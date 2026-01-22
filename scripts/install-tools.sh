#!/bin/bash

# Install security scanning tools locally

echo "🔐 Installing DevSecOps Security Tools..."
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Install Node.js security tools
echo -e "${YELLOW}[1] Installing Node.js security tools...${NC}"
npm install -g snyk npm-audit-html

# 2. Install Python-based tools
echo -e "${YELLOW}[2] Installing Python tools...${NC}"
if command -v pip3 &> /dev/null; then
    pip3 install --upgrade pip
    pip3 install truffleHog semgrep detect-secrets
else
    echo "Python 3 is required. Please install it first."
fi

# 3. Install Docker scanning tools
echo -e "${YELLOW}[3] Checking for Docker scanning tools...${NC}"
if ! command -v trivy &> /dev/null; then
    echo "📥 Installing Trivy..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
else
    echo -e "${GREEN}✓ Trivy is already installed${NC}"
fi

if ! command -v grype &> /dev/null; then
    echo "📥 Installing Grype..."
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
else
    echo -e "${GREEN}✓ Grype is already installed${NC}"
fi

# 4. Install OWASP tools
echo -e "${YELLOW}[4] Installing OWASP tools...${NC}"
if ! command -v zaproxy &> /dev/null; then
    echo "⚠️  ZAP CLI not found. It will run via Docker in the pipeline."
fi

# 5. Make scripts executable
chmod +x scripts/*.sh

echo ""
echo -e "${GREEN}✅ Security tools installation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Configure Snyk: snyk auth"
echo "2. Start local environment: bash scripts/setup-env.sh"
echo "3. Run security scans: bash scripts/local-security-scan.sh"
echo ""
