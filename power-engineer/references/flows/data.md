# Data/ML Flow

Install data engineering, data science, ML/MLOps, and computer vision skills.
No sub-questions needed — install the full data stack.

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

### Research tools (global)

```bash
npx skills@latest add tavily-ai/skills/search --global
npx skills@latest add supercent-io/skills-template/technical-writing --global
```

### Data & ML skills (local)

```bash
npx skills@latest add supercent-io/skills-template/data-analysis
npx skills@latest add inferen-sh/skills/python-executor
npx skills@latest add wshobson/agents/python-performance-optimization
npx skills@latest add firecrawl/cli/firecrawl
npx skills@latest add inferen-sh/skills/web-search
```

### Plugin-based data skills

These require the marketplace added first:
`/plugin marketplace add alirezarezvani/claude-skills`

```
/plugin install engineering-advanced-skills@claude-code-skills
```
Includes: senior-data-engineer (Spark, Airflow, dbt, Kafka),
senior-data-scientist (statistical modeling, A/B testing, MLflow),
senior-ml-engineer (MLOps, model serving, RAG systems),
senior-computer-vision (YOLO, DETR, SAM, ONNX deployment)

---

## Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
