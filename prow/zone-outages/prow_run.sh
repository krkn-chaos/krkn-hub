#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh
source common_run.sh
source zone-outages/env.sh
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
envsubst < zone-outages/zone_outage_scenario.yaml.template > /tmp/zone_outage.yaml
envsubst < config.yaml.template > /tmp/zone_config.yaml

export SCENARIO_FILE=$krkn_loc/scenarios/zone_outage.yaml

# Run Kraken
cat /tmp/zone_outage.yaml
cat /tmp/zone_config.yaml
python3.9 /root/kraken/run_kraken.py --config=/tmp/zone_config.yaml
