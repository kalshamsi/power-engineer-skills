#!/usr/bin/env bash
# Integration test: Drift detector skill discovery
# Validates detection of new/removed skills and provenance tagging
# Shell-portable: works on bash 3.2+ (macOS default) and Linux
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

echo "=== Test: Drift Detector Skill Discovery ==="
echo ""

# --- Setup: state.json (what was recorded at install time) ---
cat > "$TMPDIR_TEST/state.json" << 'EOF'
{
  "version": "2.0",
  "installed_skills": [
    {"name": "brainstorming",           "source": "power-engineer", "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:00:00Z", "installed_by": "power-engineer"},
    {"name": "writing-plans",           "source": "power-engineer", "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:00:00Z", "installed_by": "power-engineer"},
    {"name": "test-driven-development", "source": "manual",         "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:01:00Z", "installed_by": "power-engineer"},
    {"name": "firecrawl",               "source": "power-engineer", "repo": "mendableai/firecrawl-skills", "installed_at": "2026-03-25T10:02:00Z", "installed_by": "power-engineer"},
    {"name": "removed-skill",           "source": "power-engineer", "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:03:00Z", "installed_by": "power-engineer"},
    {"name": "another-removed",         "source": "manual",         "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:04:00Z", "installed_by": "power-engineer"}
  ]
}
EOF

# --- Setup: .claude/skills/ on disk (additions and removals vs state.json) ---
SKILLS_DIR="$TMPDIR_TEST/.claude/skills"
mkdir -p "$SKILLS_DIR"

# Present on disk (some from state.json, some new)
for skill in brainstorming writing-plans test-driven-development firecrawl manually-added-skill another-manual; do
  mkdir -p "$SKILLS_DIR/$skill"
done
# NOTE: removed-skill and another-removed are NOT on disk (simulating manual removal)
# NOTE: manually-added-skill and another-manual are NOT in state.json (simulating manual add)

# --- Drift detection functions (bash 3.2-compatible, no array appending under set -u) ---

detect_new_skills() {
  local skills_dir="$1"
  local state_file="$2"
  for skill_dir in "$skills_dir"/*/; do
    [ -d "$skill_dir" ] || continue
    local skill_name
    skill_name=$(basename "$skill_dir")
    if ! grep -q "\"$skill_name\"" "$state_file"; then
      echo "$skill_name"
    fi
  done
}

detect_removed_skills() {
  local skills_dir="$1"
  local state_file="$2"
  grep '"name":' "$state_file" | sed 's/.*"name": "//;s/".*//' | while IFS= read -r skill_name; do
    [ -z "$skill_name" ] && continue
    if [ ! -d "$skills_dir/$skill_name" ]; then
      echo "$skill_name"
    fi
  done
}

get_provenance() {
  local skill_name="$1"
  local state_file="$2"
  # Each skill is on one line: {"name": "X", "source": "Y", ...}
  # Extract the source value for the matching skill name using grep + sed
  grep "\"$skill_name\"" "$state_file" | sed 's/.*"source": "//;s/".*//' | head -1
}

NEW_SKILLS=$(detect_new_skills "$SKILLS_DIR" "$TMPDIR_TEST/state.json")
REMOVED_SKILLS=$(detect_removed_skills "$SKILLS_DIR" "$TMPDIR_TEST/state.json")

echo "New skills (on disk, not in state.json):"

check "manually-added-skill detected as new" \
  "echo '$NEW_SKILLS' | grep -q 'manually-added-skill'"

check "another-manual detected as new" \
  "echo '$NEW_SKILLS' | grep -q 'another-manual'"

new_count=$(echo "$NEW_SKILLS" | grep -c '[a-z]' || true)
check "Exactly 2 new skills detected" \
  "[ '$new_count' -eq 2 ]"

check "brainstorming NOT flagged as new (exists in state)" \
  "! echo '$NEW_SKILLS' | grep -q 'brainstorming'"

check "writing-plans NOT flagged as new (exists in state)" \
  "! echo '$NEW_SKILLS' | grep -q 'writing-plans'"

echo ""
echo "Removed skills (in state.json, not on disk):"

check "removed-skill detected as removed" \
  "echo '$REMOVED_SKILLS' | grep -q 'removed-skill'"

check "another-removed detected as removed" \
  "echo '$REMOVED_SKILLS' | grep -q 'another-removed'"

removed_count=$(echo "$REMOVED_SKILLS" | grep -c '[a-z]' || true)
check "Exactly 2 removed skills detected" \
  "[ '$removed_count' -eq 2 ]"

check "brainstorming NOT flagged as removed (still on disk)" \
  "! echo '$REMOVED_SKILLS' | grep -q 'brainstorming'"

check "firecrawl NOT flagged as removed (still on disk)" \
  "! echo '$REMOVED_SKILLS' | grep -q 'firecrawl'"

echo ""
echo "Provenance tagging:"

prov_brainstorming=$(get_provenance "brainstorming" "$TMPDIR_TEST/state.json")
prov_tdd=$(get_provenance "test-driven-development" "$TMPDIR_TEST/state.json")
prov_removed=$(get_provenance "removed-skill" "$TMPDIR_TEST/state.json")
prov_another_removed=$(get_provenance "another-removed" "$TMPDIR_TEST/state.json")

check "brainstorming provenance is 'power-engineer'" \
  "[ '$prov_brainstorming' = 'power-engineer' ]"

check "test-driven-development provenance is 'manual'" \
  "[ '$prov_tdd' = 'manual' ]"

check "removed-skill provenance is 'power-engineer'" \
  "[ '$prov_removed' = 'power-engineer' ]"

check "another-removed provenance is 'manual'" \
  "[ '$prov_another_removed' = 'manual' ]"

echo ""
echo "No-drift scenario:"

# When state and disk match exactly, no drift
NODRIFT_DIR="$TMPDIR_TEST/.claude/skills-nodrift"
mkdir -p "$NODRIFT_DIR"
cat > "$TMPDIR_TEST/state-nodrift.json" << 'EOF'
{
  "version": "2.0",
  "installed_skills": [
    {"name": "skill-a", "source": "power-engineer", "repo": "org/repo", "installed_at": "2026-03-25T10:00:00Z", "installed_by": "power-engineer"},
    {"name": "skill-b", "source": "power-engineer", "repo": "org/repo", "installed_at": "2026-03-25T10:00:00Z", "installed_by": "power-engineer"}
  ]
}
EOF
mkdir -p "$NODRIFT_DIR/skill-a" "$NODRIFT_DIR/skill-b"

NODRIFT_NEW=$(detect_new_skills "$NODRIFT_DIR" "$TMPDIR_TEST/state-nodrift.json")
NODRIFT_REMOVED=$(detect_removed_skills "$NODRIFT_DIR" "$TMPDIR_TEST/state-nodrift.json")

check "No new skills when disk matches state" \
  "[ -z '$NODRIFT_NEW' ]"

check "No removed skills when disk matches state" \
  "[ -z '$NODRIFT_REMOVED' ]"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
