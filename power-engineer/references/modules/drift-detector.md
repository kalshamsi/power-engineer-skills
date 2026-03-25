# Drift Detector Module

Compares the current project state against the saved state in
`.power-engineer/state.json`. Detects changes and presents a
reconciliation plan.

## Prerequisites

This module requires `.power-engineer/state.json` to exist. If it doesn't,
report "No previous setup found" and suggest running the full setup.

## Detection checks

### 1. Dependency changes

```bash
# Current dependencies
cat package.json 2>/dev/null | jq '.dependencies, .devDependencies' 2>/dev/null
cat pyproject.toml 2>/dev/null
```

Compare against `scan_snapshot.dependency_count` and `scan_snapshot.package_json_hash`
in state.json. Report:
- New packages added since last scan
- Packages removed since last scan

### 2. Structural changes

```bash
# Check for new config files that weren't there before
ls Dockerfile docker-compose.yml docker-compose.yaml 2>/dev/null
ls -d terraform/ .github/workflows/ 2>/dev/null
ls next.config.* nuxt.config.* vite.config.* 2>/dev/null
```

Compare against state.json project profile. Report new infrastructure:
- Docker added (wasn't present before)
- CI/CD added
- Terraform added
- Framework config changed

### 3. Brand file changes

```bash
# Check if tailwind config or design tokens changed
cat tailwind.config.* 2>/dev/null | head -50
ls design-tokens.* tokens.json 2>/dev/null
```

Compare against stored brand snapshot. Report:
- Updated color tokens
- New logo files
- Modified design tokens

### 4. CLAUDE.md manual edits

```bash
cat CLAUDE.md 2>/dev/null
```

Check if content OUTSIDE the `<!-- power-engineer:managed-section -->` delimiters
has been modified. Report manual edits and flag them for preservation.

### 5. Skill changes

```bash
ls .claude/skills/ .agents/skills/ 2>/dev/null
```

Compare against `installed_skills` list in state.json. Report:
- Skills manually removed (in state.json but not on disk)
- Skills manually added (on disk but not in state.json)

### 6. MCP server changes

```bash
cat .claude/mcp.json 2>/dev/null
cat ~/.claude/mcp.json 2>/dev/null
```

Report new MCP servers configured since last run.

### 7. Ruflo changes

```bash
# Check if Ruflo is installed
cat ruflo.config.json 2>/dev/null

# Check Ruflo's managed directories
ls .claude/agents/ .claude/skills/ .claude/hooks/ 2>/dev/null

# Check MCP registration
claude mcp list 2>/dev/null | grep -i ruflo
```

Compare against `ruflo` section in state.json. Report:
- Ruflo config changes (ruflo.config.json modified since last run)
- New agents or skills added via Ruflo CLI
- MCP registration status changes
- Ruflo version changes (check `npx ruflo@latest --version`)

### 8. Code growth & team changes

```bash
git log --since="[last_updated date]" --format="%aN" | sort -u | wc -l
find . -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.py' 2>/dev/null | wc -l
```

Compare against stored metrics. Report significant changes:
- New team members
- Large codebase growth (>20% file count increase)

## Presenting the drift report

```
========================================
 Power Engineer -- Drift Report
========================================

Changes since last setup ([date]):

Dependencies:
  + @supabase/supabase-js (new)
  + tailwindcss (new)
  - old-package (removed)

Structure:
  + Dockerfile added
  + .github/workflows/ added (2 workflows)

Brand:
  ~ tailwind.config.ts colors updated

Skills:
  - brainstorming manually removed
  + custom-skill manually added (not tracked)

CLAUDE.md:
  ~ Manual edits detected outside managed section (will be preserved)

Code:
  ~ Source files: 45 -> 120 (+167%)
  ~ Team: 1 -> 3 contributors

========================================
```

## Reconciliation options

After presenting the drift report, offer three options:

1. **Accept all** -- Update state, install recommended new skills, refresh configuration
2. **Accept selectively** -- Let the user choose which changes to act on
3. **Skip** -- Just update state.json with current snapshot, don't install anything

### If reconciliation proceeds

1. Build a new SkillPlan from the updated project state
2. Pass to Skill Resolver for new skill recommendations
3. Present new recommendations for confirmation
4. If confirmed, pass to Installer
5. Update state.json and CLAUDE.md via Configurator
6. Append to drift-history.json:

```json
{
  "date": "[ISO date]",
  "type": "drift-reconciliation",
  "changes_detected": ["list of change descriptions"],
  "skills_installed": 0,
  "skills_removed": 0
}
```
