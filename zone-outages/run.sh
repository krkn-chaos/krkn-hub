#!/bin/bash
ROOT_FOLDER="${ROOT_FOLDER:-/home/krkn}"
KRAKEN_FOLDER="${KRAKEN_FOLDER:-$ROOT_FOLDER/kraken}"
# Source env.sh to read all the vars
source "$ROOT_FOLDER/main_env.sh"
source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/common_run.sh"
SCENARIO_PATH="$(resolve_scenario_path "$SCENARIO_FILE" "$KRAKEN_FOLDER")"
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
  extra_var="--debug True"
fi

checks

# Substitute config with environment vars defined
envsubst < "$KRAKEN_FOLDER/scenarios/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_PATH"
envsubst < "$KRAKEN_FOLDER/config/$CONFIG_FILE_TEMPLATE" > "$KRAKEN_FOLDER/config/zone_config.yaml"

# Run Kraken
cd "$KRAKEN_FOLDER"
python3.11 run_kraken.py --config=config/zone_config.yaml $extra_var
