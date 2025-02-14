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
envsubst < /home/krkn/kraken/scenarios/pod_network_scenario.yaml.template > /home/krkn/kraken/scenarios/pod_network_scenario.yaml
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/pod_network_scenario_config.yaml

# Validate if namespace parameter is set
if [[ -z $NAMESPACE ]]; then
  echo "Requires NAMESPACE parameter to be set, please check"
  exit 1
fi

# Run Kraken
cd /home/krkn/kraken

if [[ $KRKN_DEBUG == "True" ]];then
  cat /home/krkn/kraken/config/pod_network_scenario_config.yaml
  cat /home/krkn/kraken/scenarios/pod_network_scenario.yaml
fi

python3.9 run_kraken.py --config=/home/krkn/kraken/config/pod_network_scenario_config.yaml
