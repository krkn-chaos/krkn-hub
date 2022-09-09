#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /root/main_env.sh
source /root/env.sh

ls -la /root/.kube

source /root/common_run.sh
checks
config_setup

# Substitute config with environment vars defined
if [[ $TRAFFIC_TYPE == "egress" ]]; then
  envsubst < /root/kraken/scenarios/network_chaos_egress.yaml.template > /root/kraken/scenarios/network_chaos.yaml
elif [[ $TRAFFIC_TYPE == "ingress" ]]; then
  envsubst < /root/kraken/scenarios/network_chaos_ingress.yaml.template > /root/kraken/scenarios/network_chaos.yaml
  export SCENARIO_TYPE="plugin_scenarios"
else
  echo "Supported TRAFFIC_TYPE options are egress or ingress, please check"
  exit 1
fi

envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/network_chaos_config.yaml

# Run Kraken
cd /root/kraken
python3 run_kraken.py --config=config/network_chaos_config.yaml
