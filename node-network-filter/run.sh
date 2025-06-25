#!/bin/sh

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

yq -i ".[0].wait_duration=$TEST_DURATION" $SCENARIO_FOLDER/network-filter.yml
yq -i ".[0].label_selector=\"$LABEL_SELECTOR\"" $SCENARIO_FOLDER/network-filter.yml
yq -i ".[0].namespace=\"$NAMESPACE\"" $SCENARIO_FOLDER/network-filter.yml
yq -i ".[0].instance_count=$INSTANCE_COUNT" $SCENARIO_FOLDER/network-filter.yml
yq -i ".[0].execution=\"$EXECUTION\"" $SCENARIO_FOLDER/network-filter.yml
yq -i ".[0].ingress=\"$INGRESS\"" $SCENARIO_FOLDER/network-filter.yml
yq -i ".[0].egress=\"$EGRESS\"" $SCENARIO_FOLDER/network-filter.yml
yq -i ".[0].workload_image=\"$WORKLOAD_IMAGE\"" $SCENARIO_FOLDER/network-filter.yml

IFS=',' read -ra array <<< "$INTERFACES"

for ((i=0; i<${#array[@]}; i++)); do
  yq -i ".[0].interfaces[$i]=\"${array[$i]}\"" $SCENARIO_FOLDER/network-filter.yml
done

IFS=',' read -ra array <<< "$PORTS"

for ((i=0; i<${#array[@]}; i++)); do
  yq -i ".[0].ports[$i]=${array[$i]}" $SCENARIO_FOLDER/network-filter.yml
done

envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/network-filter-config.yaml

checks

cd $KRAKEN_FOLDER

if [[ $KRKN_DEBUG == "True" ]];then
  cat $SCENARIO_FOLDER/network-filter.yml
  cat $KRAKEN_FOLDER/config/network-filter-config.yaml
fi


python3.9 run_kraken.py --config=$KRAKEN_FOLDER/config/network-filter-config.yaml