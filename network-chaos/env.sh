#!/bin/bash

# Vars and respective defaults
export DURATION=${DURATION:=300}
export LABEL_SELECTOR=${LABEL_SELECTOR:="node-role.kubernetes.io/master"}
export NODE_NAME=${NODE_NAME:=""}
export INSTANCE_COUNT=${INSTANCE_COUNT:=1}
export INTERFACES=${INTERFACES:="[]"}
export EXECUTION=${EXECUTION:="parallel"}
export EGRESS=${EGRESS:="{bandwidth: 100mbit}"}
export SCENARIO_TYPE=${SCENARIO_TYPE:=network_chaos_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/network_chaos.yaml}
export TRAFFIC_TYPE=${TRAFFIC_TYPE:=egress}
export IMAGE=${IMAGE:="quay.io/krkn-chaos/krkn-hub-multiarch:workload-krkn-tools"}

case "$TRAFFIC_TYPE" in
  egress)
    export SCENARIO_TEMPLATE_FILE=${SCENARIO_TEMPLATE_FILE:=network_chaos_egress.yaml.template}
    ;;
  ingress)
    export SCENARIO_TEMPLATE_FILE=${SCENARIO_TEMPLATE_FILE:=network_chaos_ingress.yaml.template}
    export SCENARIO_TYPE="ingress_node_scenarios"
    ;;
  *)
    echo "Supported TRAFFIC_TYPE options are egress or ingress, please check" >&2
    return 1
    ;;
esac

# Ingress vars
export TARGET_NODE_AND_INTERFACE=${TARGET_NODE_AND_INTERFACE:=""}
export NETWORK_PARAMS=${NETWORK_PARAMS:=""}
export WAIT_DURATION=${WAIT_DURATION:=300}
