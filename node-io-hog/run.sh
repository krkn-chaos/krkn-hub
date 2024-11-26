#!/bin/bash

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/kube/io-hog"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh
source $ROOT_FOLDER/common_run.sh

if [[ $DEBUG == "True" ]];then
  set -ex
fi

setup_arcaflow_env "$SCENARIO_FOLDER"
# Substitute config with environment vars defined
envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/io_config.yaml
checks
config_setup

# Run Kraken
cd $KRAKEN_FOLDER

if [[ $DEBUG == "True" ]];then
  cat config/io_config.yaml
  cat scenarios/kube/io-hog/input.yaml
fi

python3.9 run_kraken.py --config=config/io_config.yaml


