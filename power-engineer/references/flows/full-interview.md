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
Pass the ProjectProfile from Step 1. Ask all 11 questions (skipping those
already answered by the scan). Receive a SkillPlan.

## Step 4 -- Resolve

Read `references/modules/skill-resolver.md` and follow its instructions.
Pass the SkillPlan from Step 3. Receive a deduplicated list of install
commands and plugin-based installs.

## Step 5 -- Present & confirm

Show the user the consolidated recommendation:
- Detected stack summary
- Recommended skills grouped by category
- Skills that will be skipped (already installed)
- Plugin-based installs (separate section)
- Ruflo recommendation if warranted (see Step 7)

Ask: "Ready to install? You can add, remove, or modify before proceeding."

Wait for confirmation.

## Step 6 -- Install

Read `references/modules/installer.md` and follow its instructions.
Execute all confirmed skill installations directly.

## Step 7 -- Ruflo evaluation

Read `references/modules/ruflo.md` and follow its instructions.
Check if the project warrants multi-agent orchestration. If recommended
and user confirms, install Ruflo via `npx ruflo@latest init`.

**Important:** Ruflo MUST run BEFORE the Configurator (Step 8) because
Ruflo creates its own CLAUDE.md and .claude/ contents. The Configurator
will then smart-merge power-engineer's section into Ruflo's CLAUDE.md.

## Step 8 -- Configure

Read `references/modules/configurator.md` and follow its instructions.
Generate/merge CLAUDE.md, create state directory, patch skills with
project context. If Ruflo was installed in Step 7, the Configurator will
merge into the CLAUDE.md that Ruflo created (not overwrite it).
