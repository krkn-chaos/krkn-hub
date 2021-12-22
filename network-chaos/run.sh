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
envsubst < /root/kraken/scenarios/network_chaos.yaml.template > /root/kraken/scenarios/network_chaos.yaml
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/network_chaos_config.yaml

# Run Kraken
cd /root/kraken
python3 run_kraken.py --config=config/network_chaos_config.yaml
