# Backend Flow

Install backend, API, and database skills for this project.

## Questions

Ask these two questions, waiting for each answer:

**Q1 — Which stack?**
1. TypeScript / JavaScript (Node.js)
2. Python
3. Both

**Q2 — Which database?**
1. Azure AI / Azure PostgreSQL
2. Supabase
3. Neon / PostgreSQL
4. None / other

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

### SWE workflow skills (global)

```bash
npx skills@latest add github/awesome-copilot/gh-cli --global
npx skills@latest add mattpocock/skills/setup-pre-commit --global
npx skills@latest add mattpocock/skills/git-guardrails-claude-code --global
npx skills@latest add obra/superpowers/executing-plans --global
npx skills@latest add github/awesome-copilot/prd --global
npx skills@latest add supercent-io/skills-template/git-workflow --global
npx skills@latest add supercent-io/skills-template/changelog-maintenance --global
```

### Backend skills (local)

```bash
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
```
Plugin-based: `/plugin install engineering-skills@claude-code-skills`
(includes docker, migration, incident, secrets, tech-debt, stripe)

### Stack-specific skills (based on Q1)

**If TypeScript:**
```bash
npx skills@latest add wshobson/agents/typescript-advanced-types
npx skills@latest add wshobson/agents/nodejs-backend-patterns
npx skills@latest add mattpocock/skills/tdd
```

**If Python:**
```bash
npx skills@latest add wshobson/agents/python-performance-optimization
npx skills@latest add inferen-sh/skills/python-executor
npx skills@latest add inferen-sh/skills/python-sdk
```
Plugin-based: `/plugin install engineering-advanced-skills@claude-code-skills`

**If Both:** add all of the above.

### Database skills (based on Q2)

**If Azure AI:**
```bash
npx skills@latest add microsoft/github-copilot-for-azure/azure-ai
npx skills@latest add microsoft/azure-skills/microsoft-foundry
npx skills@latest add microsoft/github-copilot-for-azure/azure-observability
npx skills@latest add microsoft/github-copilot-for-azure/azure-compute
npx skills@latest add microsoft/github-copilot-for-azure/azure-postgres
npx skills@latest add microsoft/azure-skills/azure-observability
npx skills@latest add microsoft/azure-skills/azure-upgrade
```

**If Supabase:**
```bash
npx skills@latest add supabase/agent-skills/supabase-postgres-best-practices
```

**If Neon / PostgreSQL:**
```bash
npx skills@latest add neondatabase/agent-skills/neon-postgres
```

---

## Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
