# Power Engineer QoL v2 -- Design Specification

**Date**: 2026-03-28
**Status**: Draft
**Approach**: Infrastructure + Rules (Approach B)

## Overview

A unified set of quality-of-life improvements to power-engineer that make every project using it memory-aware, context-resilient, orchestration-ready, and consistently interactive -- while fixing the update pipeline to be robust and idempotent.

### Problem Statement

Power-engineer installs skills and generates CLAUDE.md, but the generated configuration lacks:
- Proactive memory management (Claude doesn't automatically save important project details)
- Context resilience (compaction loses project awareness with no recovery mechanism)
- Universal AskUserQuestion enforcement (only works within skills, not general conversation)
- Robust update pipeline (re-runs silently skip outputs like cheatsheet.md)
- Session/agent orchestration support (no handoff protocol between sessions or subagents)

### Success Criteria

1. Any project using power-engineer gets automatic, invisible memory management -- Claude saves branding, decisions, preferences, and operational knowledge without being asked
2. Sessions survive compaction with full context restored via hook + behavioral rules
3. Every question Claude asks the user goes through AskUserQuestion, regardless of context
4. Re-running power-engineer on an existing project always produces all expected outputs (cheatsheet, CLAUDE.md section, state files) with no silent failures
5. Multi-session and multi-agent workflows have clear continuity through handoff protocols

---

## Feature 1: Proactive Memory Management

### Mechanism

CLAUDE.md behavioral rules injected into the managed section by the configurator.

### Rules

The following rules are added as a `### Proactive Memory Management` subsection within the `## Power Engineer` managed section:

1. **Auto-detect and save**: After every meaningful interaction, evaluate whether new information was shared that belongs in project memory. Save it to the project's MEMORY.md using proper frontmatter (type: user/project/feedback/reference) without prompting the user.

2. **Never ask to save**: Do not prompt the user "should I save this?" or "would you like me to remember this?" Just save it. Memory management should be invisible.

3. **8 trigger categories** -- Claude should watch for and auto-save information in these categories:

   | Category | Trigger examples | Memory type |
   |----------|-----------------|-------------|
   | Brand/design | Colors, fonts, logos, design tokens, UI conventions | `project` |
   | Architecture decisions | Tech stack choices, patterns, libraries, conventions | `project` |
   | User preferences | Code format, communication style, things to avoid | `feedback` |
   | External references | URLs, API docs, Slack channels, Linear projects | `reference` |
   | Bug patterns & debugging | Root causes found, fix patterns, gotchas | `project` |
   | Environment & deployment | Staging URLs, deploy commands, CI/CD quirks, env var names, service endpoints | `project` |
   | Third-party integrations | API key locations, rate limits, auth flows, webhook URLs, SDK versions | `reference` |
   | Team/stakeholder context | Ownership, contacts, approval workflows, channels, deadlines | `project` |

4. **Deduplication**: Before saving a new memory, check the MEMORY.md index for existing entries on the same topic. Update existing memories rather than creating duplicates.

5. **Deduplication applies to session start too**: Context restoration at session start is handled by the Session Orchestration subsection (Feature 5A). The memory management rules focus on *saving* -- the orchestration rules handle *loading*.

### Files Modified

- `configurator.md` -- Add memory management rules block to CLAUDE.md template within managed section

---

## Feature 2: Context Management & Compaction Resilience

### Mechanism

Dual approach: CLAUDE.md behavioral rules + settings.json post-compaction hook.

### A. CLAUDE.md Rules

Added as a `### Context Management` subsection:

1. **Proactive compaction at ~60% (heuristic)**: Monitor conversation length. When context usage reaches approximately 60%, proactively save working state to memory and run `/compact`. Do not wait for the system to auto-compact at capacity. Compact early and often to maintain performance. *Note: Claude Code does not expose a precise token counter to the model. This rule relies on Claude's estimation of conversation length -- it is best-effort guidance, not a precise threshold. The post-compaction hook (Feature 2B) provides the guaranteed safety net.*

2. **Pre-compaction save**: Before compacting, save current working state to memory: what you're working on, decisions made so far, files modified, next steps planned.

3. **Post-compaction restore**: After compaction, immediately re-read `.power-engineer/project-context.md`, `.power-engineer/brand.md`, `.power-engineer/state.json`, and MEMORY.md to restore full project awareness.

4. **Token-aware progressive loading**: Don't dump all context at once. Load in priority order:
   - **Always load**: CLAUDE.md rules, installed skills list, current task context
   - **On demand**: Brand details (only when doing design work), deployment details (only when deploying), integration details (only when touching integrations)
   - **Rule**: "Read .power-engineer/ files relevant to the current task, not all of them"

### B. Post-Compaction Hook

The configurator injects a hook into the project's `.claude/settings.json` using a **read-merge-write** strategy:

1. Read existing `.claude/settings.json` (or initialize empty object if it doesn't exist)
2. Ensure `hooks` key exists (create if missing)
3. Ensure `hooks.PostToolUse` array exists (create if missing)
4. Check if a hook entry with `"matcher": "compact"` already exists in the array
   - If yes: update its `command` to the latest version (idempotent)
   - If no: append the new entry to the array
5. Write back the full settings.json, preserving all existing keys (permissions, env, other hooks, etc.)

**Never overwrite the entire settings.json.** Only touch the specific hook entry.

Hook entry to inject:

```json
{
  "matcher": "compact",
  "command": "echo '## Post-Compaction Context Restore\nRe-read the following files to restore project context:\n- .power-engineer/project-context.md\n- .power-engineer/brand.md\n- .power-engineer/state.json (installed skills)\n- Check MEMORY.md for recent project memories'"
}
```

This guarantees context restoration even if Claude doesn't "remember" the CLAUDE.md rule post-compaction. The hook fires automatically after every `/compact`.

### Files Modified

- `configurator.md` -- Add context management rules to CLAUDE.md template + inject hook into settings.json

---

## Feature 3: Universal AskUserQuestion Enforcement

### Mechanism

Enhanced CLAUDE.md behavioral rule replacing the existing skill-scoped version.

### Rule

The existing rule in the managed section:

> "All user-facing questions across ALL installed skills MUST use the AskUserQuestion tool."

Is replaced with:

> **Universal AskUserQuestion enforcement**: Every question directed at the user MUST use the `AskUserQuestion` tool. This applies to ALL contexts -- skill invocations, general conversation, debugging sessions, code reviews, clarifications, confirmations, and any other interaction where user input is needed. Never ask questions as plain text in a response. The only exception is rhetorical questions in explanations (e.g., "Why does this matter?" followed by the answer in the same message).

### Scope Change

- **Before**: "across ALL installed skills"
- **After**: "ALL contexts" -- skills, conversation, debugging, reviews, everything
- **Exception**: Rhetorical questions within explanations (question + answer in same message)

### Files Modified

- `configurator.md` -- Replace existing AskUserQuestion rule with universal version

---

## Feature 4: Update/Upgrade Pipeline Overhaul

### 4A. Full Output Regeneration

When power-engineer detects an existing project (state.json present), the configurator **always regenerates all outputs** regardless of what changed:

| Output file | Regeneration behavior |
|-------------|----------------------|
| CLAUDE.md managed section | Re-render between `<!-- power-engineer:managed-section -->` delimiters. Content outside delimiters is preserved. |
| cheatsheet.md | Regenerate from current installed_skills in state.json. If a skill can't be found in the catalog, log a warning in the cheatsheet instead of silently skipping. |
| project-context.md | Refresh from current scan + stored questionnaire answers |
| brand.md | Refresh from current codebase scan |
| state.json | Update scan_snapshot and updated timestamp. Preserve questionnaire_answers, preferences, installed_skills. |
| drift-history.json | Do not modify. This is a separate file -- only append to it when recording a new run (handled by existing drift-detector logic). |
| install-log.sh | Append new run entries. Preserve history. |

**Error handling for cheatsheet**: If a skill in state.json can't be found in any catalog file, the cheatsheet entry shows:

```
| /skill-name | ⚠ Not found in catalog -- may be manually installed or from a plugin |
```

This replaces the current silent-skip behavior.

### 4B. Skill Health Check

New step added to the update flow, **before** drift detection:

1. Read `state.json` installed_skills array
2. For each skill, verify:
   - Directory exists on disk (`.claude/skills/<name>/` or `.agents/skills/<name>/`)
   - `SKILL.md` is present and non-empty within the directory
3. Classify each skill:
   - **Healthy**: Directory exists, SKILL.md present and non-empty
   - **Missing**: Directory not found on disk
   - **Broken**: Directory exists but SKILL.md missing or empty
   - **Orphaned**: Exists on disk but not in state.json
4. Report findings:
   ```
   Skill Health Check: 42/45 healthy
   ⚠ Missing (2): [skill-a], [skill-b]
   ⚠ Broken (1): [skill-c] -- SKILL.md is empty
   ```
5. Offer to reinstall missing/broken skills or remove them from state via AskUserQuestion

### 4C. New Questionnaire Question (Q13)

Added to `questionnaire.md` after Q12 (security needs):

> **Q13: Cross-tool usage**
> "Do you use other AI coding tools alongside Claude Code?"
> Options: Cursor, GitHub Copilot, Windsurf, None
> Multi-select. Auto-skip if none detected in project (no .cursorrules, no copilot config, no .windsurfrules).
> Batch placement: batch 6 (new batch, after Q12's batch 5).

If any tools selected, the configurator generates corresponding config files:

| Tool selected | File generated | Content |
|---------------|---------------|---------|
| Cursor | `.cursorrules` | Mirror of CLAUDE.md behavioral rules adapted for Cursor format |
| GitHub Copilot | `.github/copilot-instructions.md` | Mirror adapted for Copilot format |
| Windsurf | `.windsurfrules` | Mirror adapted for Windsurf format |

These files are regenerated on every update alongside CLAUDE.md.

### Files Modified

- `configurator.md` -- Full regeneration logic, cheatsheet error handling, cross-tool config generation, health check reporting
- `update.md` -- Add health check step before drift detection, ensure configurator runs full regeneration
- `questionnaire.md` -- Add Q13 with auto-skip logic

---

## Feature 5: Orchestration -- Session Continuity, Subagent Awareness & Handoff Protocol

### 5A. Session Continuity (CLAUDE.md rules)

Added as `### Session Orchestration` subsection:

1. **Session start protocol**: At the beginning of every session, read: MEMORY.md index, `.power-engineer/project-context.md`, `.power-engineer/brand.md`, installed skills list from state.json. This establishes baseline awareness before any work begins.

2. **Session end protocol**: Before ending a session (when the user says goodbye, wraps up, or explicitly ends), save to memory: what was accomplished, decisions made, unfinished work, and next steps. Use the `project` memory type with a descriptive name like `session_handoff_YYYY-MM-DD`.

### 5B. Subagent Awareness (CLAUDE.md rules)

3. **Subagent context passing**: When spawning subagents (via Agent tool or dispatching-parallel-agents skill), include in the subagent prompt: relevant project context from `.power-engineer/project-context.md`, brand details if the task involves design, and any relevant MEMORY.md entries. Subagents must also follow AskUserQuestion enforcement.

4. **Subagent result capture**: When a subagent completes, evaluate its results for memory-worthy information and save to MEMORY.md if applicable.

### 5C. Handoff Protocol Template

The configurator generates `.power-engineer/handoff-template.md`:

```markdown
## Session Handoff

- **Date**: [ISO date]
- **What was accomplished**: [summary of work done]
- **Decisions made**: [key decisions with reasoning]
- **Unfinished work**: [items with enough context to resume]
- **Next steps**: [prioritized list]
- **Files modified**: [paths with brief description of changes]
- **Blockers/open questions**: [anything that needs resolution]
```

The CLAUDE.md rule instructs Claude to use this template structure when saving session handoff memories. The handoff is saved to MEMORY.md as a `project` type memory, not as a separate file on disk -- keeping the memory system as the single source of truth.

### Files Modified

- `configurator.md` -- Add orchestration rules to CLAUDE.md template, generate handoff-template.md

---

## Summary of All File Changes

| File | Changes |
|------|---------|
| `configurator.md` | Major: new CLAUDE.md sections (memory, context, AskUserQuestion, orchestration), post-compaction hook injection, full regeneration logic, cheatsheet error handling, cross-tool config generation, handoff template generation |
| `update.md` | Add skill health check step, ensure full regeneration on every update |
| `questionnaire.md` | Add Q13 (cross-tool usage) with auto-skip logic |
| `drift-detector.md` | No changes needed (health check is in update.md, not drift-detector) |
| `skill-resolver.md` | No changes needed |
| `installer.md` | No changes needed |
| `SKILL.md` | No changes needed |

### New Files Generated Per-Project

| File | Purpose |
|------|---------|
| `.power-engineer/handoff-template.md` | Template structure for session handoff memories |
| `.cursorrules` (conditional) | Cross-tool behavioral rules for Cursor |
| `.github/copilot-instructions.md` (conditional) | Cross-tool behavioral rules for GitHub Copilot |
| `.windsurfrules` (conditional) | Cross-tool behavioral rules for Windsurf |

### New Entries in settings.json Per-Project

| Entry | Purpose |
|-------|---------|
| `hooks.PostToolUse[matcher=compact]` | Post-compaction context restore reminder |

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────┐
│                  power-engineer run                   │
│                                                       │
│  ┌──────────┐   ┌──────────────┐   ┌──────────────┐ │
│  │ Scanner  │──▶│Questionnaire │──▶│Skill Resolver│ │
│  │          │   │ (+Q13 cross- │   │              │ │
│  │          │   │  tool usage) │   │              │ │
│  └──────────┘   └──────────────┘   └──────────────┘ │
│                                           │          │
│  ┌──────────────────────────────────────────┐        │
│  │              Installer                    │        │
│  └──────────────────────────────────────────┘        │
│                       │                              │
│  ┌────────────────────▼─────────────────────────┐    │
│  │           Configurator (UPDATED)              │    │
│  │                                               │    │
│  │  ┌─────────────────────────────────────────┐  │    │
│  │  │         CLAUDE.md managed section        │  │    │
│  │  │  ┌───────────────────────────────────┐  │  │    │
│  │  │  │ Proactive Memory Management       │  │  │    │
│  │  │  │ (8 trigger categories, auto-save) │  │  │    │
│  │  │  ├───────────────────────────────────┤  │  │    │
│  │  │  │ Context Management                │  │  │    │
│  │  │  │ (60% compact, pre/post save)      │  │  │    │
│  │  │  ├───────────────────────────────────┤  │  │    │
│  │  │  │ Universal AskUserQuestion         │  │  │    │
│  │  │  │ (all contexts, not just skills)   │  │  │    │
│  │  │  ├───────────────────────────────────┤  │  │    │
│  │  │  │ Session Orchestration             │  │  │    │
│  │  │  │ (start/end protocol, subagents,   │  │  │    │
│  │  │  │  handoff protocol)                │  │  │    │
│  │  │  ├───────────────────────────────────┤  │  │    │
│  │  │  │ Installed Skills (existing)       │  │  │    │
│  │  │  ├───────────────────────────────────┤  │  │    │
│  │  │  │ Project Goals (existing)          │  │  │    │
│  │  │  ├───────────────────────────────────┤  │  │    │
│  │  │  │ Team Workflow (existing)          │  │  │    │
│  │  │  └───────────────────────────────────┘  │  │    │
│  │  └─────────────────────────────────────────┘  │    │
│  │                                               │    │
│  │  ┌─────────────────────────────────────────┐  │    │
│  │  │       settings.json hook injection       │  │    │
│  │  │  PostToolUse[compact] → context restore  │  │    │
│  │  └─────────────────────────────────────────┘  │    │
│  │                                               │    │
│  │  ┌─────────────────────────────────────────┐  │    │
│  │  │      Full output regeneration            │  │    │
│  │  │  cheatsheet + state + context + brand    │  │    │
│  │  └─────────────────────────────────────────┘  │    │
│  │                                               │    │
│  │  ┌─────────────────────────────────────────┐  │    │
│  │  │      Cross-tool config (conditional)     │  │    │
│  │  │  .cursorrules / copilot / .windsurfrules │  │    │
│  │  └─────────────────────────────────────────┘  │    │
│  │                                               │    │
│  │  ┌─────────────────────────────────────────┐  │    │
│  │  │      Handoff template generation         │  │    │
│  │  └─────────────────────────────────────────┘  │    │
│  └───────────────────────────────────────────────┘    │
│                                                       │
│  ┌───────────────────────────────────────────────┐    │
│  │         Update Flow (UPDATED)                  │    │
│  │  1. Skill Health Check (NEW)                   │    │
│  │  2. Drift Detection (existing)                 │    │
│  │  3. Reconciliation (existing)                  │    │
│  │  4. Full Regeneration (NEW - always runs)      │    │
│  └───────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────┘
```

---

## Out of Scope

- Auto-updating skill versions (npx skills@latest handles this)
- Skill marketplace/registry (separate initiative)
- Token cost tracking or billing integration
- Agent performance tracking (agent-performance.json -- future work)
- Custom memory storage backends (uses Claude's built-in MEMORY.md system)
