#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh

export KUBECONFIG=$KRKN_KUBE_CONFIG


# Cluster details
echo "Printing cluster details"
oc version 
cat $KRKN_KUBE_CONFIG
oc config view
echo "Printing node info"
for node in $(oc get nodes | awk 'NR!=1{print $1}'); do oc get node/$node -o yaml; done

source pod-network-chaos/env.sh

krn_loc=/root/kraken

# Substitute config with environment vars defined
if [[ -z $NAMESPACE ]]; then
  echo "Requires NAMASPACE parameter to be set, please check"
  exit 1
fi
export SCENARIO_FILE=pod-network-chaos/pod_network_scenario.yaml
envsubst < pod_network_scenario.yaml.template > pod_network_scenario.yaml
envsubst < config.yaml.template > pod_network_scenario_config.yaml

cat pod_network_scenario_config.yaml
cat pod-network-chaos/pod_network_scenario.yaml

python3.9 $krn_loc/run_kraken.py --config=pod_network_scenario_config.yaml