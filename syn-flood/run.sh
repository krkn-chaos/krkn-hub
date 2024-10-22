#!/bin/bash

set -ex

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/syn-flood"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh

source $ROOT_FOLDER/common_run.sh

# Substitute config with environment vars defined
envsubst < $KRAKEN_FOLDER/scenarios/syn-flood.yaml.template > $KRAKEN_FOLDER/scenarios/syn-flood.yaml
envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/syn_flood_config.yaml

cat $KRAKEN_FOLDER/config/syn_flood_config.yaml
cat $KRAKEN_FOLDER/scenarios/syn-flood.yaml

checks

# Run Kraken
cd $KRAKEN_FOLDER
python3.9 run_kraken.py --config=config/syn_flood_config.yaml


