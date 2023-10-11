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

source network-chaos/env.sh

krn_loc=/root/kraken

# Substitute config with environment vars defined
if [[ $TRAFFIC_TYPE == "egress" ]]; then
  envsubst < /root/kraken/scenarios/network_chaos_egress.yaml.template > /root/kraken/scenarios/network_chaos.yaml
elif [[ $TRAFFIC_TYPE == "ingress" ]]; then
  envsubst < /root/kraken/scenarios/network_chaos_ingress.yaml.template > /root/kraken/scenarios/network_chaos.yaml
  export SCENARIO_TYPE="plugin_scenarios"
else
  echo "Supported TRAFFIC_TYPE options are egress or ingress, please check"
  exit 1
fi

export SCENARIO_FILE=network-chaos/network_chaos.yaml
envsubst < config.yaml.template > network_chaos_config.yaml

cat network_chaos_config.yaml
cat network-chaos/network_chaos.yaml

python3.9 $krn_loc/run_kraken.py --config=network_chaos_config.yaml
