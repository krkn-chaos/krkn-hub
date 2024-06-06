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
if [[ -z "$POD_LABEL" ]]; then
  envsubst < /tmp/kraken/scenarios/pod_scenario_namespace.yaml.template > /tmp/kraken/scenarios/pod_scenario.yaml
else  
  envsubst < /tmp/kraken/scenarios/pod_scenario.yaml.template > /tmp/kraken/scenarios/pod_scenario.yaml
fi
envsubst < /tmp/kraken/config/config.yaml.template > /tmp/kraken/config/pod_scenario_config.yaml

# Run Kraken
cd /tmp/kraken

cat /tmp/kraken/config/pod_scenario_config.yaml
cat /tmp/kraken/scenarios/pod_scenario.yaml

python3.9 run_kraken.py --config=/tmp/kraken/config/pod_scenario_config.yaml
