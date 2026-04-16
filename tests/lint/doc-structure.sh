#!/usr/bin/env bash
# Documentation / module / flow structure invariants.
# Migrated from tests/integration/ — see docs/superpowers/plans/v1.3.0-audit.md
# Compatible with bash 3.2+ (macOS default).
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

FAIL=0
pass() { echo "  PASS: $*"; }
fail() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
check() {
  local name="$1" cond="$2"
  if eval "$cond"; then pass "$name"; else fail "$name"; fi
}

# ─── Scanner module ──────────────────────────────────────────
check "scanner.md references package.json" \
  "grep -q 'package.json' power-engineer/references/modules/scanner.md"

check "scanner.md references tsconfig.json" \
  "grep -q 'tsconfig.json' power-engineer/references/modules/scanner.md"

check "scanner.md references requirements.txt" \
  "grep -q 'requirements.txt' power-engineer/references/modules/scanner.md"

check "scanner.md references Dockerfile" \
  "grep -q 'Dockerfile' power-engineer/references/modules/scanner.md"

# ─── Questionnaire module ────────────────────────────────────
check "questionnaire has all 12 question IDs (Q1-Q13 minus Q3/Q7)" \
  "[ \$(grep -cE '^### Q[0-9]+' power-engineer/references/modules/questionnaire.md) -ge 12 ]"

# ─── Skill resolver module ───────────────────────────────────
# Rewritten 2026-04-15 (Phase 1 remediation, Item 4): skill-resolver.md
# organises by skill name + Q-based section headings, not by catalog
# filename. The previous 4 checks (core-methodology / anthropic-official /
# docs-research / power-suites catalog-name references) were stale --
# skill-resolver.md doesn't mention those filenames. The replacements below
# preserve intent (resolver covers core methodology + known skill suites
# + all expected Q-based categories) by probing for what the file actually
# contains.
RESOLVER_MOD="power-engineer/references/modules/skill-resolver.md"

check "resolver has 'Always add' core methodology block" \
  "grep -qE '^## Always add' '$RESOLVER_MOD'"

check "resolver references superpowers core skills (brainstorming, writing-plans, systematic-debugging)" \
  "grep -q 'brainstorming' '$RESOLVER_MOD' && grep -q 'writing-plans' '$RESOLVER_MOD' && grep -q 'systematic-debugging' '$RESOLVER_MOD'"

check "resolver references github/awesome-copilot skills (gh-cli, git-commit)" \
  "grep -q 'gh-cli' '$RESOLVER_MOD' && grep -q 'git-commit' '$RESOLVER_MOD'"

check "resolver organizes by Q-based section headings (project type, language, framework)" \
  "grep -qE '^## Project type' '$RESOLVER_MOD' && grep -qE '^## Language/Stack' '$RESOLVER_MOD' && grep -qE '^## Framework' '$RESOLVER_MOD'"

check "resolver covers documentation + research + security Q-based sections" \
  "grep -qE '^## Documentation' '$RESOLVER_MOD' && grep -qE '^## Research / data' '$RESOLVER_MOD' && grep -qE '^## Security' '$RESOLVER_MOD'"

check "resolver references plugin-based suites (superpowers marketplace, engineering-skills)" \
  "grep -qE 'superpowers-marketplace|engineering-skills|plugin install|plugin marketplace add' '$RESOLVER_MOD'"

# ─── Installer module ────────────────────────────────────────
check "installer references progress tracking" \
  "grep -qE 'progress|Installing' power-engineer/references/modules/installer.md"

check "installer has failure handling" \
  "grep -qE 'FAILED|Continue on failure' power-engineer/references/modules/installer.md"

# ─── Configurator module ─────────────────────────────────────
check "configurator generates CLAUDE.md" \
  "grep -q 'CLAUDE.md' power-engineer/references/modules/configurator.md"

check "configurator hook uses SessionStart (not PostToolUse)" \
  "grep -q 'SessionStart' power-engineer/references/modules/configurator.md"

check "configurator hook does NOT use PostToolUse" \
  "! grep -qE '^Inject a PostToolUse' power-engineer/references/modules/configurator.md"

# ─── Permissions module (hook-schema regression prevention) ──
check "permissions hook uses nested {type,command} format" \
  "grep -qE '\"type\"[[:space:]]*:[[:space:]]*\"command\"' power-engineer/references/modules/permissions.md"

check "permissions hook does NOT use flat bare-string hooks array" \
  "! grep -qE '\"hooks\"[[:space:]]*:[[:space:]]*\\[\"\\.' power-engineer/references/modules/permissions.md"

check "permissions hook regex tolerates pinned skills@<version>" \
  "grep -qE 'npx skills\\(@\\[a-zA-Z0-9\\._-\\]\\+\\)' power-engineer/references/modules/permissions.md"

# ─── Flow files reference correct modules ────────────────────
for flow in full-interview quick frontend backend devops ai data docs mobile; do
  check "flow $flow.md references modules/scanner.md" \
    "grep -q 'modules/scanner.md' power-engineer/references/flows/$flow.md"
done

# ─── Router table ────────────────────────────────────────────
check "SKILL.md routes to full-interview" \
  "grep -q 'full-interview' power-engineer/SKILL.md"

check "SKILL.md routes to status flow" \
  "grep -q 'status' power-engineer/SKILL.md"

# ─── ported from test-stable-api.sh ─────────────────────────
check "[from test-stable-api.sh] power-engineer -> full-interview.md route present" \
  "grep -q 'full-interview.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] quick -> quick.md route present" \
  "grep -q 'quick.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] frontend -> frontend.md route present" \
  "grep -q 'frontend.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] backend -> backend.md route present" \
  "grep -q 'backend.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] devops -> devops.md route present" \
  "grep -q 'devops.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] ai -> ai.md route present" \
  "grep -q 'flows/ai.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] data -> data.md route present" \
  "grep -q 'data.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] docs -> docs.md route present" \
  "grep -q 'flows/docs.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] mobile -> mobile.md route present" \
  "grep -q 'mobile.md' power-engineer/SKILL.md"

# Rewritten 2026-04-15 (Phase 1 remediation, Item 4): SKILL.md routes
# "power engineer status" to flows/status.md (not drift-detector.md
# directly). The drift-detector behaviour is referenced from inside
# flows/status.md, so the invariant splits into two checks.
check "[from test-stable-api.sh] status -> flows/status.md route present" \
  "grep -qE 'status[^|]*\|[^|]*references/flows/status\.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] flows/status.md references drift-detector behaviour" \
  "[ -f power-engineer/references/flows/status.md ] && grep -qE 'drift-detector|drift check|drift detection' power-engineer/references/flows/status.md"

check "[from test-stable-api.sh] update -> update.md route present" \
  "grep -q 'update.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] catalog -> catalog-browse.md route present" \
  "grep -q 'catalog-browse.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] help -> help.md route present" \
  "grep -q 'help.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] configure -> configure.md route present" \
  "grep -q 'configure.md' power-engineer/SKILL.md"

check "[from test-stable-api.sh] references/flows/full-interview.md exists" \
  "[ -f power-engineer/references/flows/full-interview.md ]"

check "[from test-stable-api.sh] references/flows/quick.md exists" \
  "[ -f power-engineer/references/flows/quick.md ]"

check "[from test-stable-api.sh] references/flows/frontend.md exists" \
  "[ -f power-engineer/references/flows/frontend.md ]"

check "[from test-stable-api.sh] references/flows/backend.md exists" \
  "[ -f power-engineer/references/flows/backend.md ]"

check "[from test-stable-api.sh] references/flows/devops.md exists" \
  "[ -f power-engineer/references/flows/devops.md ]"

check "[from test-stable-api.sh] references/flows/ai.md exists" \
  "[ -f power-engineer/references/flows/ai.md ]"

check "[from test-stable-api.sh] references/flows/data.md exists" \
  "[ -f power-engineer/references/flows/data.md ]"

check "[from test-stable-api.sh] references/flows/docs.md exists" \
  "[ -f power-engineer/references/flows/docs.md ]"

check "[from test-stable-api.sh] references/flows/mobile.md exists" \
  "[ -f power-engineer/references/flows/mobile.md ]"

check "[from test-stable-api.sh] references/modules/drift-detector.md exists" \
  "[ -f power-engineer/references/modules/drift-detector.md ]"

check "[from test-stable-api.sh] references/flows/update.md exists" \
  "[ -f power-engineer/references/flows/update.md ]"

check "[from test-stable-api.sh] references/flows/catalog-browse.md exists" \
  "[ -f power-engineer/references/flows/catalog-browse.md ]"

check "[from test-stable-api.sh] references/flows/help.md exists" \
  "[ -f power-engineer/references/flows/help.md ]"

check "[from test-stable-api.sh] references/flows/configure.md exists" \
  "[ -f power-engineer/references/flows/configure.md ]"

# No orphaned references — every route target in SKILL.md must exist
while IFS= read -r ref; do
  check "[from test-stable-api.sh] No orphan: $ref" \
    "[ -f power-engineer/$ref ]"
done < <(grep -oE 'references/[^` ]+\.md' power-engineer/SKILL.md | sort -u)

# ─── ported from test-configure-autodrift.sh ─────────────────
check "[from test-configure-autodrift.sh] references/flows/configure.md exists" \
  "[ -f power-engineer/references/flows/configure.md ]"

check "[from test-configure-autodrift.sh] configure.md references state.json" \
  "grep -q 'state.json' power-engineer/references/flows/configure.md"

check "[from test-configure-autodrift.sh] configure.md has 'No Power Engineer setup found' message" \
  "grep -q 'No Power Engineer setup found' power-engineer/references/flows/configure.md"

check "[from test-configure-autodrift.sh] configure.md references preferences object" \
  "grep -q 'preferences' power-engineer/references/flows/configure.md"

check "[from test-configure-autodrift.sh] configure.md handles missing preferences with defaults" \
  "grep -qE 'no.*preferences|no \`preferences\`|no preferences|If no \`preferences\`' power-engineer/references/flows/configure.md"

check "[from test-configure-autodrift.sh] configure.md validates security_level values" \
  "grep -qE 'standard.*enhanced.*maximum|Validate.*security_level' power-engineer/references/flows/configure.md"

check "[from test-configure-autodrift.sh] configure.md includes all 5 security_level options" \
  "grep -q 'standard' power-engineer/references/flows/configure.md && grep -q 'enhanced' power-engineer/references/flows/configure.md && grep -q 'maximum' power-engineer/references/flows/configure.md && grep -q 'compliance' power-engineer/references/flows/configure.md && grep -q 'custom' power-engineer/references/flows/configure.md"

check "[from test-configure-autodrift.sh] configure.md includes auto_update option" \
  "grep -qE 'auto_update|Auto-Update|auto-update' power-engineer/references/flows/configure.md"

check "[from test-configure-autodrift.sh] configurator.md state schema includes preferences object" \
  "grep -q '\"preferences\"' power-engineer/references/modules/configurator.md"

check "[from test-configure-autodrift.sh] configurator.md preferences includes security_level" \
  "grep -q '\"security_level\"' power-engineer/references/modules/configurator.md"

check "[from test-configure-autodrift.sh] configurator.md preferences includes auto_update" \
  "grep -q '\"auto_update\"' power-engineer/references/modules/configurator.md"

check "[from test-configure-autodrift.sh] configurator.md default security_level is standard" \
  "grep -A 4 '\"preferences\"' power-engineer/references/modules/configurator.md | grep -q '\"standard\"'"

check "[from test-configure-autodrift.sh] drift-detector.md references auto_update" \
  "grep -q 'auto_update' power-engineer/references/modules/drift-detector.md"

check "[from test-configure-autodrift.sh] drift-detector.md has 'Auto-drift check' section" \
  "grep -q 'Auto-drift check' power-engineer/references/modules/drift-detector.md"

check "[from test-configure-autodrift.sh] drift-detector.md lists exempt routes (configure, help, status, catalog)" \
  "grep -q 'configure' power-engineer/references/modules/drift-detector.md && grep -q 'help' power-engineer/references/modules/drift-detector.md && grep -q 'status' power-engineer/references/modules/drift-detector.md && grep -q 'catalog' power-engineer/references/modules/drift-detector.md"

check "[from test-configure-autodrift.sh] drift-detector.md specifies default auto_update when preferences missing" \
  "grep -qE 'missing.*default|default.*auto_update: true|default to \`auto_update: true\`' power-engineer/references/modules/drift-detector.md"

check "[from test-configure-autodrift.sh] SKILL.md routes 'power engineer configure' to configure.md" \
  "grep -q 'power engineer configure' power-engineer/SKILL.md && grep -q 'references/flows/configure.md' power-engineer/SKILL.md"

check "[from test-configure-autodrift.sh] configure route ordered after help row" \
  "HELP_LINE=\$(grep -n '| \"power engineer help\"' power-engineer/SKILL.md | head -1 | cut -d: -f1); CONFIGURE_LINE=\$(grep -n '| \"power engineer configure\"' power-engineer/SKILL.md | head -1 | cut -d: -f1); [ -n \"\$HELP_LINE\" ] && [ -n \"\$CONFIGURE_LINE\" ] && [ \"\$CONFIGURE_LINE\" -gt \"\$HELP_LINE\" ]"

check "[from test-configure-autodrift.sh] configure route ordered before fallback row" \
  "CONFIGURE_LINE=\$(grep -n '| \"power engineer configure\"' power-engineer/SKILL.md | head -1 | cut -d: -f1); FALLBACK_LINE=\$(grep -n 'anything else' power-engineer/SKILL.md | head -1 | cut -d: -f1); [ -n \"\$CONFIGURE_LINE\" ] && [ -n \"\$FALLBACK_LINE\" ] && [ \"\$CONFIGURE_LINE\" -lt \"\$FALLBACK_LINE\" ]"

check "[from test-configure-autodrift.sh] configurator.md has exactly 9 steps" \
  "[ \$(grep -c '^## Step [0-9]' power-engineer/references/modules/configurator.md || true) -eq 9 ]"

# ─── ported from test-documentation.sh ──────────────────────
check "[from test-documentation.sh] README.md exists" \
  "[ -f README.md ]"

check "[from test-documentation.sh] README has Quick start section" \
  "grep -q 'Quick start' README.md"

check "[from test-documentation.sh] README quick-start mentions 'under 2 minutes'" \
  "grep -q 'under 2 minutes' README.md"

check "[from test-documentation.sh] README quick-start has 3 steps" \
  "grep -q 'Step 1' README.md"

check "[from test-documentation.sh] README quick-start has install step (npx skills@latest add)" \
  "grep -q 'npx skills@latest add' README.md"

check "[from test-documentation.sh] README quick-start has run step (/power-engineer)" \
  "grep -q '/power-engineer' README.md"

check "[from test-documentation.sh] README has Beginner guide section" \
  "grep -q 'Beginner guide' README.md"

check "[from test-documentation.sh] README explains 'What are Claude Code skills'" \
  "grep -q 'What are Claude Code skills' README.md"

check "[from test-documentation.sh] README explains 'What does Power Engineer do'" \
  "grep -q 'What does Power Engineer do' README.md"

check "[from test-documentation.sh] README has Command reference table" \
  "grep -q 'Command reference' README.md"

check "[from test-documentation.sh] README lists power-engineer command" \
  "grep -q 'power-engineer' README.md"

check "[from test-documentation.sh] README lists quick command" \
  "grep -q 'quick' README.md"

check "[from test-documentation.sh] README lists frontend command" \
  "grep -q 'frontend' README.md"

check "[from test-documentation.sh] README lists backend command" \
  "grep -q 'backend' README.md"

check "[from test-documentation.sh] README lists devops command" \
  "grep -q 'devops' README.md"

check "[from test-documentation.sh] README lists ai command" \
  "grep -qE '\\| \`ai\`' README.md"

check "[from test-documentation.sh] README lists data command" \
  "grep -qE '\\| \`data\`' README.md"

check "[from test-documentation.sh] README lists docs command" \
  "grep -qE '\\| \`docs\`' README.md"

check "[from test-documentation.sh] README lists mobile command" \
  "grep -qE '\\| \`mobile\`' README.md"

check "[from test-documentation.sh] README lists status command" \
  "grep -qE '\\| \`status\`' README.md"

check "[from test-documentation.sh] README lists update command" \
  "grep -qE '\\| \`update\`' README.md"

check "[from test-documentation.sh] README lists catalog command" \
  "grep -qE '\\| \`catalog\`' README.md"

check "[from test-documentation.sh] README lists help command" \
  "grep -qE '\\| \`help\`' README.md"

check "[from test-documentation.sh] README lists configure command" \
  "grep -qE '\\| \`configure\`' README.md"

check "[from test-documentation.sh] README has skill count badge" \
  "grep -qE 'skills-[0-9]+' README.md"

check "[from test-documentation.sh] README links to docs/CONTRIBUTING.md" \
  "grep -q 'docs/CONTRIBUTING.md' README.md"

check "[from test-documentation.sh] docs/CONTRIBUTING.md exists" \
  "[ -f docs/CONTRIBUTING.md ]"

check "[from test-documentation.sh] CONTRIBUTING.md has 'add skills to the catalog' section" \
  "grep -q 'add skills to the catalog' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md references catalog directory (references/catalog)" \
  "grep -q 'references/catalog' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Skill column" \
  "grep -q 'Skill' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Source column" \
  "grep -q 'Source' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Install column" \
  "grep -q 'Install' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Description column" \
  "grep -q 'Description' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Trigger column" \
  "grep -q 'Trigger' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents When to use column" \
  "grep -q 'When to use' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md shows trigger format (/skill-name)" \
  "grep -q '/skill-name' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md shows auto trigger" \
  "grep -q 'auto' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md shows install command syntax" \
  "grep -q 'npx skills@latest add' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Module architecture" \
  "grep -q 'Module architecture' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Scanner module" \
  "grep -q 'Scanner' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Questionnaire module" \
  "grep -q 'Questionnaire' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Skill Resolver module" \
  "grep -q 'Skill Resolver' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Installer module" \
  "grep -q 'Installer' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Configurator module" \
  "grep -q 'Configurator' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Drift Detector module" \
  "grep -q 'Drift Detector' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md documents Testing requirements" \
  "grep -q 'Testing requirements' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md has PR guidelines" \
  "grep -q 'PR guidelines' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md mentions Conventional Commit" \
  "grep -q 'Conventional Commit' docs/CONTRIBUTING.md"

check "[from test-documentation.sh] CONTRIBUTING.md mentions 'One skill per PR'" \
  "grep -q 'One skill per PR' docs/CONTRIBUTING.md"

# INDEX.md total skills count (from test-documentation.sh — destination: catalog-integrity.sh)
# This assertion is in the audit as catalog-integrity.sh destination but adding here as well
check "[from test-documentation.sh] INDEX.md has 'Total skills catalogued' count" \
  "grep -q 'Total skills catalogued' power-engineer/references/catalog/INDEX.md"

# ─── ported from test-help-cheatsheet.sh ─────────────────────
check "[from test-help-cheatsheet.sh] references/flows/help.md exists" \
  "[ -f power-engineer/references/flows/help.md ]"

check "[from test-help-cheatsheet.sh] help.md references state.json" \
  "grep -q 'state.json' power-engineer/references/flows/help.md"

check "[from test-help-cheatsheet.sh] help.md has 'No Power Engineer setup found' message" \
  "grep -q 'No Power Engineer setup found' power-engineer/references/flows/help.md"

check "[from test-help-cheatsheet.sh] help.md instructs user to run /power-engineer first" \
  "grep -q 'Run \`/power-engineer\` first' power-engineer/references/flows/help.md"

check "[from test-help-cheatsheet.sh] help.md groups skills by category" \
  "grep -qE 'catalog category|Group' power-engineer/references/flows/help.md"

check "[from test-help-cheatsheet.sh] help.md excludes MCP servers" \
  "grep -q 'MCP server' power-engineer/references/flows/help.md"

check "[from test-help-cheatsheet.sh] configurator.md references cheatsheet.md" \
  "grep -q 'cheatsheet.md' power-engineer/references/modules/configurator.md"

check "[from test-help-cheatsheet.sh] configurator.md Step 6 is 'Generate cheatsheet'" \
  "grep -q 'Step 6: Generate cheatsheet' power-engineer/references/modules/configurator.md"

check "[from test-help-cheatsheet.sh] configurator.md Step 9 is 'Present configuration summary'" \
  "grep -q 'Step 9: Present configuration summary' power-engineer/references/modules/configurator.md"

check "[from test-help-cheatsheet.sh] post-install summary mentions cheatsheet" \
  "grep -A 20 'Step 9: Present configuration summary' power-engineer/references/modules/configurator.md | grep -q 'cheatsheet'"

check "[from test-help-cheatsheet.sh] configurator cheatsheet references state.json installed_skills" \
  "grep -qE 'installed_skills|state.json' power-engineer/references/modules/configurator.md"

check "[from test-help-cheatsheet.sh] SKILL.md routes 'power engineer help' to help.md" \
  "grep -q 'power engineer help' power-engineer/SKILL.md && grep -q 'references/flows/help.md' power-engineer/SKILL.md"

check "[from test-help-cheatsheet.sh] help route ordered before fallback row" \
  "HELP_LINE=\$(grep -n 'power engineer help' power-engineer/SKILL.md | cut -d: -f1 | head -1); FALLBACK_LINE=\$(grep -n 'anything else' power-engineer/SKILL.md | cut -d: -f1 | head -1); [ -n \"\$HELP_LINE\" ] && [ -n \"\$FALLBACK_LINE\" ] && [ \"\$HELP_LINE\" -lt \"\$FALLBACK_LINE\" ]"

check "[from test-help-cheatsheet.sh] SKILL.md has routing table with fallback row" \
  "grep -q 'anything else' power-engineer/SKILL.md && grep -q 'Route the request' power-engineer/SKILL.md"

# ─── ported from test-platform-parity.sh ─────────────────────
check "[from test-platform-parity.sh] Modules directory exists" \
  "[ -d power-engineer/references/modules ]"

# No platform-conditional code in module files (loop over all modules)
PLATFORM_PATTERNS='os\.platform\(\)|process\.platform|sys\.platform|\buname\s*-[a-z]|\$\(uname\)|\`uname|OSTYPE==|\$OSTYPE\b|MACHTYPE==|\bwin32\b|\bwin64\b|\bcygwin\b|\bmsys\b|if.*==.*darwin|if.*==.*linux|if.*==.*windows|RuntimeInformation\.IsOSPlatform'
for module_file in power-engineer/references/modules/*.md; do
  mname=$(basename "$module_file")
  check "[from test-platform-parity.sh] No platform-conditional code in $mname" \
    "! grep -qiE '$PLATFORM_PATTERNS' '$module_file' 2>/dev/null || grep -iE '$PLATFORM_PATTERNS' '$module_file' 2>/dev/null | grep -qvE 'cross.platform|both.*macOS|both.*linux|macOS and Linux|Linux and macOS|supported on|platform support'"
done

# Each lint script + the canonical runner uses portable shebang.
# Glob stays narrow: tests/run-all.sh + tests/lint/*.sh only. Fixtures
# and any future tests/integration/ are intentionally excluded.
for script in tests/run-all.sh tests/lint/*.sh; do
  [ -f "$script" ] || continue
  sname=$(basename "$script")
  check "[from test-platform-parity.sh] $sname uses portable shebang (#!/usr/bin/env bash)" \
    "head -1 '$script' | grep -q '#!/usr/bin/env bash'"
done

# ─── ported from test-configurator-claudemd.sh ───────────────
check "[from test-configurator-claudemd.sh] configurator.md mentions managed section opening delimiter" \
  "grep -q 'power-engineer:managed-section' power-engineer/references/modules/configurator.md"

check "[from test-configurator-claudemd.sh] configurator.md mentions managed section closing delimiter" \
  "grep -q '/power-engineer:managed-section' power-engineer/references/modules/configurator.md"

# Rewritten 2026-04-15 (Phase 1 remediation, Item 4): configurator.md
# no longer uses the legacy `**Category**:` bold heading for skill
# patching; it uses a `| Skill category | Patch with |` table under
# Step 3. Both legacy checks collapse to this one assertion. The "no
# bare list syntax inside managed section" check is dropped -- the
# managed section now mixes markdown structures and a blanket ban on
# "^- " is too coarse.
check "[from test-configurator-claudemd.sh] configurator.md has Skill category patching table" \
  "grep -qE '^\| Skill category \| Patch' power-engineer/references/modules/configurator.md"

# ─── ported from test-configurator-statejson.sh ─────────────
check "[from test-configurator-statejson.sh] configurator.md mentions installed_skills as array" \
  "grep -q 'installed_skills' power-engineer/references/modules/configurator.md"

check "[from test-configurator-statejson.sh] configurator.md documents name field in skill entries" \
  "grep -q '\"name\"' power-engineer/references/modules/configurator.md"

# Rewritten 2026-04-15 (Phase 1 remediation, Item 4): the `source` field
# was dropped from the `installed_skills` schema. The current schema
# documents `name`, `repo`, `installed_at`, `installed_by` (4 fields).
# The `installed_by` value "power-engineer" has absorbed the old
# source-discrimination role (vs "manual") -- entries without
# `installed_by: "power-engineer"` are implicitly manual. Three stale
# source-* assertions are replaced with checks for the 4 current fields
# and for the "power-engineer" installed_by value. Flagging this as a
# probable regression in the remediation report: no plan decision was
# found that explicitly sanctions dropping `source`, and no
# test-configurator-statejson.sh audit record of this change exists.
# Treating as intentional per current file content; re-adding the
# `source` field is a separate plan decision out of scope for Phase 1.
CONFIGURATOR_MOD="power-engineer/references/modules/configurator.md"

check "[from test-configurator-statejson.sh] configurator.md documents repo field in skill entries" \
  "grep -q '\"repo\"' '$CONFIGURATOR_MOD'"

check "[from test-configurator-statejson.sh] configurator.md documents installed_at field in skill entries" \
  "grep -q '\"installed_at\"' '$CONFIGURATOR_MOD'"

check "[from test-configurator-statejson.sh] configurator.md documents installed_by field in skill entries" \
  "grep -q '\"installed_by\"' '$CONFIGURATOR_MOD'"

check "[from test-configurator-statejson.sh] configurator.md installed_by 'power-engineer' value present" \
  "grep -q '\"installed_by\": \"power-engineer\"' '$CONFIGURATOR_MOD'"

check "[from test-configurator-statejson.sh] configurator.md installed_skills schema has exactly 4 fields (name, repo, installed_at, installed_by)" \
  "grep -A 6 '\"installed_skills\"' '$CONFIGURATOR_MOD' | grep -qE '\"name\".*\"repo\".*\"installed_at\".*\"installed_by\"|\"name\"' && grep -A 8 '\"installed_skills\"' '$CONFIGURATOR_MOD' | grep -q '\"installed_by\"'"

check "[from test-configurator-statejson.sh] configurator.md does NOT use legacy 'source' field in installed_skills schema" \
  "! grep -A 8 '\"installed_skills\"' '$CONFIGURATOR_MOD' | grep -q '\"source\"'"

check "[from test-configurator-statejson.sh] configurator.md documents questionnaire_answers key" \
  "grep -q 'questionnaire_answers' power-engineer/references/modules/configurator.md"

check "[from test-configurator-statejson.sh] configurator.md documents security_needs field" \
  "grep -q 'security_needs' power-engineer/references/modules/configurator.md"

check "[from test-configurator-statejson.sh] configurator.md documents cross_tool_usage field" \
  "grep -q 'cross_tool_usage' power-engineer/references/modules/configurator.md"

# ─── ported from test-security-resolver-wiring.sh ────────────
RESOLVER="power-engineer/references/modules/skill-resolver.md"

check "[from test-security-resolver-wiring.sh] new security level section heading present" \
  "grep -q '## Security level (from Q12 — new security levels)' '$RESOLVER'"

check "[from test-security-resolver-wiring.sh] Standard branch present" \
  "grep -q '\*\*Standard:\*\*' '$RESOLVER'"

check "[from test-security-resolver-wiring.sh] Enhanced branch present" \
  "grep -q '\*\*Enhanced:\*\*' '$RESOLVER'"

check "[from test-security-resolver-wiring.sh] Maximum branch present" \
  "grep -q '\*\*Maximum:\*\*' '$RESOLVER'"

check "[from test-security-resolver-wiring.sh] Compliance branch present" \
  "grep -q '\*\*Compliance:\*\*' '$RESOLVER'"

check "[from test-security-resolver-wiring.sh] Custom branch present" \
  "grep -q '\*\*Custom:\*\*' '$RESOLVER'"

check "[from test-security-resolver-wiring.sh] Standard branch adds no kalshamsi skills" \
  "awk '/\*\*Standard:\*\*/,/\*\*Enhanced:\*\*/' '$RESOLVER' | grep -v 'npx skills@latest add kalshamsi' > /dev/null && ! awk '/\*\*Standard:\*\*/,/\*\*Enhanced:\*\*/' '$RESOLVER' | grep -q 'npx skills@latest add kalshamsi'"

check "[from test-security-resolver-wiring.sh] Enhanced includes security-headers-audit" \
  "awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' '$RESOLVER' | grep -q 'security-headers-audit'"

check "[from test-security-resolver-wiring.sh] Enhanced includes crypto-audit" \
  "awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' '$RESOLVER' | grep -q 'crypto-audit'"

check "[from test-security-resolver-wiring.sh] Enhanced includes api-security-tester" \
  "awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' '$RESOLVER' | grep -q 'api-security-tester'"

check "[from test-security-resolver-wiring.sh] Enhanced does NOT include bandit-sast" \
  "! awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' '$RESOLVER' | grep -q 'bandit-sast'"

check "[from test-security-resolver-wiring.sh] Enhanced does NOT include socket-sca" \
  "! awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' '$RESOLVER' | grep -q 'socket-sca'"

check "[from test-security-resolver-wiring.sh] Enhanced does NOT include docker-scout-scanner" \
  "! awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' '$RESOLVER' | grep -q 'docker-scout-scanner'"

check "[from test-security-resolver-wiring.sh] Enhanced does NOT include pci-dss-audit" \
  "! awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' '$RESOLVER' | grep -q 'pci-dss-audit'"

check "[from test-security-resolver-wiring.sh] Enhanced does NOT include mobile-security" \
  "! awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' '$RESOLVER' | grep -q 'mobile-security'"

check "[from test-security-resolver-wiring.sh] Maximum includes security-headers-audit" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -q 'security-headers-audit'"

check "[from test-security-resolver-wiring.sh] Maximum includes crypto-audit" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -q 'crypto-audit'"

check "[from test-security-resolver-wiring.sh] Maximum includes api-security-tester" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -q 'api-security-tester'"

check "[from test-security-resolver-wiring.sh] Maximum includes bandit-sast" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -q 'bandit-sast'"

check "[from test-security-resolver-wiring.sh] Maximum includes socket-sca" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -q 'socket-sca'"

check "[from test-security-resolver-wiring.sh] Maximum includes docker-scout-scanner" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -q 'docker-scout-scanner'"

check "[from test-security-resolver-wiring.sh] Maximum includes security-test-generator" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -q 'security-test-generator'"

check "[from test-security-resolver-wiring.sh] Maximum includes devsecops-pipeline" \
  "awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -q 'devsecops-pipeline'"

check "[from test-security-resolver-wiring.sh] Maximum does NOT include pci-dss-audit" \
  "! awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -q 'pci-dss-audit'"

check "[from test-security-resolver-wiring.sh] Maximum does NOT include mobile-security" \
  "! awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -q 'mobile-security'"

check "[from test-security-resolver-wiring.sh] Compliance includes security-headers-audit" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -q 'security-headers-audit'"

check "[from test-security-resolver-wiring.sh] Compliance includes crypto-audit" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -q 'crypto-audit'"

check "[from test-security-resolver-wiring.sh] Compliance includes api-security-tester" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -q 'api-security-tester'"

check "[from test-security-resolver-wiring.sh] Compliance includes bandit-sast" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -q 'bandit-sast'"

check "[from test-security-resolver-wiring.sh] Compliance includes socket-sca" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -q 'socket-sca'"

check "[from test-security-resolver-wiring.sh] Compliance includes docker-scout-scanner" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -q 'docker-scout-scanner'"

check "[from test-security-resolver-wiring.sh] Compliance includes security-test-generator" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -q 'security-test-generator'"

check "[from test-security-resolver-wiring.sh] Compliance includes devsecops-pipeline" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -q 'devsecops-pipeline'"

check "[from test-security-resolver-wiring.sh] Compliance includes pci-dss-audit" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -q 'pci-dss-audit'"

check "[from test-security-resolver-wiring.sh] Compliance includes mobile-security" \
  "awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -q 'mobile-security'"

check "[from test-security-resolver-wiring.sh] Custom includes security-headers-audit" \
  "awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -q 'security-headers-audit'"

check "[from test-security-resolver-wiring.sh] Custom includes crypto-audit" \
  "awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -q 'crypto-audit'"

check "[from test-security-resolver-wiring.sh] Custom includes api-security-tester" \
  "awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -q 'api-security-tester'"

check "[from test-security-resolver-wiring.sh] Custom includes bandit-sast" \
  "awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -q 'bandit-sast'"

check "[from test-security-resolver-wiring.sh] Custom includes socket-sca" \
  "awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -q 'socket-sca'"

check "[from test-security-resolver-wiring.sh] Custom includes docker-scout-scanner" \
  "awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -q 'docker-scout-scanner'"

check "[from test-security-resolver-wiring.sh] Custom includes security-test-generator" \
  "awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -q 'security-test-generator'"

check "[from test-security-resolver-wiring.sh] Custom includes devsecops-pipeline" \
  "awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -q 'devsecops-pipeline'"

check "[from test-security-resolver-wiring.sh] Custom includes pci-dss-audit" \
  "awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -q 'pci-dss-audit'"

check "[from test-security-resolver-wiring.sh] Custom includes mobile-security" \
  "awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -q 'mobile-security'"

check "[from test-security-resolver-wiring.sh] No duplicate security-headers-audit in Enhanced block" \
  "[ \$(awk '/\*\*Enhanced:\*\*/,/\*\*Maximum:\*\*/' '$RESOLVER' | grep -c 'security-headers-audit') -le 1 ]"

check "[from test-security-resolver-wiring.sh] No duplicate bandit-sast in Maximum block" \
  "[ \$(awk '/\*\*Maximum:\*\*/,/\*\*Compliance:\*\*/' '$RESOLVER' | grep -c 'bandit-sast') -le 1 ]"

check "[from test-security-resolver-wiring.sh] No duplicate pci-dss-audit in Compliance block" \
  "[ \$(awk '/\*\*Compliance:\*\*/,/\*\*Custom:\*\*/' '$RESOLVER' | grep -c 'pci-dss-audit') -le 1 ]"

check "[from test-security-resolver-wiring.sh] No duplicate mobile-security in Custom block" \
  "[ \$(awk '/\*\*Custom:\*\*/,/^---/' '$RESOLVER' | grep -c 'mobile-security') -le 1 ]"

[ "$FAIL" -eq 0 ] || exit 1
echo "  ✓ doc structure OK"
