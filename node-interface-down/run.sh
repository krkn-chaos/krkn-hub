#!/bin/bash

ROOT_FOLDER="${ROOT_FOLDER:-/home/krkn}"
KRAKEN_FOLDER="${KRAKEN_FOLDER:-$ROOT_FOLDER/kraken}"
# Source env.sh to read all the vars
source "$ROOT_FOLDER/main_env.sh"
source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/common_run.sh"
SCENARIO_PATH="$(resolve_scenario_path "$SCENARIO_FILE" "$KRAKEN_FOLDER/scenarios")"
# the config template references $SCENARIO_FILE: hand it the absolute path
export SCENARIO_FILE="$SCENARIO_PATH"

export_csv_yaml_sequence INTERFACES_YAML "$INTERFACES" || exit 1
export_csv_yaml_sequence TAINTS_YAML "$TAINTS" || exit 1

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

envsubst < "$ROOT_FOLDER/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_PATH"

envsubst < "$ROOT_FOLDER/$CONFIG_FILE_TEMPLATE" > "$KRAKEN_FOLDER/config/node-interface-down-config.yaml"

checks

cd "$KRAKEN_FOLDER"
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  cat "$SCENARIO_PATH"
  cat "$KRAKEN_FOLDER/config/node-interface-down-config.yaml"
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config="$KRAKEN_FOLDER/config/node-interface-down-config.yaml" $extra_var
