# power-engineer-skills

An intelligent Claude Code skill that scans your codebase, conducts an adaptive interview, and installs the optimal skill stack directly — no scripts to review or run manually.

Built for software engineers, AI engineers, and R&D engineers.
290+ skills catalogued across every major category, including 70+ security skills.

---

## Install

```bash
npx skills@latest add kalshamsi/power-engineer-skills --skill power-engineer --global
```

The installer will prompt you to select which agents to install on. Use the
arrow keys to navigate and **press space to select** each agent you want.

![Agent selector during installation](assets/install-agent-selector.png)

This installs the skill globally so it's available in every project. Works with
Claude Code, Codex, Cursor, Gemini CLI, and 8+ other agents.

---

## Quick start (under 2 minutes)

**Step 1 — Install**

```bash
npx skills@latest add kalshamsi/power-engineer-skills --skill power-engineer --global
```

**Step 2 — Run in any project**

Open Claude Code in your project directory and say:

```
/power-engineer
```

**Step 3 — Done**

Power Engineer scans your codebase, asks 5–7 adaptive questions, and installs the right skills directly. No scripts. No copy-paste. Skills are active immediately.

---

## What is this? (Beginner guide)

### What are Claude Code skills?

Claude Code skills are reusable instruction sets that extend what Claude can do inside your project. Each skill gives Claude a specialized workflow — for example, a `test-driven-development` skill teaches Claude the exact TDD loop to follow when writing code, and a `systematic-debugging` skill gives it a structured approach to diagnosing bugs.

Skills are installed per-project (or globally) and referenced in your `CLAUDE.md`. Once installed, you trigger them by name: `/skill-name` in chat, or they activate automatically when Claude detects the right context.

### What does Power Engineer do?

Instead of manually researching, picking, and installing individual skills one by one, Power Engineer does it all in a single run:

1. **Scans your codebase** — detects language, framework, SDKs, infrastructure, cloud/database, brand assets, existing skills, team size, and project maturity
2. **Asks only what it can't infer** — adaptive questionnaire skips questions already answered by the scan (12 questions total, typically 5–7 asked)
3. **Installs skills directly** — no script generation; skills are installed in real-time with progress tracking and failure handling
4. **Configures your project** — generates/merges CLAUDE.md, creates `.power-engineer/` state directory, patches skills with project context
5. **Tracks drift** — on re-run, detects what changed and recommends new skills

### Why would you want it?

- You start a new project and don't know which Claude Code skills are relevant
- You want your whole AI toolchain set up in one command, not assembled piece by piece
- You want skills configured with your actual project context (repo name, stack, conventions), not generic defaults
- You want drift detection: when your stack evolves, Power Engineer tells you what new skills to add

---

## Command reference

| Command | Description |
|---------|-------------|
| `power-engineer` | Full interview: scan → adaptive questionnaire → install → configure |
| `quick` | Auto-detect stack, minimal questions, smart defaults |
| `frontend` | Frontend/design skills only |
| `backend` | Backend/API/database skills only |
| `devops` | DevOps/infrastructure skills only |
| `ai` | AI/LLM/agentic skills only |
| `data` | Data/ML/research skills only |
| `docs` | Documentation skills only |
| `mobile` | Mobile development skills only |
| `status` | Show installed skills + drift report |
| `update` | Detect changes, install new skills |
| `catalog` | Browse catalog interactively |
| `help` | Show command reference and usage hints |
| `configure` | Re-run configuration step only (CLAUDE.md + state dir) |

Trigger any command by saying `power engineer <command>` in Claude Code chat, or use the slash trigger: `/power-engineer`.

---

## Skills catalog

290+ skills catalogued across every major category. Browse by category in [power-engineer/references/catalog/](./power-engineer/references/catalog/). Start with [INDEX.md](./power-engineer/references/catalog/INDEX.md) for an overview.

### Categories

| Category | Sub-categories |
|----------|---------------|
| **Core & Planning** | obra/superpowers, mattpocock planning, GitHub copilot |
| **Anthropic Official** | Document generation, design, skill creation |
| **Engineering** | Backend, DevOps/Infra, Data/ML, Testing, Agentic AI |
| **Security & AppSec** | SAST, DAST, SCA, secrets, containers, IaC, threat modeling, compliance, pentest, DFIR, MCP servers |
| **Frontend & Design** | React/Next.js, Vue/Vite, Design systems, Mobile |
| **Cloud & Databases** | Microsoft Azure, Neon, Supabase |
| **Docs & Research** | Technical writing, web research, data analysis |
| **Power Suites** | GSD, Superpowers, UI/UX Pro Max, Designer Skills, Stitch, Pencil |

---

## What it does

### Questions covered

| # | Topic | Auto-detected? |
|---|-------|---------------|
| Q1 | Project type | Yes (from framework + language) |
| Q2 | Language/stack | Yes (from config files) |
| Q3 | Framework | Yes (from config files) |
| Q4 | Design needs | Always asked |
| Q5 | Documentation needs | Always asked |
| Q6 | Research/data needs | Always asked |
| Q7 | Cloud/database | Yes (from dependencies) |
| Q8 | Project phase | Always asked |
| Q9 | Brand identity | Yes (from design tokens) |
| Q10 | Team workflow | Yes (from git log + CI/CD) |
| Q11 | Goals | Always asked |
| Q12 | Security needs | Always asked |

### After setup

Skills are installed directly — no scripts to run. Power Engineer also creates:

- **CLAUDE.md** — project context with a managed `## Power Engineer` section
- **`.power-engineer/state.json`** — full inventory for drift detection
- **`.power-engineer/install-log.sh`** — audit log (re-runnable)
- **`.power-engineer/brand.md`** — brand identity (if applicable)
- **`.power-engineer/project-context.md`** — goals, team, conventions
- **`.power-engineer/cheatsheet.md`** — installed skills quick reference

---

## Architecture

```
power-engineer/
├── SKILL.md                               ← thin router (~50 lines, 14 commands)
└── references/
    ├── modules/                           ← composable instruction sets
    │   ├── scanner.md                     ← codebase analysis → ProjectProfile
    │   ├── questionnaire.md               ← adaptive interview → SkillPlan
    │   ├── skill-resolver.md              ← SkillPlan → deduplicated install commands
    │   ├── installer.md                   ← direct execution with progress tracking
    │   ├── configurator.md                ← CLAUDE.md, state dir, skill patching
    │   └── drift-detector.md              ← compare state vs current project
    ├── flows/                             ← route-specific module compositions
    │   ├── full-interview.md              ← Scanner → Questionnaire → Resolver → Installer → Configurator
    │   ├── quick.md                       ← Scanner → smart defaults → Resolver → Installer → Configurator
    │   ├── frontend.md                    ← Scanner → targeted questions → frontend skills
    │   ├── backend.md                     ← Scanner → targeted questions → backend skills
    │   ├── devops.md                      ← Scanner → infra detection → devops skills
    │   ├── ai.md                          ← Scanner → SDK detection → AI/LLM skills
    │   ├── data.md                        ← Scanner → data/research skills
    │   ├── docs.md                        ← Scanner → documentation skills
    │   ├── mobile.md                      ← Scanner → mobile framework skills
    │   ├── status.md                      ← state.json → drift report (read-only)
    │   ├── update.md                      ← drift detection → resolve → install
    │   ├── catalog-browse.md              ← interactive catalog browser
    │   ├── help.md                        ← installed skills with trigger phrases
    │   └── configure.md                   ← manage preferences (security level, auto-update)
    ├── catalog/                           ← browsable skill documentation (16 files)
    │   ├── INDEX.md
    │   ├── core-methodology.md
    │   ├── anthropic-official.md
    │   ├── engineering/
    │   ├── frontend/
    │   ├── cloud/
    │   ├── docs-research.md
    │   └── power-suites.md
    └── PLUGIN_INSTALLS_TEMPLATE.md        ← plugin-based install reference
```

### Module pipeline

Every flow composes modules from this pipeline:

```
Scanner → Questionnaire → Skill Resolver → Installer → Configurator
```

The **Drift Detector** runs independently on `status` and `update` commands.

---

## Power suites

Some skill collections install via special methods rather than `npx skills add`.
Power Engineer presents these separately after the main installation completes.

| Suite | Install method | Description |
|-------|---------------|-------------|
| **GSD** | `npx get-shit-done-cc --claude` | Context engineering: questionnaire, SPEC, phased execution, verification |
| **Superpowers** | `/plugin install superpowers@superpowers-marketplace` | Auto-triggering dev methodology: brainstorm, TDD, verify |
| **UI/UX Pro Max** | `/plugin install ui-ux-pro-max@ui-ux-pro-max-skill` | 97 palettes, 57 font pairings, 99 UX guidelines, 9 stacks |
| **Designer Skills** | `/plugin marketplace add Owl-Listener/designer-skills` | 63 skills + 27 commands across 8 design disciplines |
| **Google Stitch** | `npx skills add google-labs-code/stitch-skills --all` | Text/sketch to high-fidelity UI to React/Tailwind |
| **Pencil** | Built-in | Native `.pen` file editor in VS Code |

---

## Security

Every project gets baseline security by default: Sentry's security-review
(independently rated #1), OWASP Top 10:2025, and secrets detection. No extra
steps needed.

For deeper security needs, Q12 asks what you need and layers on specialized
skills:

| Selection | What you get |
|-----------|-------------|
| **Standard** (default) | Code review, OWASP, secrets detection |
| **Deep SAST/DAST** | Semgrep rules, CodeQL, Nuclei scanning, FFUF fuzzing |
| **Container & IaC** | Trivy, Grype, Checkov, tfsec |
| **Compliance** | SOC 2, HIPAA, PCI-DSS, GDPR, ISO 27001 (99% eval score) |
| **Penetration testing** | SecLists, Burp Suite parsing, pentest agents |
| **Threat modeling** | STRIDE/DREAD, MITRE ATT&CK, attack trees |

Framework-specific security skills (Django, Laravel, Spring Boot) are
auto-added when those frameworks are detected — no question needed.

The full security catalog (70+ skills, 60+ MCP servers) is browsable via
`power engineer catalog` → Security & Operations.

---

## Contributing

See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for the full contributor guide,
including how to add skills to the catalog, improve the tool, and submit PRs.

Quick summary:
- Catalog additions go in `power-engineer/references/catalog/`
- Follow the 6-column table format: Skill | Source | Install | Description | Trigger | When to use
- Run `bash tests/run-tests.sh` before submitting

---

## License

MIT
