# power-engineer-skills

A global Claude Code skill that interviews you about your project and generates
a complete, ready-to-run skill installation script tailored to your stack,
discipline, and goals.

Built for software engineers, AI engineers, and R&D engineers.
150+ skills catalogued across every major category.

---

## What it does

Run it once at the start of any project. It asks you 8 questions:

1. Project type (SWE, AI/LLM, R&D, full-stack, mobile)
2. Primary language/stack
3. Framework
4. Design needs
5. Documentation needs
6. Research/data needs
7. Cloud/database target
8. Project phase

Based on your answers it:

- Detects which skills are already installed globally and locally
- Selects the right skills from 150+ catalogued options
- Generates `install-skills.sh` — a shell script you review and run
- Generates `PLUGIN_INSTALLS.md` — plugin-based installs to do inside Claude Code
- Skips anything already installed

---

## Install

```bash
npx skills@latest add kalshamsi/power-engineer-skills/power-engineer --global
```

Works with Claude Code, Codex, Cursor, Gemini CLI, and 8+ other agents.

---

## Use it

Open Claude Code in any project directory and say:

> "Set up skills for this project"

or:

> "/power-engineer"

Claude will run the questionnaire, detect your existing skills, and write the
two output files to your project root.

### Targeted commands

You can also skip the full interview and go straight to a specific category:

| Say this | What it does |
|----------|-------------|
| `power engineer quick` | Auto-detect stack, minimal questions |
| `power engineer frontend` | Install frontend/design skills |
| `power engineer backend` | Install backend/API/DB skills |
| `power engineer devops` | Install DevOps/infra skills |
| `power engineer ai` | Install AI/LLM/agentic skills |
| `power engineer data` | Install data/ML/science skills |
| `power engineer docs` | Install documentation skills |
| `power engineer mobile` | Install mobile skills |
| `power engineer status` | Show installed skills |
| `power engineer catalog` | Browse catalog interactively |
| `power engineer update` | Find new skills since last setup |

### After setup

```bash
# Review the script
cat install-skills.sh

# Make it executable and run
chmod +x install-skills.sh && ./install-skills.sh

# Then open Claude Code and follow
cat PLUGIN_INSTALLS.md
```

---

## Repository structure

```
power-engineer-skills/
├── README.md                                  ← you are here
└── power-engineer/                            ← the skill directory
    ├── SKILL.md                               ← thin router (~46 lines)
    └── references/
        ├── flows/                             ← progressive disclosure (loaded on demand)
        │   ├── full-interview.md              ← 8-question questionnaire
        │   ├── frontend.md                    ← framework + design flow
        │   ├── backend.md                     ← stack + database flow
        │   ├── devops.md                      ← DevOps/infra flow
        │   ├── ai.md                          ← AI/LLM/agentic flow
        │   ├── data.md                        ← data/ML flow
        │   ├── docs.md                        ← documentation flow
        │   ├── mobile.md                      ← mobile flow
        │   ├── quick.md                       ← auto-detect flow
        │   ├── status.md                      ← show installed skills
        │   ├── catalog-browse.md              ← interactive catalog
        │   └── update.md                      ← find new skills
        ├── shared/
        │   └── output-steps.md                ← install script + summary generation
        ├── catalog/                           ← skills catalog (split by category)
        │   ├── INDEX.md                       ← lightweight TOC
        │   ├── core-methodology.md            ← obra, mattpocock, github
        │   ├── anthropic-official.md          ← anthropic skills, meta
        │   ├── engineering/
        │   │   ├── backend-architecture.md
        │   │   ├── devops-infra.md
        │   │   ├── data-ml.md
        │   │   ├── testing-quality.md
        │   │   ├── agentic-ai.md
        │   │   └── security-ops.md
        │   ├── frontend/
        │   │   ├── react-next.md
        │   │   ├── vue-vite.md
        │   │   ├── design-systems.md
        │   │   └── mobile.md
        │   ├── cloud/
        │   │   ├── azure.md
        │   │   └── databases.md
        │   ├── docs-research.md
        │   └── power-suites.md
        ├── DECISION_MATRIX.md                 ← full matrix (used by interview/quick/update)
        ├── INSTALL_SCRIPT_TEMPLATE.md         ← install-skills.sh format
        └── PLUGIN_INSTALLS_TEMPLATE.md        ← PLUGIN_INSTALLS.md format
```

---

## Skills catalog

Browse the catalog by category in [power-engineer/references/catalog/](./power-engineer/references/catalog/).
Start with [INDEX.md](./power-engineer/references/catalog/INDEX.md) for an overview.

### Categories

| Category | Sub-categories |
|----------|---------------|
| **Core & Planning** | obra/superpowers, mattpocock planning, GitHub copilot |
| **Anthropic Official** | Document generation, design, skill creation |
| **Engineering** | Backend, DevOps/Infra, Data/ML, Testing, Agentic AI, Security |
| **Frontend & Design** | React/Next.js, Vue/Vite, Design systems, Mobile |
| **Cloud & Databases** | Microsoft Azure, Neon, Supabase |
| **Docs & Research** | Technical writing, web research, data analysis |
| **Power Suites** | GSD, Superpowers, UI/UX Pro Max, Designer Skills, Stitch, Pencil |

---

## Power suites

Some skill collections install via special methods rather than `npx skills add`.
The setup skill generates a `PLUGIN_INSTALLS.md` listing which ones are relevant
for your project and how to install them.

| Suite | Install method | Description |
|-------|---------------|-------------|
| **GSD** | `npx get-shit-done-cc --claude --global` | Context engineering: questionnaire, SPEC, phased execution, verification |
| **Superpowers** | `/plugin install superpowers@superpowers-marketplace` | Auto-triggering dev methodology: brainstorm, TDD, verify |
| **UI/UX Pro Max** | `/plugin install ui-ux-pro-max@ui-ux-pro-max-skill` | 97 palettes, 57 font pairings, 99 UX guidelines, 9 stacks |
| **Designer Skills** | `/plugin marketplace add Owl-Listener/designer-skills` | 63 skills + 27 commands across 8 design disciplines |
| **Google Stitch** | `npx skills add google-labs-code/stitch-skills --all --global` | Text/sketch to high-fidelity UI to React/Tailwind |
| **Pencil** | Built-in | Native `.pen` file editor in VS Code |

---

## Contributing

PRs welcome. If you find a skill worth adding to the catalog, open an issue or
submit a PR updating the relevant file in `power-engineer/references/catalog/`
and the corresponding section in `power-engineer/references/DECISION_MATRIX.md`.

Please include:
- Skill name and source repo
- Verified install command
- Recommended scope (global/local)
- One-line description

---

## License

MIT
