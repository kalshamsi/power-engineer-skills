# Core Methodology & Planning

## obra/superpowers

Always recommended. These skills form a complete agentic development workflow
that auto-activates at each stage without manual invocation.

| Skill | Install | Description | Trigger | When to use |
|-------|---------|-------------|---------|-------------|
| brainstorming | `npx skills@latest add obra/superpowers --skill brainstorming -y` | Refines rough ideas through structured Q&A, explores alternatives, presents design in sections for validation. | `/brainstorming` | Before starting any new feature or design decision |
| writing-plans | `npx skills@latest add obra/superpowers --skill writing-plans -y` | Breaks approved designs into 2-5 minute tasks with exact file paths, complete code, and verification steps. | `/writing-plans` | After brainstorming, before writing any code |
| test-driven-development | `npx skills@latest add obra/superpowers --skill test-driven-development -y` | Enforces RED-GREEN-REFACTOR. Write failing test, watch it fail, write minimal code, commit. | `auto` on new code | When implementing any testable feature or function |
| systematic-debugging | `npx skills@latest add obra/superpowers --skill systematic-debugging -y` | Hypothesis-driven root cause analysis. Auto-triggers when errors are encountered. | `auto` on errors | When an error or unexpected behaviour is encountered |
| verification-before-completion | `npx skills@latest add obra/superpowers --skill verification-before-completion -y` | Auto-triggers before Claude marks work done. Runs a verification checklist. | `auto` before done | Before marking any task complete |
| requesting-code-review | `npx skills@latest add obra/superpowers --skill requesting-code-review -y` | Organises changes, writes clear PR descriptions, anticipates reviewer questions. | `/requesting-code-review` | When preparing a PR or seeking peer review |
| receiving-code-review | `npx skills@latest add obra/superpowers --skill receiving-code-review -y` | Handles incoming review feedback constructively and systematically. | `/receiving-code-review` | When processing reviewer comments on your PR |
| subagent-driven-development | `npx skills@latest add obra/superpowers --skill subagent-driven-development -y` | Dispatches a fresh sub-agent per task with two-stage review: spec compliance then code quality. | `/subagent-driven-development` | When running complex multi-step tasks with quality gates |
| dispatching-parallel-agents | `npx skills@latest add obra/superpowers --skill dispatching-parallel-agents -y` | Runs independent tasks in parallel across sub-agents for maximum throughput. | `/dispatching-parallel-agents` | When multiple independent tasks can run concurrently |
| using-git-worktrees | `npx skills@latest add obra/superpowers --skill using-git-worktrees -y` | Creates isolated Git workspaces per branch, enabling parallel feature development. | `/using-git-worktrees` | When working on multiple features simultaneously |
| finishing-a-development-branch | `npx skills@latest add obra/superpowers --skill finishing-a-development-branch -y` | End-of-branch workflow: final verification, PR preparation, merge-back steps. | `/finishing-a-development-branch` | When a feature branch is ready to ship |
| executing-plans | `npx skills@latest add obra/superpowers --skill executing-plans -y` | Executes implementation plans in batches with human checkpoints between phases. | `/executing-plans` | When running a multi-phase implementation plan |
| writing-skills | `npx skills@latest add obra/superpowers --skill writing-skills -y` | General technical writing quality skill. Auto-triggers when producing reports, specs, or docs. | `auto` on docs | When producing reports, specifications, or documentation |
| using-superpowers | `npx skills@latest add obra/superpowers --skill using-superpowers -y` | Bootstraps the full Superpowers methodology. Teaches Claude the brainstorm-plan-implement loop. | `/using-superpowers` | When onboarding to the Superpowers workflow for the first time |

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

| Skill | Install | Description | Trigger | When to use |
|-------|---------|-------------|---------|-------------|
| grill-me | `npx skills@latest add mattpocock/skills --skill grill-me -y` | Relentlessly interviews you about a plan until every decision branch is resolved. | `/grill-me` | When a plan has ambiguous assumptions that need surfacing |
| write-a-prd | `npx skills@latest add mattpocock/skills --skill write-a-prd -y` | Creates a PRD through interactive interview, codebase exploration, and module design. | `/write-a-prd` | When starting a new feature and need a structured requirements doc |
| prd-to-plan | `npx skills@latest add mattpocock/skills --skill prd-to-plan -y` | Converts a PRD into a multi-phase implementation plan using tracer-bullet vertical slices. | `/prd-to-plan` | After writing a PRD and ready to break it into phases |
| prd-to-issues | `npx skills@latest add mattpocock/skills --skill prd-to-issues -y` | Breaks a PRD into independently-grabbable GitHub issues using vertical slices. | `/prd-to-issues` | When decomposing a PRD into trackable GitHub issues |
| request-refactor-plan | `npx skills@latest add mattpocock/skills --skill request-refactor-plan -y` | Creates a detailed refactor plan with tiny commits via user interview. | `/request-refactor-plan` | Before refactoring complex or risky code sections |
| design-an-interface | `npx skills@latest add mattpocock/skills --skill design-an-interface -y` | Generates multiple radically different interface designs using parallel sub-agents. | `/design-an-interface` | When exploring multiple design directions in parallel |
| tdd | `npx skills@latest add mattpocock/skills --skill tdd -y` | TypeScript-focused TDD workflow with opinionated patterns and strict RED-GREEN-REFACTOR. | `/tdd` | When writing TypeScript with strict TDD discipline |
| setup-pre-commit | `npx skills@latest add mattpocock/skills --skill setup-pre-commit -y` | Sets up pre-commit hooks with lint, type-check, and test runs. | `/setup-pre-commit` | When initializing a new project's quality gates |
| git-guardrails-claude-code | `npx skills@latest add mattpocock/skills --skill git-guardrails-claude-code -y` | Installs hooks to block dangerous git commands: push, reset --hard, clean. | `/git-guardrails-claude-code` | When setting up safety nets against destructive git ops |
| write-a-skill | `npx skills@latest add mattpocock/skills --skill write-a-skill -y` | Opinionated skill authoring workflow with bundled resource patterns. | `/write-a-skill` | When authoring a new Claude skill from scratch |
| ubiquitous-language | `npx skills@latest add mattpocock/skills --skill ubiquitous-language -y` | Extracts a DDD-style ubiquitous language glossary from the current conversation. | `/ubiquitous-language` | When aligning team on domain terminology from a design discussion |
| obsidian-vault | `npx skills@latest add mattpocock/skills --skill obsidian-vault -y` | Search, create, and manage notes in an Obsidian vault with wikilinks. | `/obsidian-vault` | When storing or retrieving project notes in Obsidian |
| scaffold-exercises | `npx skills@latest add mattpocock/skills --skill scaffold-exercises -y` | Scaffolds coding exercises with solutions and test suites. | `/scaffold-exercises` | When creating coding exercises with automated test validation |

---

## GitHub — github/awesome-copilot

| Skill | Install | Description | Trigger | When to use |
|-------|---------|-------------|---------|-------------|
| git-commit | `npx skills@latest add github/awesome-copilot --skill git-commit -y` | Generates conventional commit messages from staged diff with scope detection. | `/git-commit` | Before every commit to generate a well-structured message |
| gh-cli | `npx skills@latest add github/awesome-copilot --skill gh-cli -y` | Automates GitHub CLI workflows: PR creation, issue management, release drafts. | `/gh-cli` | When managing PRs, issues, or releases via GitHub CLI |
| prd | `npx skills@latest add github/awesome-copilot --skill prd -y` | GitHub Copilot's PRD workflow for turning specs into tracked GitHub issues. | `/prd` | When converting a spec into tracked GitHub issues |
