#!/bin/bash

ROOT_FOLDER="${ROOT_FOLDER:-/home/krkn}"
KRAKEN_FOLDER="${KRAKEN_FOLDER:-$ROOT_FOLDER/kraken}"
source "$ROOT_FOLDER/main_env.sh"
source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/common_run.sh"
SCENARIO_PATH="$(resolve_scenario_path "$SCENARIO_FILE" "$KRAKEN_FOLDER")"
CONFIG_FILE="$KRAKEN_FOLDER/config/vmi-network-filter-config.yaml"

export_csv_yaml_sequence INTERFACES_YAML "$INTERFACES" || exit 1
export_csv_yaml_sequence PORTS_YAML "$PORTS" number || exit 1
export_csv_yaml_sequence PROTOCOLS_YAML "$PROTOCOLS" || exit 1
export_csv_yaml_sequence TAINTS_YAML "$TAINTS" || exit 1

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

envsubst < "$KRAKEN_FOLDER/scenarios/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_PATH"

envsubst < "$KRAKEN_FOLDER/config/$CONFIG_FILE_TEMPLATE" > "$CONFIG_FILE"

checks

cd "$KRAKEN_FOLDER"
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  cat "$SCENARIO_PATH"
  extra_var="--debug True"
  cat "$CONFIG_FILE"
fi

python3.11 run_kraken.py --config="$CONFIG_FILE" $extra_var
