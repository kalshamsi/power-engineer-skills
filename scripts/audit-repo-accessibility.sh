#!/usr/bin/env bash
# audit-repo-accessibility.sh
# Checks every GitHub repo referenced in the power-engineer catalog.
# Outputs: ACCESSIBLE or INACCESSIBLE for each repo.
# Requires: gh CLI authenticated.

set -euo pipefail

REPOS=(
  "obra/superpowers"
  "obra/superpowers-marketplace"
  "mattpocock/skills"
  "github/awesome-copilot"
  "anthropics/skills"
  "anthropics/claude-cookbooks"
  "inferen-sh/skills"
  "browser-use/browser-use"
  "firecrawl/cli"
  "tavily-ai/skills"
  "charon-fan/agent-playbook"
  "vercel/ai"
  "vercel-labs/agent-browser"
  "vercel-labs/agent-skills"
  "vercel-labs/next-skills"
  "vercel/turborepo"
  "wshobson/agents"
  "supercent-io/skills-template"
  "alirezarezvani/claude-skills"
  "google-labs-code/stitch-skills"
  "hyf0/vue-skills"
  "antfu/skills"
  "shadcn/ui"
  "ehmo/platform-design-skills"
  "pbakaus/impeccable"
  "nextlevelbuilder/ui-ux-pro-max-skill"
  "Owl-Listener/designer-skills"
  "currents-dev/playwright-best-practices-skill"
  "expo/skills"
  "avdlee/swiftui-agent-skill"
  "microsoft/github-copilot-for-azure"
  "microsoft/azure-skills"
  "neondatabase/agent-skills"
  "supabase/agent-skills"
  "better-auth/skills"
  "getsentry/skills"
  "agamm/claude-code-owasp"
  "affaan-m/everything-claude-code"
  "MCKRUZ/security-review-skill"
  "trailofbits/skills"
  "majiayu000/claude-skill-registry"
  "TerminalSkills/skills"
  "AgentSecOps/SecOpsAgentKit"
  "Jeffallan/claude-skills"
  "sickn33/antigravity-awesome-skills"
  "kalshamsi/claude-security-skills"
  "Eyadkelleh/awesome-claude-skills-security"
  "WolzenGeorgi/claude-skills-pentest"
  "Sushegaad/Claude-Skills-Governance-Risk-and-Compliance"
  "Tencent/AI-Infra-Guard"
  "mukul975/Anthropic-Cybersecurity-Skills"
  "tsale/awesome-dfir-skills"
  "fr33d3m0n/threat-modeling"
  "garrytan/gstack"
  "jthack/ffuf_claude_skill"
  "larrygmaguire-hash/mcp-security-audit"
  "aliksir/claude-code-skill-security-check"
  "TheSethRose/Clawdbot-Security-Check"
  "alissonlinneker/shield-claude-skill"
  "ctsstc/get-shit-done-skills"
)

ACCESSIBLE=()
INACCESSIBLE=()

echo "=== Skill Repository Accessibility Audit ==="
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "Total repos to check: ${#REPOS[@]}"
echo ""

for repo in "${REPOS[@]}"; do
  if gh api "repos/${repo}" --silent 2>/dev/null; then
    echo "ACCESSIBLE: ${repo}"
    ACCESSIBLE+=("${repo}")
  else
    echo "INACCESSIBLE: ${repo}"
    INACCESSIBLE+=("${repo}")
  fi
done

echo ""
echo "=== SUMMARY ==="
echo "Accessible: ${#ACCESSIBLE[@]}"
echo "Inaccessible: ${#INACCESSIBLE[@]}"
echo ""

if [ ${#INACCESSIBLE[@]} -gt 0 ]; then
  echo "=== INACCESSIBLE REPOS (action required) ==="
  for repo in "${INACCESSIBLE[@]}"; do
    echo "  - ${repo}"
  done
fi

echo ""
echo "=== ACCESSIBLE REPOS ==="
for repo in "${ACCESSIBLE[@]}"; do
  echo "  - ${repo}"
done
