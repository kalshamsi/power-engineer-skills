# Permissions Module

Manages Claude Code permission rules to enable batch skill installation
without per-command prompts. Two-step lifecycle: **Setup** before installs,
**Cleanup** after installs.

## Important rules

1. **Never overwrite** existing settings.json content -- always read-then-merge
2. **Narrow scope only** -- only whitelist `npx skills@latest` commands
3. **Always ask consent** before modifying permissions
4. **Track what was added** so cleanup can restore the original state

---

## Step 1: Setup (run BEFORE installation loop)

### 1.1 Check for existing rule

Read `.claude/settings.json` if it exists. If `Bash(npx skills@latest*)`
is already in `permissions.allow`, skip the rest of Step 1 and note:

```
Permission rule already present from a previous setup -- no changes needed.
```

### 1.2 Ask for consent

Use AskUserQuestion:

```
AskUserQuestion:
  question: "Installing [N] skills requires [N] bash commands. To avoid
    prompting you for each one, I can add a temporary permission rule to
    .claude/settings.json that auto-approves 'npx skills@latest' commands.
    This is narrowly scoped -- it won't auto-approve any other commands.
    Add the rule?"
  header: "Permissions"
  options:
    - label: "Yes, add the rule (Recommended)"
      description: "Adds Bash(npx skills@latest*) to .claude/settings.json -- installs run without prompts"
    - label: "No, I'll approve each one"
      description: "Skip -- you'll see a permission prompt for each skill install"
  multiSelect: false
```

If "No" -- skip the rest of Step 1. Installation proceeds with per-command
prompts. This is the graceful degradation path.

### 1.3 Patch .claude/settings.json

Three scenarios:

**A) `.claude/` directory does not exist:**

```bash
mkdir -p .claude
```

Then create `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(npx skills@latest*)",
      "Bash(mkdir -p .power-engineer)"
    ]
  }
}
```

Record: `settings_created = true`

**B) `.claude/` exists but `settings.json` does not:**

Create `.claude/settings.json` with the same JSON as scenario A.

Record: `settings_created = true`

**C) `.claude/settings.json` already exists:**

1. Read the file with the Read tool
2. Parse the JSON. If it is malformed, **warn the user and fall back to
   per-command prompts** -- do NOT attempt to fix it
3. Navigate to `permissions.allow`:
   - If `permissions` key missing: add `"permissions": { "allow": [...] }`
   - If `permissions` exists but `allow` missing: add `"allow": [...]`
   - If `permissions.allow` exists: append the two rules if not already present
4. Write the updated JSON (2-space indent), preserving all existing entries

Record: `settings_created = false`, `original_allow_list = [copy of allow array before modification]`

### 1.4 Install PreToolUse hook (fallback)

This is a belt-and-suspenders mechanism. If the settings.json patch has an
edge case, the hook still catches the commands.

**Create the hook script:**

Write `.claude/hooks/allow-skills-install.sh`:

```bash
#!/usr/bin/env bash
# Power Engineer: Auto-allow skills installation commands
# Reads tool input from stdin, outputs decision JSON.

INPUT=$(cat)

# Extract the command from the JSON input
# Input shape: {"tool_name":"Bash","tool_input":{"command":"..."}}
COMMAND=$(echo "$INPUT" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)

if echo "$COMMAND" | grep -qE '^npx skills@latest '; then
  echo '{"decision":"allow"}'
elif echo "$COMMAND" | grep -q '^mkdir -p \.power-engineer'; then
  echo '{"decision":"allow"}'
else
  echo '{}'
fi
```

Make it executable:

```bash
chmod +x .claude/hooks/allow-skills-install.sh
```

**Add hook config to settings.json:**

Merge into the existing settings.json a `hooks` entry:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [".claude/hooks/allow-skills-install.sh"]
      }
    ]
  }
}
```

If a `hooks.PreToolUse` array already exists, append the entry. If a Bash
matcher already exists, append the hook path to its `hooks` array.

---

## Step 2: Cleanup (run AFTER installation summary)

Skip this step entirely if Step 1 was skipped (user declined consent or
rule was already present).

### 2.1 Ask about keeping rules

```
AskUserQuestion:
  question: "Installation used a temporary permission rule to skip prompts.
    Keep it for future /power-engineer update runs, or remove it?"
  header: "Cleanup"
  options:
    - label: "Keep it (Recommended)"
      description: "Future skill installs/updates run without prompts. Rule: Bash(npx skills@latest*)"
    - label: "Remove it"
      description: "Tighter security -- future installs will prompt for each command"
  multiSelect: false
```

### 2.2 If "Remove it"

1. Read `.claude/settings.json`
2. Remove `Bash(npx skills@latest*)` and `Bash(mkdir -p .power-engineer)`
   from `permissions.allow`
3. Remove the PreToolUse hook entry for `allow-skills-install.sh`
4. Delete `.claude/hooks/allow-skills-install.sh`
5. If `.claude/hooks/` is now empty, remove the directory
6. If `settings_created = true` AND the file now has only the empty
   permissions structure we created, delete `.claude/settings.json`
7. Write the cleaned-up JSON back

### 2.3 If "Keep it"

Do nothing. The narrow rule stays for future runs.

---

## Edge cases

- **Malformed settings.json**: Warn user, fall back to per-command prompts
- **Read-only settings.json**: Warn user, fall back to per-command prompts
- **Partial installation (user cancels mid-way)**: Cleanup should still be
  offered if Step 1 was completed
- **Re-runs**: Detected in Step 1.1 -- skip consent if rule already present
