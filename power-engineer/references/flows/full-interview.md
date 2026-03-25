# Full Interview Flow

The complete power-engineer setup. Scans the project, asks adaptive questions,
installs skills directly, and configures the project.

## Step 1 -- Scan

Read `references/modules/scanner.md` and follow its instructions to produce
a ProjectProfile.

## Step 2 -- Assess

Check the ProjectProfile:
- If `is_rerun` is true: read `references/modules/drift-detector.md` instead
  of continuing this flow. The Drift Detector handles re-runs.
- If the project is blank/empty (no package.json, no source files): proceed
  to Step 3 with full questionnaire (nothing to skip).
- Otherwise: proceed to Step 3 with adaptive questionnaire.

## Step 3 -- Interview

Read `references/modules/questionnaire.md` and follow its instructions.
Pass the ProjectProfile from Step 1. Use the `AskUserQuestion` tool for every
question — never ask as plain text. Batch questions thematically (2-3 per call).
Receive a SkillPlan.

## Step 4 -- Resolve

Read `references/modules/skill-resolver.md` and follow its instructions.
Pass the SkillPlan from Step 3. Receive a deduplicated list of install
commands and plugin-based installs.

## Step 5 -- Present & confirm

Show the user the consolidated recommendation as plain text:
- Detected stack summary
- Recommended skills grouped by category
- Skills that will be skipped (already installed)
- Plugin-based installs (separate section)

Then use AskUserQuestion to confirm (the installer module handles this —
see `references/modules/installer.md` Step 1).

## Step 6 -- Install

Read `references/modules/installer.md` and follow its instructions.
Execute all confirmed skill installations directly.

## Step 7 -- Configure

Read `references/modules/configurator.md` and follow its instructions.
Generate/merge CLAUDE.md, create state directory, patch skills with
project context.
