#!/bin/bash

# Vars and respective defaults
export SCENARIO_BASE64=${SCENARIO_BASE64:=1}
export SCENARIO_TYPE="service_hijacking"
export SCENARIO_FILE="scenarios/service_hijacking.yaml"
export SCENARIO_POST_ACTION=${SCENARIO_POST_ACTION:=""}
