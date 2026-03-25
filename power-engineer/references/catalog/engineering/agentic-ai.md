# Agentic AI & LLM Engineering

## AI/LLM SDKs — inferen-sh/skills

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| python-sdk | `local` | `npx skills@latest add inferen-sh/skills --skill python-sdk -y` | Anthropic Python SDK: async usage, streaming, tool use, batch processing. |
| javascript-sdk | `local` | `npx skills@latest add inferen-sh/skills --skill javascript-sdk -y` | Anthropic JS/TS SDK: client setup, error handling, token management, streaming. |
| chat-ui | `local` | `npx skills@latest add inferen-sh/skills --skill chat-ui -y` | Production chat UI: streaming responses, message history, tool call rendering. |
| agent-ui | `local` | `npx skills@latest add inferen-sh/skills --skill agent-ui -y` | Agent-specific UI: tool use visualisation, step tracking, human approval flows. |
| tools-ui | `local` | `npx skills@latest add inferen-sh/skills --skill tools-ui -y` | UI patterns for rendering tool calls, results, and intermediate agent steps. |
| widgets-ui | `local` | `npx skills@latest add inferen-sh/skills --skill widgets-ui -y` | Embeddable widget patterns for AI-powered components within larger apps. |
| web-search | `local` | `npx skills@latest add inferen-sh/skills --skill web-search -y` | Structured web search integration for grounding AI responses in current information. |
| python-executor | `local` | `npx skills@latest add inferen-sh/skills --skill python-executor -y` | Safe Python code execution within agent sessions for data processing. |
| agent-browser | `local` | `npx skills@latest add inferen-sh/skills --skill agent-browser -y` | Browser automation from within agent sessions: navigation, extraction, interaction. |
| ai-image-generation | `local` | `npx skills@latest add inferen-sh/skills --skill ai-image-generation -y` | AI image generation: prompt engineering, model selection, output handling. |
| elevenlabs-tts | `local` | `npx skills@latest add inferen-sh/skills --skill elevenlabs-tts -y` | ElevenLabs text-to-speech: voice selection, streaming audio, multilingual. |
| elevenlabs-music | `local` | `npx skills@latest add inferen-sh/skills --skill elevenlabs-music -y` | ElevenLabs music generation: sound effects, background scores, audio export. |

---

## Agentic Patterns

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| self-improving-agent | charon-fan/agent-playbook | `local` | `npx skills@latest add charon-fan/agent-playbook --skill self-improving-agent -y` | Self-improvement loop where the agent iteratively refines its own outputs. |
| agenthub | alirezarezvani/claude-skills | `local` | `/plugin install agenthub@claude-code-skills` | Spawns N parallel subagents competing on the same task via git worktree isolation; evaluates by metric or LLM judge; merges the best branch. |
| autoresearch-agent | alirezarezvani/claude-skills | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Autonomous experiment loop that optimizes any file by a measurable metric. Edits, evaluates, keeps improvements, discards failures, loops indefinitely (Karpathy-inspired). |
| agent-designer | alirezarezvani/claude-skills | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Multi-agent system architecture patterns, tool design principles, communication strategies, performance evaluation frameworks. |

---

## Vercel AI SDK

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| ai-sdk | vercel/ai | `local` | `npx skills@latest add vercel/ai --skill ai-sdk -y` | Vercel AI SDK: streaming, tool calling, multi-step agents, model switching, edge deployment. |
| agent-browser | vercel-labs | `local` | `npx skills@latest add vercel-labs/agent-browser --skill agent-browser -y` | Vercel browser agent: navigates, interacts with, and extracts content from live websites. |
