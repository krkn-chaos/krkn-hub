#!/bin/bash

# Vars and respective defaults
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="180"}
export IO_BLOCK_SIZE=${IO_BLOCK_SIZE:="1m"}
export IO_WORKERS=${IO_WORKERS:="5"}
export IO_WRITE_BYTES=${IO_WRITE_BYTES:="10m"}
export NAMESPACE=${NAMESPACE:="default"}
export NODE_SELECTORS=${NODE_SELECTORS:=""}

export SCENARIO_TYPE=${SCENARIO_TYPE:=arcaflow_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/arcaflow/io-hog/input.yaml}
