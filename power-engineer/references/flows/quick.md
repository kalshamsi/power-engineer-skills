# Quick Setup Flow

Auto-detect the project stack, ask only what can't be inferred, confirm with
the user, then install directly.

## Step 1 -- Scan

Read `references/modules/scanner.md` and follow its instructions to produce
a ProjectProfile.

## Step 2 -- Assess

If `is_rerun` is true: read `references/modules/drift-detector.md` instead.

## Step 3 -- Minimal interview

Read `references/modules/questionnaire.md` but ONLY ask questions that the
Scanner could not answer. In quick mode, also skip these questions and use
defaults:

- Q9 (Brand): default to "Not applicable" unless brand assets were detected
- Q10 (Team): default to "Solo developer" unless git log shows 2+ authors
- Q11 (Goals): default to "Ship features faster"

Present what was detected and the defaults. Ask: "Look right? Any changes?"

## Step 4 -- Resolve

Read `references/modules/skill-resolver.md`. Pass the SkillPlan.

## Step 5 -- Present & confirm

Show the skill list. Ask for confirmation.

## Step 6 -- Install

Read `references/modules/installer.md`. Execute installations.

## Step 7 -- Configure

Read `references/modules/configurator.md`. Set up project configuration.
