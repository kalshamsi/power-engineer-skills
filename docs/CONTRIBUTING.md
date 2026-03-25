# Contributing to power-engineer-skills

---

## How to add skills to the catalog

### Find the right catalog file

All catalog files live in `power-engineer/references/catalog/`. Use `INDEX.md` to find the right sub-file for the skill you want to add:

| Category | File |
|----------|------|
| Core & Planning | `core-methodology.md` |
| Anthropic Official | `anthropic-official.md` |
| Backend / API / Databases | `engineering/backend-architecture.md` |
| DevOps / Infra / CI | `engineering/devops-infra.md` |
| Data / ML / MLOps | `engineering/data-ml.md` |
| Testing / Quality | `engineering/testing-quality.md` |
| AI / LLM / Agentic | `engineering/agentic-ai.md` |
| Security / AppSec | `engineering/security-ops.md` |
| React / Next.js | `frontend/react-next.md` |
| Vue / Vite / Nuxt | `frontend/vue-vite.md` |
| Design Systems | `frontend/design-systems.md` |
| Mobile (Expo / RN / iOS) | `frontend/mobile.md` |
| Azure | `cloud/azure.md` |
| Databases (Neon, Supabase) | `cloud/databases.md` |
| Docs & Research | `docs-research.md` |
| Power Suites | `power-suites.md` |

### Table format

Every skill entry follows this 6-column format:

```
| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
```

### Required fields

All 6 columns must be filled. No column may be left blank or contain a placeholder.

| Column | Description | Example |
|--------|-------------|---------|
| **Skill** | Display name of the skill | `systematic-debugging` |
| **Source** | GitHub user/repo | `anthropics/claude-code-skills` |
| **Install** | Full install command (see syntax below) | `npx skills@latest add anthropics/claude-code-skills --skill systematic-debugging -y` |
| **Description** | One-sentence description of what the skill does | "Structured debugging loop: reproduce, isolate, fix, verify." |
| **Trigger** | How the skill is invoked | `/systematic-debugging` |
| **When to use** | One-line usage hint | "When a bug is hard to reproduce or the root cause is unclear." |

### Install command syntax

```
npx skills@latest add <user/repo> --skill <name> -y
```

- `<user/repo>` — GitHub username and repository, e.g. `kalshamsi/power-engineer-skills`
- `--skill <name>` — exact skill name as it appears in the repo
- `-y` — accept all prompts automatically (required for catalog entries)

The install command must be verified to work before submitting. Test it in a clean environment.

### Trigger format

- `/skill-name` — manually triggered by the user saying `/skill-name` in chat
- `auto` — skill activates automatically when Claude detects the right context (no manual trigger needed)

### When to use

Write a one-line usage hint. Start with "When" or an action verb:

- "When implementing a new API endpoint from scratch."
- "When a security review is needed before merging."
- "Debugging production incidents with live traces."

---

## How to improve the tool

### Module architecture

The tool is composed of independent modules in `power-engineer/references/modules/`:

| Module | File | Responsibility |
|--------|------|---------------|
| **Scanner** | `scanner.md` | Analyzes the codebase and produces a `ProjectProfile` |
| **Questionnaire** | `questionnaire.md` | Runs the adaptive interview and produces a `SkillPlan` |
| **Skill Resolver** | `skill-resolver.md` | Converts a `SkillPlan` into a deduplicated list of install commands |
| **Installer** | `installer.md` | Executes installs directly with progress tracking and failure handling |
| **Configurator** | `configurator.md` | Writes/merges CLAUDE.md, creates `.power-engineer/` state directory, patches skills with project context |
| **Drift Detector** | `drift-detector.md` | Compares `.power-engineer/state.json` against the current project to surface new skill recommendations |

Keep modules focused on a single responsibility. Do not add routing logic to a module; that belongs in a flow.

### Flow composition

Flows live in `power-engineer/references/flows/`. A flow composes modules from the pipeline:

```
Scanner → Questionnaire → Skill Resolver → Installer → Configurator
```

The Drift Detector runs independently on `status` and `update` commands only.

When adding a new command route:
1. Create a new flow file in `flows/`
2. Specify exactly which modules it calls and in what order
3. Add the trigger mapping to `SKILL.md`
4. Document the command in `README.md` under the command reference table

### Testing requirements

Tests use the `check()` bash pattern. All integration tests live in `tests/integration/`.

Basic pattern:

```bash
check() {
  local description="$1"
  local result="$2"
  local expected="$3"
  if echo "$result" | grep -q "$expected"; then
    echo "PASS: $description"
  else
    echo "FAIL: $description"
    echo "  Expected: $expected"
    echo "  Got: $result"
    FAILURES=$((FAILURES + 1))
  fi
}
```

Run all tests with:

```bash
bash tests/run-tests.sh
```

Run a single integration test with:

```bash
bash tests/integration/test-<name>.sh
```

Tests must pass before a PR is merged. Do not add tests to the root folder.

### File organization

| Type | Location |
|------|----------|
| Source modules | `power-engineer/references/modules/` |
| Flow compositions | `power-engineer/references/flows/` |
| Catalog files | `power-engineer/references/catalog/` |
| Integration tests | `tests/integration/` |
| Documentation | `docs/` |
| Scripts | `scripts/` |

Keep `SKILL.md` under 55 lines. It is a thin router — move logic into modules, not the router.

Keep modules focused. If a module grows beyond 500 lines, split it.

---

## PR guidelines

### Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add semgrep-pro skill to security catalog
fix: correct install command for playwright-testing
docs: update CONTRIBUTING with trigger format rules
refactor: extract scanner logic into sub-module
test: add integration test for drift-detector
```

### Before submitting

1. Run all tests: `bash tests/run-tests.sh`
2. Verify the build succeeds: `npm run build`
3. Confirm your install command works end-to-end in a clean environment

### Catalog additions

- One skill per PR
- All 6 columns filled (Skill, Source, Install, Description, Trigger, When to use)
- Install command must be verified and include `-y`
- Update the skill count in `power-engineer/references/catalog/INDEX.md`

### Module/flow changes

- Describe what the module does, why the change is needed, and any downstream impact on flows
- Include a test covering the change
- If adding a new command route, update the command reference table in `README.md`

### What not to include

- Hardcoded secrets, API keys, or credentials
- `.env` files or anything derived from them
- Files saved to the root folder (use `docs/`, `tests/`, `scripts/` instead)
