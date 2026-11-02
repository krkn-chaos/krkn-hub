#!/bin/bash
# Shared env + template render for BOTH routes (no argv here).
#
#   Container/shell:  run.sh sources this, then prep_args_shell.sh
#   Python/package:   source this first, then prep_args_python.BuildArgs()
#
# Do NOT set cliArgs / extra_var here. Do NOT cd — run.sh cds after argv prep.
# No -x until after env is sourced (see KRKN_DEBUG below) — avoids logging secrets.
set -euo pipefail; shopt -s inherit_errexit

typeset scriptDir="${BASH_SOURCE[0]%/*}"
[[ "${scriptDir}" == "${BASH_SOURCE[0]}" ]] && scriptDir=.
[[ "${scriptDir}" == /* ]] || scriptDir="$(pwd)/${scriptDir}"
typeset repoRoot="${scriptDir%/*}"

typeset e='' runDir=''
typeset -A dirLocArr=()
typeset mainEnvFile='' scenarioEnvFile='' commonRunFile=''
typeset scenarioTemplate='' cfgTemplate=''
typeset scenarioRendered='' cfgRendered=''
# Prefer KRKN_KUBE_CONFIG (env.sh canonical), then KUBECONFIG — both may be set
# by package callers; hub env.sh overwrites them with the container path.
typeset kubeconfigSave="${KRKN_KUBE_CONFIG:-${KUBECONFIG:-}}"

# Default: container layout (krkn-hub images).
# Set KRKN_HUB__IN_CONTAINER=0 for a local package / PyTest checkout layout.
# Package mode writes under an exclusive mktemp dir (0700, random suffix) so a
# git checkout stays clean and /tmp races cannot pre-create the destination.
if ((${KRKN_HUB__IN_CONTAINER:=1})); then
  dirLocArr=(
    [scenarioDirModel]=/home/krkn/kraken/scenarios
    [scenarioDirRunTm]=/home/krkn/kraken/scenarios
    [cfgDirModel]=/home/krkn/kraken/config
    [cfgDirRunTm]=/home/krkn/kraken/config
    [krakenDir]=/home/krkn/kraken
    [hubHome]=/home/krkn
  )
  mainEnvFile="${dirLocArr[hubHome]}/main_env.sh"
  scenarioEnvFile="${dirLocArr[hubHome]}/env.sh"
  commonRunFile="${dirLocArr[hubHome]}/common_run.sh"
  # Historical run.sh used an absolute --config path in the container.
  export KRKN_HUB__CONFIG_ARG=/home/krkn/kraken/config/pod_scenario_config.yaml
else
  runDir="$(mktemp -d "${TMPDIR:-/tmp}/runtime--KrknHub.XXXXXXXXXX")"
  dirLocArr=(
    [scenarioDirModel]="${scriptDir}"
    [scenarioDirRunTm]="${runDir}/scenarios"
    [cfgDirModel]="${repoRoot}"
    [cfgDirRunTm]="${runDir}/config"
    [krakenDir]="${KRKN_ROOT:-${repoRoot}/../krkn}"
    [hubHome]="${repoRoot}"
  )
  # Only create dirs we own under runDir (mktemp already mode 0700).
  mkdir -p -- "${dirLocArr[scenarioDirRunTm]}" "${dirLocArr[cfgDirRunTm]}"
  mainEnvFile="${dirLocArr[hubHome]}/env.sh"
  scenarioEnvFile="${scriptDir}/env.sh"
  commonRunFile="${dirLocArr[hubHome]}/common_run.sh"
  export KRKN_HUB__CONFIG_ARG="${dirLocArr[cfgDirRunTm]}/pod_scenario_config.yaml"
fi

cfgTemplate="${dirLocArr[cfgDirModel]}/config.yaml.template"
scenarioRendered="${dirLocArr[scenarioDirRunTm]}/pod_scenario.yaml"
cfgRendered="${dirLocArr[cfgDirRunTm]}/pod_scenario_config.yaml"

export KRKN_HUB__SCRIPT_DIR="${scriptDir}"
export KRKN_HUB__REPO_ROOT="${repoRoot}"
export KRKN_HUB__RUN_DIR="${runDir}"
export KRKN_HUB__SCENARIO_DIR="${dirLocArr[scenarioDirRunTm]}"
export KRKN_HUB__CFG_DIR="${dirLocArr[cfgDirRunTm]}"
export KRKN_HUB__KRAKEN_DIR="${dirLocArr[krakenDir]}"

# Hub env.sh uses ${VAR} without defaults for some secrets/flags; tolerate unset
# under our nounset, then re-enable.
set +u
# shellcheck disable=SC1090
source "${mainEnvFile}"
# shellcheck disable=SC1090
source "${scenarioEnvFile}"
# shellcheck disable=SC1090
source "${commonRunFile}"
set -u

# Package checkout: hub env.sh forces container kubeconfig path — restore caller.
# Prefer saved KRKN_KUBE_CONFIG over KUBECONFIG (see kubeconfigSave above).
((${KRKN_HUB__IN_CONTAINER})) || {
  export KRKN_KUBE_CONFIG="${kubeconfigSave:-${HOME}/.kube/config}"
  export KUBECONFIG="${KRKN_KUBE_CONFIG}"
}

if [[ "${KRKN_DEBUG:-}" == 'True' ]]; then
  set -x
  ((${KRKN_HUB__IN_CONTAINER})) && {
    ls -la /home/krkn/.kube 1>&2 || true
  }
fi

checks

# POD_LABEL empty → namespace-wide template; else label-based template.
# Must run after sourcing scenario env.sh (defaults POD_LABEL).
# Templates always come from scenarioDirModel (source / image tree).
[[ -z "${POD_LABEL:-}" ]] && {
  scenarioTemplate="${dirLocArr[scenarioDirModel]}/pod_scenario_namespace.yaml.template"
} || {
  scenarioTemplate="${dirLocArr[scenarioDirModel]}/pod_scenario.yaml.template"
}

# umask 077: rendered YAML may contain substituted secrets (tokens, passwords).
( umask 077; envsubst < "${scenarioTemplate}" > "${scenarioRendered}" )

# Package mode: point SCENARIO_FILE at the runtime-rendered absolute path.
((${KRKN_HUB__IN_CONTAINER})) || {
  export SCENARIO_FILE="${scenarioRendered}"
}

( umask 077; envsubst < "${cfgTemplate}" > "${cfgRendered}" )

if [[ "${KRKN_DEBUG:-}" == 'True' ]]; then
  cat "${cfgRendered}" 1>&2
  cat "${scenarioRendered}" 1>&2
fi

true
