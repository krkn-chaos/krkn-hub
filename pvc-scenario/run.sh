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
envsubst < /home/krkn/kraken/scenarios/pvc_scenario.yaml.template > /home/krkn/kraken/scenarios/pvc_scenario.yaml
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/config.yaml

# Run Kraken
cd /home/krkn/kraken


python3.9 run_kraken.py --config config/config.yaml
