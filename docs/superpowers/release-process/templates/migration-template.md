<!-- Replace <OLD.VER>, <NEW.VER>, <release-commit>, and bracketed placeholders before committing. -->

## v<OLD.VER> → v<NEW.VER>

**TL;DR:** <one-sentence summary>.

### What changed
1. <change 1>
2. <change 2>

### What users must do
<required actions, or "nothing">

### Optional
Optional steps users may run to take advantage of new features. If this
release adds a new hook, slash command, or preference, document the
command to enable it here. Omit the section body and write "None." if the
release has no optional follow-ups.

### Rollback
Commands to revert to the previous version. Typically `git revert
<release-commit>`, `git checkout v<OLD.VER> -- <paths>`, or a per-file
selective revert. Name the previous version explicitly in this body so
users grepping for "v<OLD.VER>" find the rollback path.

```bash
git revert <release-commit>
# or
git checkout v<OLD.VER> -- <paths>
```
