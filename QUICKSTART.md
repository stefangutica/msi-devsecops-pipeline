# 🚀 DevSecOps Quick Start Guide

## 30-Second Overview

This project combines a NestJS application with a **complete DevSecOps pipeline** featuring multiple security scanners that detect vulnerabilities at every stage of development.

---

## ⚡ 5 Minute Setup

### 1️⃣ Clone & Install (1 min)
```bash
git clone <repo-url>
cd msi-devsecops
npm install
```

### 2️⃣ Install Security Tools (2 min)
```bash
npm run security:install-tools
```

### 3️⃣ Start DevSecOps Stack (1 min)
```bash
npm run security:setup-env
```

### 4️⃣ Access Dashboards (1 min)
Open in browser:
- **Application**: http://localhost:3000
- **SonarQube** (code analysis): http://localhost:9000
- **Grafana** (dashboards): http://localhost:3001
- **Prometheus** (metrics): http://localhost:9090

---

## 🔐 What This Does

### Automatic Security Scanning
When you push code, the pipeline automatically:

1. **SAST** - Analyzes code for vulnerabilities
2. **SCA** - Checks dependencies for known vulnerabilities
3. **Secret Scan** - Detects hardcoded credentials
4. **Container Scan** - Scans Docker images
5. **DAST** - Tests running application
6. **Quality Tests** - Runs linting & tests

---

## 📊 Key Components

| Component | Purpose | Location |
|-----------|---------|----------|
| **GitHub Actions** | CI/CD automation | `.github/workflows/` |
| **Docker** | Container security | `docker/` |
| **SonarQube** | Code analysis | http://localhost:9000 |
| **Security Tools** | 11+ scanners | Integrated in pipeline |
| **Scripts** | Local automation | `scripts/` |
| **Dashboards** | Monitoring | Grafana, Prometheus |

---

## 🛠️ Common Commands

### Development
```bash
npm run start:dev      # Run with hot reload
npm run test:cov       # Tests with coverage
npm run lint           # Check code quality
```

### Security
```bash
npm run security:scan-local         # Run all scans
npm run security:audit              # Check dependencies
npm run docker:build                # Build image
npm run docker:scan                 # Scan image
```

### DevSecOps Stack
```bash
npm run security:setup-env          # Start services
npm run security:cleanup-env        # Stop services
```

---

## 📈 Scanners Included

### Code Analysis (SAST)
- ✅ **SonarQube** - Deep analysis
- ✅ **Semgrep** - Pattern matching

### Dependencies (SCA)
- ✅ **npm audit** - Built-in
- ✅ **Snyk** - Advanced analysis
- ✅ **Dependency-Check** - CVE database

### Secrets
- ✅ **TruffleHog** - Detects credentials
- ✅ **GitLeaks** - Git-specific
- ✅ **detect-secrets** - Baseline

### Containers
- ✅ **Trivy** - Fast scanning
- ✅ **Grype** - Detailed analysis

### Infrastructure
- ✅ **Checkov** - IaC validation

### Runtime
- ✅ **OWASP ZAP** - Dynamic testing

---

## 🔧 Configuration

### For GitHub Actions

Add to GitHub Secrets:
```
SONAR_HOST_URL = http://your-sonarqube.com
SONAR_LOGIN = your-token
SNYK_TOKEN = your-snyk-token (optional)
```

### Environment Variables

```bash
cp .env.example .env
# Edit with your values
```

---

## 📊 Dashboard URLs

When running locally with `npm run security:setup-env`:

```
SonarQube Dashboard
├─ URL: http://localhost:9000
├─ User: admin
├─ Pass: admin
└─ Check: Code quality, vulnerabilities

Grafana Dashboards
├─ URL: http://localhost:3001
├─ User: admin
├─ Pass: admin
└─ Check: Application metrics

Prometheus Metrics
├─ URL: http://localhost:9090
└─ Check: Raw metrics

OWASP ZAP
├─ URL: http://localhost:8080
└─ Check: Security testing interface

Vault Secrets
├─ URL: http://localhost:8200
├─ Token: myroot
└─ Check: Secrets management
```

---

## 🔄 GitHub Actions Pipeline

**Automatic triggers:**
- ✅ Push to `main` or `develop`
- ✅ Pull requests to main/develop
- ✅ Weekly schedule (Sunday 2 AM)

**View results:**
1. Go to GitHub → Actions tab
2. Click on "DevSecOps Pipeline" workflow
3. See job results and artifacts

---

## 🐳 Docker

### Build Image
```bash
npm run docker:build
```

### Scan for Vulnerabilities
```bash
npm run docker:scan
```

### Run Container
```bash
npm run docker:run
# Access on http://localhost:3000
```

---

## 📚 Detailed Documentation

For in-depth information:
- **[DEVSECOPS.md](DEVSECOPS.md)** - Complete implementation guide
- **[README_DEVSECOPS.md](README_DEVSECOPS.md)** - Full documentation
- **[IMPLEMENTATION_REPORT.md](IMPLEMENTATION_REPORT.md)** - Technical details

---

## ⚠️ Troubleshooting

### Docker services won't start
```bash
docker-compose -f docker/docker-compose.yml down -v
npm run security:setup-env
```

### SonarQube login fails
```bash
# Check credentials
echo "admin:admin@localhost:9000"
```

### Trivy scan fails
```bash
# Install trivy
brew install trivy  # macOS
sudo apt install trivy  # Linux
```

### Secrets detected in commit
```bash
# Immediately revoke the credential
# Remove from git history with:
git filter-branch --tree-filter 'find . -name "*.env" -delete' HEAD
```

---

## 📋 Pre-Commit Checklist

Before pushing code:
- [ ] Run `npm run lint`
- [ ] Run `npm run test:cov`
- [ ] Run `npm run security:scan-local`
- [ ] No secrets in code
- [ ] All tests passing

---

## 🎯 Next Steps

1. ✅ Install and run locally
2. ✅ Configure GitHub Secrets
3. ✅ Enable branch protection
4. ✅ Review security policy
5. ✅ Set up team training

---

## 🆘 Getting Help

1. **Documentation**: Read [DEVSECOPS.md](DEVSECOPS.md)
2. **Logs**: Check GitHub Actions logs
3. **Tools**: Visit tool documentation
   - [SonarQube Docs](https://docs.sonarqube.org/)
   - [Snyk Docs](https://docs.snyk.io/)
   - [Trivy Docs](https://github.com/aquasecurity/trivy)

---

## 📞 Support

For security issues:
- 🔴 **CRITICAL**: Contact security team immediately
- 🟠 **HIGH**: Create issue with security review
- 🟡 **MEDIUM**: Plan for next sprint
- 🟢 **LOW**: Document as tech debt

---

## ✅ Quick Verification

Verify everything is working:

```bash
# 1. Install dependencies
npm install

# 2. Run tests
npm run test:cov

# 3. Lint code
npm run lint

# 4. Build project
npm run build

# 5. Start application
npm run start:prod &

# 6. Test application
curl http://localhost:3000

# 7. Run security scan
npm run security:scan-local
```

If all pass ✅ - You're ready to go!

---

**Version**: 1.0.0  
**Last Updated**: December 2024  
**Status**: Production Ready ✅
