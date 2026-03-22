# Decision Matrix

Use this file to map questionnaire answers to skill install commands.
Build two lists as you go: **GLOBAL** (`--global` flag) and **LOCAL** (no flag).
De-duplicate as you go — the same skill may appear from multiple answers.

**Note:** Skills from alirezarezvani/claude-skills use the Claude Code plugin system.
To use them, first add the marketplace (once): `/plugin marketplace add alirezarezvani/claude-skills`
Then install individual skills or bundles as shown below.

---

## Always add — Core methodology (every project, all global)

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

---

## Q1 — Project type

**If answer includes 1 (Software Engineering) or 4 (Full-stack):**
```bash
# Global
npx skills@latest add github/awesome-copilot/gh-cli --global
npx skills@latest add mattpocock/skills/setup-pre-commit --global
npx skills@latest add mattpocock/skills/git-guardrails-claude-code --global
npx skills@latest add obra/superpowers/executing-plans --global
npx skills@latest add github/awesome-copilot/prd --global
npx skills@latest add supercent-io/skills-template/git-workflow --global
npx skills@latest add supercent-io/skills-template/changelog-maintenance --global
# Local
npx skills@latest add wshobson/agents/api-design-principles
npx skills@latest add supercent-io/skills-template/database-schema-design
npx skills@latest add supercent-io/skills-template/authentication-setup
npx skills@latest add supercent-io/skills-template/monitoring-observability
npx skills@latest add supercent-io/skills-template/deployment-automation
npx skills@latest add supercent-io/skills-template/performance-optimization
npx skills@latest add supercent-io/skills-template/backend-testing
npx skills@latest add supercent-io/skills-template/testing-strategies
npx skills@latest add supercent-io/skills-template/log-analysis
npx skills@latest add supercent-io/skills-template/codebase-search
npx skills@latest add supercent-io/skills-template/debugging
# Plugin-based (alirezarezvani/claude-skills) — requires marketplace added
# /plugin install engineering-skills@claude-code-skills (includes docker, migration, incident, secrets, tech-debt, stripe)
```

**If answer includes 2 (AI/LLM Engineering):**
```bash
# Global
npx skills@latest add anthropics/skills/mcp-builder --global
npx skills@latest add tavily-ai/skills/search --global
npx skills@latest add obra/superpowers/executing-plans --global
# Local
npx skills@latest add charon-fan/agent-playbook/self-improving-agent
npx skills@latest add vercel-labs/agent-browser/agent-browser
npx skills@latest add inferen-sh/skills/agent-browser
npx skills@latest add firecrawl/cli/firecrawl
npx skills@latest add inferen-sh/skills/web-search
npx skills@latest add inferen-sh/skills/chat-ui
npx skills@latest add inferen-sh/skills/agent-ui
npx skills@latest add inferen-sh/skills/tools-ui
npx skills@latest add inferen-sh/skills/widgets-ui
npx skills@latest add supercent-io/skills-template/security-best-practices
# Plugin-based (alirezarezvani/claude-skills)
# /plugin install agenthub@claude-code-skills (parallel competing subagents)
# /plugin install engineering-advanced-skills@claude-code-skills (agent-designer, autoresearch)
```

**If answer includes 3 (R&D / Research):**
```bash
# Global
npx skills@latest add supercent-io/skills-template/technical-writing --global
npx skills@latest add tavily-ai/skills/search --global
npx skills@latest add anthropics/skills/mcp-builder --global
# Local
npx skills@latest add supercent-io/skills-template/data-analysis
npx skills@latest add firecrawl/cli/firecrawl
npx skills@latest add inferen-sh/skills/python-executor
npx skills@latest add inferen-sh/skills/web-search
npx skills@latest add mattpocock/skills/design-an-interface
# Plugin-based (alirezarezvani/claude-skills)
# /plugin install engineering-advanced-skills@claude-code-skills (data-engineer, data-scientist, autoresearch)
```

---

## Q2 — Stack

**If TypeScript / JavaScript:**
```bash
# Local
npx skills@latest add wshobson/agents/typescript-advanced-types
npx skills@latest add wshobson/agents/nodejs-backend-patterns
npx skills@latest add mattpocock/skills/tdd
```

**If Python:**
```bash
# Local
npx skills@latest add wshobson/agents/python-performance-optimization
npx skills@latest add inferen-sh/skills/python-executor
npx skills@latest add inferen-sh/skills/python-sdk
# Plugin-based (alirezarezvani/claude-skills)
# /plugin install engineering-advanced-skills@claude-code-skills (data-engineer, data-scientist, ml-engineer, computer-vision)
```

**If Both:** add all of the above.

---

## Q3 — Framework

**Next.js:**
```bash
npx skills@latest add vercel-labs/next-skills/next-best-practices
npx skills@latest add vercel-labs/next-skills/next-cache-components
npx skills@latest add vercel-labs/agent-skills/vercel-react-best-practices
npx skills@latest add vercel-labs/agent-skills/vercel-composition-patterns
npx skills@latest add vercel-labs/agent-skills/deploy-to-vercel
```

**React (no framework):**
```bash
npx skills@latest add vercel-labs/agent-skills/vercel-react-best-practices
npx skills@latest add vercel-labs/agent-skills/vercel-composition-patterns
```

**Vue / Nuxt:**
```bash
npx skills@latest add hyf0/vue-skills/vue-best-practices
npx skills@latest add antfu/skills/vue
npx skills@latest add antfu/skills/vite
```

**Express / Fastify / Hono:**
```bash
npx skills@latest add wshobson/agents/nodejs-backend-patterns
npx skills@latest add supercent-io/skills-template/backend-testing
npx skills@latest add supercent-io/skills-template/api-design
# Plugin-based: /plugin install engineering-skills@claude-code-skills (docker, helm, terraform)
```

**FastAPI / Flask / Django:**
```bash
npx skills@latest add wshobson/agents/python-performance-optimization
npx skills@latest add supercent-io/skills-template/backend-testing
# Plugin-based: /plugin install engineering-skills@claude-code-skills (docker, helm, terraform)
```

**React Native / Expo:**
```bash
npx skills@latest add vercel-labs/agent-skills/vercel-react-native-skills
npx skills@latest add expo/skills/building-native-ui
npx skills@latest add expo/skills/native-data-fetching
npx skills@latest add expo/skills/upgrading-expo
npx skills@latest add expo/skills/expo-tailwind-setup
npx skills@latest add expo/skills/expo-cicd-workflows
npx skills@latest add expo/skills/expo-api-routes
npx skills@latest add expo/skills/expo-dev-client
npx skills@latest add expo/skills/expo-deployment
npx skills@latest add ehmo/platform-design-skills/platform-design-skills
```

**SwiftUI / iOS:**
```bash
npx skills@latest add avdlee/swiftui-agent-skill/swiftui-expert-skill
npx skills@latest add ehmo/platform-design-skills/platform-design-skills
```

Also ask the user: **Are you using the Vercel AI SDK, Anthropic Python SDK,
or Anthropic JS/TS SDK in this project?**

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

---

## Q4 — Design needs

**Full design:**
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
# Google Stitch (requires Stitch MCP server configured)
npx skills add google-labs-code/stitch-skills --skill stitch-loop --global
npx skills add google-labs-code/stitch-skills --skill enhance-prompt --global
npx skills add google-labs-code/stitch-skills --skill react:components --global
npx skills add google-labs-code/stitch-skills --skill design-md --global
npx skills add google-labs-code/stitch-skills --skill shadcn-ui --global
npx skills add google-labs-code/stitch-skills --skill remotion --global
```
Also add to PLUGIN section: UI/UX Pro Max, Designer Skills Collection.

**Standard design:**
```bash
npx skills@latest add anthropics/skills/frontend-design --global
npx skills@latest add wshobson/agents/tailwind-design-system
npx skills@latest add shadcn/ui/shadcn
npx skills@latest add supercent-io/skills-template/responsive-design
npx skills@latest add supercent-io/skills-template/web-accessibility
npx skills@latest add supercent-io/skills-template/ui-component-patterns
npx skills@latest add vercel-labs/agent-skills/web-design-guidelines
```

**Minimal design:**
```bash
npx skills@latest add anthropics/skills/frontend-design --global
```

---

## Q5 — Documentation

**Full office suite:**
```bash
# Global (useful across all projects)
npx skills@latest add anthropics/skills/docx --global
npx skills@latest add anthropics/skills/pptx --global
npx skills@latest add anthropics/skills/xlsx --global
npx skills@latest add anthropics/skills/pdf --global
npx skills@latest add anthropics/skills/internal-comms --global
npx skills@latest add supercent-io/skills-template/technical-writing --global
npx skills@latest add supercent-io/skills-template/user-guide-writing --global
# Local
npx skills@latest add supercent-io/skills-template/api-documentation
```

**Technical docs only:**
```bash
npx skills@latest add supercent-io/skills-template/technical-writing --global
npx skills@latest add supercent-io/skills-template/api-documentation
npx skills@latest add anthropics/skills/pdf --global
```

---

## Q6 — Research / data

**Full research:**
```bash
npx skills@latest add firecrawl/cli/firecrawl
npx skills@latest add tavily-ai/skills/search --global
npx skills@latest add vercel-labs/agent-browser/agent-browser
npx skills@latest add inferen-sh/skills/agent-browser
npx skills@latest add supercent-io/skills-template/data-analysis
npx skills@latest add inferen-sh/skills/python-executor
npx skills@latest add inferen-sh/skills/web-search
```

**Search only:**
```bash
npx skills@latest add tavily-ai/skills/search --global
npx skills@latest add inferen-sh/skills/web-search
```

**Data analysis / Python:**
```bash
npx skills@latest add supercent-io/skills-template/data-analysis
npx skills@latest add inferen-sh/skills/python-executor
npx skills@latest add wshobson/agents/python-performance-optimization
```

---

## Q7 — Cloud / database

**Azure AI:**
```bash
npx skills@latest add microsoft/github-copilot-for-azure/azure-ai
npx skills@latest add microsoft/azure-skills/microsoft-foundry
npx skills@latest add microsoft/github-copilot-for-azure/azure-observability
npx skills@latest add microsoft/github-copilot-for-azure/azure-compute
npx skills@latest add microsoft/github-copilot-for-azure/azure-postgres
npx skills@latest add microsoft/azure-skills/azure-observability
npx skills@latest add microsoft/azure-skills/azure-upgrade
```

**Supabase:**
```bash
npx skills@latest add supabase/agent-skills/supabase-postgres-best-practices
```

**Neon / PostgreSQL:**
```bash
npx skills@latest add neondatabase/agent-skills/neon-postgres
```

---

## Q8 — Project phase

**Greenfield:**
Add the following to the PLUGIN section (strongly recommended):
- GSD — Get Shit Done
- Superpowers by obra

```bash
npx skills@latest add supercent-io/skills-template/file-organization --global
```

**Active feature development:**
No additional skills beyond what Q1-Q7 selected.

**Refactoring:**
```bash
# Global
npx skills@latest add mattpocock/skills/request-refactor-plan --global
# Local
npx skills@latest add supercent-io/skills-template/code-refactoring
npx skills@latest add supercent-io/skills-template/codebase-search
npx skills@latest add supercent-io/skills-template/changelog-maintenance
npx skills@latest add supercent-io/skills-template/debugging
# Plugin-based (alirezarezvani/claude-skills)
# /plugin install engineering-advanced-skills@claude-code-skills (tech-debt-tracker, codebase-onboarding, migration-architect)
```

**Research / prototyping:**
```bash
npx skills@latest add supercent-io/skills-template/data-analysis
npx skills@latest add firecrawl/cli/firecrawl
npx skills@latest add tavily-ai/skills/search --global
npx skills@latest add mattpocock/skills/design-an-interface
```
