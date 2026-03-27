<p align="center">
  <h1 align="center">Power Engineer</h1>
  <p align="center">
    The skill stack manager for Claude Code.<br>
    Scan. Interview. Install. Configure. Done.
  </p>
  <p align="center">
    <a href="https://github.com/kalshamsi/power-engineer-skills/releases/tag/v1.0.1"><img src="https://img.shields.io/badge/version-1.0.1-blue" alt="Version 1.0.1"></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License"></a>
    <img src="https://img.shields.io/badge/skills-260%2B-orange" alt="260+ Skills">
    <img src="https://img.shields.io/badge/tests-312%20passing-brightgreen" alt="312 Tests Passing">
  </p>
</p>

---

## Quick start (under 2 minutes)

**Step 1 — Install**

```bash
npx skills@latest add kalshamsi/power-engineer-skills --skill power-engineer --global
```

Select which agents to install on — use arrow keys to navigate and **space to select**.

![Agent selector during installation](assets/install-agent-selector.png)

**Step 2 — Run**

```
/power-engineer
```

**Step 3 — Done.** Skills are installed and active immediately.

> Power Engineer scans your codebase, asks 5–7 adaptive questions, and installs the right skills directly. No scripts. No copy-paste.

---

## What is Power Engineer? (Beginner guide)

**Power Engineer** is an intelligent project setup skill for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). It replaces the manual process of researching, picking, and installing skills one by one with a single automated run.

### What does Power Engineer do?

```
Scan codebase → Adaptive interview → Resolve skills → Install → Configure → Track drift
```

1. **Scans your project** — detects language, framework, SDKs, infrastructure, cloud, brand assets, existing skills, team size, and project maturity
2. **Asks only what it can't infer** — 12 questions total, typically 5–7 asked after auto-detection
3. **Installs skills directly** — real-time execution with progress tracking and failure handling
4. **Configures your project** — generates CLAUDE.md, state directory, skill patching with project context
5. **Tracks drift** — on re-run, detects changes to your stack and recommends new skills

### What are Claude Code skills?

Skills are reusable instruction sets that extend what Claude can do inside your project. A `test-driven-development` skill teaches Claude TDD. A `systematic-debugging` skill gives it structured root-cause analysis. Skills activate by name (`/skill-name`) or automatically when Claude detects the right context.

**Power Engineer curates 260+ of them** across 16 catalog files and installs exactly the ones your project needs.

---

## Command reference

All commands are prefixed with `power engineer` in chat (e.g., `power engineer frontend`).

| Command | Description |
|---------|-------------|
| `/power-engineer` | Full interview — scan, questionnaire, install, configure |
| `quick` | Auto-detect stack, minimal questions, smart defaults |
| `frontend` | Frontend and design skills only |
| `backend` | Backend, API, and database skills only |
| `devops` | DevOps and infrastructure skills only |
| `ai` | AI, LLM, and agentic skills only |
| `data` | Data, ML, and research skills only |
| `docs` | Documentation skills only |
| `mobile` | Mobile development skills only |
| `status` | Show installed skills and drift report (read-only) |
| `update` | Detect project changes, install recommended skills |
| `catalog` | Browse the full skill catalog interactively |
| `help` | Show installed skills with trigger phrases and usage hints |
| `configure` | Manage preferences — security level, auto-update toggle |

---

## Catalog

260+ skills across 16 catalog files. Browse at [`power-engineer/references/catalog/`](./power-engineer/references/catalog/) or start with [`INDEX.md`](./power-engineer/references/catalog/INDEX.md).

| Category | What's included |
|----------|----------------|
| **Core & Planning** | obra/superpowers methodology, mattpocock planning, GitHub copilot workflows |
| **Anthropic Official** | Document generation (docx/pptx/xlsx/pdf), design, skill creation |
| **Backend & Architecture** | API design, TypeScript, Node.js patterns, database schemas, auth, payments |
| **DevOps & Infrastructure** | Docker, Terraform, Helm, CI/CD, migrations, runbooks |
| **Data & ML** | Data engineering, data science, ML/MLOps, computer vision |
| **Testing & Quality** | Playwright, TDD, tech debt tracking, code review, onboarding |
| **Agentic AI** | AI/LLM SDKs, MCP builders, agent patterns, Vercel AI SDK |
| **Security & AppSec** | 80+ skills — SAST, DAST, SCA, secrets, containers, IaC, threat modeling, compliance, pentest, DFIR |
| **Frontend** | React/Next.js, Vue/Vite, design systems, shadcn/ui, Stitch |
| **Mobile** | Expo, React Native, SwiftUI/iOS |
| **Cloud & Databases** | Microsoft Azure, Neon, Supabase, Better Auth |
| **Docs & Research** | Technical writing, web research, Firecrawl, Tavily |
| **Power Suites** | GSD, Superpowers, UI/UX Pro Max, Designer Skills, Stitch, Pencil |

---

## Security

Every project gets baseline security by default — no extra steps:

| Level | What's included |
|-------|----------------|
| **Standard** (default) | Sentry security-review (#1 rated), OWASP Top 10:2025, secrets detection |
| **Enhanced** | Standard + HTTP headers audit, crypto audit, API security testing |
| **Maximum** | Enhanced + Bandit SAST, Socket SCA, Docker Scout, security test generation, DevSecOps pipeline |
| **Compliance** | Maximum + PCI-DSS v4.0 audit, OWASP Mobile Top 10:2024 |
| **Custom** | Cherry-pick from all available security skills |

Additional specialized options: Deep SAST/DAST (Semgrep, CodeQL, Nuclei), Container & IaC (Trivy, Grype, Checkov), Penetration testing (SecLists, Burp Suite), Threat modeling (STRIDE, MITRE ATT&CK). Framework-specific security (Django, Laravel, Spring Boot) is auto-added when detected.

Full security catalog: **80+ skills, 60+ MCP servers** — browse via `power engineer catalog`.

---

## After setup

Power Engineer creates the following in your project:

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project context with managed `## Power Engineer` section |
| `.power-engineer/state.json` | Skill inventory, preferences, scan snapshot for drift detection |
| `.power-engineer/cheatsheet.md` | Installed skills quick reference with trigger phrases |
| `.power-engineer/install-log.sh` | Audit log of all install commands (re-runnable) |
| `.power-engineer/brand.md` | Brand identity — colors, fonts, tokens (if applicable) |
| `.power-engineer/project-context.md` | Goals, team workflow, conventions |

### Adaptive questionnaire

| # | Topic | Auto-detected? |
|---|-------|:---:|
| Q1 | Project type | Yes |
| Q2 | Language / stack | Yes |
| Q3 | Framework | Yes |
| Q4 | Design needs | — |
| Q5 | Documentation needs | — |
| Q6 | Research / data needs | — |
| Q7 | Cloud / database | Yes |
| Q8 | Project phase | — |
| Q9 | Brand identity | Yes |
| Q10 | Team workflow | Yes |
| Q11 | Goals | — |
| Q12 | Security needs | — |

Questions marked **Yes** are skipped when the scan already has the answer.

---

## Architecture

```
power-engineer/
├── SKILL.md                          ← Router (14 commands, ~50 lines)
└── references/
    ├── modules/                      ← Composable instruction sets
    │   ├── scanner.md                ← Codebase analysis → ProjectProfile
    │   ├── questionnaire.md          ← Adaptive interview → SkillPlan
    │   ├── skill-resolver.md         ← SkillPlan → deduplicated install commands
    │   ├── installer.md              ← Direct execution with progress tracking
    │   ├── configurator.md           ← CLAUDE.md, state dir, cheatsheet, skill patching
    │   └── drift-detector.md         ← Compare state vs current project
    ├── flows/                        ← Route-specific module compositions
    │   ├── full-interview.md         ← Scan → Interview → Resolve → Install → Configure
    │   ├── quick.md                  ← Scan → smart defaults → Install → Configure
    │   ├── frontend.md               ← Targeted frontend skill flow
    │   ├── backend.md                ← Targeted backend skill flow
    │   ├── devops.md                 ← Targeted devops skill flow
    │   ├── ai.md                     ← Targeted AI/LLM skill flow
    │   ├── data.md                   ← Targeted data/research skill flow
    │   ├── docs.md                   ← Targeted documentation skill flow
    │   ├── mobile.md                 ← Targeted mobile skill flow
    │   ├── update.md                 ← Drift detection → resolve → install
    │   ├── catalog-browse.md         ← Interactive catalog browser
    │   ├── help.md                   ← Installed skills with triggers
    │   └── configure.md              ← Manage preferences
    └── catalog/                      ← 16 browsable skill catalog files
```

**Module pipeline:** Every flow composes from `Scanner → Questionnaire → Skill Resolver → Installer → Configurator`. The **Drift Detector** runs independently on `status` and `update` commands, and auto-runs when `preferences.auto_update` is enabled.

---

## Power Suites

Curated skill collections that install via specialized methods. Power Engineer presents these after the main installation.

| Suite | Install | Skills |
|-------|---------|--------|
| **GSD** | `npx get-shit-done-cc --claude` | Context engineering with phased execution and verification |
| **Superpowers** | `/plugin install superpowers@superpowers-marketplace` | Auto-triggering dev methodology — brainstorm, plan, TDD, verify |
| **UI/UX Pro Max** | `/plugin install ui-ux-pro-max@ui-ux-pro-max-skill` | 50+ styles, 97 palettes, 57 font pairings, 99 UX guidelines |
| **Designer Skills** | `/plugin marketplace add Owl-Listener/designer-skills` | 63 skills + 27 commands across 8 design disciplines |
| **Google Stitch** | `npx skills add google-labs-code/stitch-skills --all` | Text/sketch → high-fidelity UI → React/Tailwind code |
| **Pencil** | Built-in (VS Code extension) | Native `.pen` design file editor |

---

## Contributing

See [**CONTRIBUTING.md**](docs/CONTRIBUTING.md) for the full guide — adding skills to the catalog, improving the tool, and submitting PRs.

**Quick version:**

1. Find the right file in `power-engineer/references/catalog/`
2. Add a row with all 6 columns: `Skill | Source | Install | Description | Trigger | When to use`
3. Run `bash tests/run-tests.sh`
4. Open a PR with a conventional commit message

---

## License

[MIT](LICENSE)
