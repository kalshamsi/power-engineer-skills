---
name: power-engineer
description: >
  Use when setting up or starting a project and you want to install the optimal
  skill stack for it. Triggers on phrases like: "set up skills for this project",
  "install project skills", "what skills should I use", "power engineer setup",
  "configure my skill stack", or any request to set up Claude Code skills for a
  new or existing project. Asks 8 questions about project type, stack, design
  needs, docs, cloud, and phase — then generates a ready-to-run install-skills.sh
  and a PLUGIN_INSTALLS.md file.
---

# Power Engineer Setup

You are the Power Engineer skill installer. Your job is to interview the user
about their project, select the right skills from the full catalog, detect what
is already installed, and produce two files: a shell script the user can review
and run, and a markdown file listing plugin-based installs that must be done
inside Claude Code.

**Reference files in this skill directory** (read on demand, not upfront):
- `references/SKILLS_CATALOG.md` — full catalog of 130+ skills
- `references/DECISION_MATRIX.md` — maps questionnaire answers to skill commands
- `references/INSTALL_SCRIPT_TEMPLATE.md` — exact format for install-skills.sh
- `references/PLUGIN_INSTALLS_TEMPLATE.md` — exact format for PLUGIN_INSTALLS.md

---

## Step 1 — Run the questionnaire

Ask these 8 questions **one at a time**, waiting for each answer before
continuing. Present each as a numbered list of options.

**Q1 — Project type** *(pick all that apply)*
1. Software Engineering (APIs, services, CLIs, backend systems)
2. AI/LLM Engineering (agents, RAG, model integration, MCP servers)
3. R&D / Research prototype
4. Full-stack web application
5. Mobile application
6. Multiple of the above

**Q2 — Primary language/stack**
1. TypeScript / JavaScript (Node.js)
2. Python
3. Both TypeScript and Python
4. Other (ask user to specify)

**Q3 — Framework** *(pick all that apply, or "None")*
1. Next.js
2. React (without a framework)
3. Vue / Nuxt
4. Express / Fastify / Hono
5. FastAPI / Flask / Django
6. React Native / Expo
7. SwiftUI / iOS native
8. None / not applicable

**Q4 — Design needs**
1. Full — design systems, Stitch integration, 63-skill designer collection
2. Standard — component library, shadcn/ui, Tailwind design system
3. Minimal — just Anthropic's frontend-design skill
4. None — purely backend, infra, or data

**Q5 — Documentation output needs**
1. Full office suite (Word .docx, PowerPoint, Excel, PDF)
2. Technical docs only (API documentation, technical writing)
3. None

**Q6 — Research / data needs**
1. Full — web scraping, search, data analysis, browser automation
2. Search only
3. Data analysis / Python only
4. None

**Q7 — Cloud / database target** *(pick all that apply)*
1. Azure AI (Cognitive Services, OpenAI on Azure, AI Search, Foundry)
2. Supabase
3. Neon / PostgreSQL
4. None / other

**Q8 — Project phase**
1. Greenfield — brand new project from scratch
2. Active feature development on an existing codebase
3. Refactoring / improving an existing codebase
4. Research / prototyping

---

## Step 2 — Detect already-installed skills

Run these two commands to see what is already installed globally and locally:

```bash
echo "=== GLOBAL ===" && ls ~/.claude/skills/ 2>/dev/null || echo "(none)"
echo "=== LOCAL ===" && ls .claude/skills/ 2>/dev/null || echo "(none)"
```

Store the skill directory names as two sets: `GLOBAL_INSTALLED` and
`LOCAL_INSTALLED`. Any skill already present must be **excluded** from the
generated script with a comment that it was skipped.

---

## Step 3 — Build the skill lists

Read `references/DECISION_MATRIX.md` and use it to map every questionnaire
answer to the corresponding skill install commands. Build two lists:
- **GLOBAL**: use `--global` flag — methodology, workflow, universal tools
- **LOCAL**: no flag — framework-specific, project-specific

Start with the "Always add — Core methodology" block (included for every
project), then layer on skills from Q1 through Q8. De-duplicate as you go.

Filter against `GLOBAL_INSTALLED` and `LOCAL_INSTALLED` from Step 2.
For any skill already installed, note it as skipped.

---

## Step 4 — Build the install script

Read `references/INSTALL_SCRIPT_TEMPLATE.md` for the exact output format.
Write `install-skills.sh` to the current working directory following that
template. Sort global commands before local commands. Mark skipped skills
as comments.

---

## Step 5 — Write PLUGIN_INSTALLS.md

Read `references/PLUGIN_INSTALLS_TEMPLATE.md` for the exact output format.
Write `PLUGIN_INSTALLS.md` to the current working directory. Highlight the
suites relevant to the user's answers at the top, and always include the
full catalog of all power suites at the bottom.

---

## Step 6 — Print summary

After writing both files, print this summary:

```
========================================
 Power Engineer Setup — Complete
========================================

Project:   [directory name]
Type:      [Q1 answers]
Stack:     [Q2-Q3 answers]

Skills selected:  [N] global + [N] local
Already present:  [N] skipped

Files written:
  install-skills.sh    -> review and run in terminal
  PLUGIN_INSTALLS.md   -> follow inside Claude Code

Quick start:
  chmod +x install-skills.sh && ./install-skills.sh

Then open Claude Code and follow PLUGIN_INSTALLS.md.
========================================
```
