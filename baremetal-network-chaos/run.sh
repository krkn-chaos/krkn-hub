#!/bin/bash

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/standalone"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh

if [[ $KRKN_DEBUG == "True" ]]; then
  set -ex
fi

mkdir -p $SCENARIO_FOLDER

# Validate inputs to prevent injection
validate_input() {
  local name="$1" value="$2" pattern="$3"
  if [[ ! "$value" =~ $pattern ]]; then
    echo "ERROR: Invalid $name: $value" >&2
    exit 1
  fi
}

validate_input "SSH_USER" "$SSH_USER" '^[a-zA-Z0-9_.-]+$'
validate_input "INTERFACES" "$INTERFACES" '^[a-zA-Z0-9_,. -]+$'
validate_input "EXECUTION" "$EXECUTION" '^(serial|parallel)$'
if [[ -n "$LATENCY" ]]; then
  validate_input "LATENCY" "$LATENCY" '^[0-9]+[a-z]*$'
fi
if [[ -n "$LOSS" ]]; then
  validate_input "LOSS" "$LOSS" '^[0-9]+(\.[0-9]+)?%?$'
fi
if [[ -n "$BANDWIDTH" ]]; then
  validate_input "BANDWIDTH" "$BANDWIDTH" '^[0-9]+[a-z]*$'
fi

# Generate scenario YAML
SCENARIO_FILE_PATH="$KRAKEN_FOLDER/$SCENARIO_FILE"
{
  echo "network_chaos:"
  echo "  targets:"
  IFS=',' read -ra TARGET_ARRAY <<< "$TARGETS"
  for target in "${TARGET_ARRAY[@]}"; do
    target=$(echo "$target" | xargs)
    if [[ -n "$target" ]]; then
      validate_input "TARGET" "$target" '^[a-zA-Z0-9._:-]+$'
      echo "    - ${target}"
    fi
  done
  echo "  ssh_user: ${SSH_USER}"
  echo "  ssh_private_key: ${SSH_PRIVATE_KEY}"
  echo "  ssh_port: ${SSH_PORT:-22}"
  echo "  duration: ${DURATION}"
  echo "  interfaces: ${INTERFACES}"
  echo "  execution: ${EXECUTION}"
  echo "  egress:"
  if [[ -n "$LATENCY" ]]; then
    echo "    latency: ${LATENCY}"
  fi
  if [[ -n "$LOSS" ]]; then
    echo "    loss: ${LOSS}"
  fi
  if [[ -n "$BANDWIDTH" ]]; then
    echo "    bandwidth: ${BANDWIDTH}"
  fi
  # Default to latency if nothing specified
  if [[ -z "$LATENCY" && -z "$LOSS" && -z "$BANDWIDTH" ]]; then
    echo "    latency: 100ms"
  fi
} > "$SCENARIO_FILE_PATH"

# Generate standalone config
cat > $KRAKEN_FOLDER/config/baremetal-network-chaos-config.yaml <<EOF
kraken:
    execution_mode: standalone
    kubeconfig_path:
    exit_on_failure: False
    publish_kraken_status: False
    signal_state: RUN
    signal_address: 0.0.0.0
    port: 8081
    chaos_scenarios:
        - $SCENARIO_TYPE:
            - $SCENARIO_FILE

tunings:
    wait_duration: ${WAIT_DURATION:-10}
    iterations: ${ITERATIONS:-1}
    daemon_mode: False

performance_monitoring:
    prometheus_url:
    prometheus_bearer_token:
    uuid:
    enable_alerts: False
    enable_metrics: False
    alert_profile:
    metrics_profile:
    check_critical_alerts: False

cerberus:
    cerberus_enabled: False
    cerberus_url:

elastic:
    enable_elastic: False

telemetry:
    enabled: False

resiliency:
    resiliency_run_mode: disabled
EOF

if [[ $KRKN_DEBUG == "True" ]]; then
  cat $SCENARIO_FILE_PATH
  cat $KRAKEN_FOLDER/config/baremetal-network-chaos-config.yaml
fi

# Run Kraken
cd $KRAKEN_FOLDER
extra_var=""
if [[ $KRKN_DEBUG == "True" ]]; then
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config=config/baremetal-network-chaos-config.yaml $extra_var
