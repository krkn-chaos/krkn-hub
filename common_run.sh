#!/bin/bash

# Logging format
log() {
  echo -e "\033[1m$(date "+%d-%m-%YT%H:%M:%S") ${@}\033[0m"
}

# Check if oc is installed
check_oc() {
  log "Checking if OpenShift client is installed"
  which oc &>/dev/null
  if [[ $? != 0 ]]; then
    log "Looks like OpenShift client is not installed, please install before continuing"
    log "Exiting"
    exit 1
  fi
}

# Check if kubectl is installed
check_kubectl() {
  log "Checking if kubernetes client is installed"
  which kubectl &>/dev/null
  if [[ $? != 0 ]]; then
    log "Looks like Kubernetes client is not installed, please install before continuing"
    log "Exiting"
    exit 1
  fi
}

# Check if cluster exists and print the clusterversion under test
check_cluster_version() {
  kubectl get clusterversion
  if [[ $? -ne 0 ]]; then
    log "Unable to connect to the cluster, please check if it's up and make sure the KUBECONFIG is set correctly"
    exit 1
  fi
}


checks() {
  check_oc
  check_kubectl
  check_cluster_version
}