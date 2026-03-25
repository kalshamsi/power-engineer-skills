# Help Flow

Show the user their installed skills with trigger phrases and usage hints.

## Step 1: Check for setup

Check if `.power-engineer/state.json` exists.

If it does not exist, respond with:
> No Power Engineer setup found. Run `/power-engineer` first to install skills.

Then stop. Do not proceed.

## Step 2: Read installed skills

Read `.power-engineer/state.json` and extract the `installed_skills` array.

If the array is empty, respond with:
> No skills installed yet. Run `/power-engineer` to set up your skill stack.

Then stop. Do not proceed.

## Step 3: Look up trigger data

For each installed skill, find its entry in the catalog files under
`references/catalog/`. Read the INDEX.md first, then look up each skill
in its category file. Extract the `Trigger` and `When to use` columns.

## Step 4: Group and display

Group skills by their catalog category. Display in this format:

```
Your installed skills:

## Core Methodology
  /brainstorming         — Before starting any new feature or design
  /writing-plans         — After brainstorming, to break work into tasks
  ...

## Security
  /security-review       — When performing a security review on any codebase
  ...

[N] skills installed. See .power-engineer/cheatsheet.md for offline reference.
```

### Notes
- Only show skills, not MCP servers
- Only show installed skills (from state.json), not the full catalog
- The catalog cross-reference is needed because state.json stores skill names
  and repos, but not trigger/when-to-use data
