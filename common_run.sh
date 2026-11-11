#!/bin/bash

# Convert a comma-separated value into a YAML sequence. String values are
# quoted and escaped; pass "number" to emit validated numeric values.
csv_to_yaml_sequence() {
  local csv="$1"
  local item
  local kind="${2:-string}"
  local output=""
  local -a values=()

  if [[ -n "$csv" ]]; then
    IFS=',' read -r -a values <<< "$csv"
  fi

  for item in "${values[@]}"; do
    if [[ "$kind" == "number" ]]; then
      if [[ ! "$item" =~ ^[0-9]+$ ]]; then
        return 1
      fi
      output+="${output:+, }$item"
    else
      item=${item//\\/\\\\}
      item=${item//\"/\\\"}
      item=${item//$'\n'/\\n}
      item=${item//$'\r'/\\r}
      item=${item//$'\t'/\\t}
      output+="${output:+, }\"$item\""
    fi
  done

  printf '[%s]' "$output"
}

# Validate and export a CSV value as a YAML sequence from a runner, after its
# environment files have been sourced.
export_csv_yaml_sequence() {
  local variable_name="$1"
  local csv="$2"
  local kind="${3:-string}"
  local yaml_sequence

  if ! yaml_sequence="$(csv_to_yaml_sequence "$csv" "$kind")"; then
    if [[ "$kind" == "number" ]]; then
      echo "Unable to encode ${variable_name%_YAML} as a numeric YAML sequence" >&2
    else
      echo "Unable to encode ${variable_name%_YAML} as a YAML sequence" >&2
    fi
    return 1
  fi

  printf -v "$variable_name" '%s' "$yaml_sequence"
  export "$variable_name"
}

# Logging format
log() {
  echo -e "\033[1m$(date "+%d-%m-%YT%H:%M:%S") ${*}\033[0m"
}

# Resolve relative scenario paths under the Kraken checkout while preserving
# absolute paths supplied by callers.
resolve_scenario_path() {
  case "$1" in
    /*) printf '%s\n' "$1" ;;
    *) printf '%s/%s\n' "${2%/}" "$1" ;;
  esac
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


checks() {
  check_oc
  check_kubectl
}
