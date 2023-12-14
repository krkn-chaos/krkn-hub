#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh
source common_run.sh
source zone-outages/env.sh
checks

export KUBECONFIG=$KRKN_KUBE_CONFIG

# cluster version
echo "Printing cluster version"
oc version

# Substitute config with environment vars defined
envsubst < zone-outages/zone_outage_scenario.yaml.template > /tmp/zone_outage.yaml
envsubst < config.yaml.template > /tmp/zone_config.yaml

export SCENARIO_FILE=$krkn_loc/scenarios/zone_outage.yaml

# Run Kraken
cat /tmp/zone_outage.yaml
cat /tmp/zone_config.yaml
python3.9 /root/kraken/run_kraken.py --config=/tmp/zone_config.yaml
