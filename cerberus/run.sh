#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /tmp/main_env.sh
source /tmp/env.sh

source /tmp/common_run.sh
checks

# Substitute config with environment vars defined
envsubst < /tmp/cerberus/config/cerberus.yaml.template > /tmp/cerberus/config/config.yaml

# Run cerberus
cd /tmp/cerberus
python3 start_cerberus.py --config=config/config.yaml
