#!/usr/bin/env bash
# Manual behavioral validation of scanner module against fixtures.
# Uses `claude --bare -p` with the detection-rules module + fixture dir.
# Not wired into CI — manual reproduction only. See
# docs/superpowers/plans/v1.3.0-behavioral-validation.md for methodology.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODULES="$ROOT/power-engineer/references/modules"
FIXTURES="$ROOT/tests/fixtures"
WORK="/tmp/pe-behavioral-$$"
MODEL="${MODEL:-claude-sonnet-4-6}"

# Fail fast if key not set (bare mode requires env-var auth)
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  echo "ERROR: ANTHROPIC_API_KEY not set." >&2
  echo "  Export it in your shell (do not print the value):" >&2
  echo "    set -a; source .env; set +a   # if using .env" >&2
  echo "    export ANTHROPIC_API_KEY=...  # direct" >&2
  exit 1
fi

# Sanity: verify the command exists
command -v claude >/dev/null || { echo "ERROR: 'claude' CLI not found" >&2; exit 1; }

mkdir -p "$WORK"
trap 'rm -rf "$WORK"' EXIT

PROMPT='Read scanner.md and detection-rules.yaml from the added directory. Those are the scanner module and its detection rules. Apply those rules to the current working directory (the project being scanned). List EVERY detection in this exact format, one per line, nothing else — no preamble, no explanations, no headings:

language: <name>
framework: <name>
sdk: <name>
cloud_db: <name>
<flag>: true

Valid detection kinds: language, framework, sdk, cloud_db, monorepo, has_docker, has_terraform, has_ci_cd, has_tailwind. Emit nothing for kinds that do not apply. Do not invent detections. Do not guess.'

FAIL=0
for dir in "$FIXTURES"/*/; do
  fixture=$(basename "$dir")
  echo "=== $fixture ==="

  # Expected: parse DETECT lines from expected.md
  grep -oE '^- \*\*DETECT\*\*: .+$' "$dir/expected.md" \
    | sed 's/^- \*\*DETECT\*\*: //' | sort > "$WORK/$fixture.expected"

  # Actual: run claude with expected.md blocked
  (cd "$dir" && claude --bare -p \
    --model "$MODEL" \
    --add-dir "$MODULES" \
    --disallowedTools 'Read(**/expected.md)' \
    "$PROMPT") > "$WORK/$fixture.raw" 2>&1

  grep -E '^(language|framework|sdk|cloud_db|monorepo|has_[a-z_]+):' \
    "$WORK/$fixture.raw" | sort > "$WORK/$fixture.actual"

  if diff -q "$WORK/$fixture.expected" "$WORK/$fixture.actual" >/dev/null; then
    echo "  ✓ MATCH"
  else
    echo "  ✗ MISMATCH"
    diff "$WORK/$fixture.expected" "$WORK/$fixture.actual" | sed 's/^/    /'
    FAIL=$((FAIL + 1))
  fi
done

if [ "$FAIL" -eq 0 ]; then
  echo ""
  echo "All fixtures MATCH."
else
  echo ""
  echo "$FAIL fixture(s) MISMATCH" >&2
  exit 1
fi
