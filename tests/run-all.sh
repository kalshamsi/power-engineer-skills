#!/usr/bin/env bash
# Power Engineer — all lint checks
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FAIL=0
shopt -s nullglob
for script in tests/lint/*.sh; do
  name=$(basename "$script" .sh)
  echo "=== $name ==="
  if bash "$script"; then
    echo "  -> PASS"
  else
    echo "  -> FAIL"
    FAIL=$((FAIL + 1))
  fi
  echo ""
done

if [ "$FAIL" -gt 0 ]; then
  echo "✗ $FAIL lint script(s) failed"
  exit 1
fi
echo "✓ All lint checks passed"
