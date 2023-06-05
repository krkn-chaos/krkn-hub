#!/bin/bash

set -ex

ROOT_FOLDER="/root"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/arcaflow/io-hog"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh

source $ROOT_FOLDER/common_run.sh

setup_arcaflow_env "$SCENARIO_FOLDER"
envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/io_config.yaml

checks
config_setup

# Substitute config with environment vars defined

# Run Kraken
cd $KRAKEN_FOLDER

cat config/io_config.yaml

cat scenarios/arcaflow/io-hog/input.yaml

python3 run_kraken.py --config=config/io_config.yaml
