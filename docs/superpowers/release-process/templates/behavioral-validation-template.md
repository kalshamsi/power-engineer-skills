<!-- Replace <X.Y.Z>, <feature-name>, and bracketed placeholders before use. Optional template — only use for releases requiring runtime behavioral validation beyond structural lint. -->

# v<X.Y.Z> Behavioral Validation — <feature-name>

**Context:** `<one paragraph: why behavioral validation was performed for this release; what structural tests already exist; why the runtime check adds independent signal>`.

This doc records `<one-shot manual / scheduled / pre-release>` runtime verification that the `<module / skill / agent>` produces the expected behavior when invoked by Claude (not by a mechanical runner).

## Method

Validation is performed via `claude --bare -p` invocation `<per fixture / per scenario>` with:

- `--bare` — disables CLAUDE.md auto-discovery, auto-memory, hooks, plugin sync (gives a clean baseline)
- `--add-dir <module-path>` — makes `<module file(s)>` readable to the invocation
- `--disallowedTools '<glob blocking the answer key>'` — prevents the invocation from reading the expected output and trivially echoing it
- `--model <pinned-model-id>` — pinned for reproducibility (e.g. `claude-sonnet-4-6`)
- `ANTHROPIC_API_KEY` from environment (required by `--bare`)

Prompt (identical across all `<N>` `<fixtures / scenarios>`):

> `<paste the verbatim prompt here. The prompt should be deterministic — describe the input,
> describe the expected output format precisely, and forbid extraneous output. State explicitly
> what to do, what NOT to do, and the format of each output line.>`
>
> `<example output format spec, if applicable:>`
> `<kind-1>: <value>`
> `<kind-2>: <value>`
> `<flag-N>: true`
>
> `<list of valid output kinds. Forbid invention. Forbid guessing.>`

Output is diffed against each `<fixture / scenario>`'s expected output after `<any normalization step — strip prefixes, sort, lowercase, etc.>`.

## Results

Run date: `<YYYY-MM-DD>`
Model: `<pinned-model-id>`
Invocation: `<exact command or script path>`

| `<Fixture / Scenario>` | Expected behavior | Actual behavior | PASS / FAIL | Evidence |
|---|---|---|---|---|
| `<name-1>` | `<expected output, abbreviated if long>` | `<actual output, abbreviated; "same" if identical>` | `<PASS / FAIL>` | `<link or path to full transcript>` |
| `<name-2>` | `<expected>` | `<actual>` | `<PASS / FAIL>` | `<link or path>` |
| `<name-3>` | `<expected>` | `<actual>` | `<PASS / FAIL>` | `<link or path>` |
| `<name-4>` | `<expected>` | `<actual>` | `<PASS / FAIL>` | `<link or path>` |
| `<name-5>` | `<expected>` | `<actual>` | `<PASS / FAIL>` | `<link or path>` |

**Score: `<N>`/`<N>` PASS.**

`<one-paragraph commentary on results — flag anything noteworthy, any near-misses, any failures and their disposition (fix / accept / defer)>`.

## Limitations

What this validation does NOT prove:

- **Manual one-shot, not wired into CI** — `<rationale; e.g., "per plan's explicit deferral; cost + model variance don't justify CI inclusion">`. A passing validation today does not guarantee a passing validation on a different day.
- **Model variance** — another run on a different day, another `<model family>` version, or an updated prompt cache may produce different output. Re-run before each release if continued confidence is required.
- **Training-data contamination** — the model has general knowledge about `<the domain being tested>` that cannot be fully isolated from the module's behavior. A correct output may reflect general knowledge rather than the module's instructions.
- **Cost** — `~$<low>–<high>` per `<N>`-`<fixture / scenario>` run on `<model>` (as of `<YYYY-MM-DD>`). Validation is intentionally one-shot, not continuous.
- **`--bare` requires `ANTHROPIC_API_KEY`** — disables OAuth / keychain auth flows; the validation script cannot be run by a maintainer who only has interactive auth configured.
- **Production environment differences** — the validation runs in `--bare` mode, which differs from production Claude Code sessions (no hooks, no memory, no plugins). Behavior in a real session may differ from behavior in the validation harness.
- **`<any other limitation specific to this release>`**

## Reproducing

Step-by-step instructions for re-running the validation:

1. **Install prerequisites:**
   ```bash
   # Confirm claude CLI version supports --bare
   claude --version
   # Confirm ANTHROPIC_API_KEY is set
   test -n "$ANTHROPIC_API_KEY" && echo "key present" || echo "MISSING — set it"
   ```

2. **Check out the release tag:**
   ```bash
   git checkout v<X.Y.Z>
   ```

3. **Run the validation script:**
   ```bash
   bash scripts/<validation-script-name>.sh
   ```

   Or, to run a single `<fixture / scenario>`:

   ```bash
   bash scripts/<validation-script-name>.sh --only <fixture-name>
   ```

4. **Inspect transcripts:**
   ```bash
   ls -la <output-directory>/
   ```

   Each transcript contains the full `claude --bare -p` invocation, the model output, and the diff against expected.

5. **Compare against this doc:**

   The script writes a results summary that should match the table in the [Results](#results) section above. If it does not match, either the module changed (update the doc), the expected outputs changed (update the fixtures), or model variance occurred (re-run; if persistent, investigate).

## Relationship to structural tests

Behavioral validation **complements** but does not **replace** the structural lint suite:

- **Structural** (`<lint script path; e.g., tests/lint/scanner-rules.sh>`): verifies `<what the structural test proves; e.g., "YAML rules apply mechanically against fixtures">`. Runs in CI on every PR. Fast, deterministic, free. **Proves the rules / module structure is correct.**
- **Behavioral** (this doc + the script in `Reproducing` above): verifies that Claude applying the module produces the same output as the mechanical runner. Manual-only. Slow, model-variant, paid. **Proves the module is interpretable as intended by an LLM.**
- **End-to-end** (not done here): a user running `<the actual user-facing trigger>` in a fresh Claude Code session against a real project. Not automated; out of scope.

The structural tests catch regressions in the module's shape; the behavioral validation catches regressions in the module's *meaning* — places where the docs are technically valid but mislead the model. Both are necessary; neither is sufficient alone.

**When to re-run behavioral validation:**
- Before tagging a new release that touches the validated module
- After any non-trivial wording change to the module
- When updating the pinned model version
- Never as part of routine CI (cost, variance, and dependency on `ANTHROPIC_API_KEY` make it unsuitable)
