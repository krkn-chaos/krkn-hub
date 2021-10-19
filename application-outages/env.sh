#!/bin/bash

# Vars and respective defaults
export KUBECONFIG=${KUBECONFIG:="/root/.kube/config"}
export DURATION=${DURATION:=600}
export NAMESAPCE=${NAMESPACE}
export POD_SELECTOR=${POD_SELECTOR:={}}
export BLOCK_TRAFFIC_TYPE=${BLOCK_TRAFFIC_TYPE:=[Ingress, Egress]}
export CERBERUS_ENABLED=${CERBERUS_ENABLED:=False}
export CERBERUS_URL=${CERBERUS_URL:=http://0.0.0.0:8080}
export WAIT_DURATION=${WAIT_DURATION:=60}
export ITERATIONS=${ITERATIONS:=1}
export DAEMON_MODE=${DAEMON_MODE:=False}
