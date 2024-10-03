#!/bin/bash

# Vars and respective defaults
export DURATION=${DURATION:=600}
export NAMESPACE=${NAMESPACE:=<namespace>}
export POD_SELECTOR=${POD_SELECTOR:="{}"}
export BLOCK_TRAFFIC_TYPE=${BLOCK_TRAFFIC_TYPE:=- Ingress}
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
export SCENARIO_TYPE=${SCENARIO_TYPE:=application_outages_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/app_outage.yaml}
