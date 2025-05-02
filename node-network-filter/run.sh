#!/bin/sh

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/kube/memory-hog"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh
source $ROOT_FOLDER/common_run.sh

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

yq -i ".[0].wait_duration=$TEST_DURATION" network_filter.yml
yq -i ".[0].label_selector=\"$LABEL_SELECTOR\"" network_filter.yml
yq -i ".[0].namespace=\"$NAMESPACE\"" network_filter.yml
yq -i ".[0].instance_count=$INSTANCE_COUNT" network_filter.yml
yq -i ".[0].execution=\"$EXECUTION\"" network_filter.yml
yq -i ".[0].ingress=\"$INGRESS\"" network_filter.yml
yq -i ".[0].egress=\"$EGRESS\"" network_filter.yml

IFS=',' read -ra array <<< "$INTERFACES"

for ((i=0; i<${#array[@]}; i++)); do
  yq -i ".[0].interfaces[$i]=\"${array[$i]}\"" network_filter.yml
done

IFS=',' read -ra array <<< "$PORTS"

for ((i=0; i<${#array[@]}; i++)); do
  yq -i ".[0].ports[$i]=${array[$i]}" network_filter.yml
done

envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/network-filter-config.yaml

checks

cd $KRAKEN_FOLDER

if [[ $KRKN_DEBUG == "True" ]];then
  cat scenarios/kube/network_filter.yml
  cat config/network-filter-config.yaml
fi


python3.9 run_kraken.py --config=config/network-filter-config.yaml