#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh

export KUBECONFIG=$KRKN_KUBE_CONFIG
# Move kraken from root dir to tmp to avoid permissions issues in prow until fixed in base image
cp -r /root/kraken /tmp/kraken
krkn_loc=/tmp/kraken
SCENARIO_FOLDER="$krkn_loc/scenarios/arcaflow/memory-hog"

# cluster version
echo "Printing cluster version"
oc version

# Copy config to kraken
cp node-memory-hog/input.yaml.template $SCENARIO_FOLDER/input.yaml.template 

source node-memory-hog/env.sh
source env.sh
source common_run.sh

setup_arcaflow_env "$SCENARIO_FOLDER"
checks

# Substitute config with environment vars defined
#envsubst < node-memory-hog/input.yaml.template> node-memory-hog/memory_hog_scenario.yaml
#export SCENARIO_FILE="node-memory-hog/memory_hog_scenario.yaml"
export SCENARIO_FILE="$SCENARIO_FOLDER/input.yaml"
envsubst < config.yaml.template > memory_hog_config.yaml

# Run Kraken
cat memory_hog_config.yaml
cat $SCENARIO_FOLDER/input.yaml
python3.9 $krkn_loc/run_kraken.py --config=memory_hog_config.yaml
