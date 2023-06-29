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

source container-scenarios/env.sh

krkn_loc=/root/kraken

# Substitute config with environment vars defined
envsubst < container-scenarios/container_scenario.yaml.template > container-scenarios/container_scenario.yaml
export SCENARIO_FILE="- container-scenarios/container_scenario.yaml"
envsubst < config.yaml.template > container_scenario_config.yaml

# Run Kraken
cat container_scenario_config.yaml
cat container-scenarios/container_scenario.yaml
python3.9 $krkn_loc/run_kraken.py --config=container_scenario_config.yaml
