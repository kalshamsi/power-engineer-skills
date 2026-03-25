# Design Systems

## Google Stitch

Requires the Stitch MCP server to be configured. Enables text/sketch to
high-fidelity UI to production React/Tailwind code via Gemini 2.5 Pro.

| Skill | Install | Description |
|-------|---------|-------------|
| stitch-loop | `npx skills add google-labs-code/stitch-skills --skill stitch-loop` | Generates a complete multi-page website from a single prompt. |
| enhance-prompt | `npx skills add google-labs-code/stitch-skills --skill enhance-prompt` | Transforms vague UI ideas into Stitch-optimised prompts with design system context. |
| react:components | `npx skills add google-labs-code/stitch-skills --skill react:components` | Converts Stitch screens into React component systems with design token consistency. |
| design-md | `npx skills add google-labs-code/stitch-skills --skill design-md` | Analyses Stitch projects and generates DESIGN.md files in semantic language. |
| shadcn-ui (stitch) | `npx skills add google-labs-code/stitch-skills --skill shadcn-ui` | Stitch-aligned shadcn/ui integration for React applications. |
| remotion | `npx skills add google-labs-code/stitch-skills --skill remotion` | Generates walkthrough videos from Stitch projects via Remotion. |

**Install all Stitch skills at once:**
```bash
npx skills add google-labs-code/stitch-skills --all
```

---

## Frontend Design

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| web-design-guidelines | vercel-labs | `npx skills@latest add vercel-labs/agent-skills/web-design-guidelines` | Comprehensive web design guidelines: layout, spacing, typography, accessibility. |
| tailwind-design-system | wshobson | `npx skills@latest add wshobson/agents/tailwind-design-system` | Tailwind design system: tokens, variants, responsive utilities, component APIs. |
| shadcn | shadcn/ui | `npx skills@latest add shadcn/ui/shadcn` | Official shadcn/ui: component discovery, installation, customisation, composition. |
| platform-design-skills | ehmo | `npx skills@latest add ehmo/platform-design-skills/platform-design-skills` | 300+ design rules from Apple HIG, Material Design 3, and WCAG 2.2. |
| ui-component-patterns | supercent-io | `npx skills@latest add supercent-io/skills-template/ui-component-patterns` | Component composition patterns, compound components, headless UI strategies. |
| responsive-design | supercent-io | `npx skills@latest add supercent-io/skills-template/responsive-design` | Mobile-first responsive layouts, breakpoint strategy, fluid typography. |
| web-accessibility | supercent-io | `npx skills@latest add supercent-io/skills-template/web-accessibility` | WCAG 2.2 compliance, ARIA, keyboard navigation, screen reader testing. |

---

## Design Refinement — pbakaus/impeccable

A suite of focused design refinement skills for iterating on UI quality.

| Skill | Install | Description |
|-------|---------|-------------|
| frontend-design (impeccable) | `npx skills@latest add pbakaus/impeccable/frontend-design` | Opinionated frontend design principles: bold, distinctive, non-generic UI. |
| polish | `npx skills@latest add pbakaus/impeccable/polish` | Refines rough UI into polished, production-ready output. |
| critique | `npx skills@latest add pbakaus/impeccable/critique` | Structured, honest critique of UI/UX decisions. |
| adapt | `npx skills@latest add pbakaus/impeccable/adapt` | Adapts design to different contexts, devices, or audiences. |
| clarify | `npx skills@latest add pbakaus/impeccable/clarify` | Removes visual noise, improves hierarchy and clarity. |
| audit | `npx skills@latest add pbakaus/impeccable/audit` | Audits existing UI against design principles and identifies issues. |
| animate | `npx skills@latest add pbakaus/impeccable/animate` | Adds purposeful motion and animation to UI components. |
| bolder | `npx skills@latest add pbakaus/impeccable/bolder` | Makes UI more decisive, confident, and visually assertive. |
| delight | `npx skills@latest add pbakaus/impeccable/delight` | Adds delightful micro-interactions and surprise moments. |
| distill | `npx skills@latest add pbakaus/impeccable/distill` | Reduces a design to its essential elements. |
| extract | `npx skills@latest add pbakaus/impeccable/extract` | Extracts reusable design patterns and tokens from existing UI. |
| onboard | `npx skills@latest add pbakaus/impeccable/onboard` | Designs clear, effective onboarding experiences. |
| harden | `npx skills@latest add pbakaus/impeccable/harden` | Makes UI resilient: empty states, error states, loading states, edge cases. |
| quieter | `npx skills@latest add pbakaus/impeccable/quieter` | Reduces visual noise; calm, focused, minimal. |
