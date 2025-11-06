# Complete Solutions: GitHub Tasks 3.10-3.18

> **📚 Navigation:** [← Part 1 (Tasks 3.1-3.9)](./REAL-WORLD-TASKS-SOLUTIONS.md) | [Back to Tasks](./REAL-WORLD-TASKS.md) | [Main README](../README.md)

## 🎯 Overview

This document provides **complete, production-ready solutions** for GitHub Repository & Workflows tasks 3.10-3.18. Each solution includes step-by-step implementation, code examples, configurations, and best practices.

---

## Table of Contents

- [Task 3.10: GitHub Packages/Container Registry](#task-310-github-packagescontainer-registry-setup)
- [Task 3.11: Repository Templates](#task-311-repository-templates-and-standardization)
- [Task 3.12: GitHub Apps & Webhooks](#task-312-github-apps-and-webhooks-integration)
- [Task 3.13: Secret Scanning & Push Protection](#task-313-secret-scanning--push-protection)
- [Task 3.14: GitHub API Automation](#task-314-github-api-automation)
- [Task 3.15: Disaster Recovery](#task-315-disaster-recovery)
- [Task 3.16: Performance Optimization](#task-316-performance-optimization)
- [Task 3.17: Compliance & Audit Logging](#task-317-compliance--audit-logging)
- [Task 3.18: Copilot Enterprise Rollout](#task-318-copilot-enterprise-rollout)

---

## Task 3.10: GitHub Packages/Container Registry Setup

### Complete Solution

**Objective:** Set up GitHub Packages for Docker containers and npm packages with automated publishing.

#### Step 1: Configure GitHub Container Registry

**Create optimized Dockerfile:**
```dockerfile
# Multi-stage build for optimal size
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

**Create .dockerignore:**
```
node_modules
.git
*.md
.env*
dist
coverage
```

#### Step 2: Automated Docker Publishing Workflow

**`.github/workflows/publish-docker.yml`:**
```yaml
name: Publish Docker Image
on:
  push:
    branches: [main]
    tags: ['v*.*.*']
  release:
    types: [published]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Log in to GHCR
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha
            type=raw,value=latest,enable={{is_default_branch}}
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
      
      - name: Security scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: Upload scan results
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: 'trivy-results.sarif'
```

#### Step 3: npm Package Registry Setup

**Configure `package.json`:**
```json
{
  "name": "@your-org/package-name",
  "version": "1.0.0",
  "description": "Your package",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "repository": {
    "type": "git",
    "url": "https://github.com/your-org/your-repo.git"
  },
  "publishConfig": {
    "registry": "https://npm.pkg.github.com",
    "access": "restricted"
  },
  "scripts": {
    "build": "tsc",
    "prepublishOnly": "npm run build",
    "test": "jest"
  }
}
```

**`.github/workflows/publish-npm.yml`:**
```yaml
name: Publish npm Package
on:
  release:
    types: [published]

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
          registry-url: 'https://npm.pkg.github.com'
          scope: '@your-org'
      
      - run: npm ci
      - run: npm test
      - run: npm run build
      - run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### Step 4: Package Cleanup Policy

**`.github/workflows/cleanup-packages.yml`:**
```yaml
name: Cleanup Old Packages
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly
  workflow_dispatch:

jobs:
  cleanup:
    runs-on: ubuntu-latest
    permissions:
      packages: write
    steps:
      - uses: actions/github-script@v7
        with:
          script: |
            const owner = context.repo.owner;
            const repo = context.repo.repo;
            
            const { data: versions } = await github.rest.packages.getAllPackageVersionsForPackageOwnedByOrg({
              package_type: 'container',
              package_name: repo,
              org: owner
            });
            
            const cutoffDate = new Date();
            cutoffDate.setDate(cutoffDate.getDate() - 90);
            
            for (const version of versions) {
              const createdAt = new Date(version.created_at);
              const isTagged = version.metadata.container.tags.some(t => t.match(/^v?\d+\.\d+\.\d+$/));
              
              if (createdAt < cutoffDate && !isTagged) {
                await github.rest.packages.deletePackageVersionForOrg({
                  package_type: 'container',
                  package_name: repo,
                  org: owner,
                  package_version_id: version.id
                });
              }
            }
```

#### Verification
```bash
# Pull and test Docker image
docker pull ghcr.io/your-org/your-repo:latest
docker run -p 3000:3000 ghcr.io/your-org/your-repo:latest

# Install and test npm package
npm install @your-org/package-name
```

---

## Task 3.11: Repository Templates and Standardization

### Complete Solution

**Objective:** Create standardized repository templates for consistent project setup.

#### Step 1: Create Template Repository

1. Create new repository
2. Go to Settings → Check "Template repository"
3. Add standard structure

#### Step 2: Standard File Structure

**Repository structure:**
```
template-repo/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── cd.yml
│   │   └── security.yml
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml
│   │   ├── feature_request.yml
│   │   └── config.yml
│   ├── pull_request_template.md
│   ├── dependabot.yml
│   └── CODEOWNERS
├── docs/
│   ├── CONTRIBUTING.md
│   ├── CODE_OF_CONDUCT.md
│   └── SECURITY.md
├── src/
├── tests/
├── .gitignore
├── README.md
└── LICENSE
```

**`.github/workflows/ci.yml`:**
```yaml
name: CI Pipeline
on:
  pull_request:
  push:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm test
      - run: npm run build
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/coverage-final.json
```

**`README.md` template:**
```markdown
# Project Name

## Description
Brief description of the project.

## Prerequisites
- Node.js 18+
- npm or yarn
- Docker (optional)

## Installation
\`\`\`bash
npm install
\`\`\`

## Usage
\`\`\`bash
npm start
\`\`\`

## Development
\`\`\`bash
npm run dev
\`\`\`

## Testing
\`\`\`bash
npm test
npm run test:coverage
\`\`\`

## Deployment
See [DEPLOYMENT.md](./docs/DEPLOYMENT.md)

## Contributing
See [CONTRIBUTING.md](./docs/CONTRIBUTING.md)

## License
MIT - see [LICENSE](./LICENSE)
```

**`.github/dependabot.yml`:**
```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    groups:
      production-dependencies:
        dependency-type: "production"
      development-dependencies:
        dependency-type: "development"
    labels:
      - "dependencies"
    reviewers:
      - "team/developers"
```

#### Step 3: Customization Script

**`scripts/customize.sh`:**
```bash
#!/bin/bash
# Customize template for new project

echo "Repository Template Customization"
echo "=================================="
read -p "Project name: " PROJECT_NAME
read -p "Description: " DESCRIPTION
read -p "Author: " AUTHOR

# Update README
sed -i "s/Project Name/$PROJECT_NAME/g" README.md
sed -i "s/Brief description.*/$DESCRIPTION/g" README.md

# Update package.json
sed -i "s/\"name\": \".*\"/\"name\": \"$PROJECT_NAME\"/g" package.json
sed -i "s/\"description\": \".*\"/\"description\": \"$DESCRIPTION\"/g" package.json
sed -i "s/\"author\": \".*\"/\"author\": \"$AUTHOR\"/g" package.json

echo "✅ Template customized successfully!"
echo "Next steps:"
echo "1. Review and update configuration files"
echo "2. Install dependencies: npm install"
echo "3. Start development: npm run dev"
```

---

## Task 3.12: GitHub Apps and Webhooks Integration

### Complete Solution

**Objective:** Create GitHub App with webhook integration for automation.

#### Step 1: Create GitHub App

1. Go to Settings → Developer settings → GitHub Apps
2. Create new app with:
   - Webhook URL: `https://your-domain.com/webhooks`
   - Webhook secret: Generate strong secret
   - Permissions: Configure based on needs
   - Subscribe to events: issues, pull_request, push

#### Step 2: Webhook Server Implementation

**Node.js webhook server (`server.js`):**
```javascript
const express = require('express');
const crypto = require('crypto');
const { Octokit } = require('@octokit/rest');

const app = express();
app.use(express.json());

const WEBHOOK_SECRET = process.env.WEBHOOK_SECRET;
const APP_ID = process.env.APP_ID;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

// Verify webhook signature
function verifySignature(req) {
  const signature = req.headers['x-hub-signature-256'];
  const hmac = crypto.createHmac('sha256', WEBHOOK_SECRET);
  const digest = 'sha256=' + hmac.update(JSON.stringify(req.body)).digest('hex');
  return crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(digest));
}

// Webhook endpoint
app.post('/webhooks', async (req, res) => {
  if (!verifySignature(req)) {
    return res.status(401).send('Invalid signature');
  }

  const event = req.headers['x-github-event'];
  const payload = req.body;

  try {
    await handleEvent(event, payload);
    res.status(200).send('OK');
  } catch (error) {
    console.error('Error handling event:', error);
    res.status(500).send('Error');
  }
});

async function handleEvent(event, payload) {
  switch (event) {
    case 'issues':
      await handleIssueEvent(payload);
      break;
    case 'pull_request':
      await handlePREvent(payload);
      break;
    case 'push':
      await handlePushEvent(payload);
      break;
    default:
      console.log(`Unhandled event: ${event}`);
  }
}

async function handleIssueEvent(payload) {
  if (payload.action === 'opened') {
    const octokit = new Octokit({ auth: getInstallationToken(payload.installation.id) });
    
    // Auto-label new issues
    await octokit.issues.addLabels({
      owner: payload.repository.owner.login,
      repo: payload.repository.name,
      issue_number: payload.issue.number,
      labels: ['triage']
    });
    
    // Add welcome comment
    await octokit.issues.createComment({
      owner: payload.repository.owner.login,
      repo: payload.repository.name,
      issue_number: payload.issue.number,
      body: 'Thanks for opening this issue! A team member will review it soon.'
    });
  }
}

async function handlePREvent(payload) {
  if (payload.action === 'opened') {
    const octokit = new Octokit({ auth: getInstallationToken(payload.installation.id) });
    
    // Check PR size
    const { data: files } = await octokit.pulls.listFiles({
      owner: payload.repository.owner.login,
      repo: payload.repository.name,
      pull_number: payload.pull_request.number
    });
    
    const totalChanges = files.reduce((sum, f) => sum + f.additions + f.deletions, 0);
    
    if (totalChanges > 500) {
      await octokit.issues.createComment({
        owner: payload.repository.owner.login,
        repo: payload.repository.name,
        issue_number: payload.pull_request.number,
        body: '⚠️ This PR is large. Consider breaking it into smaller PRs.'
      });
    }
  }
}

function getInstallationToken(installationId) {
  // Implement JWT-based authentication for GitHub App
  // Return installation access token
}

app.listen(3000, () => {
  console.log('Webhook server running on port 3000');
});
```

#### Step 3: Slack Integration

**Slack notification handler:**
```javascript
const { WebClient } = require('@slack/web-api');
const slack = new WebClient(process.env.SLACK_TOKEN);

async function notifySlack(event, payload) {
  const channel = '#github-notifications';
  
  let message = '';
  if (event === 'issues' && payload.action === 'opened') {
    message = `🐛 New issue: *${payload.issue.title}*\n<${payload.issue.html_url}|View Issue>`;
  } else if (event === 'pull_request' && payload.action === 'opened') {
    message = `🔀 New PR: *${payload.pull_request.title}*\n<${payload.pull_request.html_url}|View PR>`;
  }
  
  if (message) {
    await slack.chat.postMessage({
      channel,
      text: message
    });
  }
}
```

#### Step 4: Deployment

**Docker deployment (`Dockerfile`):**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

**Kubernetes deployment:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: github-webhook
spec:
  replicas: 2
  selector:
    matchLabels:
      app: github-webhook
  template:
    metadata:
      labels:
        app: github-webhook
    spec:
      containers:
      - name: webhook
        image: ghcr.io/your-org/github-webhook:latest
        ports:
        - containerPort: 3000
        env:
        - name: WEBHOOK_SECRET
          valueFrom:
            secretKeyRef:
              name: github-webhook-secrets
              key: webhook-secret
        - name: APP_ID
          valueFrom:
            secretKeyRef:
              name: github-webhook-secrets
              key: app-id
---
apiVersion: v1
kind: Service
metadata:
  name: github-webhook
spec:
  selector:
    app: github-webhook
  ports:
  - port: 80
    targetPort: 3000
  type: LoadBalancer
```

---

## Task 3.13: Secret Scanning & Push Protection

### Complete Solution

**Objective:** Enable organization-wide secret scanning with push protection.

#### Step 1: Enable Secret Scanning

**Via GitHub UI:**
1. Organization Settings → Code security and analysis
2. Enable "Secret scanning"
3. Enable "Push protection"
4. Enable "Secret scanning for all repositories"

**Via GitHub API:**
```bash
# Enable for organization
curl -X PATCH \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/orgs/YOUR_ORG \
  -d '{
    "security_managers": ["security-team"],
    "secret_scanning": "enabled",
    "secret_scanning_push_protection": "enabled"
  }'
```

#### Step 2: Custom Secret Patterns

**Create `.github/secret_scanning.yml`:**
```yaml
patterns:
  - name: "Custom API Key"
    regex: "api[_-]?key[_-]?[a-zA-Z0-9]{32,}"
    description: "Detects custom API keys"
  
  - name: "Internal Token"
    regex: "internal[_-]?token[_-]?[a-zA-Z0-9]{40,}"
    description: "Detects internal auth tokens"
  
  - name: "Database Connection String"
    regex: "mongodb://[^\\s]+"
    description: "MongoDB connection strings"
```

#### Step 3: Pre-commit Hook

**`.githooks/pre-commit`:**
```bash
#!/bin/bash

# Secret scanning pre-commit hook
echo "Running secret scan..."

# Use gitleaks for local scanning
if ! command -v gitleaks &> /dev/null; then
    echo "⚠️  gitleaks not installed. Install: brew install gitleaks"
    exit 0
fi

gitleaks protect --staged --verbose

if [ $? -ne 0 ]; then
    echo "❌ Secret detected! Commit blocked."
    echo ""
    echo "If this is a false positive:"
    echo "1. Add to .gitleaksignore"
    echo "2. Or use: git commit --no-verify"
    exit 1
fi

echo "✅ No secrets detected"
```

**Install hook:**
```bash
# Setup script
cat > setup-hooks.sh << 'EOF'
#!/bin/bash
mkdir -p .git/hooks
cp .githooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
echo "✅ Pre-commit hook installed"
EOF

chmod +x setup-hooks.sh
```

#### Step 4: Incident Response Workflow

**`.github/workflows/secret-alert.yml`:**
```yaml
name: Secret Scanning Alert
on:
  secret_scanning_alert:
    types: [created, reopened]

jobs:
  respond:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      issues: write
    steps:
      - name: Create incident issue
        uses: actions/github-script@v7
        with:
          script: |
            const alert = context.payload.alert;
            
            await github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: `🔒 SECRET ALERT: ${alert.secret_type}`,
              body: `
              ## Secret Detected
              
              **Type:** ${alert.secret_type}
              **Location:** ${alert.secret}
              **State:** ${alert.state}
              
              ## Immediate Actions Required
              
              1. [ ] Rotate the exposed credential
              2. [ ] Review access logs for unauthorized usage
              3. [ ] Determine scope of exposure
              4. [ ] Update all systems using this credential
              5. [ ] Document incident
              
              ## Response Team
              
              @security-team - Please investigate immediately
              
              **Alert URL:** ${alert.html_url}
              `,
              labels: ['security', 'critical', 'secret-leak'],
              assignees: ['security-lead']
            });
            
            // Send Slack notification
            // await notifySlack(alert);
      
      - name: Notify security team
        run: |
          # Send email/Slack/PagerDuty notification
          echo "Security team notified"
```

#### Step 5: Training Material

**`docs/SECRET_SCANNING_GUIDE.md`:**
```markdown
# Secret Scanning Guide

## What is Secret Scanning?

Automated detection of credentials, API keys, and tokens in code.

## What Gets Detected?

- AWS keys
- GitHub tokens
- API keys
- Private keys
- Database passwords
- OAuth tokens
- And 200+ secret types

## Best Practices

### ✅ DO:
- Use environment variables
- Use secret management tools (AWS Secrets Manager, HashiCorp Vault)
- Rotate credentials regularly
- Use least privilege access
- Enable push protection

### ❌ DON'T:
- Commit secrets to git
- Share credentials in chat/email
- Use default/weak credentials
- Hardcode secrets in code

## If You Committed a Secret

1. **Don't panic** - but act quickly
2. **Rotate the credential immediately**
3. **Remove from git history:**
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/file" \
     --prune-empty --tag-name-filter cat -- --all
   ```
4. **Report to security team**
5. **Document the incident**

## Local Scanning

Install gitleaks:
\`\`\`bash
brew install gitleaks
\`\`\`

Scan repository:
\`\`\`bash
gitleaks detect --source . --verbose
\`\`\`

## False Positives

Add to `.gitleaksignore`:
\`\`\`
path/to/file:line_number
\`\`\`

## Resources

- [GitHub Secret Scanning Docs](https://docs.github.com/en/code-security/secret-scanning)
- Internal security wiki
- Security team contacts
```

---

## Task 3.14: GitHub API Automation

### Complete Solution

**Objective:** Automate GitHub operations using REST and GraphQL APIs.

#### Step 1: Bulk Repository Operations

**Python script for bulk operations (`bulk_operations.py`):**
```python
#!/usr/bin/env python3
import os
from github import Github
import requests

# Initialize
g = Github(os.environ['GITHUB_TOKEN'])
org = g.get_organization('your-org')

def enable_security_features():
    """Enable security features across all repos"""
    for repo in org.get_repos():
        print(f"Processing {repo.name}...")
        
        try:
            # Enable vulnerability alerts
            repo.enable_vulnerability_alert()
            
            # Enable automated security fixes
            repo.enable_automated_security_fixes()
            
            # Enable secret scanning (API call)
            requests.patch(
                f"https://api.github.com/repos/{repo.full_name}",
                headers={
                    "Authorization": f"token {os.environ['GITHUB_TOKEN']}",
                    "Accept": "application/vnd.github+json"
                },
                json={"security_and_analysis": {
                    "secret_scanning": {"status": "enabled"},
                    "secret_scanning_push_protection": {"status": "enabled"}
                }}
            )
            
            print(f"✅ {repo.name} updated")
        except Exception as e:
            print(f"❌ {repo.name} failed: {e}")

def update_branch_protection():
    """Apply branch protection rules"""
    for repo in org.get_repos():
        if repo.archived:
            continue
            
        try:
            branch = repo.get_branch('main')
            branch.edit_protection(
                required_approving_review_count=2,
                dismiss_stale_reviews=True,
                require_code_owner_reviews=True,
                enforce_admins=True
            )
            print(f"✅ Protected main branch in {repo.name}")
        except Exception as e:
            print(f"⚠️  {repo.name}: {e}")

def generate_compliance_report():
    """Generate security compliance report"""
    report = []
    
    for repo in org.get_repos():
        data = {
            'name': repo.name,
            'private': repo.private,
            'has_issues': repo.has_issues,
            'has_wiki': repo.has_wiki,
            'vulnerability_alerts': repo.get_vulnerability_alert(),
            'branch_protection': check_branch_protection(repo),
            'security_policy': has_security_policy(repo),
            'last_commit': repo.get_commits()[0].commit.author.date
        }
        report.append(data)
    
    # Export to CSV
    import csv
    with open('compliance_report.csv', 'w') as f:
        writer = csv.DictWriter(f, fieldnames=report[0].keys())
        writer.writeheader()
        writer.writerows(report)
    
    print("✅ Report generated: compliance_report.csv")

def check_branch_protection(repo):
    """Check if main branch is protected"""
    try:
        branch = repo.get_branch('main')
        return branch.protected
    except:
        return False

def has_security_policy(repo):
    """Check if repo has SECURITY.md"""
    try:
        repo.get_contents('SECURITY.md')
        return True
    except:
        return False

if __name__ == '__main__':
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python bulk_operations.py [command]")
        print("Commands: security, protection, report")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == 'security':
        enable_security_features()
    elif command == 'protection':
        update_branch_protection()
    elif command == 'report':
        generate_compliance_report()
    else:
        print(f"Unknown command: {command}")
```

#### Step 2: GraphQL Queries for Analytics

**`analytics.js` - Repository analytics:**
```javascript
const { graphql } = require('@octokit/graphql');

const graphqlWithAuth = graphql.defaults({
  headers: {
    authorization: `token ${process.env.GITHUB_TOKEN}`
  }
});

async function getOrganizationMetrics(org) {
  const query = `
    query($org: String!) {
      organization(login: $org) {
        repositories(first: 100) {
          nodes {
            name
            stargazerCount
            forkCount
            issues {
              totalCount
            }
            pullRequests(states: OPEN) {
              totalCount
            }
            defaultBranchRef {
              target {
                ... on Commit {
                  history(since: "2024-01-01T00:00:00Z") {
                    totalCount
                  }
                }
              }
            }
            languages(first: 5) {
              edges {
                node {
                  name
                }
                size
              }
            }
          }
        }
        membersWithRole {
          totalCount
        }
        teams {
          totalCount
        }
      }
    }
  `;
  
  const result = await graphqlWithAuth(query, { org });
  return result.organization;
}

async function generateDashboard(org) {
  const metrics = await getOrganizationMetrics(org);
  
  console.log(`\n📊 Organization Metrics: ${org}`);
  console.log('=====================================');
  console.log(`Total Repositories: ${metrics.repositories.nodes.length}`);
  console.log(`Total Members: ${metrics.membersWithRole.totalCount}`);
  console.log(`Total Teams: ${metrics.teams.totalCount}`);
  
  let totalStars = 0;
  let totalForks = 0;
  let totalIssues = 0;
  let totalPRs = 0;
  let totalCommits = 0;
  const languages = {};
  
  metrics.repositories.nodes.forEach(repo => {
    totalStars += repo.stargazerCount;
    totalForks += repo.forkCount;
    totalIssues += repo.issues.totalCount;
    totalPRs += repo.pullRequests.totalCount;
    
    if (repo.defaultBranchRef?.target?.history) {
      totalCommits += repo.defaultBranchRef.target.history.totalCount;
    }
    
    repo.languages.edges.forEach(({ node, size }) => {
      languages[node.name] = (languages[node.name] || 0) + size;
    });
  });
  
  console.log(`\nEngagement:`);
  console.log(`  Stars: ${totalStars}`);
  console.log(`  Forks: ${totalForks}`);
  console.log(`  Open Issues: ${totalIssues}`);
  console.log(`  Open PRs: ${totalPRs}`);
  console.log(`  Commits (2024): ${totalCommits}`);
  
  console.log(`\nTop Languages:`);
  Object.entries(languages)
    .sort(([,a], [,b]) => b - a)
    .slice(0, 5)
    .forEach(([lang, bytes]) => {
      console.log(`  ${lang}: ${(bytes / 1024 / 1024).toFixed(2)} MB`);
    });
}

// Run
generateDashboard('your-org').catch(console.error);
```

#### Step 3: Automated Workflows

**`.github/workflows/api-automation.yml`:**
```yaml
name: API Automation
on:
  schedule:
    - cron: '0 0 * * 1'  # Weekly
  workflow_dispatch:

jobs:
  security-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install PyGithub requests
      
      - name: Run security audit
        env:
          GITHUB_TOKEN: ${{ secrets.ORG_ADMIN_TOKEN }}
        run: |
          python bulk_operations.py security
          python bulk_operations.py report
      
      - name: Upload report
        uses: actions/upload-artifact@v4
        with:
          name: compliance-report
          path: compliance_report.csv
      
      - name: Create summary issue
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const report = fs.readFileSync('compliance_report.csv', 'utf8');
            
            await github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: `Security Audit Report - ${new Date().toISOString().split('T')[0]}`,
              body: `## Weekly Security Audit\n\n\`\`\`csv\n${report}\n\`\`\``,
              labels: ['security', 'audit']
            });
```

---

## Task 3.15: Disaster Recovery

### Complete Solution

**Objective:** Implement automated backup and recovery procedures.

#### Step 1: Automated Backup Workflow

**`.github/workflows/backup.yml`:**
```yaml
name: Repository Backup
on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM
  workflow_dispatch:

jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - name: Backup repository
        run: |
          # Clone with all history
          git clone --mirror https://x-access-token:${{ secrets.BACKUP_TOKEN }}@github.com/${{ github.repository }}.git backup
          
          # Create archive
          tar -czf backup-$(date +%Y%m%d).tar.gz backup/
      
      - name: Upload to S3
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws s3 cp backup-$(date +%Y%m%d).tar.gz \
            s3://your-backup-bucket/github-backups/${{ github.repository }}/
      
      - name: Cleanup old backups
        run: |
          # Keep last 30 days
          aws s3 ls s3://your-backup-bucket/github-backups/${{ github.repository }}/ | \
            awk '{print $4}' | \
            head -n -30 | \
            xargs -I {} aws s3 rm s3://your-backup-bucket/github-backups/${{ github.repository }}/{}
```

#### Step 2: Recovery Script

**`scripts/restore.sh`:**
```bash
#!/bin/bash
# Repository recovery script

set -e

BACKUP_DATE=$1
REPO_NAME=$2

if [ -z "$BACKUP_DATE" ] || [ -z "$REPO_NAME" ]; then
    echo "Usage: ./restore.sh YYYYMMDD repository-name"
    exit 1
fi

echo "🔄 Starting recovery for $REPO_NAME from backup $BACKUP_DATE"

# Download backup from S3
aws s3 cp \
    s3://your-backup-bucket/github-backups/$REPO_NAME/backup-$BACKUP_DATE.tar.gz \
    ./restore/

# Extract backup
cd restore
tar -xzf backup-$BACKUP_DATE.tar.gz

# Push to new repository or restore
cd backup
git push --mirror https://github.com/$REPO_NAME.git

echo "✅ Recovery completed successfully"
```

#### Step 3: Disaster Recovery Plan

**`docs/DISASTER_RECOVERY_PLAN.md`:**
```markdown
# Disaster Recovery Plan

## Recovery Time Objective (RTO): 4 hours
## Recovery Point Objective (RPO): 24 hours

## Backup Strategy

### Daily Backups
- Full repository backups at 2 AM UTC
- Stored in AWS S3 with versioning
- Retention: 30 days
- Encrypted at rest

### What's Backed Up
- Git repository (all branches and tags)
- Issues and pull requests
- Wiki content
- Release assets
- Actions workflows

## Recovery Procedures

### Scenario 1: Accidental Force Push

\`\`\`bash
# Find the lost commit
git reflog

# Restore from reflog
git reset --hard <commit-hash>
git push --force
\`\`\`

### Scenario 2: Repository Deletion

1. Identify backup date needed
2. Download backup from S3
3. Extract and verify integrity
4. Create new repository
5. Push backup to new repository
6. Restore settings and configurations
7. Verify recovery
8. Update team

### Scenario 3: Data Corruption

1. Identify last known good state
2. Download corresponding backup
3. Clone backup locally
4. Verify integrity with `git fsck`
5. Force push to repository
6. Notify team of recovery

## Testing

### Monthly Recovery Tests
- Restore random repository from backup
- Verify all data integrity
- Document time taken
- Update procedures as needed

## Contacts

- Primary: DevOps Lead
- Secondary: Security Team
- Emergency: CTO
```

---

## Task 3.16: Performance Optimization

### Complete Solution

**Objective:** Optimize large repository performance.

#### Step 1: Repository Analysis

**Analysis script (`analyze-repo.sh`):**
```bash
#!/bin/bash
# Analyze repository size and performance

echo "📊 Repository Analysis"
echo "===================="

# Overall size
echo "\n📦 Repository Size:"
git count-objects -vH

# Largest files
echo "\n📁 Top 10 Largest Files:"
git rev-list --objects --all |
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
  sed -n 's/^blob //p' |
  sort --numeric-sort --key=2 --reverse |
  head -10 |
  awk '{print $2/1024/1024 " MB\t" $3}'

# File type distribution
echo "\n📈 File Type Distribution:"
git ls-files | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10

# Commit activity
echo "\n📅 Recent Commit Activity:"
git log --since="1 month ago" --oneline | wc -l
echo "commits in last month"

# Branch count
echo "\n🌿 Branch Count:"
git branch -a | wc -l
echo "total branches"
```

#### Step 2: Git LFS Setup

**`.gitattributes`:**
```
# Images
*.jpg filter=lfs diff=lfs merge=lfs -text
*.png filter=lfs diff=lfs merge=lfs -text
*.gif filter=lfs diff=lfs merge=lfs -text
*.psd filter=lfs diff=lfs merge=lfs -text

# Videos
*.mp4 filter=lfs diff=lfs merge=lfs -text
*.mov filter=lfs diff=lfs merge=lfs -text

# Archives
*.zip filter=lfs diff=lfs merge=lfs -text
*.tar.gz filter=lfs diff=lfs merge=lfs -text

# Binary files
*.exe filter=lfs diff=lfs merge=lfs -text
*.dll filter=lfs diff=lfs merge=lfs -text

# Large data files
*.csv filter=lfs diff=lfs merge=lfs -text
*.parquet filter=lfs diff=lfs merge=lfs -text
```

**Migrate existing files to LFS:**
```bash
# Install Git LFS
git lfs install

# Migrate existing files
git lfs migrate import --include="*.jpg,*.png,*.gif,*.mp4"

# Push LFS files
git lfs push --all origin main
```

#### Step 3: CI/CD Optimization

**Optimized workflow (`.github/workflows/ci-optimized.yml`):**
```yaml
name: Optimized CI
on:
  pull_request:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      # Shallow clone for speed
      - uses: actions/checkout@v4
        with:
          fetch-depth: 1  # Only latest commit
          lfs: false      # Skip LFS unless needed
      
      # Use cache aggressively
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      # Cache dependencies
      - uses: actions/cache@v3
        with:
          path: |
            ~/.npm
            node_modules
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-
      
      # Parallel execution
      - name: Install dependencies
        run: npm ci --prefer-offline
      
      - name: Lint and test
        run: |
          npm run lint &
          npm run test &
          wait
      
      - name: Build
        run: npm run build
```

#### Step 4: Repository Maintenance

**Cleanup script (`cleanup.sh`):**
```bash
#!/bin/bash
# Repository cleanup and optimization

echo "🧹 Starting repository cleanup..."

# Remove merged branches
git branch --merged main | grep -v "^\* main" | xargs -r git branch -d

# Prune remote tracking branches
git remote prune origin

# Garbage collection
git gc --aggressive --prune=now

# Repack repository
git repack -Ad

# Verify integrity
git fsck --full

echo "✅ Cleanup complete"
```

**Automated cleanup workflow:**
```yaml
name: Repository Maintenance
on:
  schedule:
    - cron: '0 3 * * 0'  # Weekly

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Delete merged branches
        run: |
          git branch -r --merged origin/main |
            grep -v "main" |
            sed 's/origin\///' |
            xargs -I {} git push origin --delete {}
      
      - name: Create maintenance report
        run: |
          echo "## Maintenance Report" > report.md
          echo "Branches deleted: $(git branch -r | wc -l)" >> report.md
          echo "Repository size: $(du -sh .git)" >> report.md
```

---

## Task 3.17: Compliance & Audit Logging

### Complete Solution

**Objective:** Implement audit logging for compliance requirements.

#### Step 1: Audit Log Streaming

**Stream to ELK Stack:**
```python
# audit_log_streamer.py
import requests
from elasticsearch import Elasticsearch
import os
from datetime import datetime, timedelta

GITHUB_TOKEN = os.environ['GITHUB_TOKEN']
ORG = 'your-org'
ES_HOST = os.environ['ELASTICSEARCH_HOST']

es = Elasticsearch([ES_HOST])

def fetch_audit_log():
    """Fetch recent audit log entries"""
    # GitHub Enterprise only
    url = f'https://api.github.com/orgs/{ORG}/audit-log'
    headers = {
        'Authorization': f'token {GITHUB_TOKEN}',
        'Accept': 'application/vnd.github+json'
    }
    
    # Get logs from last hour
    since = (datetime.now() - timedelta(hours=1)).isoformat()
    params = {'per_page': 100, 'include': 'all'}
    
    response = requests.get(url, headers=headers, params=params)
    return response.json()

def index_to_elasticsearch(events):
    """Index events to Elasticsearch"""
    for event in events:
        doc = {
            '@timestamp': event['@timestamp'],
            'action': event['action'],
            'actor': event['actor'],
            'repo': event.get('repo'),
            'org': event['org'],
            'created_at': event['created_at'],
            'data': event.get('data', {})
        }
        
        es.index(index='github-audit', body=doc)
        print(f"Indexed: {event['action']} by {event['actor']}")

def main():
    print("Fetching audit logs...")
    events = fetch_audit_log()
    
    print(f"Found {len(events)} events")
    index_to_elasticsearch(events)
    
    print("✅ Audit logs indexed")

if __name__ == '__main__':
    main()
```

#### Step 2: Compliance Reports

**Compliance report generator:**
```python
# compliance_report.py
from github import Github
import csv
from datetime import datetime

g = Github(os.environ['GITHUB_TOKEN'])
org = g.get_organization('your-org')

def generate_access_report():
    """Generate report of all user access"""
    report = []
    
    for member in org.get_members():
        teams = [team.name for team in member.get_teams()]
        
        report.append({
            'username': member.login,
            'email': member.email or 'N/A',
            'role': member.role if hasattr(member, 'role') else 'N/A',
            'teams': ', '.join(teams),
            'two_factor': member.type != 'User' or check_2fa(member),
            'last_active': get_last_activity(member)
        })
    
    # Write to CSV
    with open(f'access_report_{datetime.now().strftime("%Y%m%d")}.csv', 'w') as f:
        writer = csv.DictWriter(f, fieldnames=report[0].keys())
        writer.writeheader()
        writer.writerows(report)
    
    print("✅ Access report generated")

def generate_repository_compliance():
    """Check repository compliance"""
    non_compliant = []
    
    for repo in org.get_repos():
        issues = []
        
        # Check branch protection
        try:
            branch = repo.get_branch('main')
            if not branch.protected:
                issues.append('No branch protection')
        except:
            issues.append('No main branch')
        
        # Check security features
        if not repo.get_vulnerability_alert():
            issues.append('Vulnerability alerts disabled')
        
        # Check for SECURITY.md
        try:
            repo.get_contents('SECURITY.md')
        except:
            issues.append('No SECURITY.md')
        
        if issues:
            non_compliant.append({
                'repo': repo.name,
                'issues': ', '.join(issues),
                'private': repo.private
            })
    
    # Generate report
    with open(f'compliance_report_{datetime.now().strftime("%Y%m%d")}.csv', 'w') as f:
        writer = csv.DictWriter(f, fieldnames=['repo', 'issues', 'private'])
        writer.writeheader()
        writer.writerows(non_compliant)
    
    print(f"⚠️  Found {len(non_compliant)} non-compliant repositories")

if __name__ == '__main__':
    generate_access_report()
    generate_repository_compliance()
```

#### Step 3: Automated Compliance Workflow

**`.github/workflows/compliance.yml`:**
```yaml
name: Compliance Audit
on:
  schedule:
    - cron: '0 0 1 * *'  # Monthly
  workflow_dispatch:

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install PyGithub elasticsearch
      
      - name: Generate reports
        env:
          GITHUB_TOKEN: ${{ secrets.ORG_ADMIN_TOKEN }}
        run: |
          python compliance_report.py
      
      - name: Upload reports
        uses: actions/upload-artifact@v4
        with:
          name: compliance-reports
          path: |
            *_report_*.csv
      
      - name: Create compliance issue
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const files = fs.readdirSync('.').filter(f => f.includes('_report_'));
            
            let body = '## Monthly Compliance Audit\n\n';
            
            for (const file of files) {
              const content = fs.readFileSync(file, 'utf8');
              body += `### ${file}\n\`\`\`csv\n${content}\n\`\`\`\n\n`;
            }
            
            await github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: `Compliance Audit - ${new Date().toISOString().split('T')[0]}`,
              body,
              labels: ['compliance', 'audit']
            });
```

---

## Task 3.18: Copilot Enterprise Rollout

### Complete Solution

**Objective:** Plan and execute GitHub Copilot Enterprise rollout.

#### Step 1: Readiness Assessment

**Assessment checklist (`docs/COPILOT_READINESS.md`):**
```markdown
# GitHub Copilot Enterprise Readiness Assessment

## Technical Readiness

- [ ] GitHub Enterprise license active
- [ ] SSO/SAML configured
- [ ] User provisioning automated
- [ ] Network connectivity verified
- [ ] Firewall rules configured
- [ ] Proxy settings (if applicable)

## Policy & Governance

- [ ] Usage policy defined
- [ ] Code ownership clarified
- [ ] Data privacy reviewed
- [ ] Security controls approved
- [ ] Acceptable use policy
- [ ] Incident response plan

## Team Readiness

- [ ] Leadership buy-in
- [ ] Budget approved
- [ ] Training plan created
- [ ] Champions identified
- [ ] Support model defined
- [ ] Success metrics defined

## Compliance

- [ ] Legal review complete
- [ ] IP concerns addressed
- [ ] License compliance verified
- [ ] Data residency confirmed
- [ ] Audit requirements met
```

#### Step 2: Rollout Strategy

**Phased rollout plan:**
```markdown
# Copilot Rollout Plan

## Phase 1: Pilot (2 weeks)
- **Participants:** 10 volunteers
- **Goals:**
  - Validate technical setup
  - Gather initial feedback
  - Identify issues
  - Refine training
- **Success Criteria:**
  - 80% satisfaction rate
  - No major blockers
  - Positive productivity feedback

## Phase 2: Early Adopters (4 weeks)
- **Participants:** 50 developers
- **Goals:**
  - Scale testing
  - Refine policies
  - Build internal advocacy
  - Document best practices
- **Success Criteria:**
  - 75% adoption rate
  - Measurable productivity gains
  - Updated documentation

## Phase 3: Organization-Wide (8 weeks)
- **Participants:** All developers
- **Goals:**
  - Full rollout
  - Ongoing training
  - Continuous improvement
  - ROI tracking
- **Success Criteria:**
  - 90% adoption
  - Sustained usage
  - Positive ROI
```

#### Step 3: Usage Tracking

**Usage analytics script (`copilot-analytics.js`):**
```javascript
const { graphql } = require('@octokit/graphql');

async function getCopilotUsage(org) {
  const query = `
    query($org: String!) {
      organization(login: $org) {
        copilotUsage {
          totalSeats
          activeUsers
          suggestions {
            total
            accepted
            acceptanceRate
          }
          breakdown {
            language
            suggestions
            acceptanceRate
          }
        }
      }
    }
  `;
  
  const result = await graphql(query, {
    org,
    headers: {
      authorization: `token ${process.env.GITHUB_TOKEN}`,
      accept: 'application/vnd.github.v4+json'
    }
  });
  
  return result.organization.copilotUsage;
}

async function generateReport(org) {
  const usage = await getCopilotUsage(org);
  
  console.log('GitHub Copilot Usage Report');
  console.log('===========================');
  console.log(`Total Seats: ${usage.totalSeats}`);
  console.log(`Active Users: ${usage.activeUsers} (${(usage.activeUsers/usage.totalSeats*100).toFixed(1)}%)`);
  console.log(`\nSuggestions:`);
  console.log(`  Total: ${usage.suggestions.total}`);
  console.log(`  Accepted: ${usage.suggestions.accepted}`);
  console.log(`  Acceptance Rate: ${usage.suggestions.acceptanceRate}%`);
  console.log(`\nBy Language:`);
  
  usage.breakdown.forEach(lang => {
    console.log(`  ${lang.language}: ${lang.suggestions} suggestions (${lang.acceptanceRate}%)`);
  });
}

generateReport('your-org').catch(console.error);
```

#### Step 4: Training Program

**Training plan (`docs/COPILOT_TRAINING.md`):**
```markdown
# Copilot Training Program

## Getting Started (30 min)

### Installation
1. Install Copilot extension in IDE
2. Sign in with GitHub
3. Verify activation
4. Configure settings

### Basic Usage
- Accepting suggestions: Tab
- Viewing alternatives: Alt+]
- Dismissing: Esc
- Manual trigger: Alt+\

## Best Practices (1 hour)

### When to Use
✅ Boilerplate code
✅ Common patterns
✅ Test cases
✅ Documentation
✅ Code refactoring

### When Not to Use
❌ Security-sensitive code
❌ Complex algorithms
❌ Proprietary logic
❌ Compliance-critical code

### Tips
- Write clear comments
- Use descriptive names
- Review all suggestions
- Don't blindly accept
- Learn from suggestions

## Advanced Topics (1 hour)

### Context Management
- Open relevant files
- Write detailed comments
- Use clear naming
- Structure code well

### Language-Specific Tips
- Python: Docstrings help
- JavaScript: JSDoc comments
- TypeScript: Type definitions
- Java: Javadoc comments

## Resources
- Internal wiki
- Office hours (Fridays 2-3 PM)
- Slack: #copilot-help
- Feedback form
```

#### Step 5: Governance

**Usage policy (`docs/COPILOT_POLICY.md`):**
```markdown
# GitHub Copilot Usage Policy

## Scope
Applies to all developers using GitHub Copilot.

## Acceptable Use

### Allowed
- Development and testing
- Code reviews
- Documentation
- Learning and training
- Personal projects (if permitted)

### Prohibited
- Sharing credentials
- Processing sensitive data
- Bypassing security controls
- Commercial redistribution
- Violating licenses

## Code Review Requirements

All Copilot-generated code must:
1. Be reviewed by the author
2. Pass automated tests
3. Follow coding standards
4. Be documented
5. Pass security scans

## Data Privacy

- No sensitive data in prompts
- Review suggestions before accepting
- Follow data classification policy
- Report privacy concerns

## Security

- Verify all generated code
- Don't accept security-related code blindly
- Report suspicious suggestions
- Follow secure coding practices

## Compliance

- Respect open source licenses
- Verify IP ownership
- Document code sources
- Follow legal requirements

## Monitoring

Usage may be monitored for:
- License compliance
- Security
- Training and improvement
- ROI measurement

## Support

- Slack: #copilot-help
- Email: copilot-support@company.com
- Office hours: Fridays 2-3 PM

## Violations

Violations may result in:
- Warning
- License revocation
- Disciplinary action

## Updates

Policy reviewed quarterly.
Last updated: 2024-11-05
```

#### Step 6: ROI Measurement

**ROI tracking (`copilot-roi.js`):**
```javascript
const metrics = {
  // Baseline (before Copilot)
  baseline: {
    avgCodeCompletionTime: 120,  // seconds
    avgTestWritingTime: 180,
    avgDocumentationTime: 90,
    codingProductivity: 100  // baseline index
  },
  
  // With Copilot
  withCopilot: {
    avgCodeCompletionTime: 70,
    avgTestWritingTime: 100,
    avgDocumentationTime: 50,
    codingProductivity: 140
  },
  
  // Cost
  numberOfDevelopers: 100,
  costPerSeat: 39,  // monthly
  avgHourlyRate: 75
};

function calculateROI() {
  const monthlyLicenseCost = metrics.numberOfDevelopers * metrics.costPerSeat;
  
  // Time savings per developer per month
  const timeSavingsHoursPerMonth = (
    // Code completion
    ((metrics.baseline.avgCodeCompletionTime - metrics.withCopilot.avgCodeCompletionTime) / 3600) * 100 +
    // Test writing
    ((metrics.baseline.avgTestWritingTime - metrics.withCopilot.avgTestWritingTime) / 3600) * 50 +
    // Documentation
    ((metrics.baseline.avgDocumentationTime - metrics.withCopilot.avgDocumentationTime) / 3600) * 30
  );
  
  const monthlySavingsPerDeveloper = timeSavingsHoursPerMonth * metrics.avgHourlyRate;
  const totalMonthlySavings = monthlySavingsPerDeveloper * metrics.numberOfDevelopers;
  
  const netBenefit = totalMonthlySavings - monthlyLicenseCost;
  const roi = (netBenefit / monthlyLicenseCost) * 100;
  
  console.log('GitHub Copilot ROI Analysis');
  console.log('===========================');
  console.log(`Developers: ${metrics.numberOfDevelopers}`);
  console.log(`Monthly License Cost: $${monthlyLicenseCost.toLocaleString()}`);
  console.log(`Time Savings per Developer: ${timeSavingsHoursPerMonth.toFixed(1)} hours/month`);
  console.log(`Monthly Savings: $${totalMonthlySavings.toLocaleString()}`);
  console.log(`Net Monthly Benefit: $${netBenefit.toLocaleString()}`);
  console.log(`ROI: ${roi.toFixed(1)}%`);
  console.log(`Payback Period: ${(1 / (netBenefit / monthlyLicenseCost)).toFixed(1)} months`);
}

calculateROI();
```

---

## Verification & Testing

For each task, verify implementation:

1. **Functional Testing**
   - All features work as designed
   - Edge cases handled
   - Error handling robust

2. **Security Review**
   - No credentials exposed
   - Proper authentication
   - Secure configurations

3. **Performance Testing**
   - Workflows complete in reasonable time
   - No unnecessary resource usage
   - Scalable approach

4. **Documentation Review**
   - Clear and complete
   - Up to date
   - Easy to follow

5. **Team Validation**
   - Get feedback from users
   - Iterate based on feedback
   - Measure adoption and satisfaction

---

## Additional Resources

- [GitHub Documentation](https://docs.github.com)
- [GitHub API Reference](https://docs.github.com/en/rest)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)

---

**Questions or issues?** Create an issue in this repository or contact the DevOps team.

---

> **📚 For Tasks 3.1-3.9:** See [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)
