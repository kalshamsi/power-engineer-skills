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
echo "=== GLOBAL ===" && ls ~/.claude/skills/ 2>/dev/null || echo "(none)"
echo "=== LOCAL ===" && ls .claude/skills/ 2>/dev/null || echo "(none)"
```

Filter all selections below against what's already installed.

---

## Skill selection

### Always add — Core methodology (global)

```bash
npx skills@latest add obra/superpowers/brainstorming --global
npx skills@latest add obra/superpowers/writing-plans --global
npx skills@latest add obra/superpowers/test-driven-development --global
npx skills@latest add obra/superpowers/systematic-debugging --global
npx skills@latest add obra/superpowers/verification-before-completion --global
npx skills@latest add obra/superpowers/requesting-code-review --global
npx skills@latest add obra/superpowers/receiving-code-review --global
npx skills@latest add obra/superpowers/subagent-driven-development --global
npx skills@latest add obra/superpowers/dispatching-parallel-agents --global
npx skills@latest add obra/superpowers/using-git-worktrees --global
npx skills@latest add obra/superpowers/finishing-a-development-branch --global
npx skills@latest add obra/superpowers/writing-skills --global
npx skills@latest add mattpocock/skills/grill-me --global
npx skills@latest add mattpocock/skills/write-a-prd --global
npx skills@latest add mattpocock/skills/prd-to-plan --global
npx skills@latest add mattpocock/skills/prd-to-issues --global
npx skills@latest add anthropics/skills/skill-creator --global
npx skills@latest add supercent-io/skills-template/security-best-practices --global
npx skills@latest add github/awesome-copilot/git-commit --global
npx skills@latest add supercent-io/skills-template/task-planning --global
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
