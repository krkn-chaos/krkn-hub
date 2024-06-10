#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh

ls -la /home/krkn/.kube

source /home/krkn/common_run.sh
checks
config_setup

# Substitute config with environment vars defined
if [[ -z "$POD_LABEL" ]]; then
  envsubst < /home/krkn/kraken/scenarios/pod_scenario_namespace.yaml.template > /home/krkn/kraken/scenarios/pod_scenario.yaml
else  
  envsubst < /home/krkn/kraken/scenarios/pod_scenario.yaml.template > /home/krkn/kraken/scenarios/pod_scenario.yaml
fi
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/pod_scenario_config.yaml

# Run Kraken
cd /home/krkn/kraken

cat /home/krkn/kraken/config/pod_scenario_config.yaml
cat /home/krkn/kraken/scenarios/pod_scenario.yaml

python3.9 run_kraken.py --config=/home/krkn/kraken/config/pod_scenario_config.yaml
