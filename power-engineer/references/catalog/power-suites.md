# Power Suites (Plugin-based)

These are installed inside Claude Code via `/plugin` commands, not the terminal.

---

## GSD -- Get Shit Done

The most complete solo-developer context engineering system.
Deep questioning -> domain research -> requirements -> phased roadmap -> atomic
execution -> goal-backward verification -> PR. Installs `.planning/` directory,
`SPEC.md`, `STATE.md`, and per-phase plan/verify/UAT artifacts.

**Best for:** Greenfield projects, solo developers, structured shipping.

**Install via terminal:**
```bash
npx get-shit-done-cc --claude --global
```

**Or via skills-based install:**
```bash
npx skills add ctsstc/get-shit-done-skills --skill gsd
```

**Commands:** `/gsd:discuss-phase`, `/gsd:plan-phase`, `/gsd:execute-phase`,
`/gsd:verify-work`, `/gsd:ship`, `/gsd:map-codebase`

---

## Superpowers by obra

A complete software development methodology built on composable skills.
Auto-triggers brainstorm -> write-plan -> subagent-driven-development ->
TDD -> verify at every stage. 20+ battle-tested skills.

**Install inside Claude Code:**
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
/plugin update superpowers
```

**Commands:** `/superpowers:brainstorm`, `/superpowers:write-plan`,
`/superpowers:execute-plan` + 17 auto-activating skills.

---

## UI/UX Pro Max

50+ UI styles, 97 colour palettes, 57 font pairings, 99 UX guidelines, 25 chart
types across 9 tech stacks: React, Next.js, Vue, Svelte, Flutter, SwiftUI,
shadcn/ui, Jetpack Compose, HTML+Tailwind. Auto-activates on any UI/UX request.

**Install inside Claude Code:**
```
/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
/plugin install ui-ux-pro-max@ui-ux-pro-max-skill
```

**Or via CLI:**
```bash
npm install -g uipro-cli && uipro init --ai claude
```

---

## Designer Skills Collection -- 63 skills + 27 commands

63 design skills and 27 commands across 8 plugin categories by Owl-Listener:
UX Research, Design Systems, Strategy, UI, Interaction Design,
Prototyping & Testing, Design Ops, Designer Toolkit.

**Commands include:** `/discover`, `/strategize`, `/handoff`, `/write-case-study`, and 23 more.

**Install inside Claude Code:**
```
/plugin marketplace add Owl-Listener/designer-skills
```

---

## Google Stitch Skills (npx-based)

Official Google Labs skills for the Stitch MCP server. Transform text/sketches ->
high-fidelity interfaces -> production React/Tailwind code via Gemini 2.5 Pro.
Requires Stitch MCP server configured.

**Install all:**
```bash
npx skills add google-labs-code/stitch-skills --all --global
```

**Or individually:**
```bash
npx skills add google-labs-code/stitch-skills --skill stitch-loop --global
npx skills add google-labs-code/stitch-skills --skill enhance-prompt --global
npx skills add google-labs-code/stitch-skills --skill react:components --global
npx skills add google-labs-code/stitch-skills --skill design-md --global
npx skills add google-labs-code/stitch-skills --skill shadcn-ui --global
npx skills add google-labs-code/stitch-skills --skill remotion --global
```

---

## Pencil -- Built-in, no install needed

Pencil is a native design tool already integrated into Claude's environment.
Works with `.pen` design files directly in VS Code via the Pencil companion extension.

**Available tools Claude can call:**
- `pencil:batch_design` -- execute multiple design operations in one call
- `pencil:open_document` -- open a `.pen` file
- `pencil:get_style_guide` -- retrieve design guidelines for a given style
- `pencil:get_variables` -- get variables and themes defined in a file
- `pencil:export_nodes` -- export nodes to PNG/JPEG/WEBP/PDF
- `pencil:snapshot_layout` -- check current layout structure
- `pencil:get_screenshot` -- capture current canvas state

**VS Code setup:** Search "Pencil" in the Extension Marketplace.

---

## alirezarezvani/claude-skills (Plugin marketplace)

205 production-ready skills across engineering, marketing, product, compliance.

**Install marketplace:**
```
/plugin marketplace add alirezarezvani/claude-skills
```

**Install by domain:**
```
/plugin install engineering-skills@claude-code-skills
/plugin install engineering-advanced-skills@claude-code-skills
```

See individual catalog files for specific skills from this collection.
