# Testing & Code Quality

## Testing Frameworks

| Skill | Source | Scope | Install | Description | Trigger | When to use |
|-------|--------|-------|---------|-------------|---------|-------------|
| playwright-pro | alirezarezvani/claude-skills | `local` | `/plugin install playwright-pro@claude-code-skills` | Production Playwright testing: 55 templates, 3 agents, CI/CD integration, TestRail sync, BrowserStack, migration from Cypress/Selenium. | `/playwright-pro` | When building production-grade Playwright test suites |
| playwright-best-practices | currents-dev | `local` | `npx skills@latest add currents-dev/playwright-best-practices-skill --skill playwright-best-practices -y` | Playwright patterns: page objects, fixtures, parallel execution, visual regression, CI. | `/playwright-best-practices` | When applying Playwright patterns for page objects and visual regression |
| webapp-testing | anthropics/skills | `local` | `npx skills@latest add anthropics/skills --skill webapp-testing -y` | E2E web app testing strategies with browser automation and assertion patterns. | `/webapp-testing` | When designing E2E test strategies for a web application |
| api-test-suite-builder | alirezarezvani/claude-skills | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Automated API test generation: endpoint discovery, edge case coverage, contract testing. | `/api-test-suite-builder` | When generating comprehensive API tests with contract coverage |

---

## Testing Strategy — supercent-io/skills-template

| Skill | Scope | Install | Description | Trigger | When to use |
|-------|-------|---------|-------------|---------|-------------|
| backend-testing | `local` | `npx skills@latest add supercent-io/skills-template --skill backend-testing -y` | Backend test strategies: unit, integration, contract, and API testing patterns. | `/backend-testing` | When setting up or improving backend test coverage strategies |
| testing-strategies | `local` | `npx skills@latest add supercent-io/skills-template --skill testing-strategies -y` | Testing pyramid strategy: unit, integration, E2E ratios and tooling selection. | `/testing-strategies` | When planning test coverage ratios and tool selection for a project |

---

## Code Quality & Tech Debt

| Skill | Source | Scope | Install | Description | Trigger | When to use |
|-------|--------|-------|---------|-------------|---------|-------------|
| tech-debt-tracker | alirezarezvani/claude-skills | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Scans codebases for tech debt, scores severity, tracks trends over time, generates prioritized remediation plans. | `/tech-debt-tracker` | When auditing a codebase for tech debt severity and remediation priority |
| codebase-onboarding | alirezarezvani/claude-skills | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Generates onboarding guides for new developers joining a codebase: architecture overview, key patterns, setup steps. | `/codebase-onboarding` | When onboarding a new developer to an existing codebase |
| code-refactoring | supercent-io | `local` | `npx skills@latest add supercent-io/skills-template --skill code-refactoring -y` | Systematic refactoring: clean code principles, SOLID, progressive improvements. | `/code-refactoring` | When systematically improving code quality with SOLID principles |
| code-review | supercent-io | `local` | `npx skills@latest add supercent-io/skills-template --skill code-review -y` | Structured code review process: security, performance, maintainability checks. | `/code-review` | When conducting a structured code review across security and performance |
| debugging | supercent-io | `local` | `npx skills@latest add supercent-io/skills-template --skill debugging -y` | Systematic debugging approach with structured problem isolation techniques. | `/debugging` | When systematically isolating and resolving a bug |
