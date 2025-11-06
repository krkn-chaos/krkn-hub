#!/bin/bash
# Source env.sh to read all the vars
source /home/krkn/main_env.sh
source /home/krkn/env.sh
source /home/krkn/common_run.sh
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
  extra_var="--debug True"
fi

checks

if [[ "$CLOUD_TYPE" == "gcp" ]]; then
# Substitute config with environment vars defined
  envsubst < /home/krkn/kraken/scenarios/zone_outage_scenario_gcp.yaml.template > /home/krkn/kraken/scenarios/zone_outage.yaml
else 
  envsubst < /home/krkn/kraken/scenarios/zone_outage_scenario.yaml.template > /home/krkn/kraken/scenarios/zone_outage.yaml
fi 
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/zone_config.yaml

# Run Kraken
cd /home/krkn/kraken
python3.9 run_kraken.py --config=config/zone_config.yaml $extra_var
