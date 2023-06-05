#!/bin/bash

# Vars and respective defaults
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="60"}
export NODE_CPU_CORE=${NODE_CPU_CORE:="2"}
export NODE_CPU_PERCENTAGE=${NODE_CPU_PERCENTAGE:="50"}
export NAMESPACE=${NAMESPACE:="default"}
export NODE_SELECTORS=${NODE_SELECTORS:=""}

export SCENARIO_TYPE=${SCENARIO_TYPE:=arcaflow_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/arcaflow/cpu-hog/input.yaml}

