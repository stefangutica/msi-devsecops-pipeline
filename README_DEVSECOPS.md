# MSI DevSecOps - NestJS Secure Development Pipeline

<p align="center">
  <a href="https://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="120" alt="Nest Logo" /></a>
  <a href="https://owasp.org/" target="blank"><img src="https://owasp.org/assets/images/logo.png" width="120" alt="OWASP Logo" /></a>
</p>

> **A Production-Ready DevSecOps Pipeline for NestJS Applications**

[![GitHub Actions](https://github.com/yourusername/msi-devsecops/workflows/DevSecOps%20Pipeline/badge.svg)](https://github.com/yourusername/msi-devsecops/actions)
[![Security Scanning](https://img.shields.io/badge/Security-Active-brightgreen)]()
[![Docker](https://img.shields.io/badge/Docker-Ready-blue)]()
[![License](https://img.shields.io/badge/License-UNLICENSED-red)]()

---

## 📖 Quick Overview

This project demonstrates a **complete DevSecOps implementation** for a NestJS application, featuring:

- ✅ **Automated CI/CD Pipeline** - GitHub Actions with 9+ security jobs
- ✅ **Multiple Security Scanners** - SAST, SCA, Secret, Container, IaC, DAST
- ✅ **Continuous Monitoring** - SonarQube, Prometheus, Grafana dashboards
- ✅ **Secure Containerization** - Multi-stage Dockerfile, non-root user
- ✅ **Local Development** - Full DevSecOps stack via Docker Compose
- ✅ **Documentation** - Comprehensive guides and examples

---

## 🚀 Quick Start

### 1. Installation

```bash
# Clone and setup
git clone <repository-url>
cd msi-devsecops

# Install dependencies
npm install

# Install security tools
npm run security:install-tools
```

### 2. Run Locally

**Start Application:**
```bash
npm run start:dev
# App runs on http://localhost:3000
```

**Start Security Stack:**
```bash
npm run security:setup-env
# Services start: SonarQube, Grafana, Prometheus, ZAP, Vault
```

**Run Security Scans:**
```bash
npm run security:scan-local
# Executes: SCA, SAST, Secrets, Container scans
```

### 3. Access Dashboards

| Service | URL | Credentials |
|---------|-----|-------------|
| Application | http://localhost:3000 | - |
| SonarQube | http://localhost:9000 | admin / admin |
| Grafana | http://localhost:3001 | admin / admin |
| Prometheus | http://localhost:9090 | - |
| OWASP ZAP | http://localhost:8080 | - |
| Vault | http://localhost:8200 | myroot |

---

## 📋 Available Scripts

### Application
```bash
npm run build          # Compile TypeScript
npm run start          # Start application
npm run start:dev      # Development mode with watch
npm run start:prod     # Production mode
npm run lint           # Run ESLint
npm run format         # Format code with Prettier
```

### Testing
```bash
npm run test           # Unit tests
npm run test:watch     # Unit tests in watch mode
npm run test:cov       # Tests with coverage report
npm run test:e2e       # End-to-end tests
```

### Security
```bash
npm run security:install-tools      # Install security scanners
npm run security:setup-env          # Start DevSecOps environment
npm run security:cleanup-env        # Stop services
npm run security:scan-local         # Run all local security scans
npm run security:audit              # NPM audit scan
npm run docker:build                # Build Docker image
npm run docker:scan                 # Scan image with Trivy
npm run docker:run                  # Run container
```

---

## 🔐 Security Features

### SAST (Static Application Security Testing)
- **SonarQube**: Deep code analysis, quality gates, hotspots
- **Semgrep**: Fast pattern-based vulnerability detection

### SCA (Software Composition Analysis)
- **npm audit**: Built-in dependency vulnerability scanner
- **Snyk**: Advanced dependency analysis with remediation
- **Dependency-Check**: CVE database matching

### Secret Scanning
- **TruffleHog**: Detects credentials and API keys
- **GitLeaks**: Git-specific secret detection
- **detect-secrets**: Baseline-based secret management

### Container Scanning
- **Trivy**: OS and application vulnerability scanning
- **Grype**: Alternative container vulnerability scanner
- **Secure Dockerfile**: Multi-stage, minimal, non-root

### IaC Scanning
- **Checkov**: Infrastructure as Code validation

### DAST (Dynamic Application Security Testing)
- **OWASP ZAP**: Runtime vulnerability testing (on main branch)

---

## 🔄 CI/CD Pipeline

The GitHub Actions pipeline automatically runs on:
- 📤 Push to `main` or `develop`
- 🔀 Pull requests to `main` or `develop`
- 📅 Weekly schedule (Sunday 2 AM)

### Pipeline Stages

```
1. Setup & Dependencies
   ↓
2. Security Scanning (Parallel)
   ├─ SAST: SonarQube + Semgrep
   ├─ SCA: npm audit + Snyk + Dependency-Check
   ├─ Secrets: TruffleHog + GitLeaks
   └─ IaC: Checkov
   ↓
3. Quality & Testing
   ├─ ESLint
   ├─ Unit tests + Coverage
   └─ E2E tests
   ↓
4. Container Scanning
   ├─ Docker build
   ├─ Trivy scan
   └─ Grype scan
   ↓
5. DAST (Main only)
   └─ OWASP ZAP scan
   ↓
6. Reporting
   ├─ Aggregate reports
   ├─ PR comments
   └─ GitHub uploads
```

---

## 📁 Project Structure

```
msi-devsecops/
├── .github/workflows/
│   └── devsecops-pipeline.yml          # GitHub Actions CI/CD
├── .sonarqube/
│   └── sonar-project.properties        # SonarQube settings
├── .zap/
│   └── rules.tsv                       # OWASP ZAP rules
├── docker/
│   ├── Dockerfile                      # Secure multi-stage build
│   └── docker-compose.yml              # DevSecOps stack
├── security/
│   └── prometheus.yml                  # Prometheus config
├── scripts/
│   ├── install-tools.sh               # Install scanners
│   ├── setup-env.sh                   # Start services
│   ├── cleanup-env.sh                 # Stop services
│   └── local-security-scan.sh         # Run scans
├── src/
│   ├── app.controller.ts
│   ├── app.service.ts
│   ├── app.module.ts
│   └── main.ts
├── test/
│   └── app.e2e-spec.ts
├── DEVSECOPS.md                        # Detailed guide
├── IMPLEMENTATION_REPORT.md            # Implementation details
└── package.json
```

---

## 🔧 Configuration

### GitHub Secrets Required

Add these to your GitHub repository settings (Settings → Secrets → Actions):

```
SONAR_HOST_URL    # Your SonarQube instance URL
SONAR_LOGIN       # SonarQube authentication token
SNYK_TOKEN        # Snyk API token (optional)
```

### Environment Variables

Copy and customize:
```bash
cp .env.example .env
```

Key variables:
- `NODE_ENV` - Application environment
- `PORT` - Application port
- `SONAR_HOST_URL` - SonarQube URL
- `SNYK_TOKEN` - Snyk API token
- `VAULT_ADDR` - HashiCorp Vault address

---

## 🛡️ Docker Security

### Multi-Stage Build
- Reduced image size
- Separation of build and runtime

### Runtime Security
- Non-root user execution (uid 1001)
- Read-only root filesystem
- Health checks
- Minimal Alpine Linux base
- No privileged mode

### Building & Running
```bash
# Build
npm run docker:build

# Scan for vulnerabilities
npm run docker:scan

# Run securely
npm run docker:run

# Or with docker-compose
docker-compose -f docker/docker-compose.yml up
```

---

## 📊 Monitoring & Dashboards

### Local Dashboards (after `npm run security:setup-env`)

1. **SonarQube** - Code quality and security hotspots
2. **Prometheus** - Metrics collection and alerting
3. **Grafana** - Visualization and dashboards
4. **OWASP ZAP** - DAST scanning interface
5. **Vault** - Secrets management

### GitHub Dashboards

- **Security → Code Scanning** - SAST results
- **Security → Secret Scanning** - Detected secrets
- **Security → Dependabot** - Dependency alerts
- **Actions → DevSecOps Pipeline** - Build logs

---

## 📈 Security Metrics

Track these key performance indicators:

- **Vulnerability Density**: Vulns per 1000 LOC
- **Time to Remediation**: Days from detection to fix
- **Security Coverage**: % of code scanned
- **Test Coverage**: % of code with tests
- **Dependency Freshness**: Age of critical packages
- **DAST Pass Rate**: % of builds passing DAST
- **False Positive Rate**: % of false security alerts

---

## 🐛 Troubleshooting

### Issue: Docker services won't start
```bash
# Clean up and restart
docker-compose -f docker/docker-compose.yml down -v
npm run security:setup-env
```

### Issue: Pipeline fails on SonarQube
```bash
# Ensure SONAR_HOST_URL and SONAR_LOGIN are set
# Test SonarQube connectivity
curl $SONAR_HOST_URL/api/system/status
```

### Issue: Trivy scan timeout
```bash
# Increase timeout in GitHub Actions or run locally
npm run docker:scan
```

### Issue: Secrets detected in git history
```bash
# Use git-filter-branch to remove
git filter-branch --tree-filter 'find . -name "*.env" -delete' HEAD

# Or use BFG
bfg --delete-files .env
```

---

## 📚 Documentation

- **[DEVSECOPS.md](DEVSECOPS.md)** - Comprehensive implementation guide
- **[IMPLEMENTATION_REPORT.md](IMPLEMENTATION_REPORT.md)** - Technical details
- **[Tool Documentation](#tools-used)** - External resources

---

## 🛠️ Tools Used

| Tool | Purpose | Category |
|------|---------|----------|
| [SonarQube](https://www.sonarqube.org/) | Code analysis | SAST |
| [Semgrep](https://semgrep.dev/) | Pattern detection | SAST |
| [npm audit](https://docs.npmjs.com/cli/v8/commands/npm-audit) | Dependency scan | SCA |
| [Snyk](https://snyk.io/) | Vulnerability DB | SCA |
| [Dependency-Check](https://owasp.org/www-project-dependency-check/) | CVE matching | SCA |
| [TruffleHog](https://github.com/trufflesecurity/trufflehog) | Secret detection | Secret |
| [GitLeaks](https://github.com/gitleaks/gitleaks) | Git secrets | Secret |
| [detect-secrets](https://github.com/Yelp/detect-secrets) | Baseline secrets | Secret |
| [Trivy](https://github.com/aquasecurity/trivy) | Container scan | Container |
| [Grype](https://github.com/anchore/grype) | Container scan | Container |
| [Checkov](https://www.checkov.io/) | IaC scan | IaC |
| [OWASP ZAP](https://www.zaproxy.org/) | Dynamic test | DAST |
| [Prometheus](https://prometheus.io/) | Monitoring | Observability |
| [Grafana](https://grafana.com/) | Dashboards | Observability |
| [Vault](https://www.vaultproject.io/) | Secrets mgmt | Security |

---

## 📞 Support & Contribution

### Getting Help
1. Review [DEVSECOPS.md](DEVSECOPS.md)
2. Check GitHub Actions logs
3. Review tool documentation
4. Contact your security team

### Contributing
1. Follow security best practices
2. Ensure all tests pass
3. Run security scans locally
4. Create pull request with security review

### Reporting Security Issues
**DO NOT** create public issues for security vulnerabilities.
- Email: security@project.example.com
- Include: vulnerability details, impact, suggested fix

---

## ✅ Checklist Before Production

- [ ] All GitHub Secrets configured
- [ ] SonarQube quality gate passing
- [ ] Snyk account linked and configured
- [ ] Zero critical vulnerabilities
- [ ] All tests passing with >80% coverage
- [ ] Docker image scanned and approved
- [ ] Security review completed
- [ ] Secrets stored in Vault, not code
- [ ] Monitoring dashboards set up
- [ ] Incident response plan documented

---

## 📊 Key Features Summary

| Feature | Status | Details |
|---------|--------|---------|
| **SAST** | ✅ Active | SonarQube + Semgrep |
| **SCA** | ✅ Active | npm audit, Snyk, Dependency-Check |
| **Secret Scanning** | ✅ Active | TruffleHog, GitLeaks, detect-secrets |
| **Container Scanning** | ✅ Active | Trivy, Grype |
| **IaC Scanning** | ✅ Active | Checkov |
| **DAST** | ✅ Scheduled | OWASP ZAP on main branch |
| **Code Quality** | ✅ Active | ESLint, Jest, TypeScript |
| **Monitoring** | ✅ Active | Prometheus, Grafana |
| **Secrets Management** | ✅ Active | Vault integration |
| **Documentation** | ✅ Complete | Guides and examples |

---

## 📄 License

This project is UNLICENSED. Use for educational and development purposes.

---

## 🔗 Quick Links

- [GitHub Actions Workflow](./.github/workflows/devsecops-pipeline.yml)
- [Docker Configuration](./docker/)
- [Security Scripts](./scripts/)
- [SonarQube Config](./.sonarqube/)
- [Detailed Guide](./DEVSECOPS.md)
- [Implementation Report](./IMPLEMENTATION_REPORT.md)

---

**Last Updated**: December 2024  
**Version**: 1.0.0  
**Status**: Production Ready  
**Maintained**: Yes ✅

---

<p align="center">
  <strong>🔐 Secure Development, Every Commit 🔐</strong>
</p>
