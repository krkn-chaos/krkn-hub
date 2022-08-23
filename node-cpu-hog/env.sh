#!/bin/bash

# Vars and respective defaults
export JOB_CLEANUP_POLICY=${JOB_CLEANUP_POLICY:="delete"}
export LITMUS_INSTALL=${LITMUS_INSTALL:=true}
export LITMUS_UNINSTALL_BEFORE_RUN=${LITMUS_UNINSTALL_BEFORE_RUN:=true}
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="300"}
export NODE_CPU_CORE=${NODE_CPU_CORE:="2"}
export NODES_AFFECTED_PERC=${NODES_AFFECTED_PERC:=""}
export TARGET_NODES=${TARGET_NODES:=""}
export SCENARIO_TYPE=${SCENARIO_TYPE:=litmus_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=- scenarios/templates/litmus-rbac.yaml}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=- scenarios/node_hog_engine.yaml}
