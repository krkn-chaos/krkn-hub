#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /root/main_env.sh
source /root/env.sh

source /root/common_run.sh
checks

# Substitute config with environment vars defined
envsubst < /root/cerberus/config/cerberus.yaml.template > /root/cerberus/config/config.yaml

# Run cerberus
cd /root/cerberus
python3 start_cerberus.py --config=config/config.yaml
