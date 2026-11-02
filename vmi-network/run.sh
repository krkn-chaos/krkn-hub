#!/bin/bash

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/kube"

source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh
source $ROOT_FOLDER/common_run.sh

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

yq -i ".[0].test_duration=$TEST_DURATION" $SCENARIO_FOLDER/vmi-network-chaos.yml
yq -i ".[0].label_selector=\"$LABEL_SELECTOR\"" $SCENARIO_FOLDER/vmi-network-chaos.yml
yq -i ".[0].namespace=\"$NAMESPACE\"" $SCENARIO_FOLDER/vmi-network-chaos.yml
yq -i ".[0].instance_count=$INSTANCE_COUNT" $SCENARIO_FOLDER/vmi-network-chaos.yml
yq -i ".[0].execution=\"$EXECUTION\"" $SCENARIO_FOLDER/vmi-network-chaos.yml
yq -i ".[0].ingress=$INGRESS" $SCENARIO_FOLDER/vmi-network-chaos.yml
yq -i ".[0].egress=$EGRESS" $SCENARIO_FOLDER/vmi-network-chaos.yml
yq -i ".[0].image=\"$IMAGE\"" $SCENARIO_FOLDER/vmi-network-chaos.yml
yq -i ".[0].target=\"$VMI_NAME\"" $SCENARIO_FOLDER/vmi-network-chaos.yml
yq -i ".[0].service_account=\"$SERVICE_ACCOUNT\"" $SCENARIO_FOLDER/vmi-network-chaos.yml

if [[ -n "$LATENCY" ]]; then
  yq -i ".[0].latency=\"$LATENCY\"" $SCENARIO_FOLDER/vmi-network-chaos.yml
fi

if [[ -n "$LOSS" ]]; then
  yq -i ".[0].loss=\"$LOSS\"" $SCENARIO_FOLDER/vmi-network-chaos.yml
fi

if [[ -n "$BANDWIDTH" ]]; then
  yq -i ".[0].bandwidth=\"$BANDWIDTH\"" $SCENARIO_FOLDER/vmi-network-chaos.yml
fi

IFS=',' read -ra array <<< "$INTERFACES"

for ((i=0; i<${#array[@]}; i++)); do
  yq -i ".[0].interfaces[$i]=\"${array[$i]}\"" $SCENARIO_FOLDER/vmi-network-chaos.yml
done

IFS=',' read -ra array <<< "$TAINTS"

for ((i=0; i<${#array[@]}; i++)); do
  yq -i ".[0].taints[$i]=\"${array[$i]}\"" $SCENARIO_FOLDER/vmi-network-chaos.yml
done

envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/vmi-network-chaos-config.yaml

checks

cd $KRAKEN_FOLDER
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  cat $SCENARIO_FOLDER/vmi-network-chaos.yml
  extra_var="--debug True"
  cat $KRAKEN_FOLDER/config/vmi-network-chaos-config.yaml
fi

python3.11 run_kraken.py --config=$KRAKEN_FOLDER/config/vmi-network-chaos-config.yaml $extra_var
