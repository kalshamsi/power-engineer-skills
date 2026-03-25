# Frontend Flow

Install frontend and design skills for this project.

## Questions

Ask these two questions, waiting for each answer:

**Q1 — Which framework?**
1. Next.js
2. React (without a framework)
3. Vue / Nuxt
4. None / other

**Q2 — What design level?**
1. Full — design systems, Stitch integration, 63-skill designer collection
2. Standard — component library, shadcn/ui, Tailwind design system
3. Minimal — just Anthropic's frontend-design skill
4. None

Also ask: **Are you using the Vercel AI SDK, Anthropic Python SDK, or
Anthropic JS/TS SDK in this project?**

---

## Detect installed skills

```bash
ls ~/.claude/skills/ .claude/skills/ 2>/dev/null || echo "(none)"
```

Filter all selections below against what's already installed.

---

## Skill selection

### Always add — Core methodology

```bash
npx skills@latest add obra/superpowers/brainstorming
npx skills@latest add obra/superpowers/writing-plans
npx skills@latest add obra/superpowers/test-driven-development
npx skills@latest add obra/superpowers/systematic-debugging
npx skills@latest add obra/superpowers/verification-before-completion
npx skills@latest add obra/superpowers/requesting-code-review
npx skills@latest add obra/superpowers/receiving-code-review
npx skills@latest add obra/superpowers/subagent-driven-development
npx skills@latest add obra/superpowers/dispatching-parallel-agents
npx skills@latest add obra/superpowers/using-git-worktrees
npx skills@latest add obra/superpowers/finishing-a-development-branch
npx skills@latest add obra/superpowers/writing-skills
npx skills@latest add mattpocock/skills/grill-me
npx skills@latest add mattpocock/skills/write-a-prd
npx skills@latest add mattpocock/skills/prd-to-plan
npx skills@latest add mattpocock/skills/prd-to-issues
npx skills@latest add anthropics/skills/skill-creator
npx skills@latest add supercent-io/skills-template/security-best-practices
npx skills@latest add github/awesome-copilot/git-commit
npx skills@latest add supercent-io/skills-template/task-planning
```

### Framework skills (based on Q1)

**If Next.js:**
```bash
npx skills@latest add vercel-labs/next-skills/next-best-practices
npx skills@latest add vercel-labs/next-skills/next-cache-components
npx skills@latest add vercel-labs/agent-skills/vercel-react-best-practices
npx skills@latest add vercel-labs/agent-skills/vercel-composition-patterns
npx skills@latest add vercel-labs/agent-skills/deploy-to-vercel
```

**If React (no framework):**
```bash
npx skills@latest add vercel-labs/agent-skills/vercel-react-best-practices
npx skills@latest add vercel-labs/agent-skills/vercel-composition-patterns
```

**If Vue / Nuxt:**
```bash
npx skills@latest add hyf0/vue-skills/vue-best-practices
npx skills@latest add antfu/skills/vue
npx skills@latest add antfu/skills/vite
```

### SDK skills (based on follow-up question)

**If Vercel AI SDK:**
```bash
npx skills@latest add vercel/ai/ai-sdk
npx skills@latest add inferen-sh/skills/chat-ui
npx skills@latest add inferen-sh/skills/agent-ui
npx skills@latest add inferen-sh/skills/tools-ui
npx skills@latest add inferen-sh/skills/widgets-ui
```

**If Anthropic Python SDK:**
```bash
npx skills@latest add inferen-sh/skills/python-sdk
```

**If Anthropic JS/TS SDK:**
```bash
npx skills@latest add inferen-sh/skills/javascript-sdk
```

### Design skills (based on Q2)

**If Full design:**
```bash
npx skills@latest add anthropics/skills/frontend-design
npx skills@latest add anthropics/skills/canvas-design
npx skills@latest add anthropics/skills/brand-guidelines
npx skills@latest add vercel-labs/agent-skills/web-design-guidelines
npx skills@latest add wshobson/agents/tailwind-design-system
npx skills@latest add shadcn/ui/shadcn
npx skills@latest add ehmo/platform-design-skills/platform-design-skills
npx skills@latest add better-auth/skills/better-auth-best-practices
npx skills@latest add supercent-io/skills-template/ui-component-patterns
npx skills@latest add supercent-io/skills-template/responsive-design
npx skills@latest add supercent-io/skills-template/web-accessibility
npx skills@latest add mattpocock/skills/design-an-interface
# Google Stitch
npx skills add google-labs-code/stitch-skills --skill stitch-loop
npx skills add google-labs-code/stitch-skills --skill enhance-prompt
npx skills add google-labs-code/stitch-skills --skill react:components
npx skills add google-labs-code/stitch-skills --skill design-md
npx skills add google-labs-code/stitch-skills --skill shadcn-ui
npx skills add google-labs-code/stitch-skills --skill remotion
```
Also add to PLUGIN section: UI/UX Pro Max, Designer Skills Collection.

**If Standard design:**
```bash
npx skills@latest add anthropics/skills/frontend-design
npx skills@latest add wshobson/agents/tailwind-design-system
npx skills@latest add shadcn/ui/shadcn
npx skills@latest add supercent-io/skills-template/responsive-design
npx skills@latest add supercent-io/skills-template/web-accessibility
npx skills@latest add supercent-io/skills-template/ui-component-patterns
npx skills@latest add vercel-labs/agent-skills/web-design-guidelines
```

**If Minimal design:**
```bash
npx skills@latest add anthropics/skills/frontend-design
```

---

## Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
