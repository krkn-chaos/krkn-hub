#!/bin/bash


# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh
source /home/krkn/common_run.sh


if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
  ls -la /home/krkn/.kube
fi




checks
config_setup

# Substitute config with environment vars defined
envsubst < /home/krkn/kraken/scenarios/app_outage.yaml.template > /home/krkn/kraken/scenarios/app_outage.yaml
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/app_outage_config.yaml

# Run Kraken
cd /home/krkn/kraken


python3.9 run_kraken.py --config=config/app_outage_config.yaml
