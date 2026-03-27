#!/usr/bin/env bash
# Integration test: Skill conflict detection
# Validates intersection logic between installed skill dirs and proposed skill list
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

echo "=== Test: Skill Conflict Detection ==="
echo ""

# --- Setup: mock .claude/skills/ directory ---
SKILLS_DIR="$TMPDIR_TEST/.claude/skills"
mkdir -p "$SKILLS_DIR"

# Simulate already-installed skills (directories)
for skill in brainstorming writing-plans test-driven-development systematic-debugging; do
  mkdir -p "$SKILLS_DIR/$skill"
done

# --- Setup: proposed skill list (mix of new and existing) ---
PROPOSED_LIST="$TMPDIR_TEST/proposed-skills.txt"
cat > "$PROPOSED_LIST" << 'EOF'
brainstorming
writing-plans
firecrawl
tavily-search
frontend-design
test-driven-development
new-skill-alpha
EOF

# --- Conflict detection function (simulates installer logic) ---
detect_conflicts() {
  local skills_dir="$1"
  local proposed_file="$2"
  while IFS= read -r skill; do
    skill=$(echo "$skill" | tr -d '[:space:]')
    [ -z "$skill" ] && continue
    if [ -d "$skills_dir/$skill" ]; then
      echo "$skill"
    fi
  done < "$proposed_file"
}

detect_new_skills() {
  local skills_dir="$1"
  local proposed_file="$2"
  while IFS= read -r skill; do
    skill=$(echo "$skill" | tr -d '[:space:]')
    [ -z "$skill" ] && continue
    if [ ! -d "$skills_dir/$skill" ]; then
      echo "$skill"
    fi
  done < "$proposed_file"
}

CONFLICTS=$(detect_conflicts "$SKILLS_DIR" "$PROPOSED_LIST")
NEW_SKILLS=$(detect_new_skills "$SKILLS_DIR" "$PROPOSED_LIST")

echo "Intersection (conflict) detection:"

check "brainstorming flagged as conflict" \
  "echo '$CONFLICTS' | grep -q 'brainstorming'"

check "writing-plans flagged as conflict" \
  "echo '$CONFLICTS' | grep -q 'writing-plans'"

check "test-driven-development flagged as conflict" \
  "echo '$CONFLICTS' | grep -q 'test-driven-development'"

check "firecrawl NOT flagged as conflict (not installed)" \
  "! echo '$CONFLICTS' | grep -q 'firecrawl'"

check "tavily-search NOT flagged as conflict (not installed)" \
  "! echo '$CONFLICTS' | grep -q 'tavily-search'"

check "frontend-design NOT flagged as conflict (not installed)" \
  "! echo '$CONFLICTS' | grep -q 'frontend-design'"

check "new-skill-alpha NOT flagged as conflict (not installed)" \
  "! echo '$CONFLICTS' | grep -q 'new-skill-alpha'"

echo ""
echo "Non-intersecting skills not flagged:"

conflict_count=$(echo "$CONFLICTS" | grep -c '[a-z]' || true)
check "Exactly 3 conflicts detected (brainstorming, writing-plans, test-driven-development)" \
  "[ '$conflict_count' -eq 3 ]"

echo ""
echo "New skills (on proposed but not installed):"

check "firecrawl in new skills list" \
  "echo '$NEW_SKILLS' | grep -q 'firecrawl'"

check "tavily-search in new skills list" \
  "echo '$NEW_SKILLS' | grep -q 'tavily-search'"

check "frontend-design in new skills list" \
  "echo '$NEW_SKILLS' | grep -q 'frontend-design'"

check "new-skill-alpha in new skills list" \
  "echo '$NEW_SKILLS' | grep -q 'new-skill-alpha'"

new_count=$(echo "$NEW_SKILLS" | grep -c '[a-z]' || true)
check "Exactly 4 new skills detected" \
  "[ '$new_count' -eq 4 ]"

echo ""
echo "Edge cases:"

# Empty proposed list = no conflicts
EMPTY_LIST="$TMPDIR_TEST/empty-proposed.txt"
touch "$EMPTY_LIST"
EMPTY_CONFLICTS=$(detect_conflicts "$SKILLS_DIR" "$EMPTY_LIST")
check "Empty proposed list produces no conflicts" \
  "[ -z '$EMPTY_CONFLICTS' ]"

# Proposed list with skills that don't exist at all on disk
ALL_NEW_LIST="$TMPDIR_TEST/all-new.txt"
cat > "$ALL_NEW_LIST" << 'EOF'
brand-new-skill-1
brand-new-skill-2
EOF
ALL_CONFLICTS=$(detect_conflicts "$SKILLS_DIR" "$ALL_NEW_LIST")
check "All-new skill list produces no conflicts" \
  "[ -z '$ALL_CONFLICTS' ]"

# Proposed list matches all installed exactly
EXACT_LIST="$TMPDIR_TEST/exact-match.txt"
printf 'brainstorming\nwriting-plans\ntest-driven-development\nsystematic-debugging\n' > "$EXACT_LIST"
EXACT_CONFLICTS=$(detect_conflicts "$SKILLS_DIR" "$EXACT_LIST")
exact_count=$(echo "$EXACT_CONFLICTS" | grep -c '[a-z]' || true)
check "All-existing list produces 4 conflicts" \
  "[ '$exact_count' -eq 4 ]"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
