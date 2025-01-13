#!/bin/bash

set -ex

ROOT_FOLDER="/home/krkn"
KUBECONFIG_PATH="$ROOT_FOLDER/.kube/config"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh
source $ROOT_FOLDER/common_run.sh

[ ! -f "$KUBECONFIG_PATH" ] && echo "error: kubeconfig file not found in $KUBECONFIG_PATH,\
  run the recommender image with the -v\
  <PATH_TO_YOUR_LOCAL_KUBECONFIG>:/root/.kube/config:Z option" && exit 1

[ -z "$NAMESPACE" ] && echo "error: NAMESPACE not set, run the recommender \
  with the -e NAMESPACE=<namespace> option" && exit 1

[ -z "$PROMETHEUS_ENDPOINT" ] && echo "error: PROMETHEUS_ENDPOINT not set, run the recommender \
  with the -e PROMETHEUS_ENDPOINT=<prometheus_url> option" && exit 1

[ -z "$PROMETHEUS_TOKEN" ] && echo "error: PROMETHEUS_TOKEN not set, run the recommender \
  with the -e PROMETHEUS_TOKEN=<prometheus_token> option" && exit 1

[ -z "$THRESHOLD" ] && echo "error: THRESHOLD not set, run the recommender \
  with the -e THRESHOLD=<threshold, for example 0.7> option" && exit 1

[ -z "$CPU_THRESHOLD" ] && echo "error: CPU_THRESHOLD not set, run the recommender \
  with the -e CPU_THRESHOLD=<cpu_threshold, for example 0.5> option" && exit 1

[ -z "$MEMORY_THRESHOLD" ] && echo "error: MEMORY_THRESHOLD not set, run the recommender \
  with the -e MEMORY_THRESHOLD=<memory_threshold, for example 0.5> option" && exit 1

# Run Kraken
cd $KRAKEN_FOLDER


python3.9 utils/chaos_recommender/chaos_recommender.py \
-o -k $KRKN_KUBE_CONFIG \
-M $MEM_TESTS \
-G $GENERIC_TESTS \
-N $NETWORK_TESTS \
-C $CPU_TESTS \
-k $KUBECONFIG_PATH \
-n $NAMESPACE \
-p $PROMETHEUS_ENDPOINT \
-t $PROMETHEUS_TOKEN \
-s $SCRAPE_DURATION \
--threshold $THRESHOLD \
--cpu-threshold $CPU_THRESHOLD \
--mem-threshold $MEMORY_THRESHOLD \
-L $LOG_LEVEL
