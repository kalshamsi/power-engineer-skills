# Install Script Template

Generate `install-skills.sh` in the current working directory using this exact format.

Replace all `[bracketed]` placeholders with actual values from the questionnaire.

```bash
#!/usr/bin/env bash
# =============================================================
# Power Engineer Skills Installer
# Project:  [current working directory name]
# Date:     [today's date]
# Type:     [Q1 answers]
# Stack:    [Q2+Q3 answers]
# =============================================================
# Review this file before running.
# Run: chmod +x install-skills.sh && ./install-skills.sh
# =============================================================

set -e

echo ""
echo "Power Engineer Skills Installer"
echo "================================"
echo ""

# -- Global skills (available across all your projects) ----------------------
echo "Installing global skills..."
echo ""

[one command per line, each preceded by:  echo "  -> skill-name"]

# -- Local skills (scoped to this project only) ------------------------------
echo ""
echo "Installing local skills..."
echo ""

[one command per line, each preceded by:  echo "  -> skill-name"]

# -- Skipped (already installed) ---------------------------------------------
# [list of SKIPPED lines as comments]

echo ""
echo "Done. [N] skills installed, [N] skipped (already present)."
echo ""
echo "Next steps:"
echo "  1. Open PLUGIN_INSTALLS.md in this directory"
echo "  2. Follow those steps inside Claude Code"
echo "  3. Run /mcp inside Claude Code to verify MCP connections"
echo ""
```
