# Expected: nextjs-supabase

## Scanner MUST detect

- **DETECT**: language: typescript
- **DETECT**: framework: next.js
- **DETECT**: cloud_db: supabase
- **DETECT**: has_tailwind: true

## Questions that should be SKIPPED (auto-detected)

- Primary language
- Framework
- Database provider
- Styling approach

## Skills that MUST be recommended

- vercel-labs/next-skills (Next.js patterns)
- next/supabase skills (Supabase integration)
- playwright (testing — devDependency detected)
- shadcn-ui or tailwind-design-system
- security-review (standard tier default)

## Skills that MUST NOT be recommended

- Vue / Vite / Nuxt
- Python / FastAPI / Django
- Mobile / React Native / SwiftUI
