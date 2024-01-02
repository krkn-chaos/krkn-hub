#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh

export KUBECONFIG=$KRKN_KUBE_CONFIG

# cluster version
echo "Printing cluster version"
oc version

source service-disruption-scenarios/env.sh

krkn_loc=/root/kraken

# Substitute config with environment vars defined
export SCENARIO_FILE="- service-disruption-scenarios/service_disruption_scenario.yaml"
envsubst < service-disruption-scenarios/namespace_scenario.yaml.template > service-disruption-scenarios/service_disruption_scenario.yaml
envsubst < config.yaml.template > service_disruption_config.yaml

# Run Kraken
cat service_disruption_config.yaml
cat service-disruption-scenarios/service_disruption_scenario.yaml
python3.9 $krkn_loc/run_kraken.py --config=service_disruption_config.yaml
