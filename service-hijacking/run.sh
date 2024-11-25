#!/bin/bash
# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh
source /home/krkn/common_run.sh

if [[ $DEBUG == "True" ]];then
  set -ex
fi

checks

# check if SCENARIO_BASE64 is set

[ $SCENARIO_BASE64 == 1 ] && \
( echo "[ERROR] please set SCENARIO_BASE64 variable with a valid base64 encoded hijacking scenario
eg. podman run -e SCENARIO_BASE64=\$(base64 -w0 ~/krkn/scenarios/kube/service_hijacking.yaml) [...] " && \
exit 1 )


# Substitute config with environment vars defined
echo $SCENARIO_BASE64 | base64 -d >> /home/krkn/kraken/scenarios/service_hijacking.yaml || \
(echo -e "[ERROR] Unable to decode SCENARIO_BASE64, bad base64 format please refer to documentation" \
&& exit 1)

# Validate scenario against schema

python3.9 /home/krkn/validate_config.py -y /home/krkn/kraken/scenarios/service_hijacking.yaml \
                             -s /home/krkn/kraken/scenarios/service-hijacking-schema.json


# replace env variables

envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/service_hijacking_config.yaml

# Run Kraken
cd /home/krkn/kraken

if [[ $DEBUG == "True" ]];then
  cat scenarios/service_hijacking.yaml
  cat config/service_hijacking_config.yaml
fi

python3.9 run_kraken.py --config=config/service_hijacking_config.yaml
