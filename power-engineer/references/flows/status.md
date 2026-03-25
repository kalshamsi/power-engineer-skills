# Status Flow

Show all currently installed skills with a clean summary. This flow does NOT
generate install scripts — it only reports what's installed.

## Detect installed skills

Run these commands:

```bash
ls ~/.claude/skills/ .claude/skills/ 2>/dev/null || echo "(none)"
```

## Present the results

Format the output as a clean summary:

```
========================================
 Power Engineer — Skill Status
========================================

Installed skills:
  - [skill-name-1]
  - [skill-name-2]
  - ...

========================================
 [N] skills installed
========================================
```

If nothing is installed, suggest running the full setup:

```
No skills installed yet.

To get started, run:
  /power-engineer        — full guided setup (8 questions)
  /power-engineer quick  — auto-detect your stack
```
