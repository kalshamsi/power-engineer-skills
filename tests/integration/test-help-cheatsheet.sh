#!/usr/bin/env bash
# Integration tests for help flow and cheatsheet generator
# Tests: help.md exists and references state.json, handles missing state.json,
#        configurator references cheatsheet, router has help route

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "=== Help Flow + Cheatsheet Tests ==="
echo ""

# --- Test 1: help.md file exists ---
echo "Test 1: help.md exists"
if [[ -f "$REPO_ROOT/power-engineer/references/flows/help.md" ]]; then
  pass "references/flows/help.md exists"
else
  fail "references/flows/help.md not found"
fi

# --- Test 2: help.md references state.json ---
echo "Test 2: help.md references state.json"
if grep -q "state.json" "$REPO_ROOT/power-engineer/references/flows/help.md"; then
  pass "help.md references state.json"
else
  fail "help.md does not reference state.json"
fi

# --- Test 3: help.md handles missing state.json with clear message ---
echo "Test 3: help.md handles missing state.json"
if grep -q "No Power Engineer setup found" "$REPO_ROOT/power-engineer/references/flows/help.md"; then
  pass "help.md has 'No Power Engineer setup found' message"
else
  fail "help.md missing 'No Power Engineer setup found' message"
fi

# --- Test 4: help.md instructs to run /power-engineer first ---
echo "Test 4: help.md instructs user to run /power-engineer"
if grep -q "Run \`/power-engineer\` first" "$REPO_ROOT/power-engineer/references/flows/help.md"; then
  pass "help.md instructs user to run /power-engineer first"
else
  fail "help.md does not instruct user to run /power-engineer first"
fi

# --- Test 5: help.md groups skills by category ---
echo "Test 5: help.md groups skills by category"
if grep -q "catalog category" "$REPO_ROOT/power-engineer/references/flows/help.md" || \
   grep -q "Group" "$REPO_ROOT/power-engineer/references/flows/help.md"; then
  pass "help.md instructs grouping by category"
else
  fail "help.md does not mention grouping by category"
fi

# --- Test 6: help.md excludes MCP servers ---
echo "Test 6: help.md excludes MCP servers"
if grep -q "MCP server" "$REPO_ROOT/power-engineer/references/flows/help.md"; then
  pass "help.md mentions exclusion of MCP servers"
else
  fail "help.md does not mention MCP server exclusion"
fi

# --- Test 7: configurator.md references cheatsheet generation ---
echo "Test 7: configurator.md references cheatsheet generation"
if grep -q "cheatsheet.md" "$REPO_ROOT/power-engineer/references/modules/configurator.md"; then
  pass "configurator.md references cheatsheet.md"
else
  fail "configurator.md does not reference cheatsheet.md"
fi

# --- Test 8: configurator.md has Step 5 as cheatsheet step ---
echo "Test 8: configurator.md Step 5 is cheatsheet generation"
if grep -q "Step 5: Generate cheatsheet" "$REPO_ROOT/power-engineer/references/modules/configurator.md"; then
  pass "configurator.md Step 5 is 'Generate cheatsheet'"
else
  fail "configurator.md Step 5 is not 'Generate cheatsheet'"
fi

# --- Test 9: configurator.md has Step 6 as summary ---
echo "Test 9: configurator.md Step 6 is configuration summary"
if grep -q "Step 6: Present configuration summary" "$REPO_ROOT/power-engineer/references/modules/configurator.md"; then
  pass "configurator.md Step 6 is 'Present configuration summary'"
else
  fail "configurator.md Step 6 is not 'Present configuration summary'"
fi

# --- Test 10: post-install summary mentions cheatsheet file location ---
echo "Test 10: post-install summary mentions cheatsheet location"
if grep -A 20 "Step 6: Present configuration summary" "$REPO_ROOT/power-engineer/references/modules/configurator.md" | \
   grep -q "cheatsheet"; then
  pass "post-install summary mentions cheatsheet"
else
  fail "post-install summary does not mention cheatsheet"
fi

# --- Test 11: cheatsheet contains only installed skills (not full catalog) ---
echo "Test 11: configurator cheatsheet uses installed_skills from state.json"
if grep -q "installed_skills" "$REPO_ROOT/power-engineer/references/modules/configurator.md" || \
   grep -q "state.json" "$REPO_ROOT/power-engineer/references/modules/configurator.md"; then
  pass "configurator cheatsheet references state.json installed_skills"
else
  fail "configurator cheatsheet does not reference state.json"
fi

# --- Test 12: SKILL.md routes "power engineer help" to help.md ---
echo "Test 12: SKILL.md routes 'power engineer help' to help.md"
if grep -q "power engineer help" "$REPO_ROOT/power-engineer/SKILL.md" && \
   grep -q "references/flows/help.md" "$REPO_ROOT/power-engineer/SKILL.md"; then
  pass "SKILL.md routes 'power engineer help' to references/flows/help.md"
else
  fail "SKILL.md does not route 'power engineer help' to help.md"
fi

# --- Test 13: help route is placed before the fallback row ---
echo "Test 13: help route is placed before the fallback row"
HELP_LINE=$(grep -n "power engineer help" "$REPO_ROOT/power-engineer/SKILL.md" | cut -d: -f1)
FALLBACK_LINE=$(grep -n "anything else" "$REPO_ROOT/power-engineer/SKILL.md" | cut -d: -f1)
if [[ -n "$HELP_LINE" && -n "$FALLBACK_LINE" && "$HELP_LINE" -lt "$FALLBACK_LINE" ]]; then
  pass "help route (line $HELP_LINE) is before fallback row (line $FALLBACK_LINE)"
else
  fail "help route is not correctly ordered before fallback row"
fi

# --- Test 14: SKILL.md line count stays under 55 lines ---
echo "Test 14: SKILL.md stays under 55 lines"
LINE_COUNT=$(wc -l < "$REPO_ROOT/power-engineer/SKILL.md")
if [[ "$LINE_COUNT" -lt 55 ]]; then
  pass "SKILL.md has $LINE_COUNT lines (under 55)"
else
  fail "SKILL.md has $LINE_COUNT lines (exceeds 55 line limit)"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
