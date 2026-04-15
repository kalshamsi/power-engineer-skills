#!/usr/bin/env bash
# Runs detection-rules.yaml against each fixture and compares to expected.md.
#
# Source of truth: power-engineer/references/modules/detection-rules.yaml
# Consumed by: Phase 5 fixtures in tests/fixtures/<name>/{package.json,...,expected.md}
#
# For each fixture directory under FIXTURES_DIR (default: tests/fixtures),
# evaluate every rule in detection-rules.yaml and build a "detected" array.
# Each line in expected.md of the form `- **DETECT**: <item>` must appear in
# that array, else the fixture fails.
#
# Detected-item formats (must match what expected.md writes).
# Canonical form: every entry is "key: value".
#   language:  "language: <name>"        e.g. language: typescript
#   framework: "framework: <name>"       e.g. framework: next.js
#   sdk:       "sdk: <name>"             e.g. sdk: anthropic-ts
#   cloud_db:  "cloud_db: <name>"        e.g. cloud_db: supabase
#   infra:     "<flag_name>: true"       e.g. has_docker: true
#   monorepo:  "monorepo: true"          (single flag)
#
# Exit codes:
#   0  all fixtures passed, OR no fixtures exist yet (Phase 5 hasn't built them)
#   1  at least one fixture failed, or yq/jq missing, or rules file missing
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

RULES="power-engineer/references/modules/detection-rules.yaml"
FIXTURES_DIR="${FIXTURES_DIR:-tests/fixtures}"
FAIL=0

fail() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

# --- Preflight: tools + rules file ---
command -v yq >/dev/null 2>&1 || {
  echo "  SKIP: yq not found — install via 'brew install yq' OR 'pip install yq'"
  exit 1
}
command -v jq >/dev/null 2>&1 || {
  echo "  SKIP: jq not found — install via 'brew install jq'"
  exit 1
}
[ -f "$RULES" ] || {
  echo "  FAIL: detection rules file missing: $RULES"
  exit 1
}

# Evaluates a single condition against a fixture directory.
# $1: fixture dir
# $2: condition key (file_exists|file_glob|dir_exists|
#                    package_json_has_dep|package_json_has_dep_prefix|python_dep)
# $3: value
evaluate_condition() {
  local dir="$1" key="$2" val="$3"
  case "$key" in
    file_exists)
      [ -f "$dir/$val" ]
      ;;
    file_glob)
      compgen -G "$dir/$val" > /dev/null
      ;;
    dir_exists)
      [ -d "$dir/$val" ]
      ;;
    package_json_has_dep)
      [ -f "$dir/package.json" ] && jq -e \
        --arg d "$val" '.dependencies[$d]? // .devDependencies[$d]? // empty' \
        "$dir/package.json" > /dev/null
      ;;
    package_json_has_dep_prefix)
      [ -f "$dir/package.json" ] && jq -e \
        --arg p "$val" '(.dependencies // {}) + (.devDependencies // {}) | keys | any(startswith($p))' \
        "$dir/package.json" > /dev/null
      ;;
    python_dep)
      { [ -f "$dir/requirements.txt" ] && grep -qiE "^$val(==|>=|~|\$)" "$dir/requirements.txt"; } \
        || { [ -f "$dir/pyproject.toml" ] && grep -qi "\"$val\"" "$dir/pyproject.toml"; }
      ;;
    *)
      echo "Unknown condition key: $key" >&2
      return 1
      ;;
  esac
}

# Evaluate a when-block at the given yq path.
# $1: fixture dir
# $2: yq rule_path (e.g. '.framework[0]', '.infra.has_docker', '.monorepo')
#
# Semantics:
#   when_any   OR  — any match → pass
#   when_all   AND — all must match → pass
#   unless_any NEG — any match → fail
# A missing block is treated as "not constraining".
# A rule with NO when_any AND NO when_all is treated as false (never matches).
evaluate_when() {
  local dir="$1" rule_path="$2"
  local has_any=false has_all=false
  local result=true
  local key val  # Bash dynamic scoping: without these, the inner read loops
                 # would clobber the caller's `key` (used by run_fixture's
                 # infra loop) — declare locally so emission sees the
                 # caller's key, not the last TSV entry read here.

  # when_any: any must pass
  if yq -e "$rule_path.when_any" "$RULES" > /dev/null 2>&1; then
    has_any=true
    result=false
    while IFS=$'\t' read -r key val; do
      if evaluate_condition "$dir" "$key" "$val"; then
        result=true; break
      fi
    done < <(yq -r "$rule_path.when_any[] | to_entries[] | [.key, .value] | @tsv" "$RULES")
  fi

  # when_all: all must pass
  if [ "$result" = true ] && yq -e "$rule_path.when_all" "$RULES" > /dev/null 2>&1; then
    has_all=true
    while IFS=$'\t' read -r key val; do
      if ! evaluate_condition "$dir" "$key" "$val"; then
        result=false; break
      fi
    done < <(yq -r "$rule_path.when_all[] | to_entries[] | [.key, .value] | @tsv" "$RULES")
  fi

  # If neither when_any nor when_all was present, treat as non-matching
  # (avoids silently matching every fixture for malformed rules).
  if [ "$has_any" = false ] && [ "$has_all" = false ]; then
    return 1
  fi

  # unless_any: any failing negates
  if [ "$result" = true ] && yq -e "$rule_path.unless_any" "$RULES" > /dev/null 2>&1; then
    while IFS=$'\t' read -r key val; do
      if evaluate_condition "$dir" "$key" "$val"; then
        result=false; break
      fi
    done < <(yq -r "$rule_path.unless_any[] | to_entries[] | [.key, .value] | @tsv" "$RULES")
  fi

  [ "$result" = true ]
}

# Run against one fixture
run_fixture() {
  local fixture="$1"
  local dir="$FIXTURES_DIR/$fixture"
  local expected="$dir/expected.md"
  [ -f "$expected" ] || { fail "$fixture: missing expected.md"; return; }

  echo "→ $fixture"
  local detected=()
  local count i name key

  # --- Languages (array of named entries) ---
  count=$(yq -r '.language | length' "$RULES")
  for i in $(seq 0 $((count - 1))); do
    name=$(yq -r ".language[$i].name" "$RULES")
    if evaluate_when "$dir" ".language[$i]"; then
      detected+=("language: $name")
    fi
  done

  # --- Frameworks (array of named entries) ---
  count=$(yq -r '.framework | length' "$RULES")
  for i in $(seq 0 $((count - 1))); do
    name=$(yq -r ".framework[$i].name" "$RULES")
    if evaluate_when "$dir" ".framework[$i]"; then
      detected+=("framework: $name")
    fi
  done

  # --- SDKs (array of named entries) ---
  count=$(yq -r '.sdk | length' "$RULES")
  for i in $(seq 0 $((count - 1))); do
    name=$(yq -r ".sdk[$i].name" "$RULES")
    if evaluate_when "$dir" ".sdk[$i]"; then
      detected+=("sdk: $name")
    fi
  done

  # --- Cloud/DB (array of named entries) ---
  count=$(yq -r '.cloud_db | length' "$RULES")
  for i in $(seq 0 $((count - 1))); do
    name=$(yq -r ".cloud_db[$i].name" "$RULES")
    if evaluate_when "$dir" ".cloud_db[$i]"; then
      detected+=("cloud_db: $name")
    fi
  done

  # --- Infra flags (object keyed by flag name; emitted as "<flag>: true") ---
  while IFS= read -r key; do
    [ -n "$key" ] || continue
    if evaluate_when "$dir" ".infra.$key"; then
      detected+=("$key: true")
    fi
  done < <(yq -r '.infra | keys[]' "$RULES")

  # --- Monorepo (single object; emitted as "monorepo: true") ---
  if evaluate_when "$dir" ".monorepo"; then
    detected+=("monorepo: true")
  fi

  # --- Verify each expected line is in detected ---
  while IFS= read -r line; do
    [[ "$line" =~ ^-[[:space:]]+\*\*DETECT\*\*:[[:space:]]+(.+)$ ]] || continue
    expected_item="${BASH_REMATCH[1]}"
    if ! printf '%s\n' "${detected[@]}" | grep -qxF "$expected_item"; then
      fail "$fixture: expected '$expected_item' but not detected"
    fi
  done < "$expected"
}

# --- Main loop: gracefully handle missing/empty fixtures dir (Phase 5 builds these) ---
if [ ! -d "$FIXTURES_DIR" ]; then
  echo "  (no fixtures found at '$FIXTURES_DIR' — Phase 5 will add them; skipping)"
  exit 0
fi

shopt -s nullglob
fixture_dirs=("$FIXTURES_DIR"/*/)
shopt -u nullglob

if [ ${#fixture_dirs[@]} -eq 0 ]; then
  echo "  (no fixtures found in '$FIXTURES_DIR' — Phase 5 will add them; skipping)"
  exit 0
fi

for f in "${fixture_dirs[@]}"; do
  fixture=$(basename "$f")
  run_fixture "$fixture"
done

[ "$FAIL" -eq 0 ] || exit 1
echo "  ✓ scanner rules verified against all fixtures"
