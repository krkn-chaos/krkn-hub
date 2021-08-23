#!/bin/bash

# Vars and respective defaults
export KUBECONFIG=${KUBECONFIG:="/root/.kube/config"}
export CLOUD_TYPE=${CLOUD_TYPE:="aws"}
export DURATION=${DURATION:=600}
export VPC_ID=${VPC_ID:=""}
export SUBNET_ID=${SUBNET_ID:=""}
export CERBERUS_ENABLED=${CERBERUS_ENABLED:=False}
export CERBERUS_URL=${CERBERUS_URL:=http://0.0.0.0:8080}
export WAIT_DURATION=${WAIT_DURATION:=60}
export ITERATIONS=${ITERATIONS:=1}
export DAEMON_MODE=${DAEMON_MODE:=False}
