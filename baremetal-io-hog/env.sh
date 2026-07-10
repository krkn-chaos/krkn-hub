#!/bin/bash

# Vars and respective defaults
export TARGETS=${TARGETS:=""}
export SSH_USER=${SSH_USER:="root"}
export SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY:="/home/krkn/.ssh/id_rsa"}
export SSH_PORT=${SSH_PORT:="22"}
export IO_BLOCK_SIZE=${IO_BLOCK_SIZE:="1m"}
export IO_WORKERS=${IO_WORKERS:="5"}
export IO_WRITE_BYTES=${IO_WRITE_BYTES:="10m"}
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="60"}
export FILL_PATH=${FILL_PATH:="/tmp"}
export FILL_PERCENTAGE=${FILL_PERCENTAGE:="90"}

export SCENARIO_TYPE=${SCENARIO_TYPE:=hog_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/standalone/baremetal-io-hog.yml}
