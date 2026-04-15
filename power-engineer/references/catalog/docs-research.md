# Documentation & Research

## Document Generation — Anthropic Official

| Skill | Install | Description | Trigger | When to use |
|-------|---------|-------------|---------|-------------|
| docx | `npx skills add anthropics/skills --skill docx -y` | Creates and edits Word documents with headers, tables, tracked changes. | `/docx` | When generating or editing Word documents programmatically |
| pptx | `npx skills add anthropics/skills --skill pptx -y` | Builds polished PowerPoint presentations with layouts, speaker notes, themes. | `/pptx` | When generating presentation slides from content or data |
| xlsx | `npx skills add anthropics/skills --skill xlsx -y` | Creates and manipulates Excel spreadsheets with formulas, pivot tables. | `/xlsx` | When generating or transforming Excel spreadsheets |
| pdf | `npx skills add anthropics/skills --skill pdf -y` | PDF manipulation: text extraction, merging, splitting, form filling, OCR. | `/pdf` | When reading, merging, splitting, or filling PDF documents |
| internal-comms | `npx skills add anthropics/skills --skill internal-comms -y` | Internal communications: status reports, newsletters, FAQs. | `/internal-comms` | When drafting status reports, newsletters, or internal FAQs |

---

## Web Research & Data

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| firecrawl | firecrawl/cli | `npx skills add firecrawl/cli --skill firecrawl -y` | Web crawl and structure data from any URL for research and RAG. | `/firecrawl` | When crawling websites to extract structured data for research or RAG |
| search | tavily-ai/skills | `npx skills add tavily-ai/skills --skill search -y` | Tavily real-time search with structured result extraction. | `/search` | When grounding AI responses with real-time web search results |
| browser-use | browser-use | `npx skills add browser-use/browser-use --skill browser-use -y` | Browser automation: navigation, form filling, extraction, screenshot. | `/browser-use` | When automating browser navigation, form filling, or content extraction |
