#!/bin/bash

set -ex

ls

# Source env.sh to read all the vars
source env.sh

export KUBECONFIG=$KRKN_KUBE_CONFIG

oc version 

cat $KRKN_KUBE_CONFIG

oc config view
source env.sh
source cerberus/env.sh

crb_loc=/root/cerberus

# Substitute config with environment vars defined
envsubst < cerberus/config/cerberus.yaml.template > cerberus/config/config.yaml

cat config/config.yaml

python3 $crb_loc/start_cerberus.py --config=config/config.yaml