# DevOps Flow

Install DevOps, infrastructure, and CI/CD skills. No sub-questions needed —
install the full DevOps/infra stack.

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

### SWE workflow skills

```bash
npx skills@latest add github/awesome-copilot/gh-cli
npx skills@latest add mattpocock/skills/setup-pre-commit
npx skills@latest add mattpocock/skills/git-guardrails-claude-code
npx skills@latest add obra/superpowers/executing-plans
npx skills@latest add github/awesome-copilot/prd
npx skills@latest add supercent-io/skills-template/git-workflow
npx skills@latest add supercent-io/skills-template/changelog-maintenance
```

### DevOps & Infrastructure

```bash
npx skills@latest add supercent-io/skills-template/deployment-automation
npx skills@latest add supercent-io/skills-template/monitoring-observability
npx skills@latest add supercent-io/skills-template/log-analysis
npx skills@latest add supercent-io/skills-template/debugging
```

### Plugin-based DevOps skills

These require the marketplace added first:
`/plugin marketplace add alirezarezvani/claude-skills`

```
/plugin install engineering-skills@claude-code-skills
```
Includes: docker-development, helm-chart-builder, incident-response, secrets-management

```
/plugin install engineering-advanced-skills@claude-code-skills
```
Includes: terraform-patterns, migration-architect, runbook-generator

---

## Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
