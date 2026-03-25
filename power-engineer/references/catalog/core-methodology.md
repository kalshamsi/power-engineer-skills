# Core Methodology & Planning

## obra/superpowers

Always recommended. These skills form a complete agentic development workflow
that auto-activates at each stage without manual invocation.

| Skill | Description |
|-------|-------------|
| brainstorming | Refines rough ideas through structured Q&A, explores alternatives, presents design in sections for validation. |
| writing-plans | Breaks approved designs into 2-5 minute tasks with exact file paths, complete code, and verification steps. |
| test-driven-development | Enforces RED-GREEN-REFACTOR. Write failing test, watch it fail, write minimal code, commit. |
| systematic-debugging | Hypothesis-driven root cause analysis. Auto-triggers when errors are encountered. |
| verification-before-completion | Auto-triggers before Claude marks work done. Runs a verification checklist. |
| requesting-code-review | Organises changes, writes clear PR descriptions, anticipates reviewer questions. |
| receiving-code-review | Handles incoming review feedback constructively and systematically. |
| subagent-driven-development | Dispatches a fresh sub-agent per task with two-stage review: spec compliance then code quality. |
| dispatching-parallel-agents | Runs independent tasks in parallel across sub-agents for maximum throughput. |
| using-git-worktrees | Creates isolated Git workspaces per branch, enabling parallel feature development. |
| finishing-a-development-branch | End-of-branch workflow: final verification, PR preparation, merge-back steps. |
| executing-plans | Executes implementation plans in batches with human checkpoints between phases. |
| writing-skills | General technical writing quality skill. Auto-triggers when producing reports, specs, or docs. |
| using-superpowers | Bootstraps the full Superpowers methodology. Teaches Claude the brainstorm-plan-implement loop. |

**Install all at once (via plugin):**
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

**Or individually:**
```bash
npx skills@latest add obra/superpowers --skill brainstorming -y
npx skills@latest add obra/superpowers --skill writing-plans -y
npx skills@latest add obra/superpowers --skill test-driven-development -y
npx skills@latest add obra/superpowers --skill systematic-debugging -y
npx skills@latest add obra/superpowers --skill verification-before-completion -y
npx skills@latest add obra/superpowers --skill requesting-code-review -y
npx skills@latest add obra/superpowers --skill receiving-code-review -y
npx skills@latest add obra/superpowers --skill subagent-driven-development -y
npx skills@latest add obra/superpowers --skill dispatching-parallel-agents -y
npx skills@latest add obra/superpowers --skill using-git-worktrees -y
npx skills@latest add obra/superpowers --skill finishing-a-development-branch -y
npx skills@latest add obra/superpowers --skill executing-plans -y
npx skills@latest add obra/superpowers --skill writing-skills -y
npx skills@latest add obra/superpowers --skill using-superpowers -y```

---

## Planning & Product — mattpocock/skills

| Skill | Install | Description |
|-------|---------|-------------|
| grill-me | `npx skills@latest add mattpocock/skills --skill grill-me -y` | Relentlessly interviews you about a plan until every decision branch is resolved. |
| write-a-prd | `npx skills@latest add mattpocock/skills --skill write-a-prd -y` | Creates a PRD through interactive interview, codebase exploration, and module design. |
| prd-to-plan | `npx skills@latest add mattpocock/skills --skill prd-to-plan -y` | Converts a PRD into a multi-phase implementation plan using tracer-bullet vertical slices. |
| prd-to-issues | `npx skills@latest add mattpocock/skills --skill prd-to-issues -y` | Breaks a PRD into independently-grabbable GitHub issues using vertical slices. |
| request-refactor-plan | `npx skills@latest add mattpocock/skills --skill request-refactor-plan -y` | Creates a detailed refactor plan with tiny commits via user interview. |
| design-an-interface | `npx skills@latest add mattpocock/skills --skill design-an-interface -y` | Generates multiple radically different interface designs using parallel sub-agents. |
| tdd | `npx skills@latest add mattpocock/skills --skill tdd -y` | TypeScript-focused TDD workflow with opinionated patterns and strict RED-GREEN-REFACTOR. |
| setup-pre-commit | `npx skills@latest add mattpocock/skills --skill setup-pre-commit -y` | Sets up pre-commit hooks with lint, type-check, and test runs. |
| git-guardrails-claude-code | `npx skills@latest add mattpocock/skills --skill git-guardrails-claude-code -y` | Installs hooks to block dangerous git commands: push, reset --hard, clean. |
| write-a-skill | `npx skills@latest add mattpocock/skills --skill write-a-skill -y` | Opinionated skill authoring workflow with bundled resource patterns. |
| ubiquitous-language | `npx skills@latest add mattpocock/skills --skill ubiquitous-language -y` | Extracts a DDD-style ubiquitous language glossary from the current conversation. |
| obsidian-vault | `npx skills@latest add mattpocock/skills --skill obsidian-vault -y` | Search, create, and manage notes in an Obsidian vault with wikilinks. |
| scaffold-exercises | `npx skills@latest add mattpocock/skills --skill scaffold-exercises -y` | Scaffolds coding exercises with solutions and test suites. |

---

## GitHub — github/awesome-copilot

| Skill | Install | Description |
|-------|---------|-------------|
| git-commit | `npx skills@latest add github/awesome-copilot --skill git-commit -y` | Generates conventional commit messages from staged diff with scope detection. |
| gh-cli | `npx skills@latest add github/awesome-copilot --skill gh-cli -y` | Automates GitHub CLI workflows: PR creation, issue management, release drafts. |
| prd | `npx skills@latest add github/awesome-copilot --skill prd -y` | GitHub Copilot's PRD workflow for turning specs into tracked GitHub issues. |
