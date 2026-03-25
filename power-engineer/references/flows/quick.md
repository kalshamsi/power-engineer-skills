# Quick Setup Flow

Auto-detect the project stack from config files, ask only what can't be
inferred, confirm with the user, then generate the full install.

## Step 1 — Auto-detect stack

Check for these files in the current directory to infer the project stack:

| File | Infers |
|------|--------|
| `package.json` | Node.js/TypeScript project |
| `tsconfig.json` | TypeScript |
| `pyproject.toml` or `requirements.txt` | Python |
| `next.config.*` | Next.js framework |
| `nuxt.config.*` | Nuxt/Vue framework |
| `vite.config.*` | Vite (likely Vue or React) |
| `app.json` or `expo` in package.json | Expo / React Native |
| `*.xcodeproj` or `Package.swift` | SwiftUI / iOS |
| `Dockerfile` | Docker/DevOps |
| `terraform/` or `*.tf` | Terraform |
| `.github/workflows/` | CI/CD |
| `docker-compose.yml` | Container orchestration |

Also check `package.json` dependencies for:
- `next` -> Next.js
- `react` -> React
- `vue` -> Vue
- `@anthropic-ai/sdk` -> Anthropic JS SDK
- `ai` (vercel) -> Vercel AI SDK
- `expo` -> Expo

Check `pyproject.toml` / `requirements.txt` for:
- `anthropic` -> Anthropic Python SDK
- `fastapi` / `flask` / `django` -> Python web framework

## Step 2 — Present detection and ask remaining questions

Present what was detected, then ask only the questions that couldn't be
inferred. Typically these are:
- Design needs (Full / Standard / Minimal / None)
- Documentation needs (Full / Technical / None)
- Project phase (Greenfield / Active / Refactoring / Research)

## Step 3 — Detect installed skills

```bash
echo "=== GLOBAL ===" && ls ~/.claude/skills/ 2>/dev/null || echo "(none)"
echo "=== LOCAL ===" && ls .claude/skills/ 2>/dev/null || echo "(none)"
```

## Step 4 — Build skill lists

Read `references/DECISION_MATRIX.md` and map the detected + answered values
to skill install commands, the same way the full interview does. Start with
core methodology, then layer on skills per detection. De-duplicate and filter
against already-installed skills.

## Step 5 — Confirm with user

Present the planned skill list grouped by category before generating. Ask
the user to confirm or adjust.

## Step 6 — Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
