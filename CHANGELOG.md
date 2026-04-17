# Changelog

All notable changes to Power Engineer are documented in this file.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
