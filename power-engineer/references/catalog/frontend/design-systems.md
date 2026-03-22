# Design Systems

## Google Stitch

Requires the Stitch MCP server to be configured. Enables text/sketch to
high-fidelity UI to production React/Tailwind code via Gemini 2.5 Pro.

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| stitch-loop | `--global` | `npx skills add google-labs-code/stitch-skills --skill stitch-loop --global` | Generates a complete multi-page website from a single prompt. |
| enhance-prompt | `--global` | `npx skills add google-labs-code/stitch-skills --skill enhance-prompt --global` | Transforms vague UI ideas into Stitch-optimised prompts with design system context. |
| react:components | `--global` | `npx skills add google-labs-code/stitch-skills --skill react:components --global` | Converts Stitch screens into React component systems with design token consistency. |
| design-md | `--global` | `npx skills add google-labs-code/stitch-skills --skill design-md --global` | Analyses Stitch projects and generates DESIGN.md files in semantic language. |
| shadcn-ui (stitch) | `--global` | `npx skills add google-labs-code/stitch-skills --skill shadcn-ui --global` | Stitch-aligned shadcn/ui integration for React applications. |
| remotion | `--global` | `npx skills add google-labs-code/stitch-skills --skill remotion --global` | Generates walkthrough videos from Stitch projects via Remotion. |

**Install all Stitch skills at once:**
```bash
npx skills add google-labs-code/stitch-skills --all --global
```

---

## Frontend Design

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| web-design-guidelines | vercel-labs | `local` | `npx skills@latest add vercel-labs/agent-skills/web-design-guidelines` | Comprehensive web design guidelines: layout, spacing, typography, accessibility. |
| tailwind-design-system | wshobson | `local` | `npx skills@latest add wshobson/agents/tailwind-design-system` | Tailwind design system: tokens, variants, responsive utilities, component APIs. |
| shadcn | shadcn/ui | `local` | `npx skills@latest add shadcn/ui/shadcn` | Official shadcn/ui: component discovery, installation, customisation, composition. |
| platform-design-skills | ehmo | `local` | `npx skills@latest add ehmo/platform-design-skills/platform-design-skills` | 300+ design rules from Apple HIG, Material Design 3, and WCAG 2.2. |
| ui-component-patterns | supercent-io | `local` | `npx skills@latest add supercent-io/skills-template/ui-component-patterns` | Component composition patterns, compound components, headless UI strategies. |
| responsive-design | supercent-io | `local` | `npx skills@latest add supercent-io/skills-template/responsive-design` | Mobile-first responsive layouts, breakpoint strategy, fluid typography. |
| web-accessibility | supercent-io | `local` | `npx skills@latest add supercent-io/skills-template/web-accessibility` | WCAG 2.2 compliance, ARIA, keyboard navigation, screen reader testing. |

---

## Design Refinement — pbakaus/impeccable

A suite of focused design refinement skills for iterating on UI quality.

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| frontend-design (impeccable) | `local` | `npx skills@latest add pbakaus/impeccable/frontend-design` | Opinionated frontend design principles: bold, distinctive, non-generic UI. |
| polish | `local` | `npx skills@latest add pbakaus/impeccable/polish` | Refines rough UI into polished, production-ready output. |
| critique | `local` | `npx skills@latest add pbakaus/impeccable/critique` | Structured, honest critique of UI/UX decisions. |
| adapt | `local` | `npx skills@latest add pbakaus/impeccable/adapt` | Adapts design to different contexts, devices, or audiences. |
| clarify | `local` | `npx skills@latest add pbakaus/impeccable/clarify` | Removes visual noise, improves hierarchy and clarity. |
| audit | `local` | `npx skills@latest add pbakaus/impeccable/audit` | Audits existing UI against design principles and identifies issues. |
| animate | `local` | `npx skills@latest add pbakaus/impeccable/animate` | Adds purposeful motion and animation to UI components. |
| bolder | `local` | `npx skills@latest add pbakaus/impeccable/bolder` | Makes UI more decisive, confident, and visually assertive. |
| delight | `local` | `npx skills@latest add pbakaus/impeccable/delight` | Adds delightful micro-interactions and surprise moments. |
| distill | `local` | `npx skills@latest add pbakaus/impeccable/distill` | Reduces a design to its essential elements. |
| extract | `local` | `npx skills@latest add pbakaus/impeccable/extract` | Extracts reusable design patterns and tokens from existing UI. |
| onboard | `local` | `npx skills@latest add pbakaus/impeccable/onboard` | Designs clear, effective onboarding experiences. |
| harden | `local` | `npx skills@latest add pbakaus/impeccable/harden` | Makes UI resilient: empty states, error states, loading states, edge cases. |
| quieter | `local` | `npx skills@latest add pbakaus/impeccable/quieter` | Reduces visual noise; calm, focused, minimal. |
