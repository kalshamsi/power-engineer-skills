#!/usr/bin/env bash
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

CATALOG_DIR="/Users/khalfan/Documents/Development/power-engineer-skills/power-engineer/references/catalog"

echo "=== Test: Catalog Trigger Maps ==="
echo ""

# --- Part 1: All 16 catalog files have Trigger and When to use columns ---

echo "-- Checking all 16 catalog files have Trigger and When to use columns --"
echo ""

check "core-methodology.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/core-methodology.md\""

check "core-methodology.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/core-methodology.md\""

check "anthropic-official.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/anthropic-official.md\""

check "anthropic-official.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/anthropic-official.md\""

check "engineering/backend-architecture.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/engineering/backend-architecture.md\""

check "engineering/backend-architecture.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/engineering/backend-architecture.md\""

check "engineering/devops-infra.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/engineering/devops-infra.md\""

check "engineering/devops-infra.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/engineering/devops-infra.md\""

check "engineering/data-ml.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/engineering/data-ml.md\""

check "engineering/data-ml.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/engineering/data-ml.md\""

check "engineering/testing-quality.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/engineering/testing-quality.md\""

check "engineering/testing-quality.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/engineering/testing-quality.md\""

check "engineering/agentic-ai.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/engineering/agentic-ai.md\""

check "engineering/agentic-ai.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/engineering/agentic-ai.md\""

check "engineering/security-ops.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/engineering/security-ops.md\""

check "engineering/security-ops.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/engineering/security-ops.md\""

check "frontend/react-next.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/frontend/react-next.md\""

check "frontend/react-next.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/frontend/react-next.md\""

check "frontend/vue-vite.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/frontend/vue-vite.md\""

check "frontend/vue-vite.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/frontend/vue-vite.md\""

check "frontend/design-systems.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/frontend/design-systems.md\""

check "frontend/design-systems.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/frontend/design-systems.md\""

check "frontend/mobile.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/frontend/mobile.md\""

check "frontend/mobile.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/frontend/mobile.md\""

check "cloud/azure.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/cloud/azure.md\""

check "cloud/azure.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/cloud/azure.md\""

check "cloud/databases.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/cloud/databases.md\""

check "cloud/databases.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/cloud/databases.md\""

check "docs-research.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/docs-research.md\""

check "docs-research.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/docs-research.md\""

check "power-suites.md has Trigger column" \
  "grep -q '| Trigger |' \"$CATALOG_DIR/power-suites.md\""

check "power-suites.md has When to use column" \
  "grep -q '| When to use |' \"$CATALOG_DIR/power-suites.md\""

echo ""

# --- Part 2: No skill table row has empty trigger or when-to-use cells ---
# We detect empty cells by looking for rows that contain "| |" (pipe space pipe),
# but only in files that have a Trigger column (i.e., all 16 files).
# We exclude header/separator rows (those containing dashes like |---|).

echo "-- Checking no skill table row has empty Trigger or When to use cells --"
echo ""

CATALOG_FILES=(
  "$CATALOG_DIR/core-methodology.md"
  "$CATALOG_DIR/anthropic-official.md"
  "$CATALOG_DIR/engineering/backend-architecture.md"
  "$CATALOG_DIR/engineering/devops-infra.md"
  "$CATALOG_DIR/engineering/data-ml.md"
  "$CATALOG_DIR/engineering/testing-quality.md"
  "$CATALOG_DIR/engineering/agentic-ai.md"
  "$CATALOG_DIR/engineering/security-ops.md"
  "$CATALOG_DIR/frontend/react-next.md"
  "$CATALOG_DIR/frontend/vue-vite.md"
  "$CATALOG_DIR/frontend/design-systems.md"
  "$CATALOG_DIR/frontend/mobile.md"
  "$CATALOG_DIR/cloud/azure.md"
  "$CATALOG_DIR/cloud/databases.md"
  "$CATALOG_DIR/docs-research.md"
  "$CATALOG_DIR/power-suites.md"
)

for f in "${CATALOG_FILES[@]}"; do
  fname=$(basename "$f")
  # Count data rows with empty cells: pipe-space-pipe patterns in non-separator lines
  empty_count=$(grep -E '^\|' "$f" | grep -v '^\|[-| ]*\|$' | grep -c '| |' || true)
  check "No empty trigger/when-to-use cells in $fname" \
    "[ \"$empty_count\" -eq 0 ]"
done

echo ""

# --- Summary ---
echo "================================"
echo "Results: $PASS passed, $FAIL failed"
echo "================================"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
