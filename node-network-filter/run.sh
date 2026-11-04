#!/bin/bash

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/kube"
SCENARIO_FILE="$SCENARIO_FOLDER/network-filter.yml"
CONFIG_FILE="$KRAKEN_FOLDER/config/network-filter-config.yaml"

source "$ROOT_FOLDER/main_env.sh"
source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/common_run.sh"

if [[ "$KRKN_DEBUG" == "True" ]]; then
  set -ex
fi

INTERFACES_YAML="$(python3.11 -c 'import json, os; print(json.dumps([name for name in os.environ.get("INTERFACES", "").split(",") if name]))')" || {
  echo "Unable to encode INTERFACES as a YAML sequence" >&2
  exit 1
}
export INTERFACES_YAML

envsubst < "$KRAKEN_FOLDER/scenarios/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_FILE"
envsubst < "$KRAKEN_FOLDER/config/config.yaml.template" > "$CONFIG_FILE"
checks

cd "$KRAKEN_FOLDER"
extra_var=""
if [[ "$KRKN_DEBUG" == "True" ]]; then
  cat "$SCENARIO_FILE" "$CONFIG_FILE"
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config="$CONFIG_FILE" $extra_var
