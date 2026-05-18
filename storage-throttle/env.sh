#!/bin/bash

# Vars and respective defaults
export PVC_NAME=${PVC_NAME:=""}
export POD_NAME=${POD_NAME:=""}
export NAMESPACE=${NAMESPACE:="default"}
export MOUNT_PATH=${MOUNT_PATH:=""}
export THROTTLE_TYPE=${THROTTLE_TYPE:="bandwidth"}
export READ_IOPS=${READ_IOPS:="100"}
export WRITE_IOPS=${WRITE_IOPS:="50"}
export READ_BPS=${READ_BPS:="1Mi"}
export WRITE_BPS=${WRITE_BPS:="512Ki"}
export DURATION=${DURATION:="1m"}
export IMAGE=${IMAGE:="quay.io/krkn-chaos/krkn:tools"}
export SCENARIO_TYPE=${SCENARIO_TYPE:=storage_throttle_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/storage_throttle.yaml}
