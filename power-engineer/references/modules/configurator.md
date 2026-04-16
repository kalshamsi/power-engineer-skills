# Configurator Module

Post-installation project configuration. Creates state directory, generates
or merges CLAUDE.md, and patches installed skills with project context.

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

## Step 1: Create .power-engineer/ state directory

```bash
mkdir -p .power-engineer
```

### state.json

Write `.power-engineer/state.json`:

```json
{
  "version": "2.0",
  "created": "[ISO date]",
  "updated": "[ISO date]",
  "project": {
    "name": "[directory name]",
    "language": "[from SkillPlan]",
    "framework": "[from SkillPlan]",
    "sdks": [],
    "cloud_database": [],
    "team_size": 0,
    "is_monorepo": false
  },
  "questionnaire_answers": {
    "project_type": "[Q1]",
    "design_needs": "[Q4]",
    "documentation": "[Q5]",
    "research_data": "[Q6]",
    "project_phase": "[Q8]",
    "brand_identity": "[Q9]",
    "team_workflow": "[Q10]",
    "goals": "[Q11]",
    "security_needs": "[Q12]",
    "cross_tool_usage": "[Q13]"
  },
  "installed_skills": [
    {
      "name": "[skill-name]",
      "repo": "[user/repo]",
      "installed_at": "[ISO date]",
      "installed_by": "power-engineer"
    }
  ],
  "scan_snapshot": {
    "source_file_count": 0,
    "package_json_hash": "[first 8 chars of md5]",
    "dependency_count": 0
  },
  "preferences": {
    "security_level": "standard",
    "auto_update": true,
    "skills_cli_version": "1.2.3",
    "subagent_model_mode": "selector"
  }

}
```

**Setting `security_level` from Q12 answer:**

Map the Q12 security needs answer to a security level preference:

| Q12 answer | security_level |
|------------|---------------|
| No additional security / default | `"standard"` |
| Any single speciality (SAST/DAST, Container & IaC, etc.) | `"enhanced"` |
| Multiple specialities selected | `"maximum"` |
| Compliance selected | `"compliance"` |
| Custom selection | `"custom"` |

If Q12 was not asked (skipped), default to `"standard"`.

**`subagent_model_mode`** — Policy governing how the orchestrator selects models when dispatching subagents.

- Allowed values: `"selector"` (default) · `"force-opus"` · `"force-sonnet"` · `"force-haiku"` · `"none"`
- Set at project instantiation via Q14 (see `questionnaire.md`).
- Editable via `/power-engineer configure`.
- Consumed by `subagent-selector.md` fallback contract: missing or unreadable → orchestrator defaults to Opus (safe).

### brand.md

Write `.power-engineer/brand.md` (only if brand information was collected):

```markdown
---
name: [project name]
colors:
  primary: "[hex]"
  secondary: "[hex]"
  accent: "[hex]"
fonts:
  heading: "[font name]"
  body: "[font name]"
logo: "[path to logo file or null]"
---

# Brand Identity

[Human-readable brand description based on detected tokens and user answers]

## Color Palette
[Extracted from tailwind.config or CSS custom properties]

## Typography
[Extracted from font configurations]

## Design Tokens
[Any additional design tokens detected]
```

### project-context.md

Write `.power-engineer/project-context.md`:

```markdown
# Project Context

## Goals
[From Q11 answers]

## Team
[From Q10 answers + git log team size]

## Conventions
[Detected from codebase: naming patterns, directory structure, test patterns]

## Architecture
[Detected: monorepo?, services, deployment targets]
```

### drift-history.json

Write `.power-engineer/drift-history.json`:

```json
{
  "runs": [
    {
      "date": "[ISO date]",
      "type": "initial-setup",
      "skills_installed": 0,
      "skills_skipped": 0,
      "skills_failed": 0
    }
  ]
}
```

### agent-performance.json

Write `.power-engineer/agent-performance.json`:

```json
{
  "agents": [],
  "tracking_started": "[ISO date]"
}
```

## Step 2: CLAUDE.md generation / smart merge

### If no CLAUDE.md exists

Create a new CLAUDE.md with full project context:

```markdown
# CLAUDE.md

## Project Overview
[Project name] is a [framework] project using [language].

## Tech Stack
- Language: [language]
- Framework: [framework]
- Database: [cloud_database]
- SDKs: [sdks list]

## Conventions
[Detected conventions from codebase]

## Power Engineer
<!-- power-engineer:managed-section -->

### Behavioral Rules
- **Universal AskUserQuestion enforcement**: Every question directed at the user MUST use the `AskUserQuestion` tool. This applies to ALL contexts — skill invocations, general conversation, debugging sessions, code reviews, clarifications, confirmations, and any other interaction where user input is needed. Never ask questions as plain text in a response. The only exception is rhetorical questions in explanations (e.g., "Why does this matter?" followed by the answer in the same message).

### Proactive Memory Management
- After every interaction where the user shares new factual information about the project, preferences, or decisions, save it to Claude Code's project memory (MEMORY.md at `~/.claude/projects/`) using proper frontmatter (type: user/project/feedback/reference) without prompting the user.
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
  - **User profile** (user's role, expertise level, goals, responsibilities) → `user` type
- Before saving a new memory, check MEMORY.md index for existing entries on the same topic. Update existing memories rather than creating duplicates.
- Context restoration at session start is handled by Session Orchestration (below). These rules focus on saving.

### Context Management
- **Proactive compaction**: Monitor conversation length. When context usage reaches approximately 60%, proactively save working state to memory and run `/compact`. Do not wait for the system to auto-compact. This is a best-effort heuristic — Claude Code does not expose a precise token counter.
- **Pre-compaction save**: Before compacting, save to memory: what you're working on, decisions made so far, files modified, next steps planned.
- **Post-compaction restore**: After compaction, immediately re-read `.power-engineer/project-context.md`, `.power-engineer/brand.md`, `.power-engineer/state.json`, and MEMORY.md to restore full project awareness.
- **Token-aware progressive loading**: Load project context in priority order:
  - Always load: CLAUDE.md rules, installed skills list, current task context
  - On demand (mid-session): Detailed brand tokens (only for design work), deployment details (only when deploying), integration details (only when touching integrations). Note: session start loads brand.md for baseline awareness; this rule applies to deep-diving into specific .power-engineer/ files mid-session
  - Read `.power-engineer/` files relevant to the current task, not all of them

### Session Orchestration
- **Session start protocol**: At the beginning of every session, read: MEMORY.md index, `.power-engineer/project-context.md`, `.power-engineer/brand.md`, installed skills list from state.json. Establish baseline awareness before any work begins.
- **Session end protocol**: Before ending a session (when the user wraps up or explicitly ends), save to memory: what was accomplished, decisions made, unfinished work, and next steps. Use the `project` memory type with a descriptive name like `session_handoff_YYYY-MM-DD`. Follow the handoff template structure from `.power-engineer/handoff-template.md`.
- **Subagent context passing**: When spawning subagents (via Agent tool or dispatching-parallel-agents), include in the prompt: relevant project context from `.power-engineer/project-context.md`, brand details if the task involves design, and relevant MEMORY.md entries. Subagents must also follow AskUserQuestion enforcement.
- **Subagent result capture**: When a subagent completes, evaluate its results for memory-worthy information and save to MEMORY.md if applicable.

### Installed Skills
[List of installed skills with brief descriptions]

### Brand Context
[Reference to .power-engineer/brand.md if exists]

### Project Goals
[From Q11 answers]

### Team Workflow
[From Q10 answers]

<!-- /power-engineer:managed-section -->
```

### If CLAUDE.md already exists

1. Read the existing CLAUDE.md completely
2. Search for `<!-- power-engineer:managed-section -->`
3. If found: replace everything between the opening and closing delimiters
4. If not found: append the `## Power Engineer` section at the end
5. **NEVER modify any content outside the managed section**

## Step 3: Skill patching with Project Context

For each installed skill where project context is materially useful, append
a `## Project Context` section.

### Which skills to patch

| Skill category | Patch with |
|---------------|------------|
| Design skills (frontend-design, tailwind-design-system, shadcn, etc.) | Brand tokens, color palette, typography |
| Backend skills (api-design-principles, nodejs-backend-patterns, etc.) | API conventions, naming patterns, database schema patterns |
| Testing skills (tdd, test-driven-development, backend-testing, etc.) | Test directory structure, test naming patterns, test runner config |
| Documentation skills (technical-writing, api-documentation, etc.) | Project terminology, audience, documentation standards |

### Patching format

Append to the end of the skill's SKILL.md file:

```markdown
<!-- power-engineer:project-context -->
## Project Context

This project uses [framework] with [language].

[Category-specific context from the table above]

### Brand
[If design skill: include brand tokens from .power-engineer/brand.md]

### Conventions
[Relevant conventions for this skill category]
<!-- /power-engineer:project-context -->
```

### On re-run

When patching skills on re-run:
1. Search for `<!-- power-engineer:project-context -->`
2. If found: replace everything between the delimiters
3. If not found: append the section

## Step 4: .gitignore check

Check if `.power-engineer/` is in `.gitignore`:

```bash
grep -q '.power-engineer' .gitignore 2>/dev/null
```

If not present, use AskUserQuestion:

```
AskUserQuestion:
  question: "Should I add .power-engineer/ to your .gitignore?"
  header: "Gitignore"
  options:
    - label: "Yes, add it (Recommended)"
      description: "Keeps local state and install logs out of version control"
    - label: "No, leave .gitignore as-is"
      description: "The .power-engineer/ directory will be tracked by git"
  multiSelect: false
```

If the user selects "Yes", append to `.gitignore`:
```
# Power Engineer state
.power-engineer/
```

## Step 5: Inject lifecycle hooks

Inject Claude Code lifecycle hooks into `.claude/settings.json` using a **read-merge-write** strategy so existing settings are preserved. The configurator registers three hook events:

1. **`SessionStart`** with matcher `"compact"` — restores project context after `/compact` completes.
2. **`SessionEnd`** (no matcher) — automatically captures a session handoff summary as part of Power Engineer v1.4.0's 3-tier memory architecture (Tier 2: automation).
3. **`PreCompact`** (no matcher) — captures a pre-compact snapshot of session state immediately before compaction runs (Tier 3 supplement — context-crunch safety net).

Every registration follows the nested schema quoted below from the current official docs (see `docs/superpowers/plans/v1.4.0-hooks-research.md` for the verified shape and source URLs):

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "string|pattern|* (optional)",
        "hooks": [
          { "type": "command", "command": "path/to/script.sh" }
        ]
      }
    ]
  }
}
```

The outer `hooks` map keys event names to arrays of **matcher-group objects**. Each matcher-group has a `matcher` string (optional — omit or use `""`/`"*"` to match all) and a `hooks` array of handler objects with `type` + `command`. Flat shapes (`{type, command}` directly in the event array) are not documented and were the source of the v1.3.0 regression.

### SessionStart hook — post-compaction context restore

**Why `SessionStart`, not `PostToolUse`:** `PostToolUse` matchers filter by tool name (Bash, Edit, Write, etc.) — `"compact"` is not a tool and would never match. Compaction restarts the session, so `SessionStart` with matcher `"compact"` (one of the valid `source` values: `startup`, `resume`, `clear`, `compact`) is the correct event.

### Process

1. Read `.claude/settings.json` (if it exists). If it doesn't exist, start with `{}`
2. Ensure the `hooks` key exists (create empty object if missing)
3. Ensure `hooks.SessionStart` exists (create empty array if missing)
4. Search the `SessionStart` array for an entry with `"matcher": "compact"`
   - If found: update its `hooks` array to the latest version below
   - If not found: append the new entry to the array
5. Write back the full settings.json, preserving all existing keys (permissions, env, other hooks)

**NEVER overwrite the entire settings.json.** Only touch the specific hook entry.

### Hook entry

Each entry in the `SessionStart` array requires a `matcher` string (matching the session source) and a `hooks` array of `{type, command}` objects. This is the Claude Code hooks schema — do NOT put `command` directly on the matcher object.

```json
{
  "matcher": "compact",
  "hooks": [
    {
      "type": "command",
      "command": "echo '## Post-Compaction Context Restore\nRe-read the following files to restore project context:\n- .power-engineer/project-context.md\n- .power-engineer/brand.md\n- .power-engineer/state.json (installed skills)\n- Check MEMORY.md for recent project memories'"
    }
  ]
}
```

### On re-run

Same process — the read-merge-write strategy is idempotent. If the hook already exists, its command is updated to the latest version.

### SessionEnd hook — automatic session handoff

Register a `SessionEnd` hook that invokes `scripts/hooks/session-end-handoff.sh` to automatically capture a session handoff summary (git branch, last 5 commits, modified files, placeholder for next steps) to `.power-engineer/session-handoff-<UTC-timestamp>.md`. This is **Tier 2** of Power Engineer v1.4.0's 3-tier memory architecture:

- **Tier 1** (reliability): CLAUDE.md proactive memory rules — always runs, does not depend on hooks.
- **Tier 2** (automation): this SessionEnd hook — best-effort, fires when Claude Code's SessionEnd event triggers.
- **Tier 3** (explicit): `/power-engineer save-phase` flow — user-initiated checkpoint.

**Best-effort semantics (per `docs/superpowers/plans/v1.4.0-hooks-research.md`):** SessionEnd was introduced in Claude Code v1.0.85 but is known to **not fire on `/exit`** (GitHub issue [#17885](https://github.com/anthropics/claude-code/issues/17885), closed as "not planned") and **not fire on `/clear`** (issue [#6428](https://github.com/anthropics/claude-code/issues/6428), open with repro) despite the docs listing `"clear"` as a valid reason value. Treat SessionEnd as advisory; Tier 1 remains the primary reliability guarantee.

**Script location:** The hook script ships as a standalone file at `scripts/hooks/session-end-handoff.sh` in the `power-engineer-skills` repo (rather than as a heredoc inside this configurator module). Standalone scripts enable ShellCheck coverage (wired into CI in Phase 7 Task 7.3) and unit-testability. At install time, the configurator copies the script into the user's project at `.claude/hooks/session-end-handoff.sh` and ensures `chmod +x`; the registration `command` field points at the installed path. For the repo's own dogfood config (Phase 2 Task 2.7), the command may reference the in-repo path directly.

**Matcher choice:** The `matcher` field is **omitted** so the hook fires on every SessionEnd reason (`"clear"`, `"resume"`, `"logout"`, `"prompt_input_exit"`, `"bypass_permissions_disabled"`, `"other"`). The handoff script's job is to checkpoint the session regardless of exit path — filtering by reason would defeat the purpose. Research doc: "Omit the `matcher` field to catch all SessionEnd reasons."

**Registration shape** (nested `{matcher, hooks:[{type, command}]}` schema confirmed by research against `code.claude.com/docs/en/hooks`):

```json
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/scripts/hooks/session-end-handoff.sh",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

Using `$CLAUDE_PROJECT_DIR` (populated by Claude Code at hook invocation) makes the path portable. The 60-second timeout is well under the 600s default and ample for a handoff write.

**Fallback contract:** If the hook errors on invocation (non-zero exit from `mkdir -p`, write failure, missing permissions), the script routes diagnostics to `.power-engineer/memory-errors.log` with an ISO-8601 UTC timestamp, **then exits 0 anyway**. The SessionEnd event must never block session termination. Memory writes continue via the CLAUDE.md auto-memory rules (Tier 1) without interruption, and the user can still run `/power-engineer save-phase` (Tier 3) to capture a handoff explicitly.

### On re-run (SessionEnd)

Same read-merge-write pattern — if a `SessionEnd` entry already exists, update its inner `hooks` array to the latest version; otherwise append. Never replace the whole `settings.json`.

### PreCompact hook — pre-compaction state snapshot

Register a `PreCompact` hook that invokes `scripts/hooks/pre-compact-snapshot.sh` to capture a pre-compact snapshot of session state — timestamp (ISO-8601 UTC), current branch, last 10 commits, first 30 modified files from `git status --porcelain`, and an empty "Post-compact Notes" section for the user to fill in manually — written to `.power-engineer/pre-compact-<UTC-timestamp>.md`. The snapshot gives the user a reliable reference to pre-compact project state so they can restore context on post-compact resume.

**Relationship to the 3-tier memory architecture:** PreCompact is a **Tier 3 SUPPLEMENT**, not a replacement for SessionEnd (Tier 2) or the `/power-engineer save-phase` ceremony (Tier 3). It is the context-crunch safety net that fires *just before* compaction summarizes the conversation — complementing (not superseding) the other tiers with a cheap, always-on snapshot:

- **Tier 1** (reliability): CLAUDE.md proactive memory rules — always runs, does not depend on hooks.
- **Tier 2** (automation): SessionEnd hook — session-handoff on exit.
- **Tier 3** (explicit): `/power-engineer save-phase` flow — user-initiated checkpoint.
- **Tier 3 supplement**: this PreCompact hook — pre-compaction snapshot on compact.

**Research doc citation:** See `docs/superpowers/plans/v1.4.0-hooks-research.md` (PreCompact subsection) for the verified schema + firing semantics, sourced from `code.claude.com/docs/en/hooks` (2026-04-16). The research doc documents that **PreCompact hooks can BLOCK compaction by exiting with code 2** (CHANGELOG v2.1.105) or returning `{"decision": "block"}`. Our hook is **advisory only** — we NEVER want to block compaction. The script therefore exits 0 on every path (including ERR-trap and EXIT-trap branches). Blocking auto-compaction in a long session could cause context overflow errors, so we deliberately avoid that capability.

**Matcher choice:** The `matcher` field is **omitted** so the hook fires on both documented `trigger` values — `"manual"` (user explicitly ran `/compact`) and `"auto"` (automatic compaction from the context limit). The snapshot is useful in both cases; filtering would defeat the purpose.

**Registration shape** (nested `{matcher?, hooks:[{type, command, timeout}]}` schema confirmed by research against `code.claude.com/docs/en/hooks`):

```json
{
  "hooks": {
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/scripts/hooks/pre-compact-snapshot.sh",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

Using `$CLAUDE_PROJECT_DIR` (populated by Claude Code at hook invocation) makes the path portable. The 60-second timeout is well under the 600s default and ample for a snapshot write.

**Script location:** The hook script ships as a standalone file at `scripts/hooks/pre-compact-snapshot.sh` in the `power-engineer-skills` repo (same pattern as the SessionEnd handoff script — heredocs in this module are avoided for ShellCheck coverage + unit-testability). At install time, the configurator copies the script into the user's project at `.claude/hooks/pre-compact-snapshot.sh` and ensures `chmod +x`; the registration `command` field points at the installed path. For the repo's own dogfood config (Phase 2 Task 2.7), the command may reference the in-repo path directly.

**Fallback contract:** If the hook errors on invocation, output is redirected to `.power-engineer/memory-errors.log` with an ISO-8601 UTC timestamp. **The script always exits 0 to ensure compaction is never blocked** — exit code 2 would block per CHANGELOG v2.1.105, and a blocked auto-compact in a long session could overflow context. On snapshot failure, context restoration remains possible via CLAUDE.md auto-memory (Tier 1) and `/power-engineer save-phase` (Tier 3).

### On re-run (PreCompact)

Same read-merge-write pattern — if a `PreCompact` entry already exists, update its inner `hooks` array to the latest version; otherwise append. Never replace the whole `settings.json`.

## Step 6: Generate cheatsheet

Generate `.power-engineer/cheatsheet.md` as an offline reference for the
user's installed skills.

For each installed skill in `state.json`, look up its entry in the catalog
files under `references/catalog/` to get the `Trigger` and `When to use`
columns. Group the skills by their catalog category.

Write `.power-engineer/cheatsheet.md` in this format:

```markdown
# Power Engineer Cheatsheet

Generated: [ISO date]

## Core Methodology
| Trigger | When to use |
|---------|-------------|
| /brainstorming | Before starting any new feature or design |
| /writing-plans | After brainstorming, to break work into tasks |

## Security
| Trigger | When to use |
|---------|-------------|
| /security-review | When performing a security review on any codebase |

---
[N] skills installed. Run `power engineer help` to see this list in-session.
```

### Notes
- Only include skills, not MCP servers
- Only include skills from the `installed_skills` array in state.json
- Omit any category section that has no installed skills

### Error handling

If a skill in `state.json` cannot be found in any catalog file under
`references/catalog/`, do NOT silently skip it. Instead, include a warning
row in the cheatsheet:

```
| /skill-name | ⚠ Not found in catalog — may be manually installed or from a plugin |
```

This ensures the user sees all installed skills, even if metadata is unavailable.

## Step 7: Cross-tool config generation (conditional)

If the user answered Q13 with any AI coding tools other than "None", generate
corresponding config files that mirror the CLAUDE.md behavioral rules.

Only generate files for tools the user selected. Skip this step entirely if
Q13 was "None" or was auto-skipped.

| Q13 answer | File to generate | Format |
|------------|-----------------|--------|
| Cursor | `.cursorrules` | Cursor rules format — one rule per line, no markdown headers |
| GitHub Copilot | `.github/copilot-instructions.md` | Markdown — same structure as CLAUDE.md behavioral sections |
| Windsurf | `.windsurfrules` | Windsurf rules format — one rule per line, no markdown headers |

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

### On re-run

Overwrite the existing handoff-template.md with the latest version.
This file is a reference template, not user-editable content.

## Step 9: Present configuration summary

```
Project configured!

  CLAUDE.md:           [created | updated (merged Power Engineer section)]
  State directory:     .power-engineer/ created
  Skills patched:      [N] skills received project context
  Brand file:          [created | skipped (no brand info)]
  Cheatsheet:          .power-engineer/cheatsheet.md
  Lifecycle hooks:     .claude/settings.json (SessionStart + SessionEnd + PreCompact hooks injected)
  Cross-tool configs:  [list of generated files, or "skipped (no cross-tool usage)"]
  Handoff template:    .power-engineer/handoff-template.md

  State files:
    .power-engineer/state.json
    .power-engineer/brand.md
    .power-engineer/project-context.md
    .power-engineer/install-log.sh
    .power-engineer/drift-history.json
    .power-engineer/agent-performance.json
    .power-engineer/handoff-template.md
```
