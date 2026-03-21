# power-engineer-skills

A global Claude Code skill that interviews you about your project and generates
a complete, ready-to-run skill installation script tailored to your stack,
discipline, and goals.

Built for software engineers, AI engineers, and R&D engineers.
130+ skills catalogued across every major category.

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
- Selects the right skills from 130+ catalogued options
- Generates `install-skills.sh` — a shell script you review and run
- Generates `PLUGIN_INSTALLS.md` — plugin-based installs to do inside Claude Code
- Skips anything already installed

---

## Install the skill globally

```bash
npx skills@latest add kalshamsi/power-engineer-skills/power-engineer --global
```

This installs the skill to `~/.claude/skills/power-engineer/` so it is
available in every project.

---

## Use it

Open Claude Code in any project directory and say:

> "Set up skills for this project"

or

> "Power engineer setup"

Claude will run the questionnaire, detect your existing skills, and write the
two output files to your project root.

Then:

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
├── README.md                              ← you are here
├── SKILLS_CATALOG.md                      ← full catalog (human reference)
└── power-engineer/                        ← the skill directory
    ├── SKILL.md                           ← skill instructions (<200 lines)
    └── references/
        ├── SKILLS_CATALOG.md              ← full catalog (Claude reads at runtime)
        ├── DECISION_MATRIX.md             ← maps answers → skill commands
        ├── INSTALL_SCRIPT_TEMPLATE.md     ← install-skills.sh format
        └── PLUGIN_INSTALLS_TEMPLATE.md    ← PLUGIN_INSTALLS.md format
```

---

## Skills catalog

See [SKILLS_CATALOG.md](./SKILLS_CATALOG.md) for the full list of 130+ skills
organised by category, with install commands and scope recommendations.

Categories covered:

| # | Category |
|---|----------|
| 1 | Core Methodology — obra/superpowers |
| 2 | Planning & Product — mattpocock/skills |
| 3 | Anthropic Official |
| 4 | GitHub — awesome-copilot |
| 5 | Architecture & Backend — wshobson/agents |
| 6 | Engineering Templates — supercent-io |
| 7 | Vercel — agent-skills, next-skills, AI SDK |
| 8 | AI/LLM Engineering — inferen-sh |
| 9 | Agentic Patterns |
| 10 | Data & Research |
| 11 | Testing |
| 12 | Cloud & Infrastructure — Microsoft Azure |
| 13 | Databases — Neon, Supabase, Better Auth |
| 14 | Design — Google Stitch |
| 15 | Design — Frontend |
| 16 | Design — pbakaus/impeccable (14 refinement skills) |
| 17 | Mobile — Expo |
| 18 | Mobile — SwiftUI/iOS |
| 19 | Vue / Vite |
| 20 | Meta / Skill Creation |
| 21 | Power Suites (GSD, Superpowers, UI/UX Pro Max, Designer Skills, Stitch, Pencil) |
| 22 | Community Extras |

---

## Power suites

Some skill collections install via Claude Code's `/plugin` system rather than
`npx skills add`. The setup skill generates a `PLUGIN_INSTALLS.md` listing
which ones are relevant for your project and how to install them.

| Suite | Install method | Description |
|-------|---------------|-------------|
| **GSD — Get Shit Done** | `npx get-shit-done-cc --claude --global` | Context engineering layer: questionnaire → SPEC → phased execution → verification |
| **Superpowers** | `/plugin install superpowers@superpowers-marketplace` | Auto-triggering dev methodology: brainstorm → TDD → verify |
| **UI/UX Pro Max** | `/plugin install ui-ux-pro-max@ui-ux-pro-max-skill` | 97 palettes, 57 font pairings, 99 UX guidelines, 9 stacks |
| **Designer Skills** | `/plugin marketplace add Owl-Listener/designer-skills` | 63 skills + 27 commands across 8 design disciplines |
| **Google Stitch** | `npx skills add google-labs-code/stitch-skills --all --global` | Text/sketch → high-fidelity UI → React/Tailwind via Gemini 2.5 Pro |
| **Pencil** | Built-in | Native `.pen` file editor in VS Code via companion extension |

---

## Contributing

PRs welcome. If you find a skill worth adding to the catalog, open an issue or
submit a PR updating `SKILLS_CATALOG.md`, `setup/references/SKILLS_CATALOG.md`,
and the relevant section in `setup/references/DECISION_MATRIX.md`.

Please include:
- Skill name and source repo
- Verified install command
- Recommended scope (global/local)
- One-line description

---

## License

MIT
