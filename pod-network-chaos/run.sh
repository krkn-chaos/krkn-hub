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
envsubst < /tmp/kraken/scenarios/pod_network_scenario.yaml.template > /tmp/kraken/scenarios/pod_network_scenario.yaml
envsubst < /tmp/kraken/config/config.yaml.template > /tmp/kraken/config/pod_network_scenario_config.yaml

# Validate if namespace parameter is set
if [[ -z $NAMESPACE ]]; then
  echo "Requires NAMASPACE parameter to be set, please check"
  exit 1
fi

# Run Kraken
cd /tmp/kraken

cat /tmp/kraken/config/pod_network_scenario_config.yaml
cat /tmp/kraken/scenarios/pod_network_scenario.yaml

python3.9 run_kraken.py --config=/tmp/kraken/config/pod_network_scenario_config.yaml
