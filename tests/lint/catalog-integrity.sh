#!/usr/bin/env bash
# Validates catalog structure: 4-column schema, install block per section,
# INDEX.md ↔ catalog file symmetry, no duplicate skill names.
# Compatible with bash 3.2+ (macOS default).
set -uo pipefail

CATALOG="power-engineer/references/catalog"
INDEX="$CATALOG/INDEX.md"
FAIL=0

fail() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
pass() { echo "  PASS: $*"; }

# Check 1: INDEX.md exists
[ -f "$INDEX" ] || { fail "INDEX.md missing at $INDEX"; exit 1; }

# Check 2: every file listed in INDEX exists; every file on disk is listed
# bash 3.2-compatible: read into array via while loop
INDEXED=()
while IFS= read -r f; do
  INDEXED+=("$f")
done < <(grep -oE '\[[^]]+\]\(([^)]+\.md)\)' "$INDEX" | grep -oE '\([^)]+\)' | tr -d '()')

ON_DISK=()
while IFS= read -r f; do
  ON_DISK+=("$f")
done < <(cd "$CATALOG" && find . -name '*.md' -not -name 'INDEX.md' | sed 's|^\./||' | sort)

for f in "${INDEXED[@]}"; do
  [ -f "$CATALOG/$f" ] || fail "INDEX lists $f but file missing"
done
for f in "${ON_DISK[@]}"; do
  grep -q "($f)" "$INDEX" || fail "$f on disk but not in INDEX"
done

# Check 3: every catalog file has at least one 4-column table
for f in "${ON_DISK[@]}"; do
  path="$CATALOG/$f"
  if ! grep -qE '^\| Skill \| Description \| Trigger \| When to use \|' "$path"; then
    fail "$f missing required 4-column header (Skill/Description/Trigger/When to use)"
  fi
done

# Check 4: every catalog file has at least one install block (``` fenced)
for f in "${ON_DISK[@]}"; do
  path="$CATALOG/$f"
  if ! grep -qE '^(npx skills add|/plugin install|/plugin marketplace add)' "$path"; then
    fail "$f has no install command"
  fi
done

# Check 5: no duplicate skill names across all catalog files
# Extract skill name = first cell in data rows (after header)
DUPES=$(find "$CATALOG" -name '*.md' -not -name 'INDEX.md' -exec awk -F'|' '
  /^\| Skill \| Description \|/ { in_table=1; next }
  /^\|[-: ]+\|/ && in_table==1 { next }
  /^\|/ && in_table==1 { gsub(/^ +| +$/, "", $2); print $2 }
  !/^\|/ { in_table=0 }
' {} \; | sort | uniq -d)

if [ -n "$DUPES" ]; then
  echo "$DUPES" | while read -r dup; do fail "duplicate skill name: $dup"; done
fi

# Check 6: skill count matches README badge
CATALOG_COUNT=$(find "$CATALOG" -name '*.md' -not -name 'INDEX.md' -exec awk -F'|' '
  /^\| Skill \| Description \|/ { in_table=1; next }
  /^\|[-: ]+\|/ && in_table==1 { next }
  /^\|/ && in_table==1 { print $2 }
  !/^\|/ { in_table=0 }
' {} \; | wc -l | tr -d ' ')

BADGE_COUNT=$(grep -oE 'skills-[0-9]+' README.md | head -1 | grep -oE '[0-9]+')
if [ "$CATALOG_COUNT" != "$BADGE_COUNT" ]; then
  fail "README badge says $BADGE_COUNT skills but catalog has $CATALOG_COUNT rows"
else
  pass "skill count: $CATALOG_COUNT (matches README badge)"
fi

[ "$FAIL" -eq 0 ] || exit 1
echo "  ✓ catalog integrity OK"
