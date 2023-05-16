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
envsubst < /root/kraken/scenarios/pod_network_scenario.yaml.template > /root/kraken/scenarios/pod_network_scenario.yaml
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/pod_network_scenario_config.yaml

# Validate if namespace parameter is set
if [[ -z $NAMESPACE ]]; then
  echo "Requires NAMASPACE parameter to be set, please check"
  exit 1
fi

# Run Kraken
cd /root/kraken

cat /root/kraken/config/pod_network_scenario_config.yaml
cat /root/kraken/scenarios/pod_network_scenario.yaml

python3 run_kraken.py --config=/root/kraken/config/pod_network_scenario_config.yaml
