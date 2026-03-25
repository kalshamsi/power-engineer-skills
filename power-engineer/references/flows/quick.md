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

Present what was detected and the defaults as plain text, then confirm with
AskUserQuestion:

```
AskUserQuestion:
  question: "I've auto-detected your stack and applied smart defaults. Look right?"
  header: "Quick"
  options:
    - label: "Looks good, proceed"
      description: "Use these settings and install skills"
    - label: "Adjust settings"
      description: "I want to change some of the detected values or defaults"
  multiSelect: false
```

If "Adjust settings", fall back to the full questionnaire for unanswered questions.

## Step 4 -- Resolve

Read `references/modules/skill-resolver.md`. Pass the SkillPlan.

## Step 5 -- Present & confirm

Show the skill list. The installer module handles confirmation via
AskUserQuestion (see `references/modules/installer.md` Step 1).

## Step 6 -- Install

Read `references/modules/installer.md`. Execute installations.

## Step 7 -- Configure

Read `references/modules/configurator.md`. Set up project configuration.
