# Changelog

All notable changes to Power Engineer are documented in this file.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.4.1] — 2026-04-18

### Added
- Stderr warning at hook start when `.power-engineer/memory-errors.log` contains prior entries — operator-observability surface for silent hook failures (addresses v1.4.0 security review ⚠️ MINOR #2)

### Changed
- `power-engineer/scripts/hooks/session-end-handoff.sh` and `power-engineer/scripts/hooks/pre-compact-snapshot.sh` output filenames now include process ID (`$$`) alongside the UTC second-resolution timestamp — prevents filename collision on sub-second concurrent invocations (addresses v1.4.0 security review ⚠️ MINOR #1)

### Catalog
- **Catalog version:** 1.4.0 (unchanged)
- **Skills added:** none
- **Skills removed:** none
- **Skills renamed:** none
- **Structural changes:** none

### Removed
- None

### Migration
- Existing v1.4.0 users: see `docs/MIGRATION.md`. All changes additive; no breaking changes. Re-running `/power-engineer configure` is NOT required — the hook scripts are shipped in-place via `npx skills add`. Operators are advised to periodically check `.power-engineer/memory-errors.log` for silent hook failures (now surfaced at hook start via stderr).

## [1.4.0] — 2026-04-17

### Added
- **Subagent-selector module** — prose + 3-axis decision table at `power-engineer/references/modules/subagent-selector.md`; 5-mode preference in `state.json.preferences.subagent_model_mode` (`selector` / `force-opus` / `force-sonnet` / `force-haiku` / `none`); new questionnaire Q14
- **3-tier memory architecture** — `/power-engineer save-phase` slash command + `SessionEnd` hook (automatic handoff) + `PreCompact` hook (context-crunch snapshot); each tier with graceful fallback contract
- **`.catalog-version` mechanism** — new `power-engineer/.catalog-version` file (initialized at 1.3.0 retroactive baseline, bumped to 1.4.0 for this release); CI `catalog-version-sync` job enforces bump on catalog changes
- **CHANGELOG `### Catalog` convention** — structured catalog-delta reporting per release; retroactive application to v1.3.0 entry; `tests/lint/catalog-integrity.sh` Check 8 enforces
- **Release-process framework kit** — `docs/superpowers/release-process/` with process doc + 5 required templates (planner-prompt, executor-prompt, plan, changelog-entry, migration) + 2 optional (parity, behavioral-validation); maintainer-only (not in shipped skill)
- **7 new catalog rows** — 6 `tavily-*` sub-skills + `stitch-design` (plus `search` → `tavily-search` rename in-place in docs-research.md + data-ml.md)
- Feedback memory documenting external-API / hooks research requirement for future plans

### Changed
- None

### Catalog
- **Catalog version:** 1.4.0 (from 1.3.0)
- **Skills added:** tavily-best-practices, tavily-cli, tavily-crawl, tavily-extract, tavily-map, tavily-research, stitch-design (7 new rows across docs-research.md + design-systems.md)
- **Skills removed:** none
- **Skills renamed:** `search` → `tavily-search` (in docs-research.md + engineering/data-ml.md — corrects stale upstream package name; net-zero on row count)
- **Structural changes:** new `.catalog-version` single-line file (power-engineer/.catalog-version); catalog row count 224 → 231

### Removed
- None

### Migration
- Existing v1.3.0 users: see `docs/MIGRATION.md`. All changes additive; no breaking changes. Re-run `/power-engineer configure` to register SessionEnd + PreCompact hooks and to set your `subagent_model_mode` preference (defaults to `selector` if skipped).

## [1.3.0] — 2026-04-16

### Added
- **Two-layer testing story**: `tests/lint/` (5 scripts, runs every PR) + `tests/fixtures/` (5 archetypes, verified by scanner-rules runner)
- **Single-source CLI version pin**: new `power-engineer/.skills-cli-version` file; installer injects at runtime — catalog stays clean
- **Machine-readable detection rules**: `power-engineer/references/modules/detection-rules.yaml` is the new source of truth; scanner.md references it; CI verifies via `tests/lint/scanner-rules.sh`
- **Auto-synced badge**: `scripts/update-skill-count.sh` keeps README + INDEX skill count honest; CI `badge-sync` job enforces it
- **GitHub Actions CI**: lint on every PR, daily URL check, on-PR targeted URL check for touched catalog files
- **MIGRATION.md**: upgrade path for v1.2.0 users (see docs/MIGRATION.md)
- Behavioral validation of scanner module via `claude --bare -p`; manual reproduction via `scripts/run-behavioral-fixtures.sh`; methodology + result in `docs/superpowers/plans/v1.3.0-behavioral-validation.md`
- `.env` / `.env.*` gitignore patterns to prevent accidental secret commits

### Changed
- Catalog install commands: stripped `@latest` from 220 rows across 11 catalog files; version now injected at runtime by installer module (catalog totals 224 rows post-cleanup)
- Scanner module: references `detection-rules.yaml` for detection logic
- Post-compaction hook (`power-engineer/references/flows/configurator.md`): moved from `PostToolUse` with matcher `"compact"` (invalid — `PostToolUse` matches tool names, not session sources, so never fired) to `SessionStart` with matcher `"compact"` (correct per Claude Code hooks docs)
- Permissions hook schema (`power-engineer/references/modules/permissions.md`): `PreToolUse` entry corrected from flat array-of-strings to nested `{type, command}` objects (matches Claude Code hooks schema; flat format caused a Settings Error on launch)
- README badges: honest claims — `fixtures-5-scanner-verified`, auto-generated skill count, CI status

### Catalog

- **Catalog version:** pre-convention baseline; recorded retroactively as `1.3.0` in `power-engineer/.catalog-version` (file introduced in v1.4.0)
- **Skills added:** none
- **Skills removed:** none
- **Skills renamed:** none
- **Structural changes:** 220 install commands normalized via `@latest` strip; catalog row count reconciled 238 → 224 (cross-category duplicates removed)

### Removed
- `tests/integration/` (14 scripts) — invariants migrated to `tests/lint/`
- `tests/run-tests.sh` — replaced by `tests/run-all.sh`
- Hardcoded `tests-312 passing` badge — superseded by CI status badge
- Stale `tests-312 passing` badge from README header (superseded by live CI status badge)

### Migration
- Existing v1.2.0 users: see `docs/MIGRATION.md`. Your installed skills continue to work. First v1.3.0 run prompts for version-pin acknowledgment.
