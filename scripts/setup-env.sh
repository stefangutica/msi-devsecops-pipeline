#!/bin/bash

# Docker Compose setup and local environment initialization

set -e

echo "🚀 Starting DevSecOps local environment..."
echo ""

# Create necessary directories
mkdir -p zap-reports
mkdir -p reports
mkdir -p security/alerts

# Pull images to ensure latest versions with security patches
echo "📦 Pulling latest Docker images..."
docker compose -f docker/docker-compose.yml pull

# Start services
echo "🔄 Starting Docker containers..."
docker compose -f docker/docker-compose.yml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if services are running
echo ""
echo "✅ Services started:"
docker compose -f docker/docker-compose.yml ps

echo ""
echo "🔐 DevSecOps Services Available:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 SonarQube:     http://localhost:9000"
echo "📈 Prometheus:    http://localhost:9090"
echo "📉 Grafana:       http://localhost:3001"
echo "🛡️  OWASP ZAP:     http://localhost:8080"
echo "🔑 Vault:         http://localhost:8200"
echo "🚀 Application:   http://localhost:3000"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "📝 Default Credentials:"
echo "   SonarQube: admin / admin"
echo "   Grafana:   admin / admin"
echo "   Vault:     Token: myroot"
echo ""

echo "🛑 To stop services, run:"
echo "   docker compose -f docker/docker-compose.yml down"
echo ""
