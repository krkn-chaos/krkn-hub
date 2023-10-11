#!/bin/bash

# Vars and respective defaults
export NAMESPACE=${NAMESPACE:="openshift-etcd"}
export LABEL_SELECTOR=${LABEL_SELECTOR:="''"}
export RUNS=${RUNS:=1}
export DELETE_COUNT=${DELETE_COUNT:=1}
export SLEEP=${SLEEP:=15}
export SCENARIO_TYPE=${SCENARIO_TYPE:=service_disruption_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=- scenarios/namespace_scenario.yaml}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
