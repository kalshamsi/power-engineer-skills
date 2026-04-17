# Save-Phase Flow

Record an explicit phase-level memory checkpoint for the current project. This is Tier 3 (explicit) of the Power Engineer 3-tier memory architecture — the deliberate, user-driven ceremony that sits alongside CLAUDE.md proactive memory rules (Tier 1: reliability), the automatic `SessionEnd` hook (Tier 2: automation), and the `PreCompact` hook (Tier 3 supplement: context-crunch safety net). Use it at meaningful milestones: end of an implementation phase, a user-approved checkpoint, before a long pause, or after a risky task completes.

## When to use

- End of an implementation phase (e.g., "Phase 2 complete")
- User-approved checkpoint after a review pass (dispatched subagents returned APPROVED)
- Before a long pause where the next session may start cold
- After a risky or irreversible task (migration, release, schema change) so the completed state is durable
- Any moment the user says "save this phase" / "record this phase" / `/power-engineer save-phase`

This flow is complementary to the automatic tiers — it is explicit, structured, and attaches user-intent prose (summary, why, how to apply). Automatic tiers snapshot raw state; this flow curates it.

## Preconditions

- An active Claude Code session (the orchestrator has access to the `AskUserQuestion` tool and can read/write files)
- A project directory (the current working directory identifies the project; `.power-engineer/state.json` is consulted if present for the project name, otherwise the repo directory basename is used)
- Write access to `~/.claude/projects/<proj-slug>/memory/` — the flow creates it if missing

## Step 1 -- Discover session state

Gather the raw material that will populate the memory file. Do NOT ask the user for what the tools can answer directly.

Run, in order, and capture output:

```bash
git branch --show-current                               # current branch
git log --oneline main..HEAD 2>/dev/null | head -30     # commits on feature branch
git log -10 --oneline                                   # fallback if main..HEAD is empty
git status --porcelain                                  # modified / untracked files
```

If `.power-engineer/state.json` exists, read it and extract `project.name` (fallback: basename of the current working directory).

If a TodoWrite/TaskList is active, capture its current state (unfinished items, completed items).

Record these as internal scratch data — they feed Step 3.

### Detached HEAD / no-git edge cases

- If `git branch --show-current` returns empty (detached HEAD), record `detached HEAD @ <short SHA>` as the branch label and continue. Note this explicitly in the memory file's body (see Step 3).
- If the project is not a git repository at all, skip the git commands and note "no git tracking" in the memory body. The ceremony continues without commit history.

## Step 2 -- Prompt user for phase details

Use `AskUserQuestion` to collect the two required pieces of user-intent prose. Every user-facing question MUST go through `AskUserQuestion` — never as plain text in a reply.

### Question 1: Phase identifier

```
AskUserQuestion:
  question: "Which phase are you saving?"
  header: "Phase"
  multiSelect: false
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

**Skip condition:** if the current task context makes the phase unambiguous (for example, an orchestrator-driven release workflow where "Phase <N>" is already in the prompt), you MAY skip this question and use the inferred phase — but ONLY when the inference is explicit. Never guess from vibes.

Also capture the version identifier (e.g., `v1.4.0`) — infer from the branch name (`v1.4.0-upgrade` → `1.4.0`), current tag, or the plan the user is executing. If none is inferable, ask via a one-off `AskUserQuestion` with a "Type version" free-text prompt.

### Question 2: Phase summary

```
AskUserQuestion:
  question: "One-sentence summary of what this phase accomplished."
  header: "Summary"
  multiSelect: false
  options:
    - label: "Other"
      description: "Type the summary as free text (one sentence, under 150 characters)."
```

The user's free-text response becomes the memory file's `description` frontmatter field AND the MEMORY.md index entry.

## Step 3 -- Construct the memory file content

Assemble the file body using the Step-1 scratch data plus the Step-2 user prose. Match the v1.3.0 phase-memory shape exactly — see `~/.claude/projects/<proj-slug>/memory/project_v130_phase*.md` for reference exemplars.

### Required frontmatter

```yaml
---
name: v<X> Phase <N> complete
description: <Step 2 Question 2 free-text summary; single sentence, under 150 chars>
type: project
originSessionId: <current Claude Code session ID; if unavailable, use a timestamp-based placeholder like `session-YYYY-MM-DDTHH:MM:SSZ`>
---
```

- `<X>` — version without dots and without the leading `v` (e.g., `140` for `v1.4.0`)
- `<N>` — phase number (e.g., `2`) or the "Other" label slugified (e.g., `released`, `hotfix`)
- `type: project` — this is phase-tracking memory; always project type
- `originSessionId` — if the orchestrator exposes it, use it. Otherwise fall back to a timestamp placeholder and note the fallback inside the body.

### Required body sections

Write prose + structured lists in this order:

1. **Opening paragraph.** One-to-two sentences summarizing what was accomplished and when (ISO date). Lead with the phase identity.
2. **`**Commits produced:**` bulleted list.** From Step 1's `git log main..HEAD` output. For each commit: short SHA + conventional-commit subject. If no feature branch, use `git log -10 --oneline` and note the fallback inline.
3. **`**Files modified:**` bulleted list** (optional — include when relevant, e.g., when touching meta-infra or configuration). Group by logical area.
4. **`**Verification state:**` brief paragraph.** State whether `bash tests/run-all.sh` passed at phase completion, any known failures, any skipped checks.
5. **`**Next:**` paragraph or list.** What the immediately following phase is, what subagent pattern it will use, any precondition gates.
6. **`**Why:**` paragraph.** The rationale for key decisions made in this phase. Prefer the user's own words (from Question 2 and any dialogue before the flow triggered) over the orchestrator's summary.
7. **`**How to apply:**` paragraph.** What a future session reading this memory should actually DO — which files to re-read, which outputs to consume downstream, any invariants to preserve.

Keep the whole body tight (under 40 lines is typical for Phase memories). If the phase was unusually large, longer is fine — but no padding.

## Step 4 -- Write the memory file

Determine the project slug and target path:

- The slug is the URL-safe form of the project's absolute path: replace `/` with `-` and preserve case. On this machine the established pattern is `~/.claude/projects/-Users-khalfan-Documents-Development-power-engineer-skills/memory/`.
- Derive the slug from `$PWD`:

  ```bash
  PROJ_SLUG=$(pwd | sed 's|/|-|g')
  MEMORY_DIR="$HOME/.claude/projects/$PROJ_SLUG/memory"
  ```

- File name: `project_v<X>_phase<N>.md` — e.g., `project_v140_phase2.md`. For "Other" labels: `project_v<X>_<slug>.md` (e.g., `project_v140_released.md`).

Create the directory if it does not exist, then write the file:

```bash
mkdir -p "$MEMORY_DIR"
# Write the assembled frontmatter + body to $MEMORY_DIR/project_v<X>_phase<N>.md
```

Do NOT overwrite an existing file without confirming with the user via `AskUserQuestion`. If a file at the target path already exists, ask:

```
AskUserQuestion:
  question: "A memory file already exists at <path>. How should I proceed?"
  header: "Overwrite"
  multiSelect: false
  options:
    - label: "Overwrite"
      description: "Replace the existing file with the new content."
    - label: "Append phase suffix"
      description: "Write to `project_v<X>_phase<N>_b.md` instead, preserving the original."
    - label: "Cancel"
      description: "Abort the save. Nothing written."
```

## Step 5 -- Update MEMORY.md index

Append a one-line entry to `$MEMORY_DIR/MEMORY.md`. Match the existing format exactly — look at the current index to calibrate:

```markdown
- [project_v<X>_phase<N>.md](project_v<X>_phase<N>.md) - <one-sentence summary under 150 chars>
```

The summary should be the same prose as the frontmatter `description` field (or a slight condensation if the description itself ran over 150 chars).

### Index cap enforcement

Before appending, count lines:

```bash
INDEX_LINES=$(wc -l < "$MEMORY_DIR/MEMORY.md")
```

If `INDEX_LINES` is already at or approaching 200, pause and ask the user via `AskUserQuestion`:

```
AskUserQuestion:
  question: "MEMORY.md has <N> entries and is approaching the 200-line cap. How should I proceed?"
  header: "Index cap"
  multiSelect: false
  options:
    - label: "Prune oldest handoffs"
      description: "Remove the oldest session_handoff_* entries to make room (keeps project + feedback entries)."
    - label: "Skip index update"
      description: "Write the memory file but do not add an index line. User can add it later."
    - label: "Accept over-cap"
      description: "Append anyway; accept that the index is over 200 lines."
```

Do NOT silently prune. The cap is advisory; the user decides.

## Step 6 -- Optional checkpoint commit

Offer an empty git checkpoint commit so the phase boundary is discoverable in `git log`. This matches the v1.3.0 precedent (`checkpoint: Phase <N> complete and approved by user`).

```
AskUserQuestion:
  question: "Create an empty git checkpoint commit marking this phase boundary?"
  header: "Checkpoint commit"
  multiSelect: false
  options:
    - label: "Yes"
      description: "Runs: git commit --allow-empty -m \"checkpoint: Phase <N> complete and approved by user\""
    - label: "No"
      description: "Skip the commit. The memory file on disk is enough."
```

On "Yes":

```bash
git commit --allow-empty -m "checkpoint: Phase <N> complete and approved by user"
```

If the project is not a git repository, or if HEAD is detached with uncommittable state, skip this step silently (the memory file is still written).

## Step 7 -- Report back

Return a concise confirmation to the user:

```
Memory saved.

  File:    <full path to memory file>
  Index:   updated (<N> entries total)
  Commit:  <SHA or "skipped">
  Summary: <one-sentence description from Step 2 Q2>

Next phase (from memory): <contents of **Next:** section>
```

If any step was skipped or downgraded (e.g., fallback used, index not updated, commit skipped), surface that explicitly in the report so the user knows what is and is not durable.

## Fallback contract

This flow has documented degraded-mode behavior for the three realistic failure modes:

- **Memory directory is not writable.** Do NOT silently fail. Append the would-have-been-written memory content to `.power-engineer/memory-errors.log` in the project root (creating the file if needed), then use `AskUserQuestion` to tell the user the write failed and offer: "Retry", "Save to clipboard instead (user pastes manually)", "Abort". CLAUDE.md auto-memory rules continue to apply without interruption.
- **MEMORY.md index is at/over the 200-line cap.** See Step 5 — user decides (prune / skip / accept). The memory file itself is written regardless.
- **Not on a git branch (detached HEAD, or no commits yet).** Still write the memory file and index entry with a note in the body. Skip Step 6 (checkpoint commit) silently.
- **No `AskUserQuestion` tool available** (rare — e.g., running inside a degraded harness). Write the file with minimal inferred content, populate the body with a "needs user review" marker, and report to the user that the flow completed in degraded mode.

No step blocks on a failure other than a user-requested "Cancel" or "Abort" — the whole point of Tier 3 is durability; silently losing data is the worst outcome.

## Relationship to other tiers

Save-phase (Tier 3: explicit) is the deliberate, user-initiated ceremony that complements the always-on reliability tier and the two automatic hook tiers registered in `.claude/settings.json` via the configurator:

- **Tier 1 (reliability) — CLAUDE.md proactive memory rules.** Always runs in Claude's context; no hook dependency. This is the primary reliability guarantee — if every hook and ceremony fails, Tier 1 still captures memory-worthy information via Claude's own writes to `MEMORY.md`.
- **Tier 2 (automation) — `SessionEnd` hook.** `power-engineer/scripts/hooks/session-end-handoff.sh` fires automatically at session end and writes a raw handoff file (todos, recent commits, modified files). That file is unstructured and NOT indexed in MEMORY.md. Best-effort — does not fire on `/exit` or `/clear`.
- **Tier 3 (explicit) — `/power-engineer save-phase`.** This flow. Structured, curated, indexed. User decides when it runs. Produces the phase-memory files that future sessions consult as authoritative.
- **Tier 3 supplement — `PreCompact` hook.** `power-engineer/scripts/hooks/pre-compact-snapshot.sh` fires automatically before Claude Code compacts context and writes a pre-compaction snapshot. Also unstructured, not indexed. Context-crunch safety net; never blocks compaction.

For the full architecture, see `power-engineer/references/modules/configurator.md` (Memory fallback contracts section) and the per-hook research doc at `docs/superpowers/plans/v1.4.0-hooks-research.md`.

## Errors / Troubleshooting

**Symptom:** Flow writes the file but MEMORY.md index update silently fails.
**Cause:** MEMORY.md does not exist yet (first phase save for this project).
**Fix:** Create it with a `# Memory Index` header before appending, or let Step 5 detect a missing file and seed it. The flow should handle this — if it doesn't, file a bug against this skill.

**Symptom:** `originSessionId` is a timestamp placeholder instead of a real session ID.
**Cause:** The orchestrator harness does not expose the session ID to the flow.
**Fix:** Timestamp placeholder is acceptable; future automation (Cluster C) may add session-ID exposure. Do NOT block the save on this.

**Symptom:** User sees two near-duplicate memory files (e.g., `project_v140_phase2.md` and `project_v140_phase2_b.md`).
**Cause:** The original was preserved on the Step-4 "Append phase suffix" branch because the user chose not to overwrite.
**Fix:** Manually compare and consolidate. The duplicate is a feature, not a bug — it preserved the prior state intentionally.
