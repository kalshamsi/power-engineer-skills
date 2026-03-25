# Status Flow

Show current project setup status. Read-only -- does not install anything.

## Step 1 -- Check for state

```bash
cat .power-engineer/state.json 2>/dev/null
```

### If state exists

Read `.power-engineer/state.json` and present:

```
========================================
 Power Engineer -- Project Status
========================================

Project:     [name]
Last setup:  [updated date]
Stack:       [language] + [framework]

Installed skills ([N] total):

  Core & Planning:
    - brainstorming (obra/superpowers)
    - writing-plans (obra/superpowers)
    - ...

  [Category]:
    - [skill] ([repo])
    - ...

Brand:       [configured | not configured]
CLAUDE.md:   [managed section present | not present]
Ruflo:       [installed via npx | not installed]

========================================
```

Then run a quick drift check: read `references/modules/drift-detector.md`
in read-only mode (detect changes but don't offer to fix them). Show any
detected drift at the bottom:

```
Changes detected since last setup:
  - 3 new dependencies added to package.json
  - Docker configuration added
  - 1 skill manually removed

Run /power-engineer update to reconcile.
```

### If no state exists

```
No power-engineer state found.

To get started, run:
  /power-engineer        -- full guided setup
  /power-engineer quick  -- auto-detect your stack
```
