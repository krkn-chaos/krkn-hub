#!/bin/bash

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/kube"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh
source $ROOT_FOLDER/common_run.sh

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

yq -i ".[0].image=\"$IMAGE\"" $SCENARIO_FOLDER/pod-network-shaping.yml
yq -i ".[0].wait_duration=\"$WAIT_DURATION\"" $SCENARIO_FOLDER/pod-network-shaping.yml
yq -i ".[0].test_duration=$TEST_DURATION" $SCENARIO_FOLDER/pod-network-shaping.yml
yq -i ".[0].label_selector=\"$POD_SELECTOR\"" $SCENARIO_FOLDER/pod-network-shaping.yml
yq -i ".[0].execution=\"$EXECUTION\"" $SCENARIO_FOLDER/pod-network-shaping.yml
yq -i ".[0].namespace=\"$NAMESPACE\"" $SCENARIO_FOLDER/pod-network-shaping.yml
yq -i ".[0].instance_count=$INSTANCE_COUNT" $SCENARIO_FOLDER/pod-network-shaping.yml
yq -i ".[0].target=\"$POD_NAME\"" $SCENARIO_FOLDER/pod-network-filter.yml
yq -i ".[0].service_account=\"$SERVICE_ACCOUNT\"" $SCENARIO_FOLDER/pod-network-shaping.yml

yq -i ".[0].latency=\"$LATENCY\"" $SCENARIO_FOLDER/pod-network-shaping.yml
yq -i ".[0].loss=\"$LOSS\"" $SCENARIO_FOLDER/pod-network-shaping.yml
yq -i ".[0].bandwidth=\"$BANDWIDTH\"" $SCENARIO_FOLDER/pod-network-shaping.yml
yq -i ".[0].network_shaping_execution=\"$NETWORK_SHAPING_EXECUTION\"" $SCENARIO_FOLDER/pod-network-shaping.yml

IFS=',' read -ra array <<< "$TAINTS"

for ((i=0; i<${#array[@]}; i++)); do
  yq -i ".[0].taints[$i]=\"${array[$i]}\"" $SCENARIO_FOLDER/pod-network-shaping.yml
done

envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/network-filter-config.yaml

checks

cd $KRAKEN_FOLDER

if [[ $KRKN_DEBUG == "True" ]];then
  cat $SCENARIO_FOLDER/pod-network-shaping.yml
  cat $KRAKEN_FOLDER/config/network-filter-config.yaml
fi


python3.9 run_kraken.py --config=$KRAKEN_FOLDER/config/network-filter-config.yaml