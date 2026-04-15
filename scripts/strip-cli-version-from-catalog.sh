#!/usr/bin/env bash
# Strips hardcoded CLI version pins from catalog install commands.
#
# Rewrites: `npx skills@<anything> add ...`  ->  `npx skills add ...`
#
# Covers BOTH occurrence forms used across the catalog:
#   1. Inline table-cell:
#      | skill | owner/repo | `local` | `npx skills@latest add owner/repo --skill foo -y` | ... |
#   2. Fenced code block:
#      ```bash
#      npx skills@latest add owner/repo --skill foo -y
#      ```
#
# Matches any @<version> pin, not just @latest (e.g. @1.2.3, @beta) so the
# script stays correct as the upstream CLI evolves.
#
# Version pinning moves to `.skills-cli-version`, which the installer module
# injects at install time. See docs/MIGRATION.md.
#
# Properties:
#   - Idempotent: re-running on a stripped catalog changes nothing.
#   - POSIX-friendly: uses `sed -i.bak` + `rm` pattern for macOS/Linux parity.
#   - Per-file reporting: shows how many occurrences each file contributed.
#   - Self-verifying: fails (exit 1) if any @<version> pin remains post-run.
#   - Skips INDEX.md (no install commands there by convention).
#
# Usage:
#   scripts/strip-cli-version-from-catalog.sh
#
# Safe to run from any working directory; resolves CATALOG from repo root.

set -euo pipefail

# Resolve repo root so the script works regardless of CWD.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CATALOG="$REPO_ROOT/power-engineer/references/catalog"

if [ ! -d "$CATALOG" ]; then
  echo "Error: catalog directory not found at $CATALOG" >&2
  exit 1
fi

# Count BEFORE state using the broader @ pattern (catches any future variants
# like @1.x or @beta alongside @latest).
BEFORE=$(grep -rcE 'npx skills@[a-zA-Z0-9._-]+ add' "$CATALOG" | awk -F: '{s+=$2} END {print s+0}')

CHANGED_FILES=0
TOTAL_STRIPPED=0

# Iterate .md files under the catalog, skipping INDEX.md (navigation file,
# no install commands expected there).
while IFS= read -r f; do
  # Count matches in this file. `|| true` prevents `set -e` from exiting when
  # grep returns non-zero on zero matches.
  hits=$(grep -cE 'npx skills@[a-zA-Z0-9._-]+ add' "$f" || true)
  if [ "$hits" -gt 0 ]; then
    # macOS sed requires a backup extension for -i; we create .bak then remove.
    sed -i.bak -E 's|npx skills@[a-zA-Z0-9._-]+ add|npx skills add|g' "$f"
    rm -- "$f.bak"
    CHANGED_FILES=$((CHANGED_FILES + 1))
    TOTAL_STRIPPED=$((TOTAL_STRIPPED + hits))
    echo "  rewrote: ${f#"$REPO_ROOT/"} ($hits occurrence(s))"
  fi
done < <(find "$CATALOG" -name '*.md' -not -name 'INDEX.md' | sort)

# Count AFTER state to confirm 100% coverage.
AFTER=$(grep -rcE 'npx skills@[a-zA-Z0-9._-]+ add' "$CATALOG" | awk -F: '{s+=$2} END {print s+0}')

echo ""
echo "BEFORE: $BEFORE occurrences | STRIPPED: $TOTAL_STRIPPED | AFTER: $AFTER | FILES: $CHANGED_FILES"

# Sanity check: if anything slipped through the regex, fail loudly so
# Task 2.2's verification catches it immediately.
if [ "$AFTER" -ne 0 ]; then
  echo ""
  echo "FAILURE: post-run verification failed: $AFTER @<version> pin(s) remain" >&2
  echo "Inspect remaining occurrences with:" >&2
  echo "  grep -rnE 'npx skills@[a-zA-Z0-9._-]+ add' $CATALOG" >&2
  exit 1
fi

echo "SUCCESS: all @<version> pins stripped from catalog install commands"
