# GitHub Setup Guide

## 🔧 Configure Your GitHub Repository for DevSecOps

Follow these steps to enable full DevSecOps pipeline functionality in your GitHub repository.

---

## 1️⃣ Add GitHub Secrets

### Navigate to Repository Settings
1. Go to your GitHub repository
2. Click **Settings** tab
3. Go to **Secrets and variables** → **Actions**

### Add Required Secrets

#### SONAR_HOST_URL
- **Name**: `SONAR_HOST_URL`
- **Value**: Your SonarQube instance URL
  - Cloud: `https://sonarcloud.io`
  - Self-hosted: `https://your-sonarqube-server.com`

#### SONAR_LOGIN
- **Name**: `SONAR_LOGIN`
- **Value**: Your SonarQube authentication token
  - Generate in SonarQube: My Account → Security → Tokens

#### SNYK_TOKEN (Optional)
- **Name**: `SNYK_TOKEN`
- **Value**: Your Snyk API token
  - Get from: https://app.snyk.io/account/api-token
  - Only needed if using Snyk

### Example Setup
```
Settings → Secrets and variables → Actions → New repository secret

Name: SONAR_HOST_URL
Value: http://localhost:9000

Name: SONAR_LOGIN
Value: squ_1234567890abcdef...

Name: SNYK_TOKEN
Value: (optional for advanced SCA)
```

---

## 2️⃣ Enable Code Scanning

### GitHub Code Scanning
1. Go to **Security** tab
2. Click **Code scanning** (left sidebar)
3. Set up code scanning alerts

### SARIF Uploads
The pipeline automatically uploads SARIF files to GitHub:
- **Semgrep** - SAST findings
- **Trivy** - Container vulnerabilities
- **Grype** - Container analysis
- **Checkov** - IaC issues

View results in: **Security** → **Code scanning** → **Alerts**

---

## 3️⃣ Configure Branch Protection

### Set Up Branch Protection Rules
1. Go to **Settings** → **Branches**
2. Add rule for `main` branch
3. Configure protections:

```
✅ Require status checks to pass before merging
   ├─ devsecops-pipeline (required)
   ├─ build
   ├─ test
   └─ security-scan

✅ Require code reviews before merging
   └─ Dismiss stale pull request approvals

✅ Require branches to be up to date before merging
```

### Check Requirements
The following checks must pass:
- Setup & Dependencies
- SAST Scanning
- SCA Scanning
- Secret Scanning
- Quality & Testing
- Container Scanning

---

## 4️⃣ Configure Advanced Security Features

### Enable GitHub Advanced Security (Enterprise)
1. Go to **Settings** → **Security**
2. Enable:
   - ✅ Code scanning
   - ✅ Secret scanning
   - ✅ Dependabot alerts

### Configure Dependabot
1. Go to **Settings** → **Code security**
2. Enable:
   - ✅ Dependabot alerts
   - ✅ Dependabot security updates
   - ✅ Dependency graph

### Add .dependabot.yml
```yaml
version: 2
updates:
  - package-ecosystem: npm
    directory: "/"
    schedule:
      interval: weekly
    reviewers:
      - your-username
    labels:
      - dependencies
```

---

## 5️⃣ Configure Notifications

### Email Notifications
1. Go to **Settings** → **Notifications**
2. Choose notification preferences:
   - Participating
   - Watching
   - All Activity

### Integrations (Optional)

#### Slack Integration
1. Go to **Settings** → **Integrations** → **Slack**
2. Connect Slack workspace
3. Configure channels for:
   - CI/CD pipeline results
   - Security alerts
   - Pull request reviews

#### Teams Integration
1. Create incoming webhook in Teams
2. Add to GitHub workflow notifications
3. Get alerts in Microsoft Teams

---

## 6️⃣ Create Security Policy

### Add SECURITY.md
Create a file named `SECURITY.md` in repository root:

```markdown
# Security Policy

## Reporting Security Vulnerabilities

**DO NOT** create public GitHub issues for security vulnerabilities.

Please email security@example.com with:
1. Vulnerability description
2. Affected versions
3. Steps to reproduce
4. Suggested fix (if any)

We will respond within 24 hours.

## Supported Versions

| Version | Security Support |
|---------|-----------------|
| 1.x     | Active          |
| 0.x     | Ended           |

## Security Practices

- Regular dependency updates
- Automated vulnerability scanning
- Code review before merge
- Security training for team
```

---

## 7️⃣ Monitor Pipeline Runs

### View Pipeline Results
1. Go to **Actions** tab
2. Click on **DevSecOps Pipeline**
3. See job results:

```
✅ Setup & Dependencies
✅ SAST (SonarQube, Semgrep)
✅ SCA (npm audit, Snyk, Dependency-Check)
✅ Secret Scanning
✅ Quality & Testing
✅ Container Scanning
✅ DAST (Main branch)
✅ Reporting
```

### View Security Findings
1. Go to **Security** tab
2. Check:
   - **Code scanning** - SAST results
   - **Secret scanning** - Detected secrets
   - **Dependabot alerts** - Dependency vulnerabilities

---

## 8️⃣ Configure Code Owners

### Add CODEOWNERS File
Create `.github/CODEOWNERS`:

```
# Security-related files
.github/workflows/devsecops-pipeline.yml @security-team
docker/ @devops-team
security/ @security-team
DEVSECOPS.md @security-team

# Source code
src/ @development-team
test/ @qa-team

# All files need review
* @owner
```

---

## 9️⃣ Set Up Release Process

### Create RELEASE_PROCESS.md

```markdown
# Release Process

## Pre-Release Checklist

- [ ] All tests passing
- [ ] Security scans passing
- [ ] Code review approved
- [ ] Dependencies updated
- [ ] Documentation updated
- [ ] Changelog updated
- [ ] Version bumped
- [ ] Tagged in git

## Deployment Steps

1. Create release branch
2. Update version numbers
3. Update changelog
4. Create pull request
5. Wait for all checks
6. Merge to main
7. Create GitHub release
8. Tag and push
```

---

## 🔟 Create Documentation

### Add to Repository

**Files to create:**
- `SECURITY.md` - Security reporting policy
- `CONTRIBUTING.md` - Contribution guidelines
- `RELEASE_PROCESS.md` - Release procedures

**Examples provided in setup instructions.**

---

## Verification Checklist

- [ ] SONAR_HOST_URL secret added
- [ ] SONAR_LOGIN secret added
- [ ] SNYK_TOKEN secret added (if using Snyk)
- [ ] Branch protection configured
- [ ] Code scanning enabled
- [ ] Secret scanning enabled
- [ ] Dependabot alerts enabled
- [ ] SECURITY.md created
- [ ] CODEOWNERS file created
- [ ] Notifications configured

---

## Common Issues & Solutions

### Issue: Workflow doesn't run
**Solution**: 
1. Check if `.github/workflows/devsecops-pipeline.yml` exists
2. Verify file is properly formatted YAML
3. Check branch name matches trigger (main/develop)

### Issue: SonarQube authentication fails
**Solution**:
1. Verify SONAR_HOST_URL is correct
2. Generate new token in SonarQube
3. Update SONAR_LOGIN secret
4. Check firewall access

### Issue: Snyk errors
**Solution**:
1. Verify SNYK_TOKEN is valid
2. Check Snyk account status
3. Ensure organization is linked

### Issue: Secret scanning false positives
**Solution**:
1. Update `.secrets.baseline` with known safe patterns
2. Configure detect-secrets rules
3. Review and approve in PR

---

## Next Steps

1. ✅ Add all secrets to GitHub
2. ✅ Enable branch protection
3. ✅ Configure security features
4. ✅ Create security documentation
5. ✅ Set up notifications
6. ✅ Test pipeline with a PR
7. ✅ Review first security scan results
8. ✅ Configure team access

---

## Security Best Practices

### For Secrets
- ✅ Use GitHub Secrets, not .env files
- ✅ Rotate tokens regularly
- ✅ Use least privilege tokens
- ✅ Never commit credentials

### For Access
- ✅ Use branch protection
- ✅ Require code reviews
- ✅ Enforce status checks
- ✅ Use CODEOWNERS

### For Monitoring
- ✅ Watch security alerts
- ✅ Review scan results
- ✅ Track metrics
- ✅ Update dependencies

---

## 🆘 Getting Help

### GitHub Documentation
- [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [Code Scanning](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning)

### Tool Documentation
- [SonarQube Docs](https://docs.sonarqube.org/)
- [Snyk Docs](https://docs.snyk.io/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)

---

## ✅ Final Verification

After completing setup:

1. **Push a test commit** to develop branch
2. **Wait for pipeline** to complete (~20 minutes)
3. **Check Actions tab** for results
4. **Review Security tab** for findings
5. **Verify PR comments** appear on pull requests
6. **Test branch protection** with a test PR

---

**Setup Version**: 1.0.0  
**Last Updated**: December 2024  
**Status**: Ready to Deploy ✅
