#!/bin/bash

# Scenario variables and defaults
export VMI_NAME="${VMI_NAME:-}"
export PVC_NAME="${PVC_NAME:-}"
export POD_NAME="${POD_NAME:-}"
export NAMESPACE="${NAMESPACE:-default}"
export DEVICE_PATH="${DEVICE_PATH:-}"
export MOUNT_PATH="${MOUNT_PATH:-/mnt/krkn-data}"
export FILESYSTEM="${FILESYSTEM:-ext4}"
export FILL_PERCENTAGE="${FILL_PERCENTAGE:-50}"
export DURATION="${DURATION:-60}"
export FORMAT_DEVICE="${FORMAT_DEVICE:-false}"
export USERNAME="${USERNAME:-root}"
export IDENTITY_FILE="${IDENTITY_FILE:-}"
export SCENARIO_TYPE="${SCENARIO_TYPE:-vmi_pvc_fill_scenarios}"
export SCENARIO_FILE="${SCENARIO_FILE:-scenarios/kubevirt/vmi_pvc_fill.yaml}"
export SCENARIO_TEMPLATE_FILE=${SCENARIO_TEMPLATE_FILE:=kubevirt/vmi_pvc_fill.yaml.template}
