#!/bin/bash

# Vars and respective defaults
export KUBECONFIG=${KUBECONFIG:="/root/.kube/config"}
export ACTION=${ACTION:="skew_date"}
export OBJECT_TYPE=${OBJECT_TYPE:="pod"}
export LABEL_SELECTOR=${LABEL_SELECTOR:="k8s-app=etcd"}
export OBJECT_NAME=${OBJECT_NAME:=""}
export NAMESPACE=${NAMESPACE:=""}
export CERBERUS_ENABLED=${CERBERUS_ENABLED:=False}
export CERBERUS_URL=${CERBERUS_URL:=http://0.0.0.0:8080}
export WAIT_DURATION=${WAIT_DURATION:=60}
export ITERATIONS=${ITERATIONS:=1}
export DAEMON_MODE=${DAEMON_MODE:=False}
export RETRY_WAIT=${RETRY_WAIT:=120}
