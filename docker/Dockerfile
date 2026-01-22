# Multi-stage Docker build for security best practices
# Stage 1: Builder
FROM node:18-alpine AS builder

WORKDIR /app

# Install security updates
RUN apk update && apk add --no-cache \
    curl \
    git \
    python3 \
    make \
    g++ \
    && rm -rf /var/cache/apk/*

# Copy package files
COPY package*.json ./
COPY tsconfig*.json ./

# Install all dependencies (including dev) for build
RUN npm ci && \
    npm audit --audit-level=moderate || true

# Copy source code
COPY src ./src

# Build application
RUN npm run build

# Remove dev dependencies for production image
RUN npm prune --omit=dev

# Stage 2: Runtime
FROM node:18-alpine

WORKDIR /app

# Install security updates, curl, and dumb-init
# FIX: Installed dumb-init and created a symlink to /sbin/dumb-init to fix the error
RUN apk update && apk add --no-cache \
    curl \
    dumb-init \
    && ln -s /usr/bin/dumb-init /sbin/dumb-init \
    && rm -rf /var/cache/apk/*

# Create non-root user for security
RUN addgroup -g 1001 nodejs && \
    adduser -S nodejs -u 1001

# Copy only production dependencies and built code from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Change ownership to non-root user
RUN chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Expose port
EXPOSE 3000

# FIX: Explicitly set Entrypoint to use dumb-init
ENTRYPOINT ["/sbin/dumb-init", "--"]

# Start application
CMD ["node", "dist/main.js"]

# Build metadata
LABEL org.opencontainers.image.title="MSI DevSecOps" \
      org.opencontainers.image.description="NestJS application with DevSecOps practices" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.authors="DevSecOps Team"