#!/bin/bash

# Vars and respective defaults
export CERBERUS_ENABLED=${CERBERUS_ENABLED:=False}
export CERBERUS_URL=${CERBERUS_URL:=http://0.0.0.0:8080}
export KRKN_KUBE_CONFIG=${KRKN_KUBE_CONFIG:=/home/krkn/.kube/config}
export WAIT_DURATION=${WAIT_DURATION:=60}
export ITERATIONS=${ITERATIONS:=1}
export DAEMON_MODE=${DAEMON_MODE:=False}
export RETRY_WAIT=${RETRY_WAIT:=120}
export PUBLISH_KRAKEN_STATUS=${PUBLISH_KRAKEN_STATUS:=False}
export SIGNAL_ADDRESS=${SIGNAL_ADDRESS:=0.0.0.0}
export PORT=${PORT:=8081}
export SIGNAL_STATE=${SIGNAL_STATE:=RUN}
export UUID=${UUID:=""}
export PROMETHEUS_URL=${PROMETHEUS_URL:=""}
export PROMETHEUS_TOKEN=${PROMETHEUS_TOKEN:=""}
export CAPTURE_METRICS=${CAPTURE_METRICS:=False}
export ENABLE_ALERTS=${ENABLE_ALERTS:=False}
export ALERTS_PATH=${ALERTS_PATH:=config/alerts.yaml}
export METRICS_PATH=${METRICS_PATH:=config/metrics-aggregated.yaml}

export ENABLE_ES=${ENABLE_ES:=False}
export ES_SERVER=${ES_SERVER:=http://0.0.0.0}
export ES_PORT=${ES_PORT:=443}
export ES_USERNAME=${ES_USERNAME:=elastic}
export ES_PASSWORD=${ES_PASSWORD}
export ES_VERIFY_CERTS=${ES_VERIFY_CERTS:=False}
export ES_RUN_TAG=${ES_RUN_TAG:=""}

export ES_METRICS_INDEX=${ES_METRICS_INDEX:=krkn-metrics}
export ES_ALERTS_INDEX=${ES_ALERTS_INDEX:=krkn-alerts}
export ES_TELEMETRY_INDEX=${ES_TELEMETRY_INDEX:=krkn-telemetry}


export CHECK_CRITICAL_ALERTS=${CHECK_CRITICAL_ALERTS:=False}
export TELEMETRY_ENABLED=${TELEMETRY_ENABLED:=False}
export TELEMETRY_API_URL=${TELEMETRY_API_URL:=https://ulnmf9xv7j.execute-api.us-west-2.amazonaws.com/production}
export TELEMETRY_USERNAME=${TELEMETRY_USERNAME:=redhat-chaos}
export TELEMETRY_PASSWORD=${TELEMETRY_PASSWORD}
export TELEMETRY_PROMETHEUS_BACKUP=${TELEMETRY_PROMETHEUS_BACKUP:=True}
export TELEMTRY_FULL_PROMETHEUS_BACKUP=${TELEMETRY_FULL_PROMETHEUS_BACKUP:=False}
export TELEMETRY_BACKUP_THREADS=${TELEMETRY_BACKUP_THREADS:=5}
export TELEMETRY_ARCHIVE_PATH=${TELEMETRY_ARCHIVE_PATH:=/tmp}
export TELEMETRY_MAX_RETRIES=${TELEMETRY_MAX_RETRIES:=0}
export TELEMETRY_RUN_TAG=${TELEMETRY_RUN_TAG:=chaos}
export TELEMETRY_GROUP=${TELEMETRY_GROUP:=default}
export TELEMETRY_ARCHIVE_SIZE=${TELEMETRY_ARCHIVE_SIZE:=1000}
export TELEMETRY_LOGS_BACKUP=${TELEMETRY_LOGS_BACKUP:=False}
export TELEMETRY_FILTER_PATTERN=${TELEMETRY_FILTER_PATTERN:='["(\\w{3}\\s\\d{1,2}\\s\\d{2}:\\d{2}:\\d{2}\\.\\d+).+","kinit (\\d+/\\d+/\\d+\\s\\d{2}:\\d{2}:\\d{2})\\s+","(\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d+Z).+"]'}
export TELEMETRY_CLI_PATH=${TELEMETRY_CLI_PATH:=""}
export TELEMETRY_EVENTS_BACKUP=${TELEMETRY_EVENTS_BACKUP:=True}

# Set KUBECONFIG to mounted kubeconfig
export KUBECONFIG=${KRKN_KUBE_CONFIG}
export KRKN_DEBUG=${KRKN_DEBUG:="False"}

# Health check configuration
export HEALTH_CHECK_INTERVAL=${HEALTH_CHECK_INTERVAL:=2}
export HEALTH_CHECK_URL=${HEALTH_CHECK_URL:=""}
export HEALTH_CHECK_BEARER_TOKEN=${HEALTH_CHECK_BEARER_TOKEN:=""}
export HEALTH_CHECK_AUTH=${HEALTH_CHECK_AUTH:=""}
export HEALTH_CHECK_EXIT_ON_FAILURE=${HEALTH_CHECK_EXIT_ON_FAILURE:=""}
export HEALTH_CHECK_VERIFY=${HEALTH_CHECK_VERIFY:=False}


# KubeVirt Continuous check configuration
export KUBE_VIRT_CHECK_INTERVAL=${KUBE_VIRT_CHECK_INTERVAL:=2}
export KUBE_VIRT_NAMESPACE=${KUBE_VIRT_NAMESPACE:=""}
export KUBE_VIRT_NAME=${KUBE_VIRT_NAME:=""}
export KUBE_VIRT_LABEL_SELECTOR=${KUBE_VIRT_LABEL_SELECTOR:=""}
export KUBE_VIRT_FAILURES=${KUBE_VIRT_FAILURES:=False}
export KUBE_VIRT_DISCONNECTED=${KUBE_VIRT_DISCONNECTED:=False}
export KUBE_VIRT_SSH_NODE=${KUBE_VIRT_SSH_NODE:""}
export KUBE_VIRT_NODE_NAME=${KUBE_VIRT_NODE_NAME:""}                                     # Filter only VMI's running a specific node name
export KUBE_VIRT_EXIT_ON_FAIL=${KUBE_VIRT_EXIT_ON_FAIL:False}

# resiliency score
# The booleans accept the same values krknctl validates them against (Go's
# strconv.ParseBool), because krknctl passes flag values through verbatim.
export RESILIENCY_SCORE=${RESILIENCY_SCORE:=False}
export DISABLE_RESILIENCY_SCORE=${DISABLE_RESILIENCY_SCORE:=False}
export RESILIENCY_RUN_MODE=${RESILIENCY_RUN_MODE,,}
export RESILIENCY_RUN_MODE=${RESILIENCY_RUN_MODE:="standalone"}
export RESILIENCY_RUN_MODE=$([[ "${RESILIENCY_SCORE,,}" =~ ^(true|t|1)$ ]] && echo "detailed" || echo "$RESILIENCY_RUN_MODE")
export RESILIENCY_RUN_MODE=$([[ "${DISABLE_RESILIENCY_SCORE,,}" =~ ^(true|t|1)$ ]] && echo "disabled" || echo "$RESILIENCY_RUN_MODE")
export RESILIENCY_FILE=${RESILIENCY_FILE:=$ALERTS_PATH}

# chaos triggers (optional, backward compatible when TRIGGER_COMMAND is empty)
export TRIGGER_COMMAND=${TRIGGER_COMMAND:=""}
export TRIGGER_EXPECTED_RC=${TRIGGER_EXPECTED_RC:="0"}
export TRIGGER_HTTP_URL=${TRIGGER_HTTP_URL:=""}
export TRIGGER_HTTP_METHOD=${TRIGGER_HTTP_METHOD:="GET"}
export TRIGGER_HTTP_EXPECTED_STATUS=${TRIGGER_HTTP_EXPECTED_STATUS:="200"}
export TRIGGER_HTTP_BEARER_TOKEN=${TRIGGER_HTTP_BEARER_TOKEN:=""}
export TRIGGER_HTTP_BODY_CONTAINS=${TRIGGER_HTTP_BODY_CONTAINS:=""}
export TRIGGERS_MODE=${TRIGGERS_MODE:="all_of"}
export TRIGGERS_TIMEOUT=${TRIGGERS_TIMEOUT:="300"}
export TRIGGERS_INTERVAL=${TRIGGERS_INTERVAL:="5"}
export TRIGGERS_ON_TIMEOUT=${TRIGGERS_ON_TIMEOUT:="skip"}

# centralized config template block used by envsubst in config.yaml.template
export TRIGGERS_BLOCK=""

build_triggers_block() {
  local block=""
  block+="triggers:\n"
  block+="  mode: \"$TRIGGERS_MODE\"\n"
  block+="  timeout: $TRIGGERS_TIMEOUT\n"
  block+="  interval: $TRIGGERS_INTERVAL\n"
  block+="  on_timeout: \"$TRIGGERS_ON_TIMEOUT\"\n"
  block+="  conditions:\n"

  if [[ -n "$TRIGGER_COMMAND" ]]; then
    local indented
    indented=$(printf '%s\n' "$TRIGGER_COMMAND" | sed 's/^/        /')
    block+="    - type: command\n"
    block+="      inline: |-\n"
    block+="$indented\n"
    block+="      expected_rc: $TRIGGER_EXPECTED_RC\n"
  fi

  if [[ -n "$TRIGGER_HTTP_URL" ]]; then
    block+="    - type: http\n"
    block+="      url: \"$TRIGGER_HTTP_URL\"\n"
    block+="      method: \"$TRIGGER_HTTP_METHOD\"\n"
    block+="      expected_status: $TRIGGER_HTTP_EXPECTED_STATUS\n"
    [[ -n "$TRIGGER_HTTP_BEARER_TOKEN" ]] && block+="      bearer_token: \"$TRIGGER_HTTP_BEARER_TOKEN\"\n"
    [[ -n "$TRIGGER_HTTP_BODY_CONTAINS" ]] && block+="      body_contains: \"$TRIGGER_HTTP_BODY_CONTAINS\"\n"
  fi

  printf '%b' "$block"
}

if [[ -n "$TRIGGER_COMMAND" ]] || [[ -n "$TRIGGER_HTTP_URL" ]]; then
  export TRIGGERS_BLOCK="$(build_triggers_block)"
fi
