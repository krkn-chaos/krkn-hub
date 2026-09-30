#!/bin/bash
# run.sh — entrypoint for the node-network-chaos krknctl scenario image.
#
# Execution order:
#   1. Source env files (globals → scenario-specific defaults)
#   2. Mutate the seed YAML with runtime values using yq
#   3. Derive ingress/egress booleans from the TRAFFIC_TYPE list variable
#   4. Set the list-type fields (interfaces, taints) from their env vars
#   5. Generate krkn config.yaml via envsubst
#   6. Run pre-flight checks (kubectl/oc present, kubeconfig readable)
#   7. Execute krkn

set -eo pipefail

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/kube"
SCENARIO_FILE="$SCENARIO_FOLDER/node-network-chaos.yml"
CONFIG_TEMPLATE="$KRAKEN_FOLDER/config/config.yaml.template"
CONFIG_OUT="$KRAKEN_FOLDER/config/node-network-chaos-config.yaml"

# ── 1. Source environment ─────────────────────────────────────────────────────
source "$ROOT_FOLDER/env.sh"        # scenario-specific defaults FIRST
source "$ROOT_FOLDER/main_env.sh"   # global krkn-hub defaults (kubeconfig, cerberus, etc.)
source "$ROOT_FOLDER/common_run.sh" # defines the checks() helper function

if [[ "$KRKN_DEBUG" == "True" ]]; then
    set -x
fi

# ── 2. Scalar field mutations ─────────────────────────────────────────────────
# Each yq command updates one field in the YAML list-item at index 0.
# Integers: no quotes.  Strings: always double-quoted to survive special chars.
yq -i ".[0].image=\"$IMAGE\""                 "$SCENARIO_FILE"
yq -i ".[0].wait_duration=$WAIT_DURATION"     "$SCENARIO_FILE"
yq -i ".[0].test_duration=$TEST_DURATION"     "$SCENARIO_FILE"
yq -i ".[0].label_selector=\"$LABEL_SELECTOR\"" "$SCENARIO_FILE"
yq -i ".[0].service_account=\"$SERVICE_ACCOUNT\"" "$SCENARIO_FILE"
yq -i ".[0].namespace=\"$NAMESPACE\""         "$SCENARIO_FILE"
yq -i ".[0].instance_count=$INSTANCE_COUNT"   "$SCENARIO_FILE"
yq -i ".[0].execution=\"$EXECUTION\""         "$SCENARIO_FILE"
yq -i ".[0].target=\"$NODE_NAME\""            "$SCENARIO_FILE"
yq -i ".[0].force=$FORCE"                     "$SCENARIO_FILE"

# ── 3. Optional tc netem parameters ──────────────────────────────────────────
# Only write these if the caller supplied a value — an empty string is a valid
# sentinel meaning "do not apply this shaping parameter".
if [[ -n "$LATENCY" ]]; then
    yq -i ".[0].latency=\"$LATENCY\"" "$SCENARIO_FILE"
fi
if [[ -n "$LOSS" ]]; then
    # loss is digits-only (no % symbol) — stored as a YAML string per the model
    yq -i ".[0].loss=\"$LOSS\"" "$SCENARIO_FILE"
fi
if [[ -n "$BANDWIDTH" ]]; then
    yq -i ".[0].bandwidth=\"$BANDWIDTH\"" "$SCENARIO_FILE"
fi

# ── 4. Derive ingress / egress booleans from TRAFFIC_TYPE ────────────────────
# TRAFFIC_TYPE is a string like "[egress]" or "[ingress,egress]".
# We search for the word (case-insensitive) to derive each boolean.
if echo "$TRAFFIC_TYPE" | grep -qi "ingress"; then
    yq -i ".[0].ingress=true"  "$SCENARIO_FILE"
else
    yq -i ".[0].ingress=false" "$SCENARIO_FILE"
fi

if echo "$TRAFFIC_TYPE" | grep -qi "egress"; then
    yq -i ".[0].egress=true"  "$SCENARIO_FILE"
else
    yq -i ".[0].egress=false" "$SCENARIO_FILE"
fi

# ── 5. List fields — interfaces and taints ────────────────────────────────────
# INTERFACES and TAINTS are YAML array strings, e.g. "[]" or "[br-ex,eth0]".
# yq accepts raw YAML expressions, so we pass the value directly.
yq -i ".[0].interfaces=$INTERFACES" "$SCENARIO_FILE"
yq -i ".[0].taints=$TAINTS"         "$SCENARIO_FILE"

# ── 6. Generate krkn config.yaml ─────────────────────────────────────────────
# The config.yaml.template references $SCENARIO_TYPE and $SCENARIO_FILE.
# These two variables are what krkn's run_kraken.py reads to find our scenario.
export SCENARIO_TYPE="network_chaos_ng_scenarios"
export SCENARIO_FILE="$SCENARIO_FILE"
envsubst < "$CONFIG_TEMPLATE" > "$CONFIG_OUT"

# ── 7. Pre-flight check ───────────────────────────────────────────────────────
# checks() is defined in common_run.sh — verifies kubectl/oc and kubeconfig.
checks

# ── 8. Debug output ───────────────────────────────────────────────────────────
if [[ "$KRKN_DEBUG" == "True" ]]; then
    echo "=== Scenario YAML ==="
    cat "$SCENARIO_FILE"
    echo "=== Krkn Config ==="
    cat "$CONFIG_OUT"
fi

# ── 9. Run krkn ──────────────────────────────────────────────────────────────
cd "$KRAKEN_FOLDER"
exec python3.11 run_kraken.py --config="$CONFIG_OUT"
