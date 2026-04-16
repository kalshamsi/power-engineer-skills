# Frontend Flow

Install frontend and design skills. Scans the project first, then asks only
frontend-relevant questions.

## Step 1 -- Scan

Read `references/modules/scanner.md` and follow its instructions.

### Pre-install: version-pin migration notice (v1.3.0+ only)

If state.json exists and `skills_cli_version` is NOT recorded in it:

1. Use AskUserQuestion to show a one-time migration notice:

   Question: "Power Engineer now pins the `skills` CLI to `<pin>` for reproducibility. Your existing skills were installed against a compatible version — nothing changes today. Continue?"
   Header: "Version pin"
   Options:
     - "Continue (Recommended)" — proceed with installation using the pin
     - "Learn more" — display a one-paragraph explainer then continue
     - "Cancel" — exit without changes

2. On "Continue", add `"skills_cli_version": "<pin>"` to state.json's preferences block.
3. On subsequent runs, if state.json `skills_cli_version` differs from `.skills-cli-version`, ask:
   "CLI pin changed from <old> → <new>. Reinstall skills with the new pinned version?"
   Options: "Yes, reinstall" · "No, keep current installs" · "Cancel"

## Step 2 -- Targeted interview

Read `references/modules/questionnaire.md` but ONLY ask these questions
(skip all others, use scan defaults or "None"):

- Q3 Framework (if not detected by scanner)
- Q4 Design needs (always ask)
- SDK follow-up: "Are you using Vercel AI SDK, Anthropic Python SDK, or Anthropic JS/TS SDK?"

For all other questions, use these defaults:
- Q1: "Full-stack web application"
- Q2: from scanner (or "TypeScript")
- Q5-Q8: "None" / skip

## Step 3 -- Resolve

Read `references/modules/skill-resolver.md`. The Resolver will include:
- Core methodology (always)
- Framework skills (from Q3)
- Design skills (from Q4)
- SDK skills (from follow-up)

## Step 4 -- Install

Read `references/modules/installer.md`. Execute installations.

## Step 5 -- Configure

Read `references/modules/configurator.md`. Configure project.
