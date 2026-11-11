#!/bin/bash
ROOT_FOLDER="${ROOT_FOLDER:-/home/krkn}"
KRAKEN_FOLDER="${KRAKEN_FOLDER:-$ROOT_FOLDER/kraken}"
# Source env.sh to read all the vars
source "$ROOT_FOLDER/main_env.sh"
source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/common_run.sh"
SCENARIO_PATH="$(resolve_scenario_path "$SCENARIO_FILE" "$KRAKEN_FOLDER")"

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

checks

# check if SCENARIO_BASE64 is set

if [ "$SCENARIO_BASE64" == "1" ]; then
  echo "[ERROR] please set SCENARIO_BASE64 variable with a valid base64 encoded bare metal node scenario eg. podman run -e SCENARIO_BASE64=\$(base64 -w0 ~/krkn/scenarios/openshift/baremetal_node_scenarios.yml) [...] "
  exit 1
fi


# Substitute config with environment vars defined
if ! echo "$SCENARIO_BASE64" | base64 -d >> "$SCENARIO_PATH"; then
  echo -e "[ERROR] Unable to decode SCENARIO_BASE64, bad base64 format please refer to documentation"
  exit 1
fi

python3.11 "$ROOT_FOLDER/validate_config.py" -y "$SCENARIO_PATH" \
                             -s "$KRAKEN_FOLDER/scenarios/node-scenarios-bm.json"

# replace env variables

envsubst < "$KRAKEN_FOLDER/config/$CONFIG_FILE_TEMPLATE" > "$KRAKEN_FOLDER/config/node_scenarios_bm.yaml"

# Run Kraken
cd "$KRAKEN_FOLDER"
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  cat "$SCENARIO_PATH"
  cat "$KRAKEN_FOLDER/config/node_scenarios_bm.yaml"
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config=config/node_scenarios_bm.yaml $extra_var
