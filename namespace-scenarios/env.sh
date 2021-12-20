#!/bin/bash

# Vars and respective defaults
export ACTION=${ACTION:="delete"}
export NAMESPACE=${NAMESPACE:="openshift-etcd"}
export RUNS=${RUNS:=1}
export SLEEP=${SLEEP:=15}
export SCENARIO_TYPE=${SCENARIO_TYPE:=namespace_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=- scenarios/namespace_scenario.yaml}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
