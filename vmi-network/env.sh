export TEST_DURATION=${TOTAL_CHAOS_DURATION:="60"}
export VMI_NAME=${VMI_NAME:=""}
export LABEL_SELECTOR=${LABEL_SELECTOR:=""}
export NAMESPACE=${NAMESPACE:="default"}
export INSTANCE_COUNT=${INSTANCE_COUNT:="1"}
export EXECUTION=${EXECUTION:="parallel"}
export INGRESS=${INGRESS:="true"}
export EGRESS=${EGRESS:="true"}
export INTERFACES=${INTERFACES:=""}
export LATENCY=${LATENCY:=""}
export LOSS=${LOSS:=""}
export BANDWIDTH=${BANDWIDTH:=""}
export SCENARIO_TYPE=${SCENARIO_TYPE:=network_chaos_ng_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=vmi-network-chaos.yml}
export SCENARIO_TEMPLATE_FILE=${SCENARIO_TEMPLATE_FILE:=vmi-network-chaos.yml.template}
export IMAGE=${IMAGE:="quay.io/krkn-chaos/krkn-hub-multiarch:workload-krkn-network-chaos"}
export TAINTS=${TAINTS:=""}
export SERVICE_ACCOUNT=${SERVICE_ACCOUNT:=""}

# Derive YAML sequences from the CSV inputs above
export_csv_yaml_sequence INTERFACES_YAML "$INTERFACES" || return 1
export_csv_yaml_sequence TAINTS_YAML "$TAINTS" || return 1

# Optional network constraints: emit null when unset, quoted string when set
LATENCY_YAML=null
LOSS_YAML=null
BANDWIDTH_YAML=null
if [[ -n "$LATENCY" ]]; then LATENCY_YAML="\"$LATENCY\""; fi
if [[ -n "$LOSS" ]]; then LOSS_YAML="\"$LOSS\""; fi
if [[ -n "$BANDWIDTH" ]]; then BANDWIDTH_YAML="\"$BANDWIDTH\""; fi
export LATENCY_YAML LOSS_YAML BANDWIDTH_YAML
