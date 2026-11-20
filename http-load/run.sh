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
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
  extra_var="--debug True"
fi

# Build scenario config from environment variables
python3.11 "$ROOT_FOLDER/build_config_file.py" --outconfig "$SCENARIO_PATH"
envsubst < "$ROOT_FOLDER/$CONFIG_FILE_TEMPLATE" > "$KRAKEN_FOLDER/config/http_load_config.yaml"

cat "$KRAKEN_FOLDER/config/http_load_config.yaml"
cat "$SCENARIO_PATH"

checks

# Run Kraken
cd "$KRAKEN_FOLDER"
python3.11 run_kraken.py --config=config/http_load_config.yaml $extra_var
