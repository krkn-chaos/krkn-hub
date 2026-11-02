#!/bin/bash
# Container/shell argv builder — sourced only by run.sh after prep_env.sh.
# Must stay in sync with prep_args_python.BuildArgs() -> list[str].
# No -x: argv prep must not re-enable tracing over secrets still in the environment.
# Sourced file: save/restore caller's shell options (do not leak set/shopt changes).
typeset __shOpt="$(shopt -po; shopt -p)"
set -euo pipefail; shopt -s inherit_errexit

if [[ -z "${KRKN_HUB__CONFIG_ARG:-}" ]]; then
  echo "KRKN_HUB__CONFIG_ARG is unset or empty; prep_env.sh must be sourced first" >&2
  eval "${__shOpt}"; unset __shOpt
  exit 1
fi

typeset -a cliArgs
cliArgs=("--config=${KRKN_HUB__CONFIG_ARG}")

if [[ "${KRKN_DEBUG:-}" == 'True' ]]; then
  cliArgs+=(--debug 'True')
fi

eval "${__shOpt}"; unset __shOpt
true
