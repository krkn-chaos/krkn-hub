#!/bin/bash

# Logging format
log() {
  echo -e "\033[1m$(date "+%d-%m-%YT%H:%M:%S") ${*}\033[0m"
}

# Check if oc is installed
check_oc() {
  log "Checking if OpenShift client is installed"
  if ! which oc;
  then
    log "Looks like OpenShift client is not installed, please install before continuing"
    log "Exiting"
    exit 1
  fi
}

# Check if kubectl is installed
check_kubectl() {
  log "Checking if kubernetes client is installed"
  if ! which kubectl;
  then
    log "Looks like Kubernetes client is not installed, please install before continuing"
    log "Exiting"
    exit 1
  fi
}

# Check if cluster exists and print the clusterversion under test
check_cluster_version() {
  if ! kubectl version;
  then 
    log "Unable to connect to the cluster, please check if it's up and make sure the KUBECONFIG is set correctly"
    exit 1
  fi
  kubectl get clusterversion || log "Not an OpenShift environment"
}

# sets kubernetes distribution in krkn config if platform is kubernetes included automatically
# on all the builds to keep krkn compatible with both the platform
# called in the checks method below

set_kubernetes_platform() {
  if ! kubectl get clusterversion;
  then
    yq -i '.kraken.distribution="kubernetes"' /home/krkn/kraken/config/config.yaml.template
  fi
}

checks() {
  check_oc
  check_kubectl
  check_cluster_version
  set_kubernetes_platform
}

# Config substitutions
config_setup(){
  envsubst < /home/krkn/kraken/config/kube_burner.yaml.template > /home/krkn/kraken/config/kube_burner.yaml
}


