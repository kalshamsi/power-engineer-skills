#!/usr/bin/env bash
# Integration tests for configure flow and auto-drift preference
# Tests: configure.md exists, state schema has preferences, drift-detector
#        references auto_update, handles missing preferences, router has configure route

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "=== Configure Flow + Auto-Drift Tests ==="
echo ""

# --- Test 1: configure.md file exists ---
echo "Test 1: configure.md exists"
if [[ -f "$REPO_ROOT/power-engineer/references/flows/configure.md" ]]; then
  pass "references/flows/configure.md exists"
else
  fail "references/flows/configure.md not found"
fi

# --- Test 2: configure.md checks for state.json existence ---
echo "Test 2: configure.md checks for state.json"
if grep -q "state.json" "$REPO_ROOT/power-engineer/references/flows/configure.md"; then
  pass "configure.md references state.json"
else
  fail "configure.md does not reference state.json"
fi

# --- Test 3: configure.md handles missing state.json with clear message ---
echo "Test 3: configure.md handles missing state.json"
if grep -q "No Power Engineer setup found" "$REPO_ROOT/power-engineer/references/flows/configure.md"; then
  pass "configure.md has 'No Power Engineer setup found' message"
else
  fail "configure.md missing 'No Power Engineer setup found' message"
fi

# --- Test 4: configure.md reads preferences object ---
echo "Test 4: configure.md reads preferences"
if grep -q "preferences" "$REPO_ROOT/power-engineer/references/flows/configure.md"; then
  pass "configure.md references preferences object"
else
  fail "configure.md does not reference preferences object"
fi

# --- Test 5: configure.md handles missing preferences with defaults ---
echo "Test 5: configure.md handles missing preferences gracefully"
if grep -q "no.*preferences\|no \`preferences\`\|no preferences\|If no \`preferences\`" "$REPO_ROOT/power-engineer/references/flows/configure.md"; then
  pass "configure.md handles missing preferences with defaults"
else
  fail "configure.md does not handle missing preferences"
fi

# --- Test 6: configure.md validates security_level values ---
echo "Test 6: configure.md validates security_level values"
if grep -q "standard.*enhanced.*maximum\|Validate.*security_level" "$REPO_ROOT/power-engineer/references/flows/configure.md"; then
  pass "configure.md validates security_level values"
else
  fail "configure.md does not validate security_level values"
fi

# --- Test 7: configure.md includes all valid security_level options ---
echo "Test 7: configure.md includes all valid security_level options"
CONFIGURE_FILE="$REPO_ROOT/power-engineer/references/flows/configure.md"
if grep -q "standard" "$CONFIGURE_FILE" && \
   grep -q "enhanced" "$CONFIGURE_FILE" && \
   grep -q "maximum" "$CONFIGURE_FILE" && \
   grep -q "compliance" "$CONFIGURE_FILE" && \
   grep -q "custom" "$CONFIGURE_FILE"; then
  pass "configure.md includes all valid security_level options"
else
  fail "configure.md is missing one or more security_level options"
fi

# --- Test 8: configure.md includes auto_update option ---
echo "Test 8: configure.md includes auto_update option"
if grep -q "auto_update\|Auto-Update\|auto-update" "$REPO_ROOT/power-engineer/references/flows/configure.md"; then
  pass "configure.md includes auto_update option"
else
  fail "configure.md does not include auto_update option"
fi

# --- Test 9: state schema in configurator.md includes preferences object ---
echo "Test 9: configurator.md state schema includes preferences object"
if grep -q '"preferences"' "$REPO_ROOT/power-engineer/references/modules/configurator.md"; then
  pass "configurator.md state schema includes preferences object"
else
  fail "configurator.md state schema missing preferences object"
fi

# --- Test 10: preferences schema includes security_level ---
echo "Test 10: configurator.md preferences includes security_level"
if grep -q '"security_level"' "$REPO_ROOT/power-engineer/references/modules/configurator.md"; then
  pass "configurator.md preferences includes security_level"
else
  fail "configurator.md preferences missing security_level"
fi

# --- Test 11: preferences schema includes auto_update ---
echo "Test 11: configurator.md preferences includes auto_update"
if grep -q '"auto_update"' "$REPO_ROOT/power-engineer/references/modules/configurator.md"; then
  pass "configurator.md preferences includes auto_update"
else
  fail "configurator.md preferences missing auto_update"
fi

# --- Test 12: preferences default security_level is standard ---
echo "Test 12: configurator.md preferences default security_level is standard"
if grep -A 4 '"preferences"' "$REPO_ROOT/power-engineer/references/modules/configurator.md" | \
   grep -q '"standard"'; then
  pass "configurator.md default security_level is standard"
else
  fail "configurator.md default security_level is not standard"
fi

# --- Test 13: drift-detector.md references auto_update ---
echo "Test 13: drift-detector.md references auto_update"
if grep -q "auto_update" "$REPO_ROOT/power-engineer/references/modules/drift-detector.md"; then
  pass "drift-detector.md references auto_update"
else
  fail "drift-detector.md does not reference auto_update"
fi

# --- Test 14: drift-detector.md has auto-drift check section ---
echo "Test 14: drift-detector.md has Auto-drift check section"
if grep -q "Auto-drift check" "$REPO_ROOT/power-engineer/references/modules/drift-detector.md"; then
  pass "drift-detector.md has 'Auto-drift check' section"
else
  fail "drift-detector.md missing 'Auto-drift check' section"
fi

# --- Test 15: drift-detector.md skips auto-check for exempt routes ---
echo "Test 15: drift-detector.md skips auto-check for help, configure, status, catalog"
DRIFT_FILE="$REPO_ROOT/power-engineer/references/modules/drift-detector.md"
if grep -q "configure" "$DRIFT_FILE" && \
   grep -q "help" "$DRIFT_FILE" && \
   grep -q "status" "$DRIFT_FILE" && \
   grep -q "catalog" "$DRIFT_FILE"; then
  pass "drift-detector.md lists exempt routes for auto-drift"
else
  fail "drift-detector.md missing one or more exempt routes"
fi

# --- Test 16: drift-detector.md defaults to auto_update: true when preferences missing ---
echo "Test 16: drift-detector.md defaults to auto_update true when preferences missing"
if grep -q "missing.*default\|default.*auto_update: true\|default to \`auto_update: true\`" \
   "$REPO_ROOT/power-engineer/references/modules/drift-detector.md"; then
  pass "drift-detector.md defaults to auto_update: true when preferences missing"
else
  fail "drift-detector.md does not specify default when preferences missing"
fi

# --- Test 17: SKILL.md routes "power engineer configure" to configure.md ---
echo "Test 17: SKILL.md routes 'power engineer configure' to configure.md"
if grep -q "power engineer configure" "$REPO_ROOT/power-engineer/SKILL.md" && \
   grep -q "references/flows/configure.md" "$REPO_ROOT/power-engineer/SKILL.md"; then
  pass "SKILL.md routes 'power engineer configure' to references/flows/configure.md"
else
  fail "SKILL.md does not route 'power engineer configure' to configure.md"
fi

# --- Test 18: configure route is placed after help row ---
echo "Test 18: configure route is placed after help row"
HELP_LINE=$(grep -n '| "power engineer help"' "$REPO_ROOT/power-engineer/SKILL.md" | head -1 | cut -d: -f1)
CONFIGURE_LINE=$(grep -n '| "power engineer configure"' "$REPO_ROOT/power-engineer/SKILL.md" | head -1 | cut -d: -f1)
if [[ -n "$HELP_LINE" && -n "$CONFIGURE_LINE" && "$CONFIGURE_LINE" -gt "$HELP_LINE" ]]; then
  pass "configure route (line $CONFIGURE_LINE) is after help row (line $HELP_LINE)"
else
  fail "configure route is not correctly ordered after help row"
fi

# --- Test 19: configure route is placed before the fallback row ---
echo "Test 19: configure route is before fallback row"
CONFIGURE_LINE=$(grep -n '| "power engineer configure"' "$REPO_ROOT/power-engineer/SKILL.md" | head -1 | cut -d: -f1)
FALLBACK_LINE=$(grep -n "anything else" "$REPO_ROOT/power-engineer/SKILL.md" | head -1 | cut -d: -f1)
if [[ -n "$CONFIGURE_LINE" && -n "$FALLBACK_LINE" && "$CONFIGURE_LINE" -lt "$FALLBACK_LINE" ]]; then
  pass "configure route (line $CONFIGURE_LINE) is before fallback row (line $FALLBACK_LINE)"
else
  fail "configure route is not correctly ordered before fallback row"
fi

# --- Test 20: SKILL.md line count stays under 60 lines ---
echo "Test 20: SKILL.md stays under 60 lines"
LINE_COUNT=$(wc -l < "$REPO_ROOT/power-engineer/SKILL.md")
if [[ "$LINE_COUNT" -lt 60 ]]; then
  pass "SKILL.md has $LINE_COUNT lines (under 60)"
else
  fail "SKILL.md has $LINE_COUNT lines (exceeds 60 line limit)"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
