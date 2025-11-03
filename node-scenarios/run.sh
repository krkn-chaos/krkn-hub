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
if [[ "$CLOUD_TYPE" == "bm" || "$CLOUD_TYPE" == "baremetal" ]]; then
    envsubst < /home/krkn/kraken/scenarios/baremetal_node_scenario.yaml.template > /home/krkn/kraken/scenarios/node_scenario.yaml  
else
  envsubst < /home/krkn/kraken/scenarios/node_scenario.yaml.template > /home/krkn/kraken/scenarios/node_scenario.yaml
fi

# Setup config
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/node_scenario_config.yaml

# Run Kraken
cd /home/krkn/kraken


if [[ $KRKN_DEBUG == "True" ]];then
  cat config/node_scenario_config.yaml
  cat scenarios/node_scenario.yaml
fi

python3.9 run_kraken.py --config=config/node_scenario_config.yaml
