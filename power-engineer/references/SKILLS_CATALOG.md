# Power Engineer Skills Catalog

Complete reference of every skill available through the `power-engineer-setup`
skill. Organised by category. Each entry shows the source repo, install command,
recommended scope, and a brief description.

**Scope key:**
- `--global` — install once, available in every project
- `local` — install per-project (no flag), scoped to `.claude/skills/`)
- `plugin` — must be installed inside Claude Code via `/plugin` commands
- `built-in` — already available, no install needed

---

## 1. Core Methodology — obra/superpowers

Always recommended. These skills form a complete agentic development workflow
that auto-activates at each stage without manual invocation.

| Skill | Scope | Description |
|-------|-------|-------------|
| brainstorming | `--global` | Refines rough ideas through structured Q&A, explores alternatives, presents design in sections for validation. Auto-triggers before coding. |
| writing-plans | `--global` | Breaks approved designs into 2–5 minute tasks with exact file paths, complete code, and verification steps. |
| test-driven-development | `--global` | Enforces RED-GREEN-REFACTOR. Write failing test, watch it fail, write minimal code, commit. Auto-triggers during implementation. |
| systematic-debugging | `--global` | Hypothesis-driven root cause analysis. Auto-triggers when errors are encountered. |
| verification-before-completion | `--global` | Auto-triggers before Claude marks work done. Runs a verification checklist to catch regressions and missed requirements. |
| requesting-code-review | `--global` | Organises changes, writes clear PR descriptions, anticipates reviewer questions before submission. |
| receiving-code-review | `--global` | Handles incoming review feedback constructively and systematically. |
| subagent-driven-development | `--global` | Dispatches a fresh sub-agent per task with two-stage review: spec compliance first, then code quality. |
| dispatching-parallel-agents | `--global` | Runs independent tasks in parallel across sub-agents for maximum throughput. |
| using-git-worktrees | `--global` | Creates isolated Git workspaces per branch, enabling parallel feature development. |
| finishing-a-development-branch | `--global` | End-of-branch workflow: final verification, PR preparation, merge-back steps. |
| executing-plans | `--global` | Executes implementation plans in batches with human checkpoints between phases. |
| writing-skills | `--global` | General technical writing quality skill. Auto-triggers when producing reports, specs, or documentation. |
| using-superpowers | `--global` | Bootstraps the full Superpowers methodology. Teaches Claude the brainstorm → plan → implement loop. |

**Install all at once (via plugin — recommended):**
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

**Or install individually:**
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

## 2. Planning & Product — mattpocock/skills

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| grill-me | `--global` | `npx skills@latest add mattpocock/skills/grill-me --global` | Relentlessly interviews you about a plan or design until every branch of the decision tree is resolved. |
| write-a-prd | `--global` | `npx skills@latest add mattpocock/skills/write-a-prd --global` | Creates a PRD through an interactive interview, codebase exploration, and module design. Filed as a GitHub issue. |
| prd-to-plan | `--global` | `npx skills@latest add mattpocock/skills/prd-to-plan --global` | Converts a PRD into a multi-phase implementation plan using tracer-bullet vertical slices. |
| prd-to-issues | `--global` | `npx skills@latest add mattpocock/skills/prd-to-issues --global` | Breaks a PRD into independently-grabbable GitHub issues using vertical slices. |
| request-refactor-plan | `--global` | `npx skills@latest add mattpocock/skills/request-refactor-plan --global` | Creates a detailed refactor plan with tiny commits via user interview, then files it as a GitHub issue. |
| design-an-interface | `local` | `npx skills@latest add mattpocock/skills/design-an-interface` | Generates multiple radically different interface designs for a module using parallel sub-agents. |
| tdd | `local` | `npx skills@latest add mattpocock/skills/tdd` | TypeScript-focused TDD workflow with opinionated patterns and strict RED-GREEN-REFACTOR cycle. |
| setup-pre-commit | `--global` | `npx skills@latest add mattpocock/skills/setup-pre-commit --global` | Sets up pre-commit hooks with lint, type-check, and test runs. |
| git-guardrails-claude-code | `--global` | `npx skills@latest add mattpocock/skills/git-guardrails-claude-code --global` | Installs Claude Code hooks to block dangerous git commands: push, reset --hard, clean. |
| write-a-skill | `--global` | `npx skills@latest add mattpocock/skills/write-a-skill --global` | Opinionated skill authoring workflow with bundled resource patterns. |
| ubiquitous-language | `local` | `npx skills@latest add mattpocock/skills/ubiquitous-language` | Extracts a DDD-style ubiquitous language glossary from the current conversation. |
| obsidian-vault | `local` | `npx skills@latest add mattpocock/skills/obsidian-vault` | Search, create, and manage notes in an Obsidian vault with wikilinks and index notes. |
| scaffold-exercises | `local` | `npx skills@latest add mattpocock/skills/scaffold-exercises` | Scaffolds coding exercises with solutions and test suites. |

---

## 3. Anthropic Official — anthropics/skills

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| skill-creator | `--global` | `npx skills@latest add anthropics/skills/skill-creator --global` | Anthropic's official skill authoring guide. Creates SKILL.md with progressive disclosure patterns. |
| mcp-builder | `--global` | `npx skills@latest add anthropics/skills/mcp-builder --global` | Builds MCP servers from scratch: tool schema design, transport config, auth, deployment. |
| frontend-design | `--global` | `npx skills@latest add anthropics/skills/frontend-design --global` | Production-grade UI skill. Creates distinctive, accessible frontend interfaces. |
| pdf | `--global` | `npx skills@latest add anthropics/skills/pdf --global` | PDF manipulation: text extraction, merging, splitting, form filling, OCR, watermarks. |
| docx | `--global` | `npx skills@latest add anthropics/skills/docx --global` | Creates and edits Word documents with headers, tables, tracked changes, and formatting. |
| pptx | `--global` | `npx skills@latest add anthropics/skills/pptx --global` | Builds polished PowerPoint presentations with layouts, speaker notes, and theme consistency. |
| xlsx | `--global` | `npx skills@latest add anthropics/skills/xlsx --global` | Creates and manipulates Excel spreadsheets with formulas, pivot tables, formatted data. |
| webapp-testing | `local` | `npx skills@latest add anthropics/skills/webapp-testing` | E2E web app testing strategies with browser automation and assertion patterns. |
| canvas-design | `--global` | `npx skills@latest add anthropics/skills/canvas-design --global` | HTML canvas design skill for generative art and interactive visualisations. |
| algorithmic-art | `local` | `npx skills@latest add anthropics/skills/algorithmic-art` | Creates algorithmic and generative art using code. |
| brand-guidelines | `--global` | `npx skills@latest add anthropics/skills/brand-guidelines --global` | Applies brand colours, typography, and style guidelines to artifacts. |
| internal-comms | `--global` | `npx skills@latest add anthropics/skills/internal-comms --global` | Writes internal communications: status reports, newsletters, FAQs. |

---

## 4. GitHub — github/awesome-copilot

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| git-commit | `--global` | `npx skills@latest add github/awesome-copilot/git-commit --global` | Generates conventional commit messages from staged diff with scope detection. |
| gh-cli | `--global` | `npx skills@latest add github/awesome-copilot/gh-cli --global` | Automates GitHub CLI workflows: PR creation, issue management, release drafts. |
| prd | `--global` | `npx skills@latest add github/awesome-copilot/prd --global` | GitHub Copilot's PRD workflow for turning specs into tracked GitHub issues and milestones. |

---

## 5. Architecture & Backend — wshobson/agents

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| api-design-principles | `local` | `npx skills@latest add wshobson/agents/api-design-principles` | REST API design: naming conventions, versioning, error handling, response shaping, hypermedia. |
| typescript-advanced-types | `local` | `npx skills@latest add wshobson/agents/typescript-advanced-types` | Advanced TypeScript: conditional types, mapped types, template literals, type-level programming. |
| nodejs-backend-patterns | `local` | `npx skills@latest add wshobson/agents/nodejs-backend-patterns` | Production Node.js patterns: middleware, error handling, DI, module structure. |
| python-performance-optimization | `local` | `npx skills@latest add wshobson/agents/python-performance-optimization` | Python profiling, vectorisation, memory management, async patterns for compute-heavy workloads. |
| tailwind-design-system | `local` | `npx skills@latest add wshobson/agents/tailwind-design-system` | Tailwind-based design system: tokens, variants, responsive utilities, component APIs. |

---

## 6. Engineering Templates — supercent-io/skills-template

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| security-best-practices | `--global` | `npx skills@latest add supercent-io/skills-template/security-best-practices --global` | OWASP-aligned: auth, input validation, secrets management, dependency auditing. |
| data-analysis | `local` | `npx skills@latest add supercent-io/skills-template/data-analysis` | Data exploration, statistical analysis, and visualisation patterns in Python/R. |
| technical-writing | `--global` | `npx skills@latest add supercent-io/skills-template/technical-writing --global` | Docs standards: clarity, structure, audience targeting, doc testing frameworks. |
| api-documentation | `local` | `npx skills@latest add supercent-io/skills-template/api-documentation` | OpenAPI/Swagger-aligned API docs with examples, error catalogs, changelog conventions. |
| code-review | `local` | `npx skills@latest add supercent-io/skills-template/code-review` | Structured code review process: security, performance, maintainability checks. |
| code-refactoring | `local` | `npx skills@latest add supercent-io/skills-template/code-refactoring` | Systematic refactoring: clean code principles, SOLID, progressive improvements. |
| database-schema-design | `local` | `npx skills@latest add supercent-io/skills-template/database-schema-design` | Relational and NoSQL schema design, normalisation, indexing, migration patterns. |
| debugging | `local` | `npx skills@latest add supercent-io/skills-template/debugging` | Systematic debugging approach with structured problem isolation techniques. |
| backend-testing | `local` | `npx skills@latest add supercent-io/skills-template/backend-testing` | Backend test strategies: unit, integration, contract, and API testing patterns. |
| performance-optimization | `local` | `npx skills@latest add supercent-io/skills-template/performance-optimization` | Performance audit: caching, lazy loading, algorithmic complexity, bottleneck identification. |
| deployment-automation | `local` | `npx skills@latest add supercent-io/skills-template/deployment-automation` | CI/CD pipeline design, automated deployment, rollback strategies. |
| testing-strategies | `local` | `npx skills@latest add supercent-io/skills-template/testing-strategies` | Testing pyramid strategy: unit, integration, E2E ratios and tooling selection. |
| authentication-setup | `local` | `npx skills@latest add supercent-io/skills-template/authentication-setup` | Auth implementation: OAuth, JWT, session management, MFA patterns. |
| git-workflow | `--global` | `npx skills@latest add supercent-io/skills-template/git-workflow --global` | Git branching strategies, commit conventions, rebase vs merge policies. |
| task-planning | `--global` | `npx skills@latest add supercent-io/skills-template/task-planning --global` | Breaks complex features into granular, prioritised, time-estimated tasks. |
| codebase-search | `local` | `npx skills@latest add supercent-io/skills-template/codebase-search` | Strategies for navigating and understanding unfamiliar codebases quickly. |
| monitoring-observability | `local` | `npx skills@latest add supercent-io/skills-template/monitoring-observability` | Structured logging, metrics, distributed tracing, alerting instrumentation. |
| changelog-maintenance | `--global` | `npx skills@latest add supercent-io/skills-template/changelog-maintenance --global` | Maintains structured changelogs following Keep a Changelog conventions. |
| log-analysis | `local` | `npx skills@latest add supercent-io/skills-template/log-analysis` | Parses and analyses log output to surface patterns, errors, and anomalies. |
| ui-component-patterns | `local` | `npx skills@latest add supercent-io/skills-template/ui-component-patterns` | Component composition patterns, compound components, headless UI strategies. |
| responsive-design | `local` | `npx skills@latest add supercent-io/skills-template/responsive-design` | Mobile-first responsive layouts, breakpoint strategy, fluid typography. |
| web-accessibility | `local` | `npx skills@latest add supercent-io/skills-template/web-accessibility` | WCAG 2.2 compliance, ARIA patterns, keyboard navigation, screen reader testing. |
| file-organization | `local` | `npx skills@latest add supercent-io/skills-template/file-organization` | Project file structure conventions and organisation strategies. |
| user-guide-writing | `local` | `npx skills@latest add supercent-io/skills-template/user-guide-writing` | End-user documentation: clarity, step-by-step instructions, visual aids. |
| api-design | `local` | `npx skills@latest add supercent-io/skills-template/api-design` | API design from first principles: consistency, discoverability, backwards compatibility. |

---

## 7. Vercel — agent-skills, next-skills, turborepo, ai

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| web-design-guidelines | `local` | `npx skills@latest add vercel-labs/agent-skills/web-design-guidelines` | Vercel's comprehensive web design system guidelines: layout, spacing, typography, accessibility. |
| vercel-react-best-practices | `local` | `npx skills@latest add vercel-labs/agent-skills/vercel-react-best-practices` | React component architecture, performance, server components, data fetching patterns. |
| vercel-composition-patterns | `local` | `npx skills@latest add vercel-labs/agent-skills/vercel-composition-patterns` | Advanced React composition: render props, compound components, context patterns. |
| vercel-react-native-skills | `local` | `npx skills@latest add vercel-labs/agent-skills/vercel-react-native-skills` | React Native: platform patterns, navigation, gestures, native modules, performance. |
| deploy-to-vercel | `local` | `npx skills@latest add vercel-labs/agent-skills/deploy-to-vercel` | Vercel deployment: project setup, environment variables, preview deployments, edge config. |
| next-best-practices | `local` | `npx skills@latest add vercel-labs/next-skills/next-best-practices` | Next.js best practices: App Router, RSC, layouts, metadata, fonts, images, deployment. |
| next-cache-components | `local` | `npx skills@latest add vercel-labs/next-skills/next-cache-components` | Next.js caching strategies, revalidation, partial prerendering, streaming. |
| agent-browser | `local` | `npx skills@latest add vercel-labs/agent-browser/agent-browser` | Vercel browser agent: navigates, interacts with, and extracts content from live websites. |
| ai-sdk | `local` | `npx skills@latest add vercel/ai/ai-sdk` | Vercel AI SDK: streaming, tool calling, multi-step agents, model switching, edge deployment. |
| turborepo | `local` | `npx skills@latest add vercel/turborepo/turborepo` | Turborepo monorepo patterns: caching, pipeline config, remote caching, workspace management. |

---

## 8. AI / LLM Engineering — inferen-sh/skills

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| python-sdk | `local` | `npx skills@latest add inferen-sh/skills/python-sdk` | Anthropic Python SDK: async usage, streaming, tool use, batch processing best practices. |
| javascript-sdk | `local` | `npx skills@latest add inferen-sh/skills/javascript-sdk` | Anthropic JS/TS SDK: client setup, error handling, token management, streaming patterns. |
| chat-ui | `local` | `npx skills@latest add inferen-sh/skills/chat-ui` | Production chat UI: streaming responses, message history, tool call rendering, error states. |
| agent-ui | `local` | `npx skills@latest add inferen-sh/skills/agent-ui` | Agent-specific UI: tool use visualisation, step tracking, human approval flows. |
| tools-ui | `local` | `npx skills@latest add inferen-sh/skills/tools-ui` | UI patterns for rendering tool calls, results, and intermediate agent steps in real time. |
| widgets-ui | `local` | `npx skills@latest add inferen-sh/skills/widgets-ui` | Embeddable widget patterns for AI-powered components within larger applications. |
| web-search | `local` | `npx skills@latest add inferen-sh/skills/web-search` | Structured web search integration pattern for grounding AI responses in current information. |
| python-executor | `local` | `npx skills@latest add inferen-sh/skills/python-executor` | Safe Python code execution within agent sessions for data processing and computation. |
| agent-browser | `local` | `npx skills@latest add inferen-sh/skills/agent-browser` | Browser automation from within agent sessions: navigation, extraction, interaction. |
| ai-image-generation | `local` | `npx skills@latest add inferen-sh/skills/ai-image-generation` | AI image generation patterns: prompt engineering, model selection, output handling. |
| elevenlabs-tts | `local` | `npx skills@latest add inferen-sh/skills/elevenlabs-tts` | ElevenLabs text-to-speech integration: voice selection, streaming audio, multilingual. |
| elevenlabs-music | `local` | `npx skills@latest add inferen-sh/skills/elevenlabs-music` | ElevenLabs music generation: sound effects, background scores, audio export. |

---

## 9. Agentic Patterns — charon-fan/agent-playbook

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| self-improving-agent | `local` | `npx skills@latest add charon-fan/agent-playbook/self-improving-agent` | Implements a self-improvement loop where the agent iteratively refines its own outputs. |

---

## 10. Data & Research

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| firecrawl | firecrawl/cli | `local` | `npx skills@latest add firecrawl/cli/firecrawl` | Web crawl and structure data from any URL for research pipelines and RAG. |
| search | tavily-ai/skills | `--global` | `npx skills@latest add tavily-ai/skills/search --global` | Tavily real-time search with structured result extraction for AI-grounded research. |

---

## 11. Testing

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| playwright-best-practices | currents-dev | `local` | `npx skills@latest add currents-dev/playwright-best-practices-skill/playwright-best-practices` | Playwright patterns: page objects, fixtures, parallel execution, visual regression, CI. |

---

## 12. Cloud & Infrastructure — Microsoft Azure

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| azure-ai | `local` | `npx skills@latest add microsoft/github-copilot-for-azure/azure-ai` | Azure AI Services: Cognitive Services, OpenAI on Azure, AI Search, model deployment. |
| azure-observability | `local` | `npx skills@latest add microsoft/github-copilot-for-azure/azure-observability` | Monitoring AI workloads: token usage tracking, latency dashboards, cost attribution. |
| azure-compute | `local` | `npx skills@latest add microsoft/github-copilot-for-azure/azure-compute` | Azure VM, container, and serverless compute patterns and sizing guidance. |
| azure-postgres | `local` | `npx skills@latest add microsoft/github-copilot-for-azure/azure-postgres` | Azure Database for PostgreSQL: setup, scaling, connection pooling, migration. |
| azure-cloud-migrate | `local` | `npx skills@latest add microsoft/github-copilot-for-azure/azure-cloud-migrate` | Cloud migration strategy, assessment, and lift-and-shift patterns for Azure. |
| azure-hosted-copilot-sdk | `local` | `npx skills@latest add microsoft/github-copilot-for-azure/azure-hosted-copilot-sdk` | Azure-hosted Copilot SDK: extensions, plugins, and custom copilot integration. |
| microsoft-foundry | `local` | `npx skills@latest add microsoft/azure-skills/microsoft-foundry` | Azure AI Foundry: model fine-tuning, evaluation pipelines, production serving. |
| azure-quotas | `local` | `npx skills@latest add microsoft/azure-skills/azure-quotas` | Azure quota management, increase requests, and capacity planning. |
| azure-upgrade | `local` | `npx skills@latest add microsoft/azure-skills/azure-upgrade` | Azure service upgrades, deprecation handling, and migration paths. |

---

## 13. Databases

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| neon-postgres | neondatabase/agent-skills | `local` | `npx skills@latest add neondatabase/agent-skills/neon-postgres` | Neon serverless Postgres: branching, vector search with pgvector, edge deployment. |
| supabase-postgres-best-practices | supabase/agent-skills | `local` | `npx skills@latest add supabase/agent-skills/supabase-postgres-best-practices` | Supabase Postgres: RLS, realtime subscriptions, storage, edge functions, AI integrations. |
| better-auth-best-practices | better-auth/skills | `local` | `npx skills@latest add better-auth/skills/better-auth-best-practices` | Better Auth library patterns: session management, OAuth providers, multi-tenancy. |

---

## 14. Design — Google Stitch

Requires the Stitch MCP server to be configured. Enables text/sketch → high-fidelity
UI → production React/Tailwind code via Gemini 2.5 Pro.

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| stitch-loop | `--global` | `npx skills add google-labs-code/stitch-skills --skill stitch-loop --global` | Generates a complete multi-page website from a single prompt. |
| enhance-prompt | `--global` | `npx skills add google-labs-code/stitch-skills --skill enhance-prompt --global` | Transforms vague UI ideas into Stitch-optimised prompts with design system context. |
| react:components | `--global` | `npx skills add google-labs-code/stitch-skills --skill react:components --global` | Converts Stitch screens into React component systems with design token consistency. |
| design-md | `--global` | `npx skills add google-labs-code/stitch-skills --skill design-md --global` | Analyses Stitch projects and generates DESIGN.md files in semantic language. |
| shadcn-ui (stitch) | `--global` | `npx skills add google-labs-code/stitch-skills --skill shadcn-ui --global` | Stitch-aligned shadcn/ui integration for React applications. |
| remotion | `--global` | `npx skills add google-labs-code/stitch-skills --skill remotion --global` | Generates walkthrough videos from Stitch projects via Remotion with transitions and zoom. |

**Install all Stitch skills at once:**
```bash
npx skills add google-labs-code/stitch-skills --all --global
```

---

## 15. Design — Frontend

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| web-design-guidelines | vercel-labs/agent-skills | `local` | `npx skills@latest add vercel-labs/agent-skills/web-design-guidelines` | Comprehensive web design guidelines: layout, spacing, typography, accessibility. |
| tailwind-design-system | wshobson/agents | `local` | `npx skills@latest add wshobson/agents/tailwind-design-system` | Tailwind design system: tokens, variants, responsive utilities, component APIs. |
| shadcn | shadcn/ui | `local` | `npx skills@latest add shadcn/ui/shadcn` | Official shadcn/ui skill: component discovery, installation, customisation, composition. |
| platform-design-skills | ehmo | `local` | `npx skills@latest add ehmo/platform-design-skills/platform-design-skills` | 300+ design rules from Apple HIG, Material Design 3, and WCAG 2.2 for cross-platform apps. |
| ui-component-patterns | supercent-io | `local` | `npx skills@latest add supercent-io/skills-template/ui-component-patterns` | Component composition patterns, compound components, headless UI strategies. |
| responsive-design | supercent-io | `local` | `npx skills@latest add supercent-io/skills-template/responsive-design` | Mobile-first responsive layouts, breakpoint strategy, fluid typography. |
| web-accessibility | supercent-io | `local` | `npx skills@latest add supercent-io/skills-template/web-accessibility` | WCAG 2.2 compliance, ARIA, keyboard navigation, screen reader testing. |

---

## 16. Design — pbakaus/impeccable

A suite of focused design refinement skills for iterating on UI quality.

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| frontend-design (impeccable) | `local` | `npx skills@latest add pbakaus/impeccable/frontend-design` | Impeccable's opinionated frontend design principles: bold, distinctive, non-generic UI. |
| polish | `local` | `npx skills@latest add pbakaus/impeccable/polish` | Refines rough UI into polished, production-ready output. |
| critique | `local` | `npx skills@latest add pbakaus/impeccable/critique` | Provides structured, honest critique of UI/UX decisions. |
| adapt | `local` | `npx skills@latest add pbakaus/impeccable/adapt` | Adapts design to different contexts, devices, or audiences. |
| clarify | `local` | `npx skills@latest add pbakaus/impeccable/clarify` | Removes visual noise and improves hierarchy and clarity. |
| audit | `local` | `npx skills@latest add pbakaus/impeccable/audit` | Audits existing UI against design principles and identifies issues. |
| animate | `local` | `npx skills@latest add pbakaus/impeccable/animate` | Adds purposeful motion and animation to UI components. |
| bolder | `local` | `npx skills@latest add pbakaus/impeccable/bolder` | Makes UI more decisive, confident, and visually assertive. |
| delight | `local` | `npx skills@latest add pbakaus/impeccable/delight` | Adds delightful micro-interactions and surprise moments. |
| distill | `local` | `npx skills@latest add pbakaus/impeccable/distill` | Reduces a design to its essential elements; removes everything unnecessary. |
| extract | `local` | `npx skills@latest add pbakaus/impeccable/extract` | Extracts reusable design patterns and tokens from existing UI. |
| onboard | `local` | `npx skills@latest add pbakaus/impeccable/onboard` | Designs clear, effective onboarding experiences. |
| harden | `local` | `npx skills@latest add pbakaus/impeccable/harden` | Makes UI resilient: empty states, error states, loading states, edge cases. |
| quieter | `local` | `npx skills@latest add pbakaus/impeccable/quieter` | Reduces visual noise; moves UI toward calm, focused, minimal. |

---

## 17. Mobile Development — Expo

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| building-native-ui | `local` | `npx skills@latest add expo/skills/building-native-ui` | Platform-specific native UI components, animations, accessibility. |
| native-data-fetching | `local` | `npx skills@latest add expo/skills/native-data-fetching` | Data fetching patterns for React Native: caching, background sync, offline support. |
| upgrading-expo | `local` | `npx skills@latest add expo/skills/upgrading-expo` | Expo SDK upgrade process, breaking change navigation, migration checklist. |
| expo-tailwind-setup | `local` | `npx skills@latest add expo/skills/expo-tailwind-setup` | NativeWind/Tailwind setup in Expo projects with theme configuration. |
| expo-cicd-workflows | `local` | `npx skills@latest add expo/skills/expo-cicd-workflows` | EAS Build, EAS Submit, and GitHub Actions CI/CD for Expo apps. |
| expo-api-routes | `local` | `npx skills@latest add expo/skills/expo-api-routes` | Expo Router API routes: server functions, middleware, and edge deployment. |
| expo-dev-client | `local` | `npx skills@latest add expo/skills/expo-dev-client` | Custom dev client setup: native modules, splash screen, app config. |
| expo-deployment | `local` | `npx skills@latest add expo/skills/expo-deployment` | App Store and Google Play submission via EAS Submit. |

---

## 18. Mobile Development — SwiftUI / iOS

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| swiftui-expert-skill | avdlee/swiftui-agent-skill | `local` | `npx skills@latest add avdlee/swiftui-agent-skill/swiftui-expert-skill` | Modern SwiftUI + iOS 26 Liquid Glass: views, data flow, animations, best practices. |

---

## 19. Vue / Vite

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| vue-best-practices | hyf0/vue-skills | `local` | `npx skills@latest add hyf0/vue-skills/vue-best-practices` | Vue 3 composition API, Pinia, reactivity system, performance patterns. |
| vue | antfu/skills | `local` | `npx skills@latest add antfu/skills/vue` | Anthony Fu's Vue skill: opinionated Vue patterns, composables, ecosystem. |
| vite | antfu/skills | `local` | `npx skills@latest add antfu/skills/vite` | Vite configuration, plugins, SSR, optimisation, and ecosystem. |

---

## 20. Meta / Skill Creation

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| skill-creator | anthropics/skills | `--global` | `npx skills@latest add anthropics/skills/skill-creator --global` | Official Anthropic skill authoring guide with progressive disclosure patterns. |
| mcp-builder | anthropics/skills | `--global` | `npx skills@latest add anthropics/skills/mcp-builder --global` | Builds MCP servers from scratch: tool schema, transport config, auth, deployment. |
| write-a-skill | mattpocock/skills | `--global` | `npx skills@latest add mattpocock/skills/write-a-skill --global` | Matt Pocock's opinionated skill authoring workflow with bundled resource patterns. |

---

## 21. Power Suites (Plugin-based)

These are installed inside Claude Code via `/plugin` commands, not the terminal.

---

### GSD — Get Shit Done

**What it is:** The most complete solo-developer context engineering system.
Deep questioning → domain research → requirements → phased roadmap → atomic
execution → goal-backward verification → PR. Installs `.planning/` directory,
`SPEC.md`, `STATE.md`, and per-phase plan/verify/UAT artifacts.

**Best for:** Greenfield projects, solo developers, structured shipping.

**Install via terminal:**
```bash
npx get-shit-done-cc --claude --global
```

**Or via skills-based install:**
```bash
npx skills add ctsstc/get-shit-done-skills --skill gsd
```

**Commands:** `/gsd:discuss-phase`, `/gsd:plan-phase`, `/gsd:execute-phase`,
`/gsd:verify-work`, `/gsd:ship`, `/gsd:map-codebase`

---

### Superpowers by obra

**What it is:** A complete software development methodology built on composable
skills. Auto-triggers brainstorm → write-plan → subagent-driven-development →
TDD → verify at every stage. 20+ battle-tested skills. Invisible until you
realise your agent stopped rushing and started thinking.

**Install inside Claude Code:**
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
/plugin update superpowers
```

**Commands:** `/superpowers:brainstorm`, `/superpowers:write-plan`,
`/superpowers:execute-plan` + 17 auto-activating skills.

---

### UI/UX Pro Max

**What it is:** The most comprehensive design intelligence skill available.
50+ UI styles, 97 colour palettes, 57 font pairings, 99 UX guidelines, 25 chart
types across 9 tech stacks: React, Next.js, Vue, Svelte, Flutter, SwiftUI,
shadcn/ui, Jetpack Compose, HTML+Tailwind. Auto-activates on any UI/UX request
with a full design system reasoning engine.

**Install inside Claude Code:**
```
/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
/plugin install ui-ux-pro-max@ui-ux-pro-max-skill
```

**Or via CLI:**
```bash
npm install -g uipro-cli && uipro init --ai claude
```

---

### Designer Skills Collection — 63 skills + 27 commands

**What it is:** 63 design skills and 27 commands across 8 plugin categories by
Owl-Listener: UX Research, Design Systems, Strategy, UI, Interaction Design,
Prototyping & Testing, Design Ops, Designer Toolkit.

**Commands include:** `/discover` (full research discovery cycle),
`/strategize` (UX strategy from vision to metrics), `/handoff` (developer
handoff package with measurements, behaviours, edge cases, QA checklist),
`/write-case-study`, and 23 more.

**Install inside Claude Code:**
```
/plugin marketplace add Owl-Listener/designer-skills
```
Then browse with `/plugin` and install individual plugin categories.

---

### Google Stitch Skills (npx-based)

**What it is:** Official Google Labs skills for the Stitch MCP server. Transform
text descriptions or sketches → high-fidelity interfaces → production
React/Tailwind code via Gemini 2.5 Pro. Requires Stitch MCP server configured.

**Install all:**
```bash
npx skills add google-labs-code/stitch-skills --all --global
```

**Or individually:**
```bash
npx skills add google-labs-code/stitch-skills --skill stitch-loop --global
npx skills add google-labs-code/stitch-skills --skill enhance-prompt --global
npx skills add google-labs-code/stitch-skills --skill react:components --global
npx skills add google-labs-code/stitch-skills --skill design-md --global
npx skills add google-labs-code/stitch-skills --skill shadcn-ui --global
npx skills add google-labs-code/stitch-skills --skill remotion --global
```

---

### Pencil — Built-in, no install needed

**What it is:** Pencil is a native design tool already integrated into Claude's
environment. Works with `.pen` design files directly in VS Code via the Pencil
companion extension. No skill install required.

**Available tools Claude can call:**
- `pencil:batch_design` — execute multiple design operations in one call
- `pencil:open_document` — open a `.pen` file
- `pencil:get_style_guide` — retrieve design guidelines for a given style
- `pencil:get_style_guide_tags` — list available style guide tags
- `pencil:get_variables` — get variables and themes defined in a file
- `pencil:set_variables` — update variables and themes
- `pencil:batch_get` — retrieve nodes by pattern or ID
- `pencil:export_nodes` — export nodes to PNG/JPEG/WEBP/PDF
- `pencil:find_empty_space_on_canvas` — find empty space for new content
- `pencil:get_editor_state` — get current canvas and selection state
- `pencil:replace_all_matching_properties` — bulk property replacement
- `pencil:search_all_unique_properties` — search property values across nodes
- `pencil:snapshot_layout` — check current layout structure
- `pencil:get_screenshot` — capture current canvas state

**VS Code setup:** Search "Pencil" in the Extension Marketplace and install
the companion extension. Then open or create `.pen` files in your project.

---

## 22. Extras from the Community

Additional useful skills identified across curated lists.

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| better-auth-best-practices | better-auth/skills | `local` | `npx skills@latest add better-auth/skills/better-auth-best-practices` | Better Auth library: sessions, OAuth, multi-tenancy, TypeScript-first patterns. |
| browser-use | browser-use/browser-use | `local` | `npx skills@latest add browser-use/browser-use/browser-use` | Browser automation for agents: navigation, form filling, extraction, screenshot. |
| supabase-postgres-best-practices | supabase/agent-skills | `local` | `npx skills@latest add supabase/agent-skills/supabase-postgres-best-practices` | Supabase Postgres: RLS, realtime, storage, edge functions, AI vector extensions. |
| playwright-best-practices | currents-dev | `local` | `npx skills@latest add currents-dev/playwright-best-practices-skill/playwright-best-practices` | Playwright testing: page objects, fixtures, parallel execution, CI integration. |
| algorithmic-art | anthropics/skills | `local` | `npx skills@latest add anthropics/skills/algorithmic-art` | Algorithmic and generative art using creative coding patterns. |
| turborepo | vercel/turborepo | `local` | `npx skills@latest add vercel/turborepo/turborepo` | Turborepo monorepo: caching, pipeline config, remote caching, workspace management. |

---

## Quick install reference by role

### Minimum viable SWE setup
```bash
npx skills@latest add obra/superpowers/brainstorming --global
npx skills@latest add obra/superpowers/test-driven-development --global
npx skills@latest add obra/superpowers/systematic-debugging --global
npx skills@latest add mattpocock/skills/grill-me --global
npx skills@latest add anthropics/skills/skill-creator --global
npx skills@latest add github/awesome-copilot/git-commit --global
```

### Minimum viable AI Engineer setup
```bash
npx skills@latest add anthropics/skills/mcp-builder --global
npx skills@latest add vercel/ai/ai-sdk
npx skills@latest add inferen-sh/skills/python-sdk
npx skills@latest add obra/superpowers/subagent-driven-development --global
npx skills@latest add tavily-ai/skills/search --global
npx skills@latest add charon-fan/agent-playbook/self-improving-agent
```

### Minimum viable R&D setup
```bash
npx skills@latest add anthropics/skills/docx --global
npx skills@latest add anthropics/skills/pptx --global
npx skills@latest add anthropics/skills/pdf --global
npx skills@latest add supercent-io/skills-template/technical-writing --global
npx skills@latest add tavily-ai/skills/search --global
npx skills@latest add firecrawl/cli/firecrawl
npx skills@latest add mattpocock/skills/write-a-prd --global
```

---

*Total skills catalogued: 130+*
*Last updated: March 2026*
*Repository: github.com/[your-username]/power-engineer-skills*
