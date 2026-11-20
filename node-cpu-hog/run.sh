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

envsubst < "$ROOT_FOLDER/$SCENARIO_TEMPLATE_FILE" > "$SCENARIO_PATH"

cat "$SCENARIO_PATH"
# Substitute config with environment vars defined
envsubst < "$ROOT_FOLDER/$CONFIG_FILE_TEMPLATE" > "$KRAKEN_FOLDER/config/cpu_config.yaml"

checks

# Run Kraken
cd "$KRAKEN_FOLDER"
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  cat "$SCENARIO_PATH"
  cat config/cpu_config.yaml
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config=config/cpu_config.yaml $extra_var


