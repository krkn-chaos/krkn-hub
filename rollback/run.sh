#!/bin/bash
set -eo pipefail

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"

source "$ROOT_FOLDER/env.sh"
source "$ROOT_FOLDER/main_env.sh"

: "${UUID:?UUID cannot be empty}"

case "$ROLLBACK_VERSIONS_DIRECTORY" in
  *$'\n'*|*$'\r'*)
    echo "ROLLBACK_VERSIONS_DIRECTORY cannot contain newlines" >&2
    exit 1
    ;;
esac

# Render the path as a YAML single-quoted scalar. YAML escapes single quotes
# by doubling them, which keeps paths containing spaces, '#', ':' and quotes
# valid after envsubst renders the configuration.
escaped_rollback_directory=$(printf '%s' "$ROLLBACK_VERSIONS_DIRECTORY" | sed "s/'/''/g")
ROLLBACK_VERSIONS_DIRECTORY_YAML="'$escaped_rollback_directory'"
export ROLLBACK_VERSIONS_DIRECTORY_YAML

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
