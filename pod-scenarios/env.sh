#!/bin/bash

# Vars and respective defaults
export RUNS=${RUNS:=1}
export SECONDS_BETWEEN_RUNS=${SECONDS_BETWEEN_RUNS:=30}
export NAMESPACE=${NAMESPACE:="openshift-.*"}
export POD_LABEL=${POD_LABEL:=""}
export DISRUPTION_COUNT=${DISRUPTION_COUNT:=1}
export EXPECTED_POD_COUNT=${EXPECTED_POD_COUNT:=""}
export TIMEOUT=${TIMEOUT:=180}
export SCENARIO_TYPE=${SCENARIO_TYPE:=pod_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=- scenarios/pod_scenario.yaml}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
