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

# Substitute config with environment vars defined
envsubst < cerberus/cerberus.yaml.template > cerberus_config.yaml

cat cerberus_config.yaml

python3 $crb_loc/start_cerberus.py --config=cerberus_config.yaml