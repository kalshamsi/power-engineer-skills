# Security & Operations

## Security Code Review

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| security-review | getsentry/skills | `npx skills@latest add getsentry/skills --skill security-review -y` | **[TOP PICK]** Confidence-based severity (HIGH/MEDIUM/LOW), data-flow tracing, low false positives. Independently rated #1 security review skill. |
| claude-code-owasp | agamm/claude-code-owasp | `npx skills@latest add agamm/claude-code-owasp -y` | OWASP Top 10:2025, ASVS 5.0, Agentic AI security (ASI01-ASI10), 20+ language support. |
| security-review | affaan-m/everything-claude-code | `npx skills@latest add affaan-m/everything-claude-code --skill security-review -y` | Auth, user input, secrets, API endpoints, payment features checklist. |
| security-review-skill | MCKRUZ/security-review-skill | `npx skills@latest add MCKRUZ/security-review-skill -y` | Auth, secrets, input validation, API endpoints checklist. |
| differential-review | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill differential-review -y` | Security-focused diff review with git history analysis. |
| fp-check | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill fp-check -y` | Systematic false positive verification for security findings. |

---

## SAST (Static Analysis)

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| semgrep-rule-creator | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill semgrep-rule-creator -y` | Create custom Semgrep rules for vulnerability detection. |
| semgrep-rule-variant-creator | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill semgrep-rule-variant-creator -y` | Port Semgrep rules to new languages with test-driven validation. |
| static-analysis | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill static-analysis -y` | Static analysis toolkit with CodeQL, Semgrep, and SARIF parsing. |
| variant-analysis | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill variant-analysis -y` | Find similar vulnerabilities across codebases using pattern analysis. |
| codeql | github/awesome-copilot | `npx skills@latest add github/awesome-copilot --skill codeql -y` | Comprehensive CodeQL code scanning via GitHub Actions and CLI. |
| sast-configuration | sickn33/antigravity-awesome-skills | `npx skills@latest add sickn33/antigravity-awesome-skills --skill sast-configuration -y` | SAST tool setup for Semgrep/SonarQube/CodeQL. |

---

## DAST (Dynamic Analysis)

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| dast-nuclei | majiayu000/claude-skill-registry | `npx skills@latest add majiayu000/claude-skill-registry --skill dast-nuclei -y` | DAST scanning with Nuclei templates, CVE detection, OWASP testing. |
| nuclei-scanner | TerminalSkills/skills | `npx skills@latest add TerminalSkills/skills --skill nuclei-scanner -y` | Vulnerability scanning with Nuclei, CVE detection. |
| ffuf-claude-skill | jthack/ffuf_claude_skill | `npx skills@latest add jthack/ffuf_claude_skill -y` | FFUF web fuzzing and reconnaissance. |

---

## Secrets Detection

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| gitleaks | majiayu000/claude-skill-registry | `npx skills@latest add majiayu000/claude-skill-registry --skill gitleaks -y` | Secret detection with Gitleaks. |
| review-trufflehog | majiayu000/claude-skill-registry | `npx skills@latest add majiayu000/claude-skill-registry --skill review-trufflehog -y` | Review and triage TruffleHog scan results, prioritize verified findings. |
| secrets-guardian | majiayu000/claude-skill-registry | `npx skills@latest add majiayu000/claude-skill-registry --skill secrets-guardian -y` | detect-secrets scanning across all files. |
| cookbook-audit | anthropics/claude-cookbooks | `npx skills@latest add anthropics/claude-cookbooks --skill cookbook-audit -y` | detect-secrets scanning for hardcoded API keys with custom patterns. |
| Clawdbot-Security-Check | TheSethRose/Clawdbot-Security-Check | `npx skills@latest add TheSethRose/Clawdbot-Security-Check -y` | Dynamic security posture audit with detect-secrets config checking. |

---

## SCA (Dependency Security)

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| supply-chain-risk-auditor | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill supply-chain-risk-auditor -y` | Audit supply chain risks in project dependencies. |
| security-reviewer | Jeffallan/claude-skills | `npx skills@latest add Jeffallan/claude-skills --skill security-reviewer -y` | Multi-tool: npm audit, Trivy, Gitleaks, TruffleHog, Semgrep, Bandit, Checkov. |

---

## Container Security

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| trivy | majiayu000/claude-skill-registry | `npx skills@latest add majiayu000/claude-skill-registry --skill trivy -y` | Container images, filesystems, and IaC scanning. |
| container-grype | AgentSecOps/SecOpsAgentKit | `npx skills@latest add AgentSecOps/SecOpsAgentKit --skill container-grype -y` | Container security, SCA, SBOM, CVSS, CVE scanning. |
| grype | TerminalSkills/skills | `npx skills@latest add TerminalSkills/skills --skill grype -y` | Grype scanner with CI/CD integration and Syft SBOM. |

---

## IaC Security

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| iac-checkov | AgentSecOps/SecOpsAgentKit | `npx skills@latest add AgentSecOps/SecOpsAgentKit --skill iac-checkov -y` | Checkov for Terraform, K8s, CloudFormation compliance. |
| checkov | TerminalSkills/skills | `npx skills@latest add TerminalSkills/skills --skill checkov -y` | Checkov IaC static analysis and custom policy writing. |
| iac-scanner | majiayu000/claude-skill-registry | `npx skills@latest add majiayu000/claude-skill-registry --skill iac-scanner -y` | tfsec + Checkov for multi-cloud IaC scanning. |

---

## Threat Modeling

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| threat-modeling | fr33d3m0n/threat-modeling | `npx skills@latest add fr33d3m0n/threat-modeling -y` | STRIDE/DREAD, MITRE ATT&CK mapping, OWASP MCP Top 10. |
| cso | garrytan/gstack | `npx skills@latest add garrytan/gstack --skill cso -y` | CSO perspective: STRIDE, OWASP, supply chain, LLM/AI security. |
| insecure-defaults | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill insecure-defaults -y` | Detect insecure defaults, hardcoded creds, fail-open patterns. |
| sharp-edges | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill sharp-edges -y` | Identify dangerous APIs and footgun designs. |

---

## Compliance (SOC2, HIPAA, PCI-DSS, GDPR)

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| governance-risk-compliance | Sushegaad/Claude-Skills-Governance-Risk-and-Compliance | `npx skills@latest add Sushegaad/Claude-Skills-Governance-Risk-and-Compliance -y` | **[99% eval]** ISO 27001, SOC 2, FedRAMP, GDPR, HIPAA. |
| owasp-asi | Tencent/AI-Infra-Guard | `npx skills@latest add Tencent/AI-Infra-Guard --skill owasp-asi -y` | OWASP Top 10 for Agentic Applications 2026 classification. |

---

## Penetration Testing

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| awesome-claude-skills-security | Eyadkelleh/awesome-claude-skills-security | `npx skills@latest add Eyadkelleh/awesome-claude-skills-security -y` | SecLists, injection payloads, pentest/CTF/bug-bounty agents. |
| claude-skills-pentest | WolzenGeorgi/claude-skills-pentest | `npx skills@latest add WolzenGeorgi/claude-skills-pentest -y` | Automated pentesting with VPS scanner. |
| burpsuite-project-parser | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill burpsuite-project-parser -y` | Parse Burp Suite project files for analysis. |
| agentic-actions-auditor | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill agentic-actions-auditor -y` | Audit GitHub Actions for AI agent security risks. |

---

## Smart Contract & Crypto Security

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| building-secure-contracts | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill building-secure-contracts -y` | Secure smart contract patterns, 6 blockchain scanners. |
| constant-time-analysis | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill constant-time-analysis -y` | Detect timing side-channels in cryptographic code. |
| zeroize-audit | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill zeroize-audit -y` | Audit memory zeroization for sensitive data handling. |
| yara-authoring | trailofbits/skills | `npx skills@latest add trailofbits/skills --skill yara-authoring -y` | YARA detection rule authoring for malware/threat detection. |

---

## Framework-Specific Security

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| django-security | affaan-m/everything-claude-code | `npx skills@latest add affaan-m/everything-claude-code --skill django-security -y` | Django: CSRF, SQLi, XSS, secure deployment. |
| laravel-security | affaan-m/everything-claude-code | `npx skills@latest add affaan-m/everything-claude-code --skill laravel-security -y` | Laravel: auth, validation, CSRF, mass assignment. |
| springboot-security | affaan-m/everything-claude-code | `npx skills@latest add affaan-m/everything-claude-code --skill springboot-security -y` | Spring Security: auth, CSRF, headers, rate limiting. |
| perl-security | affaan-m/everything-claude-code | `npx skills@latest add affaan-m/everything-claude-code --skill perl-security -y` | Perl: taint mode, DBI parameterized queries. |

---

## Multi-Tool / Comprehensive

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| shield-claude-skill | alissonlinneker/shield-claude-skill | `npx skills@latest add alissonlinneker/shield-claude-skill -y` | Registers Semgrep + Gitleaks + Trivy as callable Claude tools. |
| security (007) | sickn33/antigravity-awesome-skills | `npx skills@latest add sickn33/antigravity-awesome-skills --skill 007 -y` | Full audit: STRIDE/PASTA, Red/Blue Team, OWASP, incident response. |
| anthropic-cybersecurity-skills | mukul975/Anthropic-Cybersecurity-Skills | `npx skills@latest add mukul975/Anthropic-Cybersecurity-Skills -y` | 734+ cybersecurity skills across 26 domains, MITRE ATT&CK mapped. |

---

## Incident Response & DFIR

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| awesome-dfir-skills | tsale/awesome-dfir-skills | `npx skills@latest add tsale/awesome-dfir-skills -y` | Digital Forensics and Incident Response skills for InfoSec. |
| incident-commander | alirezarezvani/claude-skills | `/plugin install engineering-advanced-skills@claude-code-skills` | Incident response workflows: severity classification, communication templates, escalation, post-mortems. |
| env-secrets-manager | alirezarezvani/claude-skills | `/plugin install engineering-advanced-skills@claude-code-skills` | Secrets rotation, vault integration, .env management across environments. |

---

## Skill & MCP Security (Meta)

| Skill | Source | Install | Description |
|-------|--------|---------|-------------|
| claude-code-skill-security-check | aliksir/claude-code-skill-security-check | `npx skills@latest add aliksir/claude-code-skill-security-check -y` | Scan skills for prompt injection, data exfiltration, permission bypass, supply chain risks. |
| mcp-security-audit | larrygmaguire-hash/mcp-security-audit | `npx skills@latest add larrygmaguire-hash/mcp-security-audit -y` | Audit MCP servers before installation. |
| safety-guard | affaan-m/everything-claude-code | `npx skills@latest add affaan-m/everything-claude-code --skill safety-guard -y` | Prevent destructive ops: rm -rf, force push, DROP TABLE, chmod 777. |

---

## Security MCP Servers

### Official Vendor

| Server | Register Command | Description |
|--------|-----------------|-------------|
| semgrep-mcp | `claude mcp add semgrep -- uvx semgrep-mcp` | Official Semgrep SAST across all languages. |
| snyk-studio-mcp | `claude mcp add snyk -- snyk mcp --experimental` | 11 tools: SAST, SCA, IaC, containers, SBOM. Requires Snyk CLI. |
| trivy-mcp | `claude mcp add trivy -- trivy mcp` | Filesystem, container, IaC scanning. Requires `trivy plugin install mcp`. |
| codeql-mcp | `claude mcp add codeql -- npx -y codeql-development-mcp-server` | CodeQL security research query development. |
| aikido-mcp | `claude mcp add aikido --env AIKIDO_API_KEY=TOKEN -- npx -y @aikidosec/mcp` | SAST + secrets for AI-generated code. |
| sonarqube-mcp | `claude mcp add sonarqube --env SONARQUBE_TOKEN=TOKEN --env SONARQUBE_URL=URL -- docker run --init -i --rm -e SONARQUBE_TOKEN -e SONARQUBE_URL mcp/sonarqube` | Code quality and security analysis. |

### Multi-Tool Aggregators

| Server | Register Command | Description |
|--------|-----------------|-------------|
| pentestMCP | `claude mcp add pentestMCP -- docker run --rm -i ramgameer/pentest-mcp:latest` | 20+ pentest tools, pre-built Docker image. |
| mcp-security-hub | `docker-compose build` (38 servers) | 38 MCP servers: Nmap, Nuclei, SQLMap, Radare2, Ghidra, YARA. |
| aws-security-scanner | `claude mcp add security-scanner -- uvx --from git+https://github.com/aws-samples/sample-mcp-security-scanner.git@main security_scanner_mcp_server` | AWS: Checkov + Semgrep + Bandit delta scanning. |

### Reconnaissance & Threat Intel

| Server | Register Command | Description |
|--------|-----------------|-------------|
| mcp-shodan | `claude mcp add shodan --env SHODAN_API_KEY=KEY -- npx -y @burtthecoder/mcp-shodan` | IP lookup, device search, CVE lookup. |
| mcp-virustotal | `claude mcp add virustotal --env VIRUSTOTAL_API_KEY=KEY -- npx -y @burtthecoder/mcp-virustotal` | URL, file, IP, domain threat analysis. |
| google-secops-mcp | `claude mcp add secops -- uvx --from google-secops-mcp secops_mcp` | Google Chronicle + Mandiant threat intelligence. |
| burp-suite-mcp | `claude mcp add burp -- java -jar mcp-proxy-all.jar --sse-url http://127.0.0.1:9876` | Burp Suite: HTTP crafting, proxy history, Collaborator. |

### MCP Security Scanners

| Tool | Install | Description |
|------|---------|-------------|
| mcp-scan | `pip install mcp-scan && mcp-scan` | Scan MCP installs for tool poisoning, rug pulls, prompt injection. |
| snyk-agent-scan | `pip install agent-scan` | Scan AI agents, MCP servers, and skills for 15+ risks. |
| mcp-checkpoint | `pip install mcp-checkpoint && mcp-checkpoint scan` | MCP discovery, analysis, drift detection. |
