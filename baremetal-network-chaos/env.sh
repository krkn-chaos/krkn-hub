#!/bin/bash

# Vars and respective defaults
export TARGETS=${TARGETS:=""}
export SSH_USER=${SSH_USER:="root"}
export SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY:="/home/krkn/.ssh/id_rsa"}
export SSH_PORT=${SSH_PORT:="22"}
export DURATION=${DURATION:="300"}
export INTERFACES=${INTERFACES:="[]"}
export EXECUTION=${EXECUTION:="serial"}
export LATENCY=${LATENCY:=""}
export LOSS=${LOSS:=""}
export BANDWIDTH=${BANDWIDTH:=""}

export SCENARIO_TYPE=${SCENARIO_TYPE:=network_chaos_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/standalone/baremetal-network-chaos.yml}
