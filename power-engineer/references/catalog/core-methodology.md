# Core Methodology & Planning

## obra/superpowers

Always recommended. These skills form a complete agentic development workflow
that auto-activates at each stage without manual invocation.

| Skill | Scope | Description |
|-------|-------|-------------|
| brainstorming | `--global` | Refines rough ideas through structured Q&A, explores alternatives, presents design in sections for validation. |
| writing-plans | `--global` | Breaks approved designs into 2-5 minute tasks with exact file paths, complete code, and verification steps. |
| test-driven-development | `--global` | Enforces RED-GREEN-REFACTOR. Write failing test, watch it fail, write minimal code, commit. |
| systematic-debugging | `--global` | Hypothesis-driven root cause analysis. Auto-triggers when errors are encountered. |
| verification-before-completion | `--global` | Auto-triggers before Claude marks work done. Runs a verification checklist. |
| requesting-code-review | `--global` | Organises changes, writes clear PR descriptions, anticipates reviewer questions. |
| receiving-code-review | `--global` | Handles incoming review feedback constructively and systematically. |
| subagent-driven-development | `--global` | Dispatches a fresh sub-agent per task with two-stage review: spec compliance then code quality. |
| dispatching-parallel-agents | `--global` | Runs independent tasks in parallel across sub-agents for maximum throughput. |
| using-git-worktrees | `--global` | Creates isolated Git workspaces per branch, enabling parallel feature development. |
| finishing-a-development-branch | `--global` | End-of-branch workflow: final verification, PR preparation, merge-back steps. |
| executing-plans | `--global` | Executes implementation plans in batches with human checkpoints between phases. |
| writing-skills | `--global` | General technical writing quality skill. Auto-triggers when producing reports, specs, or docs. |
| using-superpowers | `--global` | Bootstraps the full Superpowers methodology. Teaches Claude the brainstorm-plan-implement loop. |

**Install all at once (via plugin):**
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

**Or individually:**
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
npx skills@latest add obra/superpowers/executing-plans --global
npx skills@latest add obra/superpowers/writing-skills --global
npx skills@latest add obra/superpowers/using-superpowers --global
```

---

## Planning & Product — mattpocock/skills

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| grill-me | `--global` | `npx skills@latest add mattpocock/skills/grill-me --global` | Relentlessly interviews you about a plan until every decision branch is resolved. |
| write-a-prd | `--global` | `npx skills@latest add mattpocock/skills/write-a-prd --global` | Creates a PRD through interactive interview, codebase exploration, and module design. |
| prd-to-plan | `--global` | `npx skills@latest add mattpocock/skills/prd-to-plan --global` | Converts a PRD into a multi-phase implementation plan using tracer-bullet vertical slices. |
| prd-to-issues | `--global` | `npx skills@latest add mattpocock/skills/prd-to-issues --global` | Breaks a PRD into independently-grabbable GitHub issues using vertical slices. |
| request-refactor-plan | `--global` | `npx skills@latest add mattpocock/skills/request-refactor-plan --global` | Creates a detailed refactor plan with tiny commits via user interview. |
| design-an-interface | `local` | `npx skills@latest add mattpocock/skills/design-an-interface` | Generates multiple radically different interface designs using parallel sub-agents. |
| tdd | `local` | `npx skills@latest add mattpocock/skills/tdd` | TypeScript-focused TDD workflow with opinionated patterns and strict RED-GREEN-REFACTOR. |
| setup-pre-commit | `--global` | `npx skills@latest add mattpocock/skills/setup-pre-commit --global` | Sets up pre-commit hooks with lint, type-check, and test runs. |
| git-guardrails-claude-code | `--global` | `npx skills@latest add mattpocock/skills/git-guardrails-claude-code --global` | Installs hooks to block dangerous git commands: push, reset --hard, clean. |
| write-a-skill | `--global` | `npx skills@latest add mattpocock/skills/write-a-skill --global` | Opinionated skill authoring workflow with bundled resource patterns. |
| ubiquitous-language | `local` | `npx skills@latest add mattpocock/skills/ubiquitous-language` | Extracts a DDD-style ubiquitous language glossary from the current conversation. |
| obsidian-vault | `local` | `npx skills@latest add mattpocock/skills/obsidian-vault` | Search, create, and manage notes in an Obsidian vault with wikilinks. |
| scaffold-exercises | `local` | `npx skills@latest add mattpocock/skills/scaffold-exercises` | Scaffolds coding exercises with solutions and test suites. |

---

## GitHub — github/awesome-copilot

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| git-commit | `--global` | `npx skills@latest add github/awesome-copilot/git-commit --global` | Generates conventional commit messages from staged diff with scope detection. |
| gh-cli | `--global` | `npx skills@latest add github/awesome-copilot/gh-cli --global` | Automates GitHub CLI workflows: PR creation, issue management, release drafts. |
| prd | `--global` | `npx skills@latest add github/awesome-copilot/prd --global` | GitHub Copilot's PRD workflow for turning specs into tracked GitHub issues. |
