# Subagent Selector Module

## Overview

Reference for model-selection when dispatching subagents. Before this module existed, orchestrators chose models ad-hoc, producing inconsistent cost/quality tradeoffs across releases. This module formalises the decision as a 3-axis lookup driven by `state.json.preferences.subagent_model_mode`: the orchestrator reads that field first, then either consults the decision table below (`"selector"` mode), uses a forced model (`"force-*"` modes), skips guidance entirely (`"none"` mode), or falls back gracefully when the field is absent or the file is unreadable.

## Modes

The `subagent_model_mode` preference in `state.json` accepts exactly five values:

| Value | Behavior | When to choose |
|---|---|---|
| `"selector"` | Consult the decision table below using the task's (profile, risk, parallelism) tuple. **This is the default.** | Most projects — balances cost and correctness automatically. |
| `"force-opus"` | Use Opus for every subagent dispatch, ignoring the table. Maximum reasoning, highest cost. | When correctness is paramount and budget is not a constraint. |
| `"force-sonnet"` | Use Sonnet for every subagent dispatch, ignoring the table. Fast and accurate for mechanical work, cost-efficient. | When the workload is predominantly mechanical and a flat policy is preferred. |
| `"force-haiku"` | Use Haiku for every subagent dispatch, ignoring the table. Cheapest tier. | Only safe when all tasks are simple enough for Haiku to handle reliably. |
| `"none"` | No guidance consulted. Orchestrator picks ad-hoc; defaults to Opus for safety. | Not recommended — reverts to pre-v1.4.0 ad-hoc behaviour. |

**Default when `subagent_model_mode` is skipped or unset:** `"selector"`.

## Decision Table (selector mode)

Each dispatch is characterised by three axes:

- **Task profile:** `mechanical` (structured edits, scripting, catalog rows) | `judgment` (design decisions, prose authoring, risky refactors) | `audit` (per-task verification of another Dev's work) | `remediation` (fixing audit findings) | `research` (information-gathering with no code changes)
- **Risk:** `low` (reversible, localised blast radius) | `high` (irreversible OR wide blast radius — hooks, settings.json, release ceremony, production pushes)
- **Parallelism:** `single` (one dispatch at a time) | `parallel fan-out` (N independent dispatches in one message)

| Task profile | Low-risk single | High-risk single | Low-risk parallel fan-out |
|---|---|---|---|
| Mechanical | Sonnet | Sonnet | Sonnet ×N parallel |
| Judgment | Sonnet | Opus | — (judgment rarely fans out) |
| Audit | Opus | Opus | — (audit is serial by design) |
| Remediation | Opus | Opus | — (remediation is serial) |
| Research | Sonnet | Sonnet | — (research is serial) |

"Sonnet ×N parallel" means N parallel Sonnet dispatches (see `superpowers:dispatching-parallel-agents` Template F for mechanics). An em-dash "—" means the profile+parallelism combination is rare or not recommended; use single-dispatch instead.

## Cost Footnote

When cost is the primary constraint, downgrade from the table's recommendation by one tier — Opus becomes Sonnet, Sonnet becomes Haiku — acknowledging that quality may be reduced at the lower tier. Haiku is **never** appropriate for audit or remediation tasks, where incorrect output can introduce undetected defects or missed findings. The `"force-*"` modes override the decision table entirely for users who prefer a flat policy regardless of per-task profile.

## Fallback Contract

The following degradation rules apply when this module or `state.json` is unavailable:

- **Module file unreadable** — orchestrator defaults to Opus for all dispatches (safest, matches v1.3.0 behaviour).
- **`state.json` missing or `subagent_model_mode` field absent** — default to `"selector"` mode, then consult this decision table normally.
- **`state.json` present but mode value is unrecognised** — treat as `"none"` (orchestrator defaults to Opus).
- **All fallback events** are logged to `.power-engineer/memory-errors.log` for visibility.

## Examples

- **Adding 7 catalog rows (mechanical, low-risk, single)** → Sonnet
- **Auditing a hook-surface task (audit, high-risk, single)** → Opus
- **Fan-out of 5 parallel catalog-row adds (mechanical, low-risk, parallel)** → Sonnet ×5 parallel
- **Remediating a dual-auditor ISSUES FOUND (remediation, high-risk, single)** → Opus

## How the orchestrator reads this

Before dispatching ANY subagent, the orchestrator:

1. Reads `.power-engineer/state.json` to get `preferences.subagent_model_mode`.
2. Branches on the value:
   - `"selector"` → consults the decision table above with the task's (profile, risk, parallelism) tuple
   - `"force-opus"` | `"force-sonnet"` | `"force-haiku"` → uses that model for every dispatch; ignores the table
   - `"none"` → no guidance; orchestrator defaults to Opus for safety
3. Records the chosen model + rationale in the subagent dispatch prompt so downstream review can audit model-selection decisions.

If `state.json` is unreadable or missing the field, defaults to `"selector"`. If this module file is unreadable, defaults to Opus (safest).
