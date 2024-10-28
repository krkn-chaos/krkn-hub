#!/bin/bash

# Vars and respective defaults
export PVC_NAME=${PVC_NAME}
export POD_NAME=${POD_NAME}
export NAMESPACE=${NAMESPACE}
export FILL_PERCENTAGE=${FILL_PERCENTAGE:="50"}
export DURATION=${DURATION:="60"}
export SCENARIO_TYPE=${SCENARIO_TYPE:=pvc_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/pvc_scenario.yaml}
export BLOCK_SIZE=${BLOCK_SIZE:="102400"}

