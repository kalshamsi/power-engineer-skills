#!/usr/bin/env bash
# Self-test for scripts/catalog-diff.sh
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT" || exit 2

FAIL=0
pass() { echo "  PASS: $*"; }
fail() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

# Test 1: --ci-check on current branch (catalog clean)
if ./scripts/catalog-diff.sh --ci-check >/dev/null 2>&1; then
  pass "--ci-check exits 0 on catalog-clean branch"
else
  fail "--ci-check should exit 0 on this branch (no catalog changes from baseline)"
fi

# Test 2: --ref-diff v1.3.0 v1.4.0 detects 7 added skills
output=$(./scripts/catalog-diff.sh --ref-diff v1.3.0 v1.4.0 --format=changelog 2>&1)
if echo "$output" | grep -q "tavily-best-practices" && \
   echo "$output" | grep -q "stitch-design"; then
  pass "--ref-diff v1.3.0 v1.4.0 detects known additions"
else
  fail "--ref-diff v1.3.0 v1.4.0 should list 7 added skills"
fi

# Test 3: --ref-diff v1.4.0 v1.4.1 reports 'unchanged'
output=$(./scripts/catalog-diff.sh --ref-diff v1.4.0 v1.4.1 --format=changelog 2>&1)
if echo "$output" | grep -qE "unchanged|none"; then
  pass "--ref-diff v1.4.0 v1.4.1 reports unchanged"
else
  fail "--ref-diff v1.4.0 v1.4.1 should report unchanged catalog"
fi

# Test 4: --format=json validates as JSON with required keys
# IMPORTANT: Use has(...) and has(...) chain, NOT comma-list (R1 finding):
#   jq -e '.a, .b, ...' silently passes if any key except the last is missing.
#   jq -e 'has("a") and has("b") and ...' validates all keys correctly.
if ./scripts/catalog-diff.sh --ref-diff v1.4.0 v1.4.1 --format=json 2>/dev/null | \
   jq -e 'has("added") and has("removed") and has("renamed") and has("structural") and has("row_count_delta")' >/dev/null 2>&1; then
  pass "--format=json produces valid JSON with all 5 required keys"
else
  fail "--format=json should produce valid JSON with all 5 required keys"
fi

# Test 5: hostile-input rejection (command-substitution in ref)
# shellcheck disable=SC2016
# (single-quote is intentional — the literal string '$(rm -rf /)' MUST be
# passed unexpanded; the whole point is verifying it gets rejected.)
if ./scripts/catalog-diff.sh --ref-diff '$(rm -rf /)' HEAD >/dev/null 2>&1; then
  fail "hostile ref should be rejected (got exit 0)"
else
  pass "hostile ref rejected with non-zero exit"
fi

# Test 6: mutually-exclusive mode flags rejected
if ./scripts/catalog-diff.sh --ref-diff a b --version-diff 1.0.0 1.1.0 >/dev/null 2>&1; then
  fail "conflicting mode flags should be rejected (got exit 0)"
else
  pass "conflicting mode flags rejected"
fi

# Test 7: --format=changelog emits row-count math line when REMOVED is
# non-empty AND STRUCTURAL[] is empty (Task 2.3 dogfood fix). The v1.4.1 ->
# HEAD case removes mcp-security-audit (1 row) without any whole-file
# additions/removals — exactly the divergence the fix targets. Match on
# substrings so future row-count drift doesn't make the test brittle.
output=$(./scripts/catalog-diff.sh --ref-diff v1.4.1 HEAD --format=changelog 2>&1)
if echo "$output" | grep -qE "Structural changes:.*row count.*231.*230"; then
  pass "--format=changelog emits row-count math when ADDED/REMOVED non-empty + STRUCTURAL empty"
else
  fail "--format=changelog should emit 'Structural changes: ... row count 231 -> 230 ...' for v1.4.1 -> HEAD"
fi

if [ "$FAIL" -eq 0 ]; then
  echo "  ✓ catalog-diff.sh self-test: all 7 cases passed"
  exit 0
else
  echo "  ✗ catalog-diff.sh self-test: $FAIL failures"
  exit 1
fi
