#!/usr/bin/env bash
# Power Engineer Test Runner
# Sets up mock projects and validates module behavior
set -e

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

echo "=== Power Engineer Module Tests ==="
echo ""

# --- Scanner Tests ---
echo "Scanner Module:"
# Set up mock Next.js project
mkdir -p tests/test-scanner/mock-nextjs
cat > tests/test-scanner/mock-nextjs/package.json << 'MOCK'
{"dependencies":{"next":"14.0.0","react":"18.0.0","@supabase/supabase-js":"2.0.0"}}
MOCK
touch tests/test-scanner/mock-nextjs/tsconfig.json
touch tests/test-scanner/mock-nextjs/next.config.mjs

check "Detects package.json" "[ -f tests/test-scanner/mock-nextjs/package.json ]"
check "Scanner references package.json" "grep -q 'package.json' power-engineer/references/modules/scanner.md"
check "Scanner references tsconfig" "grep -q 'tsconfig.json' power-engineer/references/modules/scanner.md"
check "Scanner references next.config" "grep -q 'next.config' power-engineer/references/modules/scanner.md"
check "Scanner outputs ProjectProfile" "grep -q 'ProjectProfile' power-engineer/references/modules/scanner.md"

# Set up mock blank project
mkdir -p tests/test-scanner/mock-blank
check "Blank project has no package.json" "[ ! -f tests/test-scanner/mock-blank/package.json ]"

echo ""

# --- Skill Resolver Tests ---
echo "Skill Resolver Module:"
check "No broken slash syntax" "! grep -qE 'add [a-zA-Z-]+/[a-zA-Z-]+/[a-zA-Z-]+' power-engineer/references/modules/skill-resolver.md"
check "All commands have -y flag" "! grep 'npx skills' power-engineer/references/modules/skill-resolver.md | grep -v '\-y' | grep -v 'BROKEN' | grep -qv '^#'"
check "Uses --skill flag" "grep -q '\-\-skill' power-engineer/references/modules/skill-resolver.md"
check "Has core methodology section" "grep -q 'Core methodology' power-engineer/references/modules/skill-resolver.md"
check "Has deduplication instructions" "grep -qi 'de-duplicate\|deduplic' power-engineer/references/modules/skill-resolver.md"

echo ""

# --- Questionnaire Tests ---
echo "Questionnaire Module:"
check "Has skip rules" "grep -q 'Skip if' power-engineer/references/modules/questionnaire.md"
check "Has 12 questions" "grep -c '^### Q[0-9]' power-engineer/references/modules/questionnaire.md | grep -q '12'"
check "Has security question" "grep -q 'Security needs' power-engineer/references/modules/questionnaire.md"
check "New Q9 brand identity" "grep -q 'Brand identity' power-engineer/references/modules/questionnaire.md"
check "New Q10 team workflow" "grep -q 'Team workflow' power-engineer/references/modules/questionnaire.md"
check "New Q11 goals" "grep -q 'Goals' power-engineer/references/modules/questionnaire.md"
check "Outputs SkillPlan" "grep -q 'SkillPlan' power-engineer/references/modules/questionnaire.md"

echo ""

# --- Installer Tests ---
echo "Installer Module:"
check "No script generation" "grep -qi 'directly\|immediately' power-engineer/references/modules/installer.md"
check "No --global flag in commands" "! grep 'npx.*\-\-global' power-engineer/references/modules/installer.md"
check "Handles failures" "grep -qi 'failure\|failed\|continue' power-engineer/references/modules/installer.md"
check "Saves install log" "grep -q 'install-log.sh' power-engineer/references/modules/installer.md"
check "Shows progress" "grep -qi 'progress' power-engineer/references/modules/installer.md"

echo ""

# --- Configurator Tests ---
echo "Configurator Module:"
check "Creates state.json" "grep -q 'state.json' power-engineer/references/modules/configurator.md"
check "Creates brand.md" "grep -q 'brand.md' power-engineer/references/modules/configurator.md"
check "Smart-merge CLAUDE.md" "grep -q 'managed-section' power-engineer/references/modules/configurator.md"
check "Uses delimiters for patching" "grep -q 'power-engineer:project-context' power-engineer/references/modules/configurator.md"
check "Checks .gitignore" "grep -q 'gitignore' power-engineer/references/modules/configurator.md"

echo ""

# --- Drift Detector Tests ---
echo "Drift Detector Module:"
check "Detects dependency changes" "grep -qi 'dependency\|package.json' power-engineer/references/modules/drift-detector.md"
check "Detects structural changes" "grep -qi 'structural\|Dockerfile' power-engineer/references/modules/drift-detector.md"
check "Detects brand changes" "grep -qi 'brand\|tailwind' power-engineer/references/modules/drift-detector.md"
check "Preserves CLAUDE.md edits" "grep -qi 'manual edit\|preserve' power-engineer/references/modules/drift-detector.md"
check "Detects skill changes" "grep -qi 'skill.*removed\|manually' power-engineer/references/modules/drift-detector.md"
check "Detects Ruflo agent changes" "grep -qi 'agent.*definition\|agents/' power-engineer/references/modules/drift-detector.md"
check "Offers reconciliation" "grep -qi 'reconcil\|accept all\|selectively' power-engineer/references/modules/drift-detector.md"

echo ""

# --- Ruflo Tests ---
echo "Ruflo Module:"
check "Monorepo 3+ criterion" "grep -q 'package_count.*3\|3.*package' power-engineer/references/modules/ruflo.md"
check "Team 3+ criterion" "grep -q 'team_size.*3\|3.*contributor' power-engineer/references/modules/ruflo.md"
check "Excludes solo+small" "grep -qi 'solo\|small codebase' power-engineer/references/modules/ruflo.md"
check "Excludes research" "grep -qi 'research.*prototyp' power-engineer/references/modules/ruflo.md"
check "Requires user confirmation" "grep -qi 'confirm\|proceed' power-engineer/references/modules/ruflo.md"
check "Generates agent definitions" "grep -q 'agents/' power-engineer/references/modules/ruflo.md"

echo ""

# --- Router Tests ---
echo "Router (SKILL.md):"
check "Routes to full-interview" "grep -q 'full-interview.md' power-engineer/SKILL.md"
check "Routes to status" "grep -q 'drift-detector.md\|status' power-engineer/SKILL.md"
check "Routes to catalog-browse" "grep -q 'catalog-browse.md' power-engineer/SKILL.md"
check "Routes to all targeted flows" "grep -q 'frontend.md' power-engineer/SKILL.md && grep -q 'backend.md' power-engineer/SKILL.md"
check "Under 55 lines" "[ $(wc -l < power-engineer/SKILL.md) -le 55 ]"

echo ""

# --- Cleanup ---
rm -rf tests/test-scanner/mock-nextjs tests/test-scanner/mock-blank

echo "=== Results: $PASS passed, $FAIL failed ==="
[ $FAIL -eq 0 ] && exit 0 || exit 1
