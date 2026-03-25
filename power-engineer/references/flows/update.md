# Update Flow

Re-scan the project and install any new skills from the catalog that aren't
already installed. Skips everything already present.

## Step 1 — Detect installed skills

```bash
echo "=== GLOBAL ===" && ls ~/.claude/skills/ 2>/dev/null || echo "(none)"
echo "=== LOCAL ===" && ls .claude/skills/ 2>/dev/null || echo "(none)"
```

## Step 2 — Find new skills

Read `references/DECISION_MATRIX.md` to get the full list of available skills.
Compare against what's installed. Build a list of skills that are in the
catalog but NOT currently installed.

## Step 3 — Present new skills

Present the new (not-yet-installed) skills to the user, grouped by category:

```
========================================
 Power Engineer — Available Updates
========================================

New skills available since last setup:

Core & Planning:
  - [skill-name] — [one-line description]

Engineering:
  - [skill-name] — [one-line description]

[... more categories ...]

Total: [N] new skills available
========================================
```

Ask the user which ones they'd like to install, or offer to install all.

## Step 4 — Generate output

If the user wants to install any new skills, read `references/shared/output-steps.md`
and follow its instructions to generate the install script for just the new
skills, along with PLUGIN_INSTALLS.md and the final summary.
