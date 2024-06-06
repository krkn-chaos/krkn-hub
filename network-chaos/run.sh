#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /tmp/main_env.sh
source /tmp/env.sh

ls -la /tmp/.kube

source /tmp/common_run.sh
checks
config_setup

# Substitute config with environment vars defined
if [[ $TRAFFIC_TYPE == "egress" ]]; then
  envsubst < /tmp/kraken/scenarios/network_chaos_egress.yaml.template > /tmp/kraken/scenarios/network_chaos.yaml
elif [[ $TRAFFIC_TYPE == "ingress" ]]; then
  envsubst < /tmp/kraken/scenarios/network_chaos_ingress.yaml.template > /tmp/kraken/scenarios/network_chaos.yaml
  export SCENARIO_TYPE="plugin_scenarios"
else
  echo "Supported TRAFFIC_TYPE options are egress or ingress, please check"
  exit 1
fi

envsubst < /tmp/kraken/config/config.yaml.template > /tmp/kraken/config/network_chaos_config.yaml

# Run Kraken
cd /tmp/kraken
python3.9 run_kraken.py --config=config/network_chaos_config.yaml
