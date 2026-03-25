# Update Flow

Detect changes since last setup and install new/updated skills.

## Step 1 -- Check for state

```bash
cat .power-engineer/state.json 2>/dev/null
```

If no state exists, redirect to full interview:
"No previous setup found. Running full setup instead."
Then read `references/flows/full-interview.md`.

## Step 2 -- Drift detection

Read `references/modules/drift-detector.md` and follow its instructions.
Present the drift report to the user.

## Step 3 -- Resolve new skills

If drift detection found changes that warrant new skills (new dependencies,
new config files, structural changes):

Read `references/modules/skill-resolver.md` with updated SkillPlan.
Include ONLY new skills not already in state.json.

## Step 4 -- Present & confirm

Show the reconciliation plan:
- What changed in the project
- New skills recommended
- Skills to keep as-is
- Any skills the user might want to remove

Ask for confirmation.

## Step 5 -- Install new skills

Read `references/modules/installer.md`. Install only the new skills.

## Step 6 -- Update configuration

Read `references/modules/configurator.md`. Update state.json, refresh
CLAUDE.md managed section, re-patch skills with updated project context.
