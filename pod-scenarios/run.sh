#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /root/main_env.sh
source /root/env.sh

ls -la /root/.kube

source /root/common_run.sh
checks

# Substitute config with environment vars defined
envsubst < /root/kraken/scenarios/pod_scenario.yaml.template > /root/kraken/scenarios/pod_scenario.yaml
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/pod_scenario_config.yaml

# Run Kraken
cd /root/kraken

cat /root/kraken/config/pod_scenario_config.yaml

python3 run_kraken.py --config=/root/kraken/config/pod_scenario_config.yaml
