#!/usr/bin/env bash
set -eo pipefail

# A wait node is a workflow gate. Fail by default so a timeout cannot
# accidentally release its dependent graph nodes.
: "${TRIGGERS_ON_TIMEOUT:=fail}"
export TRIGGERS_ON_TIMEOUT

# Reuse the standard krkn-hub environment and trigger-to-config mapping.
source /home/krkn/main_env.sh

if [[ -z "$TRIGGER_COMMAND" && -z "$TRIGGER_HTTP_URL" && -z "$TRIGGER_K8S_API_VERSION" && -z "$TRIGGER_PROM_QUERY" ]]; then
  echo "A trigger wait node requires at least one trigger condition." >&2
  exit 2
fi

if [[ "$TRIGGERS_ON_TIMEOUT" == "skip" ]]; then
  echo "TRIGGERS_ON_TIMEOUT=skip cannot represent a skipped graph node; treating it as 'fail' so dependent nodes remain blocked." >&2
  TRIGGERS_ON_TIMEOUT=fail
  export TRIGGERS_ON_TIMEOUT
fi

# The trigger-specific template sets kraken.chaos_scenarios to an empty list,
# so Krkn waits for the configured trigger and runs no scenario.
envsubst < /home/krkn/kraken/config/trigger_config.yaml.template > /home/krkn/kraken/config/trigger_config.yaml

cd /home/krkn/kraken
exec python3.11 run_kraken.py --config=/home/krkn/kraken/config/trigger_config.yaml
