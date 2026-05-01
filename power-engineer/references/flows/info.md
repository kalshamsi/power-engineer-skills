# Info Flow

Show details for a single skill -- identity, description, catalog metadata, and
health. Read-only -- does not modify state, disk, or configurator outputs.

## Step 1 -- State + catalog check

```bash
cat .power-engineer/state.json 2>/dev/null
grep -rl "<skill-name>" power-engineer/references/catalog/ 2>/dev/null
```

Read `installed_skills[]` from `.power-engineer/state.json` (if present) and
grep all `power-engineer/references/catalog/**/*.md` files for the skill name.
Both lookups feed Step 2 -- a skill may live in state, in the catalog, in
both, or in neither.

If `.power-engineer/state.json` is missing, treat `installed_skills[]` as
empty and continue -- info works against the catalog alone for browsing.

## Step 2 -- Resolve skill argument

Parse the user's invocation. The argument is either:
- a bare name: `<name>` (e.g. `brainstorming`)
- a qualified name: `<name> (<repo>)` (e.g. `brainstorming (obra/superpowers)`)

### Validate the name

Reject path-traversal and shell-metacharacter attempts. The skill name MUST
match the regex:

```
^[a-z0-9][a-z0-9-]*$
```

If the name fails the regex, abort with:
"Invalid skill name '<input>'. Names must be lowercase, start with a letter
or digit, and contain only letters, digits, and hyphens."

No filesystem reads run on a rejected name.

### Filter installed_skills[] and catalog rows

From state, filter `installed_skills[]`:
- bare name -- match entries whose `name` equals the argument
- qualified name -- match entries whose `name` AND `repo` both equal

From catalog, collect every row in `power-engineer/references/catalog/**/*.md`
whose skill name equals the argument (or whose `name (repo)` matches when
the argument is qualified).

### Branch on lookup result

**1 state match** -- proceed to Step 3 with the resolved entry. Pull catalog
metadata from the matching catalog row if present.

**0 state matches, 1+ catalog matches (skill in catalog but not installed)** --
proceed to Step 3 in "not installed" mode. Render catalog metadata and the
install command; omit state-installed lines (Path / Installed).

**0 state matches AND 0 catalog matches** -- abort with:
"Skill '<name>' not in state.json or catalog. Run `/power-engineer catalog`
to browse."

**2+ state matches (bare name only)** -- the user gave a name that is installed
from multiple repos. Use AskUserQuestion to disambiguate:

```
AskUserQuestion:
  question: "Multiple skills match '<name>'. Which one should I show?"
  header: "Disambiguate"
  options:
    - label: "<name> (<repo-1>)"
      description: "Installed at <path-1>"
    - label: "<name> (<repo-2>)"
      description: "Installed at <path-2>"
    - label: "Cancel"
      description: "Exit without showing anything."
  multiSelect: false
```

Render one option per matching entry, plus a Cancel option.

## Step 3 -- Render output (read-only, plain text)

Compute the install path from the resolved state entry's scope:
- project scope -- `.claude/skills/<name>/`
- user scope -- `.agents/skills/<name>/` (under `$HOME`)

Read the skill's `SKILL.md` frontmatter for the description. If the file is
absent on disk, substitute `(skill not on disk)`. If the frontmatter is
present but unparseable, substitute `(unparseable frontmatter)`.

Compute health:
- `Healthy` -- state entry present AND directory exists AND `SKILL.md`
  present with parseable frontmatter
- `Broken` -- state entry present AND directory exists AND `SKILL.md`
  missing or unparseable
- `Missing` -- state entry present but directory absent on disk
- `Not installed` -- no state entry; rendered from catalog metadata only

Print the output as plain text using this exact layout:

```
<name> (<repo>)
  Path: .claude/skills/<name>/   [or "not installed"]
  Installed: <date> by <flow>    [or "—"]

Description
  <text from SKILL.md frontmatter>   [or "(skill not on disk)" if missing]

Catalog metadata
  Category: engineering/agentic-ai
  Related in this category: mcp-builder, self-improving-agent, …
  Install command: skills add <repo> <name>

Health: ✓ Healthy   [or ✗ Broken / ⚠ Missing / ℹ Not installed]
  Suggested action: <inline tip if not healthy>
```

Inline action by health state:
- `✓ Healthy` -- omit the "Suggested action" line.
- `✗ Broken` -- "Re-run install or `/power-engineer update`."
- `⚠ Missing` -- "Re-run install or `/power-engineer update`."
- `ℹ Not installed` -- "Run the install command above to add this skill."

If the catalog has no row for the skill (state entry exists but catalog is
silent), render `Catalog metadata` with `Category: (not in catalog)` and
omit the `Related` and `Install command` lines.

Exit after rendering -- info never prompts for further action and never
writes to state, disk, or configurator outputs.

## Error handling

| Scenario | Behavior |
|---|---|
| Skill name not in state.json AND not in catalog | Error: "Skill '<name>' not in state.json or catalog. Run `/power-engineer catalog` to browse." |
| In state.json but disk dir gone | Render with Health: ✗ Missing + action: "Re-run install or `/power-engineer update`." |
| In catalog but not installed | Render without state-installed lines; Health: ℹ Not installed; action: install command. |
| SKILL.md present but malformed frontmatter | Description: "(unparseable frontmatter)"; rest of output unaffected. |
| Path traversal attempt in skill name (e.g. `../foo`) | Reject at Step 2 regex validation. No FS read. |
