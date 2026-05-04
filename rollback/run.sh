#!/bin/bash

ROOT_FOLDER="/home/krkn"
source $ROOT_FOLDER/env.sh
source $ROOT_FOLDER/main_env.sh
[ -z $RUN_UUID ] && echo "run uuid cannot be null, exiting" && exit 1
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/config.yaml
python3.11 run_kraken.py --config config/config.yaml execute-rollback -r $RUN_UUID


