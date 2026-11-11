#!/bin/bash
ROOT_FOLDER="${ROOT_FOLDER:-/home/krkn}"
KRAKEN_FOLDER="${KRAKEN_FOLDER:-$ROOT_FOLDER/kraken}"
# Source env.sh to read all the vars
source "$ROOT_FOLDER/main_env.sh"
source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/common_run.sh"
SCENARIO_PATH="$(resolve_scenario_path "$SCENARIO_FILE" "$KRAKEN_FOLDER")"
CONFIG_FILE="$KRAKEN_FOLDER/config/pod_network_scenario_config.yaml"

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
  ls -la "$ROOT_FOLDER/.kube"
fi

checks

# Substitute config with environment vars defined
envsubst < "$KRAKEN_FOLDER/scenarios/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_PATH"
envsubst < "$KRAKEN_FOLDER/config/$CONFIG_FILE_TEMPLATE" > "$CONFIG_FILE"

# Validate if namespace parameter is set
if [[ -z $NAMESPACE ]]; then
  echo "Requires NAMESPACE parameter to be set, please check"
  exit 1
fi

# Run Kraken
cd "$KRAKEN_FOLDER"
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  cat "$CONFIG_FILE"
  cat "$SCENARIO_PATH"
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config="$CONFIG_FILE" $extra_var
