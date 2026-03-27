# Adaptive Questionnaire Module

Receives the ProjectProfile from the Scanner and constructs a dynamic interview.
Questions already answered by scan results are skipped. For blank/empty projects,
all questions are asked.

**CRITICAL:** Every question in this module MUST be asked using the
`AskUserQuestion` tool. Never ask questions as plain text in a response.
The tool provides a structured UI with clickable options that is faster and
more reliable than free-text conversation.

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
| Q9 Brand identity | `has_brand_assets` is true AND `has_design_tokens` is true (show detected) |
| Q10 Team workflow | `has_ci_cd` is true AND `team_size` is known (show detected) |
| Q11 Goals | NEVER skip |
| Q12 Security needs | NEVER skip -- always ask (subjective preference) |
| Q13 Cross-tool usage | `.cursorrules` exists OR `copilot-instructions.md` exists OR `.windsurfrules` exists (show detected, ask to confirm/add) |

## Presenting skipped questions

Before starting the interview, present what was auto-detected as plain text:

```
Detected from your project:
  Language: TypeScript (from package.json + tsconfig.json)
  Framework: Next.js (from next.config.mjs)
  Cloud: Supabase (from @supabase/supabase-js dependency)
```

Then confirm with AskUserQuestion:

```
AskUserQuestion:
  question: "I detected the above from your project. Does this look correct?"
  header: "Scan"
  options:
    - label: "Looks correct"
      description: "Proceed with these detected values"
    - label: "Needs correction"
      description: "I'll specify what needs changing"
  multiSelect: false
```

If the user selects "Needs correction" or "Other", ask which values need
changing before proceeding.

## Batching strategy

Group non-skipped questions into thematic batches of 2-3 per AskUserQuestion
call. The tool supports up to 4 questions per call.

| Batch | Questions | Theme |
|-------|-----------|-------|
| 1 | Q1, Q2, Q3 | Stack and project type |
| 2 | Q4, Q5, Q6 | Design, docs, research preferences |
| 3 | Q7, Q8 | Infrastructure and project phase |
| 4 | Q9, Q10, Q11 | Brand, team, goals |
| 5 | Q12 | Security |
| 6 | Q13 | Cross-tool usage |

Rules:
- If all questions in a batch are skipped, move to the next batch.
- If only 1 question remains in a batch after skips, combine it with the
  next batch (up to 4 questions max per call).
- Present skipped-question detections as plain text BEFORE the AskUserQuestion
  call for the batch that contains them.

## Question definitions

Each question below is defined in AskUserQuestion format. When batching
multiple questions, combine them into a single AskUserQuestion call.

### Q1 -- Project type

```
question: "What type of project is this?"
header: "Project"
multiSelect: true
options:
  - label: "Software Engineering"
    description: "APIs, services, CLIs, backend systems"
  - label: "AI/LLM Engineering"
    description: "Agents, RAG, model integration, MCP servers"
  - label: "Full-stack Web App"
    description: "Frontend + backend web application"
  - label: "Mobile App"
    description: "React Native, Expo, SwiftUI, or native mobile"
```

### Q2 -- Language / stack

```
question: "What is the primary language/stack?"
header: "Language"
multiSelect: false
options:
  - label: "TypeScript / JavaScript"
    description: "Node.js ecosystem"
  - label: "Python"
    description: "Python ecosystem"
  - label: "Both TS and Python"
    description: "Polyglot project using both"
  - label: "Go / Rust / Java"
    description: "Other compiled or typed languages"
```

### Q3 -- Framework

```
question: "Which framework(s) are you using?"
header: "Framework"
multiSelect: true
options:
  - label: "React / Next.js"
    description: "React ecosystem including Next.js, Remix, Gatsby"
  - label: "Vue / Nuxt"
    description: "Vue ecosystem including Nuxt, Vite-based setups"
  - label: "Node.js backend"
    description: "Express, Fastify, Hono, or similar server frameworks"
  - label: "Python web"
    description: "FastAPI, Flask, Django, or similar Python frameworks"
```

### Q4 -- Design needs

```
question: "What level of design tooling do you need?"
header: "Design"
multiSelect: false
options:
  - label: "Full"
    description: "Design systems, Stitch, 63-skill designer collection"
  - label: "Standard"
    description: "Component library, shadcn/ui, Tailwind design system"
  - label: "Minimal"
    description: "Just Anthropic's frontend-design skill"
  - label: "None"
    description: "Purely backend, infra, or data project"
```

### Q5 -- Documentation needs

```
question: "What documentation output do you need?"
header: "Docs"
multiSelect: false
options:
  - label: "Full office suite"
    description: "Word .docx, PowerPoint, Excel, and PDF generation"
  - label: "Technical docs only"
    description: "API docs, technical writing, markdown"
  - label: "None"
    description: "No documentation tooling needed"
```

### Q6 -- Research / data needs

```
question: "What research and data capabilities do you need?"
header: "Research"
multiSelect: false
options:
  - label: "Full"
    description: "Web scraping, search, data analysis, browser automation"
  - label: "Search only"
    description: "Web search and content retrieval"
  - label: "Data analysis"
    description: "Data analysis and visualization in Python"
  - label: "None"
    description: "No research or data tooling"
```

### Q7 -- Cloud / database

```
question: "Which cloud/database platforms are you targeting?"
header: "Cloud"
multiSelect: true
options:
  - label: "Azure AI"
    description: "Cognitive Services, OpenAI on Azure, AI Search, Foundry"
  - label: "Supabase"
    description: "Auth, database, storage, edge functions"
  - label: "Neon / PostgreSQL"
    description: "Serverless Postgres or standard PostgreSQL"
  - label: "None"
    description: "No specific cloud/database platform"
```

### Q8 -- Project phase

```
question: "What phase is this project in?"
header: "Phase"
multiSelect: false
options:
  - label: "Greenfield"
    description: "Brand new project from scratch"
  - label: "Active development"
    description: "Building features on an existing codebase"
  - label: "Refactoring"
    description: "Improving and restructuring existing code"
  - label: "Research / prototype"
    description: "Exploring ideas, prototyping, or R&D"
```

### Q9 -- Brand identity

```
question: "Do you have brand guidelines for this project?"
header: "Brand"
multiSelect: false
options:
  - label: "Yes, fully defined"
    description: "Colors, fonts, logos, and/or design tokens are set"
  - label: "Partial"
    description: "Some brand elements exist but not complete"
  - label: "No brand yet"
    description: "No brand identity established"
  - label: "Not applicable"
    description: "Backend/data project, no UI"
```

### Q10 -- Team workflow

```
question: "How does your team work?"
header: "Team"
multiSelect: false
options:
  - label: "Solo developer"
    description: "Working alone on this project"
  - label: "Small team (2-4)"
    description: "Informal process, lightweight reviews"
  - label: "Team (5+) with CI/CD"
    description: "Code reviews, CI/CD pipelines, staging"
  - label: "Large team, strict process"
    description: "PR reviews, release trains, multiple environments"
```

### Q11 -- Goals

```
question: "What are your primary goals right now?"
header: "Goals"
multiSelect: true
options:
  - label: "Ship features faster"
    description: "Increase development velocity and delivery speed"
  - label: "Improve quality & testing"
    description: "Better code quality, fewer bugs, stronger tests"
  - label: "Scale architecture"
    description: "Performance, growth, refactoring for scale"
  - label: "Better docs & onboarding"
    description: "Documentation, team onboarding, knowledge sharing"
```

### Q12 -- Security needs

```
question: "What security practices does this project need?"
header: "Security"
multiSelect: true
options:
  - label: "Standard"
    description: "Code review, OWASP, secrets detection (included by default)"
  - label: "Deep SAST/DAST"
    description: "Semgrep rules, CodeQL, Nuclei scanning, fuzzing"
  - label: "Container & IaC"
    description: "Trivy, Grype, Checkov, tfsec for containers and infrastructure"
  - label: "Compliance"
    description: "SOC 2, HIPAA, PCI-DSS, GDPR, ISO 27001 frameworks"
  - label: "Penetration testing"
    description: "Pentest tools, SecLists, offensive security, CTF"
  - label: "Threat modeling"
    description: "STRIDE/DREAD analysis, attack trees, MITRE ATT&CK"
  - label: "None"
    description: "Skip all security skills"
```

Note: "Standard" security (Sentry security-review, OWASP, secrets detection)
is included by default in the core methodology for every project. Selecting
"Standard" alone adds no extra skills. Selecting additional options layers on
specialized security tooling. Selecting "None" removes the default security
skills from the install plan.

### Q13 -- Cross-tool usage

```
question: "Do you use other AI coding tools alongside Claude Code?"
header: "Tools"
multiSelect: true
options:
  - label: "Cursor"
    description: "Generate .cursorrules with project behavioral rules"
  - label: "GitHub Copilot"
    description: "Generate .github/copilot-instructions.md with project behavioral rules"
  - label: "Windsurf"
    description: "Generate .windsurfrules with project behavioral rules"
  - label: "None"
    description: "Only using Claude Code — skip cross-tool config generation"
```

Note: If cross-tool config files are detected on disk during the scan, present
detections before asking. If the user selects "None", no config files are
generated. The answer is stored in `state.json` under
`questionnaire_answers.cross_tool_usage`.

---

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
  security_needs: [Q12 answers]
  cross_tool_usage: [Q13 answers]
```

Pass this SkillPlan to the Skill Resolver module.
