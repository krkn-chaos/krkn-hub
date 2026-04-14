#!/bin/bash
export RUNS=${RUNS:="1"}
export NUMBER_OF_PODS=${NUMBER_OF_PODS:="2"}
export NAMESPACE=${NAMESPACE:="default"}
export IMAGE=${IMAGE:="quay.io/krkn-chaos/krkn-http-load:latest"}
export NODE_SELECTORS=${NODE_SELECTORS:=""}
export TARGET_ENDPOINTS=${TARGET_ENDPOINTS:=""}
export RATE=${RATE:="50/1s"}
export TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:="30s"}
export WORKERS=${WORKERS:="10"}
export MAX_WORKERS=${MAX_WORKERS:="100"}
export CONNECTIONS=${CONNECTIONS:="100"}
export TIMEOUT=${TIMEOUT:="10s"}
export KEEPALIVE=${KEEPALIVE:="true"}
export HTTP2=${HTTP2:="true"}
export INSECURE=${INSECURE:="false"}

export SCENARIO_TYPE=${SCENARIO_TYPE:=http_load_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:="$KRAKEN_FOLDER/scenarios/http-load.yaml"}
