#!/bin/bash

# Vars and respective defaults
export DURATION=${DURATION:=300}
export LABEL_SELECTOR=${LABEL_SELECTOR:="node-role.kubernetes.io/master"}
export NODE_NAME=${NODE_NAME:=""}
export INSTANCE_COUNT=${INSTANCE_COUNT:=1}
export INTERFACES=${INTERFACES:="[]"}
export EXECUTION=${EXECUTION:="serial"}
export EGRESS=${EGRESS:="{bandwidth: 100mbit}"}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
export SCENARIO_TYPE=${SCENARIO_TYPE:=network_chaos}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/network_chaos.yaml}