#!/usr/bin/env bash
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

RESOLVER="/Users/khalfan/Documents/Development/power-engineer-skills/power-engineer/references/modules/skill-resolver.md"

echo "=== Test: Security Resolver Wiring — Phase 2b Integration ==="
echo ""

# --- Part 1: New security level section exists ---

echo "-- Checking new security level section exists --"
echo ""

check "new security level section heading present" \
  "grep -q '## Security level (from Q12 — new security levels)' \"$RESOLVER\""

check "Standard branch present" \
  "grep -q '\*\*Standard:\*\*' \"$RESOLVER\""

check "Enhanced branch present" \
  "grep -q '\*\*Enhanced:\*\*' \"$RESOLVER\""

check "Maximum branch present" \
  "grep -q '\*\*Maximum:\*\*' \"$RESOLVER\""

check "Compliance branch present" \
  "grep -q '\*\*Compliance:\*\*' \"$RESOLVER\""

check "Custom branch present" \
  "grep -q '\*\*Custom:\*\*' \"$RESOLVER\""

echo ""

# --- Part 2: Standard branch adds no new skills ---

echo "-- Verifying Standard branch adds no kalshamsi skills --"
echo ""

check "Standard branch does not install kalshamsi skills (no npx command in Standard paragraph)" \
  "awk '/\*\*Standard:\*\*/,/\*\*Enhanced:\*\*/' \"$RESOLVER\" | grep -v 'npx skills@latest add kalshamsi' > /dev/null && ! awk '/\*\*Standard:\*\*/,/\*\*Enhanced:\*\*/' \"$RESOLVER\" | grep -q 'npx skills@latest add kalshamsi'"

echo ""

# --- Part 3: Enhanced branch maps exactly 3 skills ---

echo "-- Verifying Enhanced branch maps exactly 3 skills --"
echo ""

check "Enhanced includes security-headers-audit" \
  "awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' \"$RESOLVER\" | grep -q 'security-headers-audit'"

check "Enhanced includes crypto-audit" \
  "awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' \"$RESOLVER\" | grep -q 'crypto-audit'"

check "Enhanced includes api-security-tester" \
  "awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' \"$RESOLVER\" | grep -q 'api-security-tester'"

check "Enhanced does NOT include bandit-sast" \
  "! awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' \"$RESOLVER\" | grep -q 'bandit-sast'"

check "Enhanced does NOT include socket-sca" \
  "! awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' \"$RESOLVER\" | grep -q 'socket-sca'"

check "Enhanced does NOT include docker-scout-scanner" \
  "! awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' \"$RESOLVER\" | grep -q 'docker-scout-scanner'"

check "Enhanced does NOT include pci-dss-audit" \
  "! awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' \"$RESOLVER\" | grep -q 'pci-dss-audit'"

check "Enhanced does NOT include mobile-security" \
  "! awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' \"$RESOLVER\" | grep -q 'mobile-security'"

echo ""

# --- Part 4: Maximum branch maps Enhanced + 5 ---

echo "-- Verifying Maximum branch maps Enhanced skills + 5 additional --"
echo ""

check "Maximum includes security-headers-audit" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -q 'security-headers-audit'"

check "Maximum includes crypto-audit" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -q 'crypto-audit'"

check "Maximum includes api-security-tester" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -q 'api-security-tester'"

check "Maximum includes bandit-sast" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -q 'bandit-sast'"

check "Maximum includes socket-sca" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -q 'socket-sca'"

check "Maximum includes docker-scout-scanner" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -q 'docker-scout-scanner'"

check "Maximum includes security-test-generator" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -q 'security-test-generator'"

check "Maximum includes devsecops-pipeline" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -q 'devsecops-pipeline'"

check "Maximum does NOT include pci-dss-audit" \
  "! awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -q 'pci-dss-audit'"

check "Maximum does NOT include mobile-security" \
  "! awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -q 'mobile-security'"

echo ""

# --- Part 5: Compliance branch maps Maximum + 2 ---

echo "-- Verifying Compliance branch maps Maximum skills + pci-dss-audit + mobile-security --"
echo ""

check "Compliance includes security-headers-audit" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -q 'security-headers-audit'"

check "Compliance includes crypto-audit" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -q 'crypto-audit'"

check "Compliance includes api-security-tester" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -q 'api-security-tester'"

check "Compliance includes bandit-sast" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -q 'bandit-sast'"

check "Compliance includes socket-sca" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -q 'socket-sca'"

check "Compliance includes docker-scout-scanner" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -q 'docker-scout-scanner'"

check "Compliance includes security-test-generator" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -q 'security-test-generator'"

check "Compliance includes devsecops-pipeline" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -q 'devsecops-pipeline'"

check "Compliance includes pci-dss-audit" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -q 'pci-dss-audit'"

check "Compliance includes mobile-security" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -q 'mobile-security'"

echo ""

# --- Part 6: Custom branch lists all 10 ---

echo "-- Verifying Custom branch lists all 10 skills --"
echo ""

check "Custom includes security-headers-audit" \
  "awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -q 'security-headers-audit'"

check "Custom includes crypto-audit" \
  "awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -q 'crypto-audit'"

check "Custom includes api-security-tester" \
  "awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -q 'api-security-tester'"

check "Custom includes bandit-sast" \
  "awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -q 'bandit-sast'"

check "Custom includes socket-sca" \
  "awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -q 'socket-sca'"

check "Custom includes docker-scout-scanner" \
  "awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -q 'docker-scout-scanner'"

check "Custom includes security-test-generator" \
  "awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -q 'security-test-generator'"

check "Custom includes devsecops-pipeline" \
  "awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -q 'devsecops-pipeline'"

check "Custom includes pci-dss-audit" \
  "awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -q 'pci-dss-audit'"

check "Custom includes mobile-security" \
  "awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -q 'mobile-security'"

echo ""

# --- Part 7: No duplicate skill entries within each branch ---

echo "-- Verifying no duplicate skill entries in the new section --"
echo ""

check "No duplicate security-headers-audit in Enhanced block" \
  "[ \$(awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' \"$RESOLVER\" | grep -c 'security-headers-audit') -le 1 ]"

check "No duplicate bandit-sast in Maximum block" \
  "[ \$(awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' \"$RESOLVER\" | grep -c 'bandit-sast') -le 1 ]"

check "No duplicate pci-dss-audit in Compliance block" \
  "[ \$(awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' \"$RESOLVER\" | grep -c 'pci-dss-audit') -le 1 ]"

check "No duplicate mobile-security in Custom block" \
  "[ \$(awk '/\*\*Custom:\*\*/,/^---/' \"$RESOLVER\" | grep -c 'mobile-security') -le 1 ]"

echo ""

# --- Part 8: All 10 skills referenced somewhere in resolver ---

echo "-- Verifying all 10 new skills are referenced in the resolver --"
echo ""

check "resolver references security-headers-audit" \
  "grep -q 'security-headers-audit' \"$RESOLVER\""

check "resolver references crypto-audit" \
  "grep -q 'crypto-audit' \"$RESOLVER\""

check "resolver references api-security-tester" \
  "grep -q 'api-security-tester' \"$RESOLVER\""

check "resolver references bandit-sast" \
  "grep -q 'bandit-sast' \"$RESOLVER\""

check "resolver references socket-sca" \
  "grep -q 'socket-sca' \"$RESOLVER\""

check "resolver references docker-scout-scanner" \
  "grep -q 'docker-scout-scanner' \"$RESOLVER\""

check "resolver references security-test-generator" \
  "grep -q 'security-test-generator' \"$RESOLVER\""

check "resolver references devsecops-pipeline" \
  "grep -q 'devsecops-pipeline' \"$RESOLVER\""

check "resolver references pci-dss-audit" \
  "grep -q 'pci-dss-audit' \"$RESOLVER\""

check "resolver references mobile-security" \
  "grep -q 'mobile-security' \"$RESOLVER\""

echo ""

# --- Summary ---

echo "=== Results: $PASS passed, $FAIL failed ==="
echo ""

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
