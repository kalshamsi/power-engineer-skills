#!/usr/bin/env bash
# Integration test: Post-install verification
# Validates skill count vs directory count, managed section detection
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

TMPDIR_TEST=$(mktemp -d)
trap 'rm -rf "$TMPDIR_TEST"' EXIT

echo "=== Test: Post-Install Verification ==="
echo ""

# --- Setup: mock .claude/skills/ with 5 skills ---
SKILLS_DIR="$TMPDIR_TEST/.claude/skills"
mkdir -p "$SKILLS_DIR"
for skill in brainstorming writing-plans test-driven-development firecrawl shadcn-ui; do
  mkdir -p "$SKILLS_DIR/$skill"
done

# --- Setup: state.json recording 5 installed skills ---
cat > "$TMPDIR_TEST/state.json" << 'EOF'
{
  "version": "2.0",
  "installed_skills": [
    {"name": "brainstorming",           "source": "power-engineer", "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:00:00Z", "installed_by": "power-engineer"},
    {"name": "writing-plans",           "source": "power-engineer", "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:00:00Z", "installed_by": "power-engineer"},
    {"name": "test-driven-development", "source": "power-engineer", "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:01:00Z", "installed_by": "power-engineer"},
    {"name": "firecrawl",               "source": "power-engineer", "repo": "mendableai/firecrawl-skills", "installed_at": "2026-03-25T10:02:00Z", "installed_by": "power-engineer"},
    {"name": "shadcn-ui",               "source": "power-engineer", "repo": "anthropics/skills", "installed_at": "2026-03-25T10:03:00Z", "installed_by": "power-engineer"}
  ]
}
EOF

# --- Setup: CLAUDE.md ---
cat > "$TMPDIR_TEST/CLAUDE.md" << 'EOF'
# My Project

## Power Engineer
<!-- power-engineer:managed-section -->

### Installed Skills
**Core Methodology**: brainstorming, writing-plans, test-driven-development
**Research & Data**: firecrawl
**Design**: shadcn-ui

<!-- /power-engineer:managed-section -->
EOF

# --- Setup: mismatch scenario (state says 5, only 3 on disk) ---
SKILLS_MISMATCH="$TMPDIR_TEST/.claude/skills-mismatch"
mkdir -p "$SKILLS_MISMATCH"
for skill in brainstorming writing-plans test-driven-development; do
  mkdir -p "$SKILLS_MISMATCH/$skill"
done

echo "Skill count verification:"

disk_count=$(ls -d "$SKILLS_DIR"/*/ 2>/dev/null | wc -l | tr -d ' ')
state_count=$(grep -c '"name":' "$TMPDIR_TEST/state.json" || true)

check "Disk skill count is 5" \
  "[ '$disk_count' -eq 5 ]"

check "State skill count is 5" \
  "[ '$state_count' -eq 5 ]"

check "Disk count matches state count" \
  "[ '$disk_count' -eq '$state_count' ]"

# Mismatch detection
mismatch_disk=$(ls -d "$SKILLS_MISMATCH"/*/ 2>/dev/null | wc -l | tr -d ' ')
check "Mismatch detected: disk ($mismatch_disk) differs from state ($state_count)" \
  "[ '$mismatch_disk' -ne '$state_count' ]"

echo ""
echo "Managed section detection:"

check "CLAUDE.md: managed section present" \
  "grep -q '<!-- power-engineer:managed-section -->' '$TMPDIR_TEST/CLAUDE.md'"

check "CLAUDE.md: no Orchestration header" \
  "! grep -q '### Orchestration' '$TMPDIR_TEST/CLAUDE.md'"

echo ""
echo "Skill name cross-check (state vs disk):"

all_match=true
while IFS= read -r skill_name; do
  [ -z "$skill_name" ] && continue
  if [ ! -d "$SKILLS_DIR/$skill_name" ]; then
    all_match=false
    break
  fi
done < <(grep '"name":' "$TMPDIR_TEST/state.json" | sed 's/.*"name": "//;s/".*//')

check "All state.json skills found on disk" \
  "[ '$all_match' = 'true' ]"

# Each skill mentioned in CLAUDE.md index also exists on disk
while IFS= read -r line; do
  # Extract skill names from "**Category**: skill1, skill2" format
  skills_part=$(echo "$line" | sed 's/^\*\*[^*]*\*\*: //')
  IFS=', ' read -ra skills_arr <<< "$skills_part"
  for skill in "${skills_arr[@]}"; do
    skill=$(echo "$skill" | tr -d '[:space:]')
    [ -z "$skill" ] && continue
    if [ ! -d "$SKILLS_DIR/$skill" ]; then
      check "Skill '$skill' from CLAUDE.md index exists on disk" "false"
    else
      check "Skill '$skill' from CLAUDE.md index exists on disk" "true"
    fi
  done
done < <(awk '/<!-- power-engineer:managed-section -->/{found=1;next} /<!-- \/power-engineer:managed-section -->/{found=0} found && /^\*\*/' "$TMPDIR_TEST/CLAUDE.md")

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
