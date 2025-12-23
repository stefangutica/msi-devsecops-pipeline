#!/bin/bash

# Stop local DevSecOps environment

echo "🛑 Stopping DevSecOps environment..."
docker compose -f docker/docker-compose.yml down

echo "✅ Environment stopped."
echo ""
echo "To remove all volumes and data, run:"
echo "  docker compose -f docker/docker-compose.yml down -v"
echo ""
