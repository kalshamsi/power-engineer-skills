# Agentic AI & LLM Engineering

## AI/LLM SDKs — inferen-sh/skills

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| python-sdk | `local` | `npx skills@latest add inferen-sh/skills/python-sdk` | Anthropic Python SDK: async usage, streaming, tool use, batch processing. |
| javascript-sdk | `local` | `npx skills@latest add inferen-sh/skills/javascript-sdk` | Anthropic JS/TS SDK: client setup, error handling, token management, streaming. |
| chat-ui | `local` | `npx skills@latest add inferen-sh/skills/chat-ui` | Production chat UI: streaming responses, message history, tool call rendering. |
| agent-ui | `local` | `npx skills@latest add inferen-sh/skills/agent-ui` | Agent-specific UI: tool use visualisation, step tracking, human approval flows. |
| tools-ui | `local` | `npx skills@latest add inferen-sh/skills/tools-ui` | UI patterns for rendering tool calls, results, and intermediate agent steps. |
| widgets-ui | `local` | `npx skills@latest add inferen-sh/skills/widgets-ui` | Embeddable widget patterns for AI-powered components within larger apps. |
| web-search | `local` | `npx skills@latest add inferen-sh/skills/web-search` | Structured web search integration for grounding AI responses in current information. |
| python-executor | `local` | `npx skills@latest add inferen-sh/skills/python-executor` | Safe Python code execution within agent sessions for data processing. |
| agent-browser | `local` | `npx skills@latest add inferen-sh/skills/agent-browser` | Browser automation from within agent sessions: navigation, extraction, interaction. |
| ai-image-generation | `local` | `npx skills@latest add inferen-sh/skills/ai-image-generation` | AI image generation: prompt engineering, model selection, output handling. |
| elevenlabs-tts | `local` | `npx skills@latest add inferen-sh/skills/elevenlabs-tts` | ElevenLabs text-to-speech: voice selection, streaming audio, multilingual. |
| elevenlabs-music | `local` | `npx skills@latest add inferen-sh/skills/elevenlabs-music` | ElevenLabs music generation: sound effects, background scores, audio export. |

---

## Agentic Patterns

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| self-improving-agent | charon-fan/agent-playbook | `local` | `npx skills@latest add charon-fan/agent-playbook/self-improving-agent` | Self-improvement loop where the agent iteratively refines its own outputs. |
| agenthub | alirezarezvani/claude-skills | `local` | `/plugin install agenthub@claude-code-skills` | Spawns N parallel subagents competing on the same task via git worktree isolation; evaluates by metric or LLM judge; merges the best branch. |
| autoresearch-agent | alirezarezvani/claude-skills | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Autonomous experiment loop that optimizes any file by a measurable metric. Edits, evaluates, keeps improvements, discards failures, loops indefinitely (Karpathy-inspired). |
| agent-designer | alirezarezvani/claude-skills | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Multi-agent system architecture patterns, tool design principles, communication strategies, performance evaluation frameworks. |

---

## Vercel AI SDK

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| ai-sdk | vercel/ai | `local` | `npx skills@latest add vercel/ai/ai-sdk` | Vercel AI SDK: streaming, tool calling, multi-step agents, model switching, edge deployment. |
| agent-browser | vercel-labs | `local` | `npx skills@latest add vercel-labs/agent-browser/agent-browser` | Vercel browser agent: navigates, interacts with, and extracts content from live websites. |
