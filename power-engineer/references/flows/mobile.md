# Mobile Flow

Install mobile development skills for this project.

## Questions

Ask this question:

**Which mobile platform?**
1. React Native / Expo
2. SwiftUI / iOS native

---

## Detect installed skills

```bash
ls ~/.claude/skills/ .claude/skills/ 2>/dev/null || echo "(none)"
```

Filter all selections below against what's already installed.

---

## Skill selection

### Always add — Core methodology

```bash
npx skills@latest add obra/superpowers/brainstorming
npx skills@latest add obra/superpowers/writing-plans
npx skills@latest add obra/superpowers/test-driven-development
npx skills@latest add obra/superpowers/systematic-debugging
npx skills@latest add obra/superpowers/verification-before-completion
npx skills@latest add obra/superpowers/requesting-code-review
npx skills@latest add obra/superpowers/receiving-code-review
npx skills@latest add obra/superpowers/subagent-driven-development
npx skills@latest add obra/superpowers/dispatching-parallel-agents
npx skills@latest add obra/superpowers/using-git-worktrees
npx skills@latest add obra/superpowers/finishing-a-development-branch
npx skills@latest add obra/superpowers/writing-skills
npx skills@latest add mattpocock/skills/grill-me
npx skills@latest add mattpocock/skills/write-a-prd
npx skills@latest add mattpocock/skills/prd-to-plan
npx skills@latest add mattpocock/skills/prd-to-issues
npx skills@latest add anthropics/skills/skill-creator
npx skills@latest add supercent-io/skills-template/security-best-practices
npx skills@latest add github/awesome-copilot/git-commit
npx skills@latest add supercent-io/skills-template/task-planning
```

### Mobile skills (based on answer)

**If React Native / Expo:**
```bash
npx skills@latest add vercel-labs/agent-skills/vercel-react-native-skills
npx skills@latest add expo/skills/building-native-ui
npx skills@latest add expo/skills/native-data-fetching
npx skills@latest add expo/skills/upgrading-expo
npx skills@latest add expo/skills/expo-tailwind-setup
npx skills@latest add expo/skills/expo-cicd-workflows
npx skills@latest add expo/skills/expo-api-routes
npx skills@latest add expo/skills/expo-dev-client
npx skills@latest add expo/skills/expo-deployment
npx skills@latest add ehmo/platform-design-skills/platform-design-skills
```

**If SwiftUI / iOS:**
```bash
npx skills@latest add avdlee/swiftui-agent-skill/swiftui-expert-skill
npx skills@latest add ehmo/platform-design-skills/platform-design-skills
```

---

## Generate output

Read `references/shared/output-steps.md` and follow its instructions to
generate the install script, PLUGIN_INSTALLS.md, and the final summary.
