#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh

source /home/krkn/common_run.sh
checks

# Substitute config with environment vars defined
if [[ "$CLOUD_TYPE" == "vmware" ]]; then
  export ACTION=${ACTION:="$CLOUD_TYPE-node-reboot"}
  ## Set to True if you want to verify the vSphere client session using certificates; else False
  export VERIFY_SESSION="verify_session: $VERIFY_SESSION"
  export SKIP_OPENSHIFT_CHECKS="skip_openshift_checks: $SKIP_OPENSHIFT_CHECKS"

  export SCENARIO_TYPE="vmware_node_scenarios"
  envsubst < /home/krkn/kraken/scenarios/plugin_node_scenario.yaml.template > /home/krkn/kraken/scenarios/node_scenario.yaml
elif [[ "$CLOUD_TYPE" == "ibmcloud" ]]; then
  export ACTION=${ACTION:="$CLOUD_TYPE-node-reboot"}
  
  export SCENARIO_TYPE="ibmcloud_node_scenarios"

  # IBM doesnt have verify session
  # Invalid parameter 'verify_session', expected one of: name, runs, label_selector, timeout, instance_count, skip_openshift_checks, kubeconfig_path

  export SKIP_OPENSHIFT_CHECKS=""
  export VERIFY_SESSION=""

  envsubst < /home/krkn/kraken/scenarios/plugin_node_scenario.yaml.template > /home/krkn/kraken/scenarios/node_scenario.yaml

elif [[ "$CLOUD_TYPE" == "bm" ]]; then
    envsubst < /home/krkn/kraken/scenarios/baremetal_node_scenario.yaml.template > /home/krkn/kraken/scenarios/node_scenario.yaml  
else
  envsubst < /home/krkn/kraken/scenarios/node_scenario.yaml.template > /home/krkn/kraken/scenarios/node_scenario.yaml
fi

# Setup config
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/node_scenario_config.yaml

# Run Kraken
cd /home/krkn/kraken

cat config/node_scenario_config.yaml

cat scenarios/node_scenario.yaml

python3.9 run_kraken.py --config=config/node_scenario_config.yaml
