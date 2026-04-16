# I Tried Hundreds of Claude Code Skills So You Don't Have To

When Claude Code first introduced skills, I was excited. Reusable instruction sets that shape how Claude approaches your code? That sounded like the missing layer between "generic AI assistant" and "AI that actually knows how I work."

Then I tried to use them.

I didn't know which skills existed. I didn't know which ones were worth installing. I didn't know how to make them work together or how to tune them for my specific projects. The ecosystem was growing fast — GitHub repos popping up with dozens of skills each — but there was no map, no guide, no way to tell the signal from the noise.

So I did what any reasonable person would do: I tried all of them. Over a period of weeks, I installed, tested, broke, uninstalled, and re-tested skill after skill across my projects. Some were transformative. Many were redundant. A few were outright broken. By the end, I had a strong opinion about which skills actually matter — and an even stronger feeling that nobody should have to go through what I just went through.

That's why I built Power Engineer.

## What Power Engineer Does

Power Engineer is a skill for Claude Code that automates the entire process of discovering, installing, and configuring skills for your project. Instead of manually researching which skills exist, figuring out install commands, and hoping they work together — you run one command and let it handle the rest.

The system works as a five-stage pipeline:

```
┌─────────┐    ┌─────────────┐    ┌─────────┐    ┌─────────┐    ┌───────────┐
│  Scan   │───▶│  Interview  │───▶│ Resolve │───▶│ Install │───▶│ Configure │
│codebase │    │ adaptively  │    │  skills │    │directly │    │  project  │
└─────────┘    └─────────────┘    └─────────┘    └─────────┘    └───────────┘
```

First, it **scans** your codebase — reading package.json, config files, infrastructure definitions, even your git history — to build a profile of your project. Language, framework, cloud services, team size, project maturity. It figures out as much as it can before asking you anything.

Then it **interviews** you, but only about the things it couldn't detect. If your package.json already tells it you're using Next.js, it won't ask you what framework you're using. If it spots Terraform files, it won't ask about your infrastructure. More on this in a moment.

From there, it **resolves** the right set of skills — deduplicating, filtering out what you already have, and generating correct install commands. It **installs** them directly with real-time progress tracking. And finally, it **configures** your project — generating context files, brand identity, and project-aware patches so the skills actually understand your specific codebase.

The whole thing runs through 14 different commands. Full interview, quick auto-detect mode, domain-specific flows for frontend, backend, DevOps, AI, data, mobile, and docs. Plus status checks, updates, a browsable catalog, and a help command that shows you what's installed and when to use each skill.

## The Adaptive Questionnaire

The interview system was one of the hardest parts to get right, and the one I'm most proud of.

Most setup tools ask you a fixed list of questions regardless of context. Power Engineer has 13 possible questions organized into 6 batches, but the scanner's findings determine which ones you actually see. If it detected your framework, that question disappears. If it found cloud service configurations, it skips the infrastructure question. A typical run asks 5-7 questions instead of all 13.

But it goes further than just skipping. The questionnaire is adaptive — it can *add* questions based on what it discovers. If the scanner detects patterns that suggest specific needs (say, brand assets in your repo, or multiple AI SDK imports), it surfaces targeted follow-up questions that a generic questionnaire would never think to ask. The result is that each project gets a tailored conversation, not a one-size-fits-all form.

This matters because the quality of skill recommendations depends entirely on the quality of the input. Ask too many questions and people disengage. Ask too few and you miss critical context. The adaptive approach threads that needle — it gathers exactly what it needs and nothing more.

## Drift Detection

Here's something I didn't plan for initially but turned out to be essential: projects change.

You install your skills on day one and everything is dialed in. Three weeks later, you've added a new database, switched your auth provider, and started using a framework you hadn't considered when you first set things up. Your skill stack is now stale, but you don't know it — and even if you did, running the full setup again feels wasteful.

Power Engineer solves this with drift detection. After the initial setup, it saves a snapshot of your project state — your dependencies, your structure, your scan results, your questionnaire answers. When you run `/power-engineer update`, it compares the current state against that snapshot and surfaces exactly what changed.

New dependency that suggests a skill you don't have? It tells you. Removed a framework you had skills for? It flags the orphaned skills. Changed your infrastructure? It recommends the relevant additions. You review the diff, accept what makes sense, and it installs only the new recommendations. No redundant questions, no duplicate installs, no starting from scratch.

This persistent state is what turns Power Engineer from a one-time setup tool into something that grows with your project. It remembers what it did, knows what changed, and adapts accordingly.

## Curating 238 Skills

Building the pipeline was one challenge. Filling it with quality recommendations was another.

The skill catalog that Power Engineer draws from contains 238 skills sourced from 59 GitHub repositories. I didn't build most of these skills — the Claude Code community did. My job was to find them, evaluate them, and organize them into something navigable.

The process was part community research, part hands-on validation. I tracked down skills through GitHub searches, community posts, Anthropic's documentation, and recommendations from other developers building with Claude Code. For each one, I verified that it actually installs correctly (you'd be surprised how many had broken install syntax), that it meaningfully changes Claude's behavior, and that it doesn't conflict with other skills in the catalog.

The catalog spans 16 categories: core methodology, backend architecture, DevOps, data and ML, security (which alone accounts for over 200 entries including MCP servers), frontend frameworks, design systems, mobile, cloud platforms, documentation, and more. Each skill is tagged with its trigger conditions — the situations where Claude should activate it — so the resolver can match skills to your project's actual needs.

Organizing this was less like building a package registry and more like writing a recommendation engine's knowledge base. The catalog isn't just a list; it's an opinionated guide to what works.

## What I Learned

The biggest surprise was how much state management matters for a tool like this.

My first version was stateless. Run it, get your skills, done. But in practice, that meant every re-run was a fresh start. It would recommend skills you already had. It would ask questions you'd already answered. It couldn't tell if your project had evolved in ways that warranted new skills. The experience was fine the first time and frustrating every time after.

Adding persistent state — the snapshot, the drift detection, the install history — transformed the tool from something you use once into something that remains useful. It's the difference between a setup wizard and a project companion. I underestimated this at the start, and now I'd consider state management a first-class design concern for any developer tool that touches project configuration.

The other lesson was about the value of progressive disclosure. The entire system is built in markdown — no traditional code, no external dependencies. That constraint forced a modular architecture where each module is a separate file, loaded only when needed. The router is 57 lines. It points to flows, which point to modules, which do the actual work. Claude only reads what's relevant to the current command, keeping the context window lean. What started as a limitation became one of the system's strengths.

## Where It Stands Today

Power Engineer doesn't just install skills — it understands your project and keeps understanding it as things change. The adaptive questionnaire means you're never answering unnecessary questions. The drift detection means your skill stack evolves with your codebase. And the curated catalog means someone has already done the work of figuring out what's worth using.

For me, it eliminated the confusion that made Claude Code skills feel inaccessible when I first encountered them. Setting up a new project went from a research project to a conversation. Keeping skills current went from something I never did to something that happens naturally.

The project is actively evolving — there are always new skills emerging from the community, new patterns to support, and new ways to make the setup experience smarter. It's the kind of tool that gets better the more projects use it.
