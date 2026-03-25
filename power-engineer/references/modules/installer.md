# Installer Module

Executes skill installations directly at runtime. No script generation --
skills are installed immediately via `npx skills@latest add`.

## Important rules

1. **Never use `--global`** -- all skills are installed locally to the project
2. **Always use `--skill` flag** -- never slash syntax for skill names
3. **Always use `-y` flag** -- non-interactive installation
4. **Continue on failure** -- if one skill fails, log it and continue with the rest

## Installation process

### 1. Present the plan first

Before installing anything, show the user the full list of skills that will
be installed, grouped by category:

```
Skills to install:

Core & Planning (20 skills):
  - brainstorming (obra/superpowers)
  - writing-plans (obra/superpowers)
  - ...

Framework - Next.js (5 skills):
  - next-best-practices (vercel-labs/next-skills)
  - ...

Design (7 skills):
  - frontend-design (anthropics/skills)
  - ...

Already installed (skipping):
  - skill-creator (anthropics/skills)
  - ...

Total: [N] to install, [N] already present (skipping)
```

Ask the user: **"Ready to install? You can also remove skills from the list first."**

Wait for confirmation before proceeding.

### 2. Execute installations

Run each install command one at a time. Show progress:

```
Installing skills... (1/45)
  -> brainstorming (obra/superpowers) ... done
  -> writing-plans (obra/superpowers) ... done
  -> test-driven-development (obra/superpowers) ... FAILED (logged)
  -> systematic-debugging (obra/superpowers) ... done
  ...
```

For each command, run:
```bash
npx skills@latest add <repo> --skill <name> -y
```

### 3. Handle failures

If a skill fails to install:
- Log the error message
- Add to the failures list
- Continue with the next skill
- Do NOT stop the entire installation

### 4. Save install log

After all installations complete, write the install log:

```bash
mkdir -p .power-engineer
```

Write `.power-engineer/install-log.sh` with this format:

```bash
#!/usr/bin/env bash
# Power Engineer Install Log
# Project: [directory name]
# Date: [today's date]
# Total: [N] installed, [N] failed, [N] skipped
#
# This file is a record of what was installed. It can be re-run to
# reproduce the installation.

# -- Successful installs --
npx skills@latest add obra/superpowers --skill brainstorming -y
npx skills@latest add obra/superpowers --skill writing-plans -y
# ... (all successful commands)

# -- Failed installs --
# npx skills@latest add [repo] --skill [name] -y  # ERROR: [error message]

# -- Skipped (already installed) --
# npx skills@latest add [repo] --skill [name] -y  # already present
```

### 5. Present summary

After installation completes:

```
Installation complete!

  Installed: [N] skills
  Failed:    [N] skills
  Skipped:   [N] skills (already present)

  Install log: .power-engineer/install-log.sh

[If failures:]
  Failed skills:
    - [skill-name]: [error message]
  You can retry these manually or run /power-engineer update later.
```

### 6. Plugin-based installs

If the SkillPlan includes plugin-based installs, present them separately
AFTER the npx installs complete:

```
Plugin-based skills (run these inside Claude Code):

  /plugin marketplace add alirezarezvani/claude-skills
  /plugin install engineering-skills@claude-code-skills

These require Claude Code's plugin system and can't be installed via npx.
```

Read `references/PLUGIN_INSTALLS_TEMPLATE.md` for the full plugin catalog format
if the user wants the complete reference.
