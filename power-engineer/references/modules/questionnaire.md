# Adaptive Questionnaire Module

Receives the ProjectProfile from the Scanner and constructs a dynamic interview.
Questions already answered by scan results are skipped. For blank/empty projects,
all questions are asked.

## How to determine which questions to ask

Check the ProjectProfile for each question. If the scan already provides a
confident answer, SKIP the question and show the user what was detected instead.

### Question skip rules

| Question | Skip if ProjectProfile shows |
|----------|----------------------------|
| Q1 Project type | `framework` is detected AND `language` is known |
| Q2 Language/stack | `language` is not "unknown" |
| Q3 Framework | `framework` is not "none" |
| Q4 Design needs | NEVER skip -- always ask (subjective preference) |
| Q5 Documentation | NEVER skip -- always ask (subjective preference) |
| Q6 Research/data | NEVER skip -- always ask (subjective preference) |
| Q7 Cloud/database | `cloud_database` list is non-empty (show detected, ask to confirm/add) |
| Q8 Project phase | NEVER skip -- always ask (subjective preference) |

### New questions (always ask unless targeted flow says otherwise)

| Question | Skip if |
|----------|---------|
| Q9 Brand identity | `has_brand_assets` is true AND `has_design_tokens` is true (show what was detected) |
| Q10 Team workflow | `has_ci_cd` is true AND `team_size` is known (show detected, ask to confirm) |
| Q11 Goals | NEVER skip |

## Presenting skipped questions

For each skipped question, show the user what was detected:

```
Detected from your project:
  Language: TypeScript (from package.json + tsconfig.json)
  Framework: Next.js (from next.config.mjs)
  Cloud: Supabase (from @supabase/supabase-js dependency)
```

Then ask: "Does this look right? Anything to add or correct?"

## Full question set

Ask only the questions not skipped. Present each one at a time, waiting for
the answer before continuing.

**Q1 -- Project type** *(pick all that apply)*
1. Software Engineering (APIs, services, CLIs, backend systems)
2. AI/LLM Engineering (agents, RAG, model integration, MCP servers)
3. R&D / Research prototype
4. Full-stack web application
5. Mobile application
6. Multiple of the above

**Q2 -- Primary language/stack**
1. TypeScript / JavaScript (Node.js)
2. Python
3. Both TypeScript and Python
4. Other (ask user to specify)

**Q3 -- Framework** *(pick all that apply, or "None")*
1. Next.js
2. React (without a framework)
3. Vue / Nuxt
4. Express / Fastify / Hono
5. FastAPI / Flask / Django
6. React Native / Expo
7. SwiftUI / iOS native
8. None / not applicable

**Q4 -- Design needs**
1. Full -- design systems, Stitch integration, 63-skill designer collection
2. Standard -- component library, shadcn/ui, Tailwind design system
3. Minimal -- just Anthropic's frontend-design skill
4. None -- purely backend, infra, or data

**Q5 -- Documentation output needs**
1. Full office suite (Word .docx, PowerPoint, Excel, PDF)
2. Technical docs only (API documentation, technical writing)
3. None

**Q6 -- Research / data needs**
1. Full -- web scraping, search, data analysis, browser automation
2. Search only
3. Data analysis / Python only
4. None

**Q7 -- Cloud / database target** *(pick all that apply)*
1. Azure AI (Cognitive Services, OpenAI on Azure, AI Search, Foundry)
2. Supabase
3. Neon / PostgreSQL
4. None / other

**Q8 -- Project phase**
1. Greenfield -- brand new project from scratch
2. Active feature development on an existing codebase
3. Refactoring / improving an existing codebase
4. Research / prototyping

**Q9 -- Brand identity** *(new)*
Do you have brand guidelines for this project?
1. Yes -- I have colors, fonts, logos, and/or design tokens defined
2. Partial -- some brand elements exist (tell me what you have)
3. No -- no brand identity yet
4. Not applicable (backend/data project)

**Q10 -- Team workflow** *(new)*
How does your team work?
1. Solo developer
2. Small team (2-4), informal process
3. Team (5+), with code review and CI/CD
4. Large team, strict process (PR reviews, staging environments, release trains)

**Q11 -- Goals** *(new)*
What's your primary goal right now? *(pick up to 2)*
1. Ship features faster
2. Improve code quality and reduce bugs
3. Onboard new team members
4. Scale architecture for growth
5. Improve documentation
6. Set up better testing
7. Other (ask user to specify)

## Output: SkillPlan

After all questions are answered (or skipped), combine scan results and answers
into a SkillPlan:

```
SkillPlan:
  # From scan
  language: [value]
  framework: [value]
  sdks: [list]
  cloud_database: [list]
  installed_skills: [list]
  is_rerun: [bool]
  team_size: [number]
  is_monorepo: [bool]
  brand_detected: [tokens/files or null]

  # From answers
  project_type: [Q1 answers]
  design_needs: [Q4 answer]
  documentation: [Q5 answer]
  research_data: [Q6 answer]
  project_phase: [Q8 answer]
  brand_identity: [Q9 answer]
  team_workflow: [Q10 answer]
  goals: [Q11 answers]
```

Pass this SkillPlan to the Skill Resolver module.
