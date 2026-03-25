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

SECURITY_OPS="/Users/khalfan/Documents/Development/power-engineer-skills/power-engineer/references/catalog/engineering/security-ops.md"

echo "=== Test: Security Skills Catalog — Phase 2a Integration ==="
echo ""

# --- Part 1: All 10 new skills are present ---

echo "-- Checking all 10 new skills are present in security-ops.md --"
echo ""

check "bandit-sast skill row present" \
  "grep -q '| bandit-sast |' \"$SECURITY_OPS\""

check "crypto-audit skill row present" \
  "grep -q '| crypto-audit |' \"$SECURITY_OPS\""

check "security-test-generator skill row present" \
  "grep -q '| security-test-generator |' \"$SECURITY_OPS\""

check "devsecops-pipeline skill row present" \
  "grep -q '| devsecops-pipeline |' \"$SECURITY_OPS\""

check "socket-sca skill row present" \
  "grep -q '| socket-sca |' \"$SECURITY_OPS\""

check "docker-scout-scanner skill row present" \
  "grep -q '| docker-scout-scanner |' \"$SECURITY_OPS\""

check "security-headers-audit skill row present" \
  "grep -q '| security-headers-audit |' \"$SECURITY_OPS\""

check "api-security-tester skill row present" \
  "grep -q '| api-security-tester |' \"$SECURITY_OPS\""

check "mobile-security skill row present" \
  "grep -q '| mobile-security |' \"$SECURITY_OPS\""

check "pci-dss-audit skill row present" \
  "grep -q '| pci-dss-audit |' \"$SECURITY_OPS\""

echo ""

# --- Part 2: Install command syntax validation ---

echo "-- Validating install command syntax for all 10 new skills --"
echo ""

check "bandit-sast install command uses correct syntax" \
  "grep -q 'npx skills@latest add kalshamsi/claude-security-skills --skill bandit-sast -y' \"$SECURITY_OPS\""

check "crypto-audit install command uses correct syntax" \
  "grep -q 'npx skills@latest add kalshamsi/claude-security-skills --skill crypto-audit -y' \"$SECURITY_OPS\""

check "security-test-generator install command uses correct syntax" \
  "grep -q 'npx skills@latest add kalshamsi/claude-security-skills --skill security-test-generator -y' \"$SECURITY_OPS\""

check "devsecops-pipeline install command uses correct syntax" \
  "grep -q 'npx skills@latest add kalshamsi/claude-security-skills --skill devsecops-pipeline -y' \"$SECURITY_OPS\""

check "socket-sca install command uses correct syntax" \
  "grep -q 'npx skills@latest add kalshamsi/claude-security-skills --skill socket-sca -y' \"$SECURITY_OPS\""

check "docker-scout-scanner install command uses correct syntax" \
  "grep -q 'npx skills@latest add kalshamsi/claude-security-skills --skill docker-scout-scanner -y' \"$SECURITY_OPS\""

check "security-headers-audit install command uses correct syntax" \
  "grep -q 'npx skills@latest add kalshamsi/claude-security-skills --skill security-headers-audit -y' \"$SECURITY_OPS\""

check "api-security-tester install command uses correct syntax" \
  "grep -q 'npx skills@latest add kalshamsi/claude-security-skills --skill api-security-tester -y' \"$SECURITY_OPS\""

check "mobile-security install command uses correct syntax" \
  "grep -q 'npx skills@latest add kalshamsi/claude-security-skills --skill mobile-security -y' \"$SECURITY_OPS\""

check "pci-dss-audit install command uses correct syntax" \
  "grep -q 'npx skills@latest add kalshamsi/claude-security-skills --skill pci-dss-audit -y' \"$SECURITY_OPS\""

echo ""

# --- Part 3: Trigger and When-to-use populated for each new skill ---

echo "-- Confirming Trigger and When-to-use are populated for new skills --"
echo ""

check "bandit-sast has trigger /bandit-sast" \
  "grep -q '/bandit-sast' \"$SECURITY_OPS\""

check "crypto-audit has trigger /crypto-audit" \
  "grep -q '/crypto-audit' \"$SECURITY_OPS\""

check "security-test-generator has trigger /security-test-generator" \
  "grep -q '/security-test-generator' \"$SECURITY_OPS\""

check "devsecops-pipeline has trigger /devsecops-pipeline" \
  "grep -q '/devsecops-pipeline' \"$SECURITY_OPS\""

check "socket-sca has trigger /socket-sca" \
  "grep -q '/socket-sca' \"$SECURITY_OPS\""

check "docker-scout-scanner has trigger /docker-scout-scanner" \
  "grep -q '/docker-scout-scanner' \"$SECURITY_OPS\""

check "security-headers-audit has trigger /security-headers-audit" \
  "grep -q '/security-headers-audit' \"$SECURITY_OPS\""

check "api-security-tester has trigger /api-security-tester" \
  "grep -q '/api-security-tester' \"$SECURITY_OPS\""

check "mobile-security has trigger /mobile-security" \
  "grep -q '/mobile-security' \"$SECURITY_OPS\""

check "pci-dss-audit has trigger /pci-dss-audit" \
  "grep -q '/pci-dss-audit' \"$SECURITY_OPS\""

echo ""

# --- Part 4: New section exists and is correctly placed ---

echo "-- Verifying new Security Testing & Analysis section placement --"
echo ""

check "Security Testing & Analysis section exists" \
  "grep -q '## Security Testing & Analysis' \"$SECURITY_OPS\""

check "Security Testing & Analysis section appears before Multi-Tool / Comprehensive" \
  "awk '/## Security Testing & Analysis/{sa=NR} /## Multi-Tool \/ Comprehensive/{mb=NR} END{exit !(sa > 0 && mb > 0 && sa < mb)}' \"$SECURITY_OPS\""

check "Security Testing & Analysis section appears after Framework-Specific Security" \
  "awk '/## Framework-Specific Security/{fs=NR} /## Security Testing & Analysis/{sa=NR} END{exit !(fs > 0 && sa > 0 && fs < sa)}' \"$SECURITY_OPS\""

echo ""

# --- Part 5: Section placement of skills in existing sections ---

echo "-- Verifying 4 skills are in their correct existing sections --"
echo ""

check "bandit-sast appears in SAST section" \
  "awk '/## SAST/,/^---/' \"$SECURITY_OPS\" | grep -q 'bandit-sast'"

check "socket-sca appears in SCA section" \
  "awk '/## SCA/,/^---/' \"$SECURITY_OPS\" | grep -q 'socket-sca'"

check "docker-scout-scanner appears in Container Security section" \
  "awk '/## Container Security/,/^---/' \"$SECURITY_OPS\" | grep -q 'docker-scout-scanner'"

check "pci-dss-audit appears in Compliance section" \
  "awk '/## Compliance/,/^---/' \"$SECURITY_OPS\" | grep -q 'pci-dss-audit'"

echo ""

# --- Summary ---

echo "=== Results: $PASS passed, $FAIL failed ==="
echo ""

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
