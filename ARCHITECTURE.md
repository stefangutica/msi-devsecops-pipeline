# DevSecOps Architecture & Integration Guide

## 🏗️ Complete Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          DEVELOPER WORKFLOW                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  1. Local Development                  2. Pre-commit                         │
│  ├─ npm run start:dev                 ├─ npm run lint                      │
│  ├─ npm run test:watch                ├─ npm run test:cov                  │
│  └─ npm run security:scan-local       └─ npm run security:audit            │
│                                                                               │
└──────────────────────────────────────────┬──────────────────────────────────┘
                                           │
                                      PUSH TO GIT
                                           │
┌──────────────────────────────────────────▼──────────────────────────────────┐
│                        GITHUB ACTIONS CI/CD PIPELINE                         │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  Stage 1: SETUP & DEPENDENCIES                                              │
│  ├─ Checkout code (fetch-depth: 0)                                         │
│  ├─ Setup Node.js with cache                                               │
│  └─ npm ci (clean install)                                                 │
│                                                                               │
│  Stage 2: SECURITY SCANNING (PARALLEL)                                      │
│  │                                                                           │
│  ├─ SAST JOBS                    ├─ SCA JOBS              ├─ SECRETS       │
│  │  ├─ SonarQube Analysis        │  ├─ npm audit          │  ├─ TruffleHog│
│  │  ├─ SARIF upload              │  ├─ Snyk scan          │  ├─ GitLeaks  │
│  │  └─ Quality Gate Check        │  ├─ Dependency-Check   │  └─ detect-sec│
│  │                                │  └─ JSON reports       │                │
│  │  ├─ Semgrep Analysis          └─ CVE Database         └─ Pattern DB    │
│  │  └─ OWASP patterns            matching                                   │
│  │                                                                           │
│  Stage 3: QUALITY & TESTING                                                 │
│  ├─ ESLint (code style)                                                    │
│  ├─ Jest (unit tests + coverage)                                           │
│  ├─ E2E tests                                                              │
│  └─ Codecov upload                                                         │
│                                                                               │
│  Stage 4: BUILD & CONTAINER SCANNING                                        │
│  ├─ Docker image build                                                     │
│  ├─ Trivy scan                                                             │
│  ├─ Grype scan                                                             │
│  └─ SARIF reports                                                          │
│                                                                               │
│  Stage 5: DAST (MAIN BRANCH ONLY)                                          │
│  ├─ Build & start application                                              │
│  ├─ OWASP ZAP baseline scan                                                │
│  └─ Report generation                                                       │
│                                                                               │
│  Stage 6: REPORTING & NOTIFICATIONS                                         │
│  ├─ Aggregate all reports                                                  │
│  ├─ Generate security summary                                              │
│  ├─ PR comments with findings                                              │
│  └─ GitHub upload (SARIF)                                                  │
│                                                                               │
└──────────────────────────────────────────┬──────────────────────────────────┘
                                           │
                                    RESULTS & REPORTS
                                           │
        ┌──────────────────────────────────┼──────────────────────────────────┐
        │                                  │                                  │
        ▼                                  ▼                                  ▼
┌─────────────────┐            ┌──────────────────┐         ┌──────────────────┐
│  GitHub Code    │            │  Pull Request    │         │  GitHub Actions  │
│  Scanning Tab   │            │  Comments        │         │  Artifacts       │
├─────────────────┤            ├──────────────────┤         ├──────────────────┤
│ SARIF Reports   │            │ Security Status  │         │ SAST Reports     │
│ ├─ Semgrep      │            │ ├─ Pass/Fail     │         │ ├─ SonarQube     │
│ ├─ Trivy        │            │ ├─ Issue Count   │         │ ├─ Semgrep       │
│ ├─ Grype        │            │ └─ Action Items  │         │ ├─ npm audit     │
│ └─ Checkov      │            │                  │         │ ├─ Trivy         │
└─────────────────┘            └──────────────────┘         │ └─ Grype         │
                                                             └──────────────────┘
```

---

## 🔐 Security Scanning Flow

### SAST Flow (Static Application Security Testing)
```
Source Code
    │
    ├─── SonarQube ──┐
    │                ├─── Quality Gate ──┐
    └─── Semgrep ───┘                    ├─── GitHub Code Scanning
                                         │
                          ┌──────────────┤
                          │              │
                      PASS             FAIL
                          │              │
                      Continue      Comment on PR
                          │              │
                          └──────────────┘
```

### SCA Flow (Software Composition Analysis)
```
package.json
    │
    ├─── npm audit ──┐
    │                │
    ├─── Snyk ───────┼─── CVE Database ──── Vulnerabilities Found
    │                │
    └─── Dependency-Check ┘
                │
         ┌──────┴──────┐
         │             │
    CRITICAL        MODERATE/LOW
         │             │
    BLOCK MERGE    WARN ONLY
```

### Secret Scanning Flow
```
Git Repository
    │
    ├─── TruffleHog ──┐
    │                 │
    ├─── GitLeaks ────┼─── Pattern Database
    │                 │
    └─── detect-secrets ┘
              │
      ┌───────┴────────┐
      │                │
  SECRET FOUND     NO SECRETS
      │                │
  ALERT & BLOCK    CONTINUE
```

---

## 🐳 Container Security Pipeline

```
Application Code
    │
    ├─── npm build ──┐
    │                │
    ├─── Dockerfile ─┤─── docker build ──┐
    │                │                   │
    └─── Dependencies ┘        ┌─────────┘
                               │
                        Docker Image
                               │
                ┌──────────────┼──────────────┐
                │              │              │
            Trivy Scan    Grype Scan     Checkov
                │              │              │
         OS + App Vulns   SBOM Gen      IaC Validation
                │              │              │
                └──────────────┼──────────────┘
                               │
                        ┌──────┴──────┐
                        │             │
                   VULNERABILITIES  PASS
                   FOUND?            │
                        │             │
                   ┌──REJECT      PUSH TO
                   │             REGISTRY
            │      │
        CRITICAL  HIGH
           │       │
        FAIL   WARN
```

---

## 📊 Local Development Stack

```
┌────────────────────────────────────────────────────────────────┐
│                 Local DevSecOps Environment                    │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐         ┌──────────────┐                    │
│  │   Your App   │ ◄──────► │   SonarQube  │                   │
│  │  localhost   │ Port3000 │  localhost   │ Port9000           │
│  │   :3000      │         │    :9000     │                    │
│  └──────────────┘         └──────┬───────┘                    │
│                                  │                             │
│                            ┌──────┴────────┐                  │
│                            │                │                  │
│                       PostgreSQL        Metrics               │
│                       Port5432         Collection             │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │             Monitoring & Dashboards                      │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │  Prometheus (9090)  ◄───── Metrics ◄─── Application    │ │
│  │         │                                                 │ │
│  │         ▼                                                 │ │
│  │  Grafana (3001) ──► Dashboards & Alerts                │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │           Additional Security Services                   │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │  ├─ OWASP ZAP (8080)  ◄─── DAST Testing                 │ │
│  │  └─ Vault (8200)      ◄─── Secrets Management           │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 🔄 CI/CD Integration Points

```
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Workflow Triggers                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PUSH to main/develop                                           │
│  ├─ Full pipeline runs                                          │
│  └─ Reports uploaded to GitHub                                  │
│                                                                  │
│  PULL REQUEST to main/develop                                   │
│  ├─ All security checks run                                     │
│  ├─ Comment on PR with summary                                  │
│  └─ Require checks to pass before merge                         │
│                                                                  │
│  SCHEDULED (Weekly Sunday 2 AM)                                 │
│  ├─ Regular security audit                                      │
│  └─ Detect new vulnerabilities                                  │
│                                                                  │
│  MANUAL TRIGGER (via GitHub UI)                                 │
│  └─ Run pipeline on demand                                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔌 Tool Integration Architecture

```
SAST Layer
├─ SonarQube
│  ├─ Language: TypeScript/JavaScript
│  ├─ Rules: Security + Quality
│  ├─ Integration: REST API
│  └─ Output: SARIF
│
├─ Semgrep
│  ├─ Rules: OWASP Top 10
│  ├─ Speed: Fast (parallel)
│  └─ Output: JSON + SARIF
│
SCA Layer
├─ npm audit
│  ├─ Source: npm database
│  └─ Output: JSON
│
├─ Snyk
│  ├─ Source: Snyk DB
│  ├─ Features: Remediation suggestions
│  └─ Output: JSON
│
├─ Dependency-Check
│  ├─ Source: CVE database
│  └─ Output: JSON + HTML
│
Secret Scanning Layer
├─ TruffleHog
│  ├─ Detection: Pattern matching
│  └─ Output: JSON
│
├─ GitLeaks
│  ├─ Detection: Entropy + Rules
│  └─ Output: JSON
│
├─ detect-secrets
│  ├─ Approach: Baseline
│  └─ Output: JSON
│
Container Scanning Layer
├─ Trivy
│  ├─ Scope: OS + App
│  ├─ Speed: Fast
│  └─ Output: JSON + SARIF
│
├─ Grype
│  ├─ Features: SBOM generation
│  └─ Output: JSON + SARIF
│
IaC Scanning Layer
└─ Checkov
   ├─ Scope: Docker, K8s
   └─ Output: SARIF

DAST Layer
└─ OWASP ZAP
   ├─ Trigger: Main branch only
   ├─ Mode: Baseline scan
   └─ Output: HTML + JSON
```

---

## 📈 Metrics & Reporting

```
┌─────────────────────────────────────────────────────────────┐
│             Security Metrics Collection                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Build Metrics                                               │
│  ├─ Pass rate (%)                                            │
│  ├─ Execution time (minutes)                                 │
│  └─ Failure reasons                                          │
│                                                              │
│  Code Quality Metrics                                        │
│  ├─ Code coverage (%)                                        │
│  ├─ Technical debt ratio                                     │
│  └─ Maintainability index                                    │
│                                                              │
│  Security Metrics                                            │
│  ├─ Vulnerabilities found                                    │
│  ├─ Secrets detected                                         │
│  ├─ Time to remediation (days)                               │
│  └─ Critical issues count                                    │
│                                                              │
│  Container Metrics                                           │
│  ├─ Image size (MB)                                          │
│  ├─ Vulnerabilities per image                                │
│  └─ Patch compliance (%)                                     │
│                                                              │
│  Dependency Metrics                                          │
│  ├─ Total dependencies                                       │
│  ├─ Outdated packages                                        │
│  └─ Security updates required                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
       │              │                │
       ▼              ▼                ▼
  Prometheus     SonarQube      GitHub Advanced
   Database      Dashboard      Security
       │              │                │
       └──────────────┼────────────────┘
              │
              ▼
         Grafana Dashboards
```

---

## 🔐 Secret Management Flow

```
Developer Commit
    │
    ├─ Code with potential secret
    │
    ├─ TruffleHog Analysis
    │   └─ Pattern: AWSKeyPattern, GitHub Token, etc.
    │
    ├─ GitLeaks Analysis
    │   └─ Entropy + Rule matching
    │
    ├─ detect-secrets Analysis
    │   └─ Compare to baseline
    │
    └─ RESULT: ┌─ No secrets found
              │
              └─ Secret detected!
                   │
                   ├─ ALERT: Block push
                   ├─ Notify: Security team
                   ├─ Revoke: Credentials immediately
                   └─ Action: Remove from history
```

---

## 🚀 Deployment Authorization Flow

```
Merge to Main
    │
    ▼
All CI Checks Pass
    │
    ├─ Security scanning
    ├─ Code quality gates
    ├─ Tests passing
    └─ No critical issues
        │
        ▼
Code Review & Approval
    │
    ├─ Security review
    ├─ Architecture review
    └─ Tests review
        │
        ▼
Automated Deployment
    │
    ├─ Build Docker image
    ├─ Scan image
    ├─ Push to registry
    └─ Deploy to environment
        │
        ▼
Runtime Security
    │
    ├─ Monitor logs
    ├─ Alert on anomalies
    └─ Track metrics
```

---

## 📊 Scanning Results Interpretation

```
SAST Results
├─ Blocker
│  └─ Critical security issue
│     └─ Action: Fix immediately
│
├─ Critical
│  └─ Major vulnerability
│     └─ Action: Fix before release
│
├─ Major
│  └─ Significant issue
│     └─ Action: Plan for sprint
│
└─ Minor
   └─ Code smell / best practice
      └─ Action: Document as tech debt

SCA Results
├─ Critical CVE
│  └─ Unpatched vulnerability in use
│     └─ Action: Update immediately
│
├─ High
│  └─ Known security issue
│     └─ Action: Update ASAP
│
├─ Medium
│  └─ Moderate risk
│     └─ Action: Plan for next release
│
└─ Low
   └─ Low priority
      └─ Action: Monitor and plan updates

Container Scan Results
├─ Critical
│  └─ OS-level vulnerability
│     └─ Action: Rebuild with patches
│
└─ High/Medium/Low
   └─ Follow severity guidelines
```

---

## 🔗 External Integrations

```
┌──────────────────────────────────────────────────────────┐
│           Optional External Integrations                 │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  Cloud SonarQube                                          │
│  ├─ URL: https://sonarcloud.io                           │
│  ├─ Integration: REST API                                │
│  └─ Benefit: Managed, cloud-hosted                       │
│                                                           │
│  Snyk Cloud Platform                                      │
│  ├─ URL: https://snyk.io                                 │
│  ├─ Features: Advanced SCA, remediation PR               │
│  └─ Benefit: Continuous monitoring                       │
│                                                           │
│  GitHub Advanced Security                                │
│  ├─ Features: Code scanning, secret scanning             │
│  ├─ Benefit: Native GitHub integration                   │
│  └─ Cost: Enterprise feature                             │
│                                                           │
│  Slack/Teams Notifications                               │
│  ├─ Integration: GitHub Actions                          │
│  ├─ Alerts: Build status, vulnerabilities                │
│  └─ Benefit: Real-time notifications                     │
│                                                           │
│  Container Registry                                      │
│  ├─ Docker Hub, GitHub Container Registry, ECR          │
│  ├─ Scanning: Image scanning on push                     │
│  └─ Benefit: Supply chain security                       │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

---

## 📚 References

- [DEVSECOPS.md](DEVSECOPS.md) - Detailed guide
- [QUICKSTART.md](QUICKSTART.md) - Quick start
- [IMPLEMENTATION_REPORT.md](IMPLEMENTATION_REPORT.md) - Technical details

---

**Architecture Version**: 1.0.0  
**Last Updated**: December 2024
