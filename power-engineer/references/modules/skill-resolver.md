# Skill Resolver

Takes a SkillPlan (scan results + questionnaire answers) and resolves it to a
deduplicated list of install commands using correct `--skill` flag syntax.

## Important: Install command syntax

All commands MUST use this format:
```
npx skills@latest add <github-user/repo> --skill <skill-name> -y
```

NEVER use the slash syntax:
```
npx skills@latest add <github-user/repo/skill-name>  # BROKEN - DO NOT USE
```

## How to use this module

1. Receive a SkillPlan (detected stack + user answers)
2. Start with "Always add" core methodology
3. Layer on skills from each answered question
4. De-duplicate: if the same skill appears from multiple answers, include it once
5. Filter against already-installed skills (from Scanner's ProjectProfile)
6. Output a flat list of install commands + a separate list of plugin-based installs

---

## Always add -- Core methodology (every project)

```bash
npx skills@latest add obra/superpowers --skill brainstorming -y
npx skills@latest add obra/superpowers --skill writing-plans -y
npx skills@latest add obra/superpowers --skill test-driven-development -y
npx skills@latest add obra/superpowers --skill systematic-debugging -y
npx skills@latest add obra/superpowers --skill verification-before-completion -y
npx skills@latest add obra/superpowers --skill requesting-code-review -y
npx skills@latest add obra/superpowers --skill receiving-code-review -y
npx skills@latest add obra/superpowers --skill subagent-driven-development -y
npx skills@latest add obra/superpowers --skill dispatching-parallel-agents -y
npx skills@latest add obra/superpowers --skill using-git-worktrees -y
npx skills@latest add obra/superpowers --skill finishing-a-development-branch -y
npx skills@latest add obra/superpowers --skill writing-skills -y
npx skills@latest add mattpocock/skills --skill grill-me -y
npx skills@latest add mattpocock/skills --skill write-a-prd -y
npx skills@latest add mattpocock/skills --skill prd-to-plan -y
npx skills@latest add mattpocock/skills --skill prd-to-issues -y
npx skills@latest add anthropics/skills --skill skill-creator -y
npx skills@latest add getsentry/skills --skill security-review -y
npx skills@latest add agamm/claude-code-owasp -y
npx skills@latest add majiayu000/claude-skill-registry --skill secrets-guardian -y
npx skills@latest add github/awesome-copilot --skill git-commit -y
npx skills@latest add supercent-io/skills-template --skill task-planning -y
```

---

## Project type (from scan or Q1 answer)

**If Software Engineering or Full-stack:**
```bash
npx skills@latest add github/awesome-copilot --skill gh-cli -y
npx skills@latest add mattpocock/skills --skill setup-pre-commit -y
npx skills@latest add mattpocock/skills --skill git-guardrails-claude-code -y
npx skills@latest add obra/superpowers --skill executing-plans -y
npx skills@latest add github/awesome-copilot --skill prd -y
npx skills@latest add supercent-io/skills-template --skill git-workflow -y
npx skills@latest add supercent-io/skills-template --skill changelog-maintenance -y
npx skills@latest add wshobson/agents --skill api-design-principles -y
npx skills@latest add supercent-io/skills-template --skill database-schema-design -y
npx skills@latest add supercent-io/skills-template --skill authentication-setup -y
npx skills@latest add supercent-io/skills-template --skill monitoring-observability -y
npx skills@latest add supercent-io/skills-template --skill deployment-automation -y
npx skills@latest add supercent-io/skills-template --skill performance-optimization -y
npx skills@latest add supercent-io/skills-template --skill backend-testing -y
npx skills@latest add supercent-io/skills-template --skill testing-strategies -y
npx skills@latest add supercent-io/skills-template --skill log-analysis -y
npx skills@latest add supercent-io/skills-template --skill codebase-search -y
npx skills@latest add supercent-io/skills-template --skill debugging -y
# Plugin-based (alirezarezvani/claude-skills) -- requires marketplace added
# /plugin install engineering-skills@claude-code-skills (docker, migration, incident, secrets, tech-debt, stripe)
```

**If AI/LLM Engineering:**
```bash
npx skills@latest add anthropics/skills --skill mcp-builder -y
npx skills@latest add tavily-ai/skills --skill search -y
npx skills@latest add obra/superpowers --skill executing-plans -y
npx skills@latest add charon-fan/agent-playbook --skill self-improving-agent -y
npx skills@latest add vercel-labs/agent-browser --skill agent-browser -y
npx skills@latest add inferen-sh/skills --skill agent-browser -y
npx skills@latest add firecrawl/cli --skill firecrawl -y
npx skills@latest add inferen-sh/skills --skill web-search -y
npx skills@latest add inferen-sh/skills --skill chat-ui -y
npx skills@latest add inferen-sh/skills --skill agent-ui -y
npx skills@latest add inferen-sh/skills --skill tools-ui -y
npx skills@latest add inferen-sh/skills --skill widgets-ui -y
npx skills@latest add aliksir/claude-code-skill-security-check -y
# Plugin-based
# /plugin install agenthub@claude-code-skills (parallel competing subagents)
# /plugin install engineering-advanced-skills@claude-code-skills (agent-designer, autoresearch)
```

**If R&D / Research:**
```bash
npx skills@latest add supercent-io/skills-template --skill technical-writing -y
npx skills@latest add tavily-ai/skills --skill search -y
npx skills@latest add anthropics/skills --skill mcp-builder -y
npx skills@latest add supercent-io/skills-template --skill data-analysis -y
npx skills@latest add firecrawl/cli --skill firecrawl -y
npx skills@latest add inferen-sh/skills --skill python-executor -y
npx skills@latest add inferen-sh/skills --skill web-search -y
npx skills@latest add mattpocock/skills --skill design-an-interface -y
# Plugin-based
# /plugin install engineering-advanced-skills@claude-code-skills (data-engineer, data-scientist, autoresearch)
```

---

## Language/Stack (from scan or Q2 answer)

**If TypeScript / JavaScript:**
```bash
npx skills@latest add wshobson/agents --skill typescript-advanced-types -y
npx skills@latest add wshobson/agents --skill nodejs-backend-patterns -y
npx skills@latest add mattpocock/skills --skill tdd -y
```

**If Python:**
```bash
npx skills@latest add wshobson/agents --skill python-performance-optimization -y
npx skills@latest add inferen-sh/skills --skill python-executor -y
npx skills@latest add inferen-sh/skills --skill python-sdk -y
# Plugin-based
# /plugin install engineering-advanced-skills@claude-code-skills (data-engineer, data-scientist, ml-engineer, computer-vision)
```

**If Both:** add all of the above.

---

## Framework (from scan or Q3 answer)

**Next.js:**
```bash
npx skills@latest add vercel-labs/next-skills --skill next-best-practices -y
npx skills@latest add vercel-labs/next-skills --skill next-cache-components -y
npx skills@latest add vercel-labs/agent-skills --skill vercel-react-best-practices -y
npx skills@latest add vercel-labs/agent-skills --skill vercel-composition-patterns -y
npx skills@latest add vercel-labs/agent-skills --skill deploy-to-vercel -y
```

**React (no framework):**
```bash
npx skills@latest add vercel-labs/agent-skills --skill vercel-react-best-practices -y
npx skills@latest add vercel-labs/agent-skills --skill vercel-composition-patterns -y
```

**Vue / Nuxt:**
```bash
npx skills@latest add hyf0/vue-skills --skill vue-best-practices -y
npx skills@latest add antfu/skills --skill vue -y
npx skills@latest add antfu/skills --skill vite -y
```

**Express / Fastify / Hono:**
```bash
npx skills@latest add wshobson/agents --skill nodejs-backend-patterns -y
npx skills@latest add supercent-io/skills-template --skill backend-testing -y
npx skills@latest add supercent-io/skills-template --skill api-design -y
# Plugin-based: /plugin install engineering-skills@claude-code-skills (docker, helm, terraform)
```

**FastAPI / Flask / Django:**
```bash
npx skills@latest add wshobson/agents --skill python-performance-optimization -y
npx skills@latest add supercent-io/skills-template --skill backend-testing -y
# Plugin-based: /plugin install engineering-skills@claude-code-skills (docker, helm, terraform)
```

**React Native / Expo:**
```bash
npx skills@latest add vercel-labs/agent-skills --skill vercel-react-native-skills -y
npx skills@latest add expo/skills --skill building-native-ui -y
npx skills@latest add expo/skills --skill native-data-fetching -y
npx skills@latest add expo/skills --skill upgrading-expo -y
npx skills@latest add expo/skills --skill expo-tailwind-setup -y
npx skills@latest add expo/skills --skill expo-cicd-workflows -y
npx skills@latest add expo/skills --skill expo-api-routes -y
npx skills@latest add expo/skills --skill expo-dev-client -y
npx skills@latest add expo/skills --skill expo-deployment -y
npx skills@latest add ehmo/platform-design-skills --skill platform-design-skills -y
```

**SwiftUI / iOS:**
```bash
npx skills@latest add avdlee/swiftui-agent-skill --skill swiftui-expert-skill -y
npx skills@latest add ehmo/platform-design-skills --skill platform-design-skills -y
```

### SDK sub-question (from scan or follow-up)

**If Vercel AI SDK:**
```bash
npx skills@latest add vercel/ai --skill ai-sdk -y
npx skills@latest add inferen-sh/skills --skill chat-ui -y
npx skills@latest add inferen-sh/skills --skill agent-ui -y
npx skills@latest add inferen-sh/skills --skill tools-ui -y
npx skills@latest add inferen-sh/skills --skill widgets-ui -y
```

**If Anthropic Python SDK:**
```bash
npx skills@latest add inferen-sh/skills --skill python-sdk -y
```

**If Anthropic JS/TS SDK:**
```bash
npx skills@latest add inferen-sh/skills --skill javascript-sdk -y
```

---

## Design needs (from Q4 answer)

**Full design:**
```bash
npx skills@latest add anthropics/skills --skill frontend-design -y
npx skills@latest add anthropics/skills --skill canvas-design -y
npx skills@latest add anthropics/skills --skill brand-guidelines -y
npx skills@latest add vercel-labs/agent-skills --skill web-design-guidelines -y
npx skills@latest add wshobson/agents --skill tailwind-design-system -y
npx skills@latest add shadcn/ui --skill shadcn -y
npx skills@latest add ehmo/platform-design-skills --skill platform-design-skills -y
npx skills@latest add better-auth/skills --skill better-auth-best-practices -y
npx skills@latest add supercent-io/skills-template --skill ui-component-patterns -y
npx skills@latest add supercent-io/skills-template --skill responsive-design -y
npx skills@latest add supercent-io/skills-template --skill web-accessibility -y
npx skills@latest add mattpocock/skills --skill design-an-interface -y
# Google Stitch (requires Stitch MCP server configured)
npx skills@latest add google-labs-code/stitch-skills --skill stitch-loop -y
npx skills@latest add google-labs-code/stitch-skills --skill enhance-prompt -y
npx skills@latest add google-labs-code/stitch-skills --skill react:components -y
npx skills@latest add google-labs-code/stitch-skills --skill design-md -y
npx skills@latest add google-labs-code/stitch-skills --skill shadcn-ui -y
npx skills@latest add google-labs-code/stitch-skills --skill remotion -y
```
Also add to PLUGIN section: UI/UX Pro Max, Designer Skills Collection.

**Standard design:**
```bash
npx skills@latest add anthropics/skills --skill frontend-design -y
npx skills@latest add wshobson/agents --skill tailwind-design-system -y
npx skills@latest add shadcn/ui --skill shadcn -y
npx skills@latest add supercent-io/skills-template --skill responsive-design -y
npx skills@latest add supercent-io/skills-template --skill web-accessibility -y
npx skills@latest add supercent-io/skills-template --skill ui-component-patterns -y
npx skills@latest add vercel-labs/agent-skills --skill web-design-guidelines -y
```

**Minimal design:**
```bash
npx skills@latest add anthropics/skills --skill frontend-design -y
```

---

## Documentation (from Q5 answer)

**Full office suite:**
```bash
npx skills@latest add anthropics/skills --skill docx -y
npx skills@latest add anthropics/skills --skill pptx -y
npx skills@latest add anthropics/skills --skill xlsx -y
npx skills@latest add anthropics/skills --skill pdf -y
npx skills@latest add anthropics/skills --skill internal-comms -y
npx skills@latest add supercent-io/skills-template --skill technical-writing -y
npx skills@latest add supercent-io/skills-template --skill user-guide-writing -y
npx skills@latest add supercent-io/skills-template --skill api-documentation -y
```

**Technical docs only:**
```bash
npx skills@latest add supercent-io/skills-template --skill technical-writing -y
npx skills@latest add supercent-io/skills-template --skill api-documentation -y
npx skills@latest add anthropics/skills --skill pdf -y
```

---

## Research / data (from Q6 answer)

**Full research:**
```bash
npx skills@latest add firecrawl/cli --skill firecrawl -y
npx skills@latest add tavily-ai/skills --skill search -y
npx skills@latest add vercel-labs/agent-browser --skill agent-browser -y
npx skills@latest add inferen-sh/skills --skill agent-browser -y
npx skills@latest add supercent-io/skills-template --skill data-analysis -y
npx skills@latest add inferen-sh/skills --skill python-executor -y
npx skills@latest add inferen-sh/skills --skill web-search -y
```

**Search only:**
```bash
npx skills@latest add tavily-ai/skills --skill search -y
npx skills@latest add inferen-sh/skills --skill web-search -y
```

**Data analysis / Python:**
```bash
npx skills@latest add supercent-io/skills-template --skill data-analysis -y
npx skills@latest add inferen-sh/skills --skill python-executor -y
npx skills@latest add wshobson/agents --skill python-performance-optimization -y
```

---

## Cloud / database (from scan or Q7 answer)

**Azure AI:**
```bash
npx skills@latest add microsoft/github-copilot-for-azure --skill azure-ai -y
npx skills@latest add microsoft/azure-skills --skill microsoft-foundry -y
npx skills@latest add microsoft/github-copilot-for-azure --skill azure-observability -y
npx skills@latest add microsoft/github-copilot-for-azure --skill azure-compute -y
npx skills@latest add microsoft/github-copilot-for-azure --skill azure-postgres -y
npx skills@latest add microsoft/azure-skills --skill azure-observability -y
npx skills@latest add microsoft/azure-skills --skill azure-upgrade -y
```

**Supabase:**
```bash
npx skills@latest add supabase/agent-skills --skill supabase-postgres-best-practices -y
```

**Neon / PostgreSQL:**
```bash
npx skills@latest add neondatabase/agent-skills --skill neon-postgres -y
```

---

## Project phase (from Q8 answer)

**Greenfield:**
```bash
npx skills@latest add supercent-io/skills-template --skill file-organization -y
```
Also recommend plugins: GSD, Superpowers by obra.

**Active feature development:** No additional skills.

**Refactoring:**
```bash
npx skills@latest add mattpocock/skills --skill request-refactor-plan -y
npx skills@latest add supercent-io/skills-template --skill code-refactoring -y
npx skills@latest add supercent-io/skills-template --skill codebase-search -y
npx skills@latest add supercent-io/skills-template --skill changelog-maintenance -y
npx skills@latest add supercent-io/skills-template --skill debugging -y
# Plugin-based
# /plugin install engineering-advanced-skills@claude-code-skills (tech-debt-tracker, codebase-onboarding, migration-architect)
```

**Research / prototyping:**
```bash
npx skills@latest add supercent-io/skills-template --skill data-analysis -y
npx skills@latest add firecrawl/cli --skill firecrawl -y
npx skills@latest add tavily-ai/skills --skill search -y
npx skills@latest add mattpocock/skills --skill design-an-interface -y
```

---

## Security needs (from Q12 answer)

Default security (Sentry security-review, OWASP, secrets-guardian) is already
included in "Always add" core methodology. The blocks below layer on additional
security skills based on the user's Q12 selection.

If the user selected "None" for Q12, REMOVE the three default security skills
from the install plan (security-review, claude-code-owasp, secrets-guardian).

**If Deep SAST/DAST:**
```bash
npx skills@latest add trailofbits/skills --skill semgrep-rule-creator -y
npx skills@latest add trailofbits/skills --skill static-analysis -y
npx skills@latest add trailofbits/skills --skill variant-analysis -y
npx skills@latest add trailofbits/skills --skill differential-review -y
npx skills@latest add trailofbits/skills --skill fp-check -y
npx skills@latest add github/awesome-copilot --skill codeql -y
npx skills@latest add majiayu000/claude-skill-registry --skill dast-nuclei -y
npx skills@latest add jthack/ffuf_claude_skill -y
npx skills@latest add majiayu000/claude-skill-registry --skill gitleaks -y
```

**If Container & IaC:**
```bash
npx skills@latest add majiayu000/claude-skill-registry --skill trivy -y
npx skills@latest add AgentSecOps/SecOpsAgentKit --skill container-grype -y
npx skills@latest add AgentSecOps/SecOpsAgentKit --skill iac-checkov -y
npx skills@latest add majiayu000/claude-skill-registry --skill iac-scanner -y
npx skills@latest add trailofbits/skills --skill supply-chain-risk-auditor -y
```

**If Compliance:**
```bash
npx skills@latest add Sushegaad/Claude-Skills-Governance-Risk-and-Compliance -y
npx skills@latest add Tencent/AI-Infra-Guard --skill owasp-asi -y
```

**If Penetration testing:**
```bash
npx skills@latest add Eyadkelleh/awesome-claude-skills-security -y
npx skills@latest add jthack/ffuf_claude_skill -y
npx skills@latest add trailofbits/skills --skill burpsuite-project-parser -y
npx skills@latest add trailofbits/skills --skill agentic-actions-auditor -y
npx skills@latest add WolzenGeorgi/claude-skills-pentest -y
```

**If Threat modeling:**
```bash
npx skills@latest add fr33d3m0n/threat-modeling -y
npx skills@latest add garrytan/gstack --skill cso -y
npx skills@latest add trailofbits/skills --skill insecure-defaults -y
npx skills@latest add trailofbits/skills --skill sharp-edges -y
```

## Security level (from Q12 — new security levels)

Controls which of the 10 new `kalshamsi/claude-security-skills` skills get added.
These levels are distinct from the existing Q12 branches above.

**Standard:** No new skills added (existing security-review, OWASP, secrets-guardian from core methodology is sufficient)

**Enhanced:** Add exactly these 3:
```bash
npx skills@latest add kalshamsi/claude-security-skills --skill security-headers-audit -y
npx skills@latest add kalshamsi/claude-security-skills --skill crypto-audit -y
npx skills@latest add kalshamsi/claude-security-skills --skill api-security-tester -y
```

**Maximum:** Add all of Enhanced + these 5:
```bash
npx skills@latest add kalshamsi/claude-security-skills --skill security-headers-audit -y
npx skills@latest add kalshamsi/claude-security-skills --skill crypto-audit -y
npx skills@latest add kalshamsi/claude-security-skills --skill api-security-tester -y
npx skills@latest add kalshamsi/claude-security-skills --skill bandit-sast -y
npx skills@latest add kalshamsi/claude-security-skills --skill socket-sca -y
npx skills@latest add kalshamsi/claude-security-skills --skill docker-scout-scanner -y
npx skills@latest add kalshamsi/claude-security-skills --skill security-test-generator -y
npx skills@latest add kalshamsi/claude-security-skills --skill devsecops-pipeline -y
```

**Compliance:** Add all of Maximum + these 2:
```bash
npx skills@latest add kalshamsi/claude-security-skills --skill security-headers-audit -y
npx skills@latest add kalshamsi/claude-security-skills --skill crypto-audit -y
npx skills@latest add kalshamsi/claude-security-skills --skill api-security-tester -y
npx skills@latest add kalshamsi/claude-security-skills --skill bandit-sast -y
npx skills@latest add kalshamsi/claude-security-skills --skill socket-sca -y
npx skills@latest add kalshamsi/claude-security-skills --skill docker-scout-scanner -y
npx skills@latest add kalshamsi/claude-security-skills --skill security-test-generator -y
npx skills@latest add kalshamsi/claude-security-skills --skill devsecops-pipeline -y
npx skills@latest add kalshamsi/claude-security-skills --skill pci-dss-audit -y
npx skills@latest add kalshamsi/claude-security-skills --skill mobile-security -y
```

**Custom:** Present all 10 as options for user to cherry-pick:
```bash
npx skills@latest add kalshamsi/claude-security-skills --skill security-headers-audit -y
npx skills@latest add kalshamsi/claude-security-skills --skill crypto-audit -y
npx skills@latest add kalshamsi/claude-security-skills --skill api-security-tester -y
npx skills@latest add kalshamsi/claude-security-skills --skill bandit-sast -y
npx skills@latest add kalshamsi/claude-security-skills --skill socket-sca -y
npx skills@latest add kalshamsi/claude-security-skills --skill docker-scout-scanner -y
npx skills@latest add kalshamsi/claude-security-skills --skill security-test-generator -y
npx skills@latest add kalshamsi/claude-security-skills --skill devsecops-pipeline -y
npx skills@latest add kalshamsi/claude-security-skills --skill pci-dss-audit -y
npx skills@latest add kalshamsi/claude-security-skills --skill mobile-security -y
```

---

**Framework-specific security (auto-added based on Q3 framework, no question needed):**

If Django detected → also add:
```bash
npx skills@latest add affaan-m/everything-claude-code --skill django-security -y
```

If Laravel detected → also add:
```bash
npx skills@latest add affaan-m/everything-claude-code --skill laravel-security -y
```

If Spring Boot detected → also add:
```bash
npx skills@latest add affaan-m/everything-claude-code --skill springboot-security -y
```
