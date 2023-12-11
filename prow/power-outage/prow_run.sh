#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh
source common_run.sh
source power-outages/env.sh
checks

export KUBECONFIG=$KRKN_KUBE_CONFIG

# Cluster details
echo "Printing cluster details"
oc version
cat $KRKN_KUBE_CONFIG
oc config view
echo "Printing node info"
for node in $(oc get nodes | awk 'NR!=1{print $1}'); do oc get node/$node -o yaml; done

# Substitute config with environment vars defined
envsubst < power-outages/shutdown_scenario.yaml.template > /tmp/power_outage_scenario.yaml
export SCENARIO_FILE=/tmp/power_outage_scenario.yaml
envsubst < config.yaml.template > power_outage_config.yaml

# Run Kraken
cat /tmp/power_outage_scenario.yaml
cat power_outage_config.yaml
python3.9 /root/kraken/run_kraken.py --config=power_outage_config.yaml
