# Scanner Module

Analyzes the target project's codebase to produce a ProjectProfile. This module
runs FIRST in every flow. Its output drives the Adaptive Questionnaire (which
questions to skip) and the Skill Resolver (which skills to recommend).

## How to scan

Run the following checks in order. Record all findings as the ProjectProfile.

### 1. Package manager & language detection

```bash
# Check for Node.js/TypeScript
cat package.json 2>/dev/null
cat tsconfig.json 2>/dev/null

# Check for Python
cat pyproject.toml 2>/dev/null
cat requirements.txt 2>/dev/null
cat setup.py 2>/dev/null
```

**Record:**
- `language`: "typescript", "python", "both", or "unknown"
- `package_manager`: "npm", "yarn", "pnpm", "pip", "poetry", or "unknown"

### 2. Framework detection

| Check for file/dependency | Framework detected |
|--------------------------|-------------------|
| `next.config.*` or `next` in package.json deps | Next.js |
| `react` in deps (no next) | React (standalone) |
| `nuxt.config.*` or `nuxt` in deps | Nuxt |
| `vue` in deps (no nuxt) | Vue |
| `vite.config.*` | Vite (check deps for React vs Vue) |
| `express` or `fastify` or `hono` in deps | Node.js backend (specify which) |
| `fastapi` or `flask` or `django` in Python deps | Python backend (specify which) |
| `app.json` or `expo` in deps | Expo / React Native |
| `*.xcodeproj` or `Package.swift` | SwiftUI / iOS |

```bash
# Check framework config files
ls next.config.* nuxt.config.* vite.config.* app.json 2>/dev/null
# Check for Xcode project
ls *.xcodeproj 2>/dev/null
ls Package.swift 2>/dev/null
```

**Record:** `framework`: detected framework name or "none"

### 3. SDK detection

Check package.json dependencies and pyproject.toml for:
- `@anthropic-ai/sdk` -> Anthropic JS/TS SDK
- `ai` (from vercel) -> Vercel AI SDK
- `anthropic` (Python) -> Anthropic Python SDK

**Record:** `sdks`: list of detected SDKs

### 4. Infrastructure detection

```bash
# Docker
ls Dockerfile docker-compose.yml docker-compose.yaml 2>/dev/null

# Terraform
ls -d terraform/ 2>/dev/null
ls *.tf 2>/dev/null

# CI/CD
ls -d .github/workflows/ 2>/dev/null
ls .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null | wc -l
```

**Record:**
- `has_docker`: true/false
- `has_terraform`: true/false
- `has_ci_cd`: true/false
- `ci_workflow_count`: number

### 5. Cloud / database detection

Check package.json / pyproject.toml for:
- `@supabase/supabase-js` or `supabase` -> Supabase
- `@neondatabase/serverless` or `neon` -> Neon
- `@azure/*` -> Azure

**Record:** `cloud_database`: list of detected providers

### 6. Brand & design detection

```bash
# Tailwind config
cat tailwind.config.* 2>/dev/null | head -50

# CSS custom properties (look for brand tokens)
grep -r '--brand\|--color-primary\|--font-' src/ app/ styles/ 2>/dev/null | head -20

# Logo files
ls -d public/logo* public/brand* assets/logo* assets/brand* 2>/dev/null

# Design tokens
ls design-tokens.* tokens.json .stitch/ 2>/dev/null
```

**Record:**
- `has_tailwind`: true/false
- `tailwind_custom_tokens`: extracted color/font tokens if present
- `has_brand_assets`: true/false
- `brand_files`: list of detected brand files
- `has_design_tokens`: true/false

### 7. Existing setup detection

```bash
# Existing CLAUDE.md
cat CLAUDE.md 2>/dev/null | head -5

# Power engineer state (re-run detection)
cat .power-engineer/state.json 2>/dev/null

# Already-installed skills
ls .claude/skills/ .agents/skills/ 2>/dev/null
cat skills-lock.json 2>/dev/null
```

**Record:**
- `has_claude_md`: true/false
- `has_power_engineer_state`: true/false (if true, this is a RE-RUN)
- `installed_skills`: list of already-installed skill names
- `is_rerun`: true if `.power-engineer/state.json` exists

### 8. Project maturity & team size

```bash
# Team size from git log (unique authors in last 6 months)
git log --since="6 months ago" --format="%aN" 2>/dev/null | sort -u | wc -l

# Project age (first commit date)
git log --reverse --format="%ci" 2>/dev/null | head -1

# Codebase size estimate
find . -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' -o -name '*.py' 2>/dev/null | wc -l

# Monorepo detection
ls -d packages/ apps/ services/ 2>/dev/null
cat pnpm-workspace.yaml lerna.json 2>/dev/null
```

**Record:**
- `team_size`: number of unique git authors (last 6 months)
- `project_age_months`: estimated months since first commit
- `source_file_count`: approximate number of source files
- `is_monorepo`: true/false
- `package_count`: number of packages (if monorepo)

### 9. Output: ProjectProfile

After running all checks, summarize findings as a structured ProjectProfile:

```
ProjectProfile:
  language: [typescript|python|both|unknown]
  framework: [next|react|vue|nuxt|express|fastapi|flask|django|expo|swiftui|none]
  sdks: [list]
  has_docker: [bool]
  has_terraform: [bool]
  has_ci_cd: [bool]
  ci_workflow_count: [number]
  cloud_database: [list]
  has_tailwind: [bool]
  tailwind_custom_tokens: [extracted tokens or null]
  has_brand_assets: [bool]
  has_design_tokens: [bool]
  has_claude_md: [bool]
  is_rerun: [bool]
  installed_skills: [list]
  team_size: [number]
  source_file_count: [number]
  is_monorepo: [bool]
  package_count: [number]
```

Present this profile to the user as "Here's what I detected about your project"
before proceeding to the next module.
