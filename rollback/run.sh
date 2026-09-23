#!/bin/bash
set -eo pipefail

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"

source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/main_env.sh"

: "${UUID:?UUID cannot be empty}"

envsubst < "$KRAKEN_FOLDER/config/config.yaml.template" > "$KRAKEN_FOLDER/config/config.yaml"

rollback_args=(
  --config "$KRAKEN_FOLDER/config/config.yaml"
  execute-rollback
  --run_uuid "$UUID"
)

if [[ -n "$SCENARIO_TYPE" ]]; then
  rollback_args+=(--scenario_type "$SCENARIO_TYPE")
fi

cd "$KRAKEN_FOLDER"
"${PYTHON_CMD:-python3}" run_kraken.py "${rollback_args[@]}"
