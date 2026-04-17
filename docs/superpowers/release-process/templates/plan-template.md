<!-- Replace <X.Y.Z>, <feature-name>, <N>, <YYYY-MM-DD>, and bracketed placeholders before use. -->

# Power Engineer v<X.Y.Z> Upgrade Plan — <feature-name>

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. The companion executor prompt instantiated from `docs/superpowers/release-process/templates/executor-prompt-template.md` orchestrates dispatch; this document is the spec it executes against.

**Goal:** <One-paragraph statement of what v<X.Y.Z> ships. Name the headline themes (e.g. "catalog hygiene + Cluster B agent infrastructure"). State the delivery approach (e.g. "aggressive-dogfooding with graceful fallback contracts"). One paragraph max.>

**Architecture:** <How the phases compose. Typically: meta-infra in early phases so later phases can dogfood it; foundation-before-content (e.g. lint before catalog edits); tests/docs before release ceremony. Call out any inversion or unusual ordering and why. One paragraph.>

**Tech Stack:** <Languages/runtimes touched (Bash, GitHub Actions, Markdown). Note any new tool introduced this release (e.g. "new: `SessionEnd`, `PreCompact` hooks" or "yq Phase 0 only"). Distinguish ship-time vs build-time tools.>

**Related artifacts:**
- Spec: `docs/superpowers/specs/<YYYY-MM-DD>-power-engineer-v<X.Y.Z>-<feature-name>.md`
- Prior plan (reference format): `docs/superpowers/plans/power-engineer-v<prior-version>-upgrade-plan.md`
- Brainstorm memory: `~/.claude/projects/<project-slug>/memory/project_v<X.Y.Z>_brainstorm.md`
- Prior release retrospective: `~/.claude/projects/<project-slug>/memory/project_v<prior-version>_released.md`
- Cross-cutting policy: `docs/superpowers/release-process/release-process.md`
- Feedback memories consumed during authoring: `feedback_plan_pattern_verification.md`, `feedback_external_api_verification.md`
- <Add release-specific spec/research/audit docs as needed>

---

## File Structure

<!-- Group every file the plan creates or modifies under a responsibility heading. Annotate INSIDE / OUTSIDE `power-engineer/` per the shipping-boundary invariant — see release-process.md and Phase N-1's lint enforcement task. -->

Files created or modified, grouped by responsibility:

**Skill content (INSIDE `power-engineer/` — ships via `npx skills add`):**
- Create: `power-engineer/<path>` — <one-line purpose>
- Modify: `power-engineer/<path>` — <one-line purpose>

**Hook / script content (INSIDE `power-engineer/` — ships with the skill):**
- Create: `power-engineer/scripts/hooks/<name>.sh` — <purpose; bash, executable, shellcheck-clean>
- <Add additional scripts as needed>

**Catalog hygiene (INSIDE `power-engineer/`):**
- Create / Modify: `power-engineer/.catalog-version` — single-line semver, no trailing newline
- Modify: `power-engineer/references/catalog/<path>.md` — <delta description>

**Tests + lint (OUTSIDE `power-engineer/` — maintainer-only):**
- Modify: `tests/lint/<name>.sh` — <new check description>
- Modify: `tests/README.md` — document new lint additions

**CI (OUTSIDE `power-engineer/`):**
- Modify: `.github/workflows/ci.yml` — <new job or step>

**Release-process kit (OUTSIDE `power-engineer/` — maintainer-only, force-committed):**
- Create / Modify: `docs/superpowers/release-process/<path>.md`

**Docs + release ceremony (OUTSIDE `power-engineer/`):**
- Modify: `CHANGELOG.md` — v<X.Y.Z> entry (instantiated from `changelog-entry-template.md`)
- Modify: `docs/MIGRATION.md` — v<prior-version> → v<X.Y.Z> entry (instantiated from `migration-template.md`)
- Modify: `README.md` — version bumps + badge updates
- Modify: `power-engineer/SKILL.md` — version bump if applicable

<!-- Misplacements (e.g. release-process kit landing inside power-engineer/) are BLOCKERS at audit time. The Phase N-1 lint step asserts the boundary structurally. -->

---

## Phase 0 — Audit & Prep

<!-- Phase 0 is always audit/prep: branch creation, baseline lint pass, ecosystem research subagents (memory / hooks / catalog / API / CLI as the release demands), `.catalog-version` baseline. No production-file edits. -->

**Goal:** Create the working branch, commission research subagents whose output gates downstream implementation phases, and establish baseline verification (`bash tests/run-all.sh` exits 0 on a clean tree).

### Task 0.1: Create working branch

**Files:** None (git operation)

- [ ] **Step 1: Create branch tracking origin**

```bash
git checkout main
git pull
git checkout -b v<X.Y.Z>-upgrade
git push -u origin v<X.Y.Z>-upgrade
```

Expected: branch `v<X.Y.Z>-upgrade` tracks `origin/v<X.Y.Z>-upgrade`. This push is the single mid-release exception to the push-at-release-time policy (per `release-process.md` §4) — Phase 0 has nothing meaningful in the branch yet.

- [ ] **Step 2: Confirm clean starting state**

```bash
git status
bash tests/run-all.sh
```

Expected: clean tree; lint exits 0.

### Task 0.2: <Research subagent: ecosystem / external API / etc.>

**Files:** Create: `docs/superpowers/plans/v<X.Y.Z>-<topic>-research.md` (force-committed)

<!-- One Research-subagent task per external-surface gate identified in the External API research checklist below. Output is consumed by the Dev that touches the surface. -->

- [ ] **Step 1: Dispatch Research subagent**

Brief: <topic, scope, output expectations, success criteria>.

- [ ] **Step 2: Review subagent output**

Confirm the report covers <minimum content gates> and produces an explicit recommendation.

- [ ] **Step 3: Commit the research doc**

```bash
git add -f docs/superpowers/plans/v<X.Y.Z>-<topic>-research.md
git commit -m "docs(v<X.Y.Z>): <topic> research report (Phase 0)"
```

### Task 0.3: <e.g. Initialize `.catalog-version` baseline>

**Files:** <files>

- [ ] **Step 1: <action>**
- [ ] **Step 2: Verify**
- [ ] **Step 3: Commit**

### Phase 0 Verification

- [ ] Branch `v<X.Y.Z>-upgrade` exists and tracks origin
- [ ] All Phase 0 research docs exist and contain explicit recommendations
- [ ] <release-specific baseline gate>
- [ ] `bash tests/run-all.sh` → exit 0 (existing lint unaffected)

---

## Phase 1 — <Phase 1 title>

<!-- Phases 1 .. N-2 are implementation phases. Order them so meta-infra introduced early can be dogfooded by later phases of the same release. -->

**Goal:** <one paragraph>

### Task 1.1: <title>

**Files:** <Create / Modify list>

- [ ] **Step 1: <action>**

```bash
<command>
```

Expected: <evidence>.

- [ ] **Step 2: Verify**

```bash
<verification command — runnable, deterministic>
```

Expected: <exit code / match count / output snippet>.

- [ ] **Step 3: Commit**

```bash
git add <paths>
git commit -m "<type>(<scope>): <subject>"
```

### Task 1.2: <title>

<!-- Repeat the Files / Steps / Commit pattern. -->

### Phase 1 Verification

- [ ] <gate 1 — quote the exact command + expected output>
- [ ] <gate 2>
- [ ] `bash tests/run-all.sh` → exit 0

---

## Phase 2 — <Phase 2 title>

<!-- Repeat the phase template per implementation phase. Number sequentially from 1 to N-2. -->

**Goal:** <one paragraph>

### Task 2.1: <title>

**Files:** <Create / Modify list>

- [ ] **Step 1: <action>**
- [ ] **Step 2: Verify**
- [ ] **Step 3: Commit**

### Phase 2 Verification

- [ ] <gates>

---

## Phase <N-1> — Tests / Lint Extensions

<!-- The penultimate phase always extends tests/lint to assert that Phases 1..N-2 outputs are structurally correct. CI workflow updates live here too. -->

**Goal:** Add `tests/lint/*.sh` checks asserting Phases 1..N-2 outputs (existence, schema, shipping-boundary placement). Wire CI workflow updates.

### Task <N-1>.1: <new lint check>

**Files:** Modify: `tests/lint/<name>.sh`

- [ ] **Step 1: Add Check <K>**
- [ ] **Step 2: Run lint locally**
- [ ] **Step 3: Commit**

### Task <N-1>.2: <CI workflow updates>

**Files:** Modify: `.github/workflows/ci.yml`

- [ ] **Step 1: <action>**
- [ ] **Step 2: Commit**

### Phase <N-1> Verification

- [ ] All new checks pass on current tree
- [ ] `bash tests/run-all.sh` → exit 0
- [ ] CI workflow YAML is syntactically valid

---

## Phase <N> — Release Ceremony

<!-- Always HIGH-CAUTION. CHANGELOG entry + MIGRATION.md entry + version bumps + final end-to-end audit + draft PR + squash merge + tag + GitHub release + post-release dogfood. Per release-process.md §4, this is the only phase that pushes (Phase 0 Task 0.1's branch push excepted). -->

**Goal:** Ship v<X.Y.Z>. Instantiate the changelog + migration templates introduced in earlier phases (template dogfooding per `release-process.md` §9). Final end-to-end auditor approves before tag.

### Task <N>.1: Write CHANGELOG v<X.Y.Z> entry (instantiate template)

**Files:** Modify: `CHANGELOG.md`

- [ ] **Step 1: Instantiate from `docs/superpowers/release-process/templates/changelog-entry-template.md`**
- [ ] **Step 2: Verify the v<X.Y.Z> changelog entry is template-derived (dogfood check)**

```bash
diff \
  <(grep -E '^### ' docs/superpowers/release-process/templates/changelog-entry-template.md) \
  <(awk '/^## \[<X.Y.Z>\]/,/^## \[/' CHANGELOG.md | grep -E '^### ') \
  && echo "OK: v<X.Y.Z> CHANGELOG structurally derived from template" \
  || echo "FAIL: changelog entry diverges from template shape (dogfooding gap)"
```

Expected: matching `###` subheads in the same order. Divergence → fix the template OR the entry in-place (this release dogfoods the template; defects fixed pre-tag).

- [ ] **Step 3: Commit**

```bash
git add CHANGELOG.md
git commit -m "docs: add CHANGELOG v<X.Y.Z> entry"
```

### Task <N>.2: Write MIGRATION.md v<prior-version> → v<X.Y.Z> entry (instantiate template)

**Files:** Modify: `docs/MIGRATION.md`

- [ ] **Step 1: Instantiate from `docs/superpowers/release-process/templates/migration-template.md`**
- [ ] **Step 2: Verify the v<X.Y.Z> migration entry is template-derived (dogfood check)**
- [ ] **Step 3: Commit**

### Task <N>.3: Version bumps

**Files:** Modify: `README.md`, `power-engineer/SKILL.md` (if version-referenced)

- [ ] **Step 1: Grep for forward-looking version references**

```bash
grep -rn 'v<prior-version>' README.md power-engineer/ docs/ CHANGELOG.md CLAUDE.md
```

Review each hit individually — historical entries (CHANGELOG past sections, MIGRATION headings) MUST NOT be bumped; only forward-looking current-version text updates to v<X.Y.Z>.

- [ ] **Step 2: Update each occurrence to v<X.Y.Z> where appropriate**
- [ ] **Step 3: Commit**

### Task <N>.4: Final verification + security review

**Files:** None (verification) plus `docs/superpowers/plans/v<X.Y.Z>-security-review.md` (if produced)

- [ ] **Step 1: Run full lint suite** (`bash tests/run-all.sh` → exit 0)
- [ ] **Step 2: Dispatch security-review subagent for any new hook scripts / shell scripts / external surfaces this release introduced**
- [ ] **Step 3: Address findings (in-place fixes; one commit per finding)**
- [ ] **Step 4: Push branch**

```bash
git push
```

- [ ] **Step 5: Create draft PR**

```bash
gh pr create --draft \
  --title "v<X.Y.Z> — <feature-name>" \
  --body "See CHANGELOG.md v<X.Y.Z> entry for summary; docs/MIGRATION.md for upgrade path."
gh pr checks --watch
```

Expected: all CI jobs pass green.

### Task <N>.5: Merge + tag + release

**Files:** None (git / GitHub)

- [ ] **Step 1a: MANDATORY — research subagent for `gh` CLI flag verification**

Per `feedback_external_api_verification.md`, before invoking `gh pr merge`, `gh release create`, or any other gh CLI command this release uses, dispatch a research subagent to confirm current flag semantics. Save findings to `docs/superpowers/plans/v<X.Y.Z>-gh-cli-research.md`. Only proceed after the report is written and reviewed.

- [ ] **Step 1b: Mark PR ready + squash-merge**

```bash
gh pr ready
gh pr merge --squash --admin
```

`--admin` is the documented solo-dev advisory bypass per `release-process.md` §5. Substitute the formalized policy if v<X.Y.Z> introduces one.

- [ ] **Step 1c: Merge-confirmation gate (MANDATORY — halts if merge silently failed)**

```bash
git checkout main
git pull
if ! git log --oneline -20 | grep -qi 'v<X.Y.Z>'; then
  echo "v<X.Y.Z> squash commit not found on main — merge failed or not yet propagated; aborting tag"
  exit 1
fi
```

This guards Step 2 from mis-tagging the pre-merge `main` commit when Step 1b silently fails (rate-limit, permission, CI red).

- [ ] **Step 2: Tag annotated**

```bash
git tag -a v<X.Y.Z> -m "Power Engineer v<X.Y.Z> — <feature-name>"
git push origin v<X.Y.Z>
```

- [ ] **Step 3: Create GitHub release**

```bash
gh release create v<X.Y.Z> \
  --title "v<X.Y.Z> — <feature-name>" \
  --notes-file <(sed -n '/## \[<X.Y.Z>\]/,/## \[/p' CHANGELOG.md | sed '$d')
```

- [ ] **Step 4: Verify release is live** (`gh release view v<X.Y.Z>`)
- [ ] **Step 5: Save session memory** (invoke `/power-engineer save-phase` to dogfood the explicit-save flow)

### Phase <N> Verification

- [ ] CHANGELOG v<X.Y.Z> entry present + uses `### Catalog` subhead
- [ ] `docs/MIGRATION.md` has v<prior-version> → v<X.Y.Z> section with rollback commands
- [ ] Version bumps done (README, SKILL.md if applicable)
- [ ] Security-review report exists; no unresolved blockers
- [ ] PR #N merged via `gh pr merge --squash --admin`
- [ ] Tag `v<X.Y.Z>` pushed; annotated (`git cat-file -t v<X.Y.Z>` = "tag")
- [ ] GitHub release published
- [ ] `/power-engineer save-phase` invoked post-release

---

## Plan-Pattern Verification Gates

<!-- Per `feedback_plan_pattern_verification.md`. The planner authoring THIS plan MUST tick every checkbox below before dispatching to executors. Pattern verification at plan-authoring time prevents zero-match defects from shipping to implementers. -->

**Why this section exists:** LLM training data on shell-pattern semantics is unreliable. v1.3.0 shipped a defective `awk '/^\| Skill \| Description \|/'` pattern that matched zero lines because the actual catalog header had five columns. The pattern survived through six phases before discovery. The institutional rule: when a plan inlines a regex/awk/grep/jq/yq pattern intended to match file structure, the planner spot-checks the pattern against ≥2 representative real files BEFORE shipping the plan to implementers. A pattern that matches zero lines is a defect.

**Scope:** This rule applies to ALL pattern-matching constructs the plan inlines: `awk`/`sed`/`grep`/`rg` regexes, `jq`/`yq` paths, JSON Pointer expressions, CSS selectors, XPath. It does NOT apply to natural-language references to file content (counts, descriptions).

**Planner checklist (tick each row before dispatching to executors):**

| # | Pattern (paste verbatim) | Intended target file(s) — list ≥2 | Expected match count | Actual match count (run the cmd) | PASS / FAIL |
|---|---|---|---|---|---|
| 1 | `<paste pattern>` | `<file 1>`, `<file 2>` | <N> | <N> | <PASS/FAIL> |
| 2 | `<paste pattern>` | `<file 1>`, `<file 2>` | <N> | <N> | <PASS/FAIL> |
| 3 | <add rows for every plan-inlined pattern> | | | | |

**Failure handling:** Any FAIL row blocks dispatch. Fix the pattern in the plan body BEFORE shipping to executors. Rerun the spot-check. Proceed only when every row reads PASS.

**Implementer brief reminder:** Implementers are explicitly told to FLAG plan-pattern deviations rather than silently correct them. Silent correction is a CLAUDE.md violation: it makes plan-text drift undetectable, which means the next implementer reusing the same pattern has no signal that the plan is wrong. Auditors cross-reference duplicate patterns across the plan; if the same pattern appears in two tasks, both need updating when one breaks.

---

## External API Research Gates

<!-- Per `feedback_external_api_verification.md`. The planner identifies every task whose implementation touches an external surface (Claude Code hooks, .claude/settings.json, gh CLI, GitHub REST/GraphQL, MCP, Anthropic SDK, third-party CLIs) and adds a Research-subagent prerequisite. The orchestrator MUST NOT dispatch the implementing Dev for those tasks until the corresponding Research subagent's output is referenced in the Dev's brief. -->

**Why this section exists:** LLM training data on rapidly-evolving API surfaces is stale. v1.3.0 shipped a `PostToolUse` hook with matcher `"compact"` that never fired, because `PostToolUse` matchers filter by tool name — not by session source. The correct schema is `SessionStart` with matcher `"compact"`. The defect surfaced only after a real runtime failure. A Research subagent with current Anthropic docs would have caught the schema mismatch before implementation. The institutional rule: every task that touches an in-scope external surface MUST be gated on a Research-subagent step that pulls current docs BEFORE the implementing Dev runs.

**In-scope surfaces (research subagent required):**

- Claude Code hook surface (`SessionStart`, `SessionEnd`, `PreCompact`, `PostToolUse`, `PreToolUse`, hook matchers, registration shape in `.claude/settings.json`)
- `.claude/settings.json` schema overall (precedence vs `.claude/settings.local.json`, environment-variable expansion semantics)
- GitHub APIs (`gh` CLI flags, REST endpoints, GraphQL queries, rate-limit handling)
- MCP server protocol (tool-use, resources, prompts shape)
- Anthropic SDK (messages API, tool-use, prompt caching, thinking, batch, files)
- Third-party CLIs the orchestration depends on (`skills`, `git` subcommand semantics that differ across versions, `jq`/`yq` flag stability)

**Out-of-scope surfaces (no research subagent required):**

- Internal file edits (module prose, catalog rows, README, MIGRATION) where the implementation is content-only
- Pure bash scripts with no external API surface
- Markdown-only structural changes (heading reorganization, anchor renames)

**Planner checklist (tick each row before dispatching to executors):**

| # | Task | External surface touched | Research subagent dispatched (Phase / Task) | Output saved to | Dev brief references the doc? |
|---|---|---|---|---|---|
| 1 | Task <N.X> | <e.g. Claude Code SessionEnd hook> | Phase 0 Task 0.<X> | `docs/superpowers/plans/v<X.Y.Z>-<topic>-research.md` | <yes/no> |
| 2 | Task <N.X> | <e.g. gh pr merge --admin flag> | Phase <N> Task <N>.5 Step 1a | `docs/superpowers/plans/v<X.Y.Z>-gh-cli-research.md` | <yes/no> |
| 3 | <add rows for every in-scope task> | | | | |

**Failure handling:** Any "no" in the rightmost column blocks dispatch. Authoritative API context must be referenced in the Dev's brief; otherwise the Dev will fall back on stale training-data assumptions and re-introduce the v1.3.0 hook bug.

**Auditor brief reminder:** Auditors verify the Dev consumed the research output correctly (e.g. used the schema shape the research doc reported, not a remembered shape from training). A Dev that ignored the research doc is an ISSUES FOUND finding, even if the implementation happens to work — the discipline is what prevents the next regression.

---

## Risk & Rollback

<!-- Risks ranked by blast radius. Per-phase rollback commands MUST be runnable as-is by the orchestrator (per release-process.md §10). The orchestrator has authority to execute per-phase rollback only after a dual-rejection + user authorization (see release-process.md §10). Full-release rollback (post-tag) ALWAYS requires explicit user authorization. -->

### Biggest risks

- **<Phase X (theme)>** — <one-sentence risk> — Mitigation: <research subagent / lint / dual-auditor / etc.>
- **<Phase Y (theme)>** — <one-sentence risk> — Mitigation: <strategy>
- **Phase <N> (release ceremony)** — first dogfood of any newly-introduced templates; template defects surface here and must be fixed in-place per `release-process.md` §9.

### Rollback per phase

| Phase | Risk | Likelihood | Mitigation | Per-phase rollback command(s) |
|---|---|---|---|---|
| 0 | Working branch contaminated | Low | Branch is empty pre-implementation | `git checkout main && git branch -D v<X.Y.Z>-upgrade` |
| 1 | <risk summary> | <H/M/L> | <mitigation> | `git revert <phase-1-commits>` |
| 2 | <risk summary> | <H/M/L> | <mitigation> | `git revert <phase-2-commits>` |
| ... | <risk summary> | <H/M/L> | <mitigation> | `git revert <phase-N-commits>` |
| <N-1> | Lint extension breaks unrelated check | Low | New checks gated by file-existence guards | `git revert <phase-N-1-commits>` |
| <N> | Tag pushed prematurely / merge-confirmation gate skipped | Low | §10 rollback authority + Step 1c gate; never delete tags without user approval | `git tag -d v<X.Y.Z>; git push --delete origin v<X.Y.Z>; gh release delete v<X.Y.Z> --yes; git revert <squash-commit>` |

### Full-release rollback

```bash
git checkout main
git revert <squash-commit-of-v<X.Y.Z>-PR>
git tag -d v<X.Y.Z>
git push origin :refs/tags/v<X.Y.Z>
gh release delete v<X.Y.Z> --yes
```

Restores v<prior-version> behavior. Document any user-side action required (e.g. re-running `/power-engineer configure` to unregister hooks introduced in v<X.Y.Z>).

---

## Out of Scope

<!-- Force the planner to make scope decisions explicit. Anything in this section is deferred to a future release; an in-flight scope creep request maps onto a row here, not onto an extra task. -->

- **v<X.Y.Z+0.0.1> (patch)**: <items deferred to next patch — typically: late-found defects of this release, polish items>
- **v<X.Y.Z+0.1.0> (next minor)**: <next-minor candidates surfaced during planning — feature ideas that didn't make this scope>
- **v<X.Y.Z+1.0.0> (next major)**: <large architectural shifts noted but deferred>
- **Permanently out of scope**: <items the planner explicitly REJECTS rather than defers — capture the reasoning so future planners do not re-litigate>

---

## Execution Handoff

<!-- The bridge from plan to executor. The executor session consumes the artifacts listed below; this section names them so the orchestrator's first read is unambiguous. -->

Plan complete and saved to `docs/superpowers/plans/power-engineer-v<X.Y.Z>-upgrade-plan.md`. Two execution options:

**1. Subagent-Driven (recommended)** — dispatch a fresh subagent per task; review between tasks; fast iteration. Matches the orchestration pattern documented in `docs/superpowers/release-process/templates/executor-prompt-template.md`.

**2. Inline Execution** — execute tasks in the planning session using `superpowers:executing-plans`; batch execution with checkpoints. Lower throughput; only use when subagent dispatch is unavailable.

**For subagent-driven execution, instantiate `docs/superpowers/release-process/templates/executor-prompt-template.md`** at `docs/superpowers/prompts/v<X.Y.Z>-executor.md` (typically gitignored — `git add -f` if you want it tracked). Replace placeholders (`<X.Y.Z>`, `<feature-name>`, `<prior-version>`, `<YYYY-MM-DD>`) and fill the per-phase execution table at the bottom with the model assignments + HIGH-CAUTION flags.

**Required executor inputs (the orchestrator must read these before dispatching any subagent):**

1. This plan file
2. The companion spec at `docs/superpowers/specs/<YYYY-MM-DD>-power-engineer-v<X.Y.Z>-<feature-name>.md`
3. Brainstorm memory `project_v<X.Y.Z>_brainstorm.md` (locked architectural decisions — do NOT re-litigate)
4. Prior release retrospective `project_v<prior-version>_released.md`
5. Both feedback memories cited in this plan: `feedback_plan_pattern_verification.md`, `feedback_external_api_verification.md`
6. `CLAUDE.md` (universal `AskUserQuestion` enforcement, memory management, session orchestration)
7. `docs/superpowers/release-process/release-process.md` (cross-cutting policy)
8. `power-engineer/references/modules/subagent-selector.md` (model-assignment decision table)

**The executor prompt codifies (per `release-process.md` and the executor template):**
- Subagent-selector consultation per dispatch
- Research-subagent step required for every task in the External API Research Gates table above
- Pattern spot-check required for every row in the Plan-Pattern Verification Gates table above
- Audit gates + HIGH-CAUTION dual-auditor rule for any phase with irreversible operations
- Push-at-release-time policy (Phase <N> only; Phase 0 Task 0.1 is the documented exception)
- Per-phase user checkpoint with empty checkpoint commit + memory save via `/power-engineer save-phase`
- Rollback authority limited to dual-rejection + user-approved per-phase rollback; full-release rollback always requires explicit user authorization

---

*End of plan template. Replace every `<placeholder>` before dispatching to an executor session. The Phase N-1 lint task in this plan will assert structural invariants of the resulting plan; misplacements (e.g. release-process kit landing inside `power-engineer/`) are BLOCKERS at audit time.*
