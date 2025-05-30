#!/bin/bash

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/kube/memory-hog"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh
source $ROOT_FOLDER/common_run.sh

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

envsubst < $KRAKEN_FOLDER/scenarios/kube/memory-hog.yml.template > $KRAKEN_FOLDER/scenarios/kube/memory-hog.yml
# Substitute config with environment vars defined
envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/mem-config.yaml

checks

# Run Kraken
cd $KRAKEN_FOLDER

if [[ $KRKN_DEBUG == "True" ]];then
  cat scenarios/kube/memory-hog.yml
  cat config/mem-config.yaml
fi


python3.9 run_kraken.py --config=config/mem-config.yaml
