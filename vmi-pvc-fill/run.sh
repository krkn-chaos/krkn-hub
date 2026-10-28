#!/bin/bash
# Source environment variables and common setup
source /home/krkn/main_env.sh
source /home/krkn/env.sh
source /home/krkn/common_run.sh

if [[ $KRKN_DEBUG == "True" ]]; then
  set -ex
fi

checks

envsubst < /home/krkn/kraken/scenarios/kubevirt/vmi_pvc_fill.yaml.template > /home/krkn/kraken/scenarios/kubevirt/vmi_pvc_fill.yaml
envsubst < /home/krkn/kraken/config/config.yaml.template > /home/krkn/kraken/config/vmi_pvc_fill_config.yaml

cd /home/krkn/kraken
extra_var=""
if [[ $KRKN_DEBUG == "True" ]]; then
  cat scenarios/kubevirt/vmi_pvc_fill.yaml
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config=config/vmi_pvc_fill_config.yaml $extra_var
