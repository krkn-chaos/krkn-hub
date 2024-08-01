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
  if [[ $(kubectl api-resources  --api-group=apiserver.openshift.io --no-headers=true|wc -l) -gt 0 ]];
  then
    kubectl get clusterversion 
  else
    log "Not an OpenShift environment"
  fi  
}

# sets kubernetes distribution in krkn config if platform is kubernetes included automatically
# on all the builds to keep krkn compatible with both the platform
# called in the checks method below

set_kubernetes_platform() {
  if [[ $(kubectl api-resources  --api-group=apiserver.openshift.io --no-headers=true|wc -l) -eq 0 ]];  
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

setup_arcaflow_env(){
    # will create the arcaflow input.yaml replacing the env variables
    # and creating an input_list entry per each node selector passed as
    # NODE_SELECTORS env

    # check for yq in $PATH
    YQ=`which yq`
    [ -z $YQ ] && echo "Error: yq not found in PATH" && exit 1

    # blank the default input file
    echo > $1/input.yaml
    
    IFS=';' read -r -a SELECTORS <<< $NODE_SELECTORS
    if [[ "${#SELECTORS[@]}" > 0 ]]
    then
        for selector in "${SELECTORS[@]}"
        do
            # if the selector is in the format kubernetes.io/os= will become kubernetes.io/os=''
            [[ $selector =~ ^.+\=$ ]] && selector="$selector''"
            # if the selector is in the format kubernetes.io/os will become kubernetes.io/os=''
            [[ ! $selector =~ ^.+\=.+ ]] && selector="$selector=''"

            IFS='=' read -r -a SPLITTED_SELECTOR <<< $selector
            export SELECTOR=${SPLITTED_SELECTOR[0]}
            export SELECTOR_VALUE=${SPLITTED_SELECTOR[1]}
            export TEMPLATE=`envsubst < $1/input.yaml.template`
            $YQ e '.input_list += [env(TEMPLATE)]' -i $1/input.yaml
            
        done
    else
          export SELECTOR="none"
          export SELECTOR_VALUE="none"
          export TEMPLATE=`envsubst < $1/input.yaml.template`
          TEMPLATE=`echo "${TEMPLATE}" | yq e '.node_selector={}'`
          $YQ e '.input_list += [env(TEMPLATE)]' -i $1/input.yaml
    fi
}

