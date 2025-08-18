export SCENARIO_TYPE=${SCENARIO_TYPE:=network_chaos_ng_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/kube/pod-network-shaping.yml}

export IMAGE=${IMAGE:="quay.io/krkn-chaos/krkn:tools"}
export TEST_DURATION=${TOTAL_CHAOS_DURATION:="60"}
export POD_SELECTOR=${POD_SELECTOR:=""}
export EXECUTION=${EXECUTION:="parallel"}
export NAMESPACE=${NAMESPACE:="default"}
export INSTANCE_COUNT=${INSTANCE_COUNT:="1"}
export POD_NAME=${POD_NAME:=""}
export SERVICE_ACCOUNT=${SERVICE_ACCOUNT:=""}
export TAINTS=${TAINTS:=""}

export LATENCY=${LATENCY:=""}
export LOSS=${LOSS:=""}
export BANDWIDTH=${BANDWIDTH:=""}
export NETWORK_SHAPING_EXECUTION=${NETWORK_SHAPING_EXECUTION:="parallel"}