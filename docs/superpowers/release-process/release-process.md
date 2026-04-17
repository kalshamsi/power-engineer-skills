# Power Engineer Release Process

> **Status:** Maintainer-only. This document codifies the patterns the v1.3.0 release taught us and the additions v1.4.0 introduced. It is consulted by humans planning a release and by orchestrator subagents executing one. It does NOT ship to end users via `npx skills add` — it lives outside `power-engineer/` for that reason.

## 1. Overview

This document describes how to plan, execute, and ship a release of the `power-engineer-skills` repository. Its consumers are:

1. **The maintainer**, when authoring a planning prompt or when interrupted mid-release and resuming from a handoff.
2. **The orchestrator subagent**, when executing a planning- or execution-session prompt that points here for cross-cutting policy (e.g. "before dispatching any task that touches Claude Code hooks, follow the External API Research Requirement in `release-process.md`").
3. **Auditor subagents**, when verifying that an executed phase obeyed the rules below (e.g. "verify that no `git push` happened mid-release per the Push-At-Release-Time Policy").

It applies to every release semver-tagged from `v1.4.1` onwards, plus retroactively justifies what we already did in `v1.3.0` and `v1.4.0`. Ad-hoc patches that bypass the orchestrator workflow (single-commit hotfixes that don't change the catalog or modules) MAY skip the planning + audit + ceremony machinery, but they MUST still respect §4 (push policy), §7 (plan-pattern verification — applies to the patch's diff), and §8 (external API research — applies whenever hooks/settings/external APIs are involved).

This is not an onboarding doc. It assumes the reader has already read `docs/superpowers/prompts/v1.3.0-executor.md` (the v1.3.0 orchestrator prompt) and the most recent upgrade plan under `docs/superpowers/plans/`. Those documents describe the per-release implementation; this one describes the shape they all share.

## 2. Phase Structure

Every release follows a 9-ish-phase pattern. The exact phase count varies (v1.3.0 had 10 phases, v1.4.0 has 10 phases — but the *roles* are stable). The pattern:

| Slot | Role | What lives here |
|---|---|---|
| **Phase 0** | Audit & prep | Branch creation, baseline lint pass, ecosystem research subagents (memory-research, hooks-research, catalog-research), `.catalog-version` baseline write |
| **Phase 1 .. N-2** | Implementation | Module + flow + catalog + scanner work, plus any new meta-infra (e.g. v1.4.0 Phase 1 introduces `subagent-selector.md`; Phase 2 introduces 3-tier memory) |
| **Phase N-1** | Tests / lint extensions | New `tests/lint/*.sh` checks asserting Phase 1..N-2 outputs; CI workflow updates |
| **Phase N** | Release ceremony | CHANGELOG entry + MIGRATION.md entry + version bumps + final end-to-end audit + draft PR + squash merge + tag + GitHub release + post-release dogfood |

The convention is: meta-infra introduced in early phases is **dogfooded** by later phases of the same release. v1.4.0 introduces the release-process kit in Phase 6 and instantiates its `changelog-entry-template.md` + `migration-template.md` in Phase 9 — that round-trip catches template defects before the next release inherits them. See §9.

Each phase must end in one or more verification gates (a `### Phase N Verification` checkbox list in the plan) and an empty checkpoint commit:

```bash
git commit --allow-empty -m "checkpoint: Phase <N> complete and approved by user"
```

The empty commit serves three purposes: it marks the boundary in `git log --oneline` for auditors and per-phase rollback, it forces the user to acknowledge the phase before the orchestrator advances, and it provides a stable revert target if the next phase's auditor uncovers a regression.

## 3. Audit Gates

Every phase ends with a dedicated auditor subagent. The auditor is fresh-context — it did NOT implement the work it is reviewing. The orchestrator dispatches it via the `Agent` tool with a Template B-style brief (see `docs/superpowers/prompts/v1.3.0-executor.md` for the canonical wording). The auditor reads the plan section, re-runs every verification command in the task, inspects the produced commits, and returns either **APPROVED** or **ISSUES FOUND** with itemized deviations.

Three audit policies apply:

1. **Per-task auditor for HIGH-CAUTION phases.** When a phase's blast radius is irreversible or wide (catalog rewrite, deletion, hook surface, release ceremony, anything that mutates `.claude/settings.json` semantics), the orchestrator dispatches a per-task auditor (Template B) immediately after each implementer in the phase, not just one at the end. v1.3.0 Phase 7 ("Parity & Deletion") used this pattern: Task 7.1's parity proof had to APPROVE before Task 7.2's deletion implementer was dispatched at all.

2. **Dual-auditor rule for HIGH-CAUTION phases.** For the highest-risk phases, dispatch two independent Opus auditors in parallel and reconcile their findings. v1.4.0's plan audit ran two Opus auditors against the same plan and produced the 27-finding remediation that landed in commit `933d2a2` — neither auditor alone caught all 27. The reconciliation step is itself an Opus judgment task (treat agreed findings as authoritative, treat conflicting findings as escalation candidates). Use this pattern for: catalog refactors with >100 row changes, anything that deletes shipped files, the release ceremony's pre-tag audit, and any plan-level review.

3. **Selector consultation.** Per `power-engineer/references/modules/subagent-selector.md`, audit work is always Opus regardless of risk axis or parallelism — incorrect audit output produces undetected defects. The selector module's decision table makes this explicit (`audit` rows are all Opus). The orchestrator MUST NOT downgrade an auditor to Sonnet for cost reasons; if cost is a true constraint, reduce the *number* of auditors (skip per-task and rely on phase-end), not the model tier.

When an auditor returns ISSUES FOUND, dispatch a Remediator subagent (Template C). After the remediator returns, re-dispatch the same auditor (new invocation, fresh context) to re-verify. Maximum two auto-remediations; on the third rejection, escalate to the user via `AskUserQuestion`.

## 4. Push-At-Release-Time Policy

`git push` does NOT happen mid-release. The orchestrator commits locally per task and per phase boundary, but defers the first push to origin until the release ceremony's PR-creation step (the v1.4.0 plan calls this Phase 9 Task 9.5 Step 5 — `gh pr create --draft`). The same policy applies to the v1.3.0 ceremony.

Rationale (three independent reasons, any one of which suffices):

1. **CI churn.** Every push to a tracked branch triggers the CI workflow. A 9-phase release with ~60 commits would trigger 60 CI runs, most of which test intermediate (incomplete) state. The CI feedback you actually want is the one that runs against the final, complete branch state — and the draft PR provides exactly that.
2. **Reversibility window.** Until the branch is pushed, every phase is locally revertible without coordinating with origin or any reviewer. The orchestrator's per-phase rollback commands (§10) operate on local refs only; they don't have to handle the case where origin is ahead of local.
3. **Re-bundling capability.** v1.3.0 demonstrated that a release can be re-bundled mid-flight (see §6) when a previously-shipped defect is discovered. Re-bundling local-only commits is straightforward (`git rebase -i` or `git reset --soft`); re-bundling pushed commits requires coordinated force-pushes and confuses CI.

The single exception is Phase 0 Task 0.1, which pushes the working branch (`git push -u origin <branch>`) for backup and to enable mid-release WIP visibility. This push is acceptable because Phase 0 is pre-implementation; nothing meaningful is in the branch yet.

## 5. `--admin` Merge Convention

The admin merge convention (`gh pr merge --admin`) covers the solo-dev advisory-rule bypass used during the v1.3.0 release ceremony. `power-engineer-skills` is a solo-developer repository. The maintainer enforces "advisory" branch-protection rules that require a code review on every PR — not because anyone else reviews them, but to make it harder for the maintainer to merge a PR by accident from a phone or a stale tab.

Solo dev = the reviewer is also the author, so there is nobody to actually approve the PR. The accepted workaround is the `gh pr merge --admin --squash` flag, which bypasses the advisory rule with the maintainer's explicit assent. v1.3.0's PR #4 was merged this way (see commit `b8878c9`); v1.4.0's release ceremony will do the same.

This is documented here rather than enforced as a rule because **the convention is not yet formalized**. It is known unfinished work, deferred to v1.4.1's "Cluster C: PR-policy formalization" item (see the v1.4.0 plan's Out of Scope section). v1.4.1 will either:

- Convert the advisory rule to non-blocking (signal-only), removing the need for `--admin`.
- Replace `--admin` with a self-approval workflow using a dedicated bot account.
- Document `--admin` as the official policy with a checklist gate (e.g. "the PR's auditor subagent must have returned APPROVED, recorded in the PR body, before `--admin` is invoked").

Until then, treat `--admin` use as the documented escape hatch. The auditor subagent's APPROVED status (recorded in the final end-to-end audit) is the substitute for human review.

## 6. Re-Bundle vs Patch-Release Rules

v1.3.0 set a precedent the future should not casually repeat. The release was tagged at `b8878c9`, then a stale-badge defect (`tests-312 passing` in the README) was discovered minutes later, then a v1.3.1 patch was tagged at `08172c7`, then a behavioral-validation pass surfaced .env handling concerns and a missing `.gitignore` rule, then the maintainer authorized **collapsing both tags** into a single re-bundled `v1.3.0` re-release at `c0140ae`. The v1.3.1 tag was deleted; v1.3.0 was retagged forward.

The forward-looking rule is:

**Default to a clean patch release. Re-bundle only when the user explicitly authorizes it.**

A patch release (e.g. v1.4.1 to fix a v1.4.0 defect) is unambiguous: the v1.4.0 history is preserved, the new tag points to a clean fix commit, MIGRATION.md picks up the patch under `## v1.4.0 → v1.4.1`, and downstream tooling (anything that pinned `v1.4.0` by SHA) keeps working. A re-bundle, by contrast, retroactively changes what `v1.4.0` "means": anyone who consumed the original tag now sees a different commit at the same name. That violates semver's tag-immutability expectation and confuses release-history readers.

The legitimate cases for re-bundling are narrow:

- The original tag was published less than ~24 hours ago AND no one has consumed it AND the defect is severe enough that clean-patch costs (an extra entry in the changelog history) are worse than re-bundle costs (broken tag immutability).
- The user explicitly authorizes the re-bundle in a single message containing the literal word "rebundle" or "re-bundle", after the orchestrator surfaces the alternatives via `AskUserQuestion`.

In every other case — a defect found a week later, a defect found by an external user, a defect that is only cosmetic — ship a patch release.

## 7. Plan-Pattern Verification Requirement

Per `~/.claude/projects/-Users-khalfan-Documents-Development-power-engineer-skills/memory/feedback_plan_pattern_verification.md`: plans that hardcode regex/awk/grep patterns intended to match structured data (markdown tables, YAML keys, JSON paths) MUST spot-check those patterns against ≥2 representative real files BEFORE the plan ships to implementers.

The why:

LLM training data on shell-pattern semantics is unreliable. A plan author may write `awk '/^\| Skill \| Description \|/'` to match a catalog header, but the actual catalog header is `| Skill | Install | Description | Trigger | When to use |` — five columns. The pattern matches zero lines. v1.3.0 shipped exactly this defect: the same incorrect pattern appeared in `tests/lint/catalog-integrity.sh` Check 6 (Phase 1 Task 1.2) and `scripts/update-skill-count.sh` (Phase 8 Task 8.1). Phase 1's implementer silently corrected the pattern to `/^\| (Skill|Suite) \|/` + `non_empty >= 3` without flagging the plan-text bug; Phase 8's implementer caught it explicitly. For six phases the plan and the code disagreed and nobody noticed. If Phase 8 hadn't surfaced it, the badge-sync CI job would have permanently reported zero skills.

The mechanism the rule requires:

1. **At plan-authoring time.** When a plan introduces a regex/awk/grep pattern intended to match file structure, the planner adds a verification step adjacent to the pattern: "Run this pattern against `<concrete file 1>` and `<concrete file 2>`; expected match count is N; if 0, the pattern is wrong, fix before shipping the plan." The v1.4.0 plan demonstrates this pattern in Phase 7 Task 7.1's check definitions, where each `check "..."` line includes a re-runnable command in the plan body that a Sonnet executor or human reader can verify in seconds.

2. **At orchestrator-dispatch time.** Before dispatching the first implementer of a task that contains a hardcoded pattern, the orchestrator spot-checks one or two patterns against current files. If a pattern matches zero lines, the orchestrator escalates via `AskUserQuestion` rather than dispatching the implementer.

3. **At implementer-execution time.** Implementers are explicitly briefed (in their dispatch prompts) to **flag** plan-pattern deviations rather than silently correct them. Silent correction is a CLAUDE.md violation: it makes the plan-text drift undetectable, which means the *next* implementer who reuses the same pattern has no signal that the plan is wrong.

4. **At auditor-verification time.** Auditors cross-reference duplicate patterns across the plan. If the same pattern appears in two places, both need updating when one breaks. v1.3.0 Phase 1 + Phase 8 used the same defective pattern; an auditor that checked Phase 1 in isolation would have missed the duplicate in Phase 8.

This rule applies to ALL pattern-matching constructs the plan inlines: `awk`/`sed`/`grep`/`rg` regexes, `jq`/`yq` paths, JSON Pointer expressions, CSS selectors, XPath. It does NOT apply to natural-language references to file content (e.g. "the catalog has approximately 224 rows" — that's a count, not a pattern, and a separate verification step covers it).

## 8. External API Research Requirement

Per `~/.claude/projects/-Users-khalfan-Documents-Development-power-engineer-skills/memory/feedback_external_api_verification.md`: tasks that touch Claude Code hooks, `.claude/settings.json`, GitHub APIs (`gh` CLI, REST/GraphQL), MCP server protocol, the Anthropic SDK, or any third-party CLI/API contract MUST include a Research subagent (Template D-style — see `docs/superpowers/prompts/v1.3.0-executor.md`) BEFORE the implementing Dev is dispatched. The research subagent's output is consumed by the implementer as authoritative context, and the implementer is briefed not to rely on training-data knowledge for these surfaces.

The why:

LLM training data on rapidly-evolving API surfaces is stale. v1.3.0 hit this directly: the original configurator registered a `PostToolUse` hook with matcher `"compact"` to fire after compaction. That registration is structurally invalid — `PostToolUse` matchers filter by *tool name*, not session source, so `"compact"` never fired. The correct schema is `SessionStart` with matcher `"compact"`. The defect was discovered only after a real runtime failure and user debugging, and the fix landed mid-v1.3.0. A Research subagent with access to current Anthropic docs would have caught the schema mismatch before implementation.

Same release shipped a second hook-schema bug: `PreToolUse` permissions hooks were registered in the legacy flat `["<cmd>", ...]` shape rather than the current nested `[{type, command}, ...]` shape. The flat shape produces a Settings Error on launch. Both bugs trace to the same root cause: implementer relied on training-data memory of the schema rather than checking current docs.

The mechanism the rule requires:

1. **Surface inventory at plan-authoring time.** The planner identifies every task whose implementation touches the in-scope surfaces (see list below) and adds a Research-subagent prerequisite. v1.4.0 demonstrates this in Phase 0 Task 0.2 (memory ecosystem research) and Phase 2 (hooks-research subagent runs before configurator and hook scripts are touched). Research outputs are saved to `docs/superpowers/plans/v<X.Y.Z>-<topic>-research.md` for traceability.

2. **Dispatch gate at execution time.** Before dispatching an implementer for any task in the in-scope list, the orchestrator verifies the corresponding research subagent has already returned within this execution session AND its output is referenced in the implementer's dispatch prompt. If the research is missing, the orchestrator dispatches the research subagent first; it does NOT proceed.

3. **Implementer brief.** The implementer's dispatch prompt explicitly states: "For all hook / settings / external-API decisions in this task, consult `<research-doc-path>` rather than relying on training-data knowledge of the schema. If `<research-doc-path>` is silent or contradicts the plan, escalate to the orchestrator via the implementer's report."

In-scope surfaces (research subagent required):

- Claude Code hook surface (`SessionStart`, `SessionEnd`, `PreCompact`, `PostToolUse`, `PreToolUse`, hook matchers, registration shape in `.claude/settings.json`)
- `.claude/settings.json` schema overall (precedence vs `.claude/settings.local.json`, environment-variable expansion semantics)
- GitHub APIs: `gh` CLI flags, REST endpoints, GraphQL queries, rate-limit handling
- MCP server protocol (tool-use, resources, prompts shape)
- Anthropic SDK (messages API, tool-use, prompt caching, thinking, batch, files)
- Third-party CLIs the orchestration depends on (`skills`, `git` subcommand semantics that differ across versions, `jq`/`yq` flag stability)

Out-of-scope surfaces (no research subagent required):

- Internal file edits (module prose, catalog rows, README, MIGRATION) where the implementation is content-only
- Pure bash scripts with no external API surface
- Markdown-only structural changes (heading reorganization, anchor renames)

## 9. Template Dogfooding Expectation

Any release that introduces NEW templates (release-process kit, plan template, prompt templates, changelog/migration entry templates) MUST instantiate those templates in its OWN release ceremony. v1.4.0 is the canonical example: Phase 6 introduces `docs/superpowers/release-process/templates/changelog-entry-template.md` + `migration-template.md`, and Phase 9 instantiates them when writing the v1.4.0 CHANGELOG entry and MIGRATION.md entry.

The why:

A template that is introduced but never instantiated is unverified. The next release that tries to use it will be the first to discover its defects — and those defects will be discovered under release-day pressure, not during the normal phase audit + remediation cycle. Dogfooding within the introducing release closes that gap: the template's first instantiation happens while the release is still pre-tag, so any defect can be fixed in-place (a separate fix commit within the same release) rather than deferred.

The mechanism:

1. **Plan authoring identifies the dogfood pair.** When a phase introduces template T, a later phase's task that instantiates T is explicitly identified in the plan as the dogfood instance. The v1.4.0 plan calls this out under Phase 9: "Tasks 9.1 + 9.2 explicitly instantiate `docs/superpowers/release-process/templates/changelog-entry-template.md` + `migration-template.md`. If any template bug surfaces, fix in-place (not a separate phase) — that's the point of dogfooding."

2. **Verification gate.** The instantiating task includes a structural-derivation check verifying that the instantiated artifact's section structure matches the template's. v1.4.0 Phase 9 Task 9.1 Step 3 demonstrates this with a `diff <(grep ### template.md) <(grep ### CHANGELOG.md v1.4.0 entry)` check — divergence is a dogfooding gap and surfaces immediately.

3. **In-place fix protocol.** If the dogfood instance reveals a template defect, the fix commits to BOTH the template and the instantiated artifact in the same release, before tag. This is one of the few acceptable mid-release re-edits: the template change is itself part of the release the template was introduced in.

Templates that are explicitly OPTIONAL — the v1.4.0 release-process kit's `parity-doc-template.md` and `behavioral-validation-template.md` — are NOT subject to dogfood-on-introduction. They become subject to dogfood-on-first-use the first time a release actually instantiates them.

## 10. Rollback Authority

Each upgrade plan's "Risk & Rollback" section enumerates per-phase rollback commands. The orchestrator has authority to execute the per-phase rollback for the most-recently-completed phase under specific conditions:

**The orchestrator MAY execute per-phase rollback when ALL of:**

- An auditor (or dual-auditor consensus) returned ISSUES FOUND on the phase, AND
- A remediator was dispatched and returned, AND
- The re-dispatched auditor returned ISSUES FOUND a second time, AND
- The user, surfaced via `AskUserQuestion` with three options (Roll back this phase / Try one more remediator / Abort release entirely), selected "Roll back this phase."

The orchestrator MUST NOT rollback under any other condition — including "the implementer reported failure" (escalate via AskUserQuestion first), "tests fail unexpectedly mid-phase" (dispatch remediator first), or "the orchestrator suspects a problem the auditor missed" (escalate, do not act unilaterally).

**The orchestrator MUST NOT execute full-release rollback (post-tag) without explicit user authorization.** Full-release rollback means reverting the squash-merge commit, deleting the tag locally + remote, and deleting the GitHub release. v1.3.0's release demonstrated this carefully: when the v1.3.1 patch was collapsed back into v1.3.0, the user explicitly authorized the tag deletion + retag. The orchestrator surfaced the destructive operations via `AskUserQuestion` and waited for explicit user response before executing.

Three permanent constraints on rollback authority:

1. **Never force-push without explicit user authorization, ever.** The single exception in repository history was the `git push --force origin v1.2.0` that retagged a pre-existing remote lightweight tag to point to the correct release commit — and the user authorized that explicitly in-session.
2. **Never delete tags without explicit user authorization, ever.** A deleted tag is recoverable only if someone has the SHA cached locally; "I'll delete the tag and re-tag later" is a one-way operation in practice.
3. **Never delete or modify other branches without explicit user authorization.** Per-phase rollback operates on the working branch only.

The full-release rollback recipe is documented in each upgrade plan's "Risk & Rollback" section. The orchestrator's job is to surface the recipe to the user via AskUserQuestion and execute only after explicit consent. The orchestrator does NOT improvise rollback commands; if the plan's recipe doesn't fit the situation, escalate.

---

*End of release-process document. Templates referenced throughout this document live in `docs/superpowers/release-process/templates/`. The release-process kit is force-committed (`git add -f`) to defend against future `.gitignore` rules that might inadvertently include `release-process/`.*
