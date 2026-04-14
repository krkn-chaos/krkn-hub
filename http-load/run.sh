#!/bin/bash
ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/http-load"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh
source $ROOT_FOLDER/common_run.sh
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
  extra_var="--debug True"
fi

# Build scenario config from environment variables
python3.11 $ROOT_FOLDER/build_config_file.py --outconfig $KRAKEN_FOLDER/scenarios/http-load.yaml
envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/http_load_config.yaml

cat $KRAKEN_FOLDER/config/http_load_config.yaml
cat $KRAKEN_FOLDER/scenarios/http-load.yaml

checks

# Run Kraken
cd $KRAKEN_FOLDER
python3.11 run_kraken.py --config=config/http_load_config.yaml $extra_var
