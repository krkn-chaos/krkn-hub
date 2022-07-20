#!/bin/bash

# Vars and respective defaults
export CERBERUS_KUBECONFIG=/root/.kube/config
export CERBERUS_PORT=${CERBERUS_PORT:=8080}
export CERBERUS_WATCH_NODES=${CERBERUS_WATCH_NODES:=True}
export CERBERUS_WATCH_OPERATORS=${CERBERUS_WATCH_OPERATORS:=True}
export CERBERUS_WATCH_NAMESPACES=${CERBERUS_WATCH_NAMESPACES:=[openshift-etcd, openshift-apiserver, openshift-kube-apiserver, openshift-monitoring, openshift-kube-controller-manager, openshift-machine-api, openshift-kube-scheduler, openshift-ingress, openshift-sdn]}
export CERBERUS_TIMEOUT=${CERBERUS_TIMEOUT:=3}
export CERBERUS_SLEEP=${CERBERUS_SLEEP:=3}
export CERBERUS_CORES=${CERBERUS_CORES:=1}
export CHUNK_SIZE=${CHUNK_SIZE:=100}
export CERBERUS_ITERATIONS=${CERBERUS_ITERATIONS:=5}
export CERBERUS_DAEMON_MODE=${CERBERUS_DAEMON_MODE:=True}
export INSPECT_COMPONENTS=${INSPECT_COMPONENTS:=False}