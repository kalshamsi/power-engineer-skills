#!/usr/bin/env bash
# catalog-diff.sh — Compare power-engineer catalog snapshots between git refs.
#
# Modes (mutually exclusive):
#   --ref-diff <a> <b>       Diff catalog at ref <a> vs ref <b>.
#   --version-diff <v1> <v2> Diff at tag v<v1> vs v<v2> (resolved to commits).
#   --ci-check               Replicate the catalog-version-sync CI job:
#                             fail if catalog files changed without a
#                             .catalog-version bump (origin/main...HEAD).
#
# Formats (default = changelog):
#   --format=changelog       Paste-ready CHANGELOG '### Catalog' block.
#   --format=diff            Human-readable bulleted diff.
#   --format=json            Machine-readable JSON with 5 keys.
#
# Exit codes (per spec §error-handling):
#   0  success / no changes / clean diff
#   1  --ci-check fail OR --format=json parse error
#   2  invalid usage / invalid mode combo / invalid ref / invalid version
#
# Maintainer-only utility — lives at repo-root scripts/, OUTSIDE the
# power-engineer/ shipping boundary.

set -euo pipefail

# ────────────────────────────────────────────────────────────────────
# Globals
# ────────────────────────────────────────────────────────────────────

readonly CATALOG_DIR='power-engineer/references/catalog'
readonly VERSION_FILE='power-engineer/.catalog-version'
readonly CATALOG_GLOB='power-engineer/references/catalog/**/*.md'

# ────────────────────────────────────────────────────────────────────
# usage()
# ────────────────────────────────────────────────────────────────────

usage() {
    cat <<'EOF'
Usage: catalog-diff.sh <mode> [--format=<format>]

Modes (exactly one required):
  --ref-diff <ref-a> <ref-b>        Diff catalog at ref-a vs ref-b.
  --version-diff <v1> <v2>          Diff catalog at tag v<v1> vs v<v2>.
  --ci-check                        Replicate catalog-version-sync CI job.
  --help, -h                        Show this help.

Formats (optional; default = changelog):
  --format=changelog                Paste-ready CHANGELOG '### Catalog' block.
  --format=diff                     Human-readable bulleted diff.
  --format=json                     Machine-readable JSON.

Examples:
  ./scripts/catalog-diff.sh --ref-diff v1.3.0 v1.4.0
  ./scripts/catalog-diff.sh --version-diff 1.3.0 1.4.0 --format=diff
  ./scripts/catalog-diff.sh --ref-diff v1.4.0 v1.4.1 --format=json
  ./scripts/catalog-diff.sh --ci-check

Exit codes:
  0 success / no changes / clean diff
  1 --ci-check fail OR --format=json parse error
  2 invalid usage / invalid mode combo / invalid ref / invalid version
EOF
}

# ────────────────────────────────────────────────────────────────────
# err — emit error message to stderr (no terminal escapes echoed)
# ────────────────────────────────────────────────────────────────────

err() {
    printf 'Error: %s\n' "$*" >&2
}

# ────────────────────────────────────────────────────────────────────
# json_emit_error — emit {"error": "<reason>"} for --format=json
# ────────────────────────────────────────────────────────────────────

json_emit_error() {
    local reason="$1"
    # Escape backslashes and double-quotes for JSON safety.
    reason="${reason//\\/\\\\}"
    reason="${reason//\"/\\\"}"
    printf '{"error": "%s"}\n' "$reason"
}

# ────────────────────────────────────────────────────────────────────
# validate_ref — Hostile-input-safe ref validation (R3)
#
# Uses --end-of-options for flag-injection defense and --quiet to
# suppress git's stderr so we can emit a controlled error message.
# Stays silent on success; emits an Error: line on failure and returns 1.
# ────────────────────────────────────────────────────────────────────

validate_ref() {
    local ref="$1"
    if ! git rev-parse --verify --quiet --end-of-options "${ref}^{commit}" >/dev/null 2>&1; then
        err "ref '${ref}' not found"
        return 1
    fi
    return 0
}

# ────────────────────────────────────────────────────────────────────
# parse_catalog_at_ref — Extract (skill_name, install_command) pairs from
# every catalog markdown file at the given ref.
#
# Reuses the awk pattern from scripts/update-skill-count.sh lines 9-22
# verbatim for in_table state machine, then extends to also emit the
# install command (cell after the skill name).
#
# Output: tab-separated lines  "<skill_name>\t<install_cmd>"  to stdout.
# Sourcefile path emitted to a parallel structural channel via stderr
# so caller can detect "structural" file additions/removals.
#
# Args:
#   $1 ref      — git ref (already validated by caller)
#   $2 outfile  — path to write the extracted "name<TAB>install" lines
#   $3 listfile — path to write the catalog file list at this ref
# ────────────────────────────────────────────────────────────────────

parse_catalog_at_ref() {
    local ref="$1"
    local outfile="$2"
    local listfile="$3"

    : >"$outfile"
    : >"$listfile"

    # List every *.md under the catalog dir at this ref (excluding INDEX.md
    # so we mirror update-skill-count.sh's `! -name 'INDEX.md'` filter).
    # `git ls-tree -r --name-only` is the canonical way to list a tree at
    # a ref without checking out.
    local file
    while IFS= read -r file; do
        # Skip blanks (defensive — `ls-tree -r` shouldn't emit them).
        [ -z "$file" ] && continue
        # Skip INDEX.md (mirrors update-skill-count.sh).
        case "$file" in
            */INDEX.md) continue ;;
        esac
        printf '%s\n' "$file" >>"$listfile"

        # Extract (name, install_cmd) using the awk pattern from
        # update-skill-count.sh lines 9-22, extended to print column 3
        # (install command) alongside column 2 (skill name).
        # Forgiving behavior: malformed rows are skipped by the
        # `non_empty >= 3` guard rather than crashing.
        git show "${ref}:${file}" 2>/dev/null | awk -F'|' -v src="$file" '
            /^\| (Skill|Suite) \|/      { in_table=1; next }
            /^\|[-: ]+\|/ && in_table==1 { next }
            /^\|/ && in_table==1 {
                non_empty=0
                for (i=2; i<=NF; i++) {
                    cell=$i
                    gsub(/^[[:space:]]+|[[:space:]]+$/, "", cell)
                    if (cell != "") non_empty++
                }
                if (non_empty >= 3) {
                    name=$2
                    install=$3
                    gsub(/^[[:space:]]+|[[:space:]]+$/, "", name)
                    gsub(/^[[:space:]]+|[[:space:]]+$/, "", install)
                    if (name != "") printf "%s\t%s\n", name, install
                } else {
                    printf "warning: malformed row in %s: %s\n", src, $0 | "cat 1>&2"
                }
            }
            !/^\|/ { in_table=0 }
        ' >>"$outfile"
    done < <(git ls-tree -r --name-only "${ref}" -- "${CATALOG_DIR}" 2>/dev/null | grep -E '\.md$' || true)
}

# ────────────────────────────────────────────────────────────────────
# read_catalog_version_at_ref — Read .catalog-version at ref.
# Echoes the version string (e.g. "1.4.0") on stdout, or an empty
# string if the file doesn't exist at that ref.
# ────────────────────────────────────────────────────────────────────

read_catalog_version_at_ref() {
    local ref="$1"
    git show "${ref}:${VERSION_FILE}" 2>/dev/null | tr -d '[:space:]' || true
}

# ────────────────────────────────────────────────────────────────────
# compute_diff — Given two parse outputs (a_file, b_file), populate
# global arrays:
#   ADDED      = names in b but not in a (and not a rename target)
#   REMOVED    = names in a but not in b (and not a rename source)
#   RENAMED    = "old\tnew" pairs where install command matches but name
#                differs (heuristic for renames)
#   STRUCTURAL = file-level changes (catalog .md files added/removed)
#   ROW_COUNT_DELTA = (rows in b) - (rows in a)
#
# Args:
#   $1 a_outfile   — parse output for ref a (name<TAB>install lines)
#   $2 b_outfile   — parse output for ref b
#   $3 a_listfile  — list of catalog files at ref a
#   $4 b_listfile  — list of catalog files at ref b
# ────────────────────────────────────────────────────────────────────

ADDED=()
REMOVED=()
RENAMED=()
STRUCTURAL=()
ROW_COUNT_DELTA=0

compute_diff() {
    local a_outfile="$1"
    local b_outfile="$2"
    local a_listfile="$3"
    local b_listfile="$4"

    ADDED=()
    REMOVED=()
    RENAMED=()
    STRUCTURAL=()
    ROW_COUNT_DELTA=0

    # Row count delta (uses raw line counts — total skill rows across catalog).
    local a_count b_count
    a_count="$(wc -l <"$a_outfile" | tr -d ' ')"
    b_count="$(wc -l <"$b_outfile" | tr -d ' ')"
    ROW_COUNT_DELTA=$((b_count - a_count))

    # Names only (for added/removed).
    local a_names_file b_names_file
    a_names_file="$(mktemp)"
    b_names_file="$(mktemp)"
    cut -f1 <"$a_outfile" | sort -u >"$a_names_file"
    cut -f1 <"$b_outfile" | sort -u >"$b_names_file"

    # Names added in b but not in a.
    local added_names
    added_names="$(comm -13 "$a_names_file" "$b_names_file")"

    # Names removed in a but not in b.
    local removed_names
    removed_names="$(comm -23 "$a_names_file" "$b_names_file")"

    # Rename detection: for each removed name, look for an added name
    # whose install command matches the removed entry's install command.
    # Heuristic: same install_cmd implies same skill, just renamed.
    local aname ainstall bname binstall
    local matched_added=()
    local rsrc rline_install
    while IFS= read -r rsrc; do
        [ -z "$rsrc" ] && continue
        # Look up install command for removed name in a_outfile (first hit).
        rline_install=""
        while IFS=$'\t' read -r aname ainstall; do
            if [ "$aname" = "$rsrc" ]; then
                rline_install="$ainstall"
                break
            fi
        done <"$a_outfile"

        # Match against any added name with same install command.
        if [ -n "$rline_install" ]; then
            while IFS=$'\t' read -r bname binstall; do
                if [ "$binstall" = "$rline_install" ]; then
                    # Confirm bname is in added_names (not in a's names).
                    if printf '%s\n' "$added_names" | grep -Fxq -- "$bname"; then
                        RENAMED+=("${rsrc}"$'\t'"${bname}")
                        matched_added+=("$bname")
                        rsrc=""  # mark as paired
                        break
                    fi
                fi
            done <"$b_outfile"
        fi

        # If still unpaired, it's a true removal.
        if [ -n "$rsrc" ]; then
            REMOVED+=("$rsrc")
        fi
    done < <(printf '%s\n' "$removed_names")

    # Added names that weren't paired as renames are true additions.
    while IFS= read -r aline; do
        [ -z "$aline" ] && continue
        local is_rename=0
        local m
        for m in "${matched_added[@]+"${matched_added[@]}"}"; do
            if [ "$m" = "$aline" ]; then
                is_rename=1
                break
            fi
        done
        if [ "$is_rename" -eq 0 ]; then
            ADDED+=("$aline")
        fi
    done < <(printf '%s\n' "$added_names")

    # Structural changes: catalog files added or removed between refs.
    local a_files_sorted b_files_sorted
    a_files_sorted="$(mktemp)"
    b_files_sorted="$(mktemp)"
    sort -u <"$a_listfile" >"$a_files_sorted"
    sort -u <"$b_listfile" >"$b_files_sorted"

    local sline
    while IFS= read -r sline; do
        [ -z "$sline" ] && continue
        STRUCTURAL+=("added: $sline")
    done < <(comm -13 "$a_files_sorted" "$b_files_sorted")

    while IFS= read -r sline; do
        [ -z "$sline" ] && continue
        STRUCTURAL+=("removed: $sline")
    done < <(comm -23 "$a_files_sorted" "$b_files_sorted")

    rm -f "$a_names_file" "$b_names_file" "$a_files_sorted" "$b_files_sorted"
}

# ────────────────────────────────────────────────────────────────────
# json_array — Emit a JSON array of strings from positional args.
# Uses python3 if available for robust escaping; falls back to manual.
# ────────────────────────────────────────────────────────────────────

json_array_from_lines() {
    # Read NUL-or-newline-separated values from stdin, emit JSON array.
    awk '
        BEGIN { printf "[" }
        NR > 1 { printf "," }
        {
            # Escape backslash, double-quote, control chars.
            s = $0
            gsub(/\\/, "\\\\", s)
            gsub(/"/,  "\\\"", s)
            gsub(/\t/, "\\t",  s)
            gsub(/\r/, "\\r",  s)
            gsub(/\n/, "\\n",  s)
            printf "\"%s\"", s
        }
        END { printf "]" }
    '
}

# ────────────────────────────────────────────────────────────────────
# render_json — Emit machine-readable JSON with all 5 keys.
# Per spec: keys = added, removed, renamed, structural, row_count_delta.
# ────────────────────────────────────────────────────────────────────

render_json() {
    local added_json removed_json renamed_json structural_json
    added_json="$(printf '%s\n' "${ADDED[@]+"${ADDED[@]}"}" | sed '/^$/d' | json_array_from_lines)"
    removed_json="$(printf '%s\n' "${REMOVED[@]+"${REMOVED[@]}"}" | sed '/^$/d' | json_array_from_lines)"

    # Renamed: each entry is "old\tnew" — emit as objects.
    {
        printf '['
        local first=1 entry old new
        for entry in "${RENAMED[@]+"${RENAMED[@]}"}"; do
            old="${entry%%	*}"
            new="${entry#*	}"
            # Escape both fields for JSON.
            old="${old//\\/\\\\}"; old="${old//\"/\\\"}"
            new="${new//\\/\\\\}"; new="${new//\"/\\\"}"
            if [ "$first" -eq 1 ]; then
                first=0
            else
                printf ','
            fi
            printf '{"from": "%s", "to": "%s"}' "$old" "$new"
        done
        printf ']'
    } >/tmp/.catalog-diff-renamed.$$

    renamed_json="$(cat /tmp/.catalog-diff-renamed.$$)"
    rm -f /tmp/.catalog-diff-renamed.$$

    structural_json="$(printf '%s\n' "${STRUCTURAL[@]+"${STRUCTURAL[@]}"}" | sed '/^$/d' | json_array_from_lines)"

    printf '{"added": %s, "removed": %s, "renamed": %s, "structural": %s, "row_count_delta": %d}\n' \
        "$added_json" "$removed_json" "$renamed_json" "$structural_json" "$ROW_COUNT_DELTA"
}

# ────────────────────────────────────────────────────────────────────
# render_changelog — Paste-ready CHANGELOG block.
# ────────────────────────────────────────────────────────────────────

render_changelog() {
    local a_version="$1"
    local b_version="$2"

    printf '### Catalog\n\n'

    # Skills added.
    # Note: printf calls in this function use a leading space character
    # ' - ...' instead of '- ...' to avoid bash printf parsing the leading
    # dash as a flag (POSIX printf treats arg-starting `-` as flag intro).
    # The space is then trimmed via sed at end. Simpler workaround: use
    # `printf '%s\n' "- foo"` so the dash is in an argument, not the format.
    if [ "${#ADDED[@]}" -eq 0 ]; then
        printf '%s\n' '- Skills added: none'
    else
        printf '%s\n' "- Skills added (${#ADDED[@]}): $(IFS=', '; printf '%s' "${ADDED[*]}")"
    fi

    # Skills removed.
    if [ "${#REMOVED[@]}" -eq 0 ]; then
        printf '%s\n' '- Skills removed: none'
    else
        printf '%s\n' "- Skills removed (${#REMOVED[@]}): $(IFS=', '; printf '%s' "${REMOVED[*]}")"
    fi

    # Renames.
    if [ "${#RENAMED[@]}" -eq 0 ]; then
        printf '%s\n' '- Skills renamed: none'
    else
        printf '%s\n' "- Skills renamed (${#RENAMED[@]}):"
        local entry old new
        for entry in "${RENAMED[@]}"; do
            old="${entry%%	*}"
            new="${entry#*	}"
            printf '  - %s -> %s\n' "$old" "$new"
        done
    fi

    # Structural changes.
    if [ "${#STRUCTURAL[@]}" -eq 0 ]; then
        printf '%s\n' '- Structural changes: none'
    else
        printf '%s\n' "- Structural changes (${#STRUCTURAL[@]}):"
        local s
        for s in "${STRUCTURAL[@]}"; do
            printf '  - %s\n' "$s"
        done
    fi

    # Catalog version delta.
    if [ -z "$a_version" ] && [ -z "$b_version" ]; then
        printf '%s\n' '- Catalog version: (not present at either ref)'
    elif [ "$a_version" = "$b_version" ]; then
        printf '%s\n' "- Catalog version: ${a_version} (unchanged)"
    else
        printf '%s\n' "- Catalog version: ${a_version:-<none>} -> ${b_version:-<none>}"
    fi
}

# ────────────────────────────────────────────────────────────────────
# render_diff — Human-readable bulleted diff (verbose).
# ────────────────────────────────────────────────────────────────────

render_diff() {
    local a_label="$1"
    local b_label="$2"
    local a_version="$3"
    local b_version="$4"

    printf 'Catalog diff: %s -> %s\n\n' "$a_label" "$b_label"

    printf 'Added skills (%d):\n' "${#ADDED[@]}"
    if [ "${#ADDED[@]}" -eq 0 ]; then
        printf '  (none)\n'
    else
        local n
        for n in "${ADDED[@]}"; do
            printf '  + %s\n' "$n"
        done
    fi
    printf '\n'

    printf 'Removed skills (%d):\n' "${#REMOVED[@]}"
    if [ "${#REMOVED[@]}" -eq 0 ]; then
        printf '  (none)\n'
    else
        local n
        for n in "${REMOVED[@]}"; do
            printf '  - %s\n' "$n"
        done
    fi
    printf '\n'

    printf 'Renamed skills (%d):\n' "${#RENAMED[@]}"
    if [ "${#RENAMED[@]}" -eq 0 ]; then
        printf '  (none)\n'
    else
        local entry old new
        for entry in "${RENAMED[@]}"; do
            old="${entry%%	*}"
            new="${entry#*	}"
            printf '  ~ %s -> %s\n' "$old" "$new"
        done
    fi
    printf '\n'

    printf 'Structural changes (%d):\n' "${#STRUCTURAL[@]}"
    if [ "${#STRUCTURAL[@]}" -eq 0 ]; then
        printf '  (none)\n'
    else
        local s
        for s in "${STRUCTURAL[@]}"; do
            printf '  * %s\n' "$s"
        done
    fi
    printf '\n'

    printf 'Row count delta: %d\n' "$ROW_COUNT_DELTA"
    printf 'Catalog version: %s -> %s\n' "${a_version:-<none>}" "${b_version:-<none>}"
}

# ────────────────────────────────────────────────────────────────────
# do_ref_diff — --ref-diff <a> <b> implementation.
# Refs MUST already be validated by the caller.
# ────────────────────────────────────────────────────────────────────

do_ref_diff() {
    local ref_a="$1"
    local ref_b="$2"
    local fmt="$3"

    local a_outfile a_listfile b_outfile b_listfile
    a_outfile="$(mktemp)"; a_listfile="$(mktemp)"
    b_outfile="$(mktemp)"; b_listfile="$(mktemp)"

    # Trap cleanup of these tempfiles on exit.
    # shellcheck disable=SC2064  # intentional: expand paths now, not at trap time
    trap "rm -f '$a_outfile' '$a_listfile' '$b_outfile' '$b_listfile'" EXIT

    parse_catalog_at_ref "$ref_a" "$a_outfile" "$a_listfile"
    parse_catalog_at_ref "$ref_b" "$b_outfile" "$b_listfile"

    compute_diff "$a_outfile" "$b_outfile" "$a_listfile" "$b_listfile"

    local a_version b_version
    a_version="$(read_catalog_version_at_ref "$ref_a")"
    b_version="$(read_catalog_version_at_ref "$ref_b")"

    case "$fmt" in
        changelog) render_changelog "$a_version" "$b_version" ;;
        diff)      render_diff "$ref_a" "$ref_b" "$a_version" "$b_version" ;;
        json)      render_json ;;
    esac
}

# ────────────────────────────────────────────────────────────────────
# do_version_diff — --version-diff <v1> <v2> implementation.
# Resolves v<N> to a tag and validates each before delegating to
# do_ref_diff. Errors with the available tag list if a version is not
# tagged.
# ────────────────────────────────────────────────────────────────────

do_version_diff() {
    local v1="$1"
    local v2="$2"
    local fmt="$3"

    local tag1="v${v1}"
    local tag2="v${v2}"

    if ! git rev-parse --verify --quiet --end-of-options "${tag1}^{commit}" >/dev/null 2>&1; then
        err "version '${v1}' not found in \`git tag\`"
        printf 'Available tags:\n' >&2
        git tag --sort=-creatordate | sed 's/^/  /' >&2
        return 2
    fi

    if ! git rev-parse --verify --quiet --end-of-options "${tag2}^{commit}" >/dev/null 2>&1; then
        err "version '${v2}' not found in \`git tag\`"
        printf 'Available tags:\n' >&2
        git tag --sort=-creatordate | sed 's/^/  /' >&2
        return 2
    fi

    do_ref_diff "$tag1" "$tag2" "$fmt"
}

# ────────────────────────────────────────────────────────────────────
# do_ci_check — Replicate .github/workflows/ci.yml catalog-version-sync
# job logic verbatim. Uses git diff --name-only origin/main...HEAD
# (R2: NOT git show — must handle additions of .catalog-version).
# ────────────────────────────────────────────────────────────────────

do_ci_check() {
    local fmt="$1"
    local base_ref='origin/main'

    local catalog_changed version_changed
    catalog_changed="$(git diff --name-only "${base_ref}...HEAD" -- \
        "$CATALOG_GLOB" 2>/dev/null | wc -l | tr -d ' ')"
    version_changed="$(git diff --name-only "${base_ref}...HEAD" -- \
        "$VERSION_FILE" 2>/dev/null | wc -l | tr -d ' ')"

    if [ "$catalog_changed" -gt 0 ] && [ "$version_changed" -eq 0 ]; then
        # Failure: catalog changed without version bump.
        local current_version expected_version
        current_version="$(read_catalog_version_at_ref HEAD)"
        expected_version="$(read_catalog_version_at_ref "$base_ref")"

        case "$fmt" in
            json)
                # Emit a structured JSON object describing the failure.
                local files
                files="$(git diff --name-only "${base_ref}...HEAD" -- "$CATALOG_GLOB" 2>/dev/null)"
                local files_json
                files_json="$(printf '%s\n' "$files" | sed '/^$/d' | json_array_from_lines)"
                printf '{"ok": false, "files_changed": %s, "current_version": "%s", "expected_to_bump_from": "%s"}\n' \
                    "$files_json" "$current_version" "$expected_version"
                ;;
            *)
                printf '✗ Catalog files changed but .catalog-version was not bumped.\n' >&2
                printf 'Files changed:\n' >&2
                git diff --name-only "${base_ref}...HEAD" -- "$CATALOG_GLOB" >&2
                printf 'Current .catalog-version (HEAD): %s\n' "$current_version" >&2
                printf 'Expected to bump from (origin/main): %s\n' "$expected_version" >&2
                ;;
        esac
        return 1
    fi

    # Success path.
    case "$fmt" in
        json)
            printf '{"ok": true, "message": "no catalog changes — bump not required"}\n'
            ;;
        *)
            printf '✓ no catalog changes — bump not required\n'
            ;;
    esac
    return 0
}

# ────────────────────────────────────────────────────────────────────
# Argument parsing + dispatch
# ────────────────────────────────────────────────────────────────────

main() {
    if [ "$#" -eq 0 ]; then
        usage >&2
        exit 2
    fi

    local mode=''
    local fmt='changelog'
    local ref_a='' ref_b=''
    local v1='' v2=''

    set_mode() {
        local new_mode="$1"
        if [ -n "$mode" ]; then
            err "modes are mutually exclusive: --${mode} and --${new_mode} cannot be combined"
            usage >&2
            exit 2
        fi
        mode="$new_mode"
    }

    while [ "$#" -gt 0 ]; do
        case "$1" in
            --help|-h)
                usage
                exit 0
                ;;
            --ref-diff)
                set_mode 'ref-diff'
                shift
                if [ "$#" -lt 2 ]; then
                    err "--ref-diff requires two arguments: <ref-a> <ref-b>"
                    usage >&2
                    exit 2
                fi
                # Reject if either looks like another mode flag (would have
                # been an arg parser bug anyway, but be explicit).
                case "$1" in
                    --ref-diff|--version-diff|--ci-check)
                        err "--ref-diff requires two refs, got mode flag '$1'"
                        usage >&2
                        exit 2
                        ;;
                esac
                ref_a="$1"
                shift
                case "$1" in
                    --ref-diff|--version-diff|--ci-check)
                        err "--ref-diff requires two refs, got mode flag '$1'"
                        usage >&2
                        exit 2
                        ;;
                esac
                ref_b="$1"
                shift
                ;;
            --version-diff)
                set_mode 'version-diff'
                shift
                if [ "$#" -lt 2 ]; then
                    err "--version-diff requires two arguments: <v1> <v2>"
                    usage >&2
                    exit 2
                fi
                case "$1" in
                    --ref-diff|--version-diff|--ci-check)
                        err "--version-diff requires two versions, got mode flag '$1'"
                        usage >&2
                        exit 2
                        ;;
                esac
                v1="$1"
                shift
                case "$1" in
                    --ref-diff|--version-diff|--ci-check)
                        err "--version-diff requires two versions, got mode flag '$1'"
                        usage >&2
                        exit 2
                        ;;
                esac
                v2="$1"
                shift
                ;;
            --ci-check)
                set_mode 'ci-check'
                shift
                ;;
            --format=*)
                fmt="${1#--format=}"
                case "$fmt" in
                    changelog|diff|json) ;;
                    *)
                        err "unknown format: '$fmt' (must be changelog, diff, or json)"
                        usage >&2
                        exit 2
                        ;;
                esac
                shift
                ;;
            --format)
                # Support `--format X` form too.
                shift
                if [ "$#" -lt 1 ]; then
                    err "--format requires a value (changelog, diff, or json)"
                    usage >&2
                    exit 2
                fi
                fmt="$1"
                case "$fmt" in
                    changelog|diff|json) ;;
                    *)
                        err "unknown format: '$fmt' (must be changelog, diff, or json)"
                        usage >&2
                        exit 2
                        ;;
                esac
                shift
                ;;
            *)
                err "unknown argument: '$1'"
                usage >&2
                exit 2
                ;;
        esac
    done

    if [ -z "$mode" ]; then
        err "no mode specified (use --ref-diff, --version-diff, or --ci-check)"
        usage >&2
        exit 2
    fi

    case "$mode" in
        ref-diff)
            # R3: validate both refs BEFORE any git show.
            if ! validate_ref "$ref_a"; then
                if [ "$fmt" = 'json' ]; then
                    json_emit_error "ref '${ref_a}' not found"
                fi
                exit 2
            fi
            if ! validate_ref "$ref_b"; then
                if [ "$fmt" = 'json' ]; then
                    json_emit_error "ref '${ref_b}' not found"
                fi
                exit 2
            fi
            do_ref_diff "$ref_a" "$ref_b" "$fmt"
            ;;
        version-diff)
            do_version_diff "$v1" "$v2" "$fmt"
            ;;
        ci-check)
            do_ci_check "$fmt"
            ;;
    esac
}

main "$@"
