#!/bin/bash

set -ex

function cerberus_cleanup() {
  echo "End running cerberus scenarios"
  PID=$( ps -a | grep -E 'cerberus' | grep -v "grep" | awk '{print $1}' > pid_list.txt) 
  for p in $(cat pid_list.txt); do 
    kill -9 $p
  done
  exit 0

}
trap cerberus_cleanup SIGTERM SIGINT

export KUBECONFIG=$CERBERUS_KUBECONFIG

oc version 

# Source env.sh to read all the vars
source env.sh
source cerberus/env.sh

crb_loc=/root/cerberus

ls -la

config_loc=$(mktemp -d)

# Substitute config with environment vars defined
envsubst < cerberus/cerberus.yaml.template > $config_loc/cerberus_config.yaml

cat $config_loc/cerberus_config.yaml

python3 $crb_loc/start_cerberus.py --config=$config_loc/cerberus_config.yaml -o $config_loc/report.out