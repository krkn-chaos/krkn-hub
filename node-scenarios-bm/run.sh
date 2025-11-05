#!/bin/bash
# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh
source /home/krkn/common_run.sh

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

checks

# check if SCENARIO_BASE64 is set

if [ "$SCENARIO_BASE64" == "1" ]; then
  echo "[ERROR] please set SCENARIO_BASE64 variable with a valid base64 encoded bare metal node scenario eg. podman run -e SCENARIO_BASE64=\$(base64 -w0 ~/krkn/scenarios/openshift/baremetal_node_scenarios.yml) [...] "
  exit 1
fi


# Substitute config with environment vars defined
if ! echo "$SCENARIO_BASE64" | base64 -d >> /home/krkn/kraken/scenarios/node_scenarios_bm.yaml; then
  echo -e "[ERROR] Unable to decode SCENARIO_BASE64, bad base64 format please refer to documentation"
  exit 1
fi

python3.9 /home/krkn/validate_config.py -y /home/krkn/kraken/scenarios/node_scenarios_bm.yaml \
                             -s /home/krkn/kraken/scenarios/node-scenarios-bm.json

# replace env variables

envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/node_scenarios_bm.yaml

# Run Kraken
cd /home/krkn/kraken
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  cat /home/krkn/kraken/scenarios/node_scenarios_bm.yaml
  cat /home/krkn/kraken/config/node_scenarios_bm.yaml
  extra_var="--debug True"
fi

python3.9 run_kraken.py --config=config/node_scenarios_bm.yaml $extra_var
