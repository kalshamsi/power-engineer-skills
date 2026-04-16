#!/usr/bin/env bash
# Validates install commands across catalog files.
# Accepts three forms:
#   1a. npx skills add <owner>/<repo> --skill <name> -y   (single skill — pinned at runtime)
#   1b. npx skills add <owner>/<repo> --all -y            (bulk install all skills in repo)
#   2. /plugin install <name>@<marketplace>
#   3. /plugin marketplace add <owner>/<repo>
# --skill and --all are mutually exclusive by CLI design.
# Rejects:
#   - npx skills@<anything> add ...        (version must NOT be hardcoded in catalog)
#   - npx skills add ... --global          (global installs forbidden)
#   - missing -y / --yes flag on npx form
#   - --all combined with --skill          (mutually exclusive flags)
set -uo pipefail

CATALOG="power-engineer/references/catalog"
FAIL_FILE=$(mktemp)
trap 'rm -f "$FAIL_FILE"' EXIT

fail() { echo "  FAIL: $*"; echo "1" >> "$FAIL_FILE"; }

# Collect all matching lines: file:lineno:cmd
LINES_FILE=$(mktemp)
trap 'rm -f "$FAIL_FILE" "$LINES_FILE"' EXIT

find "$CATALOG" -name '*.md' | xargs grep -nE '^(npx skills|/plugin)' 2>/dev/null > "$LINES_FILE" || true

while IFS= read -r raw_line; do
  # Format: /path/to/file.md:N:cmd
  f="${raw_line%%:*}"
  rest="${raw_line#*:}"
  line_no="${rest%%:*}"
  cmd="${rest#*:}"
  loc="$f:$line_no"

  # Rule A: no @version pin in catalog
  if echo "$cmd" | grep -qE '^npx skills@'; then
    fail "$loc: catalog must not pin version — use bare 'npx skills add' (pin injected at runtime)"
    continue
  fi

  # Rule B: no --global
  if echo "$cmd" | grep -q -- '--global'; then
    fail "$loc: --global is forbidden — all installs must be local"
  fi

  # Rule C: npx form must have -y, and must have either --skill <name>
  # (install one skill) or --all (install every skill in the repo).
  # --skill and --all are mutually exclusive by CLI design.
  if echo "$cmd" | grep -qE '^npx skills add'; then
    if echo "$cmd" | grep -q -- '--all'; then
      echo "$cmd" | grep -q -- '--skill' \
        && fail "$loc: --all and --skill are mutually exclusive"
    else
      echo "$cmd" | grep -q -- '--skill' || fail "$loc: missing --skill or --all flag"
    fi
    echo "$cmd" | grep -qE '(-y|--yes)\b' || fail "$loc: missing -y / --yes flag"
  fi

  # Rule D: plugin forms must be valid
  if echo "$cmd" | grep -qE '^/plugin install'; then
    echo "$cmd" | grep -qE '^/plugin install [a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+' \
      || fail "$loc: /plugin install must use name@marketplace format"
  fi
  if echo "$cmd" | grep -qE '^/plugin marketplace add'; then
    echo "$cmd" | grep -qE '^/plugin marketplace add [a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+' \
      || fail "$loc: /plugin marketplace add must use owner/repo format"
  fi
done < "$LINES_FILE"

FAIL=$(wc -l < "$FAIL_FILE" | tr -d ' ')
[ "$FAIL" -eq 0 ] || exit 1
echo "  ✓ install syntax OK"
