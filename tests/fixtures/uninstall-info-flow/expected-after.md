# Expected: uninstall-info-flow

Post-execution state for each scenario in `EXEC.md`. Each scenario starts
from a fresh copy of `initial-state.json` + `synthetic-skill/SKILL.md` (the
scenarios are independent; do not chain them).

The "scope" field in `initial-state.json` is `project` for every entry, so
the on-disk directory referenced by each entry is
`.claude/skills/<name>/`.

---

## Scenario (a) — `power engineer uninstall synthetic-skill` (ambiguous)

**Trigger:** bare-name uninstall against a name that has 2 entries
(`synthetic-skill` from `repo-a` and `synthetic-skill` from `repo-b`).

**Expected flow path:** `uninstall.md` Step 2 -> "2+ matches (bare name only)"
disambiguation prompt -> Step 3 (locate disk dir) -> Step 4 (confirm + execute)
-> Step 5 (regenerate configurator outputs).

**AskUserQuestion responses (assume the runner picks the first option each
time):**
1. Disambiguation: "synthetic-skill (test-fixtures/repo-a)"
2. Confirm: "Yes, uninstall"

**Expected post-state:**

- `state.json` `installed_skills[]` count: **3** (was 4).
- The dropped entry is the one with `name == "synthetic-skill" && repo ==
  "test-fixtures/repo-a"`. The `repo-b` entry of the same name is **still
  present**.
- `state.json` `updated` timestamp is bumped to the current ISO date.
- On disk: `.claude/skills/synthetic-skill/` is **deleted**.
- The remaining `synthetic-skill (test-fixtures/repo-b)` entry is now
  orphaned in state (its disk dir was just deleted) — this is expected; a
  follow-up uninstall against that entry would hit the stale-state path
  defined in `uninstall.md` Step 3.

**jq assertion:**
```bash
jq '.installed_skills | length' state.json   # -> 3
jq '[.installed_skills[] | select(.name == "synthetic-skill" and .repo == "test-fixtures/repo-a")] | length' state.json   # -> 0
jq '[.installed_skills[] | select(.name == "synthetic-skill" and .repo == "test-fixtures/repo-b")] | length' state.json   # -> 1
```

---

## Scenario (b) — `power engineer uninstall synthetic-skill-orphan` (orphan)

**Trigger:** bare-name uninstall against an entry whose disk directory does
not exist in the fixture (the fixture deliberately does not ship a
`synthetic-skill-orphan/` directory).

**Expected flow path:** `uninstall.md` Step 2 -> "1 match" -> Step 3
(pre-removal check) detects stale state (entry exists, dir missing) and
prompts via AskUserQuestion -> on "Drop entry from state.json", skip Step 4's
disk delete and proceed directly to the state.json update + Step 5
configurator regen.

**AskUserQuestion responses:**
1. Stale-state prompt: "Drop entry from state.json"

**Expected post-state:**

- `state.json` `installed_skills[]` count: **3** (was 4).
- The dropped entry is the one with `name == "synthetic-skill-orphan"`.
- `state.json` `updated` timestamp is bumped to the current ISO date.
- On disk: nothing changes (the directory was already absent).

**jq assertion:**
```bash
jq '.installed_skills | length' state.json   # -> 3
jq '[.installed_skills[] | select(.name == "synthetic-skill-orphan")] | length' state.json   # -> 0
```

---

## Scenario (c) — `power engineer uninstall synthetic-skill-healthy` (happy path)

**Trigger:** bare-name uninstall against an entry whose disk directory
**does** exist. The fixture's `synthetic-skill/SKILL.md` is copied to
`.claude/skills/synthetic-skill-healthy/SKILL.md` during EXEC step 1
(setup) so this entry has both a state row and a real on-disk target.

**Expected flow path:** `uninstall.md` Step 2 -> "1 match" -> Step 3
(directory exists -> no stale prompt) -> Step 4 (confirm + execute disk
delete + state.json update) -> Step 5 (configurator regen).

**AskUserQuestion responses:**
1. Confirm: "Yes, uninstall"

**Expected post-state:**

- `state.json` `installed_skills[]` count: **3** (was 4).
- The dropped entry is the one with `name == "synthetic-skill-healthy"`.
- `state.json` `updated` timestamp is bumped to the current ISO date.
- On disk: `.claude/skills/synthetic-skill-healthy/` is **deleted**.

**jq assertion:**
```bash
jq '.installed_skills | length' state.json   # -> 3
jq '[.installed_skills[] | select(.name == "synthetic-skill-healthy")] | length' state.json   # -> 0
test ! -d .claude/skills/synthetic-skill-healthy   # exits 0
```

---

## Scenario (d) — `power engineer info synthetic-skill-healthy` (info render)

**Trigger:** info request for an installed skill whose disk dir + SKILL.md
exist (same setup as scenario (c) — copy `synthetic-skill/SKILL.md` to
`.claude/skills/synthetic-skill-healthy/SKILL.md` before the info call).

**Expected flow path:** `info.md` Step 1 (state + catalog check) -> Step 2
"1 state match" -> Step 3 (render output, plain text). No state, disk, or
configurator writes.

**AskUserQuestion responses:** none — info is non-interactive.

**Expected output structure** (per `info.md` Step 3 layout):

The output MUST include all four sections in this exact order:

1. **Header line** — `synthetic-skill-healthy (test-fixtures/repo-a)`
2. **Path + Installed lines** — `Path: .claude/skills/synthetic-skill-healthy/`
   and `Installed: 2026-04-28 by power-engineer`
3. **Description section** — text from `synthetic-skill/SKILL.md`
   frontmatter `description` field (the same SKILL.md is shared by the
   healthy entry's on-disk dir per EXEC step 1)
4. **Catalog metadata section** — Category line. Because
   `synthetic-skill-healthy` is not in the real catalog, this entry MUST
   render as `Category: (not in catalog)` with the `Related` and `Install
   command` lines omitted (per `info.md` error-table row "State entry
   exists but no catalog row").
5. **Health line** — `Health: ✓ Healthy` (state entry present, dir exists,
   SKILL.md parseable). The "Suggested action" line MUST be omitted on
   healthy.

**Pass criteria:**
- All four sections present in the order above.
- No state.json mutation (compare `md5sum state.json` before/after).
- No disk mutation (the `.claude/skills/synthetic-skill-healthy/` directory
  is unchanged).
- No configurator regen (`CLAUDE.md` and cheatsheet untouched).

**Fail criteria:**
- Any section missing or out of order.
- Any state, disk, or configurator file modified.
- Health rendered as anything other than `✓ Healthy`.

---

## Pass / Fail summary

| Scenario | Pass condition |
|---|---|
| (a) ambiguous uninstall | state.json drops 1 of 2 same-name entries; correct repo dropped; disk dir deleted |
| (b) orphan uninstall | state.json drops the orphan entry; no disk operation |
| (c) happy-path uninstall | state.json drops the entry; disk dir deleted |
| (d) info render | All 4 output sections present and ordered correctly; zero side effects |

PASS = all 4 scenarios match. FAIL = any divergence.
