export TEST_DURATION=$TOTAL_CHAOS_DURATION
export LABEL_SELECTOR=${NODE_SELECTOR:="node-role.kubernetes.io/worker="}
export NAMESPACE=${NAMESPACE:="default"}
export INSTANCE_COUNT=${INSTANCE_COUNT:="1"}
export EXECUTION=${EXECUTION:="parallel"}
export INGRESS=${INGRESS:="false"}
export EGRESS=${EGRESS:="true"}
export INTERFACES=${INTERFACES:=""}
export PORTS=${PORTS:=""}

