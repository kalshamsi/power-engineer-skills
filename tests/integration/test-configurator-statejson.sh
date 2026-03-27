#!/usr/bin/env bash
# Integration test: state.json schema validation
# Validates installed_skills array, source field values, no duplicates
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

echo "=== Test: state.json Schema ==="
echo ""

# --- Setup: valid state.json with sources ---
cat > "$TMPDIR_TEST/state-with-sources.json" << 'EOF'
{
  "version": "2.0",
  "created": "2026-03-25T10:00:00Z",
  "updated": "2026-03-25T10:05:00Z",
  "project": {
    "name": "my-project",
    "language": "TypeScript",
    "framework": "Next.js",
    "sdks": ["stripe", "supabase"],
    "cloud_database": ["postgres"],
    "team_size": 4,
    "is_monorepo": true
  },
  "installed_skills": [
    {
      "name": "brainstorming",
      "source": "power-engineer",
      "repo": "obra/superpowers",
      "installed_at": "2026-03-25T10:00:00Z",
      "installed_by": "power-engineer"
    },
    {
      "name": "test-driven-development",
      "source": "manual",
      "repo": "obra/superpowers",
      "installed_at": "2026-03-25T10:01:00Z",
      "installed_by": "power-engineer"
    },
    {
      "name": "custom-skill",
      "source": "manual",
      "repo": "myorg/myskills",
      "installed_at": "2026-03-25T10:02:00Z",
      "installed_by": "user"
    }
  ]
}
EOF

# --- Setup: minimal valid state.json ---
cat > "$TMPDIR_TEST/state-minimal.json" << 'EOF'
{
  "version": "2.0",
  "created": "2026-03-25T10:00:00Z",
  "updated": "2026-03-25T10:05:00Z",
  "project": {
    "name": "solo-project",
    "language": "JavaScript",
    "framework": "Express",
    "sdks": [],
    "cloud_database": [],
    "team_size": 1,
    "is_monorepo": false
  },
  "installed_skills": [
    {
      "name": "brainstorming",
      "source": "power-engineer",
      "repo": "obra/superpowers",
      "installed_at": "2026-03-25T10:00:00Z",
      "installed_by": "power-engineer"
    }
  ]
}
EOF

# --- Setup: state.json with duplicate skill names ---
cat > "$TMPDIR_TEST/state-dupes.json" << 'EOF'
{
  "version": "2.0",
  "installed_skills": [
    {
      "name": "brainstorming",
      "source": "power-engineer",
      "repo": "obra/superpowers",
      "installed_at": "2026-03-25T10:00:00Z",
      "installed_by": "power-engineer"
    },
    {
      "name": "brainstorming",
      "source": "manual",
      "repo": "other/repo",
      "installed_at": "2026-03-25T10:01:00Z",
      "installed_by": "user"
    }
  ]
}
EOF

# --- Setup: state.json with invalid source value ---
cat > "$TMPDIR_TEST/state-badsource.json" << 'EOF'
{
  "version": "2.0",
  "installed_skills": [
    {
      "name": "my-skill",
      "source": "unknown-installer",
      "repo": "org/repo",
      "installed_at": "2026-03-25T10:00:00Z",
      "installed_by": "power-engineer"
    }
  ]
}
EOF

echo "installed_skills array:"

check "installed_skills key exists (multi-source state)" \
  "grep -q '\"installed_skills\"' '$TMPDIR_TEST/state-with-sources.json'"

check "installed_skills key exists (minimal state)" \
  "grep -q '\"installed_skills\"' '$TMPDIR_TEST/state-minimal.json'"

check "installed_skills is an array (opens with [)" \
  "grep -A1 '\"installed_skills\"' '$TMPDIR_TEST/state-with-sources.json' | grep -q '\['"

echo ""
echo "Required skill entry fields:"

check "name field present in skill entries" \
  "grep -q '\"name\"' '$TMPDIR_TEST/state-with-sources.json'"

check "source field present in skill entries" \
  "grep -q '\"source\"' '$TMPDIR_TEST/state-with-sources.json'"

check "repo field present in skill entries" \
  "grep -q '\"repo\"' '$TMPDIR_TEST/state-with-sources.json'"

check "installed_at field present in skill entries" \
  "grep -q '\"installed_at\"' '$TMPDIR_TEST/state-with-sources.json'"

check "installed_by field present in skill entries" \
  "grep -q '\"installed_by\"' '$TMPDIR_TEST/state-with-sources.json'"

echo ""
echo "source field valid values:"

# Valid source values: power-engineer, manual
check "source 'power-engineer' is valid" \
  "grep -q '\"source\": \"power-engineer\"' '$TMPDIR_TEST/state-with-sources.json'"

check "source 'manual' is valid" \
  "grep -q '\"source\": \"manual\"' '$TMPDIR_TEST/state-with-sources.json'"

check "source 'unknown-installer' is not a valid known value" \
  "! grep -qE '\"source\": \"(power-engineer|manual)\"' '$TMPDIR_TEST/state-badsource.json'"

echo ""
echo "Duplicate skill detection:"

# Count occurrences of "brainstorming" name entries in dupes file
dupe_count=$(grep -c '"name": "brainstorming"' "$TMPDIR_TEST/state-dupes.json" || true)
check "Duplicate skill names detected ($dupe_count occurrences of brainstorming)" \
  "[ '$dupe_count' -gt 1 ]"

unique_count=$(grep '"name":' "$TMPDIR_TEST/state-with-sources.json" | sort -u | wc -l | tr -d ' ')
total_count=$(grep -c '"name":' "$TMPDIR_TEST/state-with-sources.json" || true)
check "No duplicate names in valid state (unique=$unique_count total=$total_count)" \
  "[ '$unique_count' -eq '$total_count' ]"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
