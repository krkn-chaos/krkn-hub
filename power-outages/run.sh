#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /tmp/main_env.sh
source /tmp/env.sh

source /tmp/common_run.sh
config_setup
checks

# Substitute config with environment vars defined
envsubst < /tmp/kraken/scenarios/shutdown_scenario.yaml.template > /tmp/kraken/scenarios/cluster_shut_down_scenario.yml
envsubst < /tmp/kraken/config/config.yaml.template > /tmp/kraken/config/shut_down_config.yaml

# Run Kraken
cd /tmp/kraken

cat config/shut_down_config.yaml

cat scenarios/cluster_shut_down_scenario.yml

python3.9 run_kraken.py --config=config/shut_down_config.yaml
