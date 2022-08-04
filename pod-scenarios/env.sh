#!/bin/bash

# Vars and respective defaults
export NAMESPACE=${NAMESPACE:="openshift-.*"}
export POD_LABEL=${POD_LABEL:=""}
export NAME_PATTERN=${NAME_PATTERN:=".*"}
export DISRUPTION_COUNT=${DISRUPTION_COUNT:=1}
export EXPECTED_POD_COUNT=${EXPECTED_POD_COUNT:=""}
export KILL_TIMEOUT=${KILL_TIMEOUT:=180}
export WAIT_TIMEOUT=${WAIT_TIMEOUT:=360}
export SCENARIO_TYPE=${SCENARIO_TYPE:=plugin_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/pod_scenario.yaml}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
