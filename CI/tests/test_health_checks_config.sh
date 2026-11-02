#!/usr/bin/env bash
# Lightweight unit test: verify HEALTH_CHECK_URL renders one or more
# health_checks.config entries in config.yaml.
# Checks both config.yaml.template and workload-trigger/config.yaml.template.
# No cluster or container required. Requires envsubst (gettext) and PyYAML.
set -eo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

if ! command -v envsubst >/dev/null 2>&1; then
  echo "FAIL: envsubst not found (install gettext)" >&2
  exit 1
fi

if ! python3 -c 'import yaml' >/dev/null 2>&1; then
  echo "FAIL: PyYAML not found (install python3-yaml)" >&2
  exit 1
fi

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

# Render config.yaml.template with the given exports in an isolated subshell
# and print only the health_checks section.
TEMPLATE="config.yaml.template"
render_health_checks() {
  (
    set -a
    unset HEALTH_CHECK_URL HEALTH_CHECK_BEARER_TOKEN HEALTH_CHECK_AUTH \
      HEALTH_CHECK_EXIT_ON_FAILURE HEALTH_CHECK_VERIFY \
      HEALTH_CHECK_CONFIG_BLOCK HEALTH_CHECK_SECTION_EXIT_ON_FAILURE
    eval "$1"
    # shellcheck disable=SC1091
    source "$ROOT/env.sh"
    envsubst < "$ROOT/$TEMPLATE"
  ) | sed -n '/^health_checks:/,/^[^[:space:]]/p' | sed '$d'
}

count_urls() {
  grep -c '^        - url: ' <<< "$1" || true
}

# Case 1: no URL set -> a single empty entry, same as before this change
out="$(render_health_checks true)"
[ "$(count_urls "$out")" -eq 1 ] || fail "expected 1 entry when HEALTH_CHECK_URL is unset"
grep -q '^        - url: ""$' <<< "$out" || fail "expected an empty url when HEALTH_CHECK_URL is unset"

# Case 2: one URL -> one entry with shared settings
out="$(render_health_checks "export HEALTH_CHECK_URL='http://app-a/health'; \
  export HEALTH_CHECK_BEARER_TOKEN='tok'; export HEALTH_CHECK_EXIT_ON_FAILURE='True'")"
[ "$(count_urls "$out")" -eq 1 ] || fail "expected 1 entry for a single URL"
grep -q 'url: "http://app-a/health"' <<< "$out" || fail "single URL not rendered"
grep -q 'bearer_token: "tok"' <<< "$out" || fail "bearer token not rendered"
grep -q 'exit_on_failure: True' <<< "$out" || fail "exit_on_failure not rendered"

# Case 3: comma-separated URLs with spaces and empty items -> one entry each
out="$(render_health_checks "export HEALTH_CHECK_URL='http://app-a/health, http://app-b/ready,,http://app-c/'")"
[ "$(count_urls "$out")" -eq 3 ] || fail "expected 3 entries for 3 URLs, got $(count_urls "$out")"
grep -q 'url: "http://app-a/health"' <<< "$out" || fail "first URL missing"
grep -q 'url: "http://app-b/ready"' <<< "$out" || fail "second URL missing or not trimmed"
grep -q 'url: "http://app-c/"' <<< "$out" || fail "third URL missing"
[ "$(grep -c '^          verify_url: False$' <<< "$out")" -eq 3 ] || fail "each entry should get verify_url"

# Case 4: rendered section is valid YAML with the expected list
python3 - "$out" <<'PY' || fail "health_checks section is not valid YAML"
import sys, yaml
data = yaml.safe_load(sys.argv[1])
urls = [c["url"] for c in data["health_checks"]["config"]]
assert urls == ["http://app-a/health", "http://app-b/ready", "http://app-c/"], urls
PY

# Case 5: exit_on_failure set -> also rendered at section level (Krkn reads it
# there for pre/post checks); unset -> no section-level key, same as before
out="$(render_health_checks 'HEALTH_CHECK_URL="http://a,http://b"; HEALTH_CHECK_EXIT_ON_FAILURE=False')"
python3 - "$out" <<'PY' || fail "section-level exit_on_failure not rendered"
import sys, yaml
hc = yaml.safe_load(sys.argv[1])["health_checks"]
assert hc["exit_on_failure"] is False, hc
assert [c["exit_on_failure"] for c in hc["config"]] == [False, False], hc
PY
out="$(render_health_checks 'HEALTH_CHECK_URL="http://a"')"
python3 - "$out" <<'PY' || fail "section-level exit_on_failure should be absent when unset"
import sys, yaml
assert "exit_on_failure" not in yaml.safe_load(sys.argv[1])["health_checks"]
PY

# Case 6: the trigger image template renders the same multi-URL list
TEMPLATE="workload-trigger/config.yaml.template"
out="$(render_health_checks 'HEALTH_CHECK_URL="http://app-a/health, http://app-b/ready"; HEALTH_CHECK_EXIT_ON_FAILURE=True')"
python3 - "$out" <<'PY' || fail "trigger template health_checks not rendered per URL"
import sys, yaml
hc = yaml.safe_load(sys.argv[1])["health_checks"]
assert [c["url"] for c in hc["config"]] == ["http://app-a/health", "http://app-b/ready"], hc
assert hc["exit_on_failure"] is True, hc
PY

echo "PASS: health checks config rendering"
