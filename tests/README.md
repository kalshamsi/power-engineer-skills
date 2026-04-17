# Power Engineer — Tests

Two-layer verification:

## Layer 1 — Lint (CI-automated, every PR)

`tests/lint/` — runs via `bash tests/run-all.sh`

| Script | Purpose |
|--------|---------|
| catalog-integrity.sh | Canonical 5-col-with-Install schema, INDEX ↔ file symmetry, no dupes, skill count matches README badge; **Check 7**: `.catalog-version` exists, is semver (`X.Y.Z`, exactly 5 bytes, no trailing newline), not at repo root; **Check 8**: every CHANGELOG `## [X.Y.Z]` release (v1.3.0+) has a `### Catalog` subhead |
| install-syntax.sh | Bare `npx skills add` form + `/plugin install` + `/plugin marketplace add` patterns; no version pinning in catalog rows |
| doc-structure.sh | Module / flow / router invariants migrated from tests/integration/; v1.4.0 additions: **subagent-selector** module (3-axis decision table, all 5 model modes); **save-phase** flow exists and is routed in SKILL.md; **configurator hooks** — SessionEnd + PreCompact hook scripts exist and are executable, registration commands use `$CLAUDE_PROJECT_DIR`, `settings.local.json` is asserted user-owned (never overwritten); **release-process kit** — 1 process doc + 5 templates exist in `docs/superpowers/release-process/`, shipping-boundary guard asserts none live inside `power-engineer/` |
| url-validation.sh | HEAD-check every GitHub URL in the catalog (session-cached) |
| scanner-rules.sh | Runs `power-engineer/references/modules/detection-rules.yaml` against `tests/fixtures/` |

ShellCheck runs as a separate CI step (`.github/workflows/ci.yml`) against `scripts/*.sh` (maintainer utilities) and `power-engineer/scripts/hooks/*.sh` (hook scripts that ship with the skill).

## Layer 2 — Fixtures (archetype verification)

`tests/fixtures/` — five project archetypes:

- `nextjs-supabase/` — full-stack TS web app
- `python-fastapi/` — Python backend API
- `monorepo/` — multi-language monorepo (TS + Python)
- `blank-project/` — greenfield (no detections expected)
- `react-native-expo/` — mobile

Each fixture has `expected.md` listing detections and skill recommendations the
scanner+resolver must produce. `scanner-rules.sh` verifies detections
automatically on every PR.

## Coverage philosophy

The lint layer enforces **structural invariants that apply to every skill** —
install-command syntax, 4-column catalog schema, INDEX ↔ file symmetry, URL
reachability, detection-rule wiring. Per-skill content assertions (e.g.,
"`bandit-sast` exists in the catalog with exactly this install command" or
"`pci-dss-audit` appears in the Compliance resolver block") are deliberately
**not** enforced here. Those concerns belong to PR review: a reviewer sees the
diff and can judge whether the right skill was added to the right place. Baking
per-skill content checks into lint would couple the test suite to every catalog
edit and make routine additions needlessly churny, without catching real defects
that structural invariants already cover. See
`docs/superpowers/plans/v1.3.0-parity.md` for the detailed coverage matrix that
justifies each retained assertion.

## Known coverage gaps (intentional)

- Questionnaire logic: tested manually. Complex branching / user-input flows can't be
  exercised from CI without invoking Claude Code.
- Skill resolver: tested manually via fixture expected.md skill lists. No automated
  runner yet; this is on the v1.4.0 roadmap.
- End-to-end Claude Code invocation: not automated. Cost + variance make it
  unsuitable for every-PR CI.

## Running locally

```bash
bash tests/run-all.sh
```
