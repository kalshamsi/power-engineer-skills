# uninstall-info-flow (behavioral fixture)

Manual harness covering v1.4.2 acceptance criteria **1 (uninstall)** and
**2 (info)**.

## Purpose

Exercises the v1.4.2 `uninstall` and `info` flows end-to-end against a
synthetic `state.json` and a synthetic on-disk skill, so a maintainer can
verify both flows actually behave as documented before tag push.

The fixture covers four scenarios:

| Scenario | Flow | Path covered |
|---|---|---|
| (a) | `uninstall` | bare-name disambiguation (2+ matches → AskUserQuestion) |
| (b) | `uninstall` | orphan / stale-state cleanup (entry exists, dir gone) |
| (c) | `uninstall` | happy path (entry + dir → delete both) |
| (d) | `info`      | render for an installed skill (header + Description + Catalog metadata + Health) |

See `expected-after.md` for the expected post-state of each scenario and
`EXEC.md` for the reproduction procedure.

## Files

| File | Purpose |
|---|---|
| `README.md`              | This file. |
| `EXEC.md`                | Numbered manual reproduction steps for all four scenarios. |
| `initial-state.json`     | Seed `state.json` with 4 entries: 2× `synthetic-skill` (different repos), 1× `synthetic-skill-orphan`, 1× `synthetic-skill-healthy`. |
| `expected-after.md`      | Expected post-state per scenario, with `jq` and `test` assertions. |
| `synthetic-skill/SKILL.md` | Minimal SKILL.md used as the on-disk target for the healthy + ambiguous-name cases. |

## How to invoke

Follow `EXEC.md`. Each scenario is independent — set up a fresh working
tree before running each one (the procedure is documented in `EXEC.md` Step
1).

## When to run

At the **Phase 3 release ceremony**, before tag push. The fixture is part
of the v1.4.2 release checklist alongside the existing scanner-rules
fixtures and the `tests/run-all.sh` lint suite.

## Manual-harness note

This fixture is **not** wired into `scripts/run-behavioral-fixtures.sh`.
That harness is scanner-rules-specific (it parses `DETECT:` lines from each
fixture's `expected.md` and runs the detection-rules YAML against the
fixture tree). This fixture instead documents flow execution + state
mutation, so a maintainer walks the EXEC steps and visually diffs the
post-state against `expected-after.md`. Extending the runner to support
flow-execution fixtures is plausible future work but is out of v1.4.2
scope.
