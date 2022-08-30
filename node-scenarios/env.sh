#!/bin/bash

# Vars and respective defaults
export ACTION=${ACTION:="node_stop_start_scenario"}
export LABEL_SELECTOR=${LABEL_SELECTOR:="node-role.kubernetes.io/worker"}
export NODE_NAME=${NODE_NAME:=""}
export INSTANCE_COUNT=${INSTANCE_COUNT:=1}
export RUNS=${RUNS:=1}
export CLOUD_TYPE=${CLOUD_TYPE:="aws"}
export TIMEOUT=${TIMEOUT:=180}
export SCENARIO_TYPE=${SCENARIO_TYPE:=node_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/node_scenario.yaml}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
export VERIFY_SESSION=${VERIFY_SESSION:="false"}
export SKIP_OPENSHIFT_CHECKS=${SKIP_OPENSHIFT_CHECKS:="false"}
