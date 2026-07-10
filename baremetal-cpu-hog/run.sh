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

# Generate scenario YAML
SCENARIO_FILE_PATH="$KRAKEN_FOLDER/$SCENARIO_FILE"
{
  echo "hog-type: cpu"
  echo "targets:"
  IFS=',' read -ra TARGET_ARRAY <<< "$TARGETS"
  for target in "${TARGET_ARRAY[@]}"; do
    target=$(echo "$target" | xargs)
    if [[ -n "$target" ]]; then
      validate_input "TARGET" "$target" '^[a-zA-Z0-9._:-]+$'
      echo "  - ${target}"
    fi
  done
  echo "ssh_user: ${SSH_USER}"
  echo "ssh_private_key: ${SSH_PRIVATE_KEY}"
  echo "ssh_port: ${SSH_PORT:-22}"
  echo "node-selector: \"\""
  echo "duration: ${TOTAL_CHAOS_DURATION}"
  echo "workers: ${NODE_CPU_CORE}"
  echo "cpu-load-percentage: ${NODE_CPU_PERCENTAGE}"
} > "$SCENARIO_FILE_PATH"

# Generate standalone config
cat > $KRAKEN_FOLDER/config/baremetal-cpu-hog-config.yaml <<EOF
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
  cat $KRAKEN_FOLDER/config/baremetal-cpu-hog-config.yaml
fi

# Run Kraken
cd $KRAKEN_FOLDER
extra_var=""
if [[ $KRKN_DEBUG == "True" ]]; then
  extra_var="--debug True"
fi

python3.11 run_kraken.py --config=config/baremetal-cpu-hog-config.yaml $extra_var
