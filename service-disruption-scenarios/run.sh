#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /tmp/main_env.sh
source /tmp/env.sh

source /tmp/common_run.sh
checks
config_setup

# Substitute config with environment vars defined
envsubst < /tmp/kraken/scenarios/namespace_scenario.yaml.template > /tmp/kraken/scenarios/namespace_scenario.yaml
envsubst < /tmp/kraken/config/config.yaml.template > /tmp/kraken/config/namespace_config.yaml

# Run Kraken
cd /tmp/kraken

cat scenarios/namespace_scenario.yaml
cat config/namespace_config.yaml

python3.9 run_kraken.py --config=config/namespace_config.yaml
