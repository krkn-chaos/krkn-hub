#!/bin/bash

ROOT_FOLDER="${ROOT_FOLDER:-/home/krkn}"
KRAKEN_FOLDER="${KRAKEN_FOLDER:-$ROOT_FOLDER/kraken}"
# Source env.sh to read all the vars
source "$ROOT_FOLDER/main_env.sh"
source "$ROOT_FOLDER/common_run.sh"
source "$ROOT_FOLDER/env.sh"
SCENARIO_PATH="$(resolve_scenario_path "$SCENARIO_FILE" "$KRAKEN_FOLDER")"
CONFIG_FILE="$KRAKEN_FOLDER/config/vmi-network-filter-config.yaml"


extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

envsubst < "$KRAKEN_FOLDER/scenarios/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_PATH"
envsubst < "$KRAKEN_FOLDER/config/$CONFIG_FILE_TEMPLATE" > "$CONFIG_FILE"

checks

cd "$KRAKEN_FOLDER"
if [[ $KRKN_DEBUG == "True" ]];then
  cat "$SCENARIO_PATH"
  extra_var="--debug True"
  cat "$CONFIG_FILE"
fi

python3.11 run_kraken.py --config="$CONFIG_FILE" $extra_var
