#!/bin/bash

# Vars and respective defaults
export ACTION=${ACTION:="skew_date"}
export OBJECT_TYPE=${OBJECT_TYPE:="pod"}
export LABEL_SELECTOR=${LABEL_SELECTOR:="k8s-app=etcd"}
export OBJECT_NAME=${OBJECT_NAME:=""}
export NAMESPACE=${NAMESPACE:=""}
export SCENARIO_TYPE=${SCENARIO_TYPE:=time_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/time_scenario.yaml}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}