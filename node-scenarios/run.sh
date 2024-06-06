#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /tmp/main_env.sh
source /tmp/env.sh

source /tmp/common_run.sh
checks

# Substitute config with environment vars defined
if [[ "$CLOUD_TYPE" == "vmware" || "$CLOUD_TYPE" == "ibmcloud" ]]; then
  envsubst < /tmp/kraken/scenarios/plugin_node_scenario.yaml.template > /tmp/kraken/scenarios/node_scenario.yaml
  export SCENARIO_TYPE="plugin_scenarios"
  export ACTION=${ACTION:="$CLOUD_TYPE-node-reboot"}
else
  envsubst < /tmp/kraken/scenarios/node_scenario.yaml.template > /tmp/kraken/scenarios/node_scenario.yaml
fi
envsubst < /tmp/kraken/config/config.yaml.template > /tmp/kraken/config/node_scenario_config.yaml

# Run Kraken
cd /tmp/kraken

cat config/node_scenario_config.yaml

cat scenarios/node_scenario.yaml

python3.9 run_kraken.py --config=config/node_scenario_config.yaml
