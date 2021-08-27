#!/bin/bash

set -ex

# Source env.sh to read all the vars
source /root/env.sh

# Logging format
log() {
  echo -e "\033[1m$(date "+%d-%m-%YT%H:%M:%S") ${@}\033[0m"
}


# Check if oc is installed
log "Checking if OpenShift client is installed"
which oc &>/dev/null
if [[ $? != 0 ]]; then
  log "Looks like OpenShift client is not installed, please install before continuing"
  log "Exiting"
  exit 1
fi

# Check if kubectl is installed
log "Checking if kubernetes client is installed"
which kubectl &>/dev/null
if [[ $? != 0 ]]; then
  log "Looks like Kubernetes client is not installed, please install before continuing"
  log "Exiting"
  exit 1
fi

# Check if cluster exists and print the clusterversion under test
kubectl get clusterversion
if [[ $? -ne 0 ]]; then
  log "Unable to connect to the cluster, please check if it's up and make sure the KUBECONFIG is set correctly"
  exit 1
fi

# Substitute config with environment vars defined
envsubst < /root/cerberus/config/cerberus.yaml.template > /root/cerberus/config/config.yaml

# Run cerberus
cd /root/cerberus
python3 start_cerberus.py --config=config/config.yaml
