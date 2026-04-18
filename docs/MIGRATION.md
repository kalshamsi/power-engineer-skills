# Migration Guide

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

An empty file means no failures have been recorded. A non-empty file means at least one prior hook invocation encountered a failure (mkdir, write, etc.); the v1.4.1 stderr warning at hook start surfaces this automatically, but occasional manual inspection is a useful belt-and-suspenders habit for production projects.

### Rollback
To roll back to v1.4.0:

```bash
git revert <v1.4.1-release-commit>
# or selectively
git checkout v1.4.0 -- power-engineer/scripts/hooks/
```

No state cleanup required — v1.4.1 hook output files interleave cleanly with v1.4.0 output files (filename prefix unchanged; only the suffix adds `-$$`).

## v1.3.0 → v1.4.0

**TL;DR:** All additive. Your existing skills + state continue to work. Re-run `/power-engineer configure` to enable new hooks and set your subagent-model preference.

### What changed
1. **Subagent-selector module.** New module under `power-engineer/references/modules/subagent-selector.md` with 3-axis decision table for model selection. Controlled via new `state.json.preferences.subagent_model_mode` (default: `selector`).
2. **3-tier memory architecture.** New SessionEnd + PreCompact hooks auto-save context at session-end and pre-compaction. New `/power-engineer save-phase` slash command for explicit phase ceremony. All three tiers degrade gracefully on failure.
3. **`.catalog-version` mechanism.** New file at `power-engineer/.catalog-version`. CI enforces bump when catalog changes.
4. **CHANGELOG `### Catalog` convention.** Starting from v1.3.0 retroactively, every release entry documents catalog deltas in a structured subhead. External curation workflows consume this as a stable API.
5. **Release-process framework.** Maintainer-only templates under `docs/superpowers/release-process/`. Not installed with the skill.
6. **7 new catalog rows + 1 rename.** 6 new `tavily-*` sub-skills + `stitch-design` now individually catalogued; the legacy `search` row (in docs-research.md + data-ml.md) is renamed to `tavily-search` with a corrected install command.

### What users must do
Nothing required. All changes additive.

### Optional
Re-run `/power-engineer configure` to register the new SessionEnd + PreCompact hooks + set your `subagent_model_mode` preference:

```bash
/power-engineer configure
```

### Rollback
To roll back to v1.3.0:

```bash
git revert <v1.4.0-release-commit>
# or
git checkout v1.3.0 -- power-engineer/ tests/ docs/CONTRIBUTING.md CHANGELOG.md
```

## v1.2.0 → v1.3.0

**TL;DR:** Your installed skills continue to work. First v1.3.0 run shows
a one-time notice about the new version-pin system. Nothing breaks.

### What changed

1. **`skills` CLI version is now pinned.** Before, catalog entries used
   `npx skills@latest add`. Now they use bare `npx skills add` and the
   installer injects the version from `power-engineer/.skills-cli-version`.
2. **Test suite rewritten.** `tests/integration/` replaced by
   `tests/lint/` + `tests/fixtures/`. Only matters if you contribute.
3. **Hooks fixes (two).** Both cause a Settings Error on launch until resolved:
   - Post-compaction hook moved from invalid `PostToolUse` matcher to
     `SessionStart` matcher `"compact"` (in
     `power-engineer/references/modules/configurator.md`). `PostToolUse`
     matchers filter by tool name, so `"compact"` never fired.
   - `PreToolUse` permissions hook corrected from flat array-of-strings to
     the nested `{type, command}` object schema Claude Code requires
     (in `power-engineer/references/modules/permissions.md`).

   New installs get the correct schema. Existing users should re-run
   `/power-engineer configure` to regenerate `.claude/settings.json`.

### What users must do

Nothing required. On first `/power-engineer` run after upgrade, you'll see:

> Power Engineer now pins the `skills` CLI to `1.5.0` for reproducibility.
> Your existing skills were installed against a compatible version — nothing
> changes today. Continue?

Click "Continue" to proceed. The chosen pin is recorded in
`.power-engineer/state.json` under `preferences.skills_cli_version`, so
the prompt only appears once.

### Optional: re-run configure to get the corrected hooks

If you installed skills under v1.2.0 (released 2026-03-28) before upgrading
to v1.3.0 (released 2026-04-16), your `.claude/settings.json` may contain
one or both of:

- A `PostToolUse` hook with matcher `"compact"` that never fires.
- A `PreToolUse` permissions hook in the flat `"hooks": ["<cmd>", ...]`
  shape that triggers a Settings Error on launch.

Fix both by regenerating the managed section:

```bash
/power-engineer configure
```

This rewrites `.claude/settings.json` with the correct `SessionStart` hook
and the nested `PreToolUse` `{type, command}` schema.

### Rollback to v1.2.0

```bash
git revert v1.3.0
# or (discard the upgrade entirely)
git checkout v1.2.0 -- power-engineer/ tests/ scripts/
```

If you prefer a specific commit SHA, `git log --oneline v1.2.0..v1.3.0 | tail -1`
gives you the first v1.3.0 commit to revert from.

Catalog entries will re-acquire `@latest` pinning. Behavior returns to
pre-upgrade state.
