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
check "Has 13 questions" "grep -c '^### Q[0-9]' power-engineer/references/modules/questionnaire.md | grep -q '13'"
check "Has security question (Q12)" "grep -q 'Security needs' power-engineer/references/modules/questionnaire.md"
check "Has cross-tool usage question (Q13)" "grep -q 'Cross-tool usage' power-engineer/references/modules/questionnaire.md"
check "Q13 has Cursor option" "grep -q 'Cursor' power-engineer/references/modules/questionnaire.md"
check "Q13 has Copilot option" "grep -q 'GitHub Copilot' power-engineer/references/modules/questionnaire.md"
check "Q13 has Windsurf option" "grep -q 'Windsurf' power-engineer/references/modules/questionnaire.md"
check "Has 6 batches" "grep -c '^| [0-9]' power-engineer/references/modules/questionnaire.md | grep -qE '^6$'"
check "SkillPlan includes cross_tool_usage" "grep -q 'cross_tool_usage' power-engineer/references/modules/questionnaire.md"
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
check "Has 9 steps" "grep -c '^## Step [0-9]' power-engineer/references/modules/configurator.md | grep -q '9'"
check "Has regeneration policy" "grep -q 'Regeneration Policy' power-engineer/references/modules/configurator.md"
check "Regeneration policy lists all outputs" "grep -q 'cheatsheet.md' power-engineer/references/modules/configurator.md && grep -q 'handoff-template.md' power-engineer/references/modules/configurator.md"

echo ""
echo "Configurator CLAUDE.md Template:"
check "Has memory management subsection" "grep -q '### Proactive Memory Management' power-engineer/references/modules/configurator.md"
check "Memory has 8+ trigger categories" "grep -c 'type$' power-engineer/references/modules/configurator.md | grep -qE '^[89]'"
check "Has context management subsection" "grep -q '### Context Management' power-engineer/references/modules/configurator.md"
check "Context has compaction rule" "grep -q 'Proactive compaction' power-engineer/references/modules/configurator.md"
check "Context has post-compaction restore" "grep -q 'Post-compaction restore' power-engineer/references/modules/configurator.md"
check "Has session orchestration subsection" "grep -q '### Session Orchestration' power-engineer/references/modules/configurator.md"
check "Session has start protocol" "grep -q 'Session start protocol' power-engineer/references/modules/configurator.md"
check "Session has end protocol" "grep -q 'Session end protocol' power-engineer/references/modules/configurator.md"
check "Session has subagent context passing" "grep -q 'Subagent context passing' power-engineer/references/modules/configurator.md"
check "Universal AskUserQuestion covers all contexts" "grep -q 'ALL contexts' power-engineer/references/modules/configurator.md"
check "AskUserQuestion has rhetorical exception" "grep -q 'rhetorical' power-engineer/references/modules/configurator.md"

echo ""
echo "Configurator New Steps:"
check "Has post-compaction hook step" "grep -q 'Inject post-compaction hook' power-engineer/references/modules/configurator.md"
check "Hook uses read-merge-write" "grep -q 'read-merge-write' power-engineer/references/modules/configurator.md"
check "Hook has matcher=compact" "grep -q 'matcher.*compact' power-engineer/references/modules/configurator.md"
check "Has cross-tool config step" "grep -q 'Cross-tool config' power-engineer/references/modules/configurator.md"
check "Cross-tool has delimiter strategy" "grep -q 'delimiter strategy' power-engineer/references/modules/configurator.md"
check "Has handoff template step" "grep -q 'Generate handoff template' power-engineer/references/modules/configurator.md"
check "Has cheatsheet error handling" "grep -q 'Error handling' power-engineer/references/modules/configurator.md"
check "Cheatsheet warns on missing skills" "grep -q 'Not found in catalog' power-engineer/references/modules/configurator.md"
check "state.json has cross_tool_usage" "grep -q 'cross_tool_usage' power-engineer/references/modules/configurator.md"
check "state.json has security_needs" "grep -q 'security_needs' power-engineer/references/modules/configurator.md"

echo ""

# --- Drift Detector Tests ---
echo "Drift Detector Module:"
check "Detects dependency changes" "grep -qi 'dependency\|package.json' power-engineer/references/modules/drift-detector.md"
check "Detects structural changes" "grep -qi 'structural\|Dockerfile' power-engineer/references/modules/drift-detector.md"
check "Detects brand changes" "grep -qi 'brand\|tailwind' power-engineer/references/modules/drift-detector.md"
check "Preserves CLAUDE.md edits" "grep -qi 'manual edit\|preserve' power-engineer/references/modules/drift-detector.md"
check "Detects skill changes" "grep -qi 'skill.*removed\|manually' power-engineer/references/modules/drift-detector.md"
check "Offers reconciliation" "grep -qi 'reconcil\|accept all\|selectively' power-engineer/references/modules/drift-detector.md"

echo ""

# --- Router Tests ---
echo "Router (SKILL.md):"
check "Routes to full-interview" "grep -q 'full-interview.md' power-engineer/SKILL.md"
check "Routes to status flow" "grep -q 'status.md' power-engineer/SKILL.md"
check "Routes to update flow" "grep -q 'update.md' power-engineer/SKILL.md"
check "Routes to catalog-browse" "grep -q 'catalog-browse.md' power-engineer/SKILL.md"
check "Routes to all targeted flows" "grep -q 'frontend.md' power-engineer/SKILL.md && grep -q 'backend.md' power-engineer/SKILL.md && grep -q 'devops.md' power-engineer/SKILL.md"
check "Routes to configure" "grep -q 'configure.md' power-engineer/SKILL.md"
check "Routes to help" "grep -q 'help.md' power-engineer/SKILL.md"
check "All routed files exist" "for f in \$(grep -oE 'references/[a-z/-]+\.md' power-engineer/SKILL.md | sort -u); do [ -f \"power-engineer/\$f\" ] || exit 1; done"

echo ""

# --- Update Flow Tests ---
echo "Update Flow:"
check "Has 7 steps" "grep -c '^## Step [0-9]' power-engineer/references/flows/update.md | grep -q '7'"
check "Has skill health check" "grep -q 'Skill health check' power-engineer/references/flows/update.md"
check "Health check before drift detection" "grep -n 'health check' power-engineer/references/flows/update.md | head -1 | cut -d: -f1 | xargs -I{} sh -c 'HLINE={}; DLINE=\$(grep -n -i \"drift detection\" power-engineer/references/flows/update.md | head -1 | cut -d: -f1); [ \$HLINE -lt \$DLINE ]'"
check "Health check classifies healthy/missing/broken/orphaned" "grep -q 'Healthy' power-engineer/references/flows/update.md && grep -q 'Missing' power-engineer/references/flows/update.md && grep -q 'Broken' power-engineer/references/flows/update.md && grep -q 'Orphaned' power-engineer/references/flows/update.md"
check "Health check uses AskUserQuestion" "grep -q 'AskUserQuestion' power-engineer/references/flows/update.md"
check "Enforces full regeneration" "grep -qi 'FULL configurator\|regenerate ALL' power-engineer/references/flows/update.md"

echo ""

# --- Cleanup ---
rm -rf tests/test-scanner/mock-nextjs tests/test-scanner/mock-blank

echo "=== Results: $PASS passed, $FAIL failed ==="
[ $FAIL -eq 0 ] && exit 0 || exit 1
