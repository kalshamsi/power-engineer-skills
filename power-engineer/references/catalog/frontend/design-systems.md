# Design Systems

## Google Stitch

Requires the Stitch MCP server to be configured. Enables text/sketch to
high-fidelity UI to production React/Tailwind code via Gemini 2.5 Pro.

| Skill | Install | Description | Trigger | When to use |
|-------|---------|-------------|---------|-------------|
| stitch-loop | `npx skills add google-labs-code/stitch-skills --skill stitch-loop -y` | Generates a complete multi-page website from a single prompt. | `/stitch-loop` | When generating a full multi-page website from a text prompt |
| enhance-prompt | `npx skills add google-labs-code/stitch-skills --skill enhance-prompt -y` | Transforms vague UI ideas into Stitch-optimised prompts with design system context. | `/enhance-prompt` | When refining a vague UI idea into a Stitch-ready design prompt |
| react:components | `npx skills add google-labs-code/stitch-skills --skill react:components -y` | Converts Stitch screens into React component systems with design token consistency. | `/react:components` | When converting Stitch screens into production React components |
| design-md | `npx skills add google-labs-code/stitch-skills --skill design-md -y` | Analyses Stitch projects and generates DESIGN.md files in semantic language. | `/design-md` | When documenting a Stitch project's design system in DESIGN.md |
| shadcn-ui (stitch) | `npx skills add google-labs-code/stitch-skills --skill shadcn-ui -y` | Stitch-aligned shadcn/ui integration for React applications. | `/shadcn-ui` | When integrating shadcn/ui components into a Stitch-based React app |
| remotion | `npx skills add google-labs-code/stitch-skills --skill remotion -y` | Generates walkthrough videos from Stitch projects via Remotion. | `/remotion` | When generating video walkthroughs of a Stitch project via Remotion |

**Install all Stitch skills at once:**
```bash
npx skills add google-labs-code/stitch-skills --all -y
```

---

## Frontend Design

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| web-design-guidelines | vercel-labs | `npx skills add vercel-labs/agent-skills --skill web-design-guidelines -y` | Comprehensive web design guidelines: layout, spacing, typography, accessibility. | `/web-design-guidelines` | When establishing layout, spacing, and typography guidelines for a site |
| tailwind-design-system | wshobson | `npx skills add wshobson/agents --skill tailwind-design-system -y` | Tailwind design system: tokens, variants, responsive utilities, component APIs. | `/tailwind-design-system` | When building a Tailwind design token system and component API |
| shadcn | shadcn/ui | `npx skills add shadcn/ui --skill shadcn -y` | Official shadcn/ui: component discovery, installation, customisation, composition. | `/shadcn` | When adding, customising, or composing shadcn/ui components |
| platform-design-skills | ehmo | `npx skills add ehmo/platform-design-skills --skill platform-design-skills -y` | 300+ design rules from Apple HIG, Material Design 3, and WCAG 2.2. | `/platform-design-skills` | When designing UIs to Apple HIG, Material Design 3, or WCAG standards |

---

## Design Refinement — pbakaus/impeccable

A suite of focused design refinement skills for iterating on UI quality.

| Skill | Install | Description | Trigger | When to use |
|-------|---------|-------------|---------|-------------|
| frontend-design (impeccable) | `npx skills add pbakaus/impeccable --skill frontend-design -y` | Opinionated frontend design principles: bold, distinctive, non-generic UI. | `/frontend-design` | When applying bold, distinctive design principles to a UI |
| polish | `npx skills add pbakaus/impeccable --skill polish -y` | Refines rough UI into polished, production-ready output. | `/polish` | When refining a rough UI mockup into production-ready quality |
| critique | `npx skills add pbakaus/impeccable --skill critique -y` | Structured, honest critique of UI/UX decisions. | `/critique` | When getting an honest structured critique of UI/UX decisions |
| adapt | `npx skills add pbakaus/impeccable --skill adapt -y` | Adapts design to different contexts, devices, or audiences. | `/adapt` | When adapting a design to a new device, context, or audience |
| clarify | `npx skills add pbakaus/impeccable --skill clarify -y` | Removes visual noise, improves hierarchy and clarity. | `/clarify` | When reducing visual noise and improving information hierarchy |
| audit | `npx skills add pbakaus/impeccable --skill audit -y` | Audits existing UI against design principles and identifies issues. | `/audit` | When auditing an existing UI against established design principles |
| animate | `npx skills add pbakaus/impeccable --skill animate -y` | Adds purposeful motion and animation to UI components. | `/animate` | When adding purposeful motion and transitions to UI components |
| bolder | `npx skills add pbakaus/impeccable --skill bolder -y` | Makes UI more decisive, confident, and visually assertive. | `/bolder` | When a design needs more visual confidence and assertiveness |
| delight | `npx skills add pbakaus/impeccable --skill delight -y` | Adds delightful micro-interactions and surprise moments. | `/delight` | When adding micro-interactions and surprise moments to UI |
| distill | `npx skills add pbakaus/impeccable --skill distill -y` | Reduces a design to its essential elements. | `/distill` | When stripping a design down to its most essential elements |
| extract | `npx skills add pbakaus/impeccable --skill extract -y` | Extracts reusable design patterns and tokens from existing UI. | `/extract` | When extracting reusable tokens and patterns from an existing UI |
| onboard | `npx skills add pbakaus/impeccable --skill onboard -y` | Designs clear, effective onboarding experiences. | `/onboard` | When designing user onboarding flows that are clear and effective |
| harden | `npx skills add pbakaus/impeccable --skill harden -y` | Makes UI resilient: empty states, error states, loading states, edge cases. | `/harden` | When making UI resilient with empty, error, and loading states |
| quieter | `npx skills add pbakaus/impeccable --skill quieter -y` | Reduces visual noise; calm, focused, minimal. | `/quieter` | When making a UI calmer, more focused, and minimal |
