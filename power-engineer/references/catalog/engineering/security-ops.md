# Security & Operations

## Security Code Review

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| security-review | getsentry/skills | `npx skills add getsentry/skills --skill security-review -y` | **[TOP PICK]** Confidence-based severity (HIGH/MEDIUM/LOW), data-flow tracing, low false positives. Independently rated #1 security review skill. | `/security-review` | When performing a high-confidence security review on any codebase |
| claude-code-owasp | agamm/claude-code-owasp | `npx skills add agamm/claude-code-owasp -y` | OWASP Top 10:2025, ASVS 5.0, Agentic AI security (ASI01-ASI10), 20+ language support. | `/claude-code-owasp` | When auditing against OWASP Top 10 and Agentic AI security standards |
| security-review | affaan-m/everything-claude-code | `npx skills add affaan-m/everything-claude-code --skill security-review -y` | Auth, user input, secrets, API endpoints, payment features checklist. | `/security-review` | When doing a checklist-driven security review of auth and inputs |
| security-review-skill | MCKRUZ/security-review-skill | `npx skills add MCKRUZ/security-review-skill -y` | Auth, secrets, input validation, API endpoints checklist. | `/security-review-skill` | When auditing auth, secrets, and API endpoint security posture |
| differential-review | trailofbits/skills | `npx skills add trailofbits/skills --skill differential-review -y` | Security-focused diff review with git history analysis. | `/differential-review` | When reviewing a security-sensitive diff against git history |
| fp-check | trailofbits/skills | `npx skills add trailofbits/skills --skill fp-check -y` | Systematic false positive verification for security findings. | `/fp-check` | When verifying whether a security finding is a false positive |

---

## SAST (Static Analysis)

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| semgrep-rule-creator | trailofbits/skills | `npx skills add trailofbits/skills --skill semgrep-rule-creator -y` | Create custom Semgrep rules for vulnerability detection. | `/semgrep-rule-creator` | When writing custom Semgrep detection rules for specific vulnerabilities |
| semgrep-rule-variant-creator | trailofbits/skills | `npx skills add trailofbits/skills --skill semgrep-rule-variant-creator -y` | Port Semgrep rules to new languages with test-driven validation. | `/semgrep-rule-variant-creator` | When porting existing Semgrep rules to a new language |
| static-analysis | trailofbits/skills | `npx skills add trailofbits/skills --skill static-analysis -y` | Static analysis toolkit with CodeQL, Semgrep, and SARIF parsing. | `/static-analysis` | When running static analysis with CodeQL, Semgrep, or parsing SARIF |
| variant-analysis | trailofbits/skills | `npx skills add trailofbits/skills --skill variant-analysis -y` | Find similar vulnerabilities across codebases using pattern analysis. | `/variant-analysis` | When finding variants of a known vulnerability across a codebase |
| codeql | github/awesome-copilot | `npx skills add github/awesome-copilot --skill codeql -y` | Comprehensive CodeQL code scanning via GitHub Actions and CLI. | `/codeql` | When running CodeQL scans via GitHub Actions or CLI |
| sast-configuration | sickn33/antigravity-awesome-skills | `npx skills add sickn33/antigravity-awesome-skills --skill sast-configuration -y` | SAST tool setup for Semgrep/SonarQube/CodeQL. | `/sast-configuration` | When configuring SAST tooling for a new project |
| bandit-sast | kalshamsi/claude-security-skills | `npx skills add kalshamsi/claude-security-skills --skill bandit-sast -y` | Python SAST scanning via Bandit with fallback manual checks. | `/bandit-sast` | When running Python-specific SAST with Bandit and manual fallback |

---

## DAST (Dynamic Analysis)

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| dast-nuclei | majiayu000/claude-skill-registry | `npx skills add majiayu000/claude-skill-registry --skill dast-nuclei -y` | DAST scanning with Nuclei templates, CVE detection, OWASP testing. | `/dast-nuclei` | When running dynamic scanning with Nuclei templates against a live target |
| nuclei-scanner | TerminalSkills/skills | `npx skills add TerminalSkills/skills --skill nuclei-scanner -y` | Vulnerability scanning with Nuclei, CVE detection. | `/nuclei-scanner` | When scanning for known CVEs with Nuclei against a running service |
| ffuf-claude-skill | jthack/ffuf_claude_skill | `npx skills add jthack/ffuf_claude_skill -y` | FFUF web fuzzing and reconnaissance. | `/ffuf-claude-skill` | When fuzzing web endpoints for hidden paths or parameters |

---

## Secrets Detection

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| gitleaks | majiayu000/claude-skill-registry | `npx skills add majiayu000/claude-skill-registry --skill gitleaks -y` | Secret detection with Gitleaks. | `gitleaks` | When scanning a repo for accidentally committed secrets |
| review-trufflehog | majiayu000/claude-skill-registry | `npx skills add majiayu000/claude-skill-registry --skill review-trufflehog -y` | Review and triage TruffleHog scan results, prioritize verified findings. | `/review-trufflehog` | When triaging and prioritising TruffleHog secret findings |
| secrets-guardian | majiayu000/claude-skill-registry | `npx skills add majiayu000/claude-skill-registry --skill secrets-guardian -y` | detect-secrets scanning across all files. | `/secrets-guardian` | When scanning all project files for hardcoded secrets |
| cookbook-audit | anthropics/claude-cookbooks | `npx skills add anthropics/claude-cookbooks --skill cookbook-audit -y` | detect-secrets scanning for hardcoded API keys with custom patterns. | `/cookbook-audit` | When auditing code for hardcoded API keys with custom detection patterns |
| Clawdbot-Security-Check | TheSethRose/Clawdbot-Security-Check | `npx skills add TheSethRose/Clawdbot-Security-Check -y` | Dynamic security posture audit with detect-secrets config checking. | `/Clawdbot-Security-Check` | When running a dynamic security posture audit with secrets config check |

---

## SCA (Dependency Security)

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| supply-chain-risk-auditor | trailofbits/skills | `npx skills add trailofbits/skills --skill supply-chain-risk-auditor -y` | Audit supply chain risks in project dependencies. | `/supply-chain-risk-auditor` | When auditing project dependencies for supply chain vulnerabilities |
| security-reviewer | Jeffallan/claude-skills | `npx skills add Jeffallan/claude-skills --skill security-reviewer -y` | Multi-tool: npm audit, Trivy, Gitleaks, TruffleHog, Semgrep, Bandit, Checkov. | `/security-reviewer` | When running a comprehensive multi-tool security scan across all dimensions |
| socket-sca | kalshamsi/claude-security-skills | `npx skills add kalshamsi/claude-security-skills --skill socket-sca -y` | Supply chain security analysis via Socket.dev CLI. | `/socket-sca` | When performing supply chain security analysis with Socket.dev |

---

## Container Security

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| trivy | majiayu000/claude-skill-registry | `npx skills add majiayu000/claude-skill-registry --skill trivy -y` | Container images, filesystems, and IaC scanning. | `trivy` | When scanning container images, filesystems, or IaC for vulnerabilities |
| container-grype | AgentSecOps/SecOpsAgentKit | `npx skills add AgentSecOps/SecOpsAgentKit --skill container-grype -y` | Container security, SCA, SBOM, CVSS, CVE scanning. | `/container-grype` | When scanning containers for CVEs and generating SBOMs |
| grype | TerminalSkills/skills | `npx skills add TerminalSkills/skills --skill grype -y` | Grype scanner with CI/CD integration and Syft SBOM. | `grype` | When integrating Grype into CI/CD with Syft SBOM generation |
| docker-scout-scanner | kalshamsi/claude-security-skills | `npx skills add kalshamsi/claude-security-skills --skill docker-scout-scanner -y` | Container vulnerability scanning via Docker Scout. | `/docker-scout-scanner` | When scanning container images for vulnerabilities via Docker Scout |

---

## IaC Security

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| iac-checkov | AgentSecOps/SecOpsAgentKit | `npx skills add AgentSecOps/SecOpsAgentKit --skill iac-checkov -y` | Checkov for Terraform, K8s, CloudFormation compliance. | `/iac-checkov` | When checking Terraform, K8s, or CloudFormation for compliance violations |
| checkov | TerminalSkills/skills | `npx skills add TerminalSkills/skills --skill checkov -y` | Checkov IaC static analysis and custom policy writing. | `checkov` | When running Checkov IaC static analysis and authoring custom policies |
| iac-scanner | majiayu000/claude-skill-registry | `npx skills add majiayu000/claude-skill-registry --skill iac-scanner -y` | tfsec + Checkov for multi-cloud IaC scanning. | `/iac-scanner` | When scanning multi-cloud IaC with tfsec and Checkov |

---

## Threat Modeling

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| threat-modeling | fr33d3m0n/threat-modeling | `npx skills add fr33d3m0n/threat-modeling -y` | STRIDE/DREAD, MITRE ATT&CK mapping, OWASP MCP Top 10. | `/threat-modeling` | When performing structured threat modeling with STRIDE and ATT&CK |
| cso | garrytan/gstack | `npx skills add garrytan/gstack --skill cso -y` | CSO perspective: STRIDE, OWASP, supply chain, LLM/AI security. | `/cso` | When reviewing security from a CSO/CISO strategic perspective |
| insecure-defaults | trailofbits/skills | `npx skills add trailofbits/skills --skill insecure-defaults -y` | Detect insecure defaults, hardcoded creds, fail-open patterns. | `/insecure-defaults` | When hunting for insecure defaults and fail-open patterns |
| sharp-edges | trailofbits/skills | `npx skills add trailofbits/skills --skill sharp-edges -y` | Identify dangerous APIs and footgun designs. | `/sharp-edges` | When identifying dangerous API patterns and footgun-prone designs |

---

## Compliance (SOC2, HIPAA, PCI-DSS, GDPR)

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| governance-risk-compliance | Sushegaad/Claude-Skills-Governance-Risk-and-Compliance | `npx skills add Sushegaad/Claude-Skills-Governance-Risk-and-Compliance -y` | **[99% eval]** ISO 27001, SOC 2, FedRAMP, GDPR, HIPAA. | `/governance-risk-compliance` | When assessing compliance with SOC 2, HIPAA, GDPR, or ISO 27001 |
| owasp-asi | Tencent/AI-Infra-Guard | `npx skills add Tencent/AI-Infra-Guard --skill owasp-asi -y` | OWASP Top 10 for Agentic Applications 2026 classification. | `/owasp-asi` | When classifying agentic AI risks against OWASP Agentic App Top 10 |
| pci-dss-audit | kalshamsi/claude-security-skills | `npx skills add kalshamsi/claude-security-skills --skill pci-dss-audit -y` | PCI-DSS v4.0 compliance audit for payment code. | `/pci-dss-audit` | When auditing payment-handling code for PCI-DSS v4.0 compliance |

---

## Penetration Testing

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| awesome-claude-skills-security | Eyadkelleh/awesome-claude-skills-security | `npx skills add Eyadkelleh/awesome-claude-skills-security -y` | SecLists, injection payloads, pentest/CTF/bug-bounty agents. | `/awesome-claude-skills-security` | When running pentest, CTF, or bug-bounty workflows with payloads |
| claude-skills-pentest | WolzenGeorgi/claude-skills-pentest | `npx skills add WolzenGeorgi/claude-skills-pentest -y` | Automated pentesting with VPS scanner. | `/claude-skills-pentest` | When running automated penetration tests against a target |
| burpsuite-project-parser | trailofbits/skills | `npx skills add trailofbits/skills --skill burpsuite-project-parser -y` | Parse Burp Suite project files for analysis. | `/burpsuite-project-parser` | When analysing Burp Suite project exports for security findings |
| agentic-actions-auditor | trailofbits/skills | `npx skills add trailofbits/skills --skill agentic-actions-auditor -y` | Audit GitHub Actions for AI agent security risks. | `/agentic-actions-auditor` | When auditing GitHub Actions workflows for AI agent security risks |

---

## Smart Contract & Crypto Security

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| building-secure-contracts | trailofbits/skills | `npx skills add trailofbits/skills --skill building-secure-contracts -y` | Secure smart contract patterns, 6 blockchain scanners. | `/building-secure-contracts` | When writing or auditing smart contracts for security vulnerabilities |
| constant-time-analysis | trailofbits/skills | `npx skills add trailofbits/skills --skill constant-time-analysis -y` | Detect timing side-channels in cryptographic code. | `/constant-time-analysis` | When detecting timing side-channels in cryptographic implementations |
| zeroize-audit | trailofbits/skills | `npx skills add trailofbits/skills --skill zeroize-audit -y` | Audit memory zeroization for sensitive data handling. | `/zeroize-audit` | When auditing that sensitive data is properly zeroized from memory |
| yara-authoring | trailofbits/skills | `npx skills add trailofbits/skills --skill yara-authoring -y` | YARA detection rule authoring for malware/threat detection. | `/yara-authoring` | When authoring YARA rules for malware detection |

---

## Framework-Specific Security

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| django-security | affaan-m/everything-claude-code | `npx skills add affaan-m/everything-claude-code --skill django-security -y` | Django: CSRF, SQLi, XSS, secure deployment. | `/django-security` | When hardening a Django application against CSRF, SQLi, and XSS |
| laravel-security | affaan-m/everything-claude-code | `npx skills add affaan-m/everything-claude-code --skill laravel-security -y` | Laravel: auth, validation, CSRF, mass assignment. | `/laravel-security` | When securing a Laravel application's auth and validation layer |
| springboot-security | affaan-m/everything-claude-code | `npx skills add affaan-m/everything-claude-code --skill springboot-security -y` | Spring Security: auth, CSRF, headers, rate limiting. | `/springboot-security` | When configuring Spring Security for auth, headers, and rate limiting |
| perl-security | affaan-m/everything-claude-code | `npx skills add affaan-m/everything-claude-code --skill perl-security -y` | Perl: taint mode, DBI parameterized queries. | `/perl-security` | When securing Perl code with taint mode and parameterized queries |

---

## Security Testing & Analysis

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| crypto-audit | kalshamsi/claude-security-skills | `npx skills add kalshamsi/claude-security-skills --skill crypto-audit -y` | Cryptographic vulnerability detection across Python, JS, Go, Rust, Java. | `/crypto-audit` | When auditing cryptographic implementations across multi-language codebases |
| security-headers-audit | kalshamsi/claude-security-skills | `npx skills add kalshamsi/claude-security-skills --skill security-headers-audit -y` | HTTP security header configuration audit. | `/security-headers-audit` | When auditing HTTP response headers for security misconfigurations |
| api-security-tester | kalshamsi/claude-security-skills | `npx skills add kalshamsi/claude-security-skills --skill api-security-tester -y` | API security audit for OWASP API Security Top 10:2023. | `/api-security-tester` | When auditing an API against the OWASP API Security Top 10:2023 |
| mobile-security | kalshamsi/claude-security-skills | `npx skills add kalshamsi/claude-security-skills --skill mobile-security -y` | Mobile app security audit for OWASP Mobile Top 10:2024. | `/mobile-security` | When auditing a mobile application against OWASP Mobile Top 10:2024 |
| security-test-generator | kalshamsi/claude-security-skills | `npx skills add kalshamsi/claude-security-skills --skill security-test-generator -y` | Generate executable security test suites for web apps. | `/security-test-generator` | When generating executable security test suites for a web application |
| devsecops-pipeline | kalshamsi/claude-security-skills | `npx skills add kalshamsi/claude-security-skills --skill devsecops-pipeline -y` | Generate GitHub Actions security CI/CD pipelines. | `/devsecops-pipeline` | When setting up a security-focused GitHub Actions CI/CD pipeline |

---

## Multi-Tool / Comprehensive

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| shield-claude-skill | alissonlinneker/shield-claude-skill | `npx skills add alissonlinneker/shield-claude-skill -y` | Registers Semgrep + Gitleaks + Trivy as callable Claude tools. | `/shield-claude-skill` | When registering Semgrep, Gitleaks, and Trivy as callable Claude tools |
| security (007) | sickn33/antigravity-awesome-skills | `npx skills add sickn33/antigravity-awesome-skills --skill 007 -y` | Full audit: STRIDE/PASTA, Red/Blue Team, OWASP, incident response. | `/007` | When running a full-spectrum security audit with Red/Blue team simulation |
| anthropic-cybersecurity-skills | mukul975/Anthropic-Cybersecurity-Skills | `npx skills add mukul975/Anthropic-Cybersecurity-Skills -y` | 734+ cybersecurity skills across 26 domains, MITRE ATT&CK mapped. | `/anthropic-cybersecurity-skills` | When accessing deep cybersecurity knowledge across 26 security domains |

---

## Incident Response & DFIR

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| awesome-dfir-skills | tsale/awesome-dfir-skills | `npx skills add tsale/awesome-dfir-skills -y` | Digital Forensics and Incident Response skills for InfoSec. | `/awesome-dfir-skills` | When investigating a security incident with forensic analysis |
| incident-commander | alirezarezvani/claude-skills | `/plugin install engineering-advanced-skills@claude-code-skills` | Incident response workflows: severity classification, communication templates, escalation, post-mortems. | `/incident-commander` | When coordinating an active incident response with escalation |
| env-secrets-manager | alirezarezvani/claude-skills | `/plugin install engineering-advanced-skills@claude-code-skills` | Secrets rotation, vault integration, .env management across environments. | `/env-secrets-manager` | When rotating secrets or managing .env files across environments |

---

## Skill & MCP Security (Meta)

| Skill | Source | Install | Description | Trigger | When to use |
|-------|--------|---------|-------------|---------|-------------|
| claude-code-skill-security-check | aliksir/claude-code-skill-security-check | `npx skills add aliksir/claude-code-skill-security-check -y` | Scan skills for prompt injection, data exfiltration, permission bypass, supply chain risks. | `/claude-code-skill-security-check` | When vetting a new skill for prompt injection or supply chain risks |
| mcp-security-audit | larrygmaguire-hash/mcp-security-audit | `npx skills add larrygmaguire-hash/mcp-security-audit -y` | Audit MCP servers before installation. | `/mcp-security-audit` | When auditing an MCP server for security risks before installing |
| safety-guard | affaan-m/everything-claude-code | `npx skills add affaan-m/everything-claude-code --skill safety-guard -y` | Prevent destructive ops: rm -rf, force push, DROP TABLE, chmod 777. | `/safety-guard` | When adding guardrails to prevent dangerous destructive operations |

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
