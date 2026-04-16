# Migration Guide

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
