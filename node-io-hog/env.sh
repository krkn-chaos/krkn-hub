#!/bin/bash

# Vars and respective defaults
export JOB_CLEANUP_POLICY=${JOB_CLEANUP_POLICY:="delete"}
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="300"}
export FILESYSTEM_UTILIZATION_PERCENTAGE=${FILESYSTEM_UTILIZATION_PERCENTAGE:="90"}
export NUMBER_OF_WORKERS=${NUMBER_OF_WORKERS:=""}
export CPU=${CPU:=2}
export TARGET_NODES=${TARGET_NODES:=""}
export SCENARIO_TYPE=${SCENARIO_TYPE:=litmus_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=- https://raw.githubusercontent.com/cloud-bulldozer/kraken/master/scenarios/templates/litmus-rbac.yaml}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=- scenarios/io_hog.yaml}