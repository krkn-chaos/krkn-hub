#!/bin/bash

# Vars and respective defaults
export DURATION=${DURATION:=300}
export LABEL_SELECTOR=${LABEL_SELECTOR:="node-role.kubernetes.io/master"}
export NODE_NAME=${NODE_NAME:=""}
export INSTANCE_COUNT=${INSTANCE_COUNT:=1}
export INTERFACES=${INTERFACES:="[]"}
export EXECUTION=${EXECUTION:="parallel"}
export EGRESS=${EGRESS:="{bandwidth: 100mbit}"}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
export SCENARIO_TYPE=${SCENARIO_TYPE:=network_chaos}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/network_chaos.yaml}
export TRAFFIC_TYPE=${TRAFFIC_TYPE:=egress}

# Ingress vars
export TARGET_NODE_AND_INTERFACE=${TARGET_NODE_AND_INTERFACE:=""}
export NETWORK_PARAMS=${NETWORK_PARAMS:=""}
export WAIT_DURATION=${WAIT_DURATION:=300} 
