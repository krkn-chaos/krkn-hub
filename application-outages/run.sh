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
envsubst < /root/kraken/scenarios/app_outage.yaml.template > /root/kraken/scenarios/app_outage.yaml
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/app_outage_config.yaml

# Run Kraken
cd /root/kraken


python3.9 run_kraken.py --config=config/app_outage_config.yaml
