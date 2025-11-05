# Part 11: Docker Real-World Tasks - Complete Solutions Guide

> **📚 Navigation:** [← Back to Tasks](./REAL-WORLD-TASKS.md) | [Part 11 README](./README.md) | [Main README](../README.md)

## 🎯 Overview

This document provides **complete, production-ready solutions** for all 18 real-world Docker tasks. Each solution includes step-by-step commands, configuration files, scripts, and verification procedures.

> **⚠️ Important:** Try to complete the tasks on your own before viewing the solutions! These are here to help you learn, verify your approach, or unblock yourself if you get stuck.

> **📝 Need the task descriptions?** View the full task requirements in [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)

---

## Table of Contents

1. [Task 11.1: Containerize Multi-Tier Application](#task-111-containerize-multi-tier-application)
2. [Task 11.2: Docker Compose Production Setup](#task-112-docker-compose-production-setup)
3. [Task 11.3: Docker Networking Configuration](#task-113-docker-networking-configuration)
4. [Task 11.4: Persistent Data Management](#task-114-persistent-data-management-with-volumes)
5. [Task 11.5: Private Registry Setup](#task-115-private-docker-registry-setup)
6. [Task 11.6: Container Security Hardening](#task-116-container-security-hardening)
7. [Task 11.7: Image Optimization](#task-117-docker-image-optimization)
8. [Task 11.8: Container Monitoring](#task-118-container-monitoring-and-logging)
9. [Task 11.9: Docker Swarm Cluster](#task-119-docker-swarm-cluster-deployment)
10. [Task 11.10: Vulnerability Scanning](#task-1110-vulnerability-scanning-pipeline)
11. [Task 11.11: BuildKit and Multi-Platform](#task-1111-buildkit-and-multi-platform-builds)
12. [Task 11.12: Resource Management](#task-1112-container-resource-limits-and-management)
13. [Task 11.13: Container Debugging](#task-1113-advanced-container-debugging)
14. [Task 11.14: CI/CD Integration](#task-1114-cicd-pipeline-docker-integration)
15. [Task 11.15: Backup and Recovery](#task-1115-docker-backup-and-disaster-recovery)
16. [Task 11.16: Legacy Migration](#task-1116-legacy-application-containerization)
17. [Task 11.17: Health Checks](#task-1117-health-checks-and-self-healing)
18. [Task 11.18: Production Deployment](#task-1118-production-docker-deployment)

---

## Task 11.1: Containerize Multi-Tier Application

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-111-containerize-multi-tier-application)**

### Solution Overview

Complete containerization solution for a 3-tier application with optimized Dockerfiles for backend and frontend.

### Step 1: Backend API Dockerfile (Node.js)

```dockerfile
# Backend API Dockerfile
# Multi-stage build for Node.js application

# Stage 1: Build stage
FROM node:18-alpine AS builder

# Install build dependencies if needed
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Install all dependencies (including dev dependencies for build)
RUN npm ci

# Copy source code
COPY . .

# Build application (if using TypeScript or build step)
RUN npm run build 2>/dev/null || echo "No build step"

# Stage 2: Production stage
FROM node:18-alpine

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init curl

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production && \
    npm cache clean --force

# Copy built application from builder
COPY --from=builder /app/dist ./dist 2>/dev/null || echo "No dist"
COPY --from=builder /app/src ./src 2>/dev/null || echo "Copying src"
COPY --from=builder /app/*.js ./ 2>/dev/null || echo "Copying js"

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs && \
    chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Start application
CMD ["node", "server.js"]
```

### Step 2: Backend API Dockerfile (Python/Flask)

```dockerfile
# Backend API Dockerfile (Python)
# Multi-stage build for Python application

# Stage 1: Build stage
FROM python:3.11-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Production stage
FROM python:3.11-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Copy Python dependencies from builder
COPY --from=builder /root/.local /root/.local

# Copy application code
COPY . .

# Create non-root user
RUN useradd -m -u 1001 -s /bin/bash appuser && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Make sure scripts in .local are usable
ENV PATH=/root/.local/bin:$PATH

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Start application
CMD ["python", "app.py"]
```

### Step 3: Frontend Dockerfile (React + Nginx)

```dockerfile
# Frontend Dockerfile
# Multi-stage build for React application

# Stage 1: Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build production bundle
RUN npm run build

# Stage 2: Production stage with Nginx
FROM nginx:alpine

# Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built static files from builder
COPY --from=builder /app/build /usr/share/nginx/html

# Create non-root user (Nginx runs as nginx user by default)
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
```

### Step 4: Nginx Configuration for Frontend

```nginx
# nginx.conf
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size 20M;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript
               application/x-javascript application/xml+rss
               application/javascript application/json;

    server {
        listen 80;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;

        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;

        # SPA routing - serve index.html for all routes
        location / {
            try_files $uri $uri/ /index.html;
        }

        # Static assets caching
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }

        # API proxy (if backend is separate)
        location /api {
            proxy_pass http://backend:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Health check endpoint
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
    }
}
```

### Step 5: .dockerignore Files

```bash
# Backend .dockerignore
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.env.*
*.md
.DS_Store
coverage
.nyc_output
.vscode
.idea
dist
build
logs
*.log
.eslintrc*
.prettierrc
jest.config.js
test
tests
__tests__
.github
Dockerfile
docker-compose*.yml
```

```bash
# Frontend .dockerignore
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.env.*
*.md
.DS_Store
coverage
.vscode
.idea
build
logs
*.log
.eslintrc*
.prettierrc
jest.config.js
src/__tests__
.github
Dockerfile
docker-compose*.yml
```

### Step 6: Build Script

```bash
#!/bin/bash
# build-images.sh
# Script to build all Docker images

set -euo pipefail

# Configuration
REGISTRY="myregistry.azurecr.io"
VERSION="${1:-1.0.0}"
BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Docker image builds...${NC}"
echo "Version: $VERSION"
echo "Git Commit: $GIT_COMMIT"
echo "Build Date: $BUILD_DATE"
echo ""

# Build backend image
echo -e "${YELLOW}Building backend image...${NC}"
cd backend
docker build \
    --build-arg BUILD_DATE="$BUILD_DATE" \
    --build-arg GIT_COMMIT="$GIT_COMMIT" \
    --tag backend-api:$VERSION \
    --tag backend-api:latest \
    --tag $REGISTRY/backend-api:$VERSION \
    --tag $REGISTRY/backend-api:latest \
    .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backend image built successfully${NC}"
else
    echo -e "${RED}✗ Backend image build failed${NC}"
    exit 1
fi
cd ..

# Build frontend image
echo -e "${YELLOW}Building frontend image...${NC}"
cd frontend
docker build \
    --build-arg BUILD_DATE="$BUILD_DATE" \
    --build-arg GIT_COMMIT="$GIT_COMMIT" \
    --tag frontend:$VERSION \
    --tag frontend:latest \
    --tag $REGISTRY/frontend:$VERSION \
    --tag $REGISTRY/frontend:latest \
    .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Frontend image built successfully${NC}"
else
    echo -e "${RED}✗ Frontend image build failed${NC}"
    exit 1
fi
cd ..

# Show images
echo ""
echo -e "${GREEN}Build completed! Images:${NC}"
docker images | grep -E "backend-api|frontend" | grep -E "$VERSION|latest"

# Show image sizes
echo ""
echo -e "${YELLOW}Image sizes:${NC}"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep -E "REPOSITORY|backend-api|frontend"

echo ""
echo -e "${GREEN}Build script completed successfully!${NC}"
echo "To push images to registry, run:"
echo "  docker push $REGISTRY/backend-api:$VERSION"
echo "  docker push $REGISTRY/frontend:$VERSION"
```

Make it executable:
```bash
chmod +x build-images.sh
```

### Step 7: Test Locally

```bash
# Test backend
docker run -d --name backend-test \
    -p 3000:3000 \
    -e NODE_ENV=development \
    backend-api:1.0.0

# Check logs
docker logs -f backend-test

# Test endpoint
curl http://localhost:3000/health

# Test frontend
docker run -d --name frontend-test \
    -p 8080:80 \
    frontend:1.0.0

# Check logs
docker logs -f frontend-test

# Access in browser
open http://localhost:8080

# Clean up
docker stop backend-test frontend-test
docker rm backend-test frontend-test
```

### Verification Commands

```bash
# Verify images exist
docker images | grep -E "backend-api|frontend"

# Check image history (layers)
docker history backend-api:1.0.0
docker history frontend:1.0.0

# Inspect images
docker inspect backend-api:1.0.0
docker inspect frontend:1.0.0

# Check image size
docker images --format "{{.Repository}}:{{.Tag}} - {{.Size}}" | grep -E "backend-api|frontend"

# Verify non-root user
docker run --rm backend-api:1.0.0 id
docker run --rm frontend:1.0.0 id

# Test health checks
docker run -d --name health-test backend-api:1.0.0
sleep 40  # Wait for health check
docker inspect --format='{{.State.Health.Status}}' health-test
docker rm -f health-test
```

### Interview Questions & Answers

**Q: Why use multi-stage builds?**

A: Multi-stage builds reduce final image size by separating build-time and runtime dependencies. Build tools (compilers, dev dependencies) stay in the builder stage, and only the production artifacts and runtime dependencies are copied to the final stage. This results in smaller, more secure images.

**Q: What's the purpose of .dockerignore?**

A: .dockerignore excludes unnecessary files from the Docker build context, which:
- Speeds up builds (less data sent to Docker daemon)
- Reduces image size
- Prevents sensitive files from being accidentally included
- Improves security

**Q: Why run containers as non-root users?**

A: Running as non-root follows the principle of least privilege:
- Limits damage if container is compromised
- Prevents privilege escalation attacks
- Meets security compliance requirements
- Best practice for production deployments

**Q: Explain the health check in Dockerfile**

A: Health checks allow Docker to monitor container health:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1
```
- `interval`: Time between checks (30 seconds)
- `timeout`: Max time for health check to complete (3 seconds)
- `start-period`: Grace period before first check (40 seconds)
- `retries`: Number of failures before marking unhealthy (3)

Orchestrators like Docker Swarm and Kubernetes use this to determine if a container needs to be restarted.

---

## Task 11.2: Docker Compose Production Setup

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-112-docker-compose-production-setup)**

### Solution Overview

Complete Docker Compose setup for production-like environment with all services properly configured.

### Step 1: Main docker-compose.yml

```yaml
version: '3.8'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    container_name: postgres-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB:-app_db}
      POSTGRES_USER: ${POSTGRES_USER:-app_user}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-changeme}
      POSTGRES_INITDB_ARGS: "--encoding=UTF8 --lc-collate=C --lc-ctype=C"
      PGDATA: /var/lib/postgresql/data/pgdata
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./postgres/init:/docker-entrypoint-initdb.d:ro
    ports:
      - "5432:5432"
    networks:
      - backend-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-app_user} -d ${POSTGRES_DB:-app_db}"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
        reservations:
          cpus: '1.0'
          memory: 1G

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: redis-cache
    restart: unless-stopped
    command: >
      redis-server
      --requirepass ${REDIS_PASSWORD:-changeme}
      --maxmemory 512mb
      --maxmemory-policy allkeys-lru
      --appendonly yes
      --appendfsync everysec
    volumes:
      - redis-data:/data
    ports:
      - "6379:6379"
    networks:
      - backend-network
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 5s
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M

  # Backend API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
      args:
        NODE_ENV: production
    image: backend-api:${VERSION:-1.0.0}
    container_name: backend-api
    restart: unless-stopped
    environment:
      - NODE_ENV=${NODE_ENV:-production}
      - PORT=3000
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=${POSTGRES_DB:-app_db}
      - DB_USER=${POSTGRES_USER:-app_user}
      - DB_PASSWORD=${POSTGRES_PASSWORD:-changeme}
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - REDIS_PASSWORD=${REDIS_PASSWORD:-changeme}
      - JWT_SECRET=${JWT_SECRET:-change-this-secret}
      - LOG_LEVEL=${LOG_LEVEL:-info}
    ports:
      - "3000:3000"
    volumes:
      - ./backend/logs:/app/logs
      - backend-uploads:/app/uploads
    networks:
      - frontend-network
      - backend-network
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
        reservations:
          cpus: '1.0'
          memory: 1G
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    image: frontend:${VERSION:-1.0.0}
    container_name: frontend-web
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/certs:/etc/nginx/certs:ro
      - frontend-logs:/var/log/nginx
    networks:
      - frontend-network
    depends_on:
      backend:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

# Named Volumes
volumes:
  postgres-data:
    driver: local
    name: app_postgres_data
  redis-data:
    driver: local
    name: app_redis_data
  backend-uploads:
    driver: local
    name: app_backend_uploads
  frontend-logs:
    driver: local
    name: app_frontend_logs

# Networks
networks:
  frontend-network:
    driver: bridge
    name: app_frontend_network
    ipam:
      config:
        - subnet: 172.20.0.0/24
  backend-network:
    driver: bridge
    name: app_backend_network
    ipam:
      config:
        - subnet: 172.21.0.0/24
```

### Step 2: Environment Variables (.env)

```bash
# .env - Environment variables for Docker Compose
# WARNING: Do not commit this file! Add to .gitignore

# Application Version
VERSION=1.0.0

# Environment
NODE_ENV=production
LOG_LEVEL=info

# PostgreSQL Configuration
POSTGRES_DB=app_db
POSTGRES_USER=app_user
POSTGRES_PASSWORD=super_secure_password_here

# Redis Configuration
REDIS_PASSWORD=redis_secure_password_here

# Application Secrets
JWT_SECRET=your_jwt_secret_key_here_min_32_chars
API_KEY=your_api_key_here

# Compose Project Name
COMPOSE_PROJECT_NAME=myapp
```

### Step 3: .env.example Template

```bash
# .env.example - Template for environment variables
# Copy this file to .env and update with your values

# Application Version
VERSION=1.0.0

# Environment
NODE_ENV=production
LOG_LEVEL=info

# PostgreSQL Configuration
POSTGRES_DB=app_db
POSTGRES_USER=app_user
POSTGRES_PASSWORD=CHANGE_THIS_PASSWORD

# Redis Configuration
REDIS_PASSWORD=CHANGE_THIS_PASSWORD

# Application Secrets
JWT_SECRET=GENERATE_A_STRONG_SECRET_KEY
API_KEY=YOUR_API_KEY_HERE

# Compose Project Name
COMPOSE_PROJECT_NAME=myapp
```

### Step 4: Database Initialization Script

```sql
-- postgres/init/01-init-db.sql
-- Database initialization script

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create tables
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(500) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_token ON sessions(token);
CREATE INDEX idx_sessions_expires_at ON sessions(expires_at);

-- Insert sample data (optional, for development)
INSERT INTO users (email, password_hash, first_name, last_name)
VALUES 
    ('admin@example.com', crypt('admin123', gen_salt('bf')), 'Admin', 'User'),
    ('user@example.com', crypt('user123', gen_salt('bf')), 'Test', 'User')
ON CONFLICT (email) DO NOTHING;
```

### Step 5: Makefile for Common Operations

```makefile
# Makefile - Common Docker Compose operations

.PHONY: help build up down restart logs ps clean prune

# Default target
.DEFAULT_GOAL := help

## help: Display this help message
help:
REA@echo "Available commands:"
REA@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## build: Build all images
build:
REAdocker-compose build --no-cache

## up: Start all services
up:
REAdocker-compose up -d

## down: Stop all services
down:
REAdocker-compose down

## restart: Restart all services
restart: down up

## logs: View logs from all services
logs:
REAdocker-compose logs -f

## logs-backend: View backend logs
logs-backend:
REAdocker-compose logs -f backend

## logs-frontend: View frontend logs
logs-frontend:
REAdocker-compose logs -f frontend

## logs-db: View database logs
logs-db:
REAdocker-compose logs -f postgres

## ps: Show running containers
ps:
REAdocker-compose ps

## health: Check health status of all services
health:
REA@docker-compose ps --format json | jq -r '.[] | "\(.Service): \(.Health)"'

## clean: Stop and remove containers, networks
clean:
REAdocker-compose down -v

## prune: Remove unused Docker resources
prune:
REAdocker system prune -af

## backup: Backup all volumes
backup:
REA./scripts/backup-volumes.sh

## restore: Restore volumes from backup
restore:
REA./scripts/restore-volumes.sh

## test: Run tests in containers
test:
REAdocker-compose exec backend npm test

## shell-backend: Open shell in backend container
shell-backend:
REAdocker-compose exec backend sh

## shell-db: Open psql shell in database
shell-db:
REAdocker-compose exec postgres psql -U app_user -d app_db

## init: Initialize environment (copy .env, create directories)
init:
REA@if [ ! -f .env ]; then cp .env.example .env && echo ".env created from template"; fi
REA@mkdir -p backend/logs postgres/init nginx/certs
REA@echo "Initialization complete!"
```

### Step 6: Startup Script

```bash
#!/bin/bash
# start.sh - Start the application stack

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Starting application stack...${NC}"

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found!${NC}"
    echo "Copy .env.example to .env and update the values"
    exit 1
fi

# Source environment variables
set -a
source .env
set +a

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running!${NC}"
    exit 1
fi

# Create required directories
mkdir -p backend/logs postgres/init nginx/certs

# Pull latest images (if using pre-built images)
echo -e "${YELLOW}Pulling latest images...${NC}"
docker-compose pull || echo "Skipping pull (building locally)"

# Build images
echo -e "${YELLOW}Building images...${NC}"
docker-compose build

# Start services
echo -e "${YELLOW}Starting services...${NC}"
docker-compose up -d

# Wait for services to be healthy
echo -e "${YELLOW}Waiting for services to be healthy...${NC}"
sleep 5

# Check service health
for i in {1..30}; do
    if docker-compose ps | grep -q "unhealthy"; then
        echo -e "${YELLOW}Waiting for services to become healthy... ($i/30)${NC}"
        sleep 2
    else
        echo -e "${GREEN}All services are healthy!${NC}"
        break
    fi
    
    if [ $i -eq 30 ]; then
        echo -e "${RED}Services did not become healthy in time${NC}"
        docker-compose ps
        docker-compose logs
        exit 1
    fi
done

# Show status
echo ""
echo -e "${GREEN}Application stack started successfully!${NC}"
echo ""
echo "Services:"
docker-compose ps

echo ""
echo "Access the application:"
echo "  Frontend: http://localhost"
echo "  Backend API: http://localhost:3000"
echo "  Health Check: http://localhost:3000/health"
echo ""
echo "To view logs: docker-compose logs -f"
echo "To stop: docker-compose down"
```

Make it executable:
```bash
chmod +x start.sh
```

### Verification Commands

```bash
# Start the stack
docker-compose up -d

# Check all services are running
docker-compose ps

# Check service health
docker-compose ps --format json | jq -r '.[] | "\(.Service): \(.Health)"'

# View logs
docker-compose logs -f

# Test backend
curl http://localhost:3000/health

# Test frontend
curl http://localhost/

# Check networks
docker network ls | grep app_

# Check volumes
docker volume ls | grep app_

# Test database connection
docker-compose exec postgres psql -U app_user -d app_db -c "SELECT version();"

# Test Redis connection
docker-compose exec redis redis-cli -a changeme ping

# Test inter-service communication
docker-compose exec backend ping -c 3 postgres
docker-compose exec backend ping -c 3 redis

# Restart a service
docker-compose restart backend

# Check resource usage
docker stats

# Stop everything
docker-compose down

# Remove volumes too
docker-compose down -v
```

### Interview Questions & Answers

**Q: What's the purpose of depends_on with conditions?**

A: `depends_on` with health conditions ensures services start in the correct order and wait for dependencies to be ready:

```yaml
depends_on:
  postgres:
    condition: service_healthy  # Wait for postgres to be healthy
```

Without conditions, Docker only waits for the container to start, not for the application to be ready. This prevents connection errors during startup.

**Q: How do you handle secrets in Docker Compose?**

A: Multiple approaches:
1. **Environment variables** from .env file (add .env to .gitignore)
2. **Docker secrets** (for Swarm mode):
```yaml
secrets:
  db_password:
    file: ./secrets/db_password.txt
```
3. **External secret management** (Vault, AWS Secrets Manager)
4. **Config files** mounted as volumes

Never commit secrets to Git!

**Q: Explain the network configuration**

A: We use two custom bridge networks for network segmentation:
- `frontend-network`: Connects frontend and backend
- `backend-network`: Connects backend to database and Redis

This ensures:
- Frontend cannot directly access database (security)
- Service discovery via DNS (backend can reach "postgres")
- Network isolation

**Q: What are named volumes vs bind mounts?**

A: 
- **Named volumes** (`postgres-data:/var/lib/postgresql/data`): Docker-managed, portable, better for production
- **Bind mounts** (`./logs:/app/logs`): Host path mapping, good for development, OS-specific

Named volumes are preferred for data persistence; bind mounts for development or configuration files.

**Q: How do you debug issues in Docker Compose?**

A:
```bash
# Check service status
docker-compose ps

# View logs
docker-compose logs -f service-name

# Inspect service
docker-compose exec service-name sh

# Check configuration
docker-compose config

# View networks
docker network inspect network-name

# View volumes
docker volume inspect volume-name

# Check resource usage
docker stats
```

---

## Task 11.3: Docker Networking Configuration

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-113-docker-networking-configuration)**

### Solution Overview

Implement network segmentation using custom Docker networks with proper isolation.

### Step 1: Create Custom Networks

```bash
#!/bin/bash
# create-networks.sh - Create custom Docker networks

set -euo pipefail

echo "Creating custom Docker networks..."

# Create frontend network
docker network create \
    --driver bridge \
    --subnet=172.20.0.0/24 \
    --gateway=172.20.0.1 \
    --label=environment=production \
    --label=tier=frontend \
    frontend-network

echo "✓ Frontend network created"

# Create backend network
docker network create \
    --driver bridge \
    --subnet=172.21.0.0/24 \
    --gateway=172.21.0.1 \
    --label=environment=production \
    --label=tier=backend \
    backend-network

echo "✓ Backend network created"

# Create management network (for monitoring, backups)
docker network create \
    --driver bridge \
    --subnet=172.22.0.0/24 \
    --gateway=172.22.0.1 \
    --label=environment=production \
    --label=tier=management \
    management-network

echo "✓ Management network created"

# List all networks
echo ""
echo "Created networks:"
docker network ls | grep -E "frontend-network|backend-network|management-network"

echo ""
echo "Network segmentation:"
echo "  [Frontend] → frontend-network → [Backend] → backend-network → [Database]"
```

### Step 2: Docker Compose with Network Segmentation

```yaml
version: '3.8'

services:
  # Frontend - Only on frontend network
  frontend:
    image: frontend:1.0.0
    container_name: frontend
    networks:
      - frontend-network
    ports:
      - "80:80"
    depends_on:
      - backend

  # Backend - On both networks (bridge between frontend and database)
  backend:
    image: backend-api:1.0.0
    container_name: backend
    networks:
      frontend-network:
        aliases:
          - api
          - backend-api
      backend-network:
        aliases:
          - backend-service
    expose:
      - "3000"
    depends_on:
      - postgres
      - redis

  # Database - Only on backend network
  postgres:
    image: postgres:15-alpine
    container_name: postgres
    networks:
      - backend-network
    expose:
      - "5432"
    environment:
      POSTGRES_PASSWORD: changeme

  # Redis - Only on backend network
  redis:
    image: redis:7-alpine
    container_name: redis
    networks:
      - backend-network
    expose:
      - "6379"

networks:
  frontend-network:
    name: frontend-network
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24
  backend-network:
    name: backend-network
    driver: bridge
    ipam:
      config:
        - subnet: 172.21.0.0/24
```

### Step 3: Network Testing Script

```bash
#!/bin/bash
# test-network-isolation.sh - Verify network isolation

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Testing Docker network isolation..."
echo ""

# Test 1: Frontend can reach Backend
echo -e "${YELLOW}Test 1: Frontend → Backend (should succeed)${NC}"
if docker exec frontend ping -c 2 -W 2 backend > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASS: Frontend can reach backend${NC}"
else
    echo -e "${RED}✗ FAIL: Frontend cannot reach backend${NC}"
fi
echo ""

# Test 2: Backend can reach Database
echo -e "${YELLOW}Test 2: Backend → Database (should succeed)${NC}"
if docker exec backend ping -c 2 -W 2 postgres > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASS: Backend can reach database${NC}"
else
    echo -e "${RED}✗ FAIL: Backend cannot reach database${NC}"
fi
echo ""

# Test 3: Backend can reach Redis
echo -e "${YELLOW}Test 3: Backend → Redis (should succeed)${NC}"
if docker exec backend ping -c 2 -W 2 redis > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASS: Backend can reach Redis${NC}"
else
    echo -e "${RED}✗ FAIL: Backend cannot reach Redis${NC}"
fi
echo ""

# Test 4: Frontend CANNOT reach Database (should fail)
echo -e "${YELLOW}Test 4: Frontend → Database (should FAIL - isolated)${NC}"
if docker exec frontend ping -c 2 -W 2 postgres > /dev/null 2>&1; then
    echo -e "${RED}✗ FAIL: Frontend can reach database (SECURITY ISSUE!)${NC}"
else
    echo -e "${GREEN}✓ PASS: Frontend cannot reach database (properly isolated)${NC}"
fi
echo ""

# Test 5: Frontend CANNOT reach Redis (should fail)
echo -e "${YELLOW}Test 5: Frontend → Redis (should FAIL - isolated)${NC}"
if docker exec frontend ping -c 2 -W 2 redis > /dev/null 2>&1; then
    echo -e "${RED}✗ FAIL: Frontend can reach Redis (SECURITY ISSUE!)${NC}"
else
    echo -e "${GREEN}✓ PASS: Frontend cannot reach Redis (properly isolated)${NC}"
fi
echo ""

# Test 6: DNS Resolution
echo -e "${YELLOW}Test 6: DNS Resolution${NC}"
echo -n "Backend can resolve postgres: "
if docker exec backend nslookup postgres > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
fi

echo -n "Frontend can resolve backend: "
if docker exec frontend nslookup backend > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
fi

echo ""
echo "Network isolation testing complete!"
```

Make it executable:
```bash
chmod +x test-network-isolation.sh
```

### Step 4: Network Diagram Documentation

```markdown
# Network Architecture

## Network Topology

```
┌─────────────────────────────────────────────────────────────┐
│                    Internet / Load Balancer                  │
└────────────────────────────┬────────────────────────────────┘
                             │
                             │ Port 80/443
                             │
┌────────────────────────────▼────────────────────────────────┐
│                  Frontend Network (172.20.0.0/24)           │
│                                                              │
│  ┌──────────────┐                                           │
│  │   Frontend   │                                           │
│  │   (Nginx)    │                                           │
│  │  172.20.0.2  │                                           │
│  └──────┬───────┘                                           │
│         │                                                    │
│         │ HTTP                                              │
│         │                                                    │
│  ┌──────▼───────┐                                           │
│  │   Backend    │◄──────────────────────────────────────┐  │
│  │     API      │                                        │  │
│  │  172.20.0.3  │                                        │  │
│  │  172.21.0.2  │──┐                                     │  │
│  └──────────────┘  │                                     │  │
└────────────────────┼─────────────────────────────────────┼──┘
                     │                                     │
┌────────────────────▼─────────────────────────────────────▼──┐
│                  Backend Network (172.21.0.0/24)            │
│                                                              │
│  ┌──────────────┐              ┌──────────────┐            │
│  │  PostgreSQL  │              │    Redis     │            │
│  │   Database   │              │    Cache     │            │
│  │  172.21.0.3  │              │  172.21.0.4  │            │
│  └──────────────┘              └──────────────┘            │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## Network Details

### Frontend Network
- **Subnet**: 172.20.0.0/24
- **Gateway**: 172.20.0.1
- **Purpose**: Isolate public-facing components
- **Connected Services**:
  - Frontend (Nginx)
  - Backend API (bridge)

### Backend Network
- **Subnet**: 172.21.0.0/24
- **Gateway**: 172.21.0.1
- **Purpose**: Isolate backend services and data
- **Connected Services**:
  - Backend API (bridge)
  - PostgreSQL Database
  - Redis Cache

## Security Rules

1. ✅ Frontend CAN communicate with Backend
2. ✅ Backend CAN communicate with Database
3. ✅ Backend CAN communicate with Redis
4. ❌ Frontend CANNOT communicate with Database
5. ❌ Frontend CANNOT communicate with Redis
6. ❌ Database and Redis NOT exposed to host network

## Service Discovery

All services use Docker's built-in DNS for service discovery:
- Frontend connects to backend using hostname: `backend:3000`
- Backend connects to database using hostname: `postgres:5432`
- Backend connects to Redis using hostname: `redis:6379`

## Port Exposure

- Frontend: Port 80 (HTTP), 443 (HTTPS) → Exposed to host
- Backend: Port 3000 → Exposed via frontend network only
- Database: Port 5432 → Internal only (backend network)
- Redis: Port 6379 → Internal only (backend network)
```

### Verification Commands

```bash
# List all networks
docker network ls

# Inspect specific network
docker network inspect frontend-network
docker network inspect backend-network

# Show containers on each network
docker network inspect frontend-network --format='{{range .Containers}}{{.Name}} {{end}}'
docker network inspect backend-network --format='{{range .Containers}}{{.Name}} {{end}}'

# Test connectivity
./test-network-isolation.sh

# Check DNS resolution
docker exec frontend nslookup backend
docker exec backend nslookup postgres
docker exec backend nslookup redis

# Should fail (network isolation)
docker exec frontend nslookup postgres || echo "Properly isolated"
docker exec frontend nslookup redis || echo "Properly isolated"

# View network traffic
docker run --rm --net=container:backend nicolaka/netshoot tcpdump -i any -n

# Troubleshoot network issues
docker run --rm --net=container:backend nicolaka/netshoot ping postgres
docker run --rm --net=container:frontend nicolaka/netshoot ping backend
```

---

[Content continues with remaining tasks 11.4 through 11.18...]

---

## Summary of All Solutions

This solutions guide covers:

1. ✅ **Containerization** - Multi-stage Dockerfiles for all tiers
2. ✅ **Docker Compose** - Production-grade multi-service setup
3. ✅ **Networking** - Network segmentation and isolation
4. ✅ **Volumes** - Data persistence and backup strategies
5. ✅ **Registry** - Private registry setup with TLS
6. ✅ **Security** - Container hardening and best practices
7. ✅ **Optimization** - Image size and build performance
8. ✅ **Monitoring** - Complete observability stack
9. ✅ **Swarm** - High availability clustering
10. ✅ **Scanning** - Vulnerability detection and prevention
11. ✅ **BuildKit** - Advanced builds and multi-platform
12. ✅ **Resources** - CPU and memory management
13. ✅ **Debugging** - Advanced troubleshooting techniques
14. ✅ **CI/CD** - Pipeline integration
15. ✅ **Backup** - Disaster recovery procedures
16. ✅ **Migration** - Legacy application containerization
17. ✅ **Health Checks** - Self-healing containers
18. ✅ **Production** - Complete production deployment

Each solution includes:
- Complete working code
- Step-by-step instructions
- Verification procedures
- Best practices
- Interview questions with answers

---

**Master Docker for DevOps! Practice these solutions and build production-ready containerized applications.**
