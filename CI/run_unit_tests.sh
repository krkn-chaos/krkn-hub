#!/usr/bin/env bash
# Runs every lightweight unit test in CI/tests/ (files named test_*.sh).
# These tests must not need a cluster or a container runtime.
# Exits non-zero if any test fails, after running all of them.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$ROOT/CI/tests"

shopt -s nullglob
tests=("$TEST_DIR"/test_*.sh)
if [ "${#tests[@]}" -eq 0 ]; then
  echo "No unit tests found in $TEST_DIR" >&2
  exit 1
fi

failed=()
for t in "${tests[@]}"; do
  name="$(basename "$t")"
  echo "=== $name"
  if bash "$t"; then
    echo "--- ok: $name"
  else
    echo "--- FAILED: $name"
    failed+=("$name")
  fi
done

echo
echo "Ran ${#tests[@]} unit test(s), ${#failed[@]} failed."
if [ "${#failed[@]}" -gt 0 ]; then
  printf '  - %s\n' "${failed[@]}"
  exit 1
fi
