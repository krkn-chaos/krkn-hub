#!/bin/bash

# Vars and respective defaults
export TARGETS=${TARGETS:=""}
export SSH_USER=${SSH_USER:="root"}
export SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY:="/home/krkn/.ssh/id_rsa"}
export SSH_PORT=${SSH_PORT:="22"}
export NUMBER_OF_WORKERS=${NUMBER_OF_WORKERS:="1"}
export MEMORY_VM_BYTES=${MEMORY_VM_BYTES:="256M"}
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="60"}

export SCENARIO_TYPE=${SCENARIO_TYPE:=hog_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/standalone/baremetal-memory-hog.yml}
