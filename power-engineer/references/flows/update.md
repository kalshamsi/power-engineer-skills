# Update Flow

Detect changes since last setup and install new/updated skills.

## Step 1 -- Check for state

```bash
cat .power-engineer/state.json 2>/dev/null
```

If no state exists, redirect to full interview:
"No previous setup found. Running full setup instead."
Then read `references/flows/full-interview.md`.

## Step 2 -- Skill health check

Before detecting drift, verify the integrity of all installed skills.

1. Read `.power-engineer/state.json` and extract the `installed_skills` array
2. For each skill, check:
   - Directory exists on disk: `.claude/skills/[name]/` OR `.agents/skills/[name]/`
   - `SKILL.md` is present and non-empty within the directory
3. Also scan skill directories on disk for skills NOT in state.json (orphaned)
4. Classify each skill:
   - **Healthy**: Directory exists, SKILL.md present and non-empty
   - **Missing**: In state.json but directory not found on disk
   - **Broken**: Directory exists but SKILL.md missing or empty
   - **Orphaned**: Directory exists on disk but not listed in state.json

5. Present the health check report:

```
Skill Health Check: [healthy]/[total] healthy
```

If any issues found, add:
```
⚠ Missing ([count]): [skill-names]
⚠ Broken ([count]): [skill-names] — SKILL.md is empty/missing
ℹ Orphaned ([count]): [skill-names] — on disk but not in state.json
```

6. If missing or broken skills exist, use AskUserQuestion:

```
AskUserQuestion:
  question: "Some installed skills have issues. How should I handle them?"
  header: "Health"
  options:
    - label: "Reinstall broken/missing skills"
      description: "Re-run the install commands for skills that are missing or broken"
    - label: "Remove from state"
      description: "Remove broken/missing entries from state.json and continue"
    - label: "Skip for now"
      description: "Continue with the update, ignore the issues"
  multiSelect: false
```

7. If orphaned skills exist, use AskUserQuestion:

```
AskUserQuestion:
  question: "Found skills on disk that aren't tracked in state.json. Add them?"
  header: "Orphaned"
  options:
    - label: "Add to state.json"
      description: "Track these skills in state so they appear in cheatsheet and future health checks"
    - label: "Ignore"
      description: "Leave them untracked"
  multiSelect: false
```

## Step 3 -- Drift detection

Read `references/modules/drift-detector.md` and follow its instructions.
Present the drift report to the user.

## Step 4 -- Resolve new skills

If drift detection found changes that warrant new skills (new dependencies,
new config files, structural changes):

Read `references/modules/skill-resolver.md` with updated SkillPlan.
Include ONLY new skills not already in state.json.

## Step 5 -- Present & confirm

Show the reconciliation plan as plain text:
- What changed in the project
- New skills recommended
- Skills to keep as-is
- Any skills the user might want to remove

Then use AskUserQuestion to confirm:

```
AskUserQuestion:
  question: "Ready to install the new skills recommended above?"
  header: "Update"
  options:
    - label: "Install all new skills"
      description: "Proceed with the recommended additions"
    - label: "Let me pick"
      description: "I want to select which new skills to install"
    - label: "Skip for now"
      description: "Don't install anything, just keep the drift report"
  multiSelect: false
```

## Step 6 -- Install new skills

Read `references/modules/installer.md`. Install only the new skills.

## Step 7 -- Update configuration

Read `references/modules/configurator.md`. Run the FULL configurator —
regenerate ALL outputs (CLAUDE.md managed section, cheatsheet, project-context,
brand, state.json, handoff template, compaction hook, cross-tool configs).
The configurator's regeneration policy ensures no file is silently skipped.
