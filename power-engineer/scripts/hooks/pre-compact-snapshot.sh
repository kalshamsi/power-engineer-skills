#!/usr/bin/env bash
set -euo pipefail

# pre-compact-snapshot.sh — Power Engineer PreCompact hook (v1.4.0 Tier 3 supplement)
#
# Purpose: Capture a pre-compact snapshot of session state before Claude Code
# runs a compaction (either manual `/compact` or automatic context-limit-driven).
# The snapshot is written to `.power-engineer/pre-compact-<ISO-timestamp>.md`
# so that on post-compact resume, the user has a human-readable reference to
# what the project looked like immediately before context was summarized.
#
# Relationship to the 3-tier memory architecture:
#   - Tier 1 (reliability): CLAUDE.md proactive memory rules (always runs)
#   - Tier 2 (automation):  SessionEnd hook — session-handoff on exit
#   - Tier 3 (explicit):    /power-engineer save-phase flow
#   This script is a **Tier 3 SUPPLEMENT** — the context-crunch safety net that
#   fires *just before* compaction. It does NOT replace Tier 2 or the save-phase
#   ceremony; it complements them with a cheap, always-on snapshot.
#
# Hook contract:
#   - Fires on both `"manual"` and `"auto"` PreCompact triggers (matcher omitted
#     in registration so both are captured).
#   - Per CHANGELOG v2.1.105, PreCompact hooks can BLOCK compaction by exiting
#     with code 2 — this script deliberately NEVER does so. Compaction proceeds
#     regardless of snapshot success. All failure paths route diagnostics to
#     .power-engineer/memory-errors.log and exit 0.
#   - Uses CLAUDE_PROJECT_DIR (populated by Claude Code) to locate the project.
#
# See docs/superpowers/plans/v1.4.0-hooks-research.md for the PreCompact schema
# + firing semantics (sourced from code.claude.com/docs/en/hooks, 2026-04-16).

# ── Resolve project root ─────────────────────────────────────────────────────
# CLAUDE_PROJECT_DIR is set by Claude Code at hook invocation. Fall back to the
# current working directory if the var is unset (e.g., during manual testing).
project_dir="${CLAUDE_PROJECT_DIR:-$PWD}"
state_dir="${project_dir}/.power-engineer"
error_log="${state_dir}/memory-errors.log"
script_name="pre-compact-snapshot.sh"

# ── Error sink ───────────────────────────────────────────────────────────────
# Append errors to memory-errors.log with ISO-8601 UTC timestamp. `mkdir -p`
# runs first so the log dir exists even if state_dir was missing.
log_error() {
    # All stderr is silenced at the block level because bash reports redirection
    # failures (e.g., "Not a directory" when $state_dir exists as a regular
    # file) before the command runs, so per-command `2>/dev/null` is not
    # sufficient. The hook is best-effort; failing to log a failure is OK.
    {
        local message="$1"
        local ts
        ts="$(date -u +%Y-%m-%dT%H:%M:%SZ || echo 'timestamp-unavailable')"
        mkdir -p "$state_dir" || true
        printf '[%s] %s: %s\n' "$ts" "$script_name" "$message" >> "$error_log" || true
    } 2>/dev/null || true
}

# Trap any unhandled error → log it → exit 0 (PreCompact must NEVER block
# compaction — exit code 2 would block per CHANGELOG v2.1.105, so we are
# careful to exit 0 on every path, including the ERR trap).
trap 'log_error "unhandled error on line $LINENO (exit_code=$?)"; exit 0' ERR
trap 'exit 0' EXIT

# ── Collect snapshot fields (each with its own fallback) ─────────────────────
timestamp_iso="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo 'unknown')"
timestamp_filename="$(date -u +%Y%m%dT%H%M%SZ 2>/dev/null || echo 'unknown')"

# Git-dependent fields: each field falls back to a placeholder if git is
# unavailable or the cwd is not a git repo. Each command runs inside a
# subshell so `cd` does not affect the outer script, and the `|| printf`
# fallback keeps set -e happy on failure.
git_field() {
    # Usage: git_field <fallback> <git-args...>
    # Runs `git <args>` inside a subshell at $project_dir; prints <fallback>
    # on any failure.
    local fallback="$1"
    shift
    # Subshell: cd into project_dir and run git. On any failure, print fallback.
    ( cd "$project_dir" && git "$@" ) 2>/dev/null || printf '%s\n' "$fallback"
}

branch_name="$(git_field 'unknown' branch --show-current)"
recent_commits="$(git_field 'unavailable' log -10 --oneline)"
# `head -30` runs in the outer subshell so its non-zero exit on an empty
# pipeline input is harmless; modified_files stays 'unavailable' on git failure.
modified_files="$(git_field 'unavailable' status --porcelain | head -30)"

# ── Ensure state dir ─────────────────────────────────────────────────────────
if ! mkdir -p "$state_dir" 2>/dev/null; then
    log_error "failed to create state dir: $state_dir"
    exit 0
fi

# ── Write snapshot file ──────────────────────────────────────────────────────
# Use a grouped-redirection block (printf calls writing to the file) instead
# of a $(cat <<EOF) command substitution. The block avoids heredoc parser
# quirks around apostrophes in prose, keeps variable expansion explicit, and
# is ShellCheck-friendly.
snapshot_file="${state_dir}/pre-compact-${timestamp_filename}.md"

if ! {
    printf '# Pre-Compact Snapshot — %s\n\n' "$timestamp_iso"
    printf 'Generated automatically by the PreCompact hook, fired immediately\n'
    printf 'before Claude Code ran a compaction (manual `/compact` or auto).\n\n'
    printf '## Context\n\n'
    printf -- '- **Timestamp (UTC):** %s\n' "$timestamp_iso"
    printf -- '- **Branch:** %s\n' "$branch_name"
    printf -- '- **Project directory:** %s\n\n' "$project_dir"
    printf '## Recent commits (last 10)\n\n'
    printf '```\n%s\n```\n\n' "$recent_commits"
    printf '## Modified files (first 30 from git status)\n\n'
    printf '```\n%s\n```\n\n' "$modified_files"
    printf '## Post-compact Notes\n\n'
    printf '<!-- Fill in post-compaction, once Claude has resumed with the\n'
    printf '     summarized context. Use this section to record: what was\n'
    printf '     in-flight at compaction time, what specific details may have\n'
    printf '     been lost in the summary, and any restoration steps taken. -->\n\n'
    printf '## Notes\n\n'
    printf 'This file captures state at the moment PreCompact fired. Post-compact,\n'
    printf 'use this alongside CLAUDE.md auto-memory to restore context.\n\n'
    printf 'Generated by Power Engineer v1.4.0 PreCompact hook. The hook is\n'
    printf 'advisory — it NEVER blocks compaction (exit code 2 would, per\n'
    printf 'CHANGELOG v2.1.105; this script always exits 0). On snapshot\n'
    printf 'failure, diagnostics are routed to `.power-engineer/memory-errors.log`.\n'
} > "$snapshot_file" 2>/dev/null; then
    log_error "failed to write snapshot file: $snapshot_file"
    exit 0
fi

exit 0
