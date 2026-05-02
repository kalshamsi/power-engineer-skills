<!-- Replace <OLD.VER>, <NEW.VER>, <release-commit>, and bracketed placeholders before committing. -->
<!--
  STRUCTURE NOTES (v1.4.2+):
  - This 4-section structure applies to additive releases (the common case).
  - For BREAKING-CHANGE releases, RESTORE a `### Rollback` section after
    `### Compatibility notes` with concrete revert commands (typically
    `git revert <release-commit>` or per-file `git checkout v<OLD.VER> -- <paths>`).
  - Prior entries (v1.3.0→v1.4.0, v1.4.0→v1.4.1) follow the OLD 4-section
    template (`### What changed` / `### What users must do` / `### Optional`
    / `### Rollback`). Preserved as historical drift; do NOT retroactively
    rewrite.
-->

## v<OLD.VER> → v<NEW.VER>

**Status:** <Additive | Breaking | Mixed>. <one-sentence summary>.

### What changed (user-visible)

- <user-facing change 1>
- <user-facing change 2>

### What changed (maintainer-visible)

- <maintainer-facing change 1>
- <maintainer-facing change 2>

### Required actions

- <required action, or "None. All changes are additive.">
- Optional: <optional follow-up action, or omit if none>

### Compatibility notes

- <version-state change 1, e.g., `.catalog-version` advanced X → Y>
- <preserved invariant 1, e.g., CI job name preserved>
