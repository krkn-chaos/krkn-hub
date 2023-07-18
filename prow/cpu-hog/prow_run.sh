#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh

export KUBECONFIG=$KRKN_KUBE_CONFIG
krkn_loc=/root/kraken
SCENARIO_FOLDER="$krkn_loc/scenarios/arcaflow/cpu-hog"

# cluster details
echo "Printing cluster details"
oc version
cat $KRKN_KUBE_CONFIG
oc config view
echo "Printing node info"
for node in $(oc get nodes | awk 'NR!=1{print $1}'); do oc get node/$node -o yaml; done

source node-cpu-hog/env.sh
source env.sh
source common_run.sh

setup_arcaflow_env "$SCENARIO_FOLDER"
checks
config_setup

# Substitute config with environment vars defined
envsubst < node-cpu-hog/input.yaml.template> node-cpu-hog/cpu_hog_scenario.yaml
export SCENARIO_FILE="node-cpu-hog/cpu_hog_scenario.yaml"
envsubst < config.yaml.template > cpu_hog_config.yaml

# Run Kraken
cat cpu_hog_config.yaml
cat node-cpu-hog/cpu_hog_scenario.yaml
python3.9 $krkn_loc/run_kraken.py --config=cpu_hog_config.yaml
