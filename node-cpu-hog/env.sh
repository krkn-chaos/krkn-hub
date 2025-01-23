#!/bin/bash

# Vars and respective defaults
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="60"}
export NODE_CPU_CORE=${NODE_CPU_CORE:=""}
export NODE_CPU_PERCENTAGE=${NODE_CPU_PERCENTAGE:="50"}
export NAMESPACE=${NAMESPACE:="default"}
export NODE_SELECTOR=${NODE_SELECTOR:=""}

export SCENARIO_TYPE=${SCENARIO_TYPE:=hog_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/kube/cpu-hog.yml}

