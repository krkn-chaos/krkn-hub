export SCENARIO_TYPE=${SCENARIO_TYPE:=network_chaos_ng_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/kube/pod-egress-shaping.yml}

export IMAGE=${IMAGE:="docker.io/fedora/tools"}
export TEST_DURATION=${TOTAL_CHAOS_DURATION:="60"}
export POD_SELECTOR=${POD_SELECTOR:=""}
export EXECUTION=${EXECUTION:="parallel"}
export NAMESPACE=${NAMESPACE:="default"}
export INSTANCE_COUNT=${INSTANCE_COUNT:="1"}
export POD_NAME=${POD_NAME:=""}

export LATENCY=${LATENCY:=""}
export LOSS=${LOSS:=""}
export BANDWIDTH=${BANDWIDTH:=""}
export NETWORK_SHAPING_EXECUTION=${NETWORK_SHAPING_EXECUTION:="parallel"}