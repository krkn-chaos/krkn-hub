#!/bin/bash

# Vars and respective defaults
export NAMESPACE=${NAMESPACE:="openshift-.*"}
export POD_LABEL=${POD_LABEL:=""}
export NAME_PATTERN=${NAME_PATTERN:=".*"}
export DISRUPTION_COUNT=${DISRUPTION_COUNT:=1}
export KILL_TIMEOUT=${KILL_TIMEOUT:=180}
export EXPECTED_RECOVERY_TIME=${EXPECTED_RECOVERY_TIME:=120}
export SCENARIO_TYPE=${SCENARIO_TYPE:=pod_disruption_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/pod_scenario.yaml}
