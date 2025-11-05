# Part 11: Docker Containerization & Operations

## Overview

This section covers comprehensive Docker skills required for DevOps engineers managing containerized applications in production. All tasks are built around containerizing and deploying our 3-tier web application (Frontend, Backend API, PostgreSQL) using Docker and Docker Compose.

## 📚 Available Resources

### Real-World Tasks (Recommended Starting Point)
- **[REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)** - 📝 18 practical, executable tasks with scenarios, requirements, and validation checklists
- **[REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)** - ✅ Complete, production-ready solutions with step-by-step commands and scripts
- **[NAVIGATION-GUIDE.md](NAVIGATION-GUIDE.md)** - 📚 Learn how to navigate between tasks and solutions efficiently

### Quick Start & Additional Resources
- **[QUICK-START-GUIDE.md](QUICK-START-GUIDE.md)** - 🚀 Quick reference with task lookup table and learning paths

> **💡 New to real-world tasks?** Check out the [Navigation Guide](NAVIGATION-GUIDE.md) to understand how tasks and solutions are organized!

---

## Task 11.1: Containerize a Multi-Tier Application

### Goal / Why It's Important

Containerization is the foundation of modern DevOps practices. Converting applications to Docker containers enables:
- Consistent environments across dev, staging, and production
- Easier deployment and scaling
- Better resource utilization
- Simplified dependency management
- Faster CI/CD pipelines

This is a critical skill for any DevOps engineer and a common interview topic.

### Prerequisites

- Docker Engine 20.10+ installed
- Basic understanding of Dockerfile syntax
- Knowledge of web application architecture
- Access to application source code

### Step-by-Step Implementation

#### Step 1: Analyze Application Requirements

```bash
# Check application dependencies
cd /path/to/backend-api
cat package.json  # For Node.js
cat requirements.txt  # For Python
cat pom.xml  # For Java

# Understand runtime requirements
# - Base OS/image needed
# - Runtime version (Node 18, Python 3.11, etc.)
# - System dependencies
# - Configuration files
```

#### Step 2: Create Dockerfile for Backend API

```dockerfile
# Use official Node.js LTS image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production && \
    npm cache clean --force

# Copy application code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Expose application port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD node healthcheck.js || exit 1

# Start application
CMD ["node", "server.js"]
```

#### Step 3: Create .dockerignore File

```bash
# Create .dockerignore to exclude unnecessary files
cat > .dockerignore <<'EOF'
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
dist
build
logs
*.log
EOF
```

#### Step 4: Build Docker Image

```bash
# Build image with proper tagging
docker build -t backend-api:1.0.0 .

# Tag for registry
docker tag backend-api:1.0.0 myregistry/backend-api:1.0.0
docker tag backend-api:1.0.0 myregistry/backend-api:latest

# Verify image
docker images | grep backend-api

# Inspect image layers
docker history backend-api:1.0.0

# Check image size
docker images backend-api:1.0.0 --format "{{.Size}}"
```

#### Step 5: Test Container Locally

```bash
# Run container
docker run -d \
  --name backend-api-test \
  -p 3000:3000 \
  -e NODE_ENV=development \
  -e DB_HOST=postgres \
  backend-api:1.0.0

# Check logs
docker logs backend-api-test

# Test application
curl http://localhost:3000/health

# Access container shell for debugging
docker exec -it backend-api-test sh

# Stop and remove test container
docker stop backend-api-test
docker rm backend-api-test
```

### Key Commands/Configs

#### Essential Docker Commands

```bash
# Build image
docker build -t image:tag .

# Run container
docker run -d --name container-name -p host:container image:tag

# View logs
docker logs -f container-name

# Execute commands in container
docker exec -it container-name sh

# Copy files to/from container
docker cp file.txt container-name:/path/
docker cp container-name:/path/file.txt ./

# View resource usage
docker stats container-name

# Inspect container/image
docker inspect container-name
docker inspect image:tag

# Clean up
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker image prune -a
docker system prune -a
```

### Multi-Stage Build Example

```dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
USER node
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

### Verification

```bash
# Verify image exists
docker images | grep backend-api

# Verify container runs
docker run -d --name test backend-api:1.0.0
docker ps | grep test

# Verify health check
docker inspect test | grep -A 10 Health

# Test application functionality
curl http://localhost:3000/api/health

# Check security (run as non-root)
docker exec test id

# Verify resource limits
docker stats test --no-stream
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Large Image Size
**Problem**: Image size is several GB
**Solution**:
- Use Alpine-based images
- Use multi-stage builds
- Clean up caches and temporary files
- Combine RUN commands to reduce layers

#### Mistake 2: Running as Root
**Problem**: Container runs with root privileges
**Solution**:
```dockerfile
RUN addgroup -g 1001 appgroup && \
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser
USER appuser
```

#### Mistake 3: Hardcoded Configuration
**Problem**: Configuration values are hardcoded in image
**Solution**:
- Use environment variables
- Mount configuration files as volumes
- Use Docker secrets for sensitive data

#### Mistake 4: No Health Checks
**Problem**: Cannot determine if container is healthy
**Solution**:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:3000/health || exit 1
```

#### Troubleshooting Commands

```bash
# Container won't start
docker logs container-name
docker inspect container-name

# Build failures
docker build --no-cache -t image:tag .

# Permission issues
ls -la /path/to/files
docker exec container-name ls -la /app

# Network connectivity
docker exec container-name ping -c 3 google.com
docker exec container-name nslookup database-host

# Check container processes
docker exec container-name ps aux
```

### Interview Questions

#### Q1: What is the difference between CMD and ENTRYPOINT?
**Answer**: 
- **CMD**: Provides default arguments that can be overridden when running the container
- **ENTRYPOINT**: Sets the main command that always runs; CMD provides default arguments to ENTRYPOINT
- **Best Practice**: Use ENTRYPOINT for the main executable and CMD for default arguments

Example:
```dockerfile
ENTRYPOINT ["node"]
CMD ["server.js"]
# Can be overridden: docker run image debug.js
```

#### Q2: Explain multi-stage builds and their benefits
**Answer**:
Multi-stage builds use multiple FROM statements in a Dockerfile. Each stage can use a different base image and copy artifacts from previous stages.

**Benefits**:
- Smaller final image (only runtime dependencies)
- Separate build and runtime environments
- Better security (no build tools in production)
- Improved build caching

**Example Use Case**: Compile Go application in one stage, copy binary to minimal Alpine image in final stage.

#### Q3: How do you optimize Docker image size?
**Answer**:
1. **Use minimal base images**: Alpine Linux (5MB) vs Ubuntu (70MB+)
2. **Multi-stage builds**: Separate build and runtime stages
3. **Combine RUN commands**: Reduces layers
4. **Clean up in same layer**: `RUN apt-get update && apt-get install && apt-get clean`
5. **Use .dockerignore**: Exclude unnecessary files
6. **Remove package manager cache**: `npm cache clean --force`
7. **Use specific versions**: Avoid pulling unnecessary updates

#### Q4: What are Docker image layers and how do they affect performance?
**Answer**:
Each instruction in a Dockerfile creates a new layer. Layers are cached and reused.

**Impact on Performance**:
- **Build Speed**: Unchanged layers are reused from cache
- **Storage**: Layers are shared between images
- **Network**: Only changed layers are pushed/pulled

**Best Practices**:
- Order instructions from least to most frequently changing
- Combine related commands in single RUN
- Copy dependency files before application code

#### Q5: How do you implement health checks in Docker?
**Answer**:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1
```

**Parameters**:
- `--interval`: Time between checks
- `--timeout`: Time to wait for response
- `--start-period`: Grace period before first check
- `--retries`: Consecutive failures before unhealthy

**Options**: HTTP endpoint, TCP socket, script execution

#### Q6: What security best practices should you follow when building Docker images?
**Answer**:
1. **Run as non-root user**: Create and switch to non-root user
2. **Use official base images**: From trusted registries
3. **Scan for vulnerabilities**: Use docker scan or Trivy
4. **Minimize attack surface**: Remove unnecessary packages
5. **Don't include secrets**: Use Docker secrets or env vars
6. **Use specific versions**: Avoid latest tag
7. **Keep images updated**: Regular security patches
8. **Read-only filesystem**: When possible
9. **Limit capabilities**: Drop unnecessary Linux capabilities
10. **Use multi-stage builds**: Keep build tools out of production

#### Q7: Explain Docker build context and its importance
**Answer**:
Build context is the set of files sent to Docker daemon during build.

**Importance**:
- Affects build speed (large context = slow transfer)
- Determines which files can be COPYed
- Includes all subdirectories by default

**Optimization**:
- Use .dockerignore to exclude files
- Keep Dockerfile at project root
- Only copy necessary files
- Use specific paths instead of `.`

#### Q8: How do you debug a failing Docker container?
**Answer**:
```bash
# 1. Check logs
docker logs container-name
docker logs --tail 100 -f container-name

# 2. Inspect container
docker inspect container-name

# 3. Check processes
docker top container-name

# 4. Access shell
docker exec -it container-name sh

# 5. Check exit code
docker ps -a | grep container-name

# 6. View events
docker events --filter container=container-name

# 7. Run with different command
docker run -it image:tag sh
```

#### Q9: What is the difference between COPY and ADD in Dockerfile?
**Answer**:
**COPY**:
- Simple file/directory copy
- Preferred for basic copying
- More transparent behavior

**ADD**:
- Auto-extracts tar files
- Supports URLs
- More complex behavior

**Best Practice**: Use COPY unless you need ADD's special features.

```dockerfile
# Preferred
COPY package*.json ./

# Only if needed
ADD https://example.com/file.tar.gz ./
ADD archive.tar.gz /app/
```

#### Q10: How do you handle application configuration in Docker?
**Answer**:
**Methods**:
1. **Environment Variables**: `-e KEY=value` or env_file
2. **Config Files**: Mount as volume
3. **Docker Secrets**: For sensitive data (Swarm)
4. **Build Arguments**: For build-time configuration
5. **ConfigMaps**: In Kubernetes

**Example**:
```dockerfile
# Dockerfile
ARG NODE_VERSION=18
FROM node:${NODE_VERSION}

# Runtime
docker run -e DB_HOST=postgres \
  -e DB_PORT=5432 \
  --env-file .env \
  image:tag
```

**Best Practice**: Never hardcode secrets in images; use external configuration management.

---

## Task 11.2: Docker Compose for Multi-Container Applications

### Goal / Why It's Important

Docker Compose simplifies running multi-container applications by defining all services, networks, and volumes in a single YAML file. This is essential for:
- Local development environments
- Integration testing
- Small-scale deployments
- Documenting application architecture

### Prerequisites

- Docker Compose 2.x installed
- Understanding of YAML syntax
- Knowledge of Docker networking
- Familiarity with your application stack

### Step-by-Step Implementation

#### Step 1: Create docker-compose.yml

```yaml
version: '3.8'

services:
  # Backend API Service
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
      args:
        NODE_ENV: production
    image: backend-api:1.0.0
    container_name: backend-api
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=app_db
      - DB_USER=app_user
      - DB_PASSWORD_FILE=/run/secrets/db_password
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    env_file:
      - .env.backend
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started
    networks:
      - backend-network
    volumes:
      - ./backend/logs:/app/logs
      - backend-uploads:/app/uploads
    secrets:
      - db_password
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    container_name: postgres-db
    restart: unless-stopped
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=app_db
      - POSTGRES_USER=app_user
      - POSTGRES_PASSWORD_FILE=/run/secrets/db_password
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./postgres/init:/docker-entrypoint-initdb.d
    networks:
      - backend-network
    secrets:
      - db_password
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app_user -d app_db"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: redis-cache
    restart: unless-stopped
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis-data:/data
    networks:
      - backend-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Frontend (Nginx)
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    image: frontend:1.0.0
    container_name: frontend-web
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - backend
    networks:
      - backend-network
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/certs:/etc/nginx/certs:ro

# Named Volumes
volumes:
  postgres-data:
    driver: local
  redis-data:
    driver: local
  backend-uploads:
    driver: local

# Networks
networks:
  backend-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

# Secrets
secrets:
  db_password:
    file: ./secrets/db_password.txt
```

#### Step 2: Create Environment Files

```bash
# .env.backend
NODE_ENV=production
LOG_LEVEL=info
API_PORT=3000
JWT_SECRET_FILE=/run/secrets/jwt_secret
CORS_ORIGIN=https://example.com

# .env
REDIS_PASSWORD=your-redis-password
COMPOSE_PROJECT_NAME=myapp
```

#### Step 3: Essential Docker Compose Commands

```bash
# Start all services
docker-compose up -d

# Start specific service
docker-compose up -d backend

# View logs
docker-compose logs -f
docker-compose logs -f backend

# Check service status
docker-compose ps

# Execute command in service
docker-compose exec backend sh

# Stop services
docker-compose stop

# Stop and remove containers
docker-compose down

# Remove volumes too
docker-compose down -v

# Rebuild images
docker-compose build
docker-compose build --no-cache

# Scale services
docker-compose up -d --scale backend=3

# Validate compose file
docker-compose config

# View service logs
docker-compose logs --tail=100 postgres
```

### Verification

```bash
# Verify all services are running
docker-compose ps

# Check service health
docker-compose ps --services --filter "status=running"

# Test backend API
curl http://localhost:3000/health

# Test database connection
docker-compose exec postgres psql -U app_user -d app_db -c "SELECT version();"

# Verify network connectivity
docker-compose exec backend ping -c 3 postgres

# Check volumes
docker volume ls | grep myapp

# Inspect network
docker network inspect myapp_backend-network
```

### Interview Questions

#### Q1: What is Docker Compose and when should you use it?
**Answer**:
Docker Compose is a tool for defining and running multi-container Docker applications using YAML configuration.

**Use Cases**:
- Local development environments
- Automated testing
- Single-host deployments
- CI/CD pipelines
- Documenting multi-container architectures

**Not For**: Production orchestration at scale (use Kubernetes instead)

#### Q2: Explain depends_on and its limitations
**Answer**:
`depends_on` controls service startup order but doesn't wait for services to be "ready".

**Limitations**:
- Only waits for container to start, not application
- Doesn't retry if dependency fails

**Solution**: Use health checks with condition
```yaml
depends_on:
  postgres:
    condition: service_healthy
```

#### Q3: What's the difference between volumes and bind mounts in Compose?
**Answer**:
**Volumes** (Docker-managed):
```yaml
volumes:
  - postgres-data:/var/lib/postgresql/data
```
- Managed by Docker
- Platform-independent
- Better for production

**Bind Mounts** (host path):
```yaml
volumes:
  - ./app:/app
```
- Direct host path mapping
- Good for development
- OS-specific paths

#### Q4: How do you handle secrets in Docker Compose?
**Answer**:
```yaml
secrets:
  db_password:
    file: ./secrets/db_password.txt

services:
  app:
    secrets:
      - db_password
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password
```

**Best Practices**:
- Never commit secrets to Git
- Use `.env` files (add to .gitignore)
- Use external secret management in production
- Rotate secrets regularly

#### Q5: What is the bridge network in Docker Compose?
**Answer**:
Default network type that allows containers to communicate.

**Features**:
- Service name DNS resolution
- Isolated from host network
- Containers can reach each other by service name

**Example**: Backend can connect to `postgres:5432` instead of IP address.

---

## Additional Tasks Overview

The following tasks are covered in the **REAL-WORLD-TASKS.md** file:

- **Task 11.3**: Docker Networking and Container Communication
- **Task 11.4**: Docker Volumes and Data Persistence
- **Task 11.5**: Docker Registry Setup and Image Management
- **Task 11.6**: Docker Security Hardening
- **Task 11.7**: Docker Performance Optimization
- **Task 11.8**: Docker Logging and Monitoring
- **Task 11.9**: Docker Swarm Orchestration
- **Task 11.10**: Docker Image Scanning and Vulnerability Management
- **Task 11.11**: Docker Build Optimization with BuildKit
- **Task 11.12**: Docker Resource Limits and Constraints
- **Task 11.13**: Container Debugging and Troubleshooting
- **Task 11.14**: Docker CI/CD Integration
- **Task 11.15**: Docker Backup and Disaster Recovery
- **Task 11.16**: Docker Migration Strategies
- **Task 11.17**: Docker Health Checks and Self-Healing
- **Task 11.18**: Production Docker Deployment Patterns

---

## Learning Path

### Beginner Level
Start with:
- Task 11.1: Containerize applications
- Task 11.2: Docker Compose basics
- Task 11.3: Docker networking fundamentals
- Task 11.4: Volume management

### Intermediate Level
Progress to:
- Task 11.5: Registry management
- Task 11.6: Security hardening
- Task 11.7: Performance optimization
- Task 11.11: Build optimization

### Advanced Level
Master:
- Task 11.9: Docker Swarm
- Task 11.14: CI/CD integration
- Task 11.16: Migration strategies
- Task 11.18: Production patterns

---

## Best Practices Summary

### Dockerfile Best Practices
1. Use official base images
2. Minimize layers (combine RUN commands)
3. Use multi-stage builds
4. Run as non-root user
5. Implement health checks
6. Use .dockerignore
7. Pin specific versions
8. Clean up in same layer

### Security Best Practices
1. Scan images for vulnerabilities
2. Use minimal base images
3. Don't run as root
4. Keep images updated
5. Use secrets management
6. Implement least privilege
7. Enable content trust
8. Use private registries

### Performance Best Practices
1. Optimize build context
2. Leverage build cache
3. Use multi-stage builds
4. Minimize image size
5. Use appropriate base images
6. Configure resource limits
7. Use volume drivers efficiently
8. Monitor container metrics

---

## Quick Reference Commands

```bash
# Build
docker build -t image:tag .
docker-compose build

# Run
docker run -d --name container image:tag
docker-compose up -d

# Logs
docker logs -f container
docker-compose logs -f service

# Execute
docker exec -it container sh
docker-compose exec service sh

# Clean up
docker system prune -a
docker-compose down -v

# Inspect
docker inspect container
docker-compose config

# Network
docker network ls
docker network inspect network-name

# Volumes
docker volume ls
docker volume inspect volume-name
```

---

## Troubleshooting Guide

### Container Won't Start
```bash
docker logs container-name
docker inspect container-name
docker events --filter container=container-name
```

### Network Issues
```bash
docker network inspect network-name
docker exec container ping other-container
docker exec container nslookup service-name
```

### Performance Issues
```bash
docker stats container-name
docker top container-name
docker system df
```

### Build Issues
```bash
docker build --no-cache .
docker builder prune
docker system prune -a
```

---

**Ready to master Docker? Start with the [Real-World Tasks](REAL-WORLD-TASKS.md)!**
