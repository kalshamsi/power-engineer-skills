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

### AI/LLM core skills (global)

```bash
npx skills@latest add anthropics/skills/mcp-builder --global
npx skills@latest add tavily-ai/skills/search --global
npx skills@latest add obra/superpowers/executing-plans --global
```

### Agentic skills (local)

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
