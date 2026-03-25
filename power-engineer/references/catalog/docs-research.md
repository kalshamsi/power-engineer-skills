# Documentation & Research

## Document Generation — Anthropic Official

| Skill | Install | Description | Trigger | When to use |
|-------|---------|-------------|---------|-------------|
| docx | `npx skills@latest add anthropics/skills --skill docx -y` | Creates and edits Word documents with headers, tables, tracked changes. | `/docx` | When generating or editing Word documents programmatically |
| pptx | `npx skills@latest add anthropics/skills --skill pptx -y` | Builds polished PowerPoint presentations with layouts, speaker notes, themes. | `/pptx` | When generating presentation slides from content or data |
| xlsx | `npx skills@latest add anthropics/skills --skill xlsx -y` | Creates and manipulates Excel spreadsheets with formulas, pivot tables. | `/xlsx` | When generating or transforming Excel spreadsheets |
| pdf | `npx skills@latest add anthropics/skills --skill pdf -y` | PDF manipulation: text extraction, merging, splitting, form filling, OCR. | `/pdf` | When reading, merging, splitting, or filling PDF documents |
| internal-comms | `npx skills@latest add anthropics/skills --skill internal-comms -y` | Internal communications: status reports, newsletters, FAQs. | `/internal-comms` | When drafting status reports, newsletters, or internal FAQs |

---

## Technical Writing — supercent-io/skills-template

| Skill | Install | Description | Trigger | When to use |
|-------|---------|-------------|---------|-------------|
| technical-writing | `npx skills@latest add supercent-io/skills-template --skill technical-writing -y` | Docs standards: clarity, structure, audience targeting, doc testing. | `/technical-writing` | When writing or auditing technical documentation for clarity and structure |
| api-documentation | `npx skills@latest add supercent-io/skills-template --skill api-documentation -y` | OpenAPI/Swagger-aligned API docs with examples and error catalogs. | `/api-documentation` | When writing or updating OpenAPI-aligned API reference documentation |
| user-guide-writing | `npx skills@latest add supercent-io/skills-template --skill user-guide-writing -y` | End-user documentation: step-by-step instructions, visual aids. | `/user-guide-writing` | When writing end-user guides with step-by-step instructions |

---

## Web Research & Data

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| firecrawl | firecrawl/cli | `npx skills@latest add firecrawl/cli --skill firecrawl -y` | Web crawl and structure data from any URL for research and RAG. | `/firecrawl` | When crawling websites to extract structured data for research or RAG |
| search | tavily-ai/skills | `npx skills@latest add tavily-ai/skills --skill search -y` | Tavily real-time search with structured result extraction. | `/search` | When grounding AI responses with real-time web search results |
| data-analysis | supercent-io | `npx skills@latest add supercent-io/skills-template --skill data-analysis -y` | Data exploration, statistical analysis, and visualisation in Python/R. | `/data-analysis` | When exploring datasets or building statistical visualisations |
| browser-use | browser-use | `npx skills@latest add browser-use/browser-use --skill browser-use -y` | Browser automation: navigation, form filling, extraction, screenshot. | `/browser-use` | When automating browser navigation, form filling, or content extraction |
