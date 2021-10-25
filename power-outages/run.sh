#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /root/main_env.sh
source /root/env.sh

source /root/common_run.sh
checks

# Substitute config with environment vars defined
envsubst < /root/kraken/scenarios/shutdown_scenario.yaml.template > /root/kraken/scenarios/cluster_shut_down_scenario.yml
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/config.yaml

# Run Kraken
cd /root/kraken

cat config/config.yaml

python3 run_kraken.py --config=config/config.yaml
