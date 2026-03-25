# Data/ML Flow

Install data engineering, data science, ML/MLOps, and computer vision skills.
No sub-questions needed — install the full data stack.

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

### Research tools

```bash
npx skills@latest add tavily-ai/skills/search
npx skills@latest add supercent-io/skills-template/technical-writing
```

### Data & ML skills

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
