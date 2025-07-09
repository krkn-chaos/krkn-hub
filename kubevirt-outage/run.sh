#!/bin/bash

# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh
source /home/krkn/common_run.sh

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi


checks

# Substitute config with environment vars defined
envsubst < /home/krkn/kraken/scenarios/kubevirt_scenario.yaml.template > /home/krkn/kraken/scenarios/kubevirt_scenario.yaml
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/kubevirt_scenario_config.yaml

# Run Kraken
cd /home/krkn/kraken

if [[ $KRKN_DEBUG == "True" ]];then
  cat config/kubevirt_scenario_config.yaml
  cat scenarios/kubevirt_scenario.yaml
fi



python3.9 run_kraken.py --config=config/kubevirt_scenario_config.yaml
