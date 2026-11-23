#!/bin/bash
ROOT_FOLDER="${ROOT_FOLDER:-/home/krkn}"
KRAKEN_FOLDER="${KRAKEN_FOLDER:-$ROOT_FOLDER/kraken}"
# Source env.sh to read all the vars
source "$ROOT_FOLDER/main_env.sh"
source "$ROOT_FOLDER/env.sh" || exit $?
source "$ROOT_FOLDER/common_run.sh"
SCENARIO_PATH="$(resolve_scenario_path "$SCENARIO_FILE" "$KRAKEN_FOLDER/scenarios")"
# the config template references $SCENARIO_FILE: hand it the absolute path.
# SCENARIO_PATH is exported for steps that create the scenario file themselves.
export SCENARIO_FILE="$SCENARIO_PATH"
export SCENARIO_PATH

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

checks

# Substitute config with environment vars defined
envsubst < "$ROOT_FOLDER/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_PATH"
envsubst < "$ROOT_FOLDER/$CONFIG_FILE_TEMPLATE" > "$KRAKEN_FOLDER/config/storage_throttle_config.yaml"

# Run Kraken
cd "$KRAKEN_FOLDER"
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  cat config/storage_throttle_config.yaml
  cat "$SCENARIO_PATH"
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config=config/storage_throttle_config.yaml $extra_var
