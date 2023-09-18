#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh

export KUBECONFIG=$KRKN_KUBE_CONFIG

# cluster details
echo "Printing cluster details"
oc version
cat $KRKN_KUBE_CONFIG
oc config view
echo "Printing node info"
for node in $(oc get nodes | awk 'NR!=1{print $1}'); do oc get node/$node -o yaml; done

source time-scenarios/env.sh

krkn_loc=/root/kraken

# Substitute config with environment vars defined
envsubst < time-scenarios/time_scenario.yaml.template > time-scenarios/time_scenario.yaml
export SCENARIO_FILE="- time-scenarios/time_scenario.yaml"
envsubst < config.yaml.template > time_scenario_config.yaml

# Run Kraken
cat time_scenario_config.yaml
cat time-scenarios/time_scenario.yaml
python3.9 $krkn_loc/run_kraken.py --config=time_scenario_config.yaml
