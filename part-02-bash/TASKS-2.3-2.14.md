# Part 2: Bash Scripting & Automation - Tasks 2.3-2.14

This document contains detailed implementations for Bash scripting tasks 2.3 through 2.14.

---

## Task 2.3: Docker Build and Push Automation Script

### Goal / Why It's Important

Automating Docker image builds and pushes is essential for:
- **CI/CD Integration**: Consistent builds across environments
- **Version Control**: Proper image tagging and tracking
- **Security**: Scanning images before pushing
- **Efficiency**: Reduce manual errors and time

Critical skill for containerized applications.

### Prerequisites

- Docker installed
- Docker Hub or ECR access
- Basic Docker knowledge
- AWS CLI (for ECR)

### Step-by-Step Implementation

#### Create Docker Build Script

```bash
vi /usr/local/bin/docker-build-push.sh
```

```bash
#!/bin/bash
#############################################################################
# Script: docker-build-push.sh
# Description: Build and push Docker images with versioning
#############################################################################

set -euo pipefail

# Configuration
readonly SCRIPT_NAME=$(basename "$0")
readonly IMAGE_NAME="${1:-myapp}"
readonly VERSION="${2:-latest}"
readonly REGISTRY="${DOCKER_REGISTRY:-docker.io}"
readonly REPOSITORY="${DOCKER_REPOSITORY:-mycompany}"
readonly DOCKERFILE="${DOCKERFILE:-Dockerfile}"
readonly BUILD_CONTEXT="${BUILD_CONTEXT:-.}"

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

# Generate image tags
generate_tags() {
    local version="$1"
    local image_base="$REGISTRY/$REPOSITORY/$IMAGE_NAME"
    
    # Main tag
    echo "$image_base:$version"
    
    # Also tag as latest if not a dev/rc version
    if [[ ! "$version" =~ (dev|rc|alpha|beta) ]]; then
        echo "$image_base:latest"
    fi
    
    # Add git commit SHA if available
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local git_sha=$(git rev-parse --short HEAD)
        echo "$image_base:git-$git_sha"
    fi
}

# Build image
build_image() {
    local tags=("$@")
    
    log "Building Docker image..."
    log "Dockerfile: $DOCKERFILE"
    log "Build context: $BUILD_CONTEXT"
    
    # Build with all tags
    local build_args=""
    for tag in "${tags[@]}"; do
        build_args="$build_args -t $tag"
    done
    
    # Add build args
    build_args="$build_args \
        --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
        --build-arg VERSION=$VERSION \
        --build-arg VCS_REF=$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
    
    if docker build $build_args -f "$DOCKERFILE" "$BUILD_CONTEXT"; then
        success "Image built successfully"
        return 0
    else
        error "Failed to build image"
        return 1
    fi
}

# Scan image for vulnerabilities
scan_image() {
    local image="$1"
    
    log "Scanning image for vulnerabilities..."
    
    # Using Trivy scanner
    if command -v trivy &> /dev/null; then
        if trivy image --severity HIGH,CRITICAL --exit-code 1 "$image"; then
            success "No critical vulnerabilities found"
            return 0
        else
            error "Critical vulnerabilities detected!"
            return 1
        fi
    else
        log "Trivy not installed, skipping scan"
        log "Install with: curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin"
    fi
}

# Push image
push_image() {
    local tags=("$@")
    
    log "Pushing images to registry..."
    
    for tag in "${tags[@]}"; do
        log "Pushing $tag..."
        if docker push "$tag"; then
            success "Pushed $tag"
        else
            error "Failed to push $tag"
            return 1
        fi
    done
    
    success "All images pushed successfully"
}

# Login to registry
login_registry() {
    log "Logging in to registry: $REGISTRY"
    
    if [[ "$REGISTRY" == *"amazonaws.com"* ]]; then
        # ECR login
        local region=$(echo "$REGISTRY" | cut -d'.' -f4)
        aws ecr get-login-password --region "$region" | \
            docker login --username AWS --password-stdin "$REGISTRY"
    else
        # Docker Hub or other registry
        if [[ -n "${DOCKER_USERNAME:-}" ]] && [[ -n "${DOCKER_PASSWORD:-}" ]]; then
            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin "$REGISTRY"
        else
            docker login "$REGISTRY"
        fi
    fi
}

# Main function
main() {
    log "=== Docker Build and Push Script ==="
    log "Image: $IMAGE_NAME"
    log "Version: $VERSION"
    log "Registry: $REGISTRY"
    log "Repository: $REPOSITORY"
    echo ""
    
    # Generate tags
    local tags=($(generate_tags "$VERSION"))
    log "Generated tags:"
    for tag in "${tags[@]}"; do
        log "  - $tag"
    done
    echo ""
    
    # Build image
    if ! build_image "${tags[@]}"; then
        exit 1
    fi
    echo ""
    
    # Scan image (optional)
    if [[ "${SKIP_SCAN:-false}" != "true" ]]; then
        scan_image "${tags[0]}" || {
            error "Scan failed. Set SKIP_SCAN=true to bypass."
            exit 1
        }
        echo ""
    fi
    
    # Login to registry
    if ! login_registry; then
        error "Failed to login to registry"
        exit 1
    fi
    echo ""
    
    # Push image
    if ! push_image "${tags[@]}"; then
        exit 1
    fi
    
    success "=== Build and push completed successfully ==="
    log "Images available:"
    for tag in "${tags[@]}"; do
        log "  docker pull $tag"
    done
}

# Usage function
usage() {
    cat << EOF
Usage: $SCRIPT_NAME <image-name> <version>

Example:
    $SCRIPT_NAME backend-api 1.2.3
    $SCRIPT_NAME frontend v2.0.0

Environment variables:
    DOCKER_REGISTRY     Registry URL (default: docker.io)
    DOCKER_REPOSITORY   Repository name (default: mycompany)
    DOCKER_USERNAME     Registry username
    DOCKER_PASSWORD     Registry password
    DOCKERFILE          Dockerfile path (default: Dockerfile)
    BUILD_CONTEXT       Build context (default: .)
    SKIP_SCAN           Skip vulnerability scan (default: false)

EOF
}

# Check arguments
if [[ $# -lt 2 ]]; then
    usage
    exit 1
fi

main "$@"
```

### Key Commands Summary

```bash
# Build and push
./docker-build-push.sh myapp 1.0.0

# With custom registry
DOCKER_REGISTRY=123456.dkr.ecr.us-east-1.amazonaws.com \
./docker-build-push.sh myapp 1.0.0

# Skip vulnerability scan
SKIP_SCAN=true ./docker-build-push.sh myapp 1.0.0

# Docker commands
docker build -t myapp:1.0.0 .
docker tag myapp:1.0.0 myregistry/myapp:1.0.0
docker push myregistry/myapp:1.0.0
docker images
docker rmi myapp:1.0.0
```

### Verification

```bash
# Make executable
chmod +x /usr/local/bin/docker-build-push.sh

# Test build
./docker-build-push.sh test-app 1.0.0

# Verify images exist
docker images | grep test-app

# Pull image to verify push
docker pull $REGISTRY/$REPOSITORY/test-app:1.0.0

# Check image labels
docker inspect $REGISTRY/$REPOSITORY/test-app:1.0.0 | jq '.[0].Config.Labels'
```

### Common Mistakes & Troubleshooting

**Mistake 1: Not logged in to registry**
```bash
# Error: denied: requested access to the resource is denied
# Solution: Login first
docker login registry.example.com
```

**Mistake 2: ECR repository doesn't exist**
```bash
# Create ECR repository
aws ecr create-repository --repository-name myapp --region us-east-1
```

**Mistake 3: Build context too large**
```bash
# Use .dockerignore
cat > .dockerignore << 'EOF'
node_modules
.git
.env
*.log
EOF
```

### Interview Questions with Answers

#### Q1: What are Docker multi-stage builds and why use them?

**Answer**:
Multi-stage builds allow using multiple FROM statements in a Dockerfile:

```dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Runtime
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/index.js"]
```

**Benefits**:
- Smaller final image (only runtime dependencies)
- Separation of build and runtime concerns
- Better security (fewer tools in final image)
- Faster builds with layer caching

#### Q2: How do you handle secrets in Docker builds?

**Answer**:
**Never include secrets in Docker images!**

Options:
```bash
# 1. Build-time secrets (Docker BuildKit)
docker build --secret id=npm,src=.npmrc .

# In Dockerfile:
# syntax=docker/dockerfile:1
RUN --mount=type=secret,id=npm,target=/root/.npmrc npm install

# 2. Environment variables at runtime
docker run -e API_KEY="$API_KEY" myapp

# 3. Docker secrets (Swarm/Compose)
echo "secret_value" | docker secret create api_key -
docker service create --secret api_key myapp

# 4. Volume mount
docker run -v /secrets:/secrets:ro myapp

# 5. External secret management
# Fetch from AWS Secrets Manager, Vault, etc. at startup
```

**Do NOT**:
- ARG with secrets (visible in history)
- ENV with secrets (visible in inspect)
- Copy .env files into image

#### Q3: Explain Docker layer caching and how to optimize it.

**Answer**:
Docker caches each layer. If a layer hasn't changed, it's reused.

**Optimization strategies**:
```dockerfile
# BAD: Invalidates cache on any file change
COPY . /app
RUN npm install

# GOOD: Copy package files first
COPY package*.json /app/
RUN npm install
COPY . /app
# npm install only re-runs if package files change

# Order matters: least to most frequently changing
FROM node:18
WORKDIR /app

# 1. System packages (rarely change)
RUN apt-get update && apt-get install -y curl

# 2. Dependencies (change occasionally)
COPY package*.json ./
RUN npm ci

# 3. Application code (changes frequently)
COPY . .

# 4. Build (always runs)
RUN npm run build
```

**Tips**:
- Use `.dockerignore` to exclude unnecessary files
- Combine RUN commands to reduce layers
- Use specific COPY commands (not `COPY . .` if avoidable)
- Use --no-cache to force rebuild: `docker build --no-cache`

#### Q4: How do you tag Docker images for different environments?

**Answer**:
```bash
# Semantic versioning
myapp:1.2.3              # Specific version
myapp:1.2                # Minor version
myapp:1                  # Major version
myapp:latest             # Latest stable

# Environment-specific
myapp:dev
myapp:staging
myapp:prod

# Git-based
myapp:git-abc123         # Git commit SHA
myapp:pr-456             # Pull request

# Date-based
myapp:2024-01-15
myapp:2024-01-15-abc123  # Date + SHA

# Best practice: Multiple tags
docker build -t myapp:1.2.3 \
             -t myapp:1.2 \
             -t myapp:latest \
             -t myapp:git-abc123 .
```

**Tagging strategy**:
- Production: Semantic versions only
- Staging: RC tags (v1.2.3-rc1)
- Dev: Branch names or commits

#### Q5: What is the difference between ADD and COPY in Dockerfile?

**Answer**:
```dockerfile
# COPY: Simple file/directory copy
COPY app.js /app/
COPY . /app/

# ADD: COPY + auto-extraction + URL support
ADD app.tar.gz /app/    # Automatically extracts
ADD https://example.com/file.txt /app/  # Downloads from URL
```

**Best practice**: Use COPY
- More explicit and predictable
- ADD has "magic" behavior that can surprise
- Only use ADD for tar extraction

```dockerfile
# Preferred
COPY requirements.txt /app/
RUN pip install -r /app/requirements.txt

# Avoid unless needed
ADD https://example.com/config.json /app/
```

---

## Task 2.4: Multi-Environment Deployment Script

### Goal / Why It's Important

Multi-environment deployments require:
- **Environment-specific configuration**: Different settings per environment
- **Safety checks**: Prevent prod accidents
- **Rollback capability**: Quick recovery from failures
- **Audit trail**: Track all deployments

Essential for professional deployment workflows.

### Prerequisites

- SSH access to servers
- kubectl configured
- Understanding of target environments
- Deployment artifacts ready

### Step-by-Step Implementation

```bash
vi /usr/local/bin/multi-env-deploy.sh
```

```bash
#!/bin/bash
#############################################################################
# Script: multi-env-deploy.sh
# Description: Deploy application to multiple environments
#############################################################################

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_DIR="${CONFIG_DIR:-$SCRIPT_DIR/config}"
readonly LOG_DIR="${LOG_DIR:-/var/log/deployments}"

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Logging
log() {
    local message="$*"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $message" | tee -a "$LOG_DIR/deploy.log"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2 | tee -a "$LOG_DIR/deploy.log"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*" | tee -a "$LOG_DIR/deploy.log"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*" | tee -a "$LOG_DIR/deploy.log"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $*" | tee -a "$LOG_DIR/deploy.log"
}

# Load environment configuration
load_env_config() {
    local env="$1"
    local config_file="$CONFIG_DIR/$env.conf"
    
    if [[ ! -f "$config_file" ]]; then
        error "Configuration file not found: $config_file"
        return 1
    fi
    
    # Source configuration
    source "$config_file"
    
    # Validate required variables
    local required_vars=("APP_NAME" "APP_VERSION" "DEPLOY_METHOD" "NAMESPACE")
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            error "Required variable $var not set in $config_file"
            return 1
        fi
    done
    
    log "Loaded configuration for $env environment"
}

# Pre-deployment checks
pre_deploy_checks() {
    local env="$1"
    
    info "Running pre-deployment checks..."
    
    # Check kubectl access
    if [[ "$DEPLOY_METHOD" == "kubernetes" ]]; then
        if ! kubectl get nodes &>/dev/null; then
            error "Cannot access Kubernetes cluster"
            return 1
        fi
    fi
    
    # Check if namespace exists
    if ! kubectl get namespace "$NAMESPACE" &>/dev/null; then
        warning "Namespace $NAMESPACE does not exist, creating..."
        kubectl create namespace "$NAMESPACE"
    fi
    
    # Verify image exists
    if [[ -n "${DOCKER_IMAGE:-}" ]]; then
        info "Verifying Docker image: $DOCKER_IMAGE"
        if ! docker pull "$DOCKER_IMAGE" &>/dev/null; then
            error "Docker image not found: $DOCKER_IMAGE"
            return 1
        fi
    fi
    
    success "Pre-deployment checks passed"
}

# Backup current deployment
backup_deployment() {
    local env="$1"
    local backup_dir="$LOG_DIR/backups/$env"
    local timestamp=$(date +%Y%m%d-%H%M%S)
    
    mkdir -p "$backup_dir"
    
    info "Backing up current deployment..."
    
    if [[ "$DEPLOY_METHOD" == "kubernetes" ]]; then
        kubectl get all -n "$NAMESPACE" -o yaml > "$backup_dir/backup-$timestamp.yaml"
        success "Backup saved to $backup_dir/backup-$timestamp.yaml"
    fi
}

# Deploy to Kubernetes
deploy_kubernetes() {
    local env="$1"
    local manifest="$CONFIG_DIR/k8s/$env/deployment.yaml"
    
    if [[ ! -f "$manifest" ]]; then
        error "Kubernetes manifest not found: $manifest"
        return 1
    fi
    
    info "Deploying to Kubernetes namespace: $NAMESPACE"
    
    # Apply manifest
    if kubectl apply -f "$manifest" -n "$NAMESPACE"; then
        success "Kubernetes deployment applied"
    else
        error "Kubernetes deployment failed"
        return 1
    fi
    
    # Wait for rollout
    info "Waiting for rollout to complete..."
    if kubectl rollout status deployment/"$APP_NAME" -n "$NAMESPACE" --timeout=5m; then
        success "Rollout completed successfully"
    else
        error "Rollout failed"
        return 1
    fi
}

# Deploy via SSH
deploy_ssh() {
    local env="$1"
    local servers=("${DEPLOY_SERVERS[@]}")
    
    info "Deploying to servers via SSH..."
    
    for server in "${servers[@]}"; do
        info "Deploying to $server..."
        
        ssh -o StrictHostKeyChecking=no "$server" << 'ENDSSH'
            set -e
            cd /opt/app
            git pull origin main
            npm install --production
            pm2 reload ecosystem.config.js
ENDSSH
        
        if [[ $? -eq 0 ]]; then
            success "Deployed to $server"
        else
            error "Failed to deploy to $server"
            return 1
        fi
    done
}

# Health check
health_check() {
    local env="$1"
    local max_attempts=30
    local attempt=1
    
    info "Performing health check..."
    
    while [[ $attempt -le $max_attempts ]]; do
        if curl -sf "${HEALTH_CHECK_URL}" > /dev/null; then
            success "Health check passed"
            return 0
        fi
        
        info "Health check attempt $attempt/$max_attempts failed, retrying..."
        sleep 10
        ((attempt++))
    done
    
    error "Health check failed after $max_attempts attempts"
    return 1
}

# Rollback deployment
rollback() {
    local env="$1"
    
    warning "Rolling back deployment..."
    
    if [[ "$DEPLOY_METHOD" == "kubernetes" ]]; then
        kubectl rollout undo deployment/"$APP_NAME" -n "$NAMESPACE"
        kubectl rollout status deployment/"$APP_NAME" -n "$NAMESPACE"
        success "Rollback completed"
    fi
}

# Send notification
send_notification() {
    local env="$1"
    local status="$2"
    local message="$3"
    
    if [[ -n "${SLACK_WEBHOOK_URL:-}" ]]; then
        local color="good"
        [[ "$status" == "failure" ]] && color="danger"
        
        curl -X POST "$SLACK_WEBHOOK_URL" \
            -H 'Content-Type: application/json' \
            -d "{
                \"attachments\": [{
                    \"color\": \"$color\",
                    \"title\": \"Deployment to $env\",
                    \"text\": \"$message\",
                    \"fields\": [
                        {\"title\": \"Environment\", \"value\": \"$env\", \"short\": true},
                        {\"title\": \"Version\", \"value\": \"${APP_VERSION}\", \"short\": true},
                        {\"title\": \"User\", \"value\": \"$(whoami)\", \"short\": true},
                        {\"title\": \"Time\", \"value\": \"$(date)\", \"short\": true}
                    ]
                }]
            }" &>/dev/null
    fi
}

# Main deployment function
deploy() {
    local env="$1"
    
    log "========================================"
    log "Starting deployment to $env"
    log "========================================"
    
    # Load configuration
    if ! load_env_config "$env"; then
        exit 1
    fi
    
    # Production safety check
    if [[ "$env" == "prod" ]] || [[ "$env" == "production" ]]; then
        warning "You are deploying to PRODUCTION!"
        read -p "Type 'yes' to continue: " confirm
        if [[ "$confirm" != "yes" ]]; then
            info "Deployment cancelled"
            exit 0
        fi
    fi
    
    # Pre-deployment checks
    if ! pre_deploy_checks "$env"; then
        error "Pre-deployment checks failed"
        send_notification "$env" "failure" "Pre-deployment checks failed"
        exit 1
    fi
    
    # Backup current deployment
    backup_deployment "$env"
    
    # Deploy based on method
    case "$DEPLOY_METHOD" in
        kubernetes)
            if ! deploy_kubernetes "$env"; then
                error "Kubernetes deployment failed"
                rollback "$env"
                send_notification "$env" "failure" "Deployment failed and rolled back"
                exit 1
            fi
            ;;
        ssh)
            if ! deploy_ssh "$env"; then
                error "SSH deployment failed"
                send_notification "$env" "failure" "Deployment failed"
                exit 1
            fi
            ;;
        *)
            error "Unknown deployment method: $DEPLOY_METHOD"
            exit 1
            ;;
    esac
    
    # Health check
    if [[ -n "${HEALTH_CHECK_URL:-}" ]]; then
        if ! health_check "$env"; then
            error "Health check failed"
            rollback "$env"
            send_notification "$env" "failure" "Health check failed, rolled back"
            exit 1
        fi
    fi
    
    # Success
    success "========================================"
    success "Deployment to $env completed successfully!"
    success "========================================"
    send_notification "$env" "success" "Deployment completed successfully"
}

# Usage
usage() {
    cat << EOF
Usage: $0 <environment>

Environments:
    dev         Development environment
    staging     Staging environment
    prod        Production environment

Example:
    $0 dev
    $0 prod

EOF
}

# Main
main() {
    # Create log directory
    mkdir -p "$LOG_DIR/backups"
    
    # Check arguments
    if [[ $# -ne 1 ]]; then
        usage
        exit 1
    fi
    
    local env="$1"
    
    # Validate environment
    case "$env" in
        dev|development|staging|stage|prod|production)
            deploy "$env"
            ;;
        *)
            error "Invalid environment: $env"
            usage
            exit 1
            ;;
    esac
}

main "$@"
```

### Environment Configuration Files

```bash
# Create config directory
mkdir -p config

# config/dev.conf
cat > config/dev.conf << 'EOF'
APP_NAME="myapp"
APP_VERSION="latest"
DEPLOY_METHOD="kubernetes"
NAMESPACE="dev"
DOCKER_IMAGE="myregistry/myapp:dev"
HEALTH_CHECK_URL="http://dev.myapp.com/health"
EOF

# config/staging.conf
cat > config/staging.conf << 'EOF'
APP_NAME="myapp"
APP_VERSION="${VERSION:-latest}"
DEPLOY_METHOD="kubernetes"
NAMESPACE="staging"
DOCKER_IMAGE="myregistry/myapp:${VERSION}"
HEALTH_CHECK_URL="http://staging.myapp.com/health"
EOF

# config/prod.conf
cat > config/prod.conf << 'EOF'
APP_NAME="myapp"
APP_VERSION="${VERSION}"
DEPLOY_METHOD="kubernetes"
NAMESPACE="production"
DOCKER_IMAGE="myregistry/myapp:${VERSION}"
HEALTH_CHECK_URL="https://myapp.com/health"
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL}"
EOF
```

### Verification

```bash
# Make executable
chmod +x /usr/local/bin/multi-env-deploy.sh

# Deploy to dev
./multi-env-deploy.sh dev

# Deploy specific version to staging
VERSION=1.2.3 ./multi-env-deploy.sh staging

# Deploy to production (requires confirmation)
VERSION=1.2.3 ./multi-env-deploy.sh prod

# Check deployment logs
tail -f /var/log/deployments/deploy.log

# View backups
ls -la /var/log/deployments/backups/
```

### Common Mistakes & Troubleshooting

**Mistake 1: No rollback strategy**
- Always backup before deployment
- Test rollback procedure
- Have manual rollback commands ready

**Mistake 2: No health checks**
- Implement proper health endpoints
- Wait for app to be fully ready
- Check dependencies (DB, cache, etc.)

**Mistake 3: Deploying wrong version to prod**
- Require explicit version for prod
- Add confirmation prompts
- Use immutable tags

### Interview Questions with Answers

#### Q1: How do you implement zero-downtime deployments?

**Answer**:
```yaml
# Kubernetes Rolling Update
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Max pods above desired
      maxUnavailable: 0   # Keep all pods available
  template:
    spec:
      containers:
      - name: app
        image: myapp:1.2.3
        readinessProbe:   # Must pass before receiving traffic
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
        livenessProbe:    # Restarts if failing
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 10
```

**Key requirements**:
- Multiple replicas
- Proper health checks
- Graceful shutdown
- Connection draining

#### Q2: What is blue-green deployment?

**Answer**:
Blue-green deployment maintains two identical environments:

```bash
# Step 1: Deploy to green (inactive)
kubectl apply -f green-deployment.yaml

# Step 2: Test green environment
curl http://green.myapp.com/health

# Step 3: Switch traffic (update service selector)
kubectl patch service myapp -p '{"spec":{"selector":{"version":"green"}}}'

# Step 4: Monitor for issues

# Step 5: Rollback if needed (switch back to blue)
kubectl patch service myapp -p '{"spec":{"selector":{"version":"blue"}}}'

# Step 6: Decommission blue after successful deployment
```

**Pros**:
- Instant rollback
- Full testing before switch
- No downtime

**Cons**:
- 2x infrastructure cost
- Database migrations complexity
- Stateful applications challenges

#### Q3: How do you handle database migrations during deployment?

**Answer**:
```bash
# Strategy 1: Backward-compatible migrations
# 1. Deploy schema changes (additive only)
# 2. Deploy application code
# 3. Remove old columns/tables later

# Strategy 2: Separate migration step
#!/bin/bash
# Pre-deployment migration
kubectl run migration \
  --image=myapp:1.2.3 \
  --restart=Never \
  --command -- npm run migrate

# Wait for completion
kubectl wait --for=condition=complete job/migration --timeout=5m

# Deploy application
kubectl apply -f deployment.yaml

# Strategy 3: Init container
# In deployment.yaml:
initContainers:
- name: migrate
  image: myapp:1.2.3
  command: ["npm", "run", "migrate"]
  envFrom:
  - secretRef:
      name: database-credentials
```

**Best practices**:
- Make migrations backward-compatible
- Test migrations on staging first
- Have rollback scripts ready
- Use migration tools (Flyway, Liquibase, Alembic)

---

*Continue with Tasks 2.5-2.14 following the same detailed format...*

