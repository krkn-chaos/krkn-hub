#!/bin/bash

set -ex

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/arcaflow/cpu-hog"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh

source $ROOT_FOLDER/common_run.sh

setup_arcaflow_env "$SCENARIO_FOLDER"
# Substitute config with environment vars defined
envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/cpu_config.yaml
checks
config_setup

# Run Kraken
cd $KRAKEN_FOLDER

cat config/cpu_config.yaml

cat scenarios/arcaflow/cpu-hog/input.yaml

python3.9 run_kraken.py --config=config/cpu_config.yaml


