#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /tmp/main_env.sh
source /tmp/env.sh

source /tmp/common_run.sh
checks
config_setup

# Substitute config with environment vars defined
envsubst < /tmp/kraken/scenarios/time_scenario.yaml.template > /tmp/kraken/scenarios/time_scenario.yaml
envsubst < /tmp/kraken/config/config.yaml.template > /tmp/kraken/config/time_config.yaml

# Run Kraken
cd /tmp/kraken
python3.9 run_kraken.py --config=config/time_config.yaml
