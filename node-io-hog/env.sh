#!/bin/bash

# Vars and respective defaults
export BLOCK_SIZE=${BLOCK_SIZE:="4m"}
export NUMBER_OF_WORKERS=${NUMBER_OF_WORKERS:="1"}
export TOTAL_DATA_SIZE=${TOTAL_DATA_SIZE:="1g"}
export TARGET_FOLDER=${TARGET_FOLDER:="/data"}
export HOST_VOLUME_PATH=${HOST_VOLUME_PATH:="/tmp"}
export NAMESPACE=${NAMESPACE:="default"}
export NODE_SELECTORS=${NODE_SELECTORS:=""}

export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="60"}
export SCENARIO_TYPE=${SCENARIO_TYPE:=arcaflow_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/arcaflow/io-hog/input.yaml}