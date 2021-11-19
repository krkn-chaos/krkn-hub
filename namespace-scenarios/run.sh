#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /root/main_env.sh
source /root/env.sh

source /root/common_run.sh
checks
config_setup

# Substitute config with environment vars defined
envsubst < /root/kraken/scenarios/namespace_scenario.yaml.template > /root/kraken/scenarios/namespace_scenario.yaml
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/namespace_config.yaml

# Run Kraken
cd /root/kraken

cat scenarios/namespace_scenario.yaml
cat config/namespace_config.yaml

python3 run_kraken.py --config=config/namespace_config.yaml
