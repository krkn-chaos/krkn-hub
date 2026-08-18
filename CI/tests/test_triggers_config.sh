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
      TRIGGER_HTTP_URL TRIGGER_HTTP_METHOD TRIGGER_HTTP_EXPECTED_STATUS \
      TRIGGER_HTTP_BEARER_TOKEN TRIGGER_HTTP_BODY_CONTAINS \
      TRIGGER_K8S_API_VERSION TRIGGER_K8S_KIND TRIGGER_K8S_NAME \
      TRIGGER_K8S_NAMESPACE TRIGGER_K8S_CONDITION \
      TRIGGER_PROM_QUERY TRIGGER_PROM_URL TRIGGER_PROM_TOKEN \
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

# Case 3: TRIGGER_HTTP_URL set -> HTTP block generated
out="$(
  render "export TRIGGER_HTTP_URL='http://example.com'; \
          export TRIGGER_HTTP_EXPECTED_STATUS='201'; \
          export TRIGGER_HTTP_BEARER_TOKEN='my-token'; \
          export TRIGGER_HTTP_BODY_CONTAINS='ready'"
)"
echo "$out" | grep -q '^triggers:' || fail "triggers missing when TRIGGER_HTTP_URL is set"
echo "$out" | grep -q 'type: http' || fail "type: http missing"
echo "$out" | grep -q 'url: "http://example.com"' || fail "HTTP URL missing"
echo "$out" | grep -q 'expected_status: 201' || fail "expected_status not rendered"
echo "$out" | grep -q 'bearer_token: "my-token"' || fail "bearer_token not rendered"
echo "$out" | grep -q 'body_contains: "ready"' || fail "body_contains not rendered"

# Case 4: TRIGGER_K8S_API_VERSION set -> k8s block generated
out="$(
  render "export TRIGGER_K8S_API_VERSION='apps/v1'; \
          export TRIGGER_K8S_KIND='Deployment'; \
          export TRIGGER_K8S_NAME='nginx'; \
          export TRIGGER_K8S_NAMESPACE='default'; \
          export TRIGGER_K8S_CONDITION='status.readyReplicas >= 1'"
)"
echo "$out" | grep -q '^triggers:' || fail "triggers missing when TRIGGER_K8S_API_VERSION is set"
echo "$out" | grep -q 'type: k8s' || fail "type: k8s missing"
echo "$out" | grep -q 'apiVersion: "apps/v1"' || fail "apiVersion not rendered"
echo "$out" | grep -q 'kind: "Deployment"' || fail "kind not rendered"
echo "$out" | grep -q 'name: "nginx"' || fail "k8s name not rendered"
echo "$out" | grep -q 'namespace: "default"' || fail "namespace not rendered"
echo "$out" | grep -q 'condition: "status.readyReplicas >= 1"' || fail "condition not rendered"

# Case 5: TRIGGER_K8S without namespace (cluster-scoped resource)
out="$(
  render "export TRIGGER_K8S_API_VERSION='v1'; \
          export TRIGGER_K8S_KIND='Namespace'; \
          export TRIGGER_K8S_NAME='kube-system'; \
          export TRIGGER_K8S_CONDITION='status.phase == Active'"
)"
echo "$out" | grep -q 'type: k8s' || fail "type: k8s missing for cluster-scoped resource"
# Ensure no namespace line appears in the k8s trigger block (indented under type: k8s)
if echo "$out" | grep -A5 'type: k8s' | grep -q 'namespace:'; then
  fail "namespace rendered in k8s block for cluster-scoped resource"
fi

# Case 6: TRIGGER_PROM_QUERY set -> prometheus block generated with token
out="$(
  render "export TRIGGER_PROM_QUERY='avg(rate(container_cpu_usage_seconds_total[5m])) > 0.8'; \
          export TRIGGER_PROM_URL='http://prometheus:9090'; \
          export TRIGGER_PROM_TOKEN='prom-secret-token'"
)"
echo "$out" | grep -q '^triggers:' || fail "triggers missing when TRIGGER_PROM_QUERY is set"
echo "$out" | grep -q 'type: prometheus' || fail "type: prometheus missing"
echo "$out" | grep -q 'query: "avg(rate(container_cpu_usage_seconds_total\[5m\])) > 0.8"' || fail "prometheus query not rendered"
echo "$out" | grep -q 'prometheus_url: "http://prometheus:9090"' || fail "prometheus_url not rendered"
echo "$out" | grep -q 'prometheus_bearer_token: "prom-secret-token"' || fail "prometheus_bearer_token not rendered"

# Case 7: TRIGGER_PROM_QUERY set without token -> no bearer_token line
out="$(
  render "export TRIGGER_PROM_QUERY='up{job=\"krkn\"} == 1'; \
          export TRIGGER_PROM_URL='http://prom.local:9090'"
)"
echo "$out" | grep -q 'type: prometheus' || fail "type: prometheus missing without token"
echo "$out" | grep -q 'prometheus_url: "http://prom.local:9090"' || fail "prometheus_url not rendered without token"
if echo "$out" | grep -A5 'type: prometheus' | grep -q 'prometheus_bearer_token:'; then
  fail "prometheus_bearer_token rendered when TRIGGER_PROM_TOKEN is empty"
fi

echo "PASS: triggers config rendering"
