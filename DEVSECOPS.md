# DevSecOps Implementation Guide

## 📋 Overview

This project implements a comprehensive **DevSecOps Pipeline** for a NestJS application, integrating multiple security scanning tools and best practices throughout the development lifecycle.

### 🎯 Project Goals

1. **Automated Security Testing** - Continuous security scanning in CI/CD
2. **Vulnerability Detection** - Identify and remediate security issues early
3. **Compliance & Standards** - Follow OWASP, CWE, and industry best practices
4. **Shift-Left Security** - Detect issues during development, not deployment
5. **Observability** - Monitor and track security metrics

---

## 🔐 Security Components Implemented

### 1. **SAST (Static Application Security Testing)**

#### SonarQube
- **Purpose**: Deep code analysis for vulnerabilities, bugs, and code smells
- **Coverage**: TypeScript, JavaScript, and language-agnostic patterns
- **URL**: `http://localhost:9000` (when running locally)
- **Features**:
  - Code quality gates
  - Security hotspot detection
  - Technical debt measurement
  - Integration with CI/CD

**Configuration Files**:
- `.sonarqube/sonar-project.properties` - SonarQube project settings

#### Semgrep
- **Purpose**: Lightweight, fast SAST with custom rules
- **Coverage**: OWASP Top 10, security patterns
- **Trigger**: Automatic in GitHub Actions workflow
- **Benefits**: Open-source, easy integration, quick feedback

**GitHub Actions Integration**:
```yaml
- Uses Semgrep config: p/owasp-top-ten
- Generates SARIF reports for GitHub Code Scanning
```

---

### 2. **SCA (Software Composition Analysis)**

#### NPM Audit
- **Purpose**: Scan for known vulnerabilities in dependencies
- **Frequency**: On every build and pull request
- **Severity Levels**: Low, Moderate, High, Critical
- **Report**: `reports/npm-audit-report.json`

#### Snyk
- **Purpose**: Advanced dependency vulnerability scanning
- **Features**:
  - License compliance checking
  - Transitive dependency analysis
  - Remediation suggestions
  - Real-time vulnerability updates

**Setup**: Add SNYK_TOKEN to GitHub Secrets

#### OWASP Dependency-Check
- **Purpose**: Comprehensive CVE database scanning
- **Features**:
  - Multiple language support
  - Historical vulnerability tracking
  - Experimental features for deeper analysis

**Reports**: 
- JSON format for automation
- HTML for manual review

---

### 3. **Secret Scanning**

#### TruffleHog
- **Purpose**: Detect secrets and credentials in code
- **Patterns**: AWS keys, API tokens, database passwords
- **Action**: Prevents secrets from entering repository

#### GitLeaks
- **Purpose**: Specialized secret detection for Git repositories
- **Entropy Analysis**: Detects high-entropy strings likely to be secrets
- **Custom Rules**: Can extend with organization-specific patterns

#### detect-secrets (OWASP)
- **Purpose**: Establish baseline of acceptable secrets
- **Baseline File**: `.secrets.baseline`
- **Use Case**: Identify new secrets vs. accepted ones

**Prevention**:
```bash
# Example to scan for secrets
detect-secrets scan --all-files
```

---

### 4. **Container Scanning**

#### Trivy (Aqua Security)
- **Purpose**: Vulnerability scanning for container images
- **Scanning Levels**:
  - OS packages (apt, apk, yum, etc.)
  - Application dependencies (npm, pip, maven, etc.)
  - Custom resources

**Trivy Scan**:
```bash
trivy image msi-devsecops:latest
```

#### Grype (Anchore)
- **Purpose**: Alternative container vulnerability scanner
- **Strengths**:
  - Faster scanning
  - SBOM (Software Bill of Materials) generation
  - Better for supply chain security

**Docker Image Security Best Practices** (Implemented):
- ✅ Multi-stage builds for reduced image size
- ✅ Non-root user execution (uid 1001)
- ✅ Read-only root filesystem
- ✅ Health checks
- ✅ Minimal base image (Alpine Linux)
- ✅ Security updates in base image

---

### 5. **IaC (Infrastructure as Code) Scanning**

#### Checkov
- **Purpose**: Scan Dockerfile and docker-compose for security issues
- **Checks**:
  - Root user execution
  - Image freshness
  - Resource limits
  - Secrets in environment variables

**Configuration Scanning**:
```bash
checkov -f docker/Dockerfile
checkov -f docker/docker-compose.yml
```

---

### 6. **DAST (Dynamic Application Security Testing)**

#### OWASP ZAP
- **Purpose**: Runtime security testing
- **Triggers**: Runs on main branch push
- **Scanning Mode**: Baseline scan against running application
- **Coverage**: OWASP Top 10 vulnerabilities

**ZAP Configuration**:
- Rules file: `.zap/rules.tsv`
- Custom rules for application-specific testing

**What DAST Tests**:
- Authentication bypass
- Session management issues
- Cross-site scripting (XSS)
- CSRF vulnerabilities
- SQL injection
- Security misconfigurations

---

## 📁 Project Structure

```
msi-devsecops/
├── .github/workflows/
│   └── devsecops-pipeline.yml          # GitHub Actions CI/CD pipeline
├── .sonarqube/
│   └── sonar-project.properties        # SonarQube configuration
├── .zap/
│   └── rules.tsv                       # OWASP ZAP rules
├── docker/
│   ├── Dockerfile                      # Multi-stage secure build
│   └── docker-compose.yml              # Local DevSecOps stack
├── security/
│   └── prometheus.yml                  # Prometheus monitoring config
├── scripts/
│   ├── install-tools.sh               # Install security tools
│   ├── setup-env.sh                   # Start local environment
│   ├── cleanup-env.sh                 # Stop local environment
│   └── local-security-scan.sh         # Run local scans
├── src/                                # Application source code
├── test/                               # Test files
├── .env.example                        # Environment variables template
├── package.json                        # Dependencies & scripts
└── README.md                           # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- Git
- Optional: Snyk account, SonarQube instance

### 1. Installation

```bash
# Clone the repository
git clone <repository-url>
cd msi-devsecops

# Install dependencies
npm install

# Install security tools
bash scripts/install-tools.sh

# Configure environment
cp .env.example .env
# Edit .env with your credentials
```

### 2. Run Locally

#### Start the Application
```bash
npm run start:dev
```

#### Start DevSecOps Stack
```bash
# Start all security services
bash scripts/setup-env.sh

# Access dashboards:
# - SonarQube: http://localhost:9000
# - Prometheus: http://localhost:9090
# - Grafana: http://localhost:3001
# - OWASP ZAP: http://localhost:8080
```

#### Run Security Scans Locally
```bash
bash scripts/local-security-scan.sh
```

This will execute:
1. NPM Audit (SCA)
2. Snyk scan (SCA)
3. TruffleHog (Secret Scanning)
4. Semgrep (SAST)
5. Trivy (Container Scanning)
6. Generate security summary

### 3. Testing

```bash
# Unit tests
npm run test:cov

# End-to-end tests
npm run test:e2e

# Linting
npm run lint
```

### 4. Build & Deploy

```bash
# Build application
npm run build

# Build Docker image
docker build -t msi-devsecops:latest -f docker/Dockerfile .

# Run container
docker run -p 3000:3000 msi-devsecops:latest
```

---

## 🔄 GitHub Actions CI/CD Pipeline

The pipeline is configured in `.github/workflows/devsecops-pipeline.yml`

### Pipeline Stages

#### 1. **Setup Stage**
- Checkout code with full history
- Setup Node.js with caching
- Install dependencies

#### 2. **Security Scanning (Parallel)**
- **SAST**: SonarQube + Semgrep
- **SCA**: npm audit + Snyk + Dependency-Check
- **Secrets**: TruffleHog + GitLeaks + detect-secrets
- **IaC**: Checkov

#### 3. **Quality & Testing**
- ESLint
- Unit tests with coverage
- E2E tests
- Coverage upload to Codecov

#### 4. **Build & Container Security**
- Docker image build
- Trivy scan
- Grype scan
- SARIF upload to GitHub

#### 5. **DAST (Main branch only)**
- Start application
- OWASP ZAP scan
- Security reporting

#### 6. **Reporting**
- Aggregate all reports
- Generate security summary
- Comment on PRs
- Create GitHub Pages report

### Triggering Pipeline

```yaml
# Automatic triggers:
- Push to main or develop
- Pull requests to main or develop
- Weekly schedule (Sunday 2 AM)

# Manual trigger:
# Available via Actions tab in GitHub
```

---

## 🛠️ Tool Configuration

### SonarQube Setup

**Required Environment Variables** (GitHub Secrets):
```
SONAR_HOST_URL=https://your-sonarqube-instance.com
SONAR_LOGIN=your-sonarqube-token
```

**Local Setup**:
```bash
# Create account and generate token in SonarQube UI
# Add to .env file
```

### Snyk Setup

**Required Environment Variable** (GitHub Secrets):
```
SNYK_TOKEN=your-snyk-token
```

**Get token**:
1. Sign up at https://snyk.io
2. Generate API token in account settings
3. Add to GitHub Secrets

### GitHub Security

**Enable features**:
1. Code Scanning (Advanced Security)
2. Secret Scanning
3. Dependabot alerts
4. Security advisories

---

## 📊 Security Dashboards

### Local Development

When running `bash scripts/setup-env.sh`, these dashboards are available:

| Service | URL | Credentials |
|---------|-----|-------------|
| **SonarQube** | http://localhost:9000 | admin / admin |
| **Prometheus** | http://localhost:9090 | (none) |
| **Grafana** | http://localhost:3001 | admin / admin |
| **OWASP ZAP** | http://localhost:8080 | (none) |
| **Vault** | http://localhost:8200 | myroot |
| **App** | http://localhost:3000 | (none) |

### GitHub Security Tab

After configuring Code Scanning:
1. Go to Security → Code Scanning
2. View SARIF reports from:
   - Semgrep
   - Trivy
   - Grype
   - Checkov

---

## 🔍 Interpreting Results

### SAST Results
- **High Priority**: Implement fixes before merge
- **Medium Priority**: Include in sprint planning
- **Low Priority**: Document as tech debt

### SCA Results
- **Critical**: Update immediately
- **High**: Fix before release
- **Medium**: Plan for next release
- **Low**: Monitor and plan updates

### Secret Scanning Results
- **Any match**: Immediately revoke credentials
- **Rotate secrets**: In Vault and environment
- **Investigate**: How it got committed
- **Prevent**: Add .gitignore, use pre-commit hooks

### Container Scanning Results
- **CRITICAL**: Don't deploy
- **HIGH**: Fix and rebuild image
- **MEDIUM**: Track and fix
- **LOW**: Document and monitor

---

## ✅ Security Checklist

- [ ] All GitHub Secrets configured
- [ ] SonarQube instance configured
- [ ] Snyk account linked
- [ ] Container registry configured
- [ ] SSH keys for deployment
- [ ] API keys stored in Vault
- [ ] Branch protection enabled
- [ ] Deployment approval required
- [ ] Security training completed
- [ ] Incident response plan defined

---

## 🚨 Common Issues & Solutions

### Issue: Pipeline fails on npm audit
```bash
# Solution: Review audit findings and update package.json
npm audit fix
npm audit fix --force  # Use with caution
```

### Issue: Trivy scan timeout
```bash
# Solution: Increase timeout in workflow
# Adjust in GitHub Actions step timeout
```

### Issue: SonarQube quality gate fails
```bash
# Solution: Review quality profile rules
# Adjust gate threshold in SonarQube UI
```

### Issue: Secrets detected in repository
```bash
# Solution: Use git-filter-branch or BFG to remove
git filter-branch --tree-filter 'find . -name "*.env" -delete' HEAD
```

---

## 📈 Metrics & KPIs

Track these metrics for security posture:

1. **Vulnerability Density**: Vulnerabilities per 1000 lines of code
2. **Time to Remediation**: Days from detection to fix
3. **Security Coverage**: % of code scanned
4. **Dependency Freshness**: Age of critical dependencies
5. **Test Coverage**: % of code covered by tests
6. **SCA Pass Rate**: % of builds passing SCA
7. **DAST Pass Rate**: % of builds passing DAST

---

## 🔐 Security Best Practices

1. **Code Review**: Require security review before merge
2. **Dependency Updates**: Automated patches via Dependabot
3. **Secrets Management**: Never commit credentials
4. **Access Control**: Least privilege for deployments
5. **Monitoring**: Continuous security event monitoring
6. **Incident Response**: Documented procedures
7. **Security Training**: Regular team education
8. **Compliance**: Audit trail and documentation

---

## 📚 Resources

- **OWASP Top 10**: https://owasp.org/www-project-top-ten/
- **NIST Cybersecurity Framework**: https://www.nist.gov/cyberframework
- **CWE List**: https://cwe.mitre.org/
- **NestJS Security**: https://docs.nestjs.com/security
- **Docker Security**: https://docs.docker.com/develop/security-best-practices/

---

## 📞 Support & Contribution

For issues or contributions:
1. Create an issue with security details
2. Follow responsible disclosure
3. Don't publicly disclose vulnerabilities
4. Contact: security@project.example.com

---

## 📄 License

This DevSecOps implementation is provided as-is for educational and development purposes.

---

**Last Updated**: December 2024
**Version**: 1.0.0
**Status**: Active & Maintained
