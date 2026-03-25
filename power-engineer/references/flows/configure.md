# Configure Flow

Manage Power Engineer preferences.

## Step 1: Check for setup

Check if `.power-engineer/state.json` exists.

If it does not exist, respond with:
> No Power Engineer setup found. Run `/power-engineer` first to configure preferences.

Then stop.

## Step 2: Read current preferences

Read `.power-engineer/state.json`. Look for the `preferences` object.

If no `preferences` object exists, use defaults:
- `security_level`: Map from `questionnaire_answers` if available, otherwise `"standard"`
- `auto_update`: `true`

## Step 3: Present current settings

Use AskUserQuestion to show current preferences and allow changes.

### Security Level

```
AskUserQuestion:
  question: "Current security level: [current]. Change to:"
  header: "Security Level"
  options:
    - label: "Standard"
      description: "Core security review + OWASP + secrets detection"
    - label: "Enhanced"
      description: "Standard + headers audit, crypto audit, API security"
    - label: "Maximum"
      description: "Enhanced + Bandit SAST, Socket SCA, Docker Scout, test generator, DevSecOps pipeline"
    - label: "Compliance"
      description: "Maximum + PCI-DSS audit, mobile security (all 10 new security skills)"
    - label: "Custom"
      description: "Cherry-pick from all available security skills"
    - label: "Keep current"
      description: "No change"
  multiSelect: false
```

### Auto-Update

```
AskUserQuestion:
  question: "Auto-update (drift detection on every /power-engineer command):"
  header: "Auto-Update"
  options:
    - label: "Enabled (recommended)"
      description: "Automatically check for project drift before each run"
    - label: "Disabled"
      description: "Only check drift when you explicitly run /power-engineer update"
  multiSelect: false
```

## Step 4: Validate and save

Validate `security_level` is one of: standard, enhanced, maximum, compliance, custom.

Write the updated preferences to state.json:

```json
"preferences": {
  "security_level": "[selected level]",
  "auto_update": true|false
}
```

## Step 5: Confirm

Show the user:
```
Preferences updated:
  Security level: [level]
  Auto-update: [enabled|disabled]
```
