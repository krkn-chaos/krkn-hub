#!/bin/bash
export PACKET_SIZE=${PACKET_SIZE:="120"}
export WINDOW_SIZE=${WINDOW_SIZE:="64"}
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="120"}
export NAMESPACE=${NAMESPACE:="default"}
export TARGET_SERVICE=${TARGET_SERVICE:=""}
export TARGET_PORT=${TARGET_PORT:=443}
export TARGET_SERVICE_LABEL=${TARGET_SERVICE_LABEL:=""}
export NUMBER_OF_PODS=${NUMBER_OF_PODS:="2"}
export IMAGE=${IMAGE:="quay.io/krkn-chaos/krkn-syn-flood"}
export NODE_SELECTORS=${NODE_SELECTORS:=""}

export SCENARIO_TYPE=${SCENARIO_TYPE:=syn_flood_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:="$KRAKEN_FOLDER/scenarios/syn-flood.yaml"}