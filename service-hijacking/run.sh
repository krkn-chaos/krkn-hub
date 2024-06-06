#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /tmp/main_env.sh
source /tmp/env.sh

source /tmp/common_run.sh
checks

# check if SCENARIO_BASE64 is set

[ $SCENARIO_BASE64 == 1 ] && \
( echo "[ERROR] please set SCENARIO_BASE64 variable with a valid base64 encoded hijacking scenario
eg. podman run -e SCENARIO_BASE64=\$(base64 -w0 ~/krkn/scenarios/kube/service_hijacking.yaml) [...] " && \
exit 1 )


# Substitute config with environment vars defined
echo $SCENARIO_BASE64 | base64 -d >> /tmp/kraken/scenarios/service_hijacking.yaml || \
(echo -e "[ERROR] Unable to decode SCENARIO_BASE64, bad base64 format please refer to documentation" \
&& exit 1)

# Validate scenario against schema

python3.9 /tmp/validate_config.py -y /tmp/kraken/scenarios/service_hijacking.yaml \
                             -s /tmp/kraken/scenarios/service-hijacking-schema.json


# replace env variables

envsubst < /tmp/kraken/config/config.yaml.template > /tmp/kraken/config/service_hijacking_config.yaml

# Run Kraken
cd /tmp/kraken

cat scenarios/service_hijacking.yaml
cat config/service_hijacking_config.yaml

python3.9 run_kraken.py --config=config/service_hijacking_config.yaml
