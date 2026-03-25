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

### Documentation skills (based on answer)

**If Full office suite:**
```bash
# Global
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

**If Technical docs only:**
```bash
npx skills@latest add supercent-io/skills-template/technical-writing --global
npx skills@latest add supercent-io/skills-template/api-documentation
npx skills@latest add anthropics/skills/pdf --global
```

---

## Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
