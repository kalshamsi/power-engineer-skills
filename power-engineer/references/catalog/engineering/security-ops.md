# Security & Operations

## Security

| Skill | Source | Scope | Install | Description |
|-------|--------|-------|---------|-------------|
| security-best-practices | supercent-io | `--global` | `npx skills@latest add supercent-io/skills-template/security-best-practices --global` | OWASP-aligned: auth, input validation, secrets management, dependency auditing. |
| skill-security-auditor | alirezarezvani/claude-skills | `local` | `/plugin install skill-security-auditor@claude-code-skills` | Pre-install security gate for AI agent skills: scans for malicious code, prompt injection, dependency supply chain risks, file system boundary violations. |

---

## Incident Response & Operations — alirezarezvani/claude-skills

| Skill | Scope | Install | Description |
|-------|-------|---------|-------------|
| incident-commander | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Incident response workflows: severity classification, communication templates, escalation procedures, post-mortem generation. |
| env-secrets-manager | `local` | `/plugin install engineering-advanced-skills@claude-code-skills` | Secrets rotation, vault integration, .env management, security configuration across environments. |
