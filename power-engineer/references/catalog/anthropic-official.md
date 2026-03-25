# Anthropic Official & Meta / Skill Creation

## Anthropic Official — anthropics/skills

| Skill | Install | Description | Trigger | When to use |
|-------|---------|-------------|---------|-------------|
| skill-creator | `npx skills@latest add anthropics/skills --skill skill-creator -y` | Official skill authoring guide with progressive disclosure patterns. | `/skill-creator` | When building a new Claude skill following official patterns |
| mcp-builder | `npx skills@latest add anthropics/skills --skill mcp-builder -y` | Builds MCP servers from scratch: tool schema, transport config, auth, deployment. | `/mcp-builder` | When creating a new MCP server with tools, auth, or transport |
| frontend-design | `npx skills@latest add anthropics/skills --skill frontend-design -y` | Production-grade UI skill. Creates distinctive, accessible frontend interfaces. | `/frontend-design` | When building production-quality accessible UI components |
| pdf | `npx skills@latest add anthropics/skills --skill pdf -y` | PDF manipulation: text extraction, merging, splitting, form filling, OCR, watermarks. | `/pdf` | When reading, merging, splitting, or filling PDF documents |
| docx | `npx skills@latest add anthropics/skills --skill docx -y` | Creates and edits Word documents with headers, tables, tracked changes, formatting. | `/docx` | When generating or editing Word documents programmatically |
| pptx | `npx skills@latest add anthropics/skills --skill pptx -y` | Builds polished PowerPoint presentations with layouts, speaker notes, themes. | `/pptx` | When generating presentation slides from content or data |
| xlsx | `npx skills@latest add anthropics/skills --skill xlsx -y` | Creates and manipulates Excel spreadsheets with formulas, pivot tables, formatting. | `/xlsx` | When generating or transforming Excel spreadsheets |
| webapp-testing | `npx skills@latest add anthropics/skills --skill webapp-testing -y` | E2E web app testing strategies with browser automation and assertion patterns. | `/webapp-testing` | When designing E2E test coverage for a web application |
| canvas-design | `npx skills@latest add anthropics/skills --skill canvas-design -y` | HTML canvas design for generative art and interactive visualisations. | `/canvas-design` | When creating generative art or interactive canvas visualisations |
| algorithmic-art | `npx skills@latest add anthropics/skills --skill algorithmic-art -y` | Creates algorithmic and generative art using code. | `/algorithmic-art` | When generating visual art through code-driven algorithms |
| brand-guidelines | `npx skills@latest add anthropics/skills --skill brand-guidelines -y` | Applies brand colours, typography, and style guidelines to artifacts. | `/brand-guidelines` | When ensuring output matches an established brand identity |
| internal-comms | `npx skills@latest add anthropics/skills --skill internal-comms -y` | Writes internal communications: status reports, newsletters, FAQs. | `/internal-comms` | When drafting status reports, newsletters, or internal FAQs |

---

## Meta / Skill Creation

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| skill-creator | anthropics/skills | `npx skills@latest add anthropics/skills --skill skill-creator -y` | Official Anthropic skill authoring guide with progressive disclosure. | `/skill-creator` | When authoring a new skill following Anthropic's official guide |
| mcp-builder | anthropics/skills | `npx skills@latest add anthropics/skills --skill mcp-builder -y` | Builds MCP servers from scratch. | `/mcp-builder` | When scaffolding a new MCP server from scratch |
| write-a-skill | mattpocock/skills | `npx skills@latest add mattpocock/skills --skill write-a-skill -y` | Opinionated skill authoring workflow with bundled resource patterns. | `/write-a-skill` | When creating a skill with bundled resources and opinionated structure |
