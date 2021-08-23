#!/bin/bash

# Vars and respective defaults
export KUBECONFIG=${KUBECONFIG:="/root/.kube/config"}
export SHUTDOWN_DURATION=${SHUTDOWN_DURATION:=1200} 
export CLOUD_TYPE=${CLOUD_TYPE:="aws"}
export TIMEOUT=${TIMEOUT:=180}
export CERBERUS_ENABLED=${CERBERUS_ENABLED:=False}
export CERBERUS_URL=${CERBERUS_URL:=http://0.0.0.0:8080}
export WAIT_DURATION=${WAIT_DURATION:=60}
export ITERATIONS=${ITERATIONS:=1}
export DAEMON_MODE=${DAEMON_MODE:=False}
