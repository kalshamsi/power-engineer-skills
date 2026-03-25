# Full Interview Flow

Run the complete 8-question questionnaire to build a tailored skill installation.

## Step 1 — Questionnaire

Ask these 8 questions **one at a time**, waiting for each answer before continuing.
Present each as a numbered list of options.

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

## Step 2 — Detect installed skills

Run these commands to see what is already installed:

```bash
ls ~/.claude/skills/ .claude/skills/ 2>/dev/null || echo "(none)"
```

Store the results as `INSTALLED_SKILLS`. Any skill already present will be
excluded from the generated script with a comment.

---

## Step 3 — Build skill lists

Read `references/DECISION_MATRIX.md` and map every questionnaire answer to
skill install commands.

Start with the "Always add — Core methodology" block (included for every
project), then layer on skills from Q1 through Q8. De-duplicate as you go.

Filter against `INSTALLED_SKILLS` from Step 2.

---

## Step 4 — Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
