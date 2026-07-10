#!/bin/bash

# Vars and respective defaults
export TARGETS=${TARGETS:=""}
export SSH_USER=${SSH_USER:="root"}
export SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY:="/home/krkn/.ssh/id_rsa"}
export SSH_PORT=${SSH_PORT:="22"}
export NODE_CPU_CORE=${NODE_CPU_CORE:="0"}
export NODE_CPU_PERCENTAGE=${NODE_CPU_PERCENTAGE:="50"}
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="60"}

export SCENARIO_TYPE=${SCENARIO_TYPE:=hog_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/standalone/baremetal-cpu-hog.yml}
