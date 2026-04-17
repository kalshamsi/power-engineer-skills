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
| tavily-search | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-search -y` | Search the web with LLM-optimized results. Supports domain filtering, time ranges, and multiple search depths. | `/tavily-search` | When the user wants to search the web or find recent information |
| tavily-best-practices | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-best-practices -y` | Build production-ready Tavily integrations with best practices baked in. Reference documentation for developers implementing web search and RAG in agentic workflows. | `/tavily-best-practices` | When building a production Tavily integration or RAG system and needing reference guidance |
| tavily-cli | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-cli -y` | Web search, content extraction, crawling, and deep research via the Tavily CLI. Overview skill with workflow guide, install/auth instructions, and command reference. | `/tavily-cli` | When setting up the Tavily CLI or needing an overview of all Tavily web capabilities |
| tavily-crawl | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-crawl -y` | Crawl websites and extract content from multiple pages. Supports depth/breadth control, path filtering, and saving each page as a local markdown file. | `/tavily-crawl` | When bulk-extracting multiple pages from a site or downloading documentation |
| tavily-extract | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-extract -y` | Extract clean markdown or text content from specific URLs. Handles JavaScript-rendered pages with query-focused chunking. Processes up to 20 URLs in a single call. | `/tavily-extract` | When the user has a specific URL and wants its clean text content |
| tavily-map | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-map -y` | Discover and list all URLs on a website without extracting content. Faster than crawling — returns URLs only. | `/tavily-map` | When the user wants to find a specific page on a large site or list all site URLs |
| tavily-research | tavily-ai/skills | `npx skills add tavily-ai/skills --skill tavily-research -y` | Comprehensive AI-powered research with citations. Multi-source synthesis that takes 30-120 seconds. | `/tavily-research` | When the user wants deep research, a detailed report, or multi-source synthesis with explicit citations |
| browser-use | browser-use | `npx skills add browser-use/browser-use --skill browser-use -y` | Browser automation: navigation, form filling, extraction, screenshot. | `/browser-use` | When automating browser navigation, form filling, or content extraction |
