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

# Substitute config with environment vars defined
envsubst < cerberus/cerberus.yaml.template > cerberus/config.yaml

cat cerberus/config.yaml

python3 $crb_loc/start_cerberus.py --config=cerberus/config.yaml