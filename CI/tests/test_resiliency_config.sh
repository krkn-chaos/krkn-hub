#!/usr/bin/env bash
# Lightweight unit test: verify resiliency env vars resolve into config.yaml correctly.
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

# Render config.yaml.template with optional resiliency env overrides in an isolated
# subshell, and return just the resolved resiliency_run_mode.
run_mode() {
  (
    set -a
    unset RESILIENCY_RUN_MODE RESILIENCY_SCORE DISABLE_RESILIENCY_SCORE
    # Apply case-specific exports, then source shared defaults.
    eval "$@"
    # shellcheck disable=SC1091
    source "$ROOT/env.sh"
    envsubst < "$ROOT/config.yaml.template"
  ) | sed -n 's/^  resiliency_run_mode: //p'
}

expect() { # expect "<exports>" "<expected run mode>"
  got="$(run_mode "$1")"
  [ "$got" = "$2" ] || fail "[$1] rendered resiliency_run_mode '$got', expected '$2'"
}

# Case 1: nothing set -> standalone (backward compatible default)
expect "true" "standalone"

# Case 2: RESILIENCY_SCORE enables detailed mode for every value krknctl accepts.
# krknctl validates booleans with Go's strconv.ParseBool and passes the value
# through verbatim, so all of these can reach the container.
for truthy in true True TRUE t T 1; do
  expect "export RESILIENCY_SCORE=$truthy" "detailed"
done

# Case 3: falsey values leave the default alone
for falsy in false False FALSE f F 0; do
  expect "export RESILIENCY_SCORE=$falsy" "standalone"
done

# Case 4: DISABLE_RESILIENCY_SCORE turns scoring off on the same terms
for truthy in true True TRUE t T 1; do
  expect "export DISABLE_RESILIENCY_SCORE=$truthy" "disabled"
done

# Case 5: disable wins over enable, in either casing (regression guard for #318)
expect "export RESILIENCY_SCORE=true; export DISABLE_RESILIENCY_SCORE=true" "disabled"
expect "export RESILIENCY_SCORE=True; export DISABLE_RESILIENCY_SCORE=True" "disabled"

# Case 6: RESILIENCY_RUN_MODE is honoured on its own, as the env docs describe.
# run_kraken.py only accepts the lowercase spellings, so normalise the casing
# rather than letting Detailed through to a silent fallback.
expect "export RESILIENCY_RUN_MODE=standalone" "standalone"
expect "export RESILIENCY_RUN_MODE=detailed"   "detailed"
expect "export RESILIENCY_RUN_MODE=disabled"   "disabled"
expect "export RESILIENCY_RUN_MODE=Detailed"   "detailed"
expect "export RESILIENCY_RUN_MODE=DISABLED"   "disabled"

# Case 7: the booleans are more specific, so they override an explicit run mode
expect "export RESILIENCY_RUN_MODE=standalone; export RESILIENCY_SCORE=True" "detailed"
expect "export RESILIENCY_RUN_MODE=detailed; export DISABLE_RESILIENCY_SCORE=True" "disabled"

echo "PASS: resiliency config rendering"
