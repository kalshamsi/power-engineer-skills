# Agentic AI & LLM Engineering

## AI/LLM SDKs — inferen-sh/skills

| Skill | Scope | Install | Description | Trigger | When to use |
|-------|-------|---------|-------------|---------|-------------|
| python-sdk | `local` | `npx skills@latest add inferen-sh/skills --skill python-sdk -y` | Anthropic Python SDK: async usage, streaming, tool use, batch processing. | `/python-sdk` | When building Python apps with the Anthropic SDK |
| javascript-sdk | `local` | `npx skills@latest add inferen-sh/skills --skill javascript-sdk -y` | Anthropic JS/TS SDK: client setup, error handling, token management, streaming. | `/javascript-sdk` | When integrating the Anthropic JS/TS SDK into a web or Node app |
| chat-ui | `local` | `npx skills@latest add inferen-sh/skills --skill chat-ui -y` | Production chat UI: streaming responses, message history, tool call rendering. | `/chat-ui` | When building a streaming chat interface with message history |
| agent-ui | `local` | `npx skills@latest add inferen-sh/skills --skill agent-ui -y` | Agent-specific UI: tool use visualisation, step tracking, human approval flows. | `/agent-ui` | When building UIs that display agent steps and tool call results |
| tools-ui | `local` | `npx skills@latest add inferen-sh/skills --skill tools-ui -y` | UI patterns for rendering tool calls, results, and intermediate agent steps. | `/tools-ui` | When displaying tool calls and intermediate agent outputs in the UI |
| widgets-ui | `local` | `npx skills@latest add inferen-sh/skills --skill widgets-ui -y` | Embeddable widget patterns for AI-powered components within larger apps. | `/widgets-ui` | When embedding AI-powered widgets into an existing application |
| web-search | `local` | `npx skills@latest add inferen-sh/skills --skill web-search -y` | Structured web search integration for grounding AI responses in current information. | `/web-search` | When grounding agent responses with live web search results |
| python-executor | `local` | `npx skills@latest add inferen-sh/skills --skill python-executor -y` | Safe Python code execution within agent sessions for data processing. | `/python-executor` | When executing Python code safely inside an agent session |
| agent-browser | `local` | `npx skills@latest add inferen-sh/skills --skill agent-browser -y` | Browser automation from within agent sessions: navigation, extraction, interaction. | `/agent-browser` | When automating browser navigation and extraction from agent sessions |
| ai-image-generation | `local` | `npx skills@latest add inferen-sh/skills --skill ai-image-generation -y` | AI image generation: prompt engineering, model selection, output handling. | `/ai-image-generation` | When generating images with AI models from within an agent |
| elevenlabs-tts | `local` | `npx skills@latest add inferen-sh/skills --skill elevenlabs-tts -y` | ElevenLabs text-to-speech: voice selection, streaming audio, multilingual. | `/elevenlabs-tts` | When adding text-to-speech audio output to an agent or app |
| elevenlabs-music | `local` | `npx skills@latest add inferen-sh/skills --skill elevenlabs-music -y` | ElevenLabs music generation: sound effects, background scores, audio export. | `/elevenlabs-music` | When generating background music or sound effects programmatically |

---

## Agentic Patterns

| Skill | Source | Scope | Install | Description | Trigger | When to use |
|-------|--------|-------|---------|-------------|---------|-------------|
| self-improving-agent | charon-fan/agent-playbook | `local` | `npx skills@latest add charon-fan/agent-playbook --skill self-improving-agent -y` | Self-improvement loop where the agent iteratively refines its own outputs. | `/self-improving-agent` | When iteratively refining an agent's outputs through self-evaluation loops |
| agenthub | alirezarezvani/claude-skills | `local` | `/plugin install agenthub@claude-code-skills` | Spawns N parallel subagents competing on the same task via git worktree isolation; evaluates by metric or LLM judge; merges the best branch. | `/agenthub` | When running parallel competing agents to find the best solution |
| autoresearch-agent | alirezarezvani/claude-skills | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Autonomous experiment loop that optimizes any file by a measurable metric. Edits, evaluates, keeps improvements, discards failures, loops indefinitely (Karpathy-inspired). | `/autoresearch-agent` | When autonomously optimising a file or model by a measurable metric |
| agent-designer | alirezarezvani/claude-skills | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Multi-agent system architecture patterns, tool design principles, communication strategies, performance evaluation frameworks. | `/agent-designer` | When architecting multi-agent systems with evaluation frameworks |

---

## Vercel AI SDK

| Skill | Source | Scope | Install | Description | Trigger | When to use |
|-------|--------|-------|---------|-------------|---------|-------------|
| ai-sdk | vercel/ai | `local` | `npx skills@latest add vercel/ai --skill ai-sdk -y` | Vercel AI SDK: streaming, tool calling, multi-step agents, model switching, edge deployment. | `/ai-sdk` | When building streaming AI features with Vercel AI SDK |
| agent-browser | vercel-labs | `local` | `npx skills@latest add vercel-labs/agent-browser --skill agent-browser -y` | Vercel browser agent: navigates, interacts with, and extracts content from live websites. | `/agent-browser` | When navigating and extracting content from websites via Vercel agent |
