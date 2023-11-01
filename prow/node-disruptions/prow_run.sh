#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh
source common_run.sh
checks

export KUBECONFIG=$KRKN_KUBE_CONFIG

# Cluster details
echo "Printing cluster details"
oc version
cat $KRKN_KUBE_CONFIG
oc config view
echo "Printing node info"
for node in $(oc get nodes | awk 'NR!=1{print $1}'); do oc get node/$node -o yaml; done

# Move kraken from root dir to tmp to avoid permissions issues in prow until fixed in base image
cp -r /root/kraken /tmp/kraken
krkn_loc=/tmp/kraken

# Substitute config with environment vars defined
if [[ "$CLOUD_TYPE" == "vmware" || "$CLOUD_TYPE" == "ibmcloud" ]]; then
  envsubst < node-scenarios/plugin_node_scenario.yaml.template > $krkn_loc/scenarios/node_scenario.yaml
  export SCENARIO_TYPE="plugin_scenarios"
  export ACTION=${ACTION:="$CLOUD_TYPE-node-reboot"}
else
  envsubst < node-scenarios/node_scenario.yaml.template > $krkn_loc/scenarios/node_scenario.yaml
fi
export SCENARIO_FILE=$krkn_loc/scenarios/node_scenario.yaml
envsubst < config.yaml.template > node_scenario_config.yaml

# Run Kraken
cat $krkn_loc/scenarios/node_scenario.yaml
cat node_scenario_config.yaml
python3.9 $krkn_loc/run_kraken.py --config=node_scenario_config.yaml
