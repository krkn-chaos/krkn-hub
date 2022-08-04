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
if [[ -z "$POD_LABEL" ]]; then
  envsubst < /root/kraken/scenarios/pod_scenario_namespace.yaml.template > /root/kraken/scenarios/pod_scenario.yaml
else  
  envsubst < /root/kraken/scenarios/pod_scenario.yaml.template > /root/kraken/scenarios/pod_scenario.yaml
fi
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/pod_scenario_config.yaml

# Run Kraken
cd /root/kraken

cat /root/kraken/config/pod_scenario_config.yaml
cat /root/kraken/scenarios/pod_scenario.yaml

python3 run_kraken.py --config=/root/kraken/config/pod_scenario_config.yaml
