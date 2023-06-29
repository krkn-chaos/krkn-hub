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
envsubst < /root/kraken/scenarios/pvc_scenario.yaml.template > /root/kraken/scenarios/pvc_scenario.yaml
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/config.yaml

# Run Kraken
cd /root/kraken


python3.9 run_kraken.py --config config/config.yaml
