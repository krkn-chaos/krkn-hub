#!/bin/bash

# Vars and respective defaults
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="180"}
export IO_BLOCK_SIZE=${IO_BLOCK_SIZE:="1m"}
export IO_WORKERS=${IO_WORKERS:=""}
export IO_WRITE_BYTES=${IO_WRITE_BYTES:="10m"}
export NAMESPACE=${NAMESPACE:="default"}
export NODE_SELECTOR=${NODE_SELECTOR:=""}
export NODE_NAME=${NODE_NAME:=""}
export TAINTS=${TAINTS:="[]"}
export NUMBER_OF_NODES=${NUMBER_OF_NODES:=""}
export NODE_MOUNT_PATH=${NODE_MOUNT_PATH:="/root"}
export IMAGE=${IMAGE:="quay.io/krkn-chaos/krkn-hog"}
export SCENARIO_TYPE=${SCENARIO_TYPE:=hog_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/kube/io-hog.yml}
