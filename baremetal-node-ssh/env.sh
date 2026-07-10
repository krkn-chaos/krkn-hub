#!/bin/bash

# Vars and respective defaults
export TARGETS=${TARGETS:=""}
export SSH_USER=${SSH_USER:="root"}
export SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY:="/home/krkn/.ssh/id_rsa"}
export SSH_PORT=${SSH_PORT:="22"}
export ACTION=${ACTION:="node_reboot_scenario"}
export RUNS=${RUNS:="1"}
export TIMEOUT=${TIMEOUT:="360"}
export SOFT_REBOOT=${SOFT_REBOOT:="true"}

export SCENARIO_TYPE=${SCENARIO_TYPE:=node_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/standalone/baremetal-node-ssh.yml}
