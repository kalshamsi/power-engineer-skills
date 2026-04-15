#!/usr/bin/env bash
# Extracts every GitHub target referenced by the catalog (literal
# https://github.com/... URLs AND owner/repo arguments passed to
# `npx skills add` / `/plugin marketplace add`) and HEAD-checks each.
# Caches results for the current session in $TMPDIR to skip re-validated URLs.
# Honors GITHUB_TOKEN env var (5000 req/hr vs 60).
#
# Per Phase 1 remediation (Decision B): the extractor is parameterizable via
# CATALOG_FILTER -- a newline-separated list of file paths relative to the
# repository root. If unset, the full catalog is scanned. Example:
#   CATALOG_FILTER="power-engineer/references/catalog/engineering/foo.md"
# This lets CI (Phase 6) scope URL validation to files actually changed in a PR
# by passing the output of `git diff --name-only origin/main...HEAD` directly.
set -uo pipefail

CATALOG_DEFAULT="power-engineer/references/catalog"
CACHE="${TMPDIR:-/tmp}/pe-url-cache-$(date +%Y%m%d).txt"
FAIL=0

fail() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

# ── Resolve which files to scan ─────────────────────────────────
# If CATALOG_FILTER is set (newline-separated list of paths), only validate those.
FILES=()
if [ -n "${CATALOG_FILTER:-}" ]; then
  # Newline-delimited path list (as produced by git diff --name-only).
  while IFS= read -r f; do
    [ -n "$f" ] && [ -f "$f" ] && FILES+=("$f")
  done <<< "$CATALOG_FILTER"
else
  while IFS= read -r f; do
    FILES+=("$f")
  done < <(find "$CATALOG_DEFAULT" -type f -name '*.md')
fi

if [ "${#FILES[@]}" -eq 0 ]; then
  echo "  (no catalog files matched CATALOG_FILTER='${CATALOG_FILTER:-}'; nothing to validate)"
  exit 0
fi

# ── Build the target URL list ───────────────────────────────────
# 1. Literal https://github.com/<owner>/<repo> URLs (trim any trailing .git).
# 2. owner/repo args following `npx skills add` or `npx skills@<version> add`.
# 3. owner/repo args following `/plugin marketplace add`.
# We normalise everything to the canonical form `https://github.com/<owner>/<repo>`
# for HEAD-checking and de-dup.
#
# Regex notes:
#   * owner/repo characters are [a-zA-Z0-9_.-]. This matches GitHub's rules.
#   * The `-y` flag and `--skill <name>` appear AFTER the owner/repo arg, so we
#     stop matching at the first whitespace.
URLS=()
while IFS= read -r u; do
  [ -z "$u" ] && continue
  URLS+=("$u")
done < <(
  {
    # 1. Literal https URLs
    grep -rhoE 'https://github\.com/[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+' "${FILES[@]}" \
      | sed -E 's|\.git$||'

    # 2. npx skills add owner/repo   (with optional @version pin)
    grep -rhoE 'npx skills(@[a-zA-Z0-9._-]+)? add [a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+' "${FILES[@]}" \
      | sed -E 's|.* add ([a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+).*|https://github.com/\1|'

    # 3. /plugin marketplace add owner/repo
    grep -rhoE '/plugin marketplace add [a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+' "${FILES[@]}" \
      | sed -E 's|.*add ([a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+).*|https://github.com/\1|'
  } | sort -u
)

if [ "${#URLS[@]}" -eq 0 ]; then
  echo "  ✓ all 0 GitHub targets reachable (no URLs found in scanned files)"
  exit 0
fi

touch "$CACHE"

AUTH=()
[ -n "${GITHUB_TOKEN:-}" ] && AUTH=(-H "Authorization: token $GITHUB_TOKEN")

RATE_LIMITED=0
for url in "${URLS[@]+"${URLS[@]}"}"; do
  # Session cache
  if grep -q "^$url " "$CACHE"; then
    continue
  fi

  # HEAD request, 10s timeout
  status=$(curl -sI -o /dev/null -w '%{http_code}' --max-time 10 "${AUTH[@]+"${AUTH[@]}"}" "$url" || echo "000")
  echo "$url $status" >> "$CACHE"

  case "$status" in
    200|301|302) ;;
    429|403)
      # GitHub may return 403 when rate-limited without a token.
      fail "$url → HTTP $status (likely rate-limited; set GITHUB_TOKEN or run via CI)"
      RATE_LIMITED=1
      break
      ;;
    *) fail "$url → HTTP $status" ;;
  esac
done

if [ "$RATE_LIMITED" -eq 1 ]; then
  echo "  (stopped early due to rate-limit; rerun with GITHUB_TOKEN set)"
fi

[ "$FAIL" -eq 0 ] || exit 1
echo "  ✓ all ${#URLS[@]} GitHub targets reachable"
