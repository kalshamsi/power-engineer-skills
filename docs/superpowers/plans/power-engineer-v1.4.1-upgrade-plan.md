# Power Engineer v1.4.1 Upgrade Plan — Hook-script hardening (security-review follow-ups)

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. This is a strict-patch release — scope is the two ⚠️ MINOR findings from the v1.4.0 security review, nothing else. No new catalog rows, no new modules, no new templates. The 4-phase shape below is deliberately lighter than the v1.4.0 9-phase plan because the diff is ~6 lines of bash and two Markdown entries.

**Goal:** Ship v1.4.1 as a strict-patch release addressing the two ⚠️ MINOR items from `docs/superpowers/plans/v1.4.0-security-review.md`: (1) sub-second timestamp collision in hook output filenames (append `$$` PID for uniqueness) and (2) operator observability for silent hook failures (optional stderr warning at hook start when `memory-errors.log` is non-empty, plus a CHANGELOG/MIGRATION note directing operators to check the log). No new features; no Cluster C work. Second dogfood pass of the Phase 6 `changelog-entry-template.md` + `migration-template.md` introduced in v1.4.0.

**Architecture:** Four phases rather than nine because the release is surgical. Phase 0 confirms the `$$`-append idiom on macOS bash 3.2 + zsh via a research subagent (External API gate). Phase 1 applies the two fixes under a Dev + Opus Auditor pair (hook-surface = HIGH-CAUTION). Phase 2 instantiates CHANGELOG v1.4.1 + MIGRATION v1.4.0 → v1.4.1 entries directly from the templates (dogfood); any template defect discovered fixes in-place per `release-process.md` §9. Phase 3 is the release ceremony, including a focused Opus security re-review of the patched scripts, Dual-Opus Template E end-to-end audit, tag, and GitHub release.

**Tech Stack:** Bash (hook scripts) + Markdown (CHANGELOG, MIGRATION) + YAML (GitHub Actions CI — touched only if `tests/run-all.sh` surfaces regressions). No new tools. ShellCheck remains the ship-time lint gate; `bash tests/run-all.sh` is the ship-time aggregator.

**Related artifacts:**
- Security review (v1.4.1 scope source): `docs/superpowers/plans/v1.4.0-security-review.md`
- Prior release plan (structure reference): `docs/superpowers/plans/power-engineer-v1.4.0-upgrade-plan.md`
- Prior retrospective: `~/.claude/projects/-Users-khalfan-Documents-Development-power-engineer-skills/memory/project_v140_released.md`
- Cross-cutting policy: `docs/superpowers/release-process/release-process.md`
- Feedback memories consumed during authoring: `feedback_plan_pattern_verification.md`, `feedback_external_api_verification.md`
- Templates dogfooded this release: `docs/superpowers/release-process/templates/changelog-entry-template.md`, `docs/superpowers/release-process/templates/migration-template.md`

---

## File Structure

Files created or modified, grouped by responsibility:

**Hook content (INSIDE `power-engineer/` — ships with the skill):**
- Modify: `power-engineer/scripts/hooks/session-end-handoff.sh` — append `$$` to `handoff_file` filename; optional stderr warning when `memory-errors.log` is non-empty at hook start
- Modify: `power-engineer/scripts/hooks/pre-compact-snapshot.sh` — append `$$` to `snapshot_file` filename; optional stderr warning when `memory-errors.log` is non-empty at hook start

**Catalog hygiene (INSIDE `power-engineer/`):**
- `.catalog-version` is NOT bumped (no catalog rows added/removed/renamed; no structural changes). CI `catalog-version-sync` enforces that it stays at `1.4.0`. CHANGELOG `### Catalog` subhead records `unchanged`.

**Docs + release ceremony (OUTSIDE `power-engineer/`):**
- Modify: `CHANGELOG.md` — v1.4.1 entry (instantiated from `changelog-entry-template.md`)
- Modify: `docs/MIGRATION.md` — v1.4.0 → v1.4.1 entry (instantiated from `migration-template.md`)
- Modify: `README.md` — version badge `1.4.0` → `1.4.1`; `## What's New in v1.4.0` → `## What's New in v1.4.1` with a short summary
- **NOT modified**: `power-engineer/SKILL.md` — verified via `grep` (2026-04-17): contains zero literal version references. Per `writing-skills` discipline, SKILL.md is a pure trigger-description file (name + description frontmatter only). Version bumps do not belong there. Leaving untouched preserves CSO trigger integrity.

**Release-process artifacts (OUTSIDE `power-engineer/` — maintainer-only, force-committed):**
- Create: `docs/superpowers/plans/power-engineer-v1.4.1-upgrade-plan.md` (this file)
- Create: `docs/superpowers/plans/v1.4.1-shellcheck-research.md` (Phase 0 Task 0.2 output)
- Create: `docs/superpowers/plans/v1.4.1-security-review.md` (Phase 3 Task 3.1 output)
- Modify (in-place per `release-process.md` §9 if dogfood surfaces defects): `docs/superpowers/release-process/templates/plan-template.md` awk-range command on line 240 (known-defective; see Plan-Pattern Verification Gates row 1)

---

## Phase 0 — Audit & Prep

**Goal:** Create the `v1.4.1-upgrade` branch, verify a clean baseline, and commission one research subagent to confirm the `$$`/`$RANDOM` idiom behaves correctly on every shell the hooks may run under (bash 3.2 macOS default / bash 5.x Homebrew / zsh 5.x macOS default — Claude Code hooks invoke scripts via their shebang, which is `#!/usr/bin/env bash`, so bash dominates but zsh compatibility matters if users source the scripts manually).

### Task 0.1: Create working branch

**Files:** None (git operation)

- [ ] **Step 1: Create local branch (no push per user HARD CONSTRAINT)**

```bash
git checkout main
git pull
git checkout -b v1.4.1-upgrade
```

Expected: local `v1.4.1-upgrade` branch on base `d91f905` (v1.4.0 squash).

**Push policy for v1.4.1:** User-level HARD CONSTRAINT overrides the `release-process.md` §4 Phase 0 branch-push exception. Branch stays local-only through Phase 0, 1, 2, and the audit steps of Phase 3. First (and only) push happens in Phase 3 Task 3.4 Step 1, immediately before `gh pr create --draft`. Rationale: user-directive tightens the §4 exception; all implementation commits stay locally revertible without coordination with origin.

- [ ] **Step 2: Confirm clean starting state**

```bash
git status
bash tests/run-all.sh
```

Expected: clean tree; lint suite exits 0 (same state as post-v1.4.0 release `d91f905`).

### Task 0.2: Research subagent — `$$`/`$RANDOM` idiom verification

**Files:** Create: `docs/superpowers/plans/v1.4.1-shellcheck-research.md` (force-committed)

Per `feedback_external_api_verification.md` + `release-process.md` §8, any change touching hook scripts is external-surface work. Even though `$$` is a POSIX shell special variable, we dispatch a focused Sonnet research subagent to confirm:

- [ ] **Step 1: Dispatch Research subagent (Sonnet)**

Brief (full wording lives in the executor prompt; here is the skeleton):

> You are a research subagent for Power Engineer v1.4.1. Confirm the following technical claims by consulting authoritative sources (bash manual, POSIX spec, macOS zsh manual) — do NOT rely on training-data memory:
> 1. In bash 3.2 (macOS system default) and bash 5.x, does `$$` expand to the current shell's PID inside a script invoked via `#!/usr/bin/env bash`?
> 2. Does `$$` behave the same way in zsh 5.x (macOS default login shell) if the script is sourced rather than executed?
> 3. Is there any ShellCheck warning (SC1000-series) triggered by `"${handoff_file}-$$"` or `"${handoff_file}-$RANDOM"` in strict mode? Run `shellcheck --severity=style` on a minimal example.
> 4. Confirm the PID-append idiom produces unique filenames under rapid successive invocation (test: run a loop of 10 script invocations in the same UTC second, observe filenames).
> 5. Compare `$$` vs `$RANDOM` for this use case. Does either carry a known bash quirk (e.g., `$RANDOM` reuse when multiple subshells are spawned in the same second)?
>
> Save findings as structured markdown to `docs/superpowers/plans/v1.4.1-shellcheck-research.md`. Include: one-paragraph summary, per-question answers with citations, concrete recommendation (use `$$`, use `$RANDOM`, or use both concatenated — e.g. `-$$-$RANDOM`). If the recommendation contradicts the plan text, flag it so the orchestrator can update the plan before dispatching Phase 1 Dev.

- [ ] **Step 2: Review subagent output**

Confirm the report covers all 5 questions and produces an explicit recommendation. If the recommendation diverges from the plan's default (`$$`), surface via `AskUserQuestion` before proceeding.

- [ ] **Step 3: Commit the research doc**

```bash
git add -f docs/superpowers/plans/v1.4.1-shellcheck-research.md
git commit -m "docs(v1.4.1): shellcheck + \$\$/\$RANDOM idiom research (Phase 0)"
```

### Task 0.3: Phase 0 checkpoint

**Files:** None (git operation)

- [ ] **Step 1: Empty checkpoint commit**

```bash
git commit --allow-empty -m "checkpoint: Phase 0 complete and approved by user"
```

### Phase 0 Verification

- [ ] Branch `v1.4.1-upgrade` exists and tracks origin
- [ ] `docs/superpowers/plans/v1.4.1-shellcheck-research.md` exists and contains an explicit idiom recommendation
- [ ] `bash tests/run-all.sh` → exit 0 (clean baseline, lint unaffected)
- [ ] Empty checkpoint commit present on branch

---

## Phase 1 — Patch Hook Scripts

**Goal:** Apply the two security-review minor fixes to both hook scripts.

### Task 1.1: Patch `session-end-handoff.sh`

**Files:** Modify: `power-engineer/scripts/hooks/session-end-handoff.sh`

**Risk class:** HIGH-CAUTION (hook surface, external API). Model assignment: Sonnet Dev acceptable since the diff is mechanical (2 edits, ~6 lines total); Auditor MUST be Opus per `subagent-selector.md` audit row.

- [ ] **Step 1: Append `$$` to handoff_file**

Change line 82 from:

```bash
handoff_file="${state_dir}/session-handoff-${timestamp_filename}.md"
```

to (exact string per Phase 0 research recommendation; default is `-$$`):

```bash
handoff_file="${state_dir}/session-handoff-${timestamp_filename}-$$.md"
```

- [ ] **Step 2: Add memory-errors.log surfacing at hook start**

Insert BEFORE line 21 (before `project_dir=` resolution) a block that emits a stderr warning if the memory-errors log already has content. Exact wording subject to Phase 0 research confirmation; target shape:

```bash
# ── Operator observability: surface prior hook failures ──────────────────────
# If memory-errors.log already has entries from prior invocations, emit a
# one-line stderr note so operators notice silent-failure accumulation. This
# does NOT block the hook (exit 0 on every path is still the contract).
_prior_errlog="${CLAUDE_PROJECT_DIR:-$PWD}/.power-engineer/memory-errors.log"
if [[ -s "$_prior_errlog" ]]; then
    printf 'session-end-handoff.sh: prior hook errors logged at %s\n' "$_prior_errlog" >&2
fi
unset _prior_errlog
```

The guard:
- `[[ -s file ]]` is a bash built-in (safe under `set -u` because we default via `${VAR:-}`).
- Writes to stderr (FD 2), not stdout — Claude Code transcript surfaces stderr.
- `unset` avoids polluting the later `log_error` scope.
- Never fails the hook: if the read fails (unreadable file), the guard short-circuits; the rest of the script continues.

- [ ] **Step 3: ShellCheck clean**

```bash
shellcheck power-engineer/scripts/hooks/session-end-handoff.sh
```

Expected: exit 0, no new SC warnings beyond the 2 existing SC2016 suppressions.

- [ ] **Step 4: Manual smoke test**

```bash
# Run the hook twice in rapid succession, confirm two distinct output files
TMP=$(mktemp -d)
cp power-engineer/scripts/hooks/session-end-handoff.sh "$TMP/"
CLAUDE_PROJECT_DIR="$TMP" bash "$TMP/session-end-handoff.sh" &
CLAUDE_PROJECT_DIR="$TMP" bash "$TMP/session-end-handoff.sh" &
wait
ls -1 "$TMP/.power-engineer/session-handoff-"*.md | wc -l
# Expected: 2
```

- [ ] **Step 5: Commit**

```bash
git add power-engineer/scripts/hooks/session-end-handoff.sh
git commit -m "fix(hooks): prevent session-end-handoff filename collision + surface prior errors"
```

### Task 1.2: Patch `pre-compact-snapshot.sh`

**Files:** Modify: `power-engineer/scripts/hooks/pre-compact-snapshot.sh`

Same shape as Task 1.1, applied to `snapshot_file` on line 98 and an identical stderr-warning block before line 35 (before `project_dir=` resolution).

- [ ] **Step 1: Append `$$` to snapshot_file**
- [ ] **Step 2: Add memory-errors.log surfacing at hook start** (identical block, with `printf` prefix updated to `pre-compact-snapshot.sh:`)
- [ ] **Step 3: ShellCheck clean** (expected: no new warnings beyond the 4 existing SC2016 suppressions)
- [ ] **Step 4: Manual smoke test** (same as Task 1.1 Step 4, with `pre-compact-` filename prefix)
- [ ] **Step 5: Commit**

```bash
git add power-engineer/scripts/hooks/pre-compact-snapshot.sh
git commit -m "fix(hooks): prevent pre-compact-snapshot filename collision + surface prior errors"
```

### Task 1.3: Opus Auditor pass

**Files:** None (audit only; no commit unless remediation required)

- [ ] **Step 1: Dispatch Opus Auditor (Template B)**

Brief the auditor with: the two security-review minor items (copy from `v1.4.0-security-review.md` §Recommendations), the two patched scripts, Phase 0 research doc, and the manual-smoke-test evidence. Auditor MUST re-run `shellcheck` and the smoke test; MUST verify the exit-0 hook contract is preserved on every path; MUST verify no new SC warnings beyond existing suppressions; MUST confirm PID-append idiom produces unique filenames under concurrent invocation.

- [ ] **Step 2: On APPROVED, proceed to Task 1.4. On ISSUES FOUND, dispatch Remediator (Template C).** Re-audit after remediation; max two auto-remediations per `release-process.md` §3.

### Task 1.4: Phase 1 checkpoint

- [ ] **Step 1: Empty checkpoint commit**

```bash
git commit --allow-empty -m "checkpoint: Phase 1 complete and approved by user"
```

### Phase 1 Verification

- [ ] Both hook scripts contain `${timestamp_filename}-$$` in the output filename variable
- [ ] Both hook scripts emit a stderr warning at hook start when `memory-errors.log` is non-empty
- [ ] `shellcheck power-engineer/scripts/hooks/*.sh` → exit 0
- [ ] Concurrent-invocation smoke test produces N distinct files for N invocations
- [ ] Opus Auditor returned APPROVED
- [ ] `bash tests/run-all.sh` → exit 0

---

## Phase 2 — CHANGELOG + MIGRATION (Dogfood Templates)

**Goal:** Instantiate `changelog-entry-template.md` and `migration-template.md` for v1.4.1. Second dogfood pass after v1.4.0 — surface + fix any template defects in-place per `release-process.md` §9. **Known defect entering this phase** (discovered during plan-pattern verification): `docs/superpowers/release-process/templates/plan-template.md` line 240 awk-range command closes the range on the start line when start + end regex both match the same `## [` header — will be fixed as part of Task 2.3 below.

### Task 2.1: Write CHANGELOG v1.4.1 entry (instantiate template)

**Files:** Modify: `CHANGELOG.md`

**Model:** Sonnet Dev (content-only prose work).

- [ ] **Step 1: Insert v1.4.1 entry ABOVE the v1.4.0 entry**

Entry shape (derived from `changelog-entry-template.md`):

```markdown
## [1.4.1] — <YYYY-MM-DD>

### Added
- Stderr warning at hook start when `.power-engineer/memory-errors.log` contains prior entries — operator-observability surface for silent hook failures (addresses v1.4.0 security review ⚠️ MINOR #2)

### Changed
- `power-engineer/scripts/hooks/session-end-handoff.sh` and `power-engineer/scripts/hooks/pre-compact-snapshot.sh` output filenames now include process ID (`$$`) alongside the UTC second-resolution timestamp — prevents filename collision on sub-second concurrent invocations (addresses v1.4.0 security review ⚠️ MINOR #1)

### Catalog
- **Catalog version:** 1.4.0 (unchanged)
- **Skills added:** none
- **Skills removed:** none
- **Skills renamed:** none
- **Structural changes:** none

### Removed
- None

### Migration
- Existing v1.4.0 users: see `docs/MIGRATION.md`. All changes additive; no breaking changes. Re-run `/power-engineer configure` is NOT required — the hook scripts are shipped in-place via `npx skills add`. Operators are advised to periodically check `.power-engineer/memory-errors.log` for silent hook failures (now surfaced at hook start via stderr).
```

Replace `<YYYY-MM-DD>` with the actual tag date at commit time.

- [ ] **Step 2: Verify v1.4.1 CHANGELOG entry is template-derived (dogfood check)**

Use the CORRECTED awk-range pattern (flag-based; see Plan-Pattern Verification Gates row 1):

```bash
diff \
  <(grep -E '^### ' docs/superpowers/release-process/templates/changelog-entry-template.md) \
  <(awk '/^## \[1.4.1\]/{flag=1; next} flag && /^## \[/{exit} flag' CHANGELOG.md | grep -E '^### ') \
  && echo "OK: v1.4.1 CHANGELOG structurally derived from template" \
  || echo "FAIL: changelog entry diverges from template shape (dogfooding gap)"
```

Expected: matching `###` subheads in the same order (Added / Changed / Catalog / Removed / Migration). Divergence → fix the template OR the entry in-place per `release-process.md` §9.

- [ ] **Step 3: Commit**

```bash
git add CHANGELOG.md
git commit -m "docs: add CHANGELOG v1.4.1 entry"
```

### Task 2.2: Write MIGRATION v1.4.0 → v1.4.1 entry (instantiate template)

**Files:** Modify: `docs/MIGRATION.md`

**Model:** Sonnet Dev (content-only prose work).

- [ ] **Step 1: Insert v1.4.0 → v1.4.1 entry ABOVE the v1.3.0 → v1.4.0 entry**

Entry shape (derived from `migration-template.md`):

```markdown
## v1.4.0 → v1.4.1

**TL;DR:** Two defensive-hardening fixes to the v1.4.0 SessionEnd + PreCompact hook scripts. All changes additive. Your existing skills + state continue to work.

### What changed
1. **Hook output filenames include process ID.** Both `session-end-handoff.sh` and `pre-compact-snapshot.sh` now append `$$` (current shell PID) to the timestamped output filename. Prevents sub-second collision when hooks fire in rapid succession.
2. **Operator observability for silent hook failures.** Both hooks now emit a one-line stderr warning at start when `.power-engineer/memory-errors.log` contains prior entries. The warning is non-blocking (hook still exits 0) and surfaces the accumulated-failure case that would otherwise stay silent.

### What users must do
Nothing required. Upgrade is `npx skills add power-engineer@1.4.1` (or the pinned-SHA equivalent). Existing `.power-engineer/` state is preserved.

### Optional
Periodically check `.power-engineer/memory-errors.log` to surface silent hook failures:

```bash
cat .power-engineer/memory-errors.log
```

Empty file = no failures recorded. Non-empty file = hooks have logged at least one failure; the stderr warning at v1.4.1 hook start will now surface this, but operators checking manually is a useful belt-and-suspenders habit.

### Rollback
To roll back to v1.4.0:

```bash
git revert <v1.4.1-release-commit>
# or
git checkout v1.4.0 -- power-engineer/scripts/hooks/
```

No state cleanup required — the v1.4.1 hook output files interleave cleanly with v1.4.0 output files (filename prefix unchanged; only the suffix adds `-$$`).
```

- [ ] **Step 2: Verify v1.4.0 → v1.4.1 MIGRATION entry is template-derived (dogfood check)**

Use the corrected flag-based awk-range pattern (see Plan-Pattern Verification Gates row 2):

```bash
diff \
  <(grep -E '^### ' docs/superpowers/release-process/templates/migration-template.md) \
  <(awk '/^## v1.4.0 → v1.4.1/{flag=1; next} flag && /^## v/{exit} flag' docs/MIGRATION.md | grep -E '^### ') \
  && echo "OK: v1.4.0 → v1.4.1 MIGRATION structurally derived from template" \
  || echo "FAIL: migration entry diverges from template shape (dogfooding gap)"
```

Expected: matching `###` subheads in the same order (What changed / What users must do / Optional / Rollback).

- [ ] **Step 3: Commit**

```bash
git add docs/MIGRATION.md
git commit -m "docs: add MIGRATION v1.4.0 → v1.4.1 entry"
```

### Task 2.3: Fix plan-template.md awk-range defect (template in-place fix)

**Files:** Modify: `docs/superpowers/release-process/templates/plan-template.md`

Per `release-process.md` §9 "in-place fix protocol": the dogfood commands above use the corrected flag-based awk pattern. The plan-template at line 240 ships a defective pattern (`/^## \[<X.Y.Z>\]/,/^## \[/`) that closes the range on the start line. Fix both the template text AND leave a one-line comment explaining the trap so the next planner doesn't re-introduce it.

- [ ] **Step 1: Update plan-template.md line 240 region**

Replace the defective command block (around lines 237-243) with:

```bash
# Use a flag-based awk pattern rather than the `/^## \[X.Y.Z\]/,/^## \[/` range
# form — the range form closes on the start line when the start+end regex both
# match the same `## [` header, truncating extracted subheads to zero.
diff \
  <(grep -E '^### ' docs/superpowers/release-process/templates/changelog-entry-template.md) \
  <(awk '/^## \[<X.Y.Z>\]/{flag=1; next} flag && /^## \[/{exit} flag' CHANGELOG.md | grep -E '^### ') \
  && echo "OK: v<X.Y.Z> CHANGELOG structurally derived from template" \
  || echo "FAIL: changelog entry diverges from template shape (dogfooding gap)"
```

- [ ] **Step 2: Verify no other awk-range occurrences in templates**

```bash
/usr/bin/grep -rn "awk '/.*\[.*\].*/,/.*\[.*\]/'" docs/superpowers/release-process/templates/ || echo "OK: no other defective awk ranges"
```

- [ ] **Step 3: Commit**

```bash
git add docs/superpowers/release-process/templates/plan-template.md
git commit -m "fix(release-process): correct plan-template awk-range dogfood command"
```

### Task 2.4: Sonnet Auditor pass on Phase 2

**Files:** None (audit only)

- [ ] **Step 1: Dispatch Sonnet Auditor (Template B)**

Audit brief: verify CHANGELOG v1.4.1 entry + MIGRATION v1.4.0→v1.4.1 entry both pass the corrected dogfood diffs; verify the template defect fix landed cleanly; verify `bash tests/run-all.sh` stays green (CI `catalog-version-sync` MUST NOT fire — `.catalog-version` is unchanged at `1.4.0`); verify no other `awk` range defects in any template.

- [ ] **Step 2: On APPROVED, proceed to Task 2.5. On ISSUES FOUND, dispatch Remediator.**

### Task 2.5: Phase 2 checkpoint

- [ ] **Step 1: Empty checkpoint commit**

```bash
git commit --allow-empty -m "checkpoint: Phase 2 complete and approved by user"
```

### Phase 2 Verification

- [ ] CHANGELOG.md v1.4.1 entry present; 5 `### ` subheads match template (dogfood diff passes)
- [ ] docs/MIGRATION.md v1.4.0→v1.4.1 entry present; 4 `### ` subheads match template (dogfood diff passes)
- [ ] `power-engineer/.catalog-version` unchanged at `1.4.0`
- [ ] plan-template.md line 240 awk-range defect fixed
- [ ] Sonnet Auditor returned APPROVED
- [ ] `bash tests/run-all.sh` → exit 0

---

## Phase 3 — Release Ceremony

**Goal:** Ship v1.4.1. Version bumps, Opus security re-review of patched scripts, Dual-Opus Template E end-to-end audit, user checkpoint, draft PR → ready → squash-merge → annotated tag → GitHub release → post-release dogfood of `/power-engineer save-phase`.

**Risk class:** HIGH-CAUTION throughout. Model assignment: Opus for every auditor + Dev in this phase per `release-process.md` §3 + `subagent-selector.md` audit+release-ceremony rows.

### Task 3.1: Version bumps

**Files:** Modify: `README.md` only (SKILL.md verified zero-references at plan-authoring time; leave untouched per `writing-skills` trigger-integrity guidance).

**Model:** Sonnet Dev (mechanical string replacement).

- [ ] **Step 1: Grep for forward-looking version references**

```bash
/usr/bin/grep -rn 'v1\.4\.0\|1\.4\.0' README.md 2>/dev/null
```

Expected hits (verified 2026-04-17):
- `README.md:8` — version badge `version-1.4.0-blue`
- `README.md:224` — `## What's New in v1.4.0`
- `README.md:234` — `v1.4.0 adds a three-tier memory system...`

Review each hit individually. Historical entries in CHANGELOG and MIGRATION MUST NOT be bumped.

- [ ] **Step 2: Update each forward-looking occurrence to v1.4.1**

For README `What's New` section, replace the v1.4.0 prose with a short v1.4.1 summary:

```markdown
## What's New in v1.4.1

v1.4.1 is a strict-patch release addressing two ⚠️ MINOR findings from the v1.4.0 security review:

- **Filename collision prevention.** SessionEnd + PreCompact hook output filenames now include the current shell PID (`$$`) alongside the UTC timestamp, preventing clobber on sub-second concurrent invocations.
- **Silent-failure observability.** Both hooks emit a one-line stderr warning at start when `.power-engineer/memory-errors.log` has accumulated prior failures. The warning is non-blocking and surfaces the silent-failure accumulation case.

No catalog or architectural changes. All additive. See `CHANGELOG.md` + `docs/MIGRATION.md` for full detail.
```

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: bump version references 1.4.0 → 1.4.1"
```

### Task 3.2: Opus security re-review of patched scripts

**Files:** Create: `docs/superpowers/plans/v1.4.1-security-review.md` (force-committed)

**Model:** Opus security-review subagent (separate dispatch, fresh context).

- [ ] **Step 1: Dispatch Opus security-review subagent**

Brief: Review the two patched hook scripts against the same threat model as `v1.4.0-security-review.md` (shell injection / path traversal / env var assumptions / race conditions / error handling / Power Engineer-specific). Explicitly verify:
1. The `-$$` filename suffix does not introduce a new injection surface (PID is bash-integer; interpolated as `%s` data → safe).
2. The new stderr-warning block at hook start does not break the exit-0 hook contract on any path (e.g., `[[ -s file ]]` on an unreadable file — does it return non-zero and trigger the ERR trap?).
3. Both scripts still ShellCheck-clean with the documented 6 SC2016 suppressions.
4. Both scripts still defend against hostile `CLAUDE_PROJECT_DIR`, commit messages with `$(…)`, branch-name newline injection.

Save report to `docs/superpowers/plans/v1.4.1-security-review.md`. Recommended format: same structure as `v1.4.0-security-review.md` (Summary + per-script Findings + Verdict).

- [ ] **Step 2: Address findings**

Critical findings: block release; dispatch Remediator. Minor findings: note for v1.4.2 or fix in-place per user AskUserQuestion.

- [ ] **Step 3: Commit the security-review doc**

```bash
git add -f docs/superpowers/plans/v1.4.1-security-review.md
git commit -m "docs(v1.4.1): Opus security re-review of patched hook scripts"
```

### Task 3.3: User checkpoint before PR

**Files:** None

- [ ] **Step 1: AskUserQuestion — proceed to PR?**

Surface to the user via `AskUserQuestion`: "Phase 0-3 Task 3.2 complete. Security re-review is RELEASE-SAFE. Ready to push + create draft PR?" Options: proceed / review specific commits first / abort.

- [ ] **Step 2: Empty checkpoint commit**

```bash
git commit --allow-empty -m "checkpoint: Phase 3 pre-PR audits complete and approved by user"
```

### Task 3.4: Push branch + create draft PR

**Files:** None (git + gh operations)

- [ ] **Step 1: Push branch**

```bash
git push
```

This is the first push of v1.4.1 content (Phase 0 Task 0.1 pushed the empty branch). Per `release-process.md` §4, mid-release pushes are forbidden; this push occurs inside the release ceremony.

- [ ] **Step 2: Create draft PR**

```bash
gh pr create --draft \
  --title "v1.4.1 — Hook-script hardening (security-review follow-ups)" \
  --body "$(cat <<'EOF'
## Summary

Strict-patch release addressing the two ⚠️ MINOR items from the v1.4.0 security review:

1. Hook output filenames now include `$$` (PID) to prevent sub-second collision.
2. Both hooks emit a one-line stderr warning at start when `memory-errors.log` has prior entries.

No catalog changes. No new features. Second dogfood pass of the v1.4.0 release-process templates.

## Test plan

- [x] `shellcheck power-engineer/scripts/hooks/*.sh` clean
- [x] Concurrent-invocation smoke test produces N distinct output files for N invocations
- [x] `bash tests/run-all.sh` exit 0
- [x] Dogfood diffs (CHANGELOG + MIGRATION) pass against templates
- [x] Opus security re-review: RELEASE-SAFE
- [ ] CI green on draft PR

See `CHANGELOG.md` v1.4.1 entry for full changelog; `docs/MIGRATION.md` v1.4.0 → v1.4.1 for upgrade path.
EOF
)"
gh pr checks --watch
```

Expected: all CI jobs pass green, including `catalog-version-sync` (verifies `.catalog-version` is `1.4.0` and no catalog rows changed).

### Task 3.5: Final Dual-Opus end-to-end audit

**Files:** None (audit only)

**Model:** 2 × Opus auditor (Template E dual-review pattern) per `release-process.md` §3.

- [ ] **Step 1: Dispatch two Opus Template E auditors in parallel**

Both briefed on: full plan, all commits on `v1.4.1-upgrade` branch, security-review doc, CHANGELOG + MIGRATION entries, template fix. Each auditor independently verifies release readiness (criteria list below).

Criteria (each auditor returns PASS/FAIL per row):
1. Both hook scripts include `$$` in output filename
2. Both hook scripts emit stderr warning at start when memory-errors.log is non-empty
3. Exit-0 hook contract preserved on every path
4. ShellCheck clean on both scripts (existing suppressions only)
5. CHANGELOG v1.4.1 entry structurally derived from changelog-entry-template.md
6. MIGRATION v1.4.0→v1.4.1 entry structurally derived from migration-template.md
7. plan-template.md awk-range defect fixed in-place
8. `.catalog-version` unchanged at `1.4.0`
9. README + SKILL.md version bumps applied (no stale `1.4.0` in forward-looking text)
10. No push occurred mid-release (single branch-push at Phase 0 Task 0.1, single content-push at Phase 3 Task 3.4)
11. Opus security re-review RELEASE-SAFE
12. CI green on draft PR
13. `bash tests/run-all.sh` exit 0 on current HEAD

- [ ] **Step 2: Reconcile dual-auditor findings**

Agreed PASS → proceed. Any FAIL → dispatch Remediator; re-audit after. Max one round of auto-remediation at this phase; on second FAIL, escalate via AskUserQuestion (options: remediate manually / abort release / defer to v1.4.2).

### Task 3.6: Merge + tag + release

**Files:** None (git + gh operations)

- [ ] **Step 1: Mark PR ready + squash-merge**

```bash
gh pr ready
gh pr merge --squash --admin
```

`--admin` bypass per `release-process.md` §5.

- [ ] **Step 2: Merge-confirmation gate (MANDATORY — halts if merge silently failed)**

```bash
git checkout main
git pull
if ! git log --oneline -20 | /usr/bin/grep -qi 'v1.4.1'; then
  echo "v1.4.1 squash commit not found on main — aborting tag"
  exit 1
fi
```

- [ ] **Step 3: Tag annotated**

```bash
git tag -a v1.4.1 -m "Power Engineer v1.4.1 — Hook-script hardening (security-review follow-ups)"
git push origin v1.4.1
```

- [ ] **Step 4: Create GitHub release**

```bash
gh release create v1.4.1 \
  --title "v1.4.1 — Hook-script hardening (security-review follow-ups)" \
  --verify-tag \
  --notes-file <(sed -n '/## \[1.4.1\]/,/## \[/p' CHANGELOG.md | sed '$d')
```

`--verify-tag` is the defensive guard baked in during v1.4.0 Phase 9 Task 9.5 gh-CLI research (see `project_v140_released.md`).

- [ ] **Step 5: Verify release is live**

```bash
gh release view v1.4.1
```

Expected: release URL returns; `isDraft: false`; `isPrerelease: false`; body matches CHANGELOG extract.

### Task 3.7: Post-release — save session memory

**Files:** Create: `~/.claude/projects/-Users-khalfan-Documents-Development-power-engineer-skills/memory/project_v141_released.md` (via /power-engineer save-phase or direct Write)

- [ ] **Step 1: Invoke `/power-engineer save-phase`** (dogfood the explicit-save flow — third-tier memory)
- [ ] **Step 2: Verify memory file created**

```bash
ls -la ~/.claude/projects/-Users-khalfan-Documents-Development-power-engineer-skills/memory/project_v141_released.md
```

### Phase 3 Verification

- [ ] README + SKILL.md version bumps applied (forward-looking only; historical untouched)
- [ ] Opus security re-review: RELEASE-SAFE; report committed at `docs/superpowers/plans/v1.4.1-security-review.md`
- [ ] Dual-Opus Template E end-to-end audit: both auditors return all criteria PASS
- [ ] PR merged via `gh pr merge --squash --admin`
- [ ] Merge-confirmation gate passed (v1.4.1 squash commit present on main)
- [ ] Tag `v1.4.1` pushed; annotated (`git cat-file -t v1.4.1` = "tag")
- [ ] GitHub release published (`gh release view v1.4.1` returns)
- [ ] `/power-engineer save-phase` invoked post-release; retrospective memory file created

---

## Plan-Pattern Verification Gates

Per `feedback_plan_pattern_verification.md`: patterns spot-checked against real files before plan ships to executors.

| # | Pattern (paste verbatim) | Intended target file(s) | Expected match count | Actual match count | PASS / FAIL |
|---|---|---|---|---|---|
| 1 | `awk '/^## \[1.4.0\]/{flag=1; next} flag && /^## \[/{exit} flag' CHANGELOG.md \| grep -cE '^### '` (corrected flag-based range, dry-run against v1.4.0 as v1.4.1 stand-in) | `CHANGELOG.md` (v1.4.0 section, 5 subheads); `CHANGELOG.md` post-v1.4.1-entry (5 subheads) | 5 | 5 | PASS |
| 2 | `awk '/^## v1.3.0 → v1.4.0/{flag=1; next} flag && /^## v/{exit} flag' docs/MIGRATION.md \| grep -cE '^### '` (dry-run against v1.3.0→v1.4.0 as v1.4.0→v1.4.1 stand-in) | `docs/MIGRATION.md` (v1.3.0→v1.4.0 section, 4 subheads) | 4 | 4 | PASS |
| 3 | `grep -cE '^### ' docs/superpowers/release-process/templates/changelog-entry-template.md` | template file | 5 | 5 | PASS |
| 4 | `grep -cE '^### ' docs/superpowers/release-process/templates/migration-template.md` | template file | 4 | 4 | PASS |
| 5 | `/usr/bin/grep -rn 'v1\.4\.0\|1\.4\.0' README.md` (Phase 3.1 bump detection) | `README.md` | ≥3 (badge, "What's New" heading, body prose) | 3 (lines 8, 224, 234) | PASS |
| 6 | `sed -n '/## \[1.4.1\]/,/## \[/p' CHANGELOG.md \| sed '$d'` (gh release notes extractor, works correctly on sed per §Phase 0 verification — sed range semantics tolerate start+end-on-same-line) | `CHANGELOG.md` (post-v1.4.1-entry) | non-empty; ≥20 lines | TBD post-Task 2.1 | UNVERIFIED (rely on sed semantics; dry-run against v1.4.0 returned 27 lines) |

**Known defect surfaced at plan-authoring time:** `docs/superpowers/release-process/templates/plan-template.md` line 240 ships the awk-range form `/^## \[<X.Y.Z>\]/,/^## \[/` which closes the range on the start line. Fixed in-place as part of Task 2.3. The defect was latent in v1.4.0 (never exercised as a literal template instantiation).

**Failure handling:** All rows above read PASS at plan-ship time. Row 6 is verified post-Task 2.1 before the Phase 3.4 release-creation command relies on it.

---

## External API Research Gates

Per `feedback_external_api_verification.md`.

**In-scope surfaces for this release:**
- Claude Code hooks (SessionEnd, PreCompact scripts)
- `gh` CLI flags (pr merge, release create, release view)
- macOS bash 3.2 / bash 5.x / zsh compatibility for `$$` and `[[ -s file ]]`

**Planner checklist:**

| # | Task | External surface touched | Research subagent dispatched (Phase / Task) | Output saved to | Dev brief references the doc? |
|---|---|---|---|---|---|
| 1 | Task 1.1, 1.2 | Claude Code hook surface + bash `$$`/`[[ -s ]]` idioms | Phase 0 Task 0.2 | `docs/superpowers/plans/v1.4.1-shellcheck-research.md` | **yes — dispatch Dev only after research doc exists and is referenced in brief** |
| 2 | Task 3.4, 3.6 | `gh pr create --draft`, `gh pr ready`, `gh pr merge --squash --admin`, `gh release create --verify-tag`, `gh release view` | **reuse** `docs/superpowers/plans/v1.4.0-gh-cli-research.md` (v1.4.0 findings still current; no gh CLI major-version bump in the last month) | v1.4.0 research doc | **yes — orchestrator confirms no gh version drift before Phase 3.4 via `gh --version` and a quick release-notes spot-check** |

**Failure handling:** Row 1 MUST be "yes" before dispatching Phase 1 Devs. Row 2 allows reuse; if a `gh` major bump ships between v1.4.0 and v1.4.1 ship-date, dispatch a fresh research subagent.

**Auditor brief reminder:** Phase 1.3 Auditor + Phase 3.5 Dual-Opus Auditor both cross-check that Devs consumed the research docs' recommendations (e.g., used `$$` if that was the research recommendation; did not revert to a remembered `$RANDOM` form without justification).

---

## Risk & Rollback

### Biggest risks

- **Phase 1 (hook patch)** — hook-surface change affects every user who ran `/power-engineer configure`; if the stderr-warning block breaks the exit-0 contract, SessionEnd or PreCompact could block session termination or compaction. Mitigation: Phase 0 research + Phase 1.3 Opus Auditor with explicit exit-code verification + Phase 3.2 Opus security re-review.
- **Phase 2 (template dogfood)** — plan-template awk-range defect MUST be fixed in-place; Task 2.3 is the sole fix for it. If Task 2.3 is skipped, v1.4.2+ inherits the defect. Mitigation: Task 2.3 is a separate discrete task (not a sub-step), gated by the Phase 2 Sonnet Auditor.
- **Phase 3 (release ceremony)** — first dogfood of the v1.4.0 templates that did NOT instantiate in v1.4.0's own release (plan-template itself was created in v1.4.0 Phase 6 but v1.4.0 used a plan authored in parallel, not via template instantiation). Any further latent template defects surface here. Mitigation: in-place fix protocol per `release-process.md` §9; user AskUserQuestion before each in-place template fix so scope creep stays visible.

### Rollback per phase

| Phase | Risk | Likelihood | Mitigation | Per-phase rollback command(s) |
|---|---|---|---|---|
| 0 | Branch contaminated | Low | Branch is empty pre-implementation | `git checkout main && git branch -D v1.4.1-upgrade` |
| 1 | Hook patch breaks exit-0 contract | Low | Opus Auditor re-runs exit-code verification | `git revert <phase-1-task-1.1-commit> <phase-1-task-1.2-commit>` |
| 2 | CHANGELOG/MIGRATION content wrong; template fix wrong | Low | Sonnet Auditor runs dogfood diffs | `git revert <phase-2-commits-2.1 2.2 2.3>` |
| 3 | Tag pushed prematurely / merge-confirmation gate skipped | Low | Step 2 gate + `--verify-tag` on release create; never delete tags without user approval | `git tag -d v1.4.1; git push --delete origin v1.4.1; gh release delete v1.4.1 --yes; git revert <squash-commit>` |

### Full-release rollback

```bash
git checkout main
git revert <squash-commit-of-v1.4.1-PR>
git tag -d v1.4.1
git push origin :refs/tags/v1.4.1
gh release delete v1.4.1 --yes
```

Restores v1.4.0 behavior. No user-side action required — the hook scripts are shipped in-place via `npx skills add`; users who upgrade to v1.4.1 and then downgrade have their state preserved (filename prefix unchanged; only the `-$$` suffix addition differs).

---

## Out of Scope

- **v1.4.2 (next patch)**: `/power-engineer uninstall <skill>`, `/power-engineer info <skill>`, `scripts/catalog-diff.sh` (QoL pack items originally slotted for v1.4.2 per project_v140_brainstorm.md). Any drift discovered during v1.4.1 release ceremony.
- **v1.5.0 (next minor)**: Cluster C — project-implementation advisor, extensibility framework, behavioral-CI wiring, PR-policy formalization (per project_v140_released.md).
- **v1.2.0 remote tag hygiene**: Still open per project_v130_released.md; defers to a standalone housekeeping commit or v1.4.2.
- **Permanently out of scope for v1.4.1**: Any code change beyond the two security-review minor items. No README polish beyond version bumps. No catalog changes. No new templates. No subagent-selector changes. No hook-schema changes.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/power-engineer-v1.4.1-upgrade-plan.md`. Execution approach:

**Subagent-Driven (recommended)** — orchestrator dispatches per-task subagents following `docs/superpowers/release-process/templates/executor-prompt-template.md`. Approximately 6-10 dispatches total:

| Phase | Tasks | Model(s) | Dispatch count |
|---|---|---|---|
| 0 | 0.1 (branch), 0.2 (shellcheck research), 0.3 (checkpoint) | Sonnet research | 1 |
| 1 | 1.1 (patch script 1), 1.2 (patch script 2), 1.3 (auditor), 1.4 (checkpoint) | Sonnet Dev + Opus Auditor | 2-3 (Devs may batch) |
| 2 | 2.1 (CHANGELOG), 2.2 (MIGRATION), 2.3 (template fix), 2.4 (auditor), 2.5 (checkpoint) | Sonnet Dev + Sonnet Auditor | 2-3 |
| 3 | 3.1 (version bumps), 3.2 (security review), 3.3 (user ckpt), 3.4 (push+PR), 3.5 (dual audit), 3.6 (merge+tag+release), 3.7 (save-phase) | Sonnet Dev + Opus security + Dual-Opus Template E + Opus release ops | 3-4 |

Total estimated: 8-11 dispatches.

**Required executor inputs (orchestrator reads before any dispatch):**

1. This plan file
2. `docs/superpowers/plans/v1.4.0-security-review.md` (source of the 2 minor items)
3. Prior retrospective `project_v140_released.md`
4. Both feedback memories cited in this plan: `feedback_plan_pattern_verification.md`, `feedback_external_api_verification.md`
5. `CLAUDE.md` (universal AskUserQuestion enforcement, memory management, session orchestration)
6. `docs/superpowers/release-process/release-process.md` (cross-cutting policy)
7. `power-engineer/references/modules/subagent-selector.md` (model-assignment decision table)

**Universal AskUserQuestion enforcement:** Every user-facing decision point in this plan uses the AskUserQuestion tool. Plain-text questions in orchestrator responses are forbidden per CLAUDE.md.

**Rollback authority:** Orchestrator MAY execute per-phase rollback only after dual-auditor rejection + user-approved AskUserQuestion. Full-release rollback (post-tag) ALWAYS requires explicit user authorization. Never force-push, never delete tags, never modify other branches without explicit authorization.

---

*End of v1.4.1 plan. Strict patch; 4 phases; ~8-11 subagent dispatches. The plan-template awk-range fix in Task 2.3 is the mandatory in-place dogfood defect fix — do NOT skip.*
