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

# Substitute config with environment vars defined
if [[ $TRAFFIC_TYPE == "egress" ]]; then
  envsubst < /home/krkn/kraken/scenarios/network_chaos_egress.yaml.template > /home/krkn/kraken/scenarios/network_chaos.yaml
elif [[ $TRAFFIC_TYPE == "ingress" ]]; then
  envsubst < /home/krkn/kraken/scenarios/network_chaos_ingress.yaml.template > /home/krkn/kraken/scenarios/network_chaos.yaml
  export SCENARIO_TYPE="plugin_scenarios"
else
  echo "Supported TRAFFIC_TYPE options are egress or ingress, please check"
  exit 1
fi

envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/network_chaos_config.yaml

# Run Kraken
cd /home/krkn/kraken
python3.9 run_kraken.py --config=config/network_chaos_config.yaml
