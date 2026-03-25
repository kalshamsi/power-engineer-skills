# AI/LLM Flow

Install AI/LLM engineering and agentic skills for this project.

## Questions

Ask this question:

**Which AI SDK are you using?** *(pick all that apply)*
1. Vercel AI SDK
2. Anthropic Python SDK
3. Anthropic JS/TS SDK
4. None / other

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

### AI/LLM core skills

```bash
npx skills@latest add anthropics/skills/mcp-builder
npx skills@latest add tavily-ai/skills/search
npx skills@latest add obra/superpowers/executing-plans
```

### Agentic skills

```bash
npx skills@latest add charon-fan/agent-playbook/self-improving-agent
npx skills@latest add vercel-labs/agent-browser/agent-browser
npx skills@latest add inferen-sh/skills/agent-browser
npx skills@latest add firecrawl/cli/firecrawl
npx skills@latest add inferen-sh/skills/web-search
npx skills@latest add inferen-sh/skills/chat-ui
npx skills@latest add inferen-sh/skills/agent-ui
npx skills@latest add inferen-sh/skills/tools-ui
npx skills@latest add inferen-sh/skills/widgets-ui
```

### SDK-specific skills (based on answer)

**If Vercel AI SDK:**
```bash
npx skills@latest add vercel/ai/ai-sdk
```

**If Anthropic Python SDK:**
```bash
npx skills@latest add inferen-sh/skills/python-sdk
npx skills@latest add inferen-sh/skills/python-executor
```

**If Anthropic JS/TS SDK:**
```bash
npx skills@latest add inferen-sh/skills/javascript-sdk
```

### Plugin-based AI skills

These require the marketplace added first:
`/plugin marketplace add alirezarezvani/claude-skills`

```
/plugin install agenthub@claude-code-skills
```
Includes: parallel competing subagents via git worktree isolation

```
/plugin install engineering-advanced-skills@claude-code-skills
```
Includes: agent-designer, autoresearch-agent

---

## Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
