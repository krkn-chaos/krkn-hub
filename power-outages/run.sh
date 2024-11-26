#!/bin/bash
# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh
source /home/krkn/common_run.sh

if [[ $DEBUG == "True" ]];then
  set -ex
fi

config_setup
checks

# Substitute config with environment vars defined
envsubst < /home/krkn/kraken/scenarios/shutdown_scenario.yaml.template > /home/krkn/kraken/scenarios/cluster_shut_down_scenario.yml
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/shut_down_config.yaml

# Run Kraken
cd /home/krkn/kraken

if [[ $DEBUG == "True" ]];then
  cat config/shut_down_config.yaml
  cat scenarios/cluster_shut_down_scenario.yml
fi

python3.9 run_kraken.py --config=config/shut_down_config.yaml
