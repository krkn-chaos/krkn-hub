#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /root/main_env.sh
source /root/env.sh

source /root/common_run.sh
checks

# Substitute config with environment vars defined
envsubst < /root/kraken/scenarios/cpu_hog.yaml.template > /root/kraken/scenarios/node_hog_engine.yaml
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/cpu_config.yaml

# Run Kraken
cd /root/kraken
python3 run_kraken.py --config=config/cpu_config.yaml
