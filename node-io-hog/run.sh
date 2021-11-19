#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /root/main_env.sh
source /root/env.sh

source /root/common_run.sh
checks
config_setup

# Substitute config with environment vars defined
envsubst < /root/kraken/scenarios/io_hog.yaml.template > /root/kraken/scenarios/io_hog.yaml
envsubst < /root/kraken/config/config.yaml.template > /root/kraken/config/io_config.yaml

# Run Kraken
cd /root/kraken

cat config/io_config.yaml

cat scenarios/io_hog.yaml

python3 run_kraken.py --config=config/io_config.yaml
