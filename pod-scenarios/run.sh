#!/bin/bash
# Scenario-local container entry (hub docs / krkn-skills expect run.sh here).
# Dockerfile: COPY pod-scenarios/run.sh → /home/krkn/run.sh
#
#   run.sh
#     → source prep_env.sh          (shared env + template render)
#     → source prep_args_shell.sh   (build cliArgs[@])
#     → python run_kraken.py "${cliArgs[@]}"
#
# Python package route does NOT use this file: source prep_env.sh, then
# prep_args_python.BuildArgs() (see fxtKrkn).
# No -x here: tracing would expand secrets from sourced env.sh into logs.
# prep_env.sh enables set -x only when KRKN_DEBUG=True, after env is sourced.
set -euo pipefail; shopt -s inherit_errexit

typeset _runSrc="${BASH_SOURCE[0]:-$0}"
typeset scriptDir="${_runSrc%/*}"
[[ "${scriptDir}" == "${_runSrc}" ]] && scriptDir=.
[[ "${scriptDir}" == /* ]] || scriptDir="$(pwd)/${scriptDir}"

# Image: prep_* sit beside this run.sh under /home/krkn/.
# Package checkout: prep_* live in this scenario directory.
typeset prepDir="${scriptDir}"
[[ -f "${prepDir}/prep_env.sh" ]] || prepDir="${scriptDir}/pod-scenarios"

# shellcheck disable=SC1091
source "${prepDir}/prep_env.sh"
# shellcheck disable=SC1091
source "${prepDir}/prep_args_shell.sh"

cd "${KRKN_HUB__KRAKEN_DIR}"
typeset krknPy="${KRKN_PYTHON:-python3.11}"
"${krknPy}" run_kraken.py "${cliArgs[@]}"

true
