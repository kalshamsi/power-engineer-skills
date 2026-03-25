#!/usr/bin/env bash
# tests/integration/test-stable-api.sh
# Phase 5: Stable API Validation — verifies all 14 commands are routed in SKILL.md
# and that each target file exists on disk.

set -euo pipefail

SKILL_MD="/Users/khalfan/Documents/Development/power-engineer-skills/power-engineer/SKILL.md"
BASE_DIR="/Users/khalfan/Documents/Development/power-engineer-skills/power-engineer"

PASS=0
FAIL=0

check() {
  local description="$1"
  local result="$2"
  if [ "$result" = "pass" ]; then
    echo "  PASS: $description"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $description"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
echo "=== Phase 5: Stable API Validation ==="
echo ""

echo "--- Route presence in SKILL.md ---"

# 1. power-engineer (full interview)
grep -q "full-interview.md" "$SKILL_MD" && check "power-engineer -> full-interview.md route present" "pass" || check "power-engineer -> full-interview.md route present" "fail"

# 2. quick
grep -q "quick.md" "$SKILL_MD" && check "quick -> quick.md route present" "pass" || check "quick -> quick.md route present" "fail"

# 3. frontend
grep -q "frontend.md" "$SKILL_MD" && check "frontend -> frontend.md route present" "pass" || check "frontend -> frontend.md route present" "fail"

# 4. backend
grep -q "backend.md" "$SKILL_MD" && check "backend -> backend.md route present" "pass" || check "backend -> backend.md route present" "fail"

# 5. devops
grep -q "devops.md" "$SKILL_MD" && check "devops -> devops.md route present" "pass" || check "devops -> devops.md route present" "fail"

# 6. ai
grep -q "flows/ai.md" "$SKILL_MD" && check "ai -> ai.md route present" "pass" || check "ai -> ai.md route present" "fail"

# 7. data
grep -q "data.md" "$SKILL_MD" && check "data -> data.md route present" "pass" || check "data -> data.md route present" "fail"

# 8. docs
grep -q "flows/docs.md" "$SKILL_MD" && check "docs -> docs.md route present" "pass" || check "docs -> docs.md route present" "fail"

# 9. mobile
grep -q "mobile.md" "$SKILL_MD" && check "mobile -> mobile.md route present" "pass" || check "mobile -> mobile.md route present" "fail"

# 10. status
grep -q "drift-detector.md" "$SKILL_MD" && check "status -> drift-detector.md route present" "pass" || check "status -> drift-detector.md route present" "fail"

# 11. update
grep -q "update.md" "$SKILL_MD" && check "update -> update.md route present" "pass" || check "update -> update.md route present" "fail"

# 12. catalog
grep -q "catalog-browse.md" "$SKILL_MD" && check "catalog -> catalog-browse.md route present" "pass" || check "catalog -> catalog-browse.md route present" "fail"

# 13. help
grep -q "help.md" "$SKILL_MD" && check "help -> help.md route present" "pass" || check "help -> help.md route present" "fail"

# 14. configure
grep -q "configure.md" "$SKILL_MD" && check "configure -> configure.md route present" "pass" || check "configure -> configure.md route present" "fail"

echo ""
echo "--- Target file existence ---"

# 1. full-interview.md
[ -f "$BASE_DIR/references/flows/full-interview.md" ] && check "references/flows/full-interview.md exists" "pass" || check "references/flows/full-interview.md exists" "fail"

# 2. quick.md
[ -f "$BASE_DIR/references/flows/quick.md" ] && check "references/flows/quick.md exists" "pass" || check "references/flows/quick.md exists" "fail"

# 3. frontend.md
[ -f "$BASE_DIR/references/flows/frontend.md" ] && check "references/flows/frontend.md exists" "pass" || check "references/flows/frontend.md exists" "fail"

# 4. backend.md
[ -f "$BASE_DIR/references/flows/backend.md" ] && check "references/flows/backend.md exists" "pass" || check "references/flows/backend.md exists" "fail"

# 5. devops.md
[ -f "$BASE_DIR/references/flows/devops.md" ] && check "references/flows/devops.md exists" "pass" || check "references/flows/devops.md exists" "fail"

# 6. ai.md
[ -f "$BASE_DIR/references/flows/ai.md" ] && check "references/flows/ai.md exists" "pass" || check "references/flows/ai.md exists" "fail"

# 7. data.md
[ -f "$BASE_DIR/references/flows/data.md" ] && check "references/flows/data.md exists" "pass" || check "references/flows/data.md exists" "fail"

# 8. docs.md
[ -f "$BASE_DIR/references/flows/docs.md" ] && check "references/flows/docs.md exists" "pass" || check "references/flows/docs.md exists" "fail"

# 9. mobile.md
[ -f "$BASE_DIR/references/flows/mobile.md" ] && check "references/flows/mobile.md exists" "pass" || check "references/flows/mobile.md exists" "fail"

# 10. drift-detector.md
[ -f "$BASE_DIR/references/modules/drift-detector.md" ] && check "references/modules/drift-detector.md exists" "pass" || check "references/modules/drift-detector.md exists" "fail"

# 11. update.md
[ -f "$BASE_DIR/references/flows/update.md" ] && check "references/flows/update.md exists" "pass" || check "references/flows/update.md exists" "fail"

# 12. catalog-browse.md
[ -f "$BASE_DIR/references/flows/catalog-browse.md" ] && check "references/flows/catalog-browse.md exists" "pass" || check "references/flows/catalog-browse.md exists" "fail"

# 13. help.md
[ -f "$BASE_DIR/references/flows/help.md" ] && check "references/flows/help.md exists" "pass" || check "references/flows/help.md exists" "fail"

# 14. configure.md
[ -f "$BASE_DIR/references/flows/configure.md" ] && check "references/flows/configure.md exists" "pass" || check "references/flows/configure.md exists" "fail"

echo ""
echo "--- No orphaned routes check ---"

# Extract all references/... .md paths from the router table and verify each exists
REFS=$(grep -oE 'references/[^`]+\.md' "$SKILL_MD" | sort -u)
for ref in $REFS; do
  if [ -f "$BASE_DIR/$ref" ]; then
    check "No orphan: $ref" "pass"
  else
    check "No orphan: $ref" "fail"
  fi
done

echo ""
echo "=============================="
echo "Results: $PASS passed, $FAIL failed"
echo "=============================="
echo ""

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
