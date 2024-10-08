#!/bin/bash

# Vars and respective defaults
export NAMESPACE=${NAMESPACE:=""}
export TRAFFIC_TYPE=${TRAFFIC_TYPE:=[ingress, egress]}
export INGRESS_PORTS=${INGRESS_PORTS:=[]}
export EGRESS_PORTS=${EGRESS_PORTS:=[]}
export WAIT_DURATION=${WAIT_DURATION:=360}
export LABEL_SELECTOR=${LABEL_SELECTOR:=""}
export POD_NAME=${POD_NAME:=""}
export INSTANCE_COUNT=${INSTANCE_COUNT:=1}
export TEST_DURATION=${TEST_DURATION:=120}
export SCENARIO_TYPE=${SCENARIO_TYPE:=pod_network_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/pod_network_scenario.yaml}
