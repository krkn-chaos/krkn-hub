#!/bin/bash

# Vars and respective defaults
export NAMESPACE=${NAMESPACE:="openshift-etcd"}
export LABEL_SELECTOR=${LABEL_SELECTOR:="k8s-app=etcd"}
export EXPECTED_RECOVERY_TIME=${EXPECTED_RECOVERY_TIME:=60}
export DISRUPTION_COUNT=${DISRUPTION_COUNT:=1}
export CONTAINER_NAME=${CONTAINER_NAME:=etcd}
export ACTION=${ACTION:=1}
export SCENARIO_TYPE=${SCENARIO_TYPE:=container_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=- scenarios/container_scenario.yaml}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
