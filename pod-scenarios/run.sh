#!/bin/bash
# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh
source /home/krkn/common_run.sh

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
  ls -la /home/krkn/.kube
fi

checks

# Substitute config with environment vars defined
if [[ -z "$POD_LABEL" ]]; then
  envsubst < /home/krkn/kraken/scenarios/pod_scenario_namespace.yaml.template > /home/krkn/kraken/scenarios/pod_scenario.yaml
else  
  envsubst < /home/krkn/kraken/scenarios/pod_scenario.yaml.template > /home/krkn/kraken/scenarios/pod_scenario.yaml
fi
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/pod_scenario_config.yaml

# Run Kraken
cd /home/krkn/kraken


if [[ $KRKN_DEBUG == "True" ]];then
  cat /home/krkn/kraken/config/pod_scenario_config.yaml
  cat /home/krkn/kraken/scenarios/pod_scenario.yaml
fi


python3.9 run_kraken.py --config=/home/krkn/kraken/config/pod_scenario_config.yaml
