#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh

source /home/krkn/common_run.sh
checks
config_setup

# Substitute config with environment vars defined
envsubst < /home/krkn/kraken/scenarios/container_scenario.yaml.template > /home/krkn/kraken/scenarios/container_scenario.yaml
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/container_scenario_config.yaml

# Run Kraken
cd /home/krkn/kraken

cat config/container_scenario_config.yaml

cat scenarios/container_scenario.yaml


python3.9 run_kraken.py --config=config/container_scenario_config.yaml
