#!/usr/bin/env bash
# Integration test: Skill index generation
# Validates grouping, completeness, and provenance cross-reference from state.json
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

echo "=== Test: Skill Index Generation ==="
echo ""

# --- Setup: mock .claude/skills/ with SKILL.md files ---
SKILLS_DIR="$TMPDIR_TEST/.claude/skills"

# Create each skill directory with a SKILL.md containing its category
mkdir -p "$SKILLS_DIR/brainstorming"
printf '# brainstorming\n\nCategory: Core Methodology\n\nThis is the brainstorming skill.\n' \
  > "$SKILLS_DIR/brainstorming/SKILL.md"

mkdir -p "$SKILLS_DIR/writing-plans"
printf '# writing-plans\n\nCategory: Core Methodology\n\nThis is the writing-plans skill.\n' \
  > "$SKILLS_DIR/writing-plans/SKILL.md"

mkdir -p "$SKILLS_DIR/test-driven-development"
printf '# test-driven-development\n\nCategory: Core Methodology\n\nThis is the tdd skill.\n' \
  > "$SKILLS_DIR/test-driven-development/SKILL.md"

mkdir -p "$SKILLS_DIR/firecrawl"
printf '# firecrawl\n\nCategory: Research & Data\n\nThis is the firecrawl skill.\n' \
  > "$SKILLS_DIR/firecrawl/SKILL.md"

mkdir -p "$SKILLS_DIR/tavily-search"
printf '# tavily-search\n\nCategory: Research & Data\n\nThis is the tavily-search skill.\n' \
  > "$SKILLS_DIR/tavily-search/SKILL.md"

mkdir -p "$SKILLS_DIR/frontend-design"
printf '# frontend-design\n\nCategory: Design\n\nThis is the frontend-design skill.\n' \
  > "$SKILLS_DIR/frontend-design/SKILL.md"

mkdir -p "$SKILLS_DIR/shadcn-ui"
printf '# shadcn-ui\n\nCategory: Design\n\nThis is the shadcn-ui skill.\n' \
  > "$SKILLS_DIR/shadcn-ui/SKILL.md"

# --- Setup: state.json with provenance ---
cat > "$TMPDIR_TEST/state.json" << 'EOF'
{
  "version": "2.0",
  "installed_skills": [
    {"name": "brainstorming",           "source": "power-engineer", "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:00:00Z", "installed_by": "power-engineer"},
    {"name": "writing-plans",           "source": "power-engineer", "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:00:00Z", "installed_by": "power-engineer"},
    {"name": "test-driven-development", "source": "manual",         "repo": "obra/superpowers",  "installed_at": "2026-03-25T10:01:00Z", "installed_by": "power-engineer"},
    {"name": "firecrawl",               "source": "power-engineer", "repo": "mendableai/firecrawl-skills", "installed_at": "2026-03-25T10:02:00Z", "installed_by": "power-engineer"},
    {"name": "tavily-search",           "source": "power-engineer", "repo": "tavily/skills",     "installed_at": "2026-03-25T10:02:00Z", "installed_by": "power-engineer"},
    {"name": "frontend-design",         "source": "manual",         "repo": "anthropics/skills", "installed_at": "2026-03-25T10:03:00Z", "installed_by": "user"},
    {"name": "shadcn-ui",               "source": "power-engineer", "repo": "anthropics/skills", "installed_at": "2026-03-25T10:03:00Z", "installed_by": "power-engineer"}
  ]
}
EOF

# --- Index generation function (bash 3.2-compatible, no associative arrays) ---
# Uses a flat temp file to accumulate category->skills mapping
generate_skill_index() {
  local skills_dir="$1"
  local output_file="$2"
  local cat_file
  cat_file=$(mktemp)
  # cat_file format: one line per skill: "Category|skill-name"
  for skill_dir in "$skills_dir"/*/; do
    [ -d "$skill_dir" ] || continue
    local skill_name category skill_md
    skill_name=$(basename "$skill_dir")
    skill_md="$skill_dir/SKILL.md"
    if [ -f "$skill_md" ]; then
      category=$(grep '^Category:' "$skill_md" | sed 's/Category: //' | tr -d '\r')
    else
      category="Uncategorized"
    fi
    echo "$category|$skill_name" >> "$cat_file"
  done

  # Collect unique categories
  > "$output_file"
  sort -u "$cat_file" | awk -F'|' '{print $1}' | sort -u | while IFS= read -r cat; do
    skills=$(grep "^$cat|" "$cat_file" | awk -F'|' '{print $2}' | sort | paste -sd ', ' -)
    echo "**$cat**: $skills" >> "$output_file"
  done
  rm -f "$cat_file"
}

INDEX_FILE="$TMPDIR_TEST/skill-index.md"
generate_skill_index "$SKILLS_DIR" "$INDEX_FILE"

echo "Completeness — all skills appear in index:"

for skill in brainstorming writing-plans test-driven-development firecrawl tavily-search frontend-design shadcn-ui; do
  check "Skill '$skill' appears in generated index" \
    "grep -q '$skill' '$INDEX_FILE'"
done

echo ""
echo "Grouping — categories correct:"

check "Core Methodology category exists in index" \
  "grep -q 'Core Methodology' '$INDEX_FILE'"

check "Research & Data category exists in index" \
  "grep -q 'Research & Data' '$INDEX_FILE'"

check "Design category exists in index" \
  "grep -q 'Design' '$INDEX_FILE'"

check "Index uses bold-category format" \
  "grep -qE '^\*\*[A-Za-z &]+\*\*: ' '$INDEX_FILE'"

echo ""
echo "Provenance cross-reference from state.json:"

# Extract manual-sourced skill names from state.json
manual_skill=$(awk '
  /"name": "/{split($0,a,"\""); nm=a[4]}
  /"source": "manual"/{print nm; exit}
' "$TMPDIR_TEST/state.json")

manual_skill2=$(awk '
  /"name": "/{split($0,a,"\""); nm=a[4]}
  /"source": "manual"/{count++; if(count==2){print nm; exit}}
' "$TMPDIR_TEST/state.json")

check "Manual-sourced skill ($manual_skill) appears on disk" \
  "[ -d '$SKILLS_DIR/$manual_skill' ]"

check "Manually-sourced skill ($manual_skill2) appears on disk" \
  "[ -d '$SKILLS_DIR/$manual_skill2' ]"

check "All state.json skills have corresponding dirs on disk" \
  "awk -F'\"' '/\"name\":/{print \$4}' '$TMPDIR_TEST/state.json' | while IFS= read -r s; do [ -d '$SKILLS_DIR/'\$s ] || { echo \"MISSING: \$s\"; exit 1; }; done"

echo ""
echo "Disk vs state completeness:"

disk_count=$(ls -d "$SKILLS_DIR"/*/ 2>/dev/null | wc -l | tr -d ' ')
state_count=$(grep -c '"name":' "$TMPDIR_TEST/state.json" || true)
check "Disk skill count ($disk_count) matches state.json count ($state_count)" \
  "[ '$disk_count' -eq '$state_count' ]"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
