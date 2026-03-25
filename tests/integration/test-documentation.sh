#!/usr/bin/env bash
# Integration tests for Phase 6: Documentation + Contributor Guide
# Tests: README quick-start, CONTRIBUTING.md existence, trigger map fields

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
README="$REPO_ROOT/README.md"
CONTRIBUTING="$REPO_ROOT/docs/CONTRIBUTING.md"
INDEX="$REPO_ROOT/power-engineer/references/catalog/INDEX.md"

FAILURES=0

check() {
  local description="$1"
  local result="$2"
  local expected="$3"
  if echo "$result" | grep -q "$expected"; then
    echo "PASS: $description"
  else
    echo "FAIL: $description"
    echo "  Expected to find: $expected"
    FAILURES=$((FAILURES + 1))
  fi
}

check_file_exists() {
  local description="$1"
  local filepath="$2"
  if [ -f "$filepath" ]; then
    echo "PASS: $description"
  else
    echo "FAIL: $description — file not found: $filepath"
    FAILURES=$((FAILURES + 1))
  fi
}

echo "=== Documentation tests ==="
echo ""

# README existence
check_file_exists "README.md exists" "$README"

# README quick-start section
readme_content=$(cat "$README")
check "README has quick-start section" "$readme_content" "Quick start"
check "README quick-start mentions under 2 minutes" "$readme_content" "under 2 minutes"
check "README quick-start has 3 steps" "$readme_content" "Step 1"
check "README quick-start has install step" "$readme_content" "npx skills@latest add"
check "README quick-start has run step" "$readme_content" "/power-engineer"

# README explainer for beginners
check "README has beginner explainer section" "$readme_content" "Beginner guide"
check "README explains what skills are" "$readme_content" "What are Claude Code skills"
check "README explains what power-engineer does" "$readme_content" "What does Power Engineer do"

# README command reference
check "README has command reference table" "$readme_content" "Command reference"
check "README lists power-engineer command" "$readme_content" "power-engineer"
check "README lists quick command" "$readme_content" "quick"
check "README lists frontend command" "$readme_content" "frontend"
check "README lists backend command" "$readme_content" "backend"
check "README lists devops command" "$readme_content" "devops"
check "README lists ai command" "$readme_content" "| \`ai\`"
check "README lists data command" "$readme_content" "| \`data\`"
check "README lists docs command" "$readme_content" "| \`docs\`"
check "README lists mobile command" "$readme_content" "| \`mobile\`"
check "README lists status command" "$readme_content" "| \`status\`"
check "README lists update command" "$readme_content" "| \`update\`"
check "README lists catalog command" "$readme_content" "| \`catalog\`"
check "README lists help command" "$readme_content" "| \`help\`"
check "README lists configure command" "$readme_content" "| \`configure\`"

# README skill count
check "README references 290+ skills" "$readme_content" "290+"

# README links to CONTRIBUTING.md
check "README links to docs/CONTRIBUTING.md" "$readme_content" "docs/CONTRIBUTING.md"

# CONTRIBUTING.md existence
check_file_exists "docs/CONTRIBUTING.md exists" "$CONTRIBUTING"

# CONTRIBUTING.md catalog contribution section
contributing_content=$(cat "$CONTRIBUTING")
check "CONTRIBUTING.md has catalog section" "$contributing_content" "add skills to the catalog"
check "CONTRIBUTING.md references catalog directory" "$contributing_content" "references/catalog"
check "CONTRIBUTING.md documents Skill column" "$contributing_content" "Skill"
check "CONTRIBUTING.md documents Source column" "$contributing_content" "Source"
check "CONTRIBUTING.md documents Install column" "$contributing_content" "Install"
check "CONTRIBUTING.md documents Description column" "$contributing_content" "Description"
check "CONTRIBUTING.md documents Trigger column" "$contributing_content" "Trigger"
check "CONTRIBUTING.md documents When to use column" "$contributing_content" "When to use"
check "CONTRIBUTING.md shows trigger format" "$contributing_content" "/skill-name"
check "CONTRIBUTING.md shows auto trigger" "$contributing_content" "auto"
check "CONTRIBUTING.md shows install command syntax" "$contributing_content" "npx skills@latest add"

# CONTRIBUTING.md module architecture
check "CONTRIBUTING.md documents module architecture" "$contributing_content" "Module architecture"
check "CONTRIBUTING.md documents scanner module" "$contributing_content" "Scanner"
check "CONTRIBUTING.md documents questionnaire module" "$contributing_content" "Questionnaire"
check "CONTRIBUTING.md documents skill-resolver module" "$contributing_content" "Skill Resolver"
check "CONTRIBUTING.md documents installer module" "$contributing_content" "Installer"
check "CONTRIBUTING.md documents configurator module" "$contributing_content" "Configurator"
check "CONTRIBUTING.md documents drift-detector module" "$contributing_content" "Drift Detector"

# CONTRIBUTING.md testing requirements
check "CONTRIBUTING.md documents testing requirements" "$contributing_content" "Testing requirements"
check "CONTRIBUTING.md uses check() bash pattern" "$contributing_content" "check()"
check "CONTRIBUTING.md references integration tests dir" "$contributing_content" "tests/integration"
check "CONTRIBUTING.md documents run-tests command" "$contributing_content" "tests/run-tests.sh"

# CONTRIBUTING.md PR guidelines
check "CONTRIBUTING.md has PR guidelines" "$contributing_content" "PR guidelines"
check "CONTRIBUTING.md mentions conventional commits" "$contributing_content" "Conventional Commit"
check "CONTRIBUTING.md mentions one skill per PR" "$contributing_content" "One skill per PR"

# INDEX.md skill count updated
index_content=$(cat "$INDEX")
check "INDEX.md updated to 290+ skills" "$index_content" "290+"

echo ""
echo "=== Results ==="
if [ "$FAILURES" -eq 0 ]; then
  echo "All tests passed."
else
  echo "$FAILURES test(s) failed."
  exit 1
fi
