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

source namespace-scenarios/env.sh

krkn_loc=/root/kraken

# Substitute config with environment vars defined
envsubst < namespace-scenarios/namespace_scenario.yaml.template > namespace-scenarios/namespace_scenario.yaml
envsubst < config.yaml.template > namespace_config.yaml
export SCENARIO_FILE="- namespace-scenarios/namespace_scenario.yaml"

# Run Kraken
cat namespace_config.yaml
cat namespace-scenarios/namespace_scenario.yaml
python3.9 $krkn_loc/run_kraken.py --config=namespace_config.yaml
