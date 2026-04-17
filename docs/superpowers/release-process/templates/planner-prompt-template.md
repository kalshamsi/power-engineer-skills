<!-- Replace <X.Y.Z>, <feature-name>, <YYYY-MM-DD>, and bracketed placeholders before use. -->

# Power Engineer v<X.Y.Z> — Planning Session Prompt

**How to use:** paste everything below the horizontal rule into a fresh Claude Code session (after `/compact` or in a brand-new conversation). This session produces the v<X.Y.Z> implementation plan. A separate later session will execute that plan, using `executor-prompt-template.md` from the same directory.

---

# Power Engineer v<X.Y.Z> — Planning Session

This session produces a PLAN, not code. No file writes outside the plan output and its supporting evidence. No git operations beyond reads. Do NOT execute the plan in this session — execution happens in a separate session later.

## Load skills (parallel)

Load all of the following at session start. Add or remove based on the release theme:

- `brainstorming` — idea exploration before plan synthesis
- `grill-me` — decision-tree interrogation of every architectural choice
- `write-a-prd` — for evolving the spec into a PRD-ready doc
- `prd-to-plan` — for the final plan synthesis pass
- `writing-plans` — structural correctness criteria for the plan
- `writing-skills` — applies if the release introduces new modules / skills / templates
- `requesting-code-review` — used by the independent-review subagent
- `simplify` — review pass on the plan output
- `systematic-debugging` — used if the spec/plan contains contradictions
- `verification-before-completion` — gate before declaring the plan done
- `dispatching-parallel-agents` — for the independent-review fan-out

If any skill fails to load, try unprefixed (e.g. `superpowers:brainstorming` → `brainstorming`). Report which skills loaded before proceeding.

## Read context (parallel, then summarize)

Read every relevant prior-art document before drafting. The list below is the canonical set; add release-specific items as needed.

- `~/.claude/projects/<project-slug>/memory/MEMORY.md` — index of all memories
- All `project_v<prior-version>_phase*.md` memories — what last release did and why
- `project_v<prior-version>_released.md` — last release retrospective
- `feedback_plan_pattern_verification.md` — pattern-verification gate (institutional knowledge)
- `feedback_external_api_verification.md` — research-subagent gate (institutional knowledge)
- `docs/superpowers/specs/<YYYY-MM-DD>-power-engineer-v<X.Y.Z>-<feature-name>.md` — existing spec for this release if one exists (often untracked / `git add -f`-only)
- `docs/superpowers/plans/power-engineer-v<prior-version>-upgrade-plan.md` — reference format for the plan you will produce
- `docs/superpowers/plans/v<prior-version>-parity.md` — if applicable
- `docs/superpowers/plans/v<prior-version>-behavioral-validation.md` — if applicable
- `docs/superpowers/prompts/v<prior-version>-executor.md` — how prior execution was orchestrated; your v<X.Y.Z> plan should enable a similar execution session
- `docs/superpowers/release-process/release-process.md` — cross-cutting policy this plan must obey
- `CHANGELOG.md`
- `tests/README.md`
- `power-engineer/SKILL.md`
- `power-engineer/.catalog-version`
- `.power-engineer/project-context.md` — if instantiated in this repo

Summarize back to the user in **5 bullets**:

1. **(a)** where v<prior-version> landed (final tag, follow-ups, known unfinished work)
2. **(b)** what the existing v<X.Y.Z> spec scopes (or "no spec yet" if absent)
3. **(c)** notable threads from recent memory (open follow-ups, blocked decisions, audit findings still in flight)
4. **(d)** known gaps you discovered while reading (e.g. stale catalog rows, missing modules, broken patterns from prior release)
5. **(e)** what is unclear to you before we start

## Execution sequence (no skipping; do not batch steps 1–3)

1. **Intake** — `AskUserQuestion`: "What new ideas do you want to add beyond the existing v<X.Y.Z> spec?" Use the "Other" freeform option. Listen, don't lead. If no spec exists, ask: "What is the headline theme for v<X.Y.Z>?"

2. **Brainstorming** — apply the `brainstorming` skill. Explore the idea space until goals, success criteria, non-goals, and open questions are all explicit. Ultrathink for architectural framing.

3. **Grill me** — apply the `grill-me` skill. Decision-tree interrogation of every architectural choice until no branch is under-specified. Do not let the user off easy on ambiguity.

4. **Feasibility** — dispatch an Explore subagent against the codebase to map each idea to concrete implementation surfaces (modules, catalog files, installer/configurator/scanner touch points, hook scripts, tests, CI). Surface contradictions with v<prior-version> state.

5. **Evolve the spec** — using `write-a-prd` semantics (NOT the auto-GitHub-issue path): evolve the existing spec into a PRD-ready doc, OR create one from scratch under `docs/superpowers/specs/<YYYY-MM-DD>-power-engineer-v<X.Y.Z>-<feature-name>.md`. Local file only. Ask the user before submitting to GitHub.

6. **Generate the plan** — using `writing-plans` + `prd-to-plan`, produce `docs/superpowers/plans/power-engineer-v<X.Y.Z>-upgrade-plan.md`. Format MUST match v<prior-version>'s plan: phases with verification checkboxes, per-task checkboxes, exact commit messages, rollback notes, file-created-or-modified annotations per phase. Embed:

   - **Plan-pattern verification gates** (per `feedback_plan_pattern_verification.md`): every regex/awk/grep/jq/yq pattern the plan inlines must include a re-runnable spot-check command in the plan body. If a pattern matches zero lines, fix before shipping.
   - **External API research gates** (per `feedback_external_api_verification.md`): every task that touches Claude Code hooks, `.claude/settings.json`, gh CLI, GitHub REST/GraphQL, MCP, or Anthropic SDK MUST have a Research-subagent prerequisite. Output saved to `docs/superpowers/plans/v<X.Y.Z>-<surface>-research.md`.
   - **Shipping-boundary annotations**: every file created or modified annotated INSIDE / OUTSIDE `power-engineer/`. Misplacements are blockers at audit time.
   - **HIGH-CAUTION flags**: any task with irreversible blast radius (catalog rewrite, deletion, hook surface, release ceremony, anything that mutates `.claude/settings.json` semantics) gets dual-auditor + per-task auditor treatment.
   - **Template-dogfooding pairs**: if this release introduces new templates, identify which later phase instantiates them in-place (per `release-process.md` §9).

7. **Self-review** — apply `writing-plans` criteria to your own output. If the plan introduces new power-engineer modules / skills / templates, also apply `writing-skills` criteria. Apply `simplify` to cut anything that doesn't earn its line. Fix issues in place; report what you fixed.

8. **Independent review** — dispatch a **dual-auditor pair** (two Opus reviewer subagents in parallel) with BOTH `requesting-code-review` AND `grill-me` loaded. Brief: find under-specified branches, plan gaps, phase-ordering issues, missed pattern-verification gates, missed research-subagent gates, shipping-boundary violations, and template-dogfooding gaps that self-review missed. Reconcile findings (agreed = authoritative; conflicting = escalate to user). Pass findings to the user BEFORE declaring the plan complete. If reviewers reject, remediate + re-review once; if they reject twice, escalate.

9. **Stop** — wait for explicit user approval. Do not start execution. Do not spawn implementation subagents. The plan is the output. Save a `project`-type memory `project_v<X.Y.Z>_brainstorm.md` capturing locked decisions so the executor session can re-load them.

## Non-negotiable rules

- **`AskUserQuestion` for every user-facing question.** Universal CLAUDE.md enforcement applies here too. Plain-text questions are a violation.
- **Ultrathink** for architectural decisions, phase structure, and competing-tradeoff calls.
- **No plan execution this session.** The plan is the deliverable. Implementation happens in a separate session.
- **Gitignore awareness.** `docs/superpowers/plans/` is typically caught by a `plans/` gitignore rule. Use `git add -f` for plan output (matches the v1.3.0-audit / parity / behavioral-validation pattern), OR propose a targeted allow-list. Ask the user before changing `.gitignore`.
- **Confirm before any `git push`, tag creation, GitHub issue/PR submission, or subagent that modifies production files.** This session is read-mostly.
- **Pattern verification at plan-authoring time.** Per `feedback_plan_pattern_verification.md`: when the plan introduces a regex/awk/grep pattern, you (the planner) verify it against ≥2 representative real files BEFORE the plan ships to implementers. A pattern that matches zero lines is a defect.
- **Research-subagent identification at plan-authoring time.** Per `feedback_external_api_verification.md`: every task touching hooks / `.claude/settings.json` / gh CLI / GitHub API / MCP / Anthropic SDK gets a Research-subagent prerequisite identified in the plan. Don't push the burden onto the executor session.
- **Shipping-boundary discipline.** Every file the plan creates or modifies is annotated INSIDE or OUTSIDE `power-engineer/`. New modules / catalog rows / hook scripts / SKILL.md edits / `.catalog-version` are INSIDE. CHANGELOG / MIGRATION / release-process kit / `tests/**` / `.github/**` / repo-root maintainer scripts are OUTSIDE.
- **Stop after step 9.** Do not proceed.

## Context on v<prior-version> (if you need it)

v<prior-version> released <YYYY-MM-DD>. See `project_v<prior-version>_released.md` memory for the full story — especially any "bugs caught during late-phase audit" sections; v<X.Y.Z> should not repeat those patterns. Verify literal regex/awk patterns against real files BEFORE dispatching implementers.

If the prior release was re-bundled (per `release-process.md` §6), note the chain of tags and the final canonical commit. Plan against the canonical commit, not the original tag, when reviewing prior-art file content.
