#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh

export KUBECONFIG=$KRKN_KUBE_CONFIG


# cluster version
echo "Printing cluster version"
oc version

source pod-scenarios/env.sh

krn_loc=/root/kraken

# Substitute config with environment vars defined
if [[ -z "$POD_LABEL" ]]; then
  envsubst < pod-scenarios/pod_scenario_namespace.yaml.template > pod-scenarios/pod_scenario.yaml
else  
  envsubst < pod-scenarios/pod_scenario.yaml.template > pod-scenarios/pod_scenario.yaml
fi
export SCENARIO_FILE=pod-scenarios/pod_scenario.yaml
envsubst < config.yaml.template > pod_scenario_config.yaml

cat pod_scenario_config.yaml
cat pod-scenarios/pod_scenario.yaml

python3.9 $krn_loc/run_kraken.py --config=pod_scenario_config.yaml
