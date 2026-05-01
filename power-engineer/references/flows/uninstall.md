# Uninstall Flow

Remove a single installed skill from disk and from `.power-engineer/state.json`,
then regenerate configurator outputs so cheatsheet and CLAUDE.md stay in sync.

## Step 1 -- State check

```bash
cat .power-engineer/state.json 2>/dev/null
```

If no state exists, exit cleanly with:
"No power-engineer state found. Nothing to uninstall."

Do NOT fall through to setup -- uninstall has nothing to do without state.

## Step 2 -- Resolve skill argument

Parse the user's invocation. The argument is either:
- a bare name: `<name>` (e.g. `brainstorming`)
- a qualified name: `<name> (<repo>)` (e.g. `brainstorming (obra/superpowers)`)

### Validate the name

Reject path-traversal and shell-metacharacter attempts. The skill name MUST
match the regex:

```
^[a-z0-9][a-z0-9-]*$
```

If the name fails the regex, abort with:
"Invalid skill name '<input>'. Names must be lowercase, start with a letter
or digit, and contain only letters, digits, and hyphens."

No filesystem or state operations run on a rejected name.

### Filter installed_skills[]

Read `installed_skills[]` from `.power-engineer/state.json` and filter:
- bare name -- match entries whose `name` equals the argument
- qualified name -- match entries whose `name` AND `repo` both equal

### Branch on match count

**0 matches** -- check disk for an orphan directory at
`.claude/skills/<name>/` or `.agents/skills/<name>/`. If a directory exists
but no state entry references it, use AskUserQuestion:

```
AskUserQuestion:
  question: "No state entry for '<name>', but a directory exists at <path>. Delete it?"
  header: "Orphan"
  options:
    - label: "Delete orphan directory"
      description: "Remove <path> from disk. State.json is unchanged (no entry to remove)."
    - label: "Keep it"
      description: "Leave the directory in place and exit without changes."
  multiSelect: false
```

If no orphan directory is found, abort with:
"Skill '<name>' not found. Run `/power-engineer status` to see installed skills."

**1 match** -- proceed to Step 3 with the resolved entry.

**2+ matches (bare name only)** -- the user gave a name that is installed from
multiple repos. Use AskUserQuestion to disambiguate:

```
AskUserQuestion:
  question: "Multiple skills match '<name>'. Which one should I uninstall?"
  header: "Disambiguate"
  options:
    - label: "<name> (<repo-1>)"
      description: "Installed at <path-1>"
    - label: "<name> (<repo-2>)"
      description: "Installed at <path-2>"
    - label: "Cancel"
      description: "Exit without changes."
  multiSelect: false
```

Render one option per matching entry, plus a Cancel option.

## Step 3 -- Pre-removal checks

### Locate disk directory

The resolved entry tells you the install scope. Compute the directory path:
- project scope -- `.claude/skills/<name>/`
- user scope -- `.agents/skills/<name>/` (under `$HOME`)

### Detect stale state

If the state entry exists but the directory is missing on disk, use
AskUserQuestion:

```
AskUserQuestion:
  question: "State references '<name>' but the directory at <path> is gone. Drop the entry?"
  header: "Stale"
  options:
    - label: "Drop entry from state.json"
      description: "Remove the orphaned entry. No disk operation needed (already gone)."
    - label: "Keep entry"
      description: "Leave state.json unchanged and exit."
  multiSelect: false
```

If both entry and directory exist, proceed to Step 4.

## Step 4 -- Confirm + execute

### Confirm removal

Use AskUserQuestion to gate the destructive action:

```
AskUserQuestion:
  question: "Remove <name> (<repo>) from <path> and state.json?"
  header: "Confirm"
  options:
    - label: "Yes, uninstall"
      description: "Delete the skill directory and remove the state.json entry."
    - label: "Cancel"
      description: "Exit without changes."
  multiSelect: false
```

### Execute on Yes

Construct the deletion path from a known-safe prefix. Never pass raw user
input to `rm`. The path MUST be built by joining a fixed root with the
already-validated name from Step 2:

```bash
# Pick the known-safe root for the resolved scope:
#   project -> .claude/skills
#   user    -> "$HOME/.agents/skills"
SAFE_ROOT=".claude/skills"   # or "$HOME/.agents/skills" for user scope
SKILL_NAME="<validated-name>"  # already passed ^[a-z0-9][a-z0-9-]*$

TARGET="$SAFE_ROOT/$SKILL_NAME"

# Verify the constructed path still starts with the known-safe prefix
# (defense-in-depth -- regex already forbids slashes and dot-segments):
case "$TARGET" in
  "$SAFE_ROOT"/*) rm -rf -- "$TARGET" ;;
  *) echo "Refusing to delete: '$TARGET' is outside '$SAFE_ROOT'." >&2; exit 1 ;;
esac
```

If the directory delete fails (permissions, busy file, etc.):
- Roll back: leave `.power-engineer/state.json` untouched.
- Surface the error verbatim.
- Suggest manual cleanup of `<path>` and a re-run.
- Do NOT proceed to the state.json update or Step 5.

### Update state.json

On successful disk delete:
1. Remove the matching entry from `installed_skills[]`.
2. Touch the `updated` timestamp to the current ISO date.
3. Write `.power-engineer/state.json` atomically (write to a temp file in the
   same directory, then `mv` over the original).

If the state.json write fails after the disk delete succeeded, surface the
error and tell the user:
"Skill directory deleted, but state.json update failed. Re-run
`/power-engineer uninstall <name>` to clean the stale state entry."

## Step 5 -- Regenerate configurator outputs

Read `references/modules/configurator.md` and run the FULL configurator --
regenerate ALL outputs (CLAUDE.md managed section, cheatsheet,
project-context, brand, state.json scan_snapshot + updated timestamp,
handoff template, compaction hook, cross-tool configs).

The configurator's regeneration policy ensures the cheatsheet, CLAUDE.md
managed section, and any cross-tool configs are kept in sync with the now-
shorter `installed_skills[]` -- no file is silently skipped.

If configurator regeneration fails, the uninstall itself has already
succeeded (Steps 1-4 are committed). Surface the configurator error and
suggest:
"Skill removed successfully, but configurator regeneration failed. Run
`/power-engineer configure` to refresh CLAUDE.md and the cheatsheet."

Do NOT roll back the uninstall.

## Error handling

| Scenario | Behavior |
|---|---|
| No `state.json` | "No power-engineer state found. Nothing to uninstall." Exit cleanly. |
| Skill name not in state, no orphan dir | Error: "Skill '<name>' not found. Run `/power-engineer status` to see installed skills." |
| Disk delete fails (permissions / path issue) | Roll back: keep state.json entry intact. Surface error verbatim + suggest manual cleanup. |
| state.json write fails after disk delete | Surface error + recovery hint: "Skill dir deleted but state.json update failed; re-run uninstall to clean state." |
| Configurator regen fails (Step 5) | Skill is uninstalled (Steps 1-4 done); surface configurator error + suggest `/power-engineer configure`. Do NOT roll back the uninstall. |
| Path traversal attempt in skill name (e.g. `../foo`) | Reject at Step 2 regex validation. No FS or state ops. |
