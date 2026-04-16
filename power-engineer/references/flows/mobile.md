# Mobile Flow

Install mobile development skills. Scans for Expo/React Native or SwiftUI.

## Step 1 -- Scan

Read `references/modules/scanner.md`. Pay attention to:
- app.json / expo in package.json
- *.xcodeproj / Package.swift

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

Ask only:
- Q3 Framework: specifically mobile frameworks (if not detected)
  - React Native / Expo
  - SwiftUI / iOS native
- Q4 Design needs (always ask)

Defaults:
- Q1: "Mobile application"
- Q2: from scanner
- Q5-Q8: from scanner or "None"

## Step 3 -- Resolve

Read `references/modules/skill-resolver.md`. Include:
- Core methodology
- Mobile framework skills (React Native/Expo or SwiftUI)
- Design skills (from Q4)

## Step 4 -- Install

Read `references/modules/installer.md`. Execute installations.

## Step 5 -- Configure

Read `references/modules/configurator.md`. Configure project.
