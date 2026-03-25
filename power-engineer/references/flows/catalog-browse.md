# Catalog Browse Flow

Let the user explore the full skills catalog interactively without installing
anything.

## Step 1 — Show categories

Read `references/catalog/INDEX.md` and present the categories to the user:

1. Core & Planning
2. Anthropic Official
3. Engineering — Backend & Architecture
4. Engineering — DevOps & Infrastructure
5. Engineering — Data & ML
6. Engineering — Testing & Quality
7. Engineering — Agentic AI
8. Engineering — Security & Ops
9. Frontend — React / Next.js
10. Frontend — Vue / Vite
11. Frontend — Design Systems
12. Frontend — Mobile
13. Cloud — Azure
14. Cloud — Databases
15. Docs & Research
16. Power Suites

Ask which category they'd like to explore.

## Step 2 — Show category details

Read ONLY the catalog file matching their choice:

| Category | File to read |
|----------|-------------|
| Core & Planning | `references/catalog/core-methodology.md` |
| Anthropic Official | `references/catalog/anthropic-official.md` |
| Backend & Architecture | `references/catalog/engineering/backend-architecture.md` |
| DevOps & Infrastructure | `references/catalog/engineering/devops-infra.md` |
| Data & ML | `references/catalog/engineering/data-ml.md` |
| Testing & Quality | `references/catalog/engineering/testing-quality.md` |
| Agentic AI | `references/catalog/engineering/agentic-ai.md` |
| Security & Ops | `references/catalog/engineering/security-ops.md` |
| React / Next.js | `references/catalog/frontend/react-next.md` |
| Vue / Vite | `references/catalog/frontend/vue-vite.md` |
| Design Systems | `references/catalog/frontend/design-systems.md` |
| Mobile | `references/catalog/frontend/mobile.md` |
| Azure | `references/catalog/cloud/azure.md` |
| Databases | `references/catalog/cloud/databases.md` |
| Docs & Research | `references/catalog/docs-research.md` |
| Power Suites | `references/catalog/power-suites.md` |

Present the skills in that category with their descriptions and install
commands. Ask if they want to explore another category or are done.

## Step 3 — Repeat

Let the user explore as many categories as they want. When they're done,
ask if they'd like to install any of the skills they browsed — if so,
suggest running the appropriate targeted flow (e.g., `/power-engineer frontend`).
