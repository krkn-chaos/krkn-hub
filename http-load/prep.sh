#!/bin/bash

# Scenario-specific preparation: builds the http-load scenario file from
# environment variables. Executed (not sourced) by run.sh; relies on
# SCENARIO_PATH and ROOT_FOLDER being exported by the runner.
# Exits non-zero on failure.

python3.11 "$ROOT_FOLDER/build_config_file.py" --outconfig "$SCENARIO_PATH"
