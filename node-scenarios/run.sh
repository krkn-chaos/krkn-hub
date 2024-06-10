#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh

source /home/krkn/common_run.sh
checks

# Substitute config with environment vars defined
if [[ "$CLOUD_TYPE" == "vmware" || "$CLOUD_TYPE" == "ibmcloud" ]]; then
  envsubst < /home/krkn/kraken/scenarios/plugin_node_scenario.yaml.template > /home/krkn/kraken/scenarios/node_scenario.yaml
  export SCENARIO_TYPE="plugin_scenarios"
  export ACTION=${ACTION:="$CLOUD_TYPE-node-reboot"}
else
  envsubst < /home/krkn/kraken/scenarios/node_scenario.yaml.template > /home/krkn/kraken/scenarios/node_scenario.yaml
fi
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/node_scenario_config.yaml

# Run Kraken
cd /home/krkn/kraken

cat config/node_scenario_config.yaml

cat scenarios/node_scenario.yaml

python3.9 run_kraken.py --config=config/node_scenario_config.yaml
