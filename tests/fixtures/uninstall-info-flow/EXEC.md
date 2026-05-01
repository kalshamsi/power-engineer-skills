# EXEC: uninstall-info-flow

Manual reproduction steps for the v1.4.2 uninstall + info flow fixture. Each
scenario starts from a clean copy of the fixture; **do not chain scenarios**
— the post-state of one scenario is not the pre-state of the next.

This is a manual harness. There is no automated runner; the fixture exists
to give a maintainer a deterministic checklist to walk during the Phase 3
release ceremony.

---

## Step 0 — Prerequisites

- A throwaway working directory (the steps below assume `$FIX_TMP`):
  ```bash
  FIX_TMP="$(mktemp -d -t pe-fixture-XXXXXX)"
  ```
- The repo's `power-engineer/` directory must be available so the flows
  under test can be invoked. Either run from a clone of this repo or copy
  `power-engineer/` into `$FIX_TMP` so `.claude/skills/power-engineer/`
  resolves.
- `jq` available on `PATH` (used for state.json assertions).

---

## Step 1 — Set up the fixture working tree

For each scenario you run, start by copying the fixture into a fresh
subdirectory of `$FIX_TMP`:

```bash
SCENARIO_DIR="$FIX_TMP/scenario-$(date +%s)"
mkdir -p "$SCENARIO_DIR/.power-engineer" \
         "$SCENARIO_DIR/.claude/skills"

# Copy the seeded state.json to the project's state location.
cp tests/fixtures/uninstall-info-flow/initial-state.json \
   "$SCENARIO_DIR/.power-engineer/state.json"

# Place the synthetic skill on disk for the entries whose state rows reference
# a real install. Both the ambiguous "synthetic-skill" name and the
# "synthetic-skill-healthy" entry need a SKILL.md so the flows see a healthy
# directory. The "synthetic-skill-orphan" entry deliberately gets NO disk
# directory — that is what makes it the orphan/stale-state case.
mkdir -p "$SCENARIO_DIR/.claude/skills/synthetic-skill" \
         "$SCENARIO_DIR/.claude/skills/synthetic-skill-healthy"
cp tests/fixtures/uninstall-info-flow/synthetic-skill/SKILL.md \
   "$SCENARIO_DIR/.claude/skills/synthetic-skill/SKILL.md"
cp tests/fixtures/uninstall-info-flow/synthetic-skill/SKILL.md \
   "$SCENARIO_DIR/.claude/skills/synthetic-skill-healthy/SKILL.md"

cd "$SCENARIO_DIR"
```

Verify setup before running the flow:

```bash
jq '.installed_skills | length' .power-engineer/state.json   # -> 4
ls .claude/skills/                                           # synthetic-skill  synthetic-skill-healthy
test ! -d .claude/skills/synthetic-skill-orphan && echo "orphan absent OK"
```

---

## Step 2 — Scenario (a): ambiguous uninstall

```
power engineer uninstall synthetic-skill
```

Expected interaction:
1. **Disambiguation** AskUserQuestion fires (uninstall.md Step 2,
   "2+ matches"). Pick **`synthetic-skill (test-fixtures/repo-a)`**.
2. **Confirm** AskUserQuestion fires (uninstall.md Step 4). Pick
   **`Yes, uninstall`**.
3. Configurator regen runs (Step 5).

Then verify against `expected-after.md` scenario (a):

```bash
jq '.installed_skills | length' .power-engineer/state.json   # -> 3
jq '[.installed_skills[] | select(.name=="synthetic-skill" and .repo=="test-fixtures/repo-a")] | length' \
   .power-engineer/state.json                                # -> 0
jq '[.installed_skills[] | select(.name=="synthetic-skill" and .repo=="test-fixtures/repo-b")] | length' \
   .power-engineer/state.json                                # -> 1
test ! -d .claude/skills/synthetic-skill && echo "(a) PASS"
```

If any check fails, scenario (a) FAILS. Capture the diff between
`.power-engineer/state.json` and `tests/fixtures/uninstall-info-flow/initial-state.json`
in your report.

---

## Step 3 — Scenario (b): orphan / stale-state uninstall

Re-run Step 1 in a fresh `$SCENARIO_DIR`. Then:

```
power engineer uninstall synthetic-skill-orphan
```

Expected interaction:
1. **Stale-state** AskUserQuestion fires (uninstall.md Step 3 — entry
   exists, dir missing). Pick **`Drop entry from state.json`**.
2. No "Confirm" prompt is needed (no disk delete).
3. Configurator regen runs.

Verify:

```bash
jq '.installed_skills | length' .power-engineer/state.json   # -> 3
jq '[.installed_skills[] | select(.name=="synthetic-skill-orphan")] | length' \
   .power-engineer/state.json                                # -> 0
ls .claude/skills/                                           # unchanged: synthetic-skill, synthetic-skill-healthy
echo "(b) PASS if all three checks held"
```

---

## Step 4 — Scenario (c): happy-path uninstall

Re-run Step 1 in a fresh `$SCENARIO_DIR`. Then:

```
power engineer uninstall synthetic-skill-healthy
```

Expected interaction:
1. **Confirm** AskUserQuestion fires (uninstall.md Step 4). Pick
   **`Yes, uninstall`**.
2. Configurator regen runs.

Verify:

```bash
jq '.installed_skills | length' .power-engineer/state.json   # -> 3
jq '[.installed_skills[] | select(.name=="synthetic-skill-healthy")] | length' \
   .power-engineer/state.json                                # -> 0
test ! -d .claude/skills/synthetic-skill-healthy && echo "(c) PASS"
```

---

## Step 5 — Scenario (d): info render

Re-run Step 1 in a fresh `$SCENARIO_DIR`. Then:

```
power engineer info synthetic-skill-healthy
```

Capture the rendered output (info is read-only — no prompts fire).

Verify against `expected-after.md` scenario (d). Pass criteria:
1. The output includes the **header**, **Path + Installed**,
   **Description**, **Catalog metadata** (with `Category: (not in catalog)`
   and the `Related`/`Install command` lines omitted), and **Health: ✓
   Healthy** sections, in that order.
2. No state mutation:
   ```bash
   diff -q .power-engineer/state.json \
           tests/fixtures/uninstall-info-flow/initial-state.json   # -> identical
   ```
3. No disk mutation:
   ```bash
   ls .claude/skills/                                              # synthetic-skill  synthetic-skill-healthy
   ```
4. The Health line is exactly `Health: ✓ Healthy`. No "Suggested action"
   line follows it.

If all four hold, scenario (d) PASS.

---

## Step 6 — Cleanup

```bash
rm -rf "$FIX_TMP"
```

---

## Pass / Fail roll-up

The fixture passes only when **all four scenarios pass**. Report each
scenario's status individually so a partial regression is visible. A single
failing scenario is a release blocker for v1.4.2 acceptance criteria 1
(uninstall) or 2 (info), depending on which scenario broke.
