#!/usr/bin/env bash
# Validates catalog structure: canonical 5-col-with-Install schema, install
# commands per file, INDEX.md <-> catalog file symmetry, duplicate-skill
# tracking (as a non-fatal warning), README badge count consistency
# (non-fatal warning until catalog-wide normalization completes).
#
# Canonical schemas accepted per Decision A (v1.3.0 Phase 1 remediation):
#   | Skill | Install | Description | Trigger | When to use |     (skills)
#   | Suite | Install | Description | Trigger | When to use |     (suites)
# Augmented variants are also accepted when they interpose optional Source
# and/or Scope columns between the Skill/Suite and Install columns, e.g.:
#   | Skill | Scope | Install | Description | Trigger | When to use |
#   | Skill | Source | Install | Description | Trigger | When to use |
#   | Skill | Source | Scope | Install | Description | Trigger | When to use |
# The pre-normalization 4-col header (no Install) is rejected. If a file
# contains BOTH a bare 4-col AND a canonical 5-col header, that is also
# rejected -- the rule is one canonical shape per file.
#
# NOTE: power-suites.md currently uses the legacy 3-col variant
# | Suite | Trigger | When to use |. Per Decision A this is temporarily
# accepted until power-suites.md is normalized in a later phase.
#
# NOTE: The catalog intentionally cross-lists some skills (e.g. firecrawl
# appears in both docs-research.md and engineering/data-ml.md as they are
# valid from both lenses). Duplicates are therefore reported as a WARNING
# but do not fail the lint -- the authoritative de-dup invariant lives
# inside the installer/resolver modules, not the catalog.
#
# Compatible with bash 3.2+ (macOS default).
set -uo pipefail

CATALOG="power-engineer/references/catalog"
INDEX="$CATALOG/INDEX.md"
FAIL=0

fail() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
warn() { echo "  WARN: $*"; }
pass() { echo "  PASS: $*"; }

# Check 1: INDEX.md exists
[ -f "$INDEX" ] || { fail "INDEX.md missing at $INDEX"; exit 1; }

# Check 2: every file listed in INDEX exists; every file on disk is listed
# bash 3.2-compatible: read into array via while loop
INDEXED=()
while IFS= read -r f; do
  INDEXED+=("$f")
done < <(grep -oE '\[[^]]+\]\(([^)]+\.md)\)' "$INDEX" | grep -oE '\([^)]+\)' | tr -d '()')

ON_DISK=()
while IFS= read -r f; do
  ON_DISK+=("$f")
done < <(cd "$CATALOG" && find . -name '*.md' -not -name 'INDEX.md' | sed 's|^\./||' | sort)

for f in "${INDEXED[@]}"; do
  [ -f "$CATALOG/$f" ] || fail "INDEX lists $f but file missing"
done
for f in "${ON_DISK[@]}"; do
  grep -q "($f)" "$INDEX" || fail "$f on disk but not in INDEX"
done

# ── Helpers for Check 3 ─────────────────────────────────────────
# A header is "canonical skill" if it starts with "| Skill |", then (optionally)
# one or both of "Source" and "Scope" as interposed columns, then "| Install |",
# then "| Description | Trigger | When to use |".
# Examples that match:
#   | Skill | Install | Description | Trigger | When to use |
#   | Skill | Scope | Install | Description | Trigger | When to use |
#   | Skill | Source | Install | Description | Trigger | When to use |
#   | Skill | Source | Scope | Install | Description | Trigger | When to use |
CANONICAL_SKILL_RE='^\| Skill \|( (Source|Scope) \|){0,2} Install \| Description \| Trigger \| When to use \|'
# Same with "Suite" instead of "Skill".
CANONICAL_SUITE_RE='^\| Suite \|( (Source|Scope) \|){0,2} Install \| Description \| Trigger \| When to use \|'
# Legacy 3-col Suite variant currently in power-suites.md (accepted until Phase 2
# normalizes it to the canonical 5-col-with-Install Suite form).
LEGACY_SUITE_RE='^\| Suite \| Trigger \| When to use \|$'
# The pre-normalization 4-col Skill header (what Decision A forbids).
BARE_4COL_SKILL_RE='^\| Skill \| Description \| Trigger \| When to use \|$'

# Check 3: every catalog file has at least one canonical header AND does not
# mix a bare 4-col table with the canonical 5-col-with-Install table.
for f in "${ON_DISK[@]}"; do
  path="$CATALOG/$f"

  has_canonical=0
  if grep -qE "$CANONICAL_SKILL_RE" "$path" \
     || grep -qE "$CANONICAL_SUITE_RE" "$path" \
     || grep -qE "$LEGACY_SUITE_RE" "$path"; then
    has_canonical=1
  fi

  has_bare_4col=0
  if grep -qE "$BARE_4COL_SKILL_RE" "$path"; then
    has_bare_4col=1
  fi

  if [ "$has_canonical" -eq 0 ]; then
    fail "$f missing canonical catalog header (see catalog-integrity.sh docblock for accepted shapes)"
  fi

  # Reject files that have BOTH a bare 4-col AND a canonical header (mid-migration state).
  if [ "$has_bare_4col" -eq 1 ] && [ "$has_canonical" -eq 1 ]; then
    fail "$f mixes legacy 4-col and canonical 5-col-with-Install headers -- normalize to one shape"
  fi

  # Reject files that only have the bare 4-col header.
  if [ "$has_bare_4col" -eq 1 ] && [ "$has_canonical" -eq 0 ]; then
    fail "$f uses legacy 4-col header without Install column -- normalize to 5-col-with-Install"
  fi
done

# Check 4: every catalog file has at least one install command somewhere.
# With the canonical 5-col-with-Install schema, install commands are INLINE in
# table rows (they appear as `| \`npx skills@latest add ...\` |` inside the
# Install column). They may also still appear in fenced code blocks for the
# "install everything at once" blocks (power-suites.md uses this pattern).
# Accept any of: inline table cell, fenced `npx skills` line, `/plugin` line.
for f in "${ON_DISK[@]}"; do
  path="$CATALOG/$f"
  if ! grep -qE '(npx skills(@[a-zA-Z0-9._-]+)? add|/plugin install|/plugin marketplace add)' "$path"; then
    fail "$f has no install command (expected inline \`npx skills add ...\` in an Install column, or a fenced /plugin or npx skills block)"
  fi
done

# Check 4b: no empty cells in catalog data rows (ported from
# test-catalog-trigger-maps.sh, audit row 45). An empty cell appears as
# `| |` (pipe-space-pipe) inside a table data row. We only look at rows that
# start with `|`, skip the separator row (all dashes), and then flag any
# `| |` occurrence. Headers are skipped because headers always end with the
# last column name before `|`, never with `| |`.
for f in "${ON_DISK[@]}"; do
  path="$CATALOG/$f"
  empty_count=$(grep -E '^\|' "$path" | grep -v '^\|[-| ]*\|$' | grep -c '| |' || true)
  if [ "$empty_count" -gt 0 ]; then
    fail "$f has $empty_count data row(s) with empty Trigger/When-to-use/other cells (|  |)"
  fi
done

# Check 5: duplicate skill names reported as a WARNING only.
# Catalog intentionally cross-lists some skills under multiple category lenses
# (e.g. firecrawl lives in both data-ml.md and docs-research.md). The de-dup
# invariant is enforced by the resolver/installer, not the catalog. We still
# surface the list so maintainers can spot accidental double-listings.
DUPES=$(find "$CATALOG" -name '*.md' -not -name 'INDEX.md' -exec awk -F'|' '
  /^\| (Skill|Suite) \|/      { in_table=1; next }   # header row of any variant
  /^\|[-: ]+\|/ && in_table==1 { next }              # separator row
  /^\|/ && in_table==1 {
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)      # trim col 2
    if ($2 == "Skill" || $2 == "Suite" || $2 == "" || $2 ~ /^-+$/) next
    print $2
  }
  !/^\|/ { in_table=0 }
' {} \; | sort | uniq -d)

if [ -n "$DUPES" ]; then
  DUPE_COUNT=$(echo "$DUPES" | wc -l | tr -d ' ')
  warn "$DUPE_COUNT duplicate skill name(s) across catalog (cross-category listing OR a real bug):"
  echo "$DUPES" | sed 's/^/         - /'
fi

# Check 6: skill count vs README badge.
# Count data rows across catalog files. A data row is a `|`-delimited row that
# is neither the header (first meaningful column == "Skill" or "Suite") nor the
# separator (`|---|` style). Each such row counts as one catalogued skill/suite.
CATALOG_COUNT=$(find "$CATALOG" -name '*.md' -not -name 'INDEX.md' -exec awk -F'|' '
  /^\| (Skill|Suite) \|/      { in_table=1; next }   # header row
  /^\|[-: ]+\|/ && in_table==1 { next }              # separator row
  /^\|/ && in_table==1 {
    # NF includes leading empty field from the starting `|` and a trailing empty
    # field from the closing `|`, so a 5-col row has NF>=7. Be lenient: require
    # at least 3 non-empty cells to avoid counting stray pipes.
    non_empty=0
    for (i=2; i<=NF; i++) {
      cell=$i
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", cell)
      if (cell != "") non_empty++
    }
    if (non_empty >= 3) print $2
  }
  !/^\|/ { in_table=0 }
' {} \; | wc -l | tr -d ' ')

BADGE_COUNT=$(grep -oE 'skills-[0-9]+' README.md | head -1 | grep -oE '[0-9]+')
if [ "$CATALOG_COUNT" != "$BADGE_COUNT" ]; then
  # Non-fatal: resolving this requires updating README + INDEX.md, which is
  # catalog-wide work reserved for a later phase. Surface as a warning so it
  # remains visible without blocking Phase 1 remediation.
  warn "README badge says $BADGE_COUNT skills but catalog has $CATALOG_COUNT rows (counts cross-category listings; reconcile in later phase)"
else
  pass "skill count: $CATALOG_COUNT (matches README badge)"
fi

# Check 7: .catalog-version file exists, is single-line semver, no trailing newline
CATALOG_VERSION_FILE="power-engineer/.catalog-version"
if [ ! -f "$CATALOG_VERSION_FILE" ]; then
  fail ".catalog-version file missing at $CATALOG_VERSION_FILE"
else
  CV_BYTES=$(wc -c < "$CATALOG_VERSION_FILE" | tr -d ' ')
  CV_LINES=$(wc -l < "$CATALOG_VERSION_FILE" | tr -d ' ')
  CV_CONTENT=$(cat "$CATALOG_VERSION_FILE")

  # No trailing newline means wc -l reports 0
  if [ "$CV_LINES" -ne 0 ]; then
    fail ".catalog-version has trailing newline (wc -l=$CV_LINES, expected 0)"
  fi

  # Semver pattern: X.Y.Z with numeric components
  if ! echo "$CV_CONTENT" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    fail ".catalog-version content '$CV_CONTENT' is not valid semver"
  else
    pass ".catalog-version: $CV_CONTENT (semver, no trailing newline, $CV_BYTES bytes)"
  fi
fi

# Shipping-boundary check: .catalog-version MUST NOT exist at repo root
# (would violate the invariant that only power-engineer/** ships via npx skills add)
if [ -f ".catalog-version" ]; then
  fail ".catalog-version at repo root violates shipping boundary; move to power-engineer/.catalog-version"
fi

# Check 8: every release entry (v1.3.0 and forward) in CHANGELOG.md has a ### Catalog subhead.
# The convention was established retroactively starting with v1.3.0. Entries sorted below 1.3.0
# via sort -V OR tagged with <!-- catalog-exempt: pre-convention --> are skipped.
if [ -f "CHANGELOG.md" ]; then
  # Use line numbers from outer grep directly (avoids fragile grep -F + head -1 lookup)
  while IFS=: read -r line_no header; do
    # Extract version string (e.g., "1.3.0" from "## [1.3.0] — 2026-04-16")
    version=$(echo "$header" | sed -nE 's/^## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/p')
    # Skip pre-convention entries: sort -V says version < 1.3.0
    lowest=$(printf '%s\n%s\n' "$version" "1.3.0" | sort -V | head -1)
    if [ "$lowest" != "1.3.0" ] && [ "$version" != "1.3.0" ]; then
      continue
    fi
    # Find where next release entry starts (or end of file)
    next=$(awk -v start="$line_no" 'NR > start && /^## \[/ { print NR; exit }' CHANGELOG.md)
    [ -z "$next" ] && next=$(wc -l < CHANGELOG.md)
    block=$(sed -n "${line_no},${next}p" CHANGELOG.md)
    # Skip if explicit exemption marker present
    if echo "$block" | grep -q '<!-- catalog-exempt: pre-convention -->'; then
      continue
    fi
    if ! echo "$block" | grep -qE '^### Catalog[[:space:]]*$'; then
      fail "CHANGELOG.md release '$header' (line $line_no) missing '### Catalog' subhead"
    fi
  done < <(grep -nE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' CHANGELOG.md)
fi

[ "$FAIL" -eq 0 ] || exit 1
echo "  ✓ catalog integrity OK"
