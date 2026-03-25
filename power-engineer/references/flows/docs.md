# Docs Flow

Install document generation and technical writing skills.

## Questions

Ask this question:

**What level of document generation do you need?**
1. Full office suite (Word .docx, PowerPoint, Excel, PDF)
2. Technical docs only (API documentation, technical writing)

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

### Documentation skills (based on answer)

**If Full office suite:**
```bash
npx skills@latest add anthropics/skills/docx
npx skills@latest add anthropics/skills/pptx
npx skills@latest add anthropics/skills/xlsx
npx skills@latest add anthropics/skills/pdf
npx skills@latest add anthropics/skills/internal-comms
npx skills@latest add supercent-io/skills-template/technical-writing
npx skills@latest add supercent-io/skills-template/user-guide-writing
npx skills@latest add supercent-io/skills-template/api-documentation
```

**If Technical docs only:**
```bash
npx skills@latest add supercent-io/skills-template/technical-writing
npx skills@latest add supercent-io/skills-template/api-documentation
npx skills@latest add anthropics/skills/pdf
```

---

## Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
