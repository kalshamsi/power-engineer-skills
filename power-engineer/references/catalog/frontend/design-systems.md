# Design Systems

## Google Stitch

Requires the Stitch MCP server to be configured. Enables text/sketch to
high-fidelity UI to production React/Tailwind code via Gemini 2.5 Pro.

| Skill | Install | Description |
|-------|---------|-------------|
| stitch-loop | `npx skills@latest add google-labs-code/stitch-skills --skill stitch-loop -y` | Generates a complete multi-page website from a single prompt. |
| enhance-prompt | `npx skills@latest add google-labs-code/stitch-skills --skill enhance-prompt -y` | Transforms vague UI ideas into Stitch-optimised prompts with design system context. |
| react:components | `npx skills@latest add google-labs-code/stitch-skills --skill react:components -y` | Converts Stitch screens into React component systems with design token consistency. |
| design-md | `npx skills@latest add google-labs-code/stitch-skills --skill design-md -y` | Analyses Stitch projects and generates DESIGN.md files in semantic language. |
| shadcn-ui (stitch) | `npx skills@latest add google-labs-code/stitch-skills --skill shadcn-ui -y` | Stitch-aligned shadcn/ui integration for React applications. |
| remotion | `npx skills@latest add google-labs-code/stitch-skills --skill remotion -y` | Generates walkthrough videos from Stitch projects via Remotion. |

**Install all Stitch skills at once:**
```bash
npx skills@latest add google-labs-code/stitch-skills --all -y
```

---

## Frontend Design

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| web-design-guidelines | vercel-labs | `npx skills@latest add vercel-labs/agent-skills --skill web-design-guidelines -y` | Comprehensive web design guidelines: layout, spacing, typography, accessibility. |
| tailwind-design-system | wshobson | `npx skills@latest add wshobson/agents --skill tailwind-design-system -y` | Tailwind design system: tokens, variants, responsive utilities, component APIs. |
| shadcn | shadcn/ui | `npx skills@latest add shadcn/ui --skill shadcn -y` | Official shadcn/ui: component discovery, installation, customisation, composition. |
| platform-design-skills | ehmo | `npx skills@latest add ehmo/platform-design-skills --skill platform-design-skills -y` | 300+ design rules from Apple HIG, Material Design 3, and WCAG 2.2. |
| ui-component-patterns | supercent-io | `npx skills@latest add supercent-io/skills-template --skill ui-component-patterns -y` | Component composition patterns, compound components, headless UI strategies. |
| responsive-design | supercent-io | `npx skills@latest add supercent-io/skills-template --skill responsive-design -y` | Mobile-first responsive layouts, breakpoint strategy, fluid typography. |
| web-accessibility | supercent-io | `npx skills@latest add supercent-io/skills-template --skill web-accessibility -y` | WCAG 2.2 compliance, ARIA, keyboard navigation, screen reader testing. |

---

## Design Refinement — pbakaus/impeccable

A suite of focused design refinement skills for iterating on UI quality.

| Skill | Install | Description |
|-------|---------|-------------|
| frontend-design (impeccable) | `npx skills@latest add pbakaus/impeccable --skill frontend-design -y` | Opinionated frontend design principles: bold, distinctive, non-generic UI. |
| polish | `npx skills@latest add pbakaus/impeccable --skill polish -y` | Refines rough UI into polished, production-ready output. |
| critique | `npx skills@latest add pbakaus/impeccable --skill critique -y` | Structured, honest critique of UI/UX decisions. |
| adapt | `npx skills@latest add pbakaus/impeccable --skill adapt -y` | Adapts design to different contexts, devices, or audiences. |
| clarify | `npx skills@latest add pbakaus/impeccable --skill clarify -y` | Removes visual noise, improves hierarchy and clarity. |
| audit | `npx skills@latest add pbakaus/impeccable --skill audit -y` | Audits existing UI against design principles and identifies issues. |
| animate | `npx skills@latest add pbakaus/impeccable --skill animate -y` | Adds purposeful motion and animation to UI components. |
| bolder | `npx skills@latest add pbakaus/impeccable --skill bolder -y` | Makes UI more decisive, confident, and visually assertive. |
| delight | `npx skills@latest add pbakaus/impeccable --skill delight -y` | Adds delightful micro-interactions and surprise moments. |
| distill | `npx skills@latest add pbakaus/impeccable --skill distill -y` | Reduces a design to its essential elements. |
| extract | `npx skills@latest add pbakaus/impeccable --skill extract -y` | Extracts reusable design patterns and tokens from existing UI. |
| onboard | `npx skills@latest add pbakaus/impeccable --skill onboard -y` | Designs clear, effective onboarding experiences. |
| harden | `npx skills@latest add pbakaus/impeccable --skill harden -y` | Makes UI resilient: empty states, error states, loading states, edge cases. |
| quieter | `npx skills@latest add pbakaus/impeccable --skill quieter -y` | Reduces visual noise; calm, focused, minimal. |
