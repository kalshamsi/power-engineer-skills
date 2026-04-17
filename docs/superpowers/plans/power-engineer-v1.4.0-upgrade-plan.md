# Power Engineer v1.4.0 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship catalog hygiene (`.catalog-version` + CHANGELOG `### Catalog` convention + 8 catalog gap-fixes) plus Cluster B agent infrastructure (3-tier memory management, subagent model-selection reference, release-process framework kit) via aggressive-dogfooding (Approach B′) with graceful fallback contracts.

**Architecture:** 9 phases. Meta-infra in early phases (1-2) so Phases 3-9 dogfood it. Catalog hygiene foundation (3-4) before catalog content change (5). Release-process kit (6) enables Phase 9 template instantiation. Tests/docs (7-8) followed by release ceremony (9). Every meta-infra piece has a documented graceful-fallback contract that degrades to v1.3.0 proven patterns.

**Tech Stack:** Bash, GitHub Actions, existing Markdown module/catalog/flow structure, Claude Code hooks system (new: `SessionEnd`, `PreCompact` hooks alongside existing `SessionStart`/"compact"), `jq`/`yq` (Phase 0 only, for ecosystem research).

**Related artifacts:**
- Spec: `docs/superpowers/specs/2026-04-16-power-engineer-v1.4.0-design.md`
- Feedback memories consumed during authoring: `feedback_plan_pattern_verification.md` (regex patterns verified against ≥2 real files), `feedback_external_api_verification.md` (hook/settings tasks gate on research-subagent output)

---

## File Structure

Files created or modified, grouped by responsibility:

**Meta-infra (shipped in `power-engineer/`):**
- Create: `power-engineer/references/modules/subagent-selector.md` — prose + 3-axis decision table
- Create: `power-engineer/references/flows/save-phase.md` — `/power-engineer save-phase` handler
- Modify: `power-engineer/references/modules/configurator.md` — `subagent_model_mode` schema + SessionEnd/PreCompact hook registration
- Modify: `power-engineer/references/modules/questionnaire.md` — new Q14 asking subagent model mode preference
- Modify: `power-engineer/SKILL.md` — add `save-phase` route

**Memory hook scripts (shipped INSIDE the skill — `power-engineer/` subtree):**
- Create: `power-engineer/scripts/hooks/session-end-handoff.sh` — bash script, executable, shellcheck-clean
- Create: `power-engineer/scripts/hooks/pre-compact-snapshot.sh` — bash script, executable, shellcheck-clean
- Scripts ship INSIDE `power-engineer/` because `npx skills add` copies only that subtree to end-user machines. Maintainer-only scripts at repo root (`scripts/update-skill-count.sh`, etc.) do NOT ship.
- The configurator references these paths in `.claude/settings.json`'s hook registration blocks via `$CLAUDE_PROJECT_DIR/power-engineer/scripts/hooks/...` (dogfood — in-repo) OR `$CLAUDE_PROJECT_DIR/.claude/hooks/...` (end-user — after configurator's copy-step). Standalone files enable ShellCheck coverage (Phase 7 Task 7.3) and unit-testability.

**Catalog hygiene:**
- Create: `power-engineer/.catalog-version` — single-line semver, no trailing newline
- Modify: `power-engineer/references/catalog/docs-research.md` — add 7 `tavily-*` sub-skill rows
- Modify: `power-engineer/references/catalog/frontend/design-systems.md` — add `stitch-design` row
- Modify: `CHANGELOG.md` — retroactive `### Catalog` subhead for v1.3.0 entry, then full v1.4.0 entry (Phase 9)
- Modify: `docs/CONTRIBUTING.md` — document the `### Catalog` convention

**Release-process framework (maintainer-only, force-committed):**

All files in this group live OUTSIDE `power-engineer/` by the writing-skills packaging boundary invariant: `power-engineer/**` ships via `npx skills add`; `docs/**` does not. Any task that produces a file in this group must place it under `docs/superpowers/release-process/`; a misplacement inside `power-engineer/` is a BLOCKER. A Phase 7 lint assertion (Task 7.1) enforces this.

- Create: `docs/superpowers/release-process/release-process.md`
- Create: `docs/superpowers/release-process/templates/planner-prompt-template.md`
- Create: `docs/superpowers/release-process/templates/executor-prompt-template.md`
- Create: `docs/superpowers/release-process/templates/plan-template.md`
- Create: `docs/superpowers/release-process/templates/changelog-entry-template.md`
- Create: `docs/superpowers/release-process/templates/migration-template.md`
- Create: `docs/superpowers/release-process/templates/parity-doc-template.md` (optional usage)
- Create: `docs/superpowers/release-process/templates/behavioral-validation-template.md` (optional usage)

**Tests/CI:**
- Modify: `tests/lint/catalog-integrity.sh` — new Check 7 (`.catalog-version` existence + format) + new Check 8 (CHANGELOG `### Catalog` subhead presence per release)
- Modify: `tests/lint/doc-structure.sh` — new assertions (subagent-selector module, selector module + save-phase flow + Q14 + `subagent_model_mode` in configurator + new hooks in configurator)
- Modify: `.github/workflows/ci.yml` — new `catalog-version-sync` job (enforces bump when catalog changes) + ShellCheck run on new hook scripts
- Modify: `tests/README.md` — document new lint additions

**Release (Phase 9):**
- Modify: `CHANGELOG.md` — v1.4.0 entry instantiated from `docs/superpowers/release-process/templates/changelog-entry-template.md`
- Modify: `docs/MIGRATION.md` — v1.3.0 → v1.4.0 entry instantiated from migration template
- Modify: `README.md` — version bumps + badge updates
- Modify: `power-engineer/SKILL.md` — version bump if applicable

---

## Phase 0 — Audit & Prep

**Goal:** Create working branch, commission memory ecosystem research (Explore subagent), and establish `.catalog-version` baseline at v1.3.0 so subsequent phases have known starting state.

### Task 0.1: Create working branch

**Files:** None (git operation)

- [ ] **Step 1: Create branch tracking origin**

```bash
git checkout main
git pull
git checkout -b v1.4.0-upgrade
git push -u origin v1.4.0-upgrade
```

Expected: new branch `v1.4.0-upgrade` tracks `origin/v1.4.0-upgrade`.

- [ ] **Step 2: Confirm clean starting state**

```bash
git status
bash tests/run-all.sh
```

Expected: clean tree; `tests/run-all.sh` exits 0 (all 5 v1.3.0 lint scripts pass).

### Task 0.2: Memory ecosystem research (Explore subagent)

**Files:** Create: `docs/superpowers/plans/v1.4.0-memory-research.md` (evidence doc; force-committed)

- [ ] **Step 1: Dispatch Explore subagent with two-section brief**

Dispatch an Explore subagent with the following brief (`superpowers:dispatching-parallel-agents` for mechanics):

> Two-section memory ecosystem research for Power Engineer v1.4.0. Read-only.
>
> **Section 1 — Claude Code skills marketplace:** Search for memory-adjacent skills in:
> - `obra/superpowers` (skill repo)
> - `mattpocock/skills` (skill repo)
> - `anthropic/skills` (skill repo)
> - the `skills` CLI registry (browse or search top-scoring)
>
> For each candidate: report name, maintainer, GH stars, last commit date, memory model (how it stores/retrieves), automatic-firing support (hooks, triggers), alignment with power-engineer's 4-type semantics (user/feedback/project/reference), and adoption fit score 0–100%.
>
> **Section 2 — MCP memory servers + architectural patterns:** Investigate top 3 open-source memory systems for AI agents: mem0 (mem0ai/mem0), zep (zepai/zep), supermemory, plus any others with high activity.
>
> For each: report storage model, retrieval strategy, compaction approach, namespace/tenant model, MCP compatibility, transferable patterns we could borrow.
>
> **Output:** Adopt / Adapt / Build recommendation with reasoning. Adopt threshold = 90%+ alignment with power-engineer semantics. Save report to `docs/superpowers/plans/v1.4.0-memory-research.md`.

- [ ] **Step 2: Review subagent output**

Read the generated report. Confirm:
- Section 1 contains ≥3 candidates evaluated
- Section 2 contains ≥3 MCP/pattern investigations
- Final recommendation is one of: Adopt / Adapt / Build
- Reasoning is explicit

**Branching on recommendation:**
- **Build** or **Adapt** → continue to Task 0.3 as planned. Phase 2's 3-tier memory architecture stands.
- **Adopt \<skill\>** → STOP. Phase 2's architecture is predicated on Build. Adopting an external skill would replace SessionEnd + PreCompact hook implementations with that skill's memory surface. This materially changes Phase 2–7 scope. Escalate to the maintainer via `AskUserQuestion` with these options:
  - "Accept Adopt recommendation — re-plan Phase 2" (pauses execution; planning session re-opens)
  - "Override: proceed with Build anyway" (continues current plan)
  - "Reject Adopt, downgrade to Adapt" (continues current plan with adoption-informed patterns)

Do NOT continue to Task 0.3 until the maintainer has resolved the Adopt branch.

**Completion semantics if "Accept Adopt" is chosen:** The executor (a) completes Task 0.3 (`.catalog-version` baseline) since it is architecture-independent, (b) marks Phase 0 verification gates as MET, then (c) PAUSES all subsequent execution (do NOT begin Phase 1) until the maintainer's re-planning session produces an updated plan covering the new Phase 2 architecture. The original `v1.4.0-upgrade` branch remains; phases 1+ work resumes on the updated plan.

- [ ] **Step 3: Commit the research doc**

```bash
git add -f docs/superpowers/plans/v1.4.0-memory-research.md
git commit -m "docs(v1.4.0): memory ecosystem research report (Phase 0)"
```

Note: `-f` because `plans/` is gitignored (v1.3.0 precedent).

### Task 0.3: Initialize `.catalog-version` baseline at 1.3.0

**Files:** Create: `power-engineer/.catalog-version`

Per Explore subagent findings (Phase 0 of planning session): `.skills-cli-version` is a single-line semver with no trailing newline. `.catalog-version` matches that shape.

- [ ] **Step 1: Write the baseline file**

```bash
printf '1.3.0' > power-engineer/.catalog-version
```

Using `printf` (not `echo`) to avoid trailing newline. v1.3.0 value represents the catalog as it exists today.

- [ ] **Step 2: Verify file shape**

```bash
wc -c < power-engineer/.catalog-version
# Expected: 5 (bytes for "1.3.0", no newline)

hexdump -C power-engineer/.catalog-version
# Expected: `00000000  31 2e 33 2e 30  |1.3.0|` with no trailing 0a
```

- [ ] **Step 3: Commit**

```bash
git add power-engineer/.catalog-version
git commit -m "feat(v1.4.0): initialize .catalog-version at 1.3.0 baseline"
```

### Phase 0 Verification

- [ ] Branch `v1.4.0-upgrade` exists and tracks origin
- [ ] `docs/superpowers/plans/v1.4.0-memory-research.md` exists with ≥3 candidates evaluated + explicit recommendation
- [ ] `power-engineer/.catalog-version` exists; `wc -c` = 5; no trailing newline
- [ ] `bash tests/run-all.sh` → exit 0 (existing v1.3.0 lint unaffected)

---

## Phase 1 — Subagent-Selector Module

**Goal:** Ship the `subagent-selector.md` module + user-configurable mode (state.json preference, new questionnaire entry, configurator integration, consumer-side docs). Subagent-selector is advisory — the orchestrator reads `state.json.preferences.subagent_model_mode` and either consults the 3-axis table (`selector` mode), uses a forced model (`force-*` modes), or defaults to Opus (`none` mode). Phases 2–9 reference this module when dispatching.

### Task 1.1: Write `subagent-selector.md` module

**Files:** Create: `power-engineer/references/modules/subagent-selector.md`

- [ ] **Step 1: Write the module content**

Create the file with sections:
1. **Overview** — what the module is, why it exists, how the orchestrator consumes it
2. **Modes** — the 5-value enum from state.json (`selector`, `force-opus`, `force-sonnet`, `force-haiku`, `none`), what each does, default
3. **Decision table (selector mode)** — 3-axis table with 5 task profiles × risk × parallelism cells, explicit model per cell
4. **Cost footnote** — when to downgrade
5. **Fallback contract** — module unreachable / corrupt / missing → orchestrator defaults to Opus
6. **Examples** — 3–4 dispatch scenarios mapped to model choice

Decision table structure:

```markdown
| Task profile | Low-risk single | High-risk single | Low-risk parallel fan-out |
|---|---|---|---|
| Mechanical | Sonnet | Sonnet | Sonnet ×N parallel |
| Judgment | Sonnet | Opus | — (judgment rarely fans out) |
| Audit | Opus | Opus | — (audit is serial by design) |
| Remediation | Opus | Opus | — (remediation is serial) |
| Research | Sonnet | Sonnet | — (research is serial) |
```

- [ ] **Step 2: Commit**

```bash
git add power-engineer/references/modules/subagent-selector.md
git commit -m "feat(subagent-selector): add 3-axis decision-table reference module"
```

### Task 1.2: Add Q14 to `questionnaire.md`

**Files:** Modify: `power-engineer/references/modules/questionnaire.md`

Per Explore subagent: Q1-Q13 exist; Q14 inserts after Q13's option block. Q14 is NOT auto-skippable (user preference, not scan-inferred). Batching: include in a late-stage batch with other late questions.

- [ ] **Step 1: Add Q14 section**

Insert immediately after Q13's final option block AND any trailing note/separator, before Q14 would begin. Locate insertion point semantically: search for the end of Q13's code fence (the closing ` ``` ` after Q13's last option), then any trailing note/paragraph, then insert BEFORE the next `### ` heading or the end-of-section `---` separator. Do NOT rely on a literal line number — Q13's length evolves. Verify your insertion point by running `grep -cE '^### Q[0-9]+' power-engineer/references/modules/questionnaire.md` and confirming the count is 14 after insertion (was 13 before).

```markdown
### Q14 -- Subagent model mode

\`\`\`
question: "When power-engineer dispatches subagents, which model-selection policy should apply by default?"
header: "Model mode"
multiSelect: false
options:
  - label: "Use selector (Recommended)"
    description: "Consult the 3-axis decision table (task profile × risk × parallelism) to pick the right model per dispatch. Balances cost and correctness."
  - label: "Force Opus for all subagents"
    description: "Maximum reasoning; highest cost. Choose when correctness is paramount and budget isn't a concern."
  - label: "Force Sonnet for all subagents"
    description: "Fast and accurate for mechanical work. Choose for cost-efficient tier-2 tasks."
  - label: "Force Haiku for all subagents"
    description: "Cheapest tier. Only use if tasks are simple enough for Haiku to handle reliably."
  - label: "None — orchestrator picks ad-hoc"
    description: "No guidance consulted. Orchestrator defaults to Opus for safety but may override per-dispatch."
\`\`\`

Always ask; this question is a user preference, not inferred from scan. Maps to `state.json.preferences.subagent_model_mode` enum: `selector` / `force-opus` / `force-sonnet` / `force-haiku` / `none`. Default when skipped: `selector`.
```

- [ ] **Step 2: Run questionnaire Q-count check**

```bash
grep -cE '^### Q[0-9]+' power-engineer/references/modules/questionnaire.md
# Expected: 14 (was 13; now 14 after Q14 addition)
```

Note: `doc-structure.sh` assertion uses `-ge 12`, so 14 still passes. No assertion update needed.

- [ ] **Step 3: Commit**

```bash
git add power-engineer/references/modules/questionnaire.md
git commit -m "feat(questionnaire): add Q14 for subagent_model_mode preference"
```

### Task 1.3: Update `configurator.md` — `subagent_model_mode` schema

**Files:** Modify: `power-engineer/references/modules/configurator.md`

Per Explore subagent: preferences block at lines 72-76. Insert new field after `skills_cli_version`.

- [ ] **Step 1: Extend the preferences schema**

Locate the existing block:

```json
"preferences": {
  "security_level": "standard",
  "auto_update": true,
  "skills_cli_version": "1.2.3"
}
```

Replace with:

```json
"preferences": {
  "security_level": "standard",
  "auto_update": true,
  "skills_cli_version": "1.2.3",
  "subagent_model_mode": "selector"
}
```

- [ ] **Step 2: Add documentation section for the new field**

After the existing preferences field documentation, add:

```markdown
**`subagent_model_mode`** — Policy governing how the orchestrator selects models when dispatching subagents.

- Allowed values: `"selector"` (default) · `"force-opus"` · `"force-sonnet"` · `"force-haiku"` · `"none"`
- Set at project instantiation via Q14 (see `questionnaire.md`).
- Editable via `/power-engineer configure`.
- Consumed by `subagent-selector.md` fallback contract: missing or unreadable → orchestrator defaults to Opus (safe).
```

- [ ] **Step 3: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): add subagent_model_mode to state.json preferences schema"
```

### Task 1.4: Document consumer-side usage

**Files:** Modify: `power-engineer/references/modules/subagent-selector.md` (already created in 1.1; extend)

- [ ] **Step 1: Add "How the orchestrator reads this" section**

Append to the end of `subagent-selector.md`:

```markdown
## How the orchestrator reads this

Before dispatching ANY subagent, the orchestrator:

1. Reads `.power-engineer/state.json` to get `preferences.subagent_model_mode`.
2. Branches on the value:
   - `"selector"` → consults the decision table above with the task's (profile, risk, parallelism) tuple
   - `"force-opus"` | `"force-sonnet"` | `"force-haiku"` → uses that model for every dispatch; ignores the table
   - `"none"` → no guidance; orchestrator defaults to Opus for safety
3. Records the chosen model + rationale in the subagent dispatch prompt so downstream review can audit model-selection decisions.

If `state.json` is unreadable or missing the field, defaults to `"selector"`. If this module file is unreadable, defaults to Opus (safest).
```

- [ ] **Step 2: Commit**

```bash
git add power-engineer/references/modules/subagent-selector.md
git commit -m "docs(subagent-selector): add consumer-side orchestrator integration"
```

### Phase 1 Verification

- [ ] `power-engineer/references/modules/subagent-selector.md` exists with 3-axis table + 5 modes + fallback contract + orchestrator integration doc
- [ ] `questionnaire.md` has Q14 (grep `-cE '^### Q[0-9]+'` = 14)
- [ ] `configurator.md` preferences block includes `subagent_model_mode` with default `"selector"`
- [ ] `bash tests/run-all.sh` → exit 0 (no regressions; doc-structure lint still passes)

---

## Phase 2 — Memory Management (3 tiers + fallback)

**Goal:** Implement the 3-tier memory architecture — `/power-engineer save-phase` slash command (explicit phase-level ceremony), `SessionEnd` hook (automatic handoff generation), `PreCompact` hook (automatic context-snapshot). Each tier has a documented graceful-fallback contract (hook failure → log to `.power-engineer/memory-errors.log` → manual write continues per CLAUDE.md rules).

**CRITICAL (per `feedback_external_api_verification.md`):** Task 2.1 dispatches a research subagent to pull current Claude Code hooks documentation BEFORE any implementation touches `.claude/settings.json` or hook registration. LLM training data on Claude Code hooks is stale (v1.3.0 hit a PostToolUse/"compact" bug for exactly this reason). Implementers consume research output as authoritative context.

### Task 2.1: Research subagent — current Claude Code hooks docs

**Files:** Create: `docs/superpowers/plans/v1.4.0-hooks-research.md` (research output; force-committed)

- [ ] **Step 1: Dispatch research subagent**

Dispatch with brief:

> Research subagent for Power Engineer v1.4.0 Phase 2. Read-only.
>
> Pull current Claude Code hooks documentation from official sources. For EACH of the following hooks, report: (a) exact schema shape in `.claude/settings.json` (nested vs flat, matcher semantics), (b) firing semantics (when exactly does it fire, what context is available), (c) known gotchas, (d) example registration block.
>
> Hooks to research:
> - `SessionStart` (matcher values accepted: "startup", "compact", others?)
> - `SessionEnd` (confirm availability + firing conditions; does it always fire or only on clean exit?)
> - `PreCompact` (availability + what state is captured, can hook abort compaction?)
> - `SubagentStop` (for completeness; NOT being used in v1.4.0 but context helps)
> - `Stop` (for completeness)
>
> Also report: exact file paths the configurator writes hook scripts to (.claude/hooks/), and whether `settings.local.json` vs `settings.json` takes precedence.
>
> Also report: for a skill installed via `npx skills add <user/repo>` (skill code extracted to `~/.claude/skills/<skill>/`), at hook invocation time, does `$CLAUDE_PROJECT_DIR` resolve to the user's project root OR to `~/.claude/skills/<skill>/`? Where must the `command` field point (absolute path into `~/.claude/skills/<skill>/`, or a copied path under `$CLAUDE_PROJECT_DIR/.claude/hooks/`)? Cite official docs. This is a FUTURE-RELEASE-PROOFING bullet: the question captures the institutional knowledge so future releases using this brief as a template explicitly enumerate end-user path resolution.
>
> **Output:** Structured markdown report saved to `docs/superpowers/plans/v1.4.0-hooks-research.md`. Implementers in Tasks 2.2-2.5 consume this as authoritative schema reference.

- [ ] **Step 2: Review research output**

Read the generated file. Confirm:
- `SessionEnd` availability + firing conditions are explicit
- `PreCompact` schema is explicit (nested `{type, command}` per v1.3.0 fix pattern expected)
- Any schema differences from training-data assumptions are flagged

- [ ] **Step 3: Commit research doc**

```bash
git add -f docs/superpowers/plans/v1.4.0-hooks-research.md
git commit -m "docs(v1.4.0): hooks-surface research report (Phase 2 prerequisite)"
```

### Task 2.2: Implement SessionEnd hook registration in configurator.md

**Files:** Modify: `power-engineer/references/modules/configurator.md`

Implementer consumes `docs/superpowers/plans/v1.4.0-hooks-research.md` as authoritative schema. **Hook scripts ship as standalone files at `power-engineer/scripts/hooks/session-end-handoff.sh` and `power-engineer/scripts/hooks/pre-compact-snapshot.sh`** (NOT heredocs inside configurator.md — this enables ShellCheck coverage + better testability). Configurator references these script paths directly in its hook registration block. At user-install time, configurator copies them to `.claude/hooks/` in the user's project; configurator then registers the COPIED path in `.claude/settings.json`.

**Two registration shapes exist — choose the right one for context:**
- **Dogfood (this repo's own `.claude/settings.json`, Task 2.7):** uses `$CLAUDE_PROJECT_DIR/power-engineer/scripts/hooks/...` — works because we're in the skill's source tree.
- **End-user (what the configurator writes for skill installs, THIS TASK 2.2):** the configurator COPIES scripts from `~/.claude/skills/power-engineer/scripts/hooks/*.sh` → `<user-project>/.claude/hooks/*.sh`, then registers them as `$CLAUDE_PROJECT_DIR/.claude/hooks/<script>.sh`.

The registration-example JSON in configurator.md MUST reflect the end-user case (since that's what users see); Task 2.7 separately handles the dogfood variant.

- [ ] **Step 1: Read research output first**

Implementer reads `docs/superpowers/plans/v1.4.0-hooks-research.md` in full. Quote exact schema shape being used.

- [ ] **Step 2: Add SessionEnd hook block to configurator.md**

Insert next to existing SessionStart/"compact" block:

```markdown
### SessionEnd hook — automatic session handoff

The configurator writes `.claude/hooks/session-end-handoff.sh` (contents below) and registers it under `SessionEnd` in `.claude/settings.json` using the current documented schema (see `docs/superpowers/plans/v1.4.0-hooks-research.md` for the verified shape).

[... script body as heredoc ...]

Registration shape (verified against current Claude Code docs — see `v1.4.0-hooks-research.md` "Do: Quote paths with `$CLAUDE_PROJECT_DIR` in JSON"; nested `{matcher?, hooks:[{type, command, timeout}]}` schema):

\`\`\`json
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-end-handoff.sh",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
\`\`\`

This is the post-copy path. The configurator copies `power-engineer/scripts/hooks/session-end-handoff.sh` → `.claude/hooks/session-end-handoff.sh` at configure time, then registers the copied path.

Fallback contract: if the hook errors on invocation, output is redirected to `.power-engineer/memory-errors.log`. Claude continues via existing CLAUDE.md auto-memory rules without interruption.
```

- [ ] **Step 3: Run doc-structure.sh**

```bash
bash tests/lint/doc-structure.sh
# Expected: PASS (no new assertions yet — Phase 7 adds them)
```

- [ ] **Step 4: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): add SessionEnd hook for automatic session handoff"
```

### Task 2.3: Implement PreCompact hook registration in configurator.md

**Files:** Modify: `power-engineer/references/modules/configurator.md`

- [ ] **Step 1: Consult research output**

Implementer reads `docs/superpowers/plans/v1.4.0-hooks-research.md` for `PreCompact` specifics. Quote the confirmed schema shape.

- [ ] **Step 2: Add PreCompact hook block**

Similar structure to Task 2.2 — standalone script file at `power-engineer/scripts/hooks/pre-compact-snapshot.sh`, registration block, fallback contract note. Same dogfood-vs-end-user disambiguation applies: the configurator's end-user-facing example uses `$CLAUDE_PROJECT_DIR/.claude/hooks/pre-compact-snapshot.sh` (post-copy path); this repo's own `.claude/settings.json` (Task 2.7) uses `$CLAUDE_PROJECT_DIR/power-engineer/scripts/hooks/pre-compact-snapshot.sh` (dogfood path).

- [ ] **Step 3: Verify hook registration schema**

Confirm the combined `settings.json` fragment in configurator.md includes BOTH SessionEnd and PreCompact hooks using the nested `{type, command}` schema.

- [ ] **Step 4: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): add PreCompact hook for context-crunch safety"
```

### Task 2.4: Implement `/power-engineer save-phase` flow

**Files:**
- Create: `power-engineer/references/flows/save-phase.md`
- Modify: `power-engineer/SKILL.md` — add router row

- [ ] **Step 1: Write save-phase.md flow**

Flow responsibilities:
1. Read current session state (git log since last checkpoint commit, modified files, current todos)
2. Prompt user (`AskUserQuestion`) for phase number + brief summary
3. Write structured memory file to `~/.claude/projects/<proj>/memory/project_v<X>_phase<N>.md` with frontmatter (name, description, type=project, originSessionId) matching v1.3.0 phase memory shape
4. Append one line to `MEMORY.md` index (staying under 200-line cap)
5. Optionally create empty checkpoint commit (matches v1.3.0 `checkpoint: Phase <N> complete`)

- [ ] **Step 2: Add router row to SKILL.md**

Per Explore subagent: router table at SKILL.md lines 34-56. Insert between existing `configure` row and the fallback:

```markdown
| "power engineer save-phase"              | Read `references/flows/save-phase.md`                     |
```

- [ ] **Step 3: Verify router symmetry**

```bash
bash tests/lint/doc-structure.sh
# Expected: PASS (save-phase route present; flow file exists)
```

- [ ] **Step 4: Commit**

```bash
git add power-engineer/references/flows/save-phase.md power-engineer/SKILL.md
git commit -m "feat(flows): add /power-engineer save-phase for explicit phase-memory ceremony"
```

### Task 2.5: Document fallback contracts + memory-errors.log

**Files:** Modify: `power-engineer/references/modules/configurator.md`

- [ ] **Step 1: Add fallback-contracts section**

Add a top-level "Memory fallback contracts" section to configurator.md describing:
- What happens when SessionEnd hook fails (log + continue)
- What happens when PreCompact hook fails (log + continue)
- What happens when save-phase command cannot write memory (user prompted; no data loss)
- Where errors log: `.power-engineer/memory-errors.log`
- How to debug (tail the log; check `.claude/hooks/*.sh` for executability)

- [ ] **Step 2: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "docs(configurator): document 3-tier memory fallback contracts"
```

### Task 2.6: Update permissions.md if new hook scripts require execution allow-lists

**Files:** Modify: `power-engineer/references/modules/permissions.md` (if applicable)

- [ ] **Step 1: Check whether hook scripts need Bash allow-list entries**

v1.3.0's permissions.md has a PreToolUse hook allowing `npx skills` patterns. The new session-end/precompact hooks run WITHOUT triggering PreToolUse (they're invoked by Claude Code's hook system, not by Claude as a Bash tool call). So no permissions changes are expected.

If the research subagent's output reveals otherwise, add permission entries here.

Also verify `.claude/settings.local.json` was not accidentally committed in Phase 2's work (it should be gitignored per `.gitignore`'s `.claude/*` pattern + `!.claude/settings.json` allowlist). Run:

```bash
git ls-files .claude/
# Expected: ONLY .claude/settings.json is tracked
```

If `settings.local.json` is tracked, unblock via:

```bash
git rm --cached .claude/settings.local.json
git commit -m "fix: untrack accidentally-committed .claude/settings.local.json"
```

- [ ] **Step 2: Commit if changes made (else skip)**

If this task made no changes, SKIP the commit entirely (do not commit an empty message). Otherwise:

```bash
git add power-engineer/references/modules/permissions.md
git commit -m "fix(permissions): update permission entries for new hook scripts"
```

### Task 2.7: Install v1.4.0 hooks on the power-engineer-skills repo's own `.claude/settings.json`

**Goal:** Make dogfooding literal. The v1.4.0 release session itself exercises SessionEnd + PreCompact hooks across Phases 3–9.

**Files:** Modify: `.claude/settings.json` (repo-root config; tracked)

- [ ] **Step 1: Read current `.claude/settings.json`**

Record the existing `SessionStart`/"compact" hook block shape for reference.

- [ ] **Step 2: Add SessionEnd + PreCompact hook registrations (DOGFOOD variant)**

Using the schema verified in Task 2.1's research output (and consumed in Tasks 2.2/2.3), add entries under `hooks`. This repo's own `.claude/settings.json` uses the DOGFOOD path (`$CLAUDE_PROJECT_DIR/power-engineer/scripts/hooks/...`) because the skill source tree IS the project — end-user configure NEVER emits this variant. The registration uses the canonical NESTED `{matcher?, hooks:[{type, command, timeout}]}` schema (not flat `{type, command}`):

```json
{
  "hooks": {
    "SessionStart": [ ... existing ... ],
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/power-engineer/scripts/hooks/session-end-handoff.sh",
            "timeout": 60
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/power-engineer/scripts/hooks/pre-compact-snapshot.sh",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 3: Verify script files exist and are executable**

```bash
test -x power-engineer/scripts/hooks/session-end-handoff.sh
test -x power-engineer/scripts/hooks/pre-compact-snapshot.sh
```

(These files ship inside the skill tree — `power-engineer/scripts/hooks/` — so `npx skills add` copies them to end-user machines. They are authored in Tasks 2.2 + 2.3 as standalone files.)

- [ ] **Step 4: Commit**

```bash
git add .claude/settings.json
git commit -m "feat(v1.4.0): install SessionEnd + PreCompact hooks on repo's own settings for dogfooding"
```

### Task 2.8: Fix configurator end-user-vs-dogfood path disambiguation + update hooks-research.md paths

**Goal:** Ensure configurator.md's example JSON reflects the END-USER case (post-copy `.claude/hooks/` path), not the DOGFOOD case (in-repo `power-engineer/scripts/hooks/` path). Update the hooks-research.md artifact to match post-Phase-2 relocation. Addresses audit findings B4 (configurator end-user-vs-dogfood path disambiguation) + L26 (hooks-research.md stale paths).

**Context:** Phase 2 commit `d747e07` relocated hook scripts to `power-engineer/scripts/hooks/`. The committed `configurator.md` currently uses `$CLAUDE_PROJECT_DIR/power-engineer/scripts/hooks/...` in its example JSON — which works for dogfood but 404s at end-user install time (because `$CLAUDE_PROJECT_DIR/power-engineer/` does not exist in an end-user's project). This task reconciles configurator.md to the end-user case.

**Files:**
- Modify: `power-engineer/references/modules/configurator.md` — change SessionEnd + PreCompact registration example JSON to end-user paths; add Dogfood-variant callout
- Modify: `docs/superpowers/plans/v1.4.0-hooks-research.md` — replace `scripts/hooks/...` with `power-engineer/scripts/hooks/...` (6 occurrences per Auditor 2 F15)

- [ ] **Step 1: Update configurator.md SessionEnd + PreCompact example JSON to end-user paths**

Change both example JSON blocks so `command` reads `$CLAUDE_PROJECT_DIR/.claude/hooks/session-end-handoff.sh` (and likewise `pre-compact-snapshot.sh`). These are the post-copy paths — what configurator actually writes to end-user projects.

- [ ] **Step 2: Add "Dogfood variant" callout to configurator.md**

Below each updated example JSON, insert a callout:

```markdown
**Dogfood variant (this repo only):** The power-engineer-skills repo's own `.claude/settings.json` uses the PRE-COPY path `$CLAUDE_PROJECT_DIR/power-engineer/scripts/hooks/session-end-handoff.sh` (and likewise for PreCompact) because we ARE in the skill's source tree. End-user configure NEVER emits this variant. See this repo's `.claude/settings.json` for the dogfood shape.
```

- [ ] **Step 3: Update hooks-research.md paths**

Search and replace in `docs/superpowers/plans/v1.4.0-hooks-research.md`:

```bash
grep -n 'scripts/hooks/' docs/superpowers/plans/v1.4.0-hooks-research.md
# Expected: 6 occurrences (per Auditor 2 F15)
```

Replace each `scripts/hooks/...` (root-level, non-power-engineer-prefixed) with `power-engineer/scripts/hooks/...`. Do NOT modify any occurrences that are already prefixed with `power-engineer/`.

- [ ] **Step 4: Commit (two separate commits)**

```bash
# Configurator update
git add power-engineer/references/modules/configurator.md
git commit -m "fix(configurator): emit end-user .claude/hooks/ path in registration example + add dogfood-variant callout"

# hooks-research.md update (force-added; plans/ is gitignored)
git add -f docs/superpowers/plans/v1.4.0-hooks-research.md
git commit -m "docs(v1.4.0): update hooks-research paths post-Phase-2 relocation — addresses audit L26"
```

### Phase 2 Verification

- [ ] `docs/superpowers/plans/v1.4.0-hooks-research.md` exists with `SessionEnd` + `PreCompact` schemas verified against current docs (paths updated post-Phase-2 per Task 2.8)
- [ ] `configurator.md` references BOTH new hooks with nested `{matcher?, hooks:[{type, command, timeout}]}` schema; example JSON shows end-user path (`$CLAUDE_PROJECT_DIR/.claude/hooks/...`) with Dogfood-variant callout
- [ ] `save-phase.md` flow exists; SKILL.md router has `save-phase` row
- [ ] Fallback contracts documented in `configurator.md`
- [ ] `bash tests/run-all.sh` → exit 0

---

## Phase 3 — `.catalog-version` Mechanism + CI Enforcement

**Goal:** Harden the `.catalog-version` baseline initialized in Phase 0 with lint + CI enforcement. Lint checks existence + format; CI checks that version bumps when catalog files change.

### Task 3.1: Add `.catalog-version` lint check to `catalog-integrity.sh`

**Files:** Modify: `tests/lint/catalog-integrity.sh`

- [ ] **Step 1: Add Check 7**

Append after existing Check 6 (skill count):

```bash
# Check 7: .catalog-version file exists, is single-line semver, no trailing newline
CATALOG_VERSION_FILE="power-engineer/.catalog-version"
if [ ! -f "$CATALOG_VERSION_FILE" ]; then
  fail ".catalog-version file missing at $CATALOG_VERSION_FILE"
else
  CV_BYTES=$(wc -c < "$CATALOG_VERSION_FILE" | tr -d ' ')
  CV_LINES=$(wc -l < "$CATALOG_VERSION_FILE" | tr -d ' ')
  CV_CONTENT=$(cat "$CATALOG_VERSION_FILE")

  # No trailing newline means wc -l reports 0
  if [ "$CV_LINES" -ne 0 ]; then
    fail ".catalog-version has trailing newline (wc -l=$CV_LINES, expected 0)"
  fi

  # Semver pattern: X.Y.Z with numeric components
  if ! echo "$CV_CONTENT" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    fail ".catalog-version content '$CV_CONTENT' is not valid semver"
  else
    pass ".catalog-version: $CV_CONTENT (semver, no trailing newline, $CV_BYTES bytes)"
  fi
fi

# Shipping-boundary check: .catalog-version MUST NOT exist at repo root
# (would violate the invariant that only power-engineer/** ships via npx skills add)
if [ -f ".catalog-version" ]; then
  fail ".catalog-version at repo root violates shipping boundary; move to power-engineer/.catalog-version"
fi
```

- [ ] **Step 2: Run lint — confirm pass**

```bash
bash tests/lint/catalog-integrity.sh
# Expected: PASS Check 7 with output ".catalog-version: 1.3.0 (semver, no trailing newline, 5 bytes)"
```

- [ ] **Step 3: Commit**

```bash
git add tests/lint/catalog-integrity.sh
git commit -m "feat(tests/lint): add Check 7 — .catalog-version existence and format"
```

### Task 3.2: Add CI job for catalog-version bump enforcement

**Files:** Modify: `.github/workflows/ci.yml`

- [ ] **Step 1: Add new job**

Append to the workflow:

```yaml
  catalog-version-sync:
    name: Catalog version bump check
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Check .catalog-version bumps when catalog changes
        run: |
          CATALOG_CHANGED=$(git diff --name-only origin/main...HEAD -- 'power-engineer/references/catalog/**/*.md' | wc -l | tr -d ' ')
          VERSION_CHANGED=$(git diff --name-only origin/main...HEAD -- 'power-engineer/.catalog-version' | wc -l | tr -d ' ')

          if [ "$CATALOG_CHANGED" -gt 0 ] && [ "$VERSION_CHANGED" -eq 0 ]; then
            echo "✗ Catalog files changed but .catalog-version was not bumped."
            echo "Files changed:"
            git diff --name-only origin/main...HEAD -- 'power-engineer/references/catalog/**/*.md'
            exit 1
          fi
          echo "✓ catalog-version sync OK"
```

- [ ] **Step 2: Commit**

```bash
git add .github/workflows/ci.yml
git commit -m "ci: add catalog-version-sync job enforcing bump on catalog changes"
```

### Task 3.3: Document the `.catalog-version` mechanism

**Files:** Modify: `docs/CONTRIBUTING.md`

- [ ] **Step 1: Add section**

Under the existing `### Catalog additions` block, add:

```markdown
### Bumping the catalog version

When a PR changes any `power-engineer/references/catalog/**/*.md` file, it MUST also bump `power-engineer/.catalog-version` (semver). The CI `catalog-version-sync` job enforces this.

Bump rules:
- **Patch bump (X.Y.Z → X.Y.Z+1)** — adding/removing/renaming skills
- **Minor bump (X.Y.Z → X.Y+1.0)** — adding new catalog categories (new subdirectory or top-level section)
- **Major bump (X.Y.Z → X+1.0.0)** — structural schema changes (new required column, changed separator convention)

Document the bump in the CHANGELOG entry under `### Catalog` (see below).
```

- [ ] **Step 2: Commit**

```bash
git add docs/CONTRIBUTING.md
git commit -m "docs(contributing): document .catalog-version bump conventions"
```

### Phase 3 Verification

- [ ] `catalog-integrity.sh` Check 7 passes (`.catalog-version` = `1.3.0`)
- [ ] `.github/workflows/ci.yml` has `catalog-version-sync` job
- [ ] `docs/CONTRIBUTING.md` documents bump conventions
- [ ] `bash tests/run-all.sh` → exit 0

---

## Phase 4 — CHANGELOG `### Catalog` Convention + Retroactive v1.3.0 Entry

**Goal:** Establish the `### Catalog` subheading convention starting from v1.3.0 (retroactive). Structural lint asserts presence in new release entries. External curation workflow consumes this as stable API.

### Task 4.1: Retrofit v1.3.0 CHANGELOG entry with `### Catalog` subhead

**Files:** Modify: `CHANGELOG.md`

Per Explore subagent: v1.3.0 entry has `### Added` (line 9) · `### Changed` (line 19) · `### Removed` (line 26) · `### Migration` (line 32). Insert `### Catalog` between `### Changed` end (line 25) and `### Removed` start (line 26).

- [ ] **Step 1: Insert the subheading**

At line 26 (before `### Removed`), insert:

```markdown
### Catalog

- **Catalog version:** pre-convention baseline; recorded retroactively as `1.3.0` in `power-engineer/.catalog-version` (file introduced in v1.4.0)
- **Skills added:** none
- **Skills removed:** none
- **Skills renamed:** none
- **Structural changes:** 220 install commands normalized via `@latest` strip; catalog row count reconciled 238 → 224 (cross-category duplicates removed)

```

- [ ] **Step 2: Verify structure**

```bash
grep -nE '^### ' CHANGELOG.md | head -20
# Expected: v1.3.0 entry now has 5 subheads (Added, Changed, Catalog, Removed, Migration)
```

- [ ] **Step 3: Commit**

```bash
git add CHANGELOG.md
git commit -m "docs(changelog): retrofit v1.3.0 entry with ### Catalog subhead

Establishes the convention retroactively for v1.3.0 so external curation
consumers have a consistent start-point. v1.3.0 did not add/remove/rename
skills; entry documents structural normalization instead."
```

### Task 4.2: Add structural lint for `### Catalog` presence per release

**Files:** Modify: `tests/lint/catalog-integrity.sh`

- [ ] **Step 1: Add Check 8**

Append:

```bash
# Check 8: every release entry (v1.3.0 and forward) in CHANGELOG.md has a ### Catalog subhead.
# The convention was established retroactively starting with v1.3.0. Entries sorted below 1.3.0
# via sort -V OR tagged with <!-- catalog-exempt: pre-convention --> are skipped.
if [ -f "CHANGELOG.md" ]; then
  # Use line numbers from outer grep directly (avoids fragile grep -F + head -1 lookup)
  while IFS=: read -r line_no header; do
    # Extract version string (e.g., "1.3.0" from "## [1.3.0] — 2026-04-16")
    version=$(echo "$header" | sed -nE 's/^## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/p')
    # Skip pre-convention entries: sort -V says version < 1.3.0
    lowest=$(printf '%s\n%s\n' "$version" "1.3.0" | sort -V | head -1)
    if [ "$lowest" != "1.3.0" ] && [ "$version" != "1.3.0" ]; then
      continue
    fi
    # Find where next release entry starts (or end of file)
    next=$(awk -v start="$line_no" 'NR > start && /^## \[/ { print NR; exit }' CHANGELOG.md)
    [ -z "$next" ] && next=$(wc -l < CHANGELOG.md)
    block=$(sed -n "${line_no},${next}p" CHANGELOG.md)
    # Skip if explicit exemption marker present
    if echo "$block" | grep -q '<!-- catalog-exempt: pre-convention -->'; then
      continue
    fi
    if ! echo "$block" | grep -qE '^### Catalog[[:space:]]*$'; then
      fail "CHANGELOG.md release '$header' (line $line_no) missing '### Catalog' subhead"
    fi
  done < <(grep -nE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' CHANGELOG.md)
fi
```

- [ ] **Step 2: Run lint — confirm pass**

```bash
bash tests/lint/catalog-integrity.sh
# Expected: PASS (v1.3.0 entry now has ### Catalog thanks to Task 4.1)
```

- [ ] **Step 3: Spot-check the awk pattern**

Per `feedback_plan_pattern_verification.md`, verify the pattern `^## \[[0-9]+\.[0-9]+\.[0-9]+\]` matches v1.3.0 entry:

```bash
grep -cE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' CHANGELOG.md
# Expected: 1 (only v1.3.0 currently; will be 2 after Phase 9 adds v1.4.0 entry)
```

- [ ] **Step 4: Commit**

```bash
git add tests/lint/catalog-integrity.sh
git commit -m "feat(tests/lint): add Check 8 — ### Catalog subhead per release entry"
```

### Task 4.3: Document the CHANGELOG `### Catalog` convention

**Files:** Modify: `docs/CONTRIBUTING.md`

- [ ] **Step 1: Add subsection**

Under the Catalog additions section (from Task 3.3), add:

```markdown
### CHANGELOG `### Catalog` subhead

Every release entry in `CHANGELOG.md` must include a `### Catalog` subhead documenting catalog changes in that release. Schema:

\`\`\`markdown
### Catalog

- **Catalog version:** X.Y.Z (matches `power-engineer/.catalog-version` at release time)
- **Skills added:** (list or "none")
- **Skills removed:** (list or "none")
- **Skills renamed:** (list of old → new, or "none")
- **Structural changes:** (describe schema/convention changes, or "none")
\`\`\`

Enforced by `tests/lint/catalog-integrity.sh` Check 8. The subhead lives between `### Changed` and `### Removed` (per Keep-a-Changelog convention).

**Pre-convention exemption:** The convention applies to entries v1.3.0 and forward. Entries sorted below `1.3.0` via `sort -V` are automatically skipped by Check 8. Additionally, a retroactive entry that pre-dates the convention may add an HTML comment `<!-- catalog-exempt: pre-convention -->` anywhere in its block to be skipped explicitly.

External consumers (e.g., downstream curation workflows) parse this section for delta computation across releases.
```

- [ ] **Step 2: Commit**

```bash
git add docs/CONTRIBUTING.md
git commit -m "docs(contributing): document CHANGELOG ### Catalog subhead convention"
```

### Phase 4 Verification

- [ ] v1.3.0 CHANGELOG entry contains `### Catalog` subhead (structural + normalization noted)
- [ ] `catalog-integrity.sh` Check 8 asserts the subhead; passes
- [ ] `docs/CONTRIBUTING.md` documents the convention
- [ ] `bash tests/run-all.sh` → exit 0

---

## Phase 5 — Catalog Gap Fix (7 `tavily-*` + `stitch-design`)

**Goal:** Fix 8 catalog gap-fixes that surfaced in v1.3.0's configurator cheatsheet regeneration (7 new rows + 1 in-place rename of legacy `search` → `tavily-search`). Bump `.catalog-version` to `1.4.0` (first real content change under the new convention). Net row-count delta: 224 → 231.

Per Explore subagent: `docs-research.md` uses 6-col schema (Skill / Source / Install / Description / Trigger / When to use). `frontend/design-systems.md` uses 5-col schema (Skill / Install / Description / Trigger / When to use).

### Task 5.1: Rename `search` → `tavily-search` + add 6 `tavily-*` sub-skill rows

**Files:**
- Modify: `power-engineer/references/catalog/docs-research.md` — rename existing `search` row + append 6 new rows
- Modify: `power-engineer/references/catalog/engineering/data-ml.md` — rename existing `search` row

**Context:** Per `v1.4.0-catalog-research.md` (2026-04-17): all 7 upstream `tavily-*` skill names MATCH the plan names exactly (verified against `github.com/tavily-ai/skills` SKILL.md manifests). However, the existing catalog has a legacy `| search |` row in both `docs-research.md` (L20) and `engineering/data-ml.md` (L33) with a STALE install command (`--skill search` — no such package exists upstream; the correct name is `tavily-search`). These rows MUST be renamed in-place, not kept alongside new rows. Count delta: 224 + 6 (new tavily rows) + 1 (stitch-design) = 231 (NOT 232 — rename is net-zero).

- [ ] **Step 1: Confirm upstream names via catalog research doc**

All 7 upstream skill names match the plan exactly — confirmed against `github.com/tavily-ai/skills` SKILL.md manifests (see `docs/superpowers/plans/v1.4.0-catalog-research.md`). The existing `| search |` rows in `docs-research.md` L20 and `engineering/data-ml.md` L33 use a stale/wrong skill name (`--skill search` → no such upstream package; correct is `tavily-search`). These must be RENAMED before the 6 additional rows are appended. Do NOT consult `state.json.installed_skills` — it's gitignored and may contain local drift artifacts.

- [ ] **Step 2a: Rename existing `search` row in `docs-research.md`**

Locate the row at L20:

```markdown
| search | tavily-ai/skills | `npx skills add tavily-ai/skills --skill search -y` | Tavily real-time search with structured result extraction. | `/search` | When grounding AI responses with real-time web search results |
```

Replace with:

```markdown
| tavily-search | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-search -y` | Search the web with LLM-optimized results. Supports domain filtering, time ranges, and multiple search depths. | `/tavily-search` | When the user wants to search the web or find recent information |
```

- [ ] **Step 2b: Rename existing `search` row in `engineering/data-ml.md`**

Locate the row at L33:

```markdown
| search | tavily-ai/skills | `npx skills add tavily-ai/skills --skill search -y` | Tavily real-time search with structured result extraction for AI-grounded research. | `/search` | When grounding AI responses with real-time web search results |
```

Replace with:

```markdown
| tavily-search | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-search -y` | Search the web with LLM-optimized results for AI-grounded research. | `/tavily-search` | When grounding AI responses with real-time web search results |
```

- [ ] **Step 2c: Append 6 new `tavily-*` rows to `docs-research.md` `## Web Research & Data` table**

Append after the (now-renamed) `tavily-search` row, maintaining alphabetical order among `tavily-*` rows (the 6-col table starts at L17 with header `| Skill | Source | Install | Description | Trigger | When to use |`). Do NOT add to any other table:

```markdown
| tavily-best-practices | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-best-practices -y` | Build production-ready Tavily integrations with best practices baked in. Reference documentation for developers implementing web search and RAG in agentic workflows. | `/tavily-best-practices` | When building a production Tavily integration or RAG system and needing reference guidance |
| tavily-cli | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-cli -y` | Web search, content extraction, crawling, and deep research via the Tavily CLI. Overview skill with workflow guide, install/auth instructions, and command reference. | `/tavily-cli` | When setting up the Tavily CLI or needing an overview of all Tavily web capabilities |
| tavily-crawl | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-crawl -y` | Crawl websites and extract content from multiple pages. Supports depth/breadth control, path filtering, and saving each page as a local markdown file. | `/tavily-crawl` | When bulk-extracting multiple pages from a site or downloading documentation |
| tavily-extract | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-extract -y` | Extract clean markdown or text content from specific URLs. Handles JavaScript-rendered pages with query-focused chunking. Processes up to 20 URLs in a single call. | `/tavily-extract` | When the user has a specific URL and wants its clean text content |
| tavily-map | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-map -y` | Discover and list all URLs on a website without extracting content. Faster than crawling — returns URLs only. | `/tavily-map` | When the user wants to find a specific page on a large site or list all site URLs |
| tavily-research | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-research -y` | Comprehensive AI-powered research with citations. Multi-source synthesis that takes 30-120 seconds. | `/tavily-research` | When the user wants deep research, a detailed report, or multi-source synthesis with explicit citations |
```

Note: `tavily-search` is already in the table (Step 2a). Total net additions to docs-research.md = 6 rows. `data-ml.md` gets a rename only (net 0 new rows).

- [ ] **Step 3: Run catalog-integrity**

```bash
bash tests/lint/catalog-integrity.sh
# Expected: PASS (rows conform to 6-col schema; Check 7 still passes since we haven't bumped yet)
```

- [ ] **Step 4: Commit**

```bash
git add power-engineer/references/catalog/docs-research.md power-engineer/references/catalog/engineering/data-ml.md
git commit -m "feat(catalog): rename search→tavily-search + add 6 tavily-* sub-skill rows"
```

### Task 5.2: Add `stitch-design` row to `frontend/design-systems.md`

**Files:** Modify: `power-engineer/references/catalog/frontend/design-systems.md`

- [ ] **Step 1: Confirm source repo via catalog research + sibling-row inspection**

Look at sibling Stitch skills already in `power-engineer/references/catalog/frontend/design-systems.md` (under the `## Google Stitch` table) — `stitch-loop`, `enhance-prompt`, `react:components`, `design-md`, `shadcn-ui`, `remotion` are all indexed with no explicit source column (5-col table), but they belong to `google-labs-code/stitch-skills`. The plan's `stitch-design` install command uses the same repo. Verified against `github.com/google-labs-code/stitch-skills/skills/stitch-design/SKILL.md` (see `docs/superpowers/plans/v1.4.0-catalog-research.md`).

**Do NOT consult `state.json.installed_skills`** — it's gitignored and contains `"repo": "manual"` for stitch-design as a local drift artifact. That value is unreliable; discard it.

- [ ] **Step 2: Add row**

**Insertion target:** the `## Google Stitch` section (L7-14 in `design-systems.md`), the 5-col table with header `| Skill | Install | Description | Trigger | When to use |`. Insert after the `remotion` row (preserving existing order — `stitch-design` is a meta/entry-point skill so appending after `remotion` is cleaner than alphabetical insertion).

**Do NOT insert into the `## Frontend Design` table (6-col with Source column) or the `## Design Refinement — pbakaus/impeccable` table (different skill family).** The file has THREE tables with distinct schemas; picking the wrong one will trip `catalog-integrity.sh` Check 3 (schema drift).

```markdown
| stitch-design | `npx skills add google-labs-code/stitch-skills --skill stitch-design -y` | Unified entry point for Stitch design work: prompt enhancement, design system synthesis, and high-fidelity screen generation via Stitch MCP. | `/stitch-design` | When the user wants UI design work via Google's Stitch design tooling |
```

- [ ] **Step 3: Verify + commit**

```bash
bash tests/lint/catalog-integrity.sh
# Expected: PASS

git add power-engineer/references/catalog/frontend/design-systems.md
git commit -m "feat(catalog): add stitch-design row to frontend/design-systems.md"
```

### Task 5.3: Bump `.catalog-version` to 1.4.0 + update INDEX.md count

**Files:**
- Modify: `power-engineer/.catalog-version`
- Modify: `power-engineer/references/catalog/INDEX.md` (footer skill count)
- Run: `scripts/update-skill-count.sh`

- [ ] **Step 1: Bump .catalog-version**

```bash
printf '1.4.0' > power-engineer/.catalog-version
wc -c < power-engineer/.catalog-version  # Expected: 5
```

- [ ] **Step 2: Update skill count**

```bash
scripts/update-skill-count.sh
# Expected: count bumps from 224 to 231 (224 + 6 new tavily rows in docs-research + 1 stitch-design; search→tavily-search renames in docs-research + data-ml are net-zero)
```

- [ ] **Step 3: Verify all lint + CI would pass**

```bash
bash tests/run-all.sh
# Expected: all checks pass, including new Checks 7 + 8
```

- [ ] **Step 4: Commit all catalog changes together**

```bash
git add power-engineer/.catalog-version power-engineer/references/catalog/INDEX.md README.md
git commit -m "chore(catalog): bump to 1.4.0 — +7 tavily (1 rename, 6 add) + 1 stitch-design (224 → 231)"
```

### Phase 5 Verification

- [ ] `docs-research.md` contains 6 new tavily-* rows (tavily-best-practices, tavily-cli, tavily-crawl, tavily-extract, tavily-map, tavily-research) plus renamed tavily-search
- [ ] `engineering/data-ml.md` `search` row renamed to `tavily-search` with correct install command
- [ ] `frontend/design-systems.md` contains `stitch-design` row in `## Google Stitch` table
- [ ] `.catalog-version` = `1.4.0` (5 bytes, no trailing newline)
- [ ] README badge + INDEX.md count = **231**
- [ ] `bash tests/run-all.sh` → exit 0 (Checks 7 + 8 confirm sync)

---

## Phase 6 — Release-Process Framework Kit

**Goal:** Ship 8 files under `docs/superpowers/release-process/` — a process doc + 5 required templates + 2 optional templates. Force-committed (matches v1.3.0 plan/parity precedent). NOT shipped with installed skill.

### Task 6.1: Write `release-process.md` process document

**Files:** Create: `docs/superpowers/release-process/release-process.md`

- [ ] **Step 1: Author the document**

Sections:
1. **Overview** — what this doc is, who consumes it (maintainers), when it applies
2. **Phase structure** — 9-phase pattern from v1.3.0/v1.4.0 (intro, implementation, test, release)
3. **Audit gates** — per-phase auditor subagent + dual-auditor rule for HIGH-CAUTION phases
4. **Push-at-release-time policy** — defer `git push` until Phase 9; local checkpoint-only commits mid-release
5. **`--admin` merge convention** — solo-dev advisory-rule bypass precedent (v1.3.0); formalization deferred to v1.4.1
6. **Re-bundle vs patch-release rules** — v1.3.0 re-bundled semver-hostile; future policy = ship clean patch release instead
7. **Plan-pattern verification requirement** — per `feedback_plan_pattern_verification.md`: spot-check literal regex/awk patterns against ≥2 real files before dispatch
8. **External API research requirement** — per `feedback_external_api_verification.md`: hook/settings/external-API tasks include a research-subagent step before implementation
9. **Template dogfooding expectation** — release that introduces new templates MUST instantiate them in its own Phase 9 ceremony
10. **Rollback authority** — per-phase rollback commands; user gate for full-release rollback

- [ ] **Step 2: Commit (force-added; matches v1.3.0 precedent)**

```bash
mkdir -p docs/superpowers/release-process/templates
git add -f docs/superpowers/release-process/release-process.md
git commit -m "feat(release-process): codify v1.3.0-taught release pattern + v1.4.0 additions"
```

### Task 6.2: Write `planner-prompt-template.md` + `executor-prompt-template.md`

**Files:**
- Create: `docs/superpowers/release-process/templates/planner-prompt-template.md`
- Create: `docs/superpowers/release-process/templates/executor-prompt-template.md`

- [ ] **Step 1: Distill planner-prompt-template from v1.4.0-planner.md**

The current v1.4.0-planner.md (this planning session's input) is the exemplar. Template generalization:
- Placeholder for target version (`<X.Y.Z>`)
- Skill-loading list
- Context file list
- Summary format (5-bullet)
- 9-step execution sequence
- Non-negotiable rules section

- [ ] **Step 2: Distill executor-prompt-template from v1.3.0-executor.md**

Exemplar: `docs/superpowers/prompts/v1.3.0-executor.md`. Template generalization:
- Target version placeholder
- Authoritative documents list
- Active model + required skills
- Subagent invocation Templates A (implementer) / B (auditor) / C (remediator) / D (parallel fan-out)
- Phase-by-phase execution plan (table)
- Orchestration loop
- Model-selection rationale (NOW references `power-engineer/references/modules/subagent-selector.md` + state.json preference)
- Universal hook/settings-task research-subagent gate
- Rollback authority

- [ ] **Step 3: Commit**

```bash
git add -f docs/superpowers/release-process/templates/planner-prompt-template.md docs/superpowers/release-process/templates/executor-prompt-template.md
git commit -m "feat(release-process): add planner + executor prompt templates"
```

### Task 6.3: Write `plan-template.md`

**Files:** Create: `docs/superpowers/release-process/templates/plan-template.md`

- [ ] **Step 1: Author template based on this v1.4.0 plan's structure**

Use placeholder tokens consistently: `<X.Y.Z>` for version, `<feature-name>` for release theme, `<N>` for phase numbers, `<YYYY-MM-DD>` for dates. Include a top comment `<!-- Replace placeholders before use. -->`.

Sections:
- Header (goal, architecture, tech stack, related artifacts)
- File structure (grouped by responsibility)
- Phase 0 through Phase N (each with tasks, steps, commit messages)
- **Plan-pattern verification gates** (per `feedback_plan_pattern_verification.md`: section requires the planner to spot-check hardcoded regex/awk patterns against ≥2 real files before dispatching; template includes a checklist stub)
- **External API research gates** (per `feedback_external_api_verification.md`: section requires the planner to identify all tasks touching hooks, settings.json, or external APIs, and gate each such task on a research-subagent pulling current docs BEFORE implementation; template includes a checklist stub)
- Risk & Rollback table
- Out of Scope
- Execution Handoff

The institutional knowledge from these two feedback memories must be structurally embedded in the template so future releases inherit the gates without having to re-derive them.

- [ ] **Step 2: Commit**

```bash
git add -f docs/superpowers/release-process/templates/plan-template.md
git commit -m "feat(release-process): add upgrade-plan template"
```

### Task 6.4: Write `changelog-entry-template.md` + `migration-template.md`

**Files:**
- Create: `docs/superpowers/release-process/templates/changelog-entry-template.md`
- Create: `docs/superpowers/release-process/templates/migration-template.md`

- [ ] **Step 1: Changelog entry template**

Note for template consumers: `<X.Y.Z>` and `<YYYY-MM-DD>` are placeholder tokens that MUST be replaced at instantiation time. Document this inside the template with a top comment: `<!-- Replace <X.Y.Z> with the release semver and <YYYY-MM-DD> with today's ISO date before committing. -->`. The template body follows:

```markdown
## [<X.Y.Z>] — <YYYY-MM-DD>

### Added
- <feature 1>
- <feature 2>

### Changed
- <change 1>

### Catalog
- **Catalog version:** <X.Y.Z> (matches `power-engineer/.catalog-version`)
- **Skills added:** <list or "none">
- **Skills removed:** <list or "none">
- **Skills renamed:** <old → new list or "none">
- **Structural changes:** <description or "none">

### Removed
- <removal 1>

### Migration
- <migration note>
```

- [ ] **Step 2: Migration template**

```markdown
## v<OLD.VER> → v<NEW.VER>

**TL;DR:** <one-sentence summary>.

### What changed
1. <change 1>
2. <change 2>

### What users must do
<required actions, or "nothing">

### Optional: <upgrade path>
<optional actions>

### Rollback to v<OLD.VER>
\`\`\`bash
git revert <release-commit>
# or
git checkout v<OLD.VER> -- <paths>
\`\`\`
```

- [ ] **Step 3: Commit**

```bash
git add -f docs/superpowers/release-process/templates/changelog-entry-template.md docs/superpowers/release-process/templates/migration-template.md
git commit -m "feat(release-process): add changelog + migration templates"
```

### Task 6.5: Write 2 optional templates (parity + behavioral-validation)

**Files:**
- Create: `docs/superpowers/release-process/templates/parity-doc-template.md`
- Create: `docs/superpowers/release-process/templates/behavioral-validation-template.md`

- [ ] **Step 1: Parity template (from v1.3.0-parity.md)**

Sections: context/scope, L-bucket coverage matrix, F-bucket coverage, R-bucket justifications, intentional gaps, safe-to-delete authorization.

- [ ] **Step 2: Behavioral-validation template (from v1.3.0-behavioral-validation.md)**

Sections: method (claude --bare invocation), results table per fixture, limitations, reproducing instructions, relationship to structural tests.

- [ ] **Step 3: Commit**

```bash
git add -f docs/superpowers/release-process/templates/parity-doc-template.md docs/superpowers/release-process/templates/behavioral-validation-template.md
git commit -m "feat(release-process): add optional parity + behavioral-validation templates"
```

### Phase 6 Verification

- [ ] `docs/superpowers/release-process/release-process.md` exists
- [ ] All 7 template files under `docs/superpowers/release-process/templates/` exist
- [ ] `bash tests/run-all.sh` → exit 0 (no lint regressions; release-process kit is force-added outside catalog scope)

---

## Phase 7 — Tests/Lint Extensions

**Goal:** Add structural lint assertions validating Phase 1-6 outputs. All assertions are structural (grep/awk existence checks); no runtime behavior testing.

### Task 7.1: Extend `doc-structure.sh` with selector + hook + save-phase + preference assertions

**Files:** Modify: `tests/lint/doc-structure.sh`

- [ ] **Step 1: Add assertion block**

Append:

```bash
# ─── Subagent-selector module (v1.4.0) ───
check "subagent-selector.md exists" \
  "[ -f power-engineer/references/modules/subagent-selector.md ]"

check "subagent-selector.md has 3-axis decision table" \
  "grep -qE '^\| Task profile \| Low-risk single \| High-risk single \| Low-risk parallel fan-out \|' power-engineer/references/modules/subagent-selector.md"

check "subagent-selector.md documents all 5 modes" \
  "grep -q 'force-opus' power-engineer/references/modules/subagent-selector.md && grep -q 'force-sonnet' power-engineer/references/modules/subagent-selector.md && grep -q 'force-haiku' power-engineer/references/modules/subagent-selector.md"

# ─── Save-phase flow (v1.4.0) ───
check "save-phase.md flow exists" \
  "[ -f power-engineer/references/flows/save-phase.md ]"

check "SKILL.md routes 'save-phase' to flows/save-phase.md" \
  "grep -qE 'save-phase[^|]*\|[^|]*references/flows/save-phase\.md' power-engineer/SKILL.md"

# ─── Configurator extensions (v1.4.0) ───
check "configurator.md preferences block includes subagent_model_mode" \
  "grep -A 10 '\"preferences\"' power-engineer/references/modules/configurator.md | grep -q '\"subagent_model_mode\"'"

check "configurator.md references SessionEnd hook" \
  "grep -q 'SessionEnd' power-engineer/references/modules/configurator.md"

check "configurator.md references PreCompact hook" \
  "grep -q 'PreCompact' power-engineer/references/modules/configurator.md"

# ─── Hook scripts ship inside skill (v1.4.0 shipping-boundary enforcement) ───
check "SessionEnd hook script exists and is executable" \
  "test -x power-engineer/scripts/hooks/session-end-handoff.sh"

check "PreCompact hook script exists and is executable" \
  "test -x power-engineer/scripts/hooks/pre-compact-snapshot.sh"

check "SessionEnd hook script always exits 0 (never blocks session termination)" \
  "grep -q 'exit 0' power-engineer/scripts/hooks/session-end-handoff.sh"

check "PreCompact hook script always exits 0 (never blocks compaction)" \
  "grep -q 'exit 0' power-engineer/scripts/hooks/pre-compact-snapshot.sh"

# ─── Configurator registration uses $CLAUDE_PROJECT_DIR (portable for both dogfood + end-user) ───
# Accepts either end-user form ($CLAUDE_PROJECT_DIR/.claude/hooks/...) OR dogfood form
# ($CLAUDE_PROJECT_DIR/power-engineer/scripts/hooks/...), since configurator.md documents both shapes.
check "configurator SessionEnd registration uses \$CLAUDE_PROJECT_DIR" \
  "grep -qE '\"command\":.*\\\$CLAUDE_PROJECT_DIR.*session-end-handoff' power-engineer/references/modules/configurator.md"

check "configurator PreCompact registration uses \$CLAUDE_PROJECT_DIR" \
  "grep -qE '\"command\":.*\\\$CLAUDE_PROJECT_DIR.*pre-compact-snapshot' power-engineer/references/modules/configurator.md"

# ─── Configurator regen safety: never overwrite settings.local.json ───
check "configurator.md asserts settings.local.json is user-owned" \
  "grep -qE 'settings\\.local\\.json.*(user-owned|never.*overwrit|do not touch)' power-engineer/references/modules/configurator.md"
```

- [ ] **Step 2: Run doc-structure.sh**

```bash
bash tests/lint/doc-structure.sh
# Expected: PASS all new assertions
```

- [ ] **Step 3: Commit**

```bash
git add tests/lint/doc-structure.sh
git commit -m "feat(tests/lint): add doc-structure assertions for v1.4.0 surfaces"
```

### Task 7.2: Add release-process kit inventory assertion

**Files:** Modify: `tests/lint/doc-structure.sh`

- [ ] **Step 1: Add inventory check block**

Append:

```bash
# ─── Release-process kit (v1.4.0) ───
check "release-process.md exists" \
  "[ -f docs/superpowers/release-process/release-process.md ]"

for t in planner-prompt executor-prompt plan changelog-entry migration; do
  check "release-process template $t exists" \
    "[ -f docs/superpowers/release-process/templates/${t}-template.md ]"
done

# Shipping-boundary guard: release-process kit MUST NOT live inside power-engineer/
# (would violate the invariant that only power-engineer/** ships via npx skills add).
check "release-process kit is NOT inside power-engineer/" \
  "! find power-engineer/ -path '*release-process*' -print -quit | grep -q ."
```

Optional templates (parity, behavioral-validation) are NOT asserted — they're present per v1.4.0 Phase 6.5 but not required by lint.

- [ ] **Step 2: Run lint**

```bash
bash tests/lint/doc-structure.sh
# Expected: PASS all new assertions
```

- [ ] **Step 3: Commit**

```bash
git add tests/lint/doc-structure.sh
git commit -m "feat(tests/lint): assert release-process kit required file inventory"
```

### Task 7.3: Add ShellCheck for new hook scripts (CI integration)

**Files:** Modify: `.github/workflows/ci.yml`

- [ ] **Step 1: Add ShellCheck step to lint job**

In the `lint` job, add after "Run lint suite" step:

```yaml
      - name: ShellCheck hook scripts + maintainer scripts
        run: |
          # Hook scripts ship inside the skill at power-engineer/scripts/hooks/*.sh
          # (relocated in Phase 2 commit d747e07 so they reach users via `npx skills add`).
          # Top-level scripts/*.sh are maintainer utilities (update-skill-count, etc.).
          sudo apt-get update && sudo apt-get install -y shellcheck
          shopt -s nullglob
          for s in scripts/*.sh power-engineer/scripts/hooks/*.sh; do
            [ -f "$s" ] || continue
            shellcheck "$s"
          done
```

- [ ] **Step 2: Commit**

```bash
git add .github/workflows/ci.yml
git commit -m "ci: add ShellCheck for scripts/*.sh files"
```

### Phase 7 Verification

- [ ] `doc-structure.sh` has new assertions for selector/save-phase/configurator/release-process kit; all pass
- [ ] `.github/workflows/ci.yml` includes ShellCheck step
- [ ] `bash tests/run-all.sh` → exit 0

---

## Phase 8 — Docs + Integration Validation

**Goal:** Close docs gaps introduced by v1.4.0's new surfaces; run end-to-end validation before release ceremony.

### Task 8.1: Update `tests/README.md` with new lint additions

**Files:** Modify: `tests/README.md`

- [ ] **Step 1: Document Checks 7 + 8 + shellcheck**

Update the Layer 1 (Lint) section table with new entries:
- `catalog-integrity.sh` now includes Check 7 (`.catalog-version` format) + Check 8 (CHANGELOG `### Catalog` subhead per release)
- `doc-structure.sh` now includes subagent-selector / save-phase / configurator hooks / release-process kit assertions
- ShellCheck on `scripts/*.sh` in CI

- [ ] **Step 2: Commit**

```bash
git add tests/README.md
git commit -m "docs(tests): document v1.4.0 lint additions"
```

### Task 8.2: Update `README.md` badges + testing section

**Files:** Modify: `README.md`

- [ ] **Step 1: Update testing section**

Update README to mention:
- New `.catalog-version` mechanism (link to CONTRIBUTING.md section)
- New CHANGELOG `### Catalog` convention (link to CONTRIBUTING.md section)
- New memory architecture (SessionEnd + PreCompact + save-phase)
- New subagent-selector module with 5 modes

- [ ] **Step 2: Refresh skill count badge**

```bash
scripts/update-skill-count.sh
# Expected: badge = 231 (already bumped in Phase 5)
```

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs(readme): update for v1.4.0 — mentions catalog-version + memory hooks + selector"
```

### Task 8.3: End-to-end integration validation

**Files:** None (verification)

- [ ] **Step 1: Run full lint suite**

```bash
bash tests/run-all.sh
# Expected: all 5 scripts PASS; Checks 7 + 8 active; all new assertions pass
```

- [ ] **Step 2 (automated path): Smoke-test non-interactive portions of `/power-engineer save-phase`**

Exercise ONLY the non-interactive steps of the save-phase flow — reading state, git log inspection, file inventory. `AskUserQuestion` interaction is unavailable in automated executor contexts. Skipped steps:
- Q1 (phase number prompt) — stub with "Phase 8" from plan context
- Q2 (summary prompt) — stub with synthesized summary from Phase 8 git log

Document which steps were tested and which were skipped in the commit message. Full end-to-end validation (including interactive prompts) is deferred to Phase 9 Task 9.5 Step 5, where the human operator runs `/power-engineer save-phase` at release time.

- [ ] **Step 3: Verify configurator would write new hooks correctly**

Dry-run: run configurator OR read its output path against a mock project. Confirm the SessionEnd + PreCompact hook registrations would end up as nested `{matcher?, hooks:[{type, command, timeout}]}` entries in `.claude/settings.json`, with `command` using `$CLAUDE_PROJECT_DIR/.claude/hooks/...` (end-user shape).

- [ ] **Step 4: Verify configurator regen safety for `.claude/settings.local.json`**

Grep configurator.md for the `settings.local.json` invariant. It MUST appear with an explicit "configurator writes ONLY to `.claude/settings.json`; `.claude/settings.local.json` is user-owned and never touched" disclaimer:

```bash
grep -qE 'settings\.local\.json.*(user-owned|never.*overwrit|do not touch)' power-engineer/references/modules/configurator.md
echo "Exit: $?"
# Expected: 0 (the invariant is documented)
```

If absent, add the disclaimer via an in-phase configurator.md edit:

```bash
# Append to the existing "SessionEnd hook" or "Memory fallback contracts" section:
# "**Invariant:** /power-engineer configure writes ONLY to .claude/settings.json.
# .claude/settings.local.json is user-owned (permissions, personal overrides) and
# is NEVER read, written, or overwritten by the configurator."
git add power-engineer/references/modules/configurator.md
git commit -m "docs(configurator): assert settings.local.json is user-owned (never touched)"
```

- [ ] **Step 5: Commit a checkpoint marker**

```bash
git commit --allow-empty -m "checkpoint: Phase 8 integration validation complete"
```

### Task 8.4: Generalize `save-phase.md` Q1 options (remove maintainer-specific Phase 0-9 hardcoding)

**Files:** Modify: `power-engineer/references/flows/save-phase.md`

**Context:** Task 2.4 landed `save-phase.md` with Q1 options hardcoded to Phase 0 through Phase 9 + Other — the maintainer's own release phase count. This couples the user-facing flow to maintainer-project cadence. End-user projects may have 3 phases, 15 phases, or no phases. Per audit M18 (user explicitly approved), generalize Q1.

- [ ] **Step 1: Read current Q1 structure**

```bash
grep -A 30 'question: "What phase' power-engineer/references/flows/save-phase.md
# or locate Q1 by its semantic anchor
```

- [ ] **Step 2: Replace Q1 options with a flexible 5-option set**

Change Q1 options from the hardcoded 10-option list (Phase 0 / Phase 1 / ... / Phase 9 / Other) to:

```yaml
options:
  - label: "Phase 1"
    description: "First implementation phase."
  - label: "Phase 2"
    description: "Second implementation phase."
  - label: "Phase 3"
    description: "Third implementation phase."
  - label: "Later phase (enter number)"
    description: "Phases 4+. Type the phase number in the free-text field."
  - label: "Other (non-numeric label)"
    description: "Non-numeric label: released, hotfix, spike, handoff, etc."
```

- [ ] **Step 3: Run lint + commit**

```bash
bash tests/run-all.sh
# Expected: exit 0 (doc-structure assertions still pass; save-phase.md still structurally valid)

git add power-engineer/references/flows/save-phase.md
git commit -m "fix(save-phase): generalize Q1 options from maintainer-specific Phase 0-9 to flexible 5-option set"
```

### Phase 8 Verification

- [ ] `tests/README.md` documents Checks 7 + 8 + ShellCheck
- [ ] README.md version + badges updated
- [ ] `bash tests/run-all.sh` → exit 0
- [ ] Save-phase flow smoke test (non-interactive portions) passed; full interactive test deferred to Phase 9 Task 9.5 Step 5
- [ ] Configurator integration dry-run passed
- [ ] Configurator regen-safety invariant for `.claude/settings.local.json` verified
- [ ] `save-phase.md` Q1 options generalized from Phase 0-9 to flexible 5-option set

---

## Phase 9 — Final Audit + Release Ceremony

**Goal:** Dogfood Phase 6's release-process templates (CHANGELOG + MIGRATION instantiation), run security review of new hook scripts, execute release ceremony (draft PR → CI → squash merge → tag → GH release).

**Template dogfooding:** Tasks 9.1 + 9.2 explicitly instantiate `docs/superpowers/release-process/templates/changelog-entry-template.md` + `migration-template.md`. If any template bug surfaces, fix in-place (not a separate phase) — that's the point of dogfooding.

### Task 9.1: Write CHANGELOG v1.4.0 entry (instantiate template)

**Files:** Modify: `CHANGELOG.md`

- [ ] **Step 1: Read the changelog-entry template**

```bash
cat docs/superpowers/release-process/templates/changelog-entry-template.md
```

- [ ] **Step 2: Instantiate with v1.4.0 content**

Insert at top of CHANGELOG.md (before `## [1.3.0]`). **Before saving, replace `<YYYY-MM-DD>` with today's ISO-8601 date.** Obtain via `date -u +%Y-%m-%d` and substitute. If the implementer is an automated subagent, run the command inline and use its output. Do NOT leave the placeholder literal in the committed file.

```markdown
## [1.4.0] — <YYYY-MM-DD>

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
```

- [ ] **Step 3: Verify the v1.4.0 entry is template-derived (dogfood check)**

The template defines a canonical structure; the instantiated entry must preserve it. Verify by diffing ### subhead structure:

```bash
diff \
  <(grep -E '^### ' docs/superpowers/release-process/templates/changelog-entry-template.md) \
  <(awk '/^## \[1\.4\.0\]/,/^## \[1\.3\.0\]/' CHANGELOG.md | grep -E '^### ') \
  && echo "✓ v1.4.0 entry structurally derived from template" \
  || echo "✗ v1.4.0 entry diverges from template shape (dogfooding gap)"
```

Expected: matching ### subheads (Added, Changed, Catalog, Removed, Migration in same order).

- [ ] **Step 4: Commit**

```bash
git add CHANGELOG.md
git commit -m "docs: add v1.4.0 CHANGELOG entry"
```

### Task 9.2: Write MIGRATION.md v1.3.0 → v1.4.0 (instantiate template)

**Files:** Modify: `docs/MIGRATION.md`

- [ ] **Step 1: Instantiate from template**

Insert at top of MIGRATION.md (before `## v1.2.0 → v1.3.0`):

```markdown
## v1.3.0 → v1.4.0

**TL;DR:** All additive. Your existing skills + state continue to work. Re-run `/power-engineer configure` to enable new hooks and set your subagent-model preference.

### What changed
1. **Subagent-selector module.** New module under `power-engineer/references/modules/subagent-selector.md` with 3-axis decision table for model selection. Controlled via new `state.json.preferences.subagent_model_mode` (default: `selector`).
2. **3-tier memory architecture.** New SessionEnd + PreCompact hooks auto-save context at session-end and pre-compaction. New `/power-engineer save-phase` slash command for explicit phase ceremony. All three tiers degrade gracefully on failure.
3. **`.catalog-version` mechanism.** New file at `power-engineer/.catalog-version`. CI enforces bump when catalog changes.
4. **CHANGELOG `### Catalog` convention.** Starting from v1.3.0 retroactively, every release entry documents catalog deltas in a structured subhead. External curation workflows consume this as a stable API.
5. **Release-process framework.** Maintainer-only templates under `docs/superpowers/release-process/`. Not installed with the skill.
6. **7 new catalog rows + 1 rename.** 6 new `tavily-*` sub-skills + `stitch-design` now individually catalogued; the legacy `search` row (in docs-research.md + data-ml.md) is renamed to `tavily-search` with a corrected install command.

### What users must do
Nothing required. All changes additive.

### Optional: re-run `/power-engineer configure`
To register the new SessionEnd + PreCompact hooks + set your `subagent_model_mode` preference:

\`\`\`bash
/power-engineer configure
\`\`\`

### Rollback to v1.3.0
\`\`\`bash
git revert <v1.4.0-release-commit>
# or
git checkout v1.3.0 -- power-engineer/ tests/ docs/CONTRIBUTING.md CHANGELOG.md
\`\`\`
```

- [ ] **Step 2: Verify the v1.4.0 migration entry is template-derived (dogfood check)**

Verify by diffing ### subhead structure between the template and the instantiated migration entry:

```bash
diff \
  <(grep -E '^### ' docs/superpowers/release-process/templates/migration-template.md) \
  <(awk '/^## v1\.3\.0 → v1\.4\.0/,/^## v1\.2\.0/' docs/MIGRATION.md | grep -E '^### ') \
  && echo "✓ v1.3.0 → v1.4.0 migration entry structurally derived from template" \
  || echo "✗ migration entry diverges from template shape (dogfooding gap)"
```

Expected: matching ### subheads (What changed, What users must do, etc.) in same order.

- [ ] **Step 3: Commit**

```bash
git add docs/MIGRATION.md
git commit -m "docs: add MIGRATION.md v1.3.0 → v1.4.0"
```

### Task 9.3: Version bumps

**Files:**
- Modify: `README.md` (any version refs)
- Modify: `power-engineer/SKILL.md` (if version-referenced)

- [ ] **Step 1: Grep for version references (broadened scope per audit M22)**

```bash
grep -rn 'v1\.3\.0' README.md power-engineer/ docs/ CHANGELOG.md CLAUDE.md
```

Review each hit individually — historical entries (CHANGELOG past-release sections, MIGRATION "v1.2.0 → v1.3.0" headings, memory fallback prose that references research dated to v1.3.0) should NOT be bumped; ONLY forward-looking current-version text should be updated to v1.4.0.

- [ ] **Step 2: Update each occurrence to v1.4.0 where appropriate**

- [ ] **Step 3: Commit**

```bash
git add README.md power-engineer/SKILL.md
git commit -m "chore: bump version to v1.4.0"
```

### Task 9.4: Final verification + security review of new hook scripts

**Files:** None (verification)

- [ ] **Step 1: Run full lint suite**

```bash
bash tests/run-all.sh
# Expected: all 5 scripts PASS with all new checks (7, 8, selector, hooks, kit inventory)
```

- [ ] **Step 2: Dispatch security-review subagent**

Brief:

> Security review of new hook scripts introduced in v1.4.0.
>
> **Scope:** The standalone hook scripts at `power-engineer/scripts/hooks/session-end-handoff.sh` and `power-engineer/scripts/hooks/pre-compact-snapshot.sh` (relocated to the skill-packaging tree in Phase 2 commit `d747e07` so they ship with the skill via `npx skills add`). Particularly: session-end handoff script + pre-compact snapshot script.
>
> **Checks:**
> - Shell injection: any variable expansion in `eval`, `command`, or unquoted positions
> - Path traversal: any filename construction from untrusted input
> - Unsafe `rm` or destructive commands with variable paths
> - Environment variable assumptions (missing defaults; undefined vars under `set -u`)
> - Error handling: does failure silently drop or leak?
>
> **Output:** Structured report with per-script findings (✅/⚠️/🚨) + recommendations. Save to `docs/superpowers/plans/v1.4.0-security-review.md`.

- [ ] **Step 3: Address findings**

If any 🚨 critical findings: fix in-place (separate commit per fix with `fix(hooks): address security-review finding <N>` message). If ⚠️ minor: note + plan for v1.4.1.

- [ ] **Step 4: Commit security-review doc**

```bash
git add -f docs/superpowers/plans/v1.4.0-security-review.md
git commit -m "docs(v1.4.0): security review of new hook scripts"
```

- [ ] **Step 5: Push branch**

```bash
git push
```

- [ ] **Step 6: Create draft PR**

```bash
gh pr create --draft \
  --title "v1.4.0 — Catalog hygiene + Cluster B agent infrastructure" \
  --body "See CHANGELOG.md v1.4.0 entry for summary; docs/MIGRATION.md for upgrade path."
gh pr checks --watch
```

Expected: all CI jobs (lint, url-check-targeted, catalog-version-sync, badge-sync) pass green.

### Task 9.5: Merge + tag + release

**Files:** None (git / GitHub)

- [ ] **Step 1a: MANDATORY — dispatch research subagent for gh CLI verification**

Per `feedback_external_api_verification.md`, before running external API calls touching gh CLI flags, dispatch a research subagent:

> Research subagent: confirm current `gh pr merge --squash --admin` flag semantics, required permissions (write + admin), rate limits, and any deprecations. Also confirm `gh pr ready` behavior on a draft PR + `gh release create` syntax for `--notes-file` with process-substitution input. Save findings to `docs/superpowers/plans/v1.4.0-gh-cli-research.md`.

Only proceed to Step 1b after the research subagent's report is written and reviewed.

- [ ] **Step 1b: Mark PR ready + squash-merge**

```bash
gh pr ready
gh pr merge --squash --admin
```

v1.3.0 used `--admin` for solo-dev advisory bypass; this precedent stands unless Step 1a's research report flags changes.

- [ ] **Step 1c: Merge-confirmation gate (MANDATORY — halts if merge silently failed)**

```bash
git checkout main
git pull
if ! git log --oneline -20 | grep -qi 'v1.4.0'; then
  echo "v1.4.0 squash commit not found on main — merge failed or not yet propagated; aborting tag"
  exit 1
fi
```

This guards against Step 1b silent failures (rate-limit, permission, CI red) causing Step 2 to mis-tag the pre-merge main commit.

- [ ] **Step 2: Tag annotated (main already checked out + pulled in Step 1c)**

```bash
git tag -a v1.4.0 -m "Power Engineer v1.4.0 — catalog hygiene + Cluster B agent infrastructure"
git push origin v1.4.0
```

- [ ] **Step 3: Create GitHub release**

```bash
gh release create v1.4.0 \
  --title "v1.4.0 — Catalog hygiene + Cluster B agent infrastructure" \
  --notes-file <(sed -n '/## \[1.4.0\]/,/## \[/p' CHANGELOG.md | sed '$d')
```

- [ ] **Step 4: Verify release is live**

```bash
gh release view v1.4.0
```

- [ ] **Step 5: Save session memory**

Invoke `/power-engineer save-phase` (dogfooding the new flow) to record v1.4.0 release state in memory.

### Phase 9 Verification

- [ ] CHANGELOG v1.4.0 entry present + uses `### Catalog` subhead
- [ ] `docs/MIGRATION.md` has v1.3.0 → v1.4.0 section
- [ ] Version bumps done (README, SKILL.md if applicable)
- [ ] `docs/superpowers/plans/v1.4.0-security-review.md` exists; no unresolved 🚨 findings
- [ ] PR #N merged via `gh pr merge --squash --admin`
- [ ] Tag `v1.4.0` pushed; annotated (`git cat-file -t v1.4.0` = "tag")
- [ ] GitHub release published
- [ ] `/power-engineer save-phase` invoked post-release (dogfooding Phase 2)

---

## Risk & Rollback

### Biggest risks

- **Phase 2 (memory hooks)** — meta-infra touches Claude Code hook surface. Fallback contracts mitigate runtime failure, but a bug in hook script could still degrade handoff quality during v1.4.0 itself. Mitigation: research-subagent step (Task 2.1) + ShellCheck (Phase 7) + security review (Phase 9.4).
- **Phase 5 (catalog gap fix)** — adding 7 new rows + 1 rename touches `catalog-integrity.sh` Checks 3 + 6 (schema + count). Low risk given existing robust lint.
- **Phase 9 (release ceremony)** — first dogfood of release-process templates. Template bugs surface here; fix in-place. --admin merge is a solo-dev bypass; document in security-review if any concern.

### Rollback per phase

| Phase | Rollback |
|---|---|
| 0 | `git checkout main && git branch -D v1.4.0-upgrade` (only branch + research docs written) |
| 1 | `git revert <phase-1-commits>` — module + questionnaire + configurator changes reversible |
| 2 | `git revert <phase-2-commits>` — hook registration reversible; generated hook scripts in user projects require re-running `/power-engineer configure` with v1.3.0 module |
| 3 | `git revert <phase-3-commits>` — `.catalog-version` file + lint + CI reversible; no runtime impact of removing |
| 4 | `git revert <phase-4-commits>` — CHANGELOG retroactive change + lint reversible; external consumers degrade to pre-convention behavior |
| 5 | `git revert <phase-5-commits>` — catalog rows + version bump reversible; catalog count reverts to 224 |
| 6 | `git rm -rf docs/superpowers/release-process/` — kit is purely additive, no consumers in prior phases |
| 7 | `git revert <phase-7-commits>` — lint + CI additions reversible |
| 8 | `git revert <phase-8-commits>` — README + tests/README updates reversible |
| 9 | `git tag -d v1.4.0; git push --delete origin v1.4.0; gh release delete v1.4.0 --yes; git revert <squash-commit>` |

### Full-release rollback

```bash
git checkout main
git revert <squash-commit-of-v1.4.0-PR>
git tag -d v1.4.0
git push origin :refs/tags/v1.4.0
gh release delete v1.4.0 --yes
```

Restores v1.3.0 behavior. Users who re-ran `/power-engineer configure` in v1.4.0 should re-run under v1.3.0 to unregister SessionEnd + PreCompact hooks.

---

## Out of Scope (deferred)

- **v1.4.1 Cluster C**: project-implementation advisor, domain/skill/feature extensibility framework, behavioral-CI wiring (elevate `claude --bare -p` harness), PR-policy formalization.
- **v1.4.2 QoL pack**: `/power-engineer uninstall <skill>`, `/power-engineer info <skill>`, `scripts/catalog-diff.sh`, state.json schema migrations, session-compaction budget indicator.
- **v1.5.0+**: security-advisory scanning for installed skills, automated curation schedule (if curation returns in-repo).
- **Curation Suite in-repo** — moves entirely to maintainer's external workflow. This repo publishes only `.catalog-version` + CHANGELOG `### Catalog` as API.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/power-engineer-v1.4.0-upgrade-plan.md`. Two execution options:

**1. Subagent-Driven (recommended)** — dispatch a fresh subagent per task, review between tasks, fast iteration. Matches v1.3.0's successful orchestration pattern.

**2. Inline Execution** — execute tasks in this session using `superpowers:executing-plans`, batch execution with checkpoints.

**For subagent-driven execution, generate an executor-prompt-template.md instance** at `docs/superpowers/prompts/v1.4.0-executor.md` (local-only, untracked) using the template shipped in Phase 6. The executor prompt codifies:
- Subagent-selector consultation per dispatch (new in v1.4.0)
- Research-subagent step required for Phase 2 hook tasks + any task touching settings.json
- Audit gates + HIGH-CAUTION dual-auditor rule for any phase with irreversible operations
- Push-at-release-time policy (Phase 9 only)
- `--admin` squash-merge for solo-dev advisory bypass

Which approach?
