#!/bin/bash

# Scenario-specific preparation: decodes the base64-provided service
# hijacking scenario file into $SCENARIO_PATH and validates it against the
# schema. Executed (not sourced) by run.sh; relies on SCENARIO_PATH and
# ROOT_FOLDER being exported by the runner. Exits non-zero on failure.

# check if SCENARIO_BASE64 is set
if [ "$SCENARIO_BASE64" == "1" ]; then
  echo "[ERROR] please set SCENARIO_BASE64 variable with a valid base64 encoded bare metal node scenario eg. podman run -e SCENARIO_BASE64=\$(base64 -w0 ~/krkn/scenarios/openshift/service_hijacking.yml) [...] "
  exit 1
fi

# Substitute config with environment vars defined
if ! echo "$SCENARIO_BASE64" | base64 -d >> "$SCENARIO_PATH"; then
  echo -e "[ERROR] Unable to decode SCENARIO_BASE64, bad base64 format please refer to documentation"
  exit 1
fi

# Validate scenario against schema
python3.11 "$ROOT_FOLDER/validate_config.py" -y "$SCENARIO_PATH" \
                             -s "$ROOT_FOLDER/config-schema.json"
