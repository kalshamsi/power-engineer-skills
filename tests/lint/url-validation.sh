#!/usr/bin/env bash
# Extracts every GitHub URL from catalog files and HEAD-checks each.
# Caches results for the current session in $TMPDIR to skip re-validated URLs.
# Honors GITHUB_TOKEN env var (5000 req/hr vs 60).
set -uo pipefail

CATALOG="power-engineer/references/catalog"
CACHE="${TMPDIR:-/tmp}/pe-url-cache-$(date +%Y%m%d).txt"
FAIL=0

fail() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

# Extract unique GitHub URLs
URLS=()
while IFS= read -r u; do
  URLS+=("$u")
done < <(
  grep -rhoE 'https://github\.com/[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+' "$CATALOG" \
    | sort -u
)

touch "$CACHE"

AUTH=()
[ -n "${GITHUB_TOKEN:-}" ] && AUTH=(-H "Authorization: token $GITHUB_TOKEN")

for url in "${URLS[@]}"; do
  # Session cache
  if grep -q "^$url " "$CACHE"; then
    continue
  fi

  # HEAD request, 10s timeout
  status=$(curl -sI -o /dev/null -w '%{http_code}' --max-time 10 "${AUTH[@]+"${AUTH[@]}"}" "$url" || echo "000")
  echo "$url $status" >> "$CACHE"

  case "$status" in
    200|301|302) ;;
    *) fail "$url → HTTP $status" ;;
  esac
done

[ "$FAIL" -eq 0 ] || exit 1
echo "  ✓ all ${#URLS[@]} URLs reachable"
