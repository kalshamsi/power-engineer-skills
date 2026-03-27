#!/usr/bin/env bash
# Integration test: Platform parity check
# Verifies no platform-conditional code exists in any module file
# All modules must work identically on macOS and Linux
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

# Resolve project root relative to this script's location
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
MODULES_DIR="$PROJECT_ROOT/power-engineer/references/modules"

echo "=== Test: Platform Parity (No Platform-Conditional Code) ==="
echo ""
echo "Project root: $PROJECT_ROOT"
echo "Modules dir:  $MODULES_DIR"
echo ""

# Platform-conditional patterns to detect.
# These are precise patterns that indicate OS-branching logic in code.
# Bare words like "linux", "darwin", "platform" are excluded to avoid false
# positives from skill names (e.g., "platform-design-skills") or prose.
PATTERNS=(
  "os\.platform\(\)"
  "process\.platform"
  "sys\.platform"
  "\buname\s*-[a-z]"
  "\$\(uname\)"
  "\`uname"
  "OSTYPE=="
  "\$OSTYPE\b"
  "MACHTYPE=="
  "\bwin32\b"
  "\bwin64\b"
  "\bcygwin\b"
  "\bmsys\b"
  "if.*==.*darwin"
  "if.*==.*linux"
  "if.*==.*windows"
  "RuntimeInformation\.IsOSPlatform"
)

echo "Scanning module files for platform-conditional code:"
echo ""

# Ensure modules directory exists
check "Modules directory exists" \
  "[ -d '$MODULES_DIR' ]"

module_files=$(find "$MODULES_DIR" -name "*.md" -type f 2>/dev/null)

if [ -z "$module_files" ]; then
  echo "  WARN: No module files found in $MODULES_DIR"
fi

# Check each module file for each pattern
while IFS= read -r module_file; do
  module_name=$(basename "$module_file")
  found_violations=false

  for pattern in "${PATTERNS[@]}"; do
    # Use grep -i for case-insensitive matching on relevant patterns
    if grep -qiE "$pattern" "$module_file" 2>/dev/null; then
      # Context check: distinguish actual platform-conditional usage
      # from documentation/comments about cross-platform support
      matches=$(grep -niE "$pattern" "$module_file" 2>/dev/null || true)
      # Filter out lines that are purely documentation context
      # (e.g., "works on Linux and macOS", "cross-platform")
      real_violations=$(echo "$matches" | grep -vE 'cross.platform|both.*macOS|both.*linux|macOS and Linux|Linux and macOS|supported on|platform support' || true)
      if [ -n "$real_violations" ]; then
        echo "  VIOLATION in $module_name (pattern: $pattern):"
        echo "$real_violations" | head -3 | sed 's/^/    /'
        found_violations=true
      fi
    fi
  done

  check "No platform-conditional code in $module_name" \
    "[ '$found_violations' = 'false' ]"

done <<< "$module_files"

echo ""
echo "Scanning test files for platform-conditional code:"
echo ""

TESTS_DIR="$PROJECT_ROOT/tests"
test_files=$(find "$TESTS_DIR" -name "*.sh" -type f 2>/dev/null | grep -v "$(basename "$0")" || true)

while IFS= read -r test_file; do
  [ -z "$test_file" ] && continue
  test_name=$(basename "$test_file")
  found_test_violations=false

  for pattern in uname darwin "OSTYPE" "win32" "win64" "cygwin" "msys"; do
    if grep -qiE "\b$pattern\b" "$test_file" 2>/dev/null; then
      matches=$(grep -niE "\b$pattern\b" "$test_file" 2>/dev/null || true)
      real_violations=$(echo "$matches" | grep -vE 'cross.platform|both.*macOS|supported' || true)
      if [ -n "$real_violations" ]; then
        found_test_violations=true
        break
      fi
    fi
  done

  check "No platform-conditional code in test $test_name" \
    "[ '$found_test_violations' = 'false' ]"

done <<< "$test_files"

echo ""
echo "Shell portability checks:"

# Verify integration tests use portable shebang
INT_DIR="$PROJECT_ROOT/tests/integration"
if [ -d "$INT_DIR" ]; then
  for script in "$INT_DIR"/*.sh; do
    [ -f "$script" ] || continue
    sname=$(basename "$script")
    shebang=$(head -1 "$script")
    check "Integration test $sname uses portable shebang (#!/usr/bin/env bash)" \
      "[ '$shebang' = '#!/usr/bin/env bash' ]"
  done
fi

# Verify run-tests.sh uses portable shebang
check "run-tests.sh uses portable shebang" \
  "head -1 '$PROJECT_ROOT/tests/run-tests.sh' | grep -q '#!/usr/bin/env bash'"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
