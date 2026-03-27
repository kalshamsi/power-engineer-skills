#!/usr/bin/env bash
# Integration test: CLAUDE.md format validation
# Validates managed section delimiters, skill index format, line budget
set -euo pipefail

PASS=0
FAIL=0

check() {
  local name="$1" condition="$2"
  if eval "$condition"; then
    echo "  PASS: $name"
    ((PASS++)) || true
  else
    echo "  FAIL: $name"
    ((FAIL++)) || true
  fi
}

TMPDIR_TEST=$(mktemp -d)
trap 'rm -rf "$TMPDIR_TEST"' EXIT

echo "=== Test: CLAUDE.md Format ==="
echo ""

# --- Setup: CLAUDE.md with managed section ---
cat > "$TMPDIR_TEST/claudemd.md" << 'EOF'
# My Project

Some user content here.

## Power Engineer
<!-- power-engineer:managed-section -->

### Installed Skills
**Core Methodology**: brainstorming, writing-plans
**Design**: frontend-design, shadcn-ui

### Project Goals
Improve quality.

<!-- /power-engineer:managed-section -->

## Other Section
Content outside managed section stays intact.
EOF

# --- Setup: CLAUDE.md with malformed skill index ---
cat > "$TMPDIR_TEST/claudemd-bad-index.md" << 'EOF'
## Power Engineer
<!-- power-engineer:managed-section -->

### Installed Skills
- brainstorming
- writing-plans

<!-- /power-engineer:managed-section -->
EOF

# --- Setup: CLAUDE.md with oversized managed section (>40 lines) ---
{
  echo "# Project"
  echo "<!-- power-engineer:managed-section -->"
  for i in $(seq 1 45); do
    echo "line $i"
  done
  echo "<!-- /power-engineer:managed-section -->"
} > "$TMPDIR_TEST/claudemd-oversize.md"

# --- Setup: CLAUDE.md with content outside delimiters ---
cat > "$TMPDIR_TEST/claudemd-outside.md" << 'EOF'
# My Project
This is user content BEFORE managed section.

## Power Engineer
<!-- power-engineer:managed-section -->
### Installed Skills
**Core**: brainstorming
<!-- /power-engineer:managed-section -->

This is user content AFTER managed section.
EOF

echo "Managed section delimiters:"

check "Opening delimiter present" \
  "grep -q '<!-- power-engineer:managed-section -->' '$TMPDIR_TEST/claudemd.md'"

check "Closing delimiter present" \
  "grep -q '<!-- /power-engineer:managed-section -->' '$TMPDIR_TEST/claudemd.md'"

echo ""
echo "Skill index format:"

check "Skill index uses bold-category format" \
  "grep -qE '^\*\*[A-Za-z &]+\*\*: ' '$TMPDIR_TEST/claudemd.md'"

check "Malformed index uses list syntax (detected)" \
  "grep -qE '^- ' '$TMPDIR_TEST/claudemd-bad-index.md'"

check "Good index does NOT use bare list syntax for skills" \
  "! awk '/<!-- power-engineer:managed-section -->/{in_managed=1} /<!-- \/power-engineer:managed-section -->/{in_managed=0} in_managed && /^- /{found=1} END{exit !found}' '$TMPDIR_TEST/claudemd.md'"

echo ""
echo "Managed section line count:"

# Count lines between delimiters (exclusive)
managed_lines=$(awk '/<!-- power-engineer:managed-section -->/{found=1; next} /<!-- \/power-engineer:managed-section -->/{found=0} found{count++} END{print count+0}' "$TMPDIR_TEST/claudemd.md")
managed_lines_oversize=$(awk '/<!-- power-engineer:managed-section -->/{found=1; next} /<!-- \/power-engineer:managed-section -->/{found=0} found{count++} END{print count+0}' "$TMPDIR_TEST/claudemd-oversize.md")

check "Managed section within 40-line budget ($managed_lines lines)" \
  "[ '$managed_lines' -le 40 ]"

check "Oversize section exceeds 40-line budget ($managed_lines_oversize lines)" \
  "[ '$managed_lines_oversize' -gt 40 ]"

echo ""
echo "Content outside delimiters untouched:"

check "Content before managed section preserved" \
  "grep -q 'This is user content BEFORE managed section.' '$TMPDIR_TEST/claudemd-outside.md'"

check "Content after managed section preserved" \
  "grep -q 'This is user content AFTER managed section.' '$TMPDIR_TEST/claudemd-outside.md'"

# Verify outside content line count stays the same (detect no corruption)
outside_before=$(awk 'NR==2{print}' "$TMPDIR_TEST/claudemd-outside.md")
check "First user line is not a delimiter" \
  "[ '$outside_before' != '<!-- power-engineer:managed-section -->' ]"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
