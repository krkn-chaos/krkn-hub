"""Pod-scenario inputs for ``prepare_scenario.render_config``.

``run.sh`` sources the hub env file and this directory's env file, then
fills one scenario template and ``config.yaml.template``. An empty
``POD_LABEL`` selects ``pod_scenario_namespace.yaml.template``. Any other
value selects ``pod_scenario.yaml.template``.

``main`` does not call ``run_kraken.py``. Pass the returned ``config``
as ``--config``.

From this directory:

    python3 -c 'import run; run.main("/tmp/krkn-pod", {"POD_LABEL": "app=api"})'
"""
from __future__ import annotations

import os
import sys
from collections.abc import Mapping
from pathlib import Path
from typing import Any

_SCENARIO_DIR = Path(__file__).resolve().parent
_HUB_ROOT = _SCENARIO_DIR.parent
if str(_HUB_ROOT) not in sys.path:
    sys.path.insert(0, str(_HUB_ROOT))

from prepare_scenario import render_config  # noqa: E402


def _template(env: Mapping[str, str]) -> Path:
    """Use the namespace template when ``POD_LABEL`` is empty."""
    name = "pod_scenario.yaml.template" if env.get("POD_LABEL") else "pod_scenario_namespace.yaml.template"
    return _SCENARIO_DIR / name


def main(
    work_dir: str | os.PathLike[str],
    env: Mapping[str, str] | None = None,
    *,
    general_env: str | os.PathLike[str] | None = None,
    config_template: str | os.PathLike[str] | None = None,
    scenario_env: str | os.PathLike[str] | None = None,
    scenario_template: str | os.PathLike[str] | None = None,
) -> dict[str, Any]:
    """Fill this scenario and return ``config`` for ``run_kraken.py --config``."""
    return render_config(
        work_dir,
        general_env or (_HUB_ROOT / "env.sh"),
        config_template or (_HUB_ROOT / "config.yaml.template"),
        scenario_env or (_SCENARIO_DIR / "env.sh"),
        scenario_template or _template,
        env,
    )
