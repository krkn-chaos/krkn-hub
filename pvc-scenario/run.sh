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
envsubst < /tmp/kraken/scenarios/pvc_scenario.yaml.template > /tmp/kraken/scenarios/pvc_scenario.yaml
envsubst < /tmp/kraken/config/config.yaml.template > /tmp/kraken/config/config.yaml

# Run Kraken
cd /tmp/kraken


python3.9 run_kraken.py --config config/config.yaml
