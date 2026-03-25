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
echo "=== GLOBAL ===" && ls ~/.claude/skills/ 2>/dev/null || echo "(none)"
echo "=== LOCAL ===" && ls .claude/skills/ 2>/dev/null || echo "(none)"
```

Filter all selections below against what's already installed.

---

## Skill selection

### Always add — Core methodology (global)

```bash
npx skills@latest add obra/superpowers/brainstorming --global
npx skills@latest add obra/superpowers/writing-plans --global
npx skills@latest add obra/superpowers/test-driven-development --global
npx skills@latest add obra/superpowers/systematic-debugging --global
npx skills@latest add obra/superpowers/verification-before-completion --global
npx skills@latest add obra/superpowers/requesting-code-review --global
npx skills@latest add obra/superpowers/receiving-code-review --global
npx skills@latest add obra/superpowers/subagent-driven-development --global
npx skills@latest add obra/superpowers/dispatching-parallel-agents --global
npx skills@latest add obra/superpowers/using-git-worktrees --global
npx skills@latest add obra/superpowers/finishing-a-development-branch --global
npx skills@latest add obra/superpowers/writing-skills --global
npx skills@latest add mattpocock/skills/grill-me --global
npx skills@latest add mattpocock/skills/write-a-prd --global
npx skills@latest add mattpocock/skills/prd-to-plan --global
npx skills@latest add mattpocock/skills/prd-to-issues --global
npx skills@latest add anthropics/skills/skill-creator --global
npx skills@latest add supercent-io/skills-template/security-best-practices --global
npx skills@latest add github/awesome-copilot/git-commit --global
npx skills@latest add supercent-io/skills-template/task-planning --global
```

### Framework skills (local, based on Q1)

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
# Global
npx skills@latest add anthropics/skills/frontend-design --global
npx skills@latest add anthropics/skills/canvas-design --global
npx skills@latest add anthropics/skills/brand-guidelines --global
# Local
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
npx skills add google-labs-code/stitch-skills --skill stitch-loop --global
npx skills add google-labs-code/stitch-skills --skill enhance-prompt --global
npx skills add google-labs-code/stitch-skills --skill react:components --global
npx skills add google-labs-code/stitch-skills --skill design-md --global
npx skills add google-labs-code/stitch-skills --skill shadcn-ui --global
npx skills add google-labs-code/stitch-skills --skill remotion --global
```
Also add to PLUGIN section: UI/UX Pro Max, Designer Skills Collection.

**If Standard design:**
```bash
npx skills@latest add anthropics/skills/frontend-design --global
npx skills@latest add wshobson/agents/tailwind-design-system
npx skills@latest add shadcn/ui/shadcn
npx skills@latest add supercent-io/skills-template/responsive-design
npx skills@latest add supercent-io/skills-template/web-accessibility
npx skills@latest add supercent-io/skills-template/ui-component-patterns
npx skills@latest add vercel-labs/agent-skills/web-design-guidelines
```

**If Minimal design:**
```bash
npx skills@latest add anthropics/skills/frontend-design --global
```

---

## Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
