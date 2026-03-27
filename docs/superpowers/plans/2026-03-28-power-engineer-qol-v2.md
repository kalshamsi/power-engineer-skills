# Power Engineer QoL v2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make every power-engineer-configured project memory-aware, context-resilient, orchestration-ready, and consistently interactive, while fixing the update pipeline to be robust and idempotent.

**Architecture:** All changes are to power-engineer skill markdown files (no application code). The configurator module receives the bulk of changes (new CLAUDE.md subsections, hook injection, full regeneration, cross-tool config, handoff template). The update flow gets a health check step. The questionnaire gets Q13.

**Tech Stack:** Markdown skill files, JSON (settings.json merge logic), shell commands

**Spec:** `docs/superpowers/specs/2026-03-28-power-engineer-qol-v2-design.md`

---

## File Map

| File                                                 | Action | Responsibility                                                                                                                                      |
| ---------------------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `power-engineer/references/modules/configurator.md`  | Modify | CLAUDE.md template expansion (4 new subsections), hook injection, full regeneration, cheatsheet error handling, cross-tool config, handoff template |
| `power-engineer/references/flows/update.md`          | Modify | Skill health check step, full regeneration enforcement                                                                                              |
| `power-engineer/references/modules/questionnaire.md` | Modify | Q13 (cross-tool usage), updated batch table                                                                                                         |

### Step Renumbering Reference

Tasks 5-8 insert new steps into `configurator.md`. Here is the final ordering:

| Final Step | Content | Added by |
|-----------|---------|----------|
| Step 1 | Create .power-engineer/ state directory | Existing |
| Step 2 | CLAUDE.md generation / smart merge | Existing (template expanded by Tasks 1-4) |
| Step 3 | Skill patching with Project Context | Existing |
| Step 4 | .gitignore check | Existing |
| Step 5 | Inject post-compaction hook | **Task 5 (new)** |
| Step 6 | Generate cheatsheet | Existing (error handling added by Task 6) |
| Step 7 | Cross-tool config generation | **Task 7 (new)** |
| Step 8 | Generate handoff template | **Task 8 (new)** |
| Step 9 | Present configuration summary | Existing (updated by Tasks 5, 8) |

For `update.md`:

| Final Step | Content | Added by |
|-----------|---------|----------|
| Step 1 | Check for state | Existing |
| Step 2 | Skill health check | **Task 9 (new)** |
| Step 3 | Drift detection | Existing (renumbered) |
| Step 4 | Resolve new skills | Existing (renumbered) |
| Step 5 | Present & confirm | Existing (renumbered) |
| Step 6 | Install new skills | Existing (renumbered) |
| Step 7 | Update configuration | Existing (renumbered, full regeneration enforced) |

---

### Task 1: Add Proactive Memory Management subsection to CLAUDE.md template

**Files:**

- Modify: `power-engineer/references/modules/configurator.md:155-195` (Step 2, CLAUDE.md template)

This task adds the `### Proactive Memory Management` subsection inside the managed section of the CLAUDE.md template. This comes AFTER the existing `### Behavioral Rules` subsection.

- [ ] **Step 1: Read the current CLAUDE.md template in configurator.md**

Read `power-engineer/references/modules/configurator.md` lines 155-195 to see the current managed section template.

- [ ] **Step 2: Insert the Memory Management subsection**

In `configurator.md`, inside the CLAUDE.md template (Step 2), after the existing `### Behavioral Rules` subsection and before `### Installed Skills`, insert:

```markdown
### Proactive Memory Management

- After every meaningful interaction, evaluate whether new information was shared that belongs in project memory. Save it to the project's MEMORY.md using proper frontmatter (type: user/project/feedback/reference) without prompting the user.
- Never prompt "should I save this?" or "would you like me to remember this?" Memory management is invisible.
- Auto-detect and save information in these categories:
  - **Brand/design** (colors, fonts, logos, design tokens, UI conventions) → `project` type
  - **Architecture decisions** (tech stack choices, patterns, libraries, conventions) → `project` type
  - **User preferences** (code format, communication style, things to avoid) → `feedback` type
  - **External references** (URLs, API docs, Slack channels, Linear projects) → `reference` type
  - **Bug patterns & debugging** (root causes found, fix patterns, gotchas) → `project` type
  - **Environment & deployment** (staging URLs, deploy commands, CI/CD quirks, env var names, service endpoints) → `project` type
  - **Third-party integrations** (API key locations, rate limits, auth flows, webhook URLs, SDK versions) → `reference` type
  - **Team/stakeholder context** (ownership, contacts, approval workflows, channels, deadlines) → `project` type
- Before saving a new memory, check MEMORY.md index for existing entries on the same topic. Update existing memories rather than creating duplicates.
- Context restoration at session start is handled by Session Orchestration (below). These rules focus on saving.
```

- [ ] **Step 3: Read back and verify**

Read the modified section. Confirm:

- The subsection appears after `### Behavioral Rules` and before `### Installed Skills`
- All 8 trigger categories are present
- Deduplication rule is present
- The cross-reference to Session Orchestration is present

- [ ] **Step 4: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): add Proactive Memory Management subsection to CLAUDE.md template"
```

---

### Task 2: Add Context Management subsection to CLAUDE.md template

**Files:**

- Modify: `power-engineer/references/modules/configurator.md` (Step 2, CLAUDE.md template)

This task adds the `### Context Management` subsection inside the managed section, after the Memory Management subsection added in Task 1.

- [ ] **Step 1: Insert the Context Management subsection**

In `configurator.md`, inside the CLAUDE.md template, after the `### Proactive Memory Management` subsection and before `### Installed Skills`, insert:

```markdown
### Context Management

- **Proactive compaction**: Monitor conversation length. When context usage reaches approximately 60%, proactively save working state to memory and run `/compact`. Do not wait for the system to auto-compact. This is a best-effort heuristic — Claude Code does not expose a precise token counter.
- **Pre-compaction save**: Before compacting, save to memory: what you're working on, decisions made so far, files modified, next steps planned.
- **Post-compaction restore**: After compaction, immediately re-read `.power-engineer/project-context.md`, `.power-engineer/brand.md`, `.power-engineer/state.json`, and MEMORY.md to restore full project awareness.
- **Token-aware progressive loading**: Load project context in priority order:
  - Always load: CLAUDE.md rules, installed skills list, current task context
  - On demand: Brand details (only for design work), deployment details (only when deploying), integration details (only when touching integrations)
  - Read `.power-engineer/` files relevant to the current task, not all of them
```

- [ ] **Step 2: Read back and verify**

Confirm:

- Subsection appears after Memory Management, before Installed Skills
- All 4 rules present (proactive compaction, pre-save, post-restore, progressive loading)
- Heuristic disclaimer is included for the 60% threshold

- [ ] **Step 3: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): add Context Management subsection to CLAUDE.md template"
```

---

### Task 3: Replace AskUserQuestion rule with universal version

**Files:**

- Modify: `power-engineer/references/modules/configurator.md` (Step 2, `### Behavioral Rules`)

This task replaces the existing skill-scoped AskUserQuestion rule with the universal version that covers all conversations.

- [ ] **Step 1: Find and replace the existing rule**

In `configurator.md`, inside the CLAUDE.md template's `### Behavioral Rules` subsection, find:

```markdown
- All user-facing questions across ALL installed skills MUST use the `AskUserQuestion` tool. Never ask questions as plain text. This applies to confirmations, choices, interviews, and any point where user input is needed — regardless of which skill is active.
```

Replace with:

```markdown
- **Universal AskUserQuestion enforcement**: Every question directed at the user MUST use the `AskUserQuestion` tool. This applies to ALL contexts — skill invocations, general conversation, debugging sessions, code reviews, clarifications, confirmations, and any other interaction where user input is needed. Never ask questions as plain text in a response. The only exception is rhetorical questions in explanations (e.g., "Why does this matter?" followed by the answer in the same message).
```

- [ ] **Step 2: Read back and verify**

Confirm:

- The old rule text is gone
- The new rule mentions "ALL contexts" not just "ALL installed skills"
- The rhetorical exception is present

- [ ] **Step 3: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): expand AskUserQuestion enforcement to all contexts"
```

---

### Task 4: Add Session Orchestration subsection to CLAUDE.md template

**Files:**

- Modify: `power-engineer/references/modules/configurator.md` (Step 2, CLAUDE.md template)

This task adds the `### Session Orchestration` subsection inside the managed section, after the Context Management subsection.

- [ ] **Step 1: Insert the Session Orchestration subsection**

In `configurator.md`, inside the CLAUDE.md template, after `### Context Management` and before `### Installed Skills`, insert:

```markdown
### Session Orchestration

- **Session start protocol**: At the beginning of every session, read: MEMORY.md index, `.power-engineer/project-context.md`, `.power-engineer/brand.md`, installed skills list from state.json. Establish baseline awareness before any work begins.
- **Session end protocol**: Before ending a session (when the user wraps up or explicitly ends), save to memory: what was accomplished, decisions made, unfinished work, and next steps. Use the `project` memory type with a descriptive name like `session_handoff_YYYY-MM-DD`. Follow the handoff template structure from `.power-engineer/handoff-template.md`.
- **Subagent context passing**: When spawning subagents (via Agent tool or dispatching-parallel-agents), include in the prompt: relevant project context from `.power-engineer/project-context.md`, brand details if the task involves design, and relevant MEMORY.md entries. Subagents must also follow AskUserQuestion enforcement.
- **Subagent result capture**: When a subagent completes, evaluate its results for memory-worthy information and save to MEMORY.md if applicable.
```

- [ ] **Step 2: Read back and verify**

Confirm:

- Subsection appears after Context Management, before Installed Skills
- All 4 rules present (start, end, subagent pass, subagent capture)
- Handoff template reference is included
- Subagent AskUserQuestion enforcement is mentioned

- [ ] **Step 3: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): add Session Orchestration subsection to CLAUDE.md template"
```

---

### Task 5: Add post-compaction hook injection to configurator

**Files:**

- Modify: `power-engineer/references/modules/configurator.md` (add new Step after Step 4 / .gitignore check)

This task adds a new step to the configurator that injects a PostToolUse hook into `.claude/settings.json` using a read-merge-write strategy.

- [ ] **Step 1: Read the current step numbering**

Read `configurator.md` to identify the current Step 4 (.gitignore check) location and Step 5 (cheatsheet) location. The new hook injection step will be inserted between them.

- [ ] **Step 2: Insert the hook injection step**

After the `.gitignore check` step (current Step 4) and before the cheatsheet step (current Step 5), insert a new step. Renumber subsequent steps accordingly.

New step content:

````markdown
## Step 5: Inject post-compaction hook

Inject a PostToolUse hook into `.claude/settings.json` that fires after `/compact` to restore project context. Use a **read-merge-write** strategy to preserve existing settings.

### Process

1. Read `.claude/settings.json` (if it exists). If it doesn't exist, start with `{}`
2. Ensure the `hooks` key exists (create empty object if missing)
3. Ensure `hooks.PostToolUse` exists (create empty array if missing)
4. Search the `PostToolUse` array for an entry with `"matcher": "compact"`
   - If found: update its `command` value to the latest version below
   - If not found: append the new entry to the array
5. Write back the full settings.json, preserving all existing keys (permissions, env, other hooks)

**NEVER overwrite the entire settings.json.** Only touch the specific hook entry.

### Hook entry

```json
{
  "matcher": "compact",
  "command": "echo '## Post-Compaction Context Restore\nRe-read the following files to restore project context:\n- .power-engineer/project-context.md\n- .power-engineer/brand.md\n- .power-engineer/state.json (installed skills)\n- Check MEMORY.md for recent project memories'"
}
```
````

### On re-run

Same process — the read-merge-write strategy is idempotent. If the hook already exists, its command is updated to the latest version.

```

- [ ] **Step 3: Renumber subsequent steps**

- Old Step 5 (cheatsheet) → Step 6
- Old Step 6 (summary) → Step 7
- Update the summary step to include the hook in its output:

Add this line to the summary output:
```

Compaction hook: .claude/settings.json (PostToolUse hook injected)

````

Also add `.power-engineer/handoff-template.md` to the summary.

- [ ] **Step 4: Read back and verify**

Confirm:
- New Step 5 appears between .gitignore check and cheatsheet
- 5-step read-merge-write process is documented
- Hook JSON entry is present
- Re-run behavior is documented
- Step numbering is sequential (1-7)
- Summary step updated

- [ ] **Step 5: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): add post-compaction hook injection step with read-merge-write"
````

---

### Task 6: Add cheatsheet error handling and full regeneration logic

**Files:**

- Modify: `power-engineer/references/modules/configurator.md` (Step 6, formerly Step 5 -- cheatsheet generation)

This task modifies the cheatsheet generation step to handle missing catalog entries gracefully (warning row instead of silent skip) and adds a note that all outputs are always regenerated on re-run.

- [ ] **Step 1: Add error handling to the cheatsheet step**

In the cheatsheet generation step (now Step 6 after Task 5 renumbering), after the existing `### Notes` section, add:

```markdown
### Error handling

If a skill in `state.json` cannot be found in any catalog file under
`references/catalog/`, do NOT silently skip it. Instead, include a warning
row in the cheatsheet:
```

| /skill-name | ⚠ Not found in catalog — may be manually installed or from a plugin |

```

This ensures the user sees all installed skills, even if metadata is unavailable.
```

- [ ] **Step 2: Add full regeneration note at the top of configurator.md**

After the module description at the top of the file (line 2), add:

```markdown
## Regeneration Policy

On every run (initial or re-run), the configurator regenerates ALL outputs:

- CLAUDE.md managed section (between delimiters, preserving content outside)
- `.power-engineer/cheatsheet.md`
- `.power-engineer/project-context.md`
- `.power-engineer/brand.md` (if brand info exists)
- `.power-engineer/state.json` (update scan_snapshot + updated timestamp; preserve questionnaire_answers, preferences, installed_skills)
- `.power-engineer/handoff-template.md`

Files NOT modified by the configurator (handled by other modules):

- `.power-engineer/drift-history.json` (drift-detector appends)
- `.power-engineer/install-log.sh` (installer appends)

This ensures re-runs always produce complete, current output — no file is
silently skipped or left stale.
```

- [ ] **Step 3: Read back and verify**

Confirm:

- Cheatsheet error handling section is present with the warning row format
- Regeneration policy section is at the top of the file
- drift-history.json is explicitly listed as NOT modified by configurator

- [ ] **Step 4: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): add cheatsheet error handling and full regeneration policy"
```

---

### Task 7: Add cross-tool config generation to configurator

**Files:**

- Modify: `power-engineer/references/modules/configurator.md` (add new Step after handoff template, before summary)

This task adds a step that generates `.cursorrules`, `copilot-instructions.md`, and `.windsurfrules` when the user selected those tools in Q13.

- [ ] **Step 1: Insert the cross-tool config step**

After the cheatsheet step (Step 6) and before the summary step, insert as new Step 7 (see Step Renumbering Reference table):

```markdown
## Step 7: Cross-tool config generation (conditional)

If the user answered Q13 with any AI coding tools other than "None", generate
corresponding config files that mirror the CLAUDE.md behavioral rules.

Only generate files for tools the user selected. Skip this step entirely if
Q13 was "None" or was auto-skipped.

| Q13 answer     | File to generate                  | Format                                                         |
| -------------- | --------------------------------- | -------------------------------------------------------------- |
| Cursor         | `.cursorrules`                    | Cursor rules format — one rule per line, no markdown headers   |
| GitHub Copilot | `.github/copilot-instructions.md` | Markdown — same structure as CLAUDE.md behavioral sections     |
| Windsurf       | `.windsurfrules`                  | Windsurf rules format — one rule per line, no markdown headers |

### Content to mirror

Include these behavioral rules from the CLAUDE.md managed section:

- Behavioral Rules (all project-specific rules)
- Proactive Memory Management (adapted: reference MEMORY.md equivalent if tool supports it, otherwise omit)
- Context Management (adapted: omit Claude-specific compaction rules)
- Universal AskUserQuestion enforcement (omit — tool-specific, not portable)
- Session Orchestration (omit — Claude-specific)

### On re-run

If the user's Q13 answer changes (e.g., they remove Cursor), do NOT delete
the old config file. Leave it in place — the user may have customized it.
Only regenerate files for currently-selected tools.

### If `.cursorrules` or `.windsurfrules` already exists

Use the same delimiter strategy as CLAUDE.md:

- Search for `<!-- power-engineer:managed-section -->`
- If found: replace content between delimiters
- If not found: append the managed section at the end
```

- [ ] **Step 2: Read back and verify**

Confirm:

- Step appears in correct position
- All 3 tools listed with correct file paths
- Content mirroring rules specify what to include/exclude
- Re-run behavior is documented (don't delete old files)
- Delimiter strategy for existing files is documented

- [ ] **Step 3: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): add conditional cross-tool config generation step"
```

---

### Task 8: Add handoff template generation to configurator

**Files:**

- Modify: `power-engineer/references/modules/configurator.md` (add new Step before summary)

This task adds a step that generates `.power-engineer/handoff-template.md`.

- [ ] **Step 1: Insert the handoff template step**

After the cross-tool config step (Step 7) and before the summary step, insert:

````markdown
## Step 8: Generate handoff template

Write `.power-engineer/handoff-template.md`:

```markdown
# Session Handoff Template

Use this structure when saving session handoff memories to MEMORY.md.
Save as a `project` type memory with name `session_handoff_YYYY-MM-DD`.

## Fields

- **Date**: [ISO date of session end]
- **What was accomplished**: [Summary of work completed this session]
- **Decisions made**: [Key decisions with brief reasoning]
- **Unfinished work**: [Items with enough context to resume — what was in progress, what approach was being taken, what's left]
- **Next steps**: [Prioritized list of what to do next]
- **Files modified**: [Paths with brief description of changes]
- **Blockers/open questions**: [Anything that needs resolution before continuing]
```
````

### On re-run

Overwrite the existing handoff-template.md with the latest version.
This file is a reference template, not user-editable content.

```

- [ ] **Step 2: Renumber the summary step**

The summary step becomes Step 9. Update its output to include:
```

Handoff template: .power-engineer/handoff-template.md
Compaction hook: .claude/settings.json (PostToolUse hook injected)
Cross-tool configs: [list of generated files, or "skipped (no cross-tool usage)"]

````

- [ ] **Step 3: Read back and verify**

Confirm:
- Handoff template content matches spec
- Step numbering is sequential through Step 9
- Summary step lists all new outputs

- [ ] **Step 4: Commit**

```bash
git add power-engineer/references/modules/configurator.md
git commit -m "feat(configurator): add handoff template generation and update summary"
````

---

### Task 9: Add skill health check to update flow

**Files:**

- Modify: `power-engineer/references/flows/update.md`

This task adds a skill health check step to the update flow, before drift detection. It also ensures the configurator runs full regeneration.

- [ ] **Step 1: Read the current update.md**

Read `power-engineer/references/flows/update.md` to see the current step structure.

- [ ] **Step 2: Insert skill health check as Step 2**

Renumber current Step 2 (drift detection) to Step 3, and all subsequent steps accordingly. Insert new Step 2:

```markdown
## Step 2 -- Skill health check

Before detecting drift, verify the integrity of all installed skills.

1. Read `.power-engineer/state.json` and extract the `installed_skills` array
2. For each skill, check:
   - Directory exists on disk: `.claude/skills/[name]/` OR `.agents/skills/[name]/`
   - `SKILL.md` is present and non-empty within the directory
3. Also scan skill directories on disk for skills NOT in state.json (orphaned)
4. Classify each skill:
   - **Healthy**: Directory exists, SKILL.md present and non-empty
   - **Missing**: In state.json but directory not found on disk
   - **Broken**: Directory exists but SKILL.md missing or empty
   - **Orphaned**: Directory exists on disk but not listed in state.json

5. Present the health check report:
```

Skill Health Check: [healthy]/[total] healthy

```

If any issues found, add:
```

⚠ Missing ([count]): [skill-names]
⚠ Broken ([count]): [skill-names] — SKILL.md is empty/missing
ℹ Orphaned ([count]): [skill-names] — on disk but not in state.json

```

6. If missing or broken skills exist, use AskUserQuestion:

```

AskUserQuestion:
question: "Some installed skills have issues. How should I handle them?"
header: "Health"
options: - label: "Reinstall broken/missing skills"
description: "Re-run the install commands for skills that are missing or broken" - label: "Remove from state"
description: "Remove broken/missing entries from state.json and continue" - label: "Skip for now"
description: "Continue with the update, ignore the issues"
multiSelect: false

```

7. If orphaned skills exist, use AskUserQuestion:

```

AskUserQuestion:
question: "Found skills on disk that aren't tracked in state.json. Add them?"
header: "Orphaned"
options: - label: "Add to state.json"
description: "Track these skills in state so they appear in cheatsheet and future health checks" - label: "Ignore"
description: "Leave them untracked"
multiSelect: false

```

```

- [ ] **Step 3: Renumber all subsequent steps and update final step**

After inserting the health check as Step 2, renumber all existing step headings:
- `## Step 2 -- Drift detection` → `## Step 3 -- Drift detection`
- `## Step 3 -- Resolve new skills` → `## Step 4 -- Resolve new skills`
- `## Step 4 -- Present & confirm` → `## Step 5 -- Present & confirm`
- `## Step 5 -- Install new skills` → `## Step 6 -- Install new skills`
- `## Step 6 -- Update configuration` → `## Step 7 -- Update configuration`

Then in Step 7's body (formerly Step 6), replace:

```markdown
Read `references/modules/configurator.md`. Update state.json, refresh
CLAUDE.md managed section, re-patch skills with updated project context.
```

With:

```markdown
Read `references/modules/configurator.md`. Run the FULL configurator —
regenerate ALL outputs (CLAUDE.md managed section, cheatsheet, project-context,
brand, state.json, handoff template, compaction hook, cross-tool configs).
The configurator's regeneration policy ensures no file is silently skipped.
```

- [ ] **Step 4: Read back and verify**

Confirm:

- Step 2 is skill health check (before drift detection)
- All steps are renumbered correctly (1-7)
- Health check covers healthy/missing/broken/orphaned
- AskUserQuestion is used for both missing/broken and orphaned skills
- Step 7 explicitly calls for full regeneration

- [ ] **Step 5: Commit**

```bash
git add power-engineer/references/flows/update.md
git commit -m "feat(update): add skill health check step and enforce full regeneration"
```

---

### Task 10: Add Q13 (cross-tool usage) to questionnaire

**Files:**

- Modify: `power-engineer/references/modules/questionnaire.md`

This task adds Q13 to the questionnaire and updates the batch table and skip rules.

- [ ] **Step 1: Add Q13 skip rule to the skip rules table**

In the `### Question skip rules` table, add a new row after Q12:

```markdown
| Q13 Cross-tool usage | `.cursorrules` exists OR `copilot-instructions.md` exists OR `.windsurfrules` exists (show detected, ask to confirm/add) |
```

- [ ] **Step 2: Update the batching strategy table**

In the `## Batching strategy` section, add batch 6:

```markdown
| 6 | Q13 | Cross-tool usage |
```

- [ ] **Step 3: Add Q13 question definition**

After the `### Q12 -- Security needs` section, add:

```markdown
### Q13 -- Cross-tool usage
```

question: "Do you use other AI coding tools alongside Claude Code?"
header: "Tools"
multiSelect: true
options:

- label: "Cursor"
  description: "Generate .cursorrules with project behavioral rules"
- label: "GitHub Copilot"
  description: "Generate .github/copilot-instructions.md with project behavioral rules"
- label: "Windsurf"
  description: "Generate .windsurfrules with project behavioral rules"
- label: "None"
  description: "Only using Claude Code — skip cross-tool config generation"

```

Note: If cross-tool config files are detected on disk during the scan, present
detections before asking. If the user selects "None", no config files are
generated. The answer is stored in `state.json` under
`questionnaire_answers.cross_tool_usage`.
```

- [ ] **Step 4: Update the SkillPlan output section**

In the `## Output: SkillPlan` section, add to the "From answers" block:

```markdown
cross_tool_usage: [Q13 answers]
```

- [ ] **Step 5: Read back and verify**

Confirm:

- Q13 appears in skip rules table
- Batch 6 appears in batching table
- Q13 question definition is present with correct AskUserQuestion format
- SkillPlan output includes `cross_tool_usage`

- [ ] **Step 6: Commit**

```bash
git add power-engineer/references/modules/questionnaire.md
git commit -m "feat(questionnaire): add Q13 cross-tool usage question"
```

---

### Task 11: Final verification against spec

**Files:**

- Read: `power-engineer/references/modules/configurator.md` (full file)
- Read: `power-engineer/references/flows/update.md` (full file)
- Read: `power-engineer/references/modules/questionnaire.md` (full file)
- Read: `docs/superpowers/specs/2026-03-28-power-engineer-qol-v2-design.md` (spec)

- [ ] **Step 1: Read all three modified files in full**

Read each file completely to verify all changes are present and consistent.

- [ ] **Step 2: Verify against spec checklist**

Check each spec requirement is implemented:

| Spec Requirement                                                          | Where Implemented                   | Status |
| ------------------------------------------------------------------------- | ----------------------------------- | ------ |
| Feature 1: Memory management (8 categories, auto-save, dedup)             | configurator.md CLAUDE.md template  | ☐      |
| Feature 2A: Context rules (60% compact, pre/post save, progressive)       | configurator.md CLAUDE.md template  | ☐      |
| Feature 2B: Post-compaction hook (read-merge-write, matcher=compact)      | configurator.md new Step 5          | ☐      |
| Feature 3: Universal AskUserQuestion (all contexts, rhetorical exception) | configurator.md Behavioral Rules    | ☐      |
| Feature 4A: Full output regeneration (all files, every run)               | configurator.md Regeneration Policy | ☐      |
| Feature 4A: Cheatsheet error handling (warning row, not silent skip)      | configurator.md cheatsheet step     | ☐      |
| Feature 4B: Skill health check (healthy/missing/broken/orphaned)          | update.md Step 2                    | ☐      |
| Feature 4C: Q13 cross-tool usage (batch 6, auto-skip)                     | questionnaire.md                    | ☐      |
| Feature 4C: Cross-tool config generation (conditional)                    | configurator.md new step            | ☐      |
| Feature 5A: Session start/end protocols                                   | configurator.md CLAUDE.md template  | ☐      |
| Feature 5B: Subagent context passing + result capture                     | configurator.md CLAUDE.md template  | ☐      |
| Feature 5C: Handoff template generation                                   | configurator.md new step            | ☐      |

- [ ] **Step 3: Verify internal consistency**

Check:

- Step numbering in configurator.md is sequential (1 through 9)
- Step numbering in update.md is sequential (1 through 7)
- All cross-references between files are correct
- The CLAUDE.md template's managed section has subsections in correct order:
  1. Behavioral Rules (with universal AskUserQuestion)
  2. Proactive Memory Management
  3. Context Management
  4. Session Orchestration
  5. Installed Skills
  6. Brand Context
  7. Project Goals
  8. Team Workflow

- [ ] **Step 4: Final commit (if any fixes were needed)**

```bash
git add -A
git commit -m "fix: address verification issues in QoL v2 implementation"
```

Only run this if Step 2 or Step 3 revealed issues that needed fixing.
