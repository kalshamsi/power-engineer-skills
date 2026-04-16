# Expected: monorepo

## Scanner MUST detect

- **DETECT**: monorepo: true
- **DETECT**: language: typescript
- **DETECT**: language: python
- **DETECT**: framework: next.js
- **DETECT**: framework: fastapi
- **DETECT**: has_docker: true

## Critical behavior

- Scanner MUST detect BOTH languages (not just root package.json)
- Resolver MUST recommend skills for both stacks
- Cross-cutting skills (e.g. security) MUST be recommended once, not twice

## Skills that MUST be recommended

- Next.js skills (apps/web)
- Python backend skills (services/api)
- Docker skills
- Turborepo skills
- security-review (once)

## Skills that MUST NOT be recommended

- Mobile skills
- Any single-language-only recommendation that ignores the other side
