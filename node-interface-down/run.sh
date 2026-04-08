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

yq -i ".[0].test_duration=$TEST_DURATION" $SCENARIO_FOLDER/node-interface-down.yml
yq -i ".[0].label_selector=\"$LABEL_SELECTOR\"" $SCENARIO_FOLDER/node-interface-down.yml
yq -i ".[0].namespace=\"$NAMESPACE\"" $SCENARIO_FOLDER/node-interface-down.yml
yq -i ".[0].instance_count=$INSTANCE_COUNT" $SCENARIO_FOLDER/node-interface-down.yml
yq -i ".[0].execution=\"$EXECUTION\"" $SCENARIO_FOLDER/node-interface-down.yml
yq -i ".[0].image=\"$IMAGE\"" $SCENARIO_FOLDER/node-interface-down.yml
yq -i ".[0].target=\"$NODE_NAME\"" $SCENARIO_FOLDER/node-interface-down.yml
yq -i ".[0].service_account=\"$SERVICE_ACCOUNT\"" $SCENARIO_FOLDER/node-interface-down.yml
yq -i ".[0].recovery_time=$RECOVERY_TIME" $SCENARIO_FOLDER/node-interface-down.yml
yq -i ".[0].wait_duration=$WAIT_DURATION" $SCENARIO_FOLDER/node-interface-down.yml

if [[ -n "$INTERFACES" ]]; then
  IFS=',' read -ra array <<< "$INTERFACES"
  for ((i=0; i<${#array[@]}; i++)); do
    yq -i ".[0].interfaces[$i]=\"${array[$i]}\"" $SCENARIO_FOLDER/node-interface-down.yml
  done
fi

if [[ -n "$TAINTS" ]]; then
  IFS=',' read -ra array <<< "$TAINTS"
  for ((i=0; i<${#array[@]}; i++)); do
    yq -i ".[0].taints[$i]=\"${array[$i]}\"" $SCENARIO_FOLDER/node-interface-down.yml
  done
fi

envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/node-interface-down-config.yaml

checks

cd $KRAKEN_FOLDER
extra_var=""
if [[ $KRKN_DEBUG == "True" ]];then
  cat $SCENARIO_FOLDER/node-interface-down.yml
  cat $KRAKEN_FOLDER/config/node-interface-down-config.yaml
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config=$KRAKEN_FOLDER/config/node-interface-down-config.yaml $extra_var
