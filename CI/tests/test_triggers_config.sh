#!/usr/bin/env bash
# Lightweight unit test: verify trigger env vars render into config.yaml correctly.
# No cluster or container required. Requires envsubst (gettext).
# Match other CI scripts: avoid nounset because env.sh references optional unset passwords.
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

# Render config.yaml.template with optional trigger env overrides in an isolated subshell.
render() {
  (
    set -a
    unset TRIGGER_COMMAND TRIGGER_EXPECTED_RC TRIGGERS_MODE \
      TRIGGERS_TIMEOUT TRIGGERS_INTERVAL TRIGGERS_ON_TIMEOUT TRIGGERS_BLOCK \
      RESILIENCY_SCORE DISABLE_RESILIENCY_SCORE
    # Apply case-specific exports, then source shared defaults / TRIGGERS_BLOCK builder.
    eval "$@"
    # shellcheck disable=SC1091
    source "$ROOT/env.sh"
    envsubst < "$ROOT/config.yaml.template"
  )
}

# Case 1: TRIGGER_COMMAND unset → no triggers block (backward compatible)
out="$(render true)"
if echo "$out" | grep -q '^triggers:'; then
  fail "triggers present when TRIGGER_COMMAND is unset"
fi

# Case 2: TRIGGER_COMMAND set → triggers block with quoted string fields and values
out="$(
  render "export TRIGGER_COMMAND='kubectl get ns default'; \
          export TRIGGERS_MODE='any_of'; \
          export TRIGGERS_ON_TIMEOUT='fail'; \
          export TRIGGERS_TIMEOUT='120'; \
          export TRIGGERS_INTERVAL='7'; \
          export TRIGGER_EXPECTED_RC='0'"
)"
echo "$out" | grep -q '^triggers:' || fail "triggers missing when TRIGGER_COMMAND is set"
echo "$out" | grep -q 'mode: "any_of"' || fail "mode not rendered/quoted as expected"
echo "$out" | grep -q 'on_timeout: "fail"' || fail "on_timeout not rendered/quoted as expected"
echo "$out" | grep -q 'timeout: 120' || fail "timeout not rendered"
echo "$out" | grep -q 'interval: 7' || fail "interval not rendered"
echo "$out" | grep -q 'expected_rc: 0' || fail "expected_rc not rendered"
echo "$out" | grep -q 'kubectl get ns default' || fail "command not inlined into triggers block"

echo "PASS: triggers config rendering"
