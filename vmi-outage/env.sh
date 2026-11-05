#!/bin/bash

# Vars and respective defaults
export NAMESPACE=${NAMESPACE:=""}
export VM_NAME=${VM_NAME:=""}
export LABEL_SELECTOR=${LABEL_SELECTOR:=""}
export TIMEOUT=${TIMEOUT:=60}
export KILL_COUNT=${KILL_COUNT:=1}
# Optional guest reachability MTTR (VMI Running / UEFI → first ping or TCP)
# Probe always runs from an in-cluster helper pod (krkn-tools image).
export WAIT_FOR_GUEST_PING=${WAIT_FOR_GUEST_PING:=False}
export GUEST_PING_TIMEOUT=${GUEST_PING_TIMEOUT:=300}
export GUEST_PING_INTERVAL=${GUEST_PING_INTERVAL:=2}
export GUEST_PING_METHOD=${GUEST_PING_METHOD:=icmp}
export GUEST_PING_PORT=${GUEST_PING_PORT:=22}
export GUEST_PING_NAMESPACE=${GUEST_PING_NAMESPACE:=""}
# Leave empty for icmp (ephemeral NET_RAW helper). For tcp, optional reuse of
# CI/templates/guest-ping-diagnosis-pod.yaml from krkn.
export GUEST_PING_POD=${GUEST_PING_POD:=""}
# Override helper image for disconnected / mirrored registries (needs ping/nc)
export GUEST_PING_IMAGE=${GUEST_PING_IMAGE:="quay.io/krkn-chaos/krkn-hub-multiarch:workload-krkn-tools"}
# Seconds to sleep after probe pod is Ready, before VMI delete
export GUEST_PING_SETTLE_SECONDS=${GUEST_PING_SETTLE_SECONDS:=5}
export SCENARIO_TYPE=${SCENARIO_TYPE:=vmi_outage}
export SCENARIO_FILE=${SCENARIO_FILE:=scenarios/vmi_scenario.yaml}
