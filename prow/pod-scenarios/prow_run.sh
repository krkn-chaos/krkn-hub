#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source main_env.sh
source env.sh

ls -la .kube

source common_run.sh
checks
config_setup

krn_loc=../kraken

# Substitute config with environment vars defined
if [[ -z "$POD_LABEL" ]]; then
  envsubst < pod-scenarios/pod_scenario_namespace.yaml.template > $krn_loc/scenarios/pod_scenario.yaml
else  
  envsubst < pod-scenarios/pod_scenario.yaml.template > $krn_loc/scenarios/pod_scenario.yaml
fi
export SCENARIO_FILE=${SCENARIO_FILE:=$krn_loc/scenarios/pod_scenario.yaml}
envsubst < config/config.yaml.template > $krn_loc/config/pod_scenario_config.yaml

cat $krn_loc/config/pod_scenario_config.yaml
cat $krn_loc/scenarios/pod_scenario.yaml

python3 $krn_loc/run_kraken.py --config=config/pod_scenario_config.yaml
