<!-- Replace <X.Y.Z>, <feature-name>, and bracketed placeholders before use. Optional template — only use for releases involving large refactors or infrastructure rewrites where preservation of invariants must be tracked. -->

# v<X.Y.Z> Parity Evidence — <feature-name>

Generated: <YYYY-MM-DD>
Old surface: `<command to run pre-change suite>` → `<exit status + pass/fail summary>`
New surface: `<command to run post-change suite>` → `<exit status + pass/fail summary>`

## How to use this template

A parity doc proves that a refactor or migration preserves all invariants from the surface being replaced. Three buckets organize the evidence:

- **L-bucket** (Logic / Lint) — per-assertion mapping from old to new
- **F-bucket** (Functional / Feature) — end-to-end / fixture-level scenarios
- **R-bucket** (Removal / Refactor) — items intentionally NOT carried forward, with rationale

For each old assertion, classify it as one of: **direct port** (same check, new location), **structural** (subsumed by a stronger one-place check), **migrated** (semantics preserved by a renamed/reshaped concept), **intentional gap** (dropped on purpose with rationale), or **redundant** (R-bucket). Every row must be classified — silent omissions defeat the purpose.

Delete sections that don't apply (e.g., if the migration has no F-bucket scenarios, delete that section entirely rather than leaving placeholders).

## Context / scope

This parity doc covers `<change description>` — specifically, the migration from `<old surface>` to `<new surface>` performed in Phase `<N>` (`<task-id>`).

**What this doc proves:** every invariant exercised by the old surface is preserved (directly or by stronger structural equivalent) by the new surface. Where coverage diverges, the divergence is documented as an intentional gap with rationale.

**What this doc does NOT cover:**
- Behavioral runtime validation (see `behavioral-validation-template.md` if applicable)
- Performance regressions (separate concern — measure before/after if relevant)
- New invariants introduced by the change (those belong in the changelog and lint suite, not here)

**Scope boundaries:**
- Source: `<path/to/old/surface>` (`<N files>`, `<N lines>`, `<N assertions/checks>`)
- Target: `<path/to/new/surface>` (`<N files>`, `<N lines>`, `<N assertions/checks>`)
- Out of scope: `<list anything explicitly NOT compared>`

## L-bucket coverage matrix

"L" = Logic / Lint coverage. Each row maps a logical assertion (test case, lint rule, structural check) from the old surface to its replacement on the new surface.

`<N>` L-bucket rows grouped by source. Each row is covered either by a direct port, a structural invariant that subsumes it, or is documented as an intentional gap with rationale.

### `<old-source-1>` — `<N>` L rows

| Assertion (brief) | Source row | Covered by (new) |
|---|---|---|
| `<one-line description>` | `<row id or line ref>` | `<new path:line>` `<short note>` |
| `<one-line description>` | `<row id or line ref>` | `<new path:line>` `<short note>` |
| `<one-line description>` | `<row id or line ref>` | **DROPPED INTENTIONALLY** — `<rationale>` |

### `<old-source-2>` — `<N>` L rows

| Assertion group | Source rows | Covered by (new) |
|---|---|---|
| `<group name (N assertions)>` | `<row range>` | `<new path:line range>` |
| `<group name (N assertions)>` | `<row range>` | **STRUCTURAL** via `<new check name>` — `<rationale for why structural beats per-item>` |

### `<old-source-3>` — `<N>` L rows

| Assertion (brief) | Source row | Covered by (new) | Classification |
|---|---|---|---|
| `<one-line description>` | `<row id>` | **MIGRATED** — `<old concept>` replaced by `<new concept>`; semantics preserved by `<new mechanism>` | Schema change |
| `<one-line description>` | `<row id>` | **SUPERSEDED** by `<new check>` — covers all items, not just `<N>` listed here | Structural upgrade |

**Worked-example row (delete or adapt):**

| Assertion (brief) | Source row | Covered by (new) |
|---|---|---|
| `installed_skills is an array` | `row 67` | `tests/lint/doc-structure.sh:497-498 "configurator.md mentions installed_skills as array"` |
| `Good index does NOT use bare list syntax` | `row 50` | **DROPPED INTENTIONALLY** — managed section now mixes markdown structures; assertion was against handcrafted fixture, not production behavior |
| `10 per-skill install syntax checks` | `rows 274-283` | **SUPERSEDED** by `tests/lint/install-syntax.sh` — every `npx skills add` command in the catalog is syntax-validated; the new structural invariant is stronger (covers all skills, not just these 10) |

### Summary

| Source | L rows total | Direct port | Structural / migrated | Intentional gap |
|---|---|---|---|---|
| `<old-source-1>` | `<N>` | `<N>` | `<N>` | `<N>` |
| `<old-source-2>` | `<N>` | `<N>` | `<N>` | `<N>` |
| `<old-source-3>` | `<N>` | `<N>` | `<N>` | `<N>` |
| **Total** | **`<N>`** | **`<N>`** | **`<N>`** | **`<N>`** |

**Common L-bucket patterns:**
- Per-item assertion → structural invariant: prefer one canonical check (e.g., a header regex, a schema validator) that subsumes N hardcoded per-item checks. Stronger than the original; survives item additions/removals without maintenance.
- Renamed / reshaped concept: when a field, file, or command is renamed, write **MIGRATED** in the "Covered by" cell and cite both the old name and the new mechanism that preserves the semantics.
- Self-test on handcrafted fixture: belongs in the R-bucket, not here. Don't carry forward assertions that only exercise the test fixture.

## F-bucket coverage

"F" = Functional / Feature coverage. Each row tracks a functional scenario (end-to-end behavior, integration path, fixture-driven check) and its replacement.

`<N>` F-bucket rows grouped by source. Each is typically covered by `<new fixture / integration mechanism>`.

| Source file | F rows | Covered by | Notes |
|---|---|---|---|
| `<old-source-1>` | `<N>` (`<row range>`) | `<new fixture path or check>` | `<one-line note>` |
| `<old-source-2>` | `<N>` (`<row range>`) | `<new fixture path or check>` | `<one-line note>` |
| `<old-source-3>` | `<N>` (`<row range>`) | `<new fixture path or check>` | `<one-line note>` |

**F-bucket parity verdict:** `<N>`/`<N>` covered. `<one-paragraph rationale>` — typically: fixtures replace handcrafted mocks with deterministic inputs that the new check evaluates against an expected output set. List the fixture archetypes if applicable: `<archetype-1>`, `<archetype-2>`, `<archetype-3>`.

**Common F-bucket patterns:**
- Handcrafted mocks → project-shaped fixtures: a fixture is a real-shaped input (real `package.json`, real config files) plus an `expected.<format>` answer key. Mechanically diffed; deterministic.
- Scenario coverage matrix: when an old test exercised N variants of one scenario, encode each variant as one fixture row. Prefer breadth (more archetypes) over depth (more variations of one archetype).
- End-to-end runs: if the migration changes user-facing behavior, sketch how a real invocation produces the expected output. Often deferred to behavioral validation (separate doc).

## R-bucket justifications

"R" = Removal / Refactor. Each row documents an assertion from the old surface that is intentionally NOT carried forward, with traceable rationale.

`<N>` R-bucket rows. All are self-checks against handcrafted fixtures, negative tautologies, assertions about the old infrastructure itself (which is being removed), or coverage subsumed by stronger structural checks already documented above.

| Source file | R rows | Justification |
|---|---|---|
| `<old-source-1>` | `<N>` (`<row range>`) | `<one-line rationale: tautology / handcrafted-fixture / superseded / etc.>` |
| `<old-source-2>` | `<N>` (`<row range>`) | `<one-line rationale>` |
| `<old-source-3>` | `<N>` (`<row range>`) | `<one-line rationale>` |

**R-bucket parity verdict:** `<N>`/`<N>` safely redundant. None weaken any production invariant. Categories of redundancy:

1. **Self-tests on handcrafted fixtures** — assertions that exist only to verify the test fixture itself, not production behavior
2. **Tautological negative checks** — assertions of the form "the bad pattern is not present" where the bad pattern was never producible by production code
3. **Infrastructure-about-infrastructure** — assertions about test runner names, file paths, or command shapes that change with the refactor
4. **Subsumed by structural invariants** — assertions already covered by stronger checks documented in the L-bucket matrix above

## Intentional gaps

Items NOT covered by the new surface, listed explicitly so future readers do not assume they were missed by accident.

1. **`<gap name>`** (`<source file>` `<row id>`): `<rationale — why dropping this is safe; what stronger invariant replaces it, if any>`
2. **`<gap name>`** (`<source file>` `<row id>`): `<rationale>`
3. **`<gap name>`** (`<source file>` `<row id>`): `<rationale>`

Each gap should answer:
- What invariant did the old assertion check?
- Why is that invariant no longer relevant (or no longer the right invariant to check)?
- If the invariant is still relevant, where is it now enforced?

## Summary

- **L-bucket rows**: `<N>` total, `<N>` covered (`<N>` by direct port/annotation, `<N>` by structural invariant, `<N>` by intentional documented gap)
- **F-bucket rows**: `<N>` total, `<N>` covered by `<new mechanism>`
- **R-bucket rows**: `<N>` total, all safely redundant (documented above)
- **Net additions** (new invariants introduced by the change, not present in old surface): `<list new checks added during the migration; e.g., "one-line lint addition: empty-cell detection in catalog-integrity.sh">`
- **Parity verdict**: **PASS** / **FAIL**

## Safe-to-delete authorization

Based on the evidence above, the following artifacts can now be safely deleted because their invariants are preserved by the items documented in the L/F/R buckets:

- `<path/to/old/artifact-1>` (`<N files>`, ~`<N lines>`)
- `<path/to/old/artifact-2>` (`<N files>`, ~`<N lines>`)

The new surface is strictly more maintainable: structural invariants over hardcoded content assertions, deterministic fixtures over handcrafted mocks, and one-place enforcement over scattered per-item checks. Coverage of L-bucket assertions that matter for production correctness is complete; F-bucket scenarios are covered by deterministic project-shaped fixtures; R-bucket items are documented redundancies with no production impact.

**Authorized by:** `<task-id that performs the deletion; e.g., "Task 7.2">`
**Deletion happens in:** `<commit / PR reference if available>`
