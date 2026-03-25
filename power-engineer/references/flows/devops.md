# DevOps Flow

Install DevOps, infrastructure, and CI/CD skills. No sub-questions needed —
install the full DevOps/infra stack.

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

### DevOps & Infrastructure (local)

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
