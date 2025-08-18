export SCENARIO_TYPE=${SCENARIO_TYPE:=network_chaos_ng_scenarios}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/kube/pod-network-filter.yml}

export IMAGE=${IMAGE:="quay.io/krkn-chaos/krkn-network-chaos:latest"}
export TEST_DURATION=${TOTAL_CHAOS_DURATION:="60"}
export POD_SELECTOR=${POD_SELECTOR:=""}
export EXECUTION=${EXECUTION:="parallel"}
export NAMESPACE=${NAMESPACE:="default"}
export INSTANCE_COUNT=${INSTANCE_COUNT:="1"}
export POD_NAME=${POD_NAME:=""}
export SERVICE_ACCOUNT=${SERVICE_ACCOUNT:=""}
export TAINTS=${TAINTS:=""}

export INGRESS=${INGRESS:="false"}
export EGRESS=${EGRESS:="false"}
export INTERFACES=${INTERFACES:=""}
export PROTOCOLS=${PROTOCOLS:="tcp"}
export PORTS=${PORTS:=""}



