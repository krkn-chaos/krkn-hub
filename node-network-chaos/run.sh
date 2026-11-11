#!/bin/bash

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/kube"
SCENARIO_FILE="$SCENARIO_FOLDER/node-network-chaos.yml"
CONFIG_FILE="$KRAKEN_FOLDER/config/node-network-chaos-config.yaml"

source "$ROOT_FOLDER/main_env.sh"
source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/common_run.sh"

if [[ "$KRKN_DEBUG" == "True" ]]; then
  set -ex
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

envsubst < "$KRAKEN_FOLDER/scenarios/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_FILE"

export SCENARIO_TYPE="network_chaos_ng_scenarios"
export SCENARIO_FILE
envsubst < "$KRAKEN_FOLDER/config/config.yaml.template" > "$CONFIG_FILE"

checks

cd "$KRAKEN_FOLDER"
extra_var=""
if [[ "$KRKN_DEBUG" == "True" ]]; then
  cat "$SCENARIO_FILE" "$CONFIG_FILE"
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config="$CONFIG_FILE" $extra_var
