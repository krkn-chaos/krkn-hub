#!/bin/bash

# Vars and respective defaults
export MEMORY_CONSUMPTION_PERCENTAGE=${MEMORY_CONSUMPTION_PERCENTAGE:="90%"}
export NUMBER_OF_WORKERS=${NUMBER_OF_WORKERS:=1}
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="60"}
export NAMESPACE=${NAMESPACE:="default"}
export SCENARIO_TYPE=${SCENARIO_TYPE:=hog_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/kube/memory-hog.yml}
export NODE_SELECTOR=${NODE_SELECTOR:=""}