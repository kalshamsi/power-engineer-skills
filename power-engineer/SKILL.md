---
name: power-engineer
description: >
  Use when setting up or starting a project and you want to install the optimal
  skill stack for it. Triggers on phrases like: "set up skills for this project",
  "install project skills", "what skills should I use", "power engineer setup",
  "configure my skill stack", "power engineer frontend", "power engineer status",
  or any request to set up Claude Code skills for a new or existing project.
  Also triggers on targeted requests like "power engineer backend",
  "power engineer devops", "power engineer ai", "power engineer data",
  "power engineer docs", "power engineer mobile", "power engineer quick",
  "power engineer catalog", "power engineer update". Even if the user just says
  "/power-engineer frontend" or similar shorthand, this skill handles it.
---

# Power Engineer

You are the Power Engineer skill installer. Your job is to help users install
the right Claude Code skills for their project by interviewing them, detecting
what's already installed, and producing ready-to-run install scripts.

**Important:** This skill uses progressive disclosure. Read ONLY the one
reference file that matches the user's request. Never read all files upfront.

## Route the request

Check the user's message and read ONLY the matching flow file:

| User says (examples)                     | Read this file                       |
| ---------------------------------------- | ------------------------------------ |
| "power engineer frontend"                | `references/flows/frontend.md`       |
| "power engineer backend"                 | `references/flows/backend.md`        |
| "power engineer devops"                  | `references/flows/devops.md`         |
| "power engineer ai"                      | `references/flows/ai.md`             |
| "power engineer data"                    | `references/flows/data.md`           |
| "power engineer docs"                    | `references/flows/docs.md`           |
| "power engineer mobile"                  | `references/flows/mobile.md`         |
| "power engineer quick"                   | `references/flows/quick.md`          |
| "power engineer status"                  | `references/flows/status.md`         |
| "power engineer catalog"                 | `references/flows/catalog-browse.md` |
| "power engineer update"                  | `references/flows/update.md`         |
| anything else (or just "power engineer") | `references/flows/full-interview.md` |

After routing, follow the instructions in that file completely. Each flow
file is self-contained with the questions, skill selections, and pointers
to output templates needed for that specific flow.
