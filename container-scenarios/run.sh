#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /root/main_env.sh
source /root/env.sh

source /root/common_run.sh
checks
config_setup

# Substitute config with environment vars defined
envsubst < /root/kraken/scenarios/container_scenario.yaml.template > /root/kraken/scenarios/container_scenario.yaml
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/container_scenario_config.yaml

# Run Kraken
cd /root/kraken

cat config/container_scenario_config.yaml

cat scenarios/container_scenario.yaml


python3.9 run_kraken.py --config=config/container_scenario_config.yaml
