# Plugin Installs Template

Generate `PLUGIN_INSTALLS.md` in the current working directory using this format.

The file must always contain the **full catalog of all available power suites**
at the bottom, regardless of what the user selected. At the top, highlight
only the ones relevant to their answers.

---

## Output format

```markdown
# Plugin-based Installs

These power suites are installed inside Claude Code, not via terminal.
Open Claude Code and run these commands in the chat.

---

## Recommended for this project

[Include only suites that match the user's answers, with a one-line reason]

### [Suite name]
**Why it fits your project:** [brief reason based on their Q1/Q8 answers]

\```
/plugin marketplace add [repo]
/plugin install [plugin]@[marketplace]
\```

---

## Full catalog of power suites

### GSD -- Get Shit Done
Project management system for solo developers. Deep questioning -> domain
research -> requirements -> phased roadmap -> atomic execution -> verification -> PR.
Installs .planning/ directory, SPEC.md, STATE.md, and per-phase artifacts.
Best for: Greenfield projects.

**Terminal install (Claude Code):**
\```bash
npx get-shit-done-cc --claude
\```
**Skills-based install:**
\```bash
npx skills add ctsstc/get-shit-done-skills --skill gsd
\```

---

### Superpowers by obra
Complete software development methodology. Auto-triggers brainstorm -> plan ->
TDD -> verify at every stage without manual invocation. 20+ battle-tested skills.

\```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
\```

---

### UI/UX Pro Max
50+ UI styles, 97 colour palettes, 57 font pairings, 99 UX guidelines, 25 chart
types across 9 tech stacks. Auto-activates on any UI/UX request.

\```
/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
/plugin install ui-ux-pro-max@ui-ux-pro-max-skill
\```
Or via CLI:
\```bash
npm install -g uipro-cli && uipro init --ai claude
\```

---

### Designer Skills Collection (63 skills + 27 commands)
Covers UX Research, Design Systems, Strategy, UI, Interaction Design,
Prototyping & Testing, Design Ops, and Designer Toolkit.
Commands: /discover, /strategize, /handoff, /write-case-study and 23 more.

\```
/plugin marketplace add Owl-Listener/designer-skills
\```

---

### Google Stitch Skills
Official Google Labs skills for the Stitch MCP server. Requires Stitch MCP
configured. Transform text/sketches -> high-fidelity UI -> production React/Tailwind.

\```bash
npx skills add google-labs-code/stitch-skills --all
\```

Or individually:
\```bash
npx skills add google-labs-code/stitch-skills --skill stitch-loop
npx skills add google-labs-code/stitch-skills --skill enhance-prompt
npx skills add google-labs-code/stitch-skills --skill react:components
npx skills add google-labs-code/stitch-skills --skill design-md
npx skills add google-labs-code/stitch-skills --skill shadcn-ui
npx skills add google-labs-code/stitch-skills --skill remotion
\```

---

### Pencil (built-in -- no install)
Pencil is already available as a native tool in Claude Code. Works with .pen
design files directly in VS Code via the Pencil companion extension.
Available tools: batch_design, open_document, get_style_guide, export_nodes,
snapshot_layout, get_variables.

**VS Code:** Search "Pencil" in the Extension Marketplace.

---
*Full skills catalog: see SKILLS_CATALOG.md in this repository.*
*power-engineer-skills -- github.com/[your-username]/power-engineer-skills*
```
