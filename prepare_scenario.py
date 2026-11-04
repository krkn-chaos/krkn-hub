"""Build the config file Krkn's ``run_kraken.main`` accepts.

https://github.com/krkn-chaos/krkn/blob/main/run_kraken.py#L120

``run_kraken.py --config`` reads a finished YAML file. ``yaml.safe_load``
does not expand ``$VAR`` from the process environment, so the env files
have to be applied before that call.

Inputs:

* ``general_env``: repository ``env.sh``
* ``config_template``: repository ``config.yaml.template``
* ``scenario_env``: ``<scenario>/env.sh``
* ``scenario_template``: ``<scenario>/<name>.yaml.template``
* ``env``: caller overrides. Exported before either env file is sourced,
  so ``${VAR:=default}`` keeps the caller value.

``scenario_template`` may be a path, or ``(sourced env) -> path`` when
``run.sh`` picks the template from a variable. For example, pod-scenarios does that
with ``POD_LABEL``.

The returned ``config`` path is the value for ``--config`` / ``options.cfg``.
``scenario`` is the file that path points at. A scenario ``run.sh`` that
also runs ``yq``, decodes ``SCENARIO_BASE64``, or calls
``build_config_file.py`` still does that step itself.
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
from collections.abc import Callable, Mapping
from pathlib import Path
from typing import Any

# Source both env files, then print the exported environment as JSON.
_SOURCE_SH = """
# Source generalEnv, then scenarioEnv, and print the exports as JSON.
# generalEnv    Hub env file. Assignments are exported.
# scenarioEnv   Scenario env file. Sourced second so it overrides the hub file.
# pythonBin     Interpreter that writes the JSON to stdout.
typeset generalEnv="${1:?}"
(($#)) && shift
typeset scenarioEnv="${1:?}"
(($#)) && shift
typeset pythonBin="${1:?}"
(($#)) && shift
[ -f "${generalEnv}" ]
[ -f "${scenarioEnv}" ]
[ -x "${pythonBin}" ]
# env.sh expands optional unset passwords and assigns them.
# The dump stays in this subshell so the sourced exports are still in scope.
(
    set +xu -a
    source "${generalEnv}"
    source "${scenarioEnv}"
    "${pythonBin}" -c 'import json, os, sys
json.dump(os.environ.copy(), sys.stdout)'
)
true
"""

Template = str | os.PathLike[str] | Callable[[Mapping[str, str]], str | os.PathLike[str]]


def render_config(
    work_dir: str | os.PathLike[str],
    general_env: str | os.PathLike[str],
    config_template: str | os.PathLike[str],
    scenario_env: str | os.PathLike[str],
    scenario_template: Template,
    env: Mapping[str, str] | None = None,
) -> dict[str, Any]:
    """Fill both templates and return the config path for ``run_kraken.py``.

    The hub shares ``env.sh`` (``general_env``) and ``config.yaml.template``
    (``config_template``). Each scenario has its own ``env.sh``
    (``scenario_env``) and its own scenario config file
    (``scenario_template``).

    pod-scenarios uses:

    * ``pod-scenarios/env.sh``
    * ``pod-scenarios/pod_scenario.yaml.template`` when ``POD_LABEL`` is set
    * ``pod-scenarios/pod_scenario_namespace.yaml.template`` when
      ``POD_LABEL`` is empty
    """
    sourced = source_env(general_env, scenario_env, env)
    selected = scenario_template(sourced) if callable(scenario_template) else scenario_template
    directory = Path(work_dir)
    directory.mkdir(parents=True, exist_ok=True)
    scenario_path = directory / "scenario.yaml"
    config_path = directory / "config.yaml"
    _envsubst(selected, scenario_path, sourced)
    # ``<scenario>/env.sh`` points SCENARIO_FILE at a path inside the
    # container tree. Point it at the file just written so ``--config``
    # resolves from any working directory.
    sourced["SCENARIO_FILE"] = str(scenario_path.resolve())
    _envsubst(config_template, config_path, sourced)
    return {
        "config": str(config_path.resolve()),
        "scenario": str(scenario_path.resolve()),
        "env": sourced,
        "debug": sourced.get("KRKN_DEBUG") == "True",
    }


def source_env(
    general_env: str | os.PathLike[str],
    scenario_env: str | os.PathLike[str],
    env: Mapping[str, str] | None = None,
) -> dict[str, str]:
    """Source ``general_env`` then ``scenario_env`` and return the exports."""
    proc_env = os.environ.copy()
    proc_env.update({str(key): str(value) for key, value in dict(env or {}).items()})
    completed = subprocess.run(
        [
            "bash",
            "-o",
            "pipefail",
            "-O",
            "inherit_errexit",
            "-euxc",
            _SOURCE_SH,
            "krkn-hub-prepare-scenario",
            str(general_env),
            str(scenario_env),
            sys.executable,
        ],
        env=proc_env,
        capture_output=True,
        text=True,
        encoding="utf-8",
        check=False,
    )
    if completed.returncode != 0:
        detail = completed.stderr.strip()
        raise RuntimeError(
            "Could not source krkn-hub env.sh "
            f"(status {completed.returncode}): {detail}"
        )
    loaded = json.loads(completed.stdout)
    return {str(key): str(value) for key, value in loaded.items()}


def _envsubst(
    template: str | os.PathLike[str],
    destination: Path,
    env: Mapping[str, str],
) -> None:
    """Write ``template`` with ``$VAR`` filled from ``env``, via ``envsubst``."""
    completed = subprocess.run(
        ["envsubst"],
        input=Path(template).read_text(encoding="utf-8"),
        env=dict(env),
        capture_output=True,
        text=True,
        encoding="utf-8",
        check=False,
    )
    if completed.returncode != 0:
        detail = completed.stderr.strip()
        raise RuntimeError(
            f"envsubst failed for `{template}` "
            f"(status {completed.returncode}): {detail}"
        )
    destination.write_text(completed.stdout, encoding="utf-8")
