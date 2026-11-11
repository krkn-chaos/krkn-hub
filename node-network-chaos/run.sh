#!/bin/bash
set -eo pipefail

ROOT_FOLDER="${ROOT_FOLDER:-/home/krkn}"
KRAKEN_FOLDER="${KRAKEN_FOLDER:-$ROOT_FOLDER/kraken}"

source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/main_env.sh"
source "$ROOT_FOLDER/common_run.sh"

SCENARIO_PATH="$(resolve_scenario_path "$SCENARIO_FILE" "$KRAKEN_FOLDER")"
CONFIG_FILE="$KRAKEN_FOLDER/config/node-network-chaos-config.yaml"

if [[ "$KRKN_DEBUG" == "True" ]]; then
  set -x
fi

if [[ "${TRAFFIC_TYPE,,}" == *ingress* ]]; then
  export INGRESS=true
else
  export INGRESS=false
fi
if [[ "${TRAFFIC_TYPE,,}" == *egress* ]]; then
  export EGRESS=true
else
  export EGRESS=false
fi

envsubst < "$KRAKEN_FOLDER/scenarios/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_PATH"

export SCENARIO_TYPE="network_chaos_ng_scenarios"
envsubst < "$KRAKEN_FOLDER/config/$CONFIG_FILE_TEMPLATE" > "$CONFIG_FILE"

checks

cd "$KRAKEN_FOLDER"
extra_var=""
if [[ "$KRKN_DEBUG" == "True" ]]; then
  cat "$SCENARIO_PATH" "$CONFIG_FILE"
  extra_var="--debug True"
fi

exec python3.11 run_kraken.py --config="$CONFIG_FILE" $extra_var
