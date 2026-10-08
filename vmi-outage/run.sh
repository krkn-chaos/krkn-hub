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
envsubst < /home/krkn/kraken/scenarios/vmi_scenario.yaml.template > /home/krkn/kraken/scenarios/vmi_scenario.yaml
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/vmi_scenario_config.yaml

# Run Kraken
cd /home/krkn/kraken
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  cat config/vmi_scenario_config.yaml
  cat scenarios/vmi_scenario.yaml
  extra_var="--debug True"
fi



python3.11 run_kraken.py --config=config/vmi_scenario_config.yaml $extra_var
