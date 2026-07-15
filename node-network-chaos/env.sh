#!/bin/bash
# env.sh — default environment variables for the node-network-chaos scenario.
#
# These variables are read by run.sh, which uses them to populate the scenario
# YAML before krkn executes. Every variable here corresponds to a field in
# NetworkChaosConfig (krkn/scenario_plugins/network_chaos_ng/models.py).
#
# The := syntax means: use the caller-supplied value if set; fall back to the
# literal default on the right-hand side.

# ── Targeting ────────────────────────────────────────────────────────────────
# Which node(s) to target. Provide either a label selector OR a node name.
export LABEL_SELECTOR=${LABEL_SELECTOR:=""}   # e.g. "node-role.kubernetes.io/worker"
export NODE_NAME=${NODE_NAME:=""}             # e.g. "worker-0.example.com"

# ── Scheduling ───────────────────────────────────────────────────────────────
# How many nodes to target and how to run them.
export INSTANCE_COUNT=${INSTANCE_COUNT:="1"}          # number of nodes
export EXECUTION=${EXECUTION:="parallel"}             # parallel | serial

# ── Kubernetes context ────────────────────────────────────────────────────────
export NAMESPACE=${NAMESPACE:="default"}              # namespace for the helper pod
export SERVICE_ACCOUNT=${SERVICE_ACCOUNT:=""}         # optional service account
export IMAGE=${IMAGE:="quay.io/krkn-chaos/krkn-network-chaos:latest"} # helper pod image
export TAINTS=${TAINTS:="[]"}                         # node taints (YAML array string)

# ── Network interfaces ────────────────────────────────────────────────────────
# Which interfaces to apply tc rules on. Empty = all interfaces.
export INTERFACES=${INTERFACES:="[]"}                 # e.g. "[br-ex]" or "[eth0,eth1]"

# ── Traffic direction ─────────────────────────────────────────────────────────
# JSON/YAML-style list. Supported values: egress, ingress, or both.
export TRAFFIC_TYPE=${TRAFFIC_TYPE:="[egress]"}       # e.g. "[egress]" or "[ingress,egress]"

# ── tc netem shaping parameters ───────────────────────────────────────────────
# At least one of latency, loss, or bandwidth must be provided.
export LATENCY=${LATENCY:=""}                         # e.g. "200ms"  (units: us, ms, s)
export LOSS=${LOSS:=""}                               # e.g. "10"     (%, digits only)
export BANDWIDTH=${BANDWIDTH:=""}                     # e.g. "100mbit" (units: bit..tbit)

# ── Timing ────────────────────────────────────────────────────────────────────
export TEST_DURATION=${TEST_DURATION:="120"}          # seconds to hold chaos
export WAIT_DURATION=${WAIT_DURATION:="0"}            # post-chaos wait (seconds)

# ── Safety ────────────────────────────────────────────────────────────────────
# force=true removes any pre-existing tc qdiscs before applying new ones.
export FORCE=${FORCE:="false"}                        # true | false
