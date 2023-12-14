#!/bin/bash

# Vars and respective defaults
export SHUTDOWN_DURATION=${SHUTDOWN_DURATION:=1200} 
export CLOUD_TYPE=${CLOUD_TYPE:="aws"}
export TIMEOUT=${TIMEOUT:=180}
export SCENARIO_TYPE=${SCENARIO_TYPE:=cluster_shut_down_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=- scenarios/cluster_shut_down_scenario.yml}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
