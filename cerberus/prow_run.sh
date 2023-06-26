#!/bin/bash

set -ex

ls

export KUBECONFIG=$CERBERUS_KUBECONFIG

oc version 

cat $KUBECONFIG

oc config view

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