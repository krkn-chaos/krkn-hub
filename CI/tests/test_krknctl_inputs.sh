#!/usr/bin/env bash
# Lightweight unit test: validate every scenario's krknctl-input.json.
# No cluster or container required. Requires jq.
#
# Checks:
#   - the file is a non-empty array of field objects
#   - each field has non-empty string name, short_description,
#     description, variable and type
#   - type is one krknctl understands
#   - name and variable are unique within the file
#   - "required", when present, is "true" or "false"
#   - number defaults are numeric, boolean defaults are "true"/"false"
#   - enum fields have allowed_values and their default is one of them
#   - a default passes the field's own validator regex
set -eo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

if ! command -v jq >/dev/null 2>&1; then
  echo "FAIL: jq not found" >&2
  exit 1
fi

shopt -s nullglob
files=(*/krknctl-input.json)
if [ "${#files[@]}" -eq 0 ]; then
  echo "FAIL: no krknctl-input.json files found" >&2
  exit 1
fi

# Prints one line per problem found in the file passed as input.
read -r -d '' CHECKS <<'JQ' || true
def known_types: ["string", "number", "boolean", "enum", "file", "file_base64", "Group", "group"];

def dups(f): [.[] | f | select(. != null)] | group_by(.) | map(select(length > 1) | .[0]);

# A default counts as set unless it is missing, null or "". An explicit
# false is set, so it still gets checked against the field's type.
def has_default: .default != null and .default != "";

if type != "array" then "expected a JSON array of fields, got \(type)"
elif length == 0 then "no fields defined"
else
  (.[] | select(type != "object") | "expected a field object, got \(type)"),
  ([.[] | select(type == "object")] |
    (dups(.name)[] | "duplicate name '\(.)'"),
    (dups(.variable)[] | "duplicate variable '\(.)'"),
    (.[] | . as $f | ($f.name // "<unnamed>" | tostring) as $n |
      (["name", "short_description", "description", "variable", "type"][]
         | select(($f[.] | type) != "string" or $f[.] == "")
         | "\($n): '\(.)' must be a non-empty string"),
      (select(($f.type | type) == "string" and $f.type != "" and ($f.type | IN(known_types[]) | not))
         | "\($n): unknown type '\($f.type)'"),
      (select($f.required != null and ($f.required | IN("true", "false") | not))
         | "\($n): required must be \"true\" or \"false\", got \($f.required | tojson)"),
      (select($f.type == "number" and ($f | has_default)
              and ($f.default | tostring | test("^-?[0-9]+(\\.[0-9]+)?$") | not))
         | "\($n): number default \($f.default | tojson) is not numeric"),
      (select($f.type == "boolean" and ($f | has_default)
              and ($f.default | tostring | ascii_downcase | IN("true", "false") | not))
         | "\($n): boolean default \($f.default | tojson) is not true/false"),
      (select($f.type == "enum" and (($f.allowed_values | type) != "string" or $f.allowed_values == ""))
         | "\($n): enum has no allowed_values"),
      (select($f.type == "enum" and ($f.allowed_values | type) == "string" and $f.allowed_values != ""
              and ($f | has_default)
              and (($f.default | tostring) as $d
                   | $f.allowed_values | split($f.separator // ",") | index($d) | not))
         | "\($n): enum default \($f.default | tojson) is not in allowed_values '\($f.allowed_values)'"),
      (select(($f.validator // "") != "" and ($f | has_default)
              and ($f.default | tostring | test($f.validator) | not))
         | "\($n): default \($f.default | tojson) does not match its validator")
    )
  )
end
JQ

errors=0
for f in "${files[@]}"; do
  if ! problems="$(jq -r "$CHECKS" "$f" 2>&1)"; then
    echo "FAIL: $f: could not be checked: $problems" >&2
    errors=$((errors + 1))
    continue
  fi
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    echo "FAIL: $f: $p" >&2
    errors=$((errors + 1))
  done <<< "$problems"
done

if [ "$errors" -gt 0 ]; then
  echo "FAIL: $errors problem(s) in krknctl-input.json files" >&2
  exit 1
fi

echo "PASS: krknctl-input.json files (${#files[@]} checked)"
