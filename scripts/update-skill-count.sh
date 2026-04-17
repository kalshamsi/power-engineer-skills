#!/usr/bin/env bash
# Counts total skills in catalog and updates README badge
set -euo pipefail

CATALOG="power-engineer/references/catalog"
# Use command find to bypass any shell alias (e.g. fd on macOS).
# Awk logic mirrors catalog-integrity.sh Check 6: count data rows under
# any canonical header (| Skill | ... | or | Suite | ... |).
COUNT=$(command find "$CATALOG" -name '*.md' ! -name 'INDEX.md' -exec awk -F'|' '
  /^\| (Skill|Suite) \|/      { in_table=1; next }
  /^\|[-: ]+\|/ && in_table==1 { next }
  /^\|/ && in_table==1 {
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

echo "Catalog skill count: $COUNT"

# Update README badge
sed -i.bak -E "s|skills-[0-9]+|skills-${COUNT}|g" README.md
rm README.md.bak
sed -i.bak -E "s|alt=\"[0-9]+ Skills\"|alt=\"${COUNT} Skills\"|g" README.md
rm README.md.bak

# Update INDEX.md total line
sed -i.bak -E "s|Total skills catalogued: [0-9]+|Total skills catalogued: ${COUNT}|" "$CATALOG/INDEX.md"
rm "$CATALOG/INDEX.md.bak"

echo "Updated README.md and INDEX.md with count $COUNT"
