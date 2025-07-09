#!/bin/bash

# Vars and respective defaults
export NAMESPACE=${NAMESPACE:=""}
export VM_NAME=${VM_NAME:=""}
export TIMEOUT=${TIMEOUT:=60}
export SCENARIO_TYPE=${SCENARIO_TYPE:=kubevirt_vm_outage}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/kubevirt_scenario.yaml}
