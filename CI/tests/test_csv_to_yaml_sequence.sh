#!/usr/bin/env bash
# Unit test for the shared CSV-to-YAML helper and rendered network scenario templates.
set -eo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

if ! command -v envsubst >/dev/null 2>&1; then
  echo "FAIL: envsubst not found (install gettext)" >&2
  exit 1
fi

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

# shellcheck disable=SC1091
source "$ROOT/common_run.sh"

[[ "$(csv_to_yaml_sequence '')" == '[]' ]] || fail "empty CSV did not produce an empty sequence"
[[ "$(csv_to_yaml_sequence 'on,true,eth0')" == '["on", "true", "eth0"]' ]] || \
  fail "string values were not emitted as quoted YAML strings"
[[ "$(csv_to_yaml_sequence '80,443' number)" == '[80, 443]' ]] || \
  fail "numeric values were not emitted as a numeric YAML sequence"
if csv_to_yaml_sequence '80,http' number >/dev/null; then
  fail "non-numeric value was accepted in a numeric sequence"
fi
if error_message="$(export_csv_yaml_sequence INVALID_YAML '80,http' number 2>&1)"; then
  fail "invalid numeric CSV was accepted"
fi
[[ "$error_message" == *"Unable to encode INVALID as a numeric YAML sequence"* ]] || \
  fail "numeric CSV validation error was not clear"

# Render node-interface-down through the same source and validation order as run.sh.
rendered="$(
  export TOTAL_CHAOS_DURATION=90
  export NODE_SELECTOR='node-role.kubernetes.io/worker=true'
  export NAMESPACE=chaos-test
  export INSTANCE_COUNT=2
  export EXECUTION=serial
  export INTERFACES='on,true,eth0'
  export TAINTS='node-role.kubernetes.io/worker:NoSchedule'
  export RECOVERY_TIME=5
  export WAIT_DURATION=3
  export NODE_NAME=worker-0
  export SERVICE_ACCOUNT=krkn
  export IMAGE=example.invalid/interface-down:test

  # shellcheck disable=SC1091
  # shellcheck disable=SC1091
  source "$ROOT/node-interface-down/env.sh"
  # shellcheck disable=SC1091
  source "$ROOT/common_run.sh"
  export_csv_yaml_sequence INTERFACES_YAML "$INTERFACES" || exit 1
  export_csv_yaml_sequence TAINTS_YAML "$TAINTS" || exit 1
  envsubst < "$ROOT/node-interface-down/node-interface-down.yml.template"
)"

assert_line() {
  grep -Fqx -- "$1" <<< "$rendered" || fail "rendered scenario is missing: $1"
}

assert_line '- id: node_interface_down'
assert_line '  wait_duration: 3'
assert_line '  test_duration: 90'
assert_line '  label_selector: "node-role.kubernetes.io/worker=true"'
assert_line '  service_account: "krkn"'
assert_line '  namespace: "chaos-test"'
assert_line '  instance_count: 2'
assert_line '  execution: serial'
assert_line '  ingress: true'
assert_line '  egress: true'
assert_line '  target: "worker-0"'
assert_line '  interfaces: ["on", "true", "eth0"]'
assert_line '  taints: ["node-role.kubernetes.io/worker:NoSchedule"]'
assert_line '  recovery_time: 5'
assert_line '  image: "example.invalid/interface-down:test"'

[[ "$(grep -c '^  interfaces:' <<< "$rendered")" -eq 1 ]] || \
  fail "rendered scenario must contain exactly one interfaces field"
[[ "$(grep -c '^  taints:' <<< "$rendered")" -eq 1 ]] || \
  fail "rendered scenario must contain exactly one taints field"

# VMI network chaos parameters are strings in Kraken's VMI plugin schema.
vmi_rendered="$(
  export TOTAL_CHAOS_DURATION=75
  export VMI_NAME=guest-0
  export LABEL_SELECTOR='kubevirt.io/domain=guest'
  export NAMESPACE=virtual-machines
  export INTERFACES='on,true'
  export TAINTS='node-role.kubernetes.io/worker:NoSchedule'
  export LATENCY=100ms
  export LOSS=0.02
  export BANDWIDTH=100mbit
  export SERVICE_ACCOUNT=krkn
  export IMAGE=example.invalid/vmi-network:test

  # shellcheck disable=SC1091
  source "$ROOT/vmi-network/env.sh"
  # shellcheck disable=SC1091
  source "$ROOT/common_run.sh"
  export_csv_yaml_sequence INTERFACES_YAML "$INTERFACES" || exit 1
  export_csv_yaml_sequence TAINTS_YAML "$TAINTS" || exit 1
  LATENCY_YAML="\"$LATENCY\""
  LOSS_YAML="\"$LOSS\""
  BANDWIDTH_YAML="\"$BANDWIDTH\""
  export LATENCY_YAML LOSS_YAML BANDWIDTH_YAML
  envsubst < "$ROOT/vmi-network/vmi-network-chaos.yml.template"
)"

grep -Fqx -- '  latency: "100ms"' <<< "$vmi_rendered" || \
  fail "latency was not rendered as a quoted string"
grep -Fqx -- '  loss: "0.02"' <<< "$vmi_rendered" || \
  fail "loss was not rendered as a quoted string"
grep -Fqx -- '  bandwidth: "100mbit"' <<< "$vmi_rendered" || \
  fail "bandwidth was not rendered as a quoted string"
grep -Fqx -- '  interfaces: ["on", "true"]' <<< "$vmi_rendered" || \
  fail "VMI interfaces were not rendered as quoted strings"
grep -Fqx -- '  taints: ["node-role.kubernetes.io/worker:NoSchedule"]' <<< "$vmi_rendered" || \
  fail "VMI taints were not rendered as quoted strings"

echo "PASS: CSV YAML sequences and rendered network scenario templates"
