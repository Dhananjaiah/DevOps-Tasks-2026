# GitHub Repository & Workflows Real-World Tasks - Complete Solutions

> **📚 Navigation:** [← Back to Tasks](./REAL-WORLD-TASKS.md) | [Part 3 README](./README.md) | [Main README](../README.md)

## 🎯 Overview

This document provides **complete, production-ready solutions** for all 18 real-world GitHub Repository & Workflows tasks. Each solution includes step-by-step implementations, configuration files, and verification procedures.

> **⚠️ Important:** Try to complete the tasks on your own before viewing the solutions! These are here to help you learn, verify your approach, or unblock yourself if you get stuck.

> **📝 Need the task descriptions?** View the full task requirements in [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)

> **💡 For Tasks 3.8-3.18:** Detailed implementations are provided in the main [README.md](./README.md) file due to their comprehensive nature. This file contains full solutions for Tasks 3.1-3.7, with quick reference guides for 3.8-3.18.

---

## Table of Contents

### Core Tasks (Detailed Solutions)
1. [Task 3.1: Implement GitFlow Branching Strategy](#task-31-implement-gitflow-branching-strategy)
2. [Task 3.2: Set Up Release Automation with Tags and Changelogs](#task-32-set-up-release-automation-with-tags-and-changelogs)
3. [Task 3.3: Implement Code Review Process with CODEOWNERS](#task-33-implement-code-review-process-with-codeowners)
4. [Task 3.4: Enable Security Features (Dependabot, Code Scanning)](#task-34-enable-security-features-dependabot-code-scanning)
5. [Task 3.5: Configure GitHub Environments for Deployment Control](#task-35-configure-github-environments-for-deployment-control)
6. [Task 3.6: GitHub Actions CI/CD Pipeline Setup](#task-36-github-actions-cicd-pipeline-setup)
7. [Task 3.7: Monorepo vs Polyrepo Strategy Implementation](#task-37-monorepo-vs-polyrepo-strategy-implementation)

### Advanced Tasks (Quick Reference - Full Details in README.md)
8. Task 3.8: GitHub Projects for Agile Workflow
9. Task 3.9: Advanced PR Automation and Workflows
10. Task 3.10: GitHub Packages/Container Registry Setup
11. Task 3.11: Repository Templates and Standardization
12. Task 3.12: GitHub Apps and Webhooks Integration
13. Task 3.13: Advanced Security - Secret Scanning & Push Protection
14. Task 3.14: GitHub API Integration and Automation
15. Task 3.15: Disaster Recovery and Repository Migration
16. Task 3.16: Performance Optimization for Large Repositories
17. Task 3.17: Compliance and Audit Logging
18. Task 3.18: GitHub Copilot Enterprise Rollout

---

## Task 3.1: Implement GitFlow Branching Strategy

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-31-implement-gitflow-branching-strategy)**

### Solution Overview

Complete GitFlow branching strategy implementation with branch protection, PR templates, and documentation following industry best practices.

### Step 1: Set Up Branch Structure

```bash
# Navigate to your repository
cd your-repository

# Ensure you're on main branch
git checkout main
git pull origin main

# Create develop branch from main
git checkout -b develop
git push -u origin develop

# Set develop as default branch for new branches
git config branch.autosetupmerge always
git config branch.autosetuprebase always
```

### Step 2: Configure Branch Protection Rules

**For Main Branch:**

Go to GitHub Settings → Branches → Add Rule:

```yaml
Branch name pattern: main
Protection settings:
  ✅ Require a pull request before merging
    ✅ Require approvals: 2
    ✅ Dismiss stale pull request approvals when new commits are pushed
    ✅ Require review from Code Owners
  ✅ Require status checks to pass before merging
    ✅ Require branches to be up to date before merging
    - CI/CD Pipeline (add when available)
    - Unit Tests (add when available)
    - Code Quality Checks (add when available)
  ✅ Require conversation resolution before merging
  ✅ Require signed commits (recommended for security)
  ✅ Require linear history
  ✅ Do not allow bypassing the above settings
  ✅ Restrict who can push to matching branches
    - Add: DevOps team, Senior developers
  ✅ Allow force pushes: NO
  ✅ Allow deletions: NO
```

**For Develop Branch:**

```yaml
Branch name pattern: develop
Protection settings:
  ✅ Require a pull request before merging
    ✅ Require approvals: 1
    ✅ Dismiss stale pull request approvals when new commits are pushed
  ✅ Require status checks to pass before merging
    ✅ Require branches to be up to date before merging
    - CI/CD Pipeline
    - Unit Tests
  ✅ Require conversation resolution before merging
  ✅ Allow force pushes: NO
  ✅ Allow deletions: NO
```

**For Release Branches:**

```yaml
Branch name pattern: release/*
Protection settings:
  ✅ Require a pull request before merging
    ✅ Require approvals: 2
    ✅ Require review from Code Owners
  ✅ Require status checks to pass before merging
  ✅ Require conversation resolution before merging
  ✅ Allow force pushes: NO
  ✅ Allow deletions: NO
```

**For Hotfix Branches:**

```yaml
Branch name pattern: hotfix/*
Protection settings:
  ✅ Require a pull request before merging
    ✅ Require approvals: 1 (faster for emergencies)
    ✅ Require review from Code Owners
  ✅ Require status checks to pass before merging
  ✅ Allow force pushes: NO
```

### Step 3: Create PR Templates

Create `.github/PULL_REQUEST_TEMPLATE/` directory structure:

```bash
mkdir -p .github/PULL_REQUEST_TEMPLATE
```

**Feature PR Template** (`.github/PULL_REQUEST_TEMPLATE/feature_pull_request_template.md`):

```markdown
## Feature Pull Request

### 📝 Description
<!-- Provide a clear and concise description of the feature -->

### 🎯 Related Issue
<!-- Link to the issue this PR addresses -->
Closes #[issue_number]

### 🔄 Type of Change
- [ ] New feature
- [ ] Enhancement to existing feature
- [ ] Breaking change

### 📸 Screenshots
<!-- If applicable, add screenshots to help explain your feature -->

### ✅ Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

### 🧪 Testing
<!-- Describe the tests you ran and how to reproduce them -->

### 📚 Documentation
- [ ] README.md updated (if needed)
- [ ] API documentation updated (if applicable)
- [ ] User guide updated (if applicable)

### 🔍 Review Focus Areas
<!-- What should reviewers pay special attention to? -->
```

**Hotfix PR Template** (`.github/PULL_REQUEST_TEMPLATE/hotfix_pull_request_template.md`):

```markdown
## 🚨 Hotfix Pull Request

### 🔥 Critical Issue
<!-- Describe the critical issue being fixed -->

### 🎯 Production Impact
<!-- Describe the impact on production -->
- **Severity**: [Critical/High/Medium]
- **Users Affected**: [Number or percentage]
- **Service Affected**: [Service name]

### 🔧 Fix Description
<!-- Explain what was fixed and how -->

### 📋 Root Cause Analysis
<!-- What caused this issue? -->

### ✅ Pre-Deployment Checklist
- [ ] Fix verified in staging environment
- [ ] Rollback plan prepared
- [ ] Stakeholders notified
- [ ] Monitoring alerts configured
- [ ] Documentation updated

### 🧪 Testing Performed
<!-- Describe testing done to verify the fix -->

### 🚀 Deployment Plan
1. Deploy to staging
2. Verify fix in staging (15 minutes)
3. Deploy to production
4. Monitor for 1 hour

### 📊 Monitoring
<!-- What metrics/logs should be monitored after deployment? -->

### 👥 Approvers Required
- [ ] Tech Lead: @tech-lead
- [ ] On-Call Engineer: @on-call
```

**Release PR Template** (`.github/PULL_REQUEST_TEMPLATE/release_pull_request_template.md`):

```markdown
## 🚀 Release Pull Request

### 📦 Release Version
v[MAJOR].[MINOR].[PATCH]

### 📅 Release Date
[YYYY-MM-DD]

### 🎯 Release Type
- [ ] Major Release (Breaking changes)
- [ ] Minor Release (New features, backward compatible)
- [ ] Patch Release (Bug fixes only)

### 📝 Release Notes
<!-- Summary of changes in this release -->

#### ✨ New Features
- Feature 1 (#PR_NUMBER)
- Feature 2 (#PR_NUMBER)

#### 🐛 Bug Fixes
- Bug fix 1 (#PR_NUMBER)
- Bug fix 2 (#PR_NUMBER)

#### 💥 Breaking Changes
- Breaking change 1 (#PR_NUMBER)
- Migration guide: [link]

#### 🔄 Improvements
- Improvement 1 (#PR_NUMBER)

### ✅ Pre-Release Checklist
- [ ] All features tested in staging
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version bumped in all files
- [ ] Migration guide written (if breaking changes)
- [ ] Dependencies updated
- [ ] Security scan passed
- [ ] Performance testing completed
- [ ] Backup created

### 🧪 Testing Summary
<!-- Link to test results -->

### 📚 Documentation
- [ ] User guide updated
- [ ] API docs updated
- [ ] Release notes published

### 🚀 Deployment Strategy
- [ ] Blue-Green deployment
- [ ] Canary deployment (10% → 50% → 100%)
- [ ] Rolling deployment

### 🔙 Rollback Plan
<!-- Describe how to rollback if issues occur -->

### 👥 Sign-off Required
- [ ] Product Manager: @pm
- [ ] Tech Lead: @tech-lead
- [ ] QA Lead: @qa-lead
- [ ] DevOps Lead: @devops-lead
```

### Step 4: Create CONTRIBUTING.md Documentation

Create `.github/CONTRIBUTING.md`:

```markdown
# Contributing to [Project Name]

## 🌿 GitFlow Branching Strategy

We use GitFlow for managing our development workflow. Please follow these guidelines:

### Branch Structure

```
main (production)
  ├── develop (integration)
  │   ├── feature/* (new features)
  │   │   ├── feature/user-authentication
  │   │   └── feature/payment-integration
  │   └── bugfix/* (non-critical bugs)
  ├── release/* (release preparation)
  │   └── release/v1.2.0
  └── hotfix/* (critical production fixes)
      └── hotfix/security-patch
```

### Branch Naming Conventions

- **Feature branches**: `feature/short-description` or `feature/TICKET-123-description`
- **Bugfix branches**: `bugfix/short-description` or `bugfix/TICKET-456-description`
- **Release branches**: `release/v1.2.0` (semantic versioning)
- **Hotfix branches**: `hotfix/v1.2.1` or `hotfix/critical-issue-description`

### Workflow

#### 1. Starting a New Feature

```bash
# Update develop branch
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/your-feature-name

# Work on your feature
git add .
git commit -m "feat: add new feature"

# Push to remote
git push -u origin feature/your-feature-name

# Create Pull Request to develop
# Use Feature PR template
```

#### 2. Creating a Release

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# Bump version numbers in files
# Update CHANGELOG.md
# Final testing and bug fixes only

# Create PR to main
# Use Release PR template
# Requires 2+ approvals

# After merge, tag the release
git checkout main
git pull origin main
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0

# Merge back to develop
git checkout develop
git merge main
git push origin develop
```

#### 3. Emergency Hotfix

```bash
# Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/v1.2.1

# Fix the critical issue
git add .
git commit -m "fix: critical security issue"

# Create PR to main
# Use Hotfix PR template
# Fast-track approval (1 approval minimum)

# After merge, tag the hotfix
git checkout main
git pull origin main
git tag -a v1.2.1 -m "Hotfix version 1.2.1"
git push origin v1.2.1

# Merge back to develop
git checkout develop
git merge main
git push origin develop
```

### Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```bash
feat(auth): add OAuth2 integration
fix(api): resolve null pointer in user endpoint
docs(readme): update installation instructions
```

### Pull Request Process

1. **Create PR** using appropriate template
2. **Link related issues** using keywords (Closes #123)
3. **Request reviews** from appropriate team members
4. **Ensure CI passes** (tests, linting, security scans)
5. **Address review comments**
6. **Squash commits** if requested
7. **Wait for approval** (varies by branch)
8. **Merge** using "Squash and Merge" or "Rebase and Merge"

### Code Review Guidelines

**As a PR Author:**
- Keep PRs small and focused
- Write clear descriptions
- Add tests for new features
- Update documentation
- Respond to feedback promptly

**As a Reviewer:**
- Review within 24 hours
- Be constructive and respectful
- Test the changes locally if needed
- Check for security issues
- Verify documentation updates

### Branch Cleanup

- Delete feature/bugfix branches after merging
- Keep release and hotfix branches for reference
- Archive branches older than 6 months

## Questions?

Contact the DevOps team: devops@company.com
```

### Step 5: Configure Automatic Branch Deletion

Go to GitHub Settings → Options:

```yaml
Pull Requests:
  ✅ Automatically delete head branches
```

### Step 6: Set Up Branch Protection Automation Script

Create `.github/scripts/setup-branch-protection.sh`:

```bash
#!/bin/bash
# Script to set up branch protection rules via GitHub API

set -e

REPO_OWNER="your-org"
REPO_NAME="your-repo"
GITHUB_TOKEN="${GITHUB_TOKEN}"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN environment variable not set"
    exit 1
fi

API_BASE="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}"

# Function to set branch protection
set_branch_protection() {
    local branch=$1
    local config_file=$2
    
    echo "Setting protection for branch: $branch"
    
    curl -X PUT \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Accept: application/vnd.github.v3+json" \
        "${API_BASE}/branches/${branch}/protection" \
        -d @"${config_file}"
    
    echo "✅ Protection set for $branch"
}

# Main branch protection
cat > /tmp/main-protection.json <<'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["CI/CD Pipeline", "Unit Tests", "Code Quality"]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismissal_restrictions": {},
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 2
  },
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF

set_branch_protection "main" "/tmp/main-protection.json"

# Develop branch protection
cat > /tmp/develop-protection.json <<'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["CI/CD Pipeline", "Unit Tests"]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF

set_branch_protection "develop" "/tmp/develop-protection.json"

echo "✅ All branch protections configured successfully!"
```

Make it executable:
```bash
chmod +x .github/scripts/setup-branch-protection.sh
```

### Verification Steps

```bash
# 1. Verify branches exist
git branch -a | grep -E "(main|develop)"

# 2. Check branch protection via GitHub UI
# Navigate to: Settings → Branches → Branch protection rules

# 3. Test feature branch workflow
git checkout develop
git pull origin develop
git checkout -b feature/test-workflow
echo "test" > test.txt
git add test.txt
git commit -m "feat: test workflow"
git push -u origin feature/test-workflow
# Create PR on GitHub and verify template loads

# 4. Verify branch protection blocks direct push
git checkout main
echo "test" >> README.md
git commit -am "direct commit test"
git push origin main
# Should fail with protection error

# 5. Check automatic branch deletion works
# Merge a PR and verify branch is deleted automatically
```

### Best Practices Implemented

- ✅ **Main Branch Protection**: 2 required approvals, signed commits, linear history
- ✅ **Develop Branch Protection**: 1 required approval, status checks
- ✅ **Release/Hotfix Protection**: Appropriate review requirements
- ✅ **PR Templates**: Separate templates for feature, hotfix, and release PRs
- ✅ **Clear Documentation**: Comprehensive CONTRIBUTING.md with workflows
- ✅ **Commit Conventions**: Conventional Commits standard
- ✅ **Automation**: Script for setting up branch protection via API
- ✅ **Branch Cleanup**: Automatic deletion of merged branches

### Troubleshooting

**Issue 1: Unable to Push to Protected Branch**
```bash
# Error: "Required status checks must pass"
# Solution: Ensure all CI/CD checks are passing before creating PR
git push origin feature/your-branch
# Create PR and wait for checks to complete
```

**Issue 2: PR Template Not Loading**
```bash
# Solution: Template must be in .github/PULL_REQUEST_TEMPLATE/ directory
# Check file naming and location
ls -la .github/PULL_REQUEST_TEMPLATE/
# Commit and push templates if missing
git add .github/
git commit -m "chore: add PR templates"
git push origin develop
```

**Issue 3: Branch Protection API Fails**
```bash
# Solution: Check token permissions
# Token needs: repo (full control of private repositories)
# Generate new token at: Settings → Developer settings → Personal access tokens
export GITHUB_TOKEN="your-token-here"
.github/scripts/setup-branch-protection.sh
```

**Issue 4: Can't Delete Feature Branch**
```bash
# If automatic deletion doesn't work, manual cleanup:
git branch -d feature/branch-name  # local
git push origin --delete feature/branch-name  # remote
```

---

## Task 3.2: Set Up Release Automation with Tags and Changelogs

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-32-set-up-release-automation-with-tags-and-changelogs)**

### Solution Overview

Complete release automation setup with semantic versioning, automated tag creation, changelog generation, and GitHub releases using GitHub Actions and conventional commits.

### Step 1: Set Up Semantic Versioning Structure

Create `.version` file in repository root:

```bash
# Initialize version file
echo "1.0.0" > .version
git add .version
git commit -m "chore: initialize version tracking"
git push origin develop
```

### Step 2: Configure Conventional Commits

Install commitlint for local development:

```bash
# Install commitlint
npm install --save-dev @commitlint/cli @commitlint/config-conventional

# Create commitlint config
cat > .commitlintrc.json <<'EOF'
{
  "extends": ["@commitlint/config-conventional"],
  "rules": {
    "type-enum": [
      2,
      "always",
      [
        "feat",
        "fix",
        "docs",
        "style",
        "refactor",
        "perf",
        "test",
        "build",
        "ci",
        "chore",
        "revert"
      ]
    ],
    "subject-case": [2, "never", ["upper-case"]],
    "subject-empty": [2, "never"],
    "subject-full-stop": [2, "never", "."],
    "header-max-length": [2, "always", 72]
  }
}
EOF
```

Add git hook with Husky:

```bash
# Install Husky
npm install --save-dev husky

# Initialize Husky
npx husky install

# Add commit-msg hook
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit ${1}'

chmod +x .husky/commit-msg
```

### Step 3: Create Automated Release Workflow

Create `.github/workflows/release.yml`:

```yaml
name: Release Automation

on:
  push:
    branches:
      - main
  workflow_dispatch:
    inputs:
      version_bump:
        description: 'Version bump type'
        required: true
        type: choice
        options:
          - major
          - minor
          - patch
        default: 'patch'

permissions:
  contents: write
  pull-requests: write

jobs:
  release:
    name: Create Release
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Get all history for changelog
          token: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Get current version
        id: current_version
        run: |
          if [ -f .version ]; then
            CURRENT_VERSION=$(cat .version)
          else
            CURRENT_VERSION="0.0.0"
          fi
          echo "version=$CURRENT_VERSION" >> $GITHUB_OUTPUT
          echo "Current version: $CURRENT_VERSION"
      
      - name: Determine version bump
        id: version_bump
        run: |
          # Get commits since last tag
          LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
          COMMITS=$(git log ${LAST_TAG}..HEAD --pretty=format:"%s")
          
          # Determine bump type based on conventional commits
          BUMP_TYPE="patch"
          
          if echo "$COMMITS" | grep -q "^feat!:"; then
            BUMP_TYPE="major"
          elif echo "$COMMITS" | grep -q "BREAKING CHANGE"; then
            BUMP_TYPE="major"
          elif echo "$COMMITS" | grep -q "^feat:"; then
            BUMP_TYPE="minor"
          elif echo "$COMMITS" | grep -q "^fix:"; then
            BUMP_TYPE="patch"
          fi
          
          # Override with manual input if provided
          if [ "${{ github.event.inputs.version_bump }}" != "" ]; then
            BUMP_TYPE="${{ github.event.inputs.version_bump }}"
          fi
          
          echo "bump_type=$BUMP_TYPE" >> $GITHUB_OUTPUT
          echo "Bump type: $BUMP_TYPE"
      
      - name: Calculate new version
        id: new_version
        run: |
          CURRENT="${{ steps.current_version.outputs.version }}"
          BUMP="${{ steps.version_bump.outputs.bump_type }}"
          
          IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT"
          MAJOR="${VERSION_PARTS[0]}"
          MINOR="${VERSION_PARTS[1]}"
          PATCH="${VERSION_PARTS[2]}"
          
          case $BUMP in
            major)
              MAJOR=$((MAJOR + 1))
              MINOR=0
              PATCH=0
              ;;
            minor)
              MINOR=$((MINOR + 1))
              PATCH=0
              ;;
            patch)
              PATCH=$((PATCH + 1))
              ;;
          esac
          
          NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
          echo "version=$NEW_VERSION" >> $GITHUB_OUTPUT
          echo "New version: $NEW_VERSION"
      
      - name: Generate Changelog
        id: changelog
        run: |
          LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
          NEW_VERSION="${{ steps.new_version.outputs.version }}"
          
          # Initialize changelog
          cat > CHANGELOG_NEW.md <<'EOF'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

EOF
          
          echo "## [${NEW_VERSION}] - $(date +%Y-%m-%d)" >> CHANGELOG_NEW.md
          echo "" >> CHANGELOG_NEW.md
          
          # Get commits since last tag
          if [ -z "$LAST_TAG" ]; then
            COMMITS=$(git log --pretty=format:"%h %s" --reverse)
          else
            COMMITS=$(git log ${LAST_TAG}..HEAD --pretty=format:"%h %s" --reverse)
          fi
          
          # Parse commits by type
          FEATURES=$(echo "$COMMITS" | grep "^[a-f0-9]\+ feat:" | sed 's/^[a-f0-9]\+ feat: /- /' || true)
          FIXES=$(echo "$COMMITS" | grep "^[a-f0-9]\+ fix:" | sed 's/^[a-f0-9]\+ fix: /- /' || true)
          DOCS=$(echo "$COMMITS" | grep "^[a-f0-9]\+ docs:" | sed 's/^[a-f0-9]\+ docs: /- /' || true)
          BREAKING=$(echo "$COMMITS" | grep -E "(^[a-f0-9]\+ feat!:|BREAKING CHANGE)" | sed 's/^[a-f0-9]\+ /- /' || true)
          
          # Add sections
          if [ ! -z "$BREAKING" ]; then
            echo "### 💥 BREAKING CHANGES" >> CHANGELOG_NEW.md
            echo "" >> CHANGELOG_NEW.md
            echo "$BREAKING" >> CHANGELOG_NEW.md
            echo "" >> CHANGELOG_NEW.md
          fi
          
          if [ ! -z "$FEATURES" ]; then
            echo "### ✨ Features" >> CHANGELOG_NEW.md
            echo "" >> CHANGELOG_NEW.md
            echo "$FEATURES" >> CHANGELOG_NEW.md
            echo "" >> CHANGELOG_NEW.md
          fi
          
          if [ ! -z "$FIXES" ]; then
            echo "### 🐛 Bug Fixes" >> CHANGELOG_NEW.md
            echo "" >> CHANGELOG_NEW.md
            echo "$FIXES" >> CHANGELOG_NEW.md
            echo "" >> CHANGELOG_NEW.md
          fi
          
          if [ ! -z "$DOCS" ]; then
            echo "### 📚 Documentation" >> CHANGELOG_NEW.md
            echo "" >> CHANGELOG_NEW.md
            echo "$DOCS" >> CHANGELOG_NEW.md
            echo "" >> CHANGELOG_NEW.md
          fi
          
          # Merge with existing changelog
          if [ -f CHANGELOG.md ]; then
            # Skip the header from new changelog
            tail -n +6 CHANGELOG_NEW.md > TEMP_NEW.md
            # Get header from existing changelog
            head -n 5 CHANGELOG.md > TEMP_HEADER.md
            # Combine: header + new changes + old changes (skip header)
            cat TEMP_HEADER.md TEMP_NEW.md <(echo "") <(tail -n +6 CHANGELOG.md) > CHANGELOG.md
            rm TEMP_NEW.md TEMP_HEADER.md
          else
            mv CHANGELOG_NEW.md CHANGELOG.md
          fi
          
          rm -f CHANGELOG_NEW.md
          
          # Save release notes for GitHub release
          if [ -z "$LAST_TAG" ]; then
            RANGE_DESC="Initial release"
          else
            RANGE_DESC="Changes since ${LAST_TAG}"
          fi
          
          {
            echo "## What's Changed"
            echo ""
            echo "$RANGE_DESC"
            echo ""
            cat CHANGELOG.md | sed -n "/## \[${NEW_VERSION}\]/,/## \[/p" | sed '1d;$d'
          } > RELEASE_NOTES.md
          
          echo "Changelog generated"
      
      - name: Update version in files
        run: |
          NEW_VERSION="${{ steps.new_version.outputs.version }}"
          
          # Update .version file
          echo "$NEW_VERSION" > .version
          
          # Update package.json if exists
          if [ -f package.json ]; then
            npm version $NEW_VERSION --no-git-tag-version --allow-same-version
          fi
          
          # Update any other version files
          # Add your specific version update commands here
          
          echo "Version updated in all files"
      
      - name: Commit changes
        run: |
          NEW_VERSION="${{ steps.new_version.outputs.version }}"
          
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          
          git add .version CHANGELOG.md package.json package-lock.json 2>/dev/null || true
          git commit -m "chore(release): v${NEW_VERSION}" || echo "No changes to commit"
          git push origin main
      
      - name: Create and push tag
        run: |
          NEW_VERSION="${{ steps.new_version.outputs.version }}"
          
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          
          git tag -a "v${NEW_VERSION}" -m "Release version ${NEW_VERSION}"
          git push origin "v${NEW_VERSION}"
          
          echo "Tag v${NEW_VERSION} created and pushed"
      
      - name: Create GitHub Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: v${{ steps.new_version.outputs.version }}
          release_name: Release v${{ steps.new_version.outputs.version }}
          body_path: RELEASE_NOTES.md
          draft: false
          prerelease: false
      
      - name: Merge back to develop
        run: |
          git fetch origin develop
          git checkout develop
          git merge main --no-edit
          git push origin develop
        continue-on-error: true  # Don't fail if develop doesn't exist
```

### Step 4: Create Manual Release Script

Create `.github/scripts/create-release.sh`:

```bash
#!/bin/bash
# Manual release creation script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    print_error "Must be on main branch to create release"
    print_info "Current branch: $CURRENT_BRANCH"
    exit 1
fi

# Get current version
if [ -f .version ]; then
    CURRENT_VERSION=$(cat .version)
else
    CURRENT_VERSION="0.0.0"
fi

print_info "Current version: $CURRENT_VERSION"

# Ask for bump type
echo ""
echo "Select version bump type:"
echo "  1) Major (Breaking changes)"
echo "  2) Minor (New features)"
echo "  3) Patch (Bug fixes)"
echo -n "Enter choice [1-3]: "
read CHOICE

case $CHOICE in
    1) BUMP_TYPE="major" ;;
    2) BUMP_TYPE="minor" ;;
    3) BUMP_TYPE="patch" ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

# Calculate new version
IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR="${VERSION_PARTS[0]}"
MINOR="${VERSION_PARTS[1]}"
PATCH="${VERSION_PARTS[2]}"

case $BUMP_TYPE in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"

print_info "New version will be: $NEW_VERSION"

# Confirm
echo -n "Proceed with release v${NEW_VERSION}? [y/N]: "
read CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    print_warning "Release cancelled"
    exit 0
fi

# Update version file
echo "$NEW_VERSION" > .version

# Update package.json if exists
if [ -f package.json ]; then
    npm version $NEW_VERSION --no-git-tag-version --allow-same-version
    print_info "Updated package.json"
fi

# Generate changelog entry
print_info "Generating changelog..."

LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
CHANGELOG_ENTRY="## [${NEW_VERSION}] - $(date +%Y-%m-%d)\n\n"

if [ -z "$LAST_TAG" ]; then
    COMMITS=$(git log --pretty=format:"%h %s")
else
    COMMITS=$(git log ${LAST_TAG}..HEAD --pretty=format:"%h %s")
fi

# Add to CHANGELOG.md
if [ ! -f CHANGELOG.md ]; then
    cat > CHANGELOG.md <<'EOF'
# Changelog

All notable changes to this project will be documented in this file.

EOF
fi

# Insert new entry after header
sed -i "3i\\${CHANGELOG_ENTRY}" CHANGELOG.md

# Commit changes
git add .version CHANGELOG.md package.json package-lock.json 2>/dev/null || true
git commit -m "chore(release): v${NEW_VERSION}"

# Create and push tag
git tag -a "v${NEW_VERSION}" -m "Release version ${NEW_VERSION}"

print_info "Pushing changes and tag..."
git push origin main
git push origin "v${NEW_VERSION}"

print_info "✅ Release v${NEW_VERSION} created successfully!"
print_info "Create GitHub release at: https://github.com/YOUR_ORG/YOUR_REPO/releases/new?tag=v${NEW_VERSION}"
```

Make it executable:
```bash
chmod +x .github/scripts/create-release.sh
```

### Step 5: Set Up Release Notifications

Create `.github/workflows/release-notification.yml`:

```yaml
name: Release Notifications

on:
  release:
    types: [published]

jobs:
  notify:
    name: Send Release Notifications
    runs-on: ubuntu-latest
    
    steps:
      - name: Get release info
        id: release_info
        run: |
          echo "tag=${{ github.event.release.tag_name }}" >> $GITHUB_OUTPUT
          echo "name=${{ github.event.release.name }}" >> $GITHUB_OUTPUT
          echo "url=${{ github.event.release.html_url }}" >> $GITHUB_OUTPUT
      
      - name: Notify Slack
        if: ${{ secrets.SLACK_WEBHOOK_URL }}
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "🚀 New Release Published!",
              "blocks": [
                {
                  "type": "header",
                  "text": {
                    "type": "plain_text",
                    "text": "🚀 New Release: ${{ steps.release_info.outputs.tag }}"
                  }
                },
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*Release Name:* ${{ steps.release_info.outputs.name }}\n*Tag:* ${{ steps.release_info.outputs.tag }}\n*URL:* <${{ steps.release_info.outputs.url }}|View Release>"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
          SLACK_WEBHOOK_TYPE: INCOMING_WEBHOOK
      
      - name: Comment on related issues
        uses: actions/github-script@v7
        with:
          script: |
            const release = context.payload.release;
            const tag = release.tag_name;
            const body = release.body;
            
            // Extract issue numbers from release notes
            const issueRegex = /#(\d+)/g;
            const issues = [...body.matchAll(issueRegex)].map(match => parseInt(match[1]));
            
            for (const issue_number of issues) {
              await github.rest.issues.createComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: issue_number,
                body: `🎉 This issue has been resolved in [${tag}](${release.html_url})`
              });
            }
```

### Step 6: Configure Release Branches

Update `.github/workflows/release.yml` to handle release branches:

Create `.github/workflows/prepare-release.yml`:

```yaml
name: Prepare Release Branch

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Release version (e.g., 1.2.0)'
        required: true

jobs:
  create_release_branch:
    name: Create Release Branch
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout develop
        uses: actions/checkout@v4
        with:
          ref: develop
          fetch-depth: 0
      
      - name: Create release branch
        run: |
          VERSION="${{ github.event.inputs.version }}"
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          
          git checkout -b "release/v${VERSION}"
          
          # Update version files
          echo "$VERSION" > .version
          
          if [ -f package.json ]; then
            npm version $VERSION --no-git-tag-version --allow-same-version
          fi
          
          git add .version package.json package-lock.json 2>/dev/null || true
          git commit -m "chore: prepare release v${VERSION}" || echo "No changes"
          
          git push origin "release/v${VERSION}"
      
      - name: Create PR to main
        uses: actions/github-script@v7
        with:
          script: |
            const version = '${{ github.event.inputs.version }}';
            await github.rest.pulls.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: `Release v${version}`,
              head: `release/v${version}`,
              base: 'main',
              body: `## Release v${version}\n\nThis PR prepares the release v${version}.\n\n### Checklist\n- [ ] All tests passing\n- [ ] Documentation updated\n- [ ] CHANGELOG.md reviewed\n- [ ] Version bumped in all files\n- [ ] Release notes prepared`
            });
```

### Verification Steps

```bash
# 1. Test conventional commits
git add .
git commit -m "feat: add new feature"  # Should pass
git commit -m "invalid commit"  # Should fail with commitlint

# 2. Create a test release (manual)
.github/scripts/create-release.sh

# 3. Verify tag was created
git tag -l

# 4. Check changelog was generated
cat CHANGELOG.md

# 5. Verify GitHub release
# Go to: https://github.com/YOUR_ORG/YOUR_REPO/releases

# 6. Test automated release workflow
git push origin main
# Check Actions tab for workflow run

# 7. Test release branch workflow
# Go to Actions → Prepare Release Branch → Run workflow
# Enter version: 1.1.0
# Verify PR is created
```

### Best Practices Implemented

- ✅ **Semantic Versioning**: Proper major.minor.patch versioning
- ✅ **Conventional Commits**: Enforced commit message format
- ✅ **Automated Changelog**: Generated from commit history
- ✅ **Automated Tagging**: Tags created automatically on release
- ✅ **GitHub Releases**: Automated release creation with notes
- ✅ **Release Branches**: Dedicated branches for release preparation
- ✅ **Notifications**: Slack notifications and issue comments
- ✅ **Version Management**: Centralized version tracking
- ✅ **Manual Override**: Script for manual releases when needed

### Troubleshooting

**Issue 1: Commitlint Not Working**
```bash
# Reinstall Husky hooks
rm -rf .husky
npx husky install
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit ${1}'
chmod +x .husky/commit-msg

# Test
git commit -m "test: commitlint" --allow-empty
```

**Issue 2: Changelog Not Generating**
```bash
# Manually generate changelog
LAST_TAG=$(git describe --tags --abbrev=0)
git log ${LAST_TAG}..HEAD --pretty=format:"%s" | grep "^feat:\|^fix:"

# Check if commits follow conventional format
git log --oneline -10
```

**Issue 3: Tag Already Exists**
```bash
# Delete tag locally and remotely
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0

# Recreate with correct version
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

**Issue 4: GitHub Actions Workflow Fails**
```bash
# Check workflow permissions
# Settings → Actions → General → Workflow permissions
# Ensure "Read and write permissions" is enabled

# Check if GITHUB_TOKEN has proper scopes
# For private repos, may need PAT with 'repo' scope
```

---

## Task 3.3: Implement Code Review Process with CODEOWNERS

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-33-implement-code-review-process-with-codeowners)**

### Solution Overview

Complete code review process implementation with CODEOWNERS, automatic reviewer assignment, review guidelines, and SLA documentation.

### Step 1: Create CODEOWNERS File

Create `.github/CODEOWNERS`:

```
# GitHub CODEOWNERS File
# This file defines individuals or teams responsible for code in this repository.
# Order is important; the last matching pattern takes precedence.

# Default owners for everything in the repo
* @devops-team @tech-leads

# Frontend code
/frontend/** @frontend-team @ui-ux-leads
/src/components/** @frontend-team
/public/** @frontend-team

# Backend code
/backend/** @backend-team @api-leads
/src/api/** @backend-team
/src/services/** @backend-team
/src/models/** @backend-team @database-team

# Database and migrations
/database/** @database-team @backend-team
/migrations/** @database-team @dba
*.sql @database-team

# Infrastructure and DevOps
/terraform/** @devops-team @infrastructure-leads
/kubernetes/** @devops-team @platform-team
/docker/** @devops-team
/.github/workflows/** @devops-team @ci-cd-leads
Dockerfile @devops-team
docker-compose.yml @devops-team

# CI/CD pipelines
/.github/workflows/** @devops-team @ci-cd-leads
/jenkins/** @devops-team
/.circleci/** @devops-team

# Configuration files
/config/** @devops-team @backend-team
*.env.example @devops-team @security-team
*.yaml @devops-team
*.yml @devops-team

# Documentation
/docs/** @technical-writers @tech-leads
*.md @technical-writers
README.md @tech-leads @product-team

# Security-sensitive files
/security/** @security-team @infosec-leads
SECURITY.md @security-team
/secrets/** @security-team @devops-team

# Testing
/tests/** @qa-team @backend-team @frontend-team
*.test.js @qa-team @backend-team
*.spec.js @qa-team @frontend-team
/e2e/** @qa-team

# Dependencies and package management
package.json @devops-team @tech-leads
package-lock.json @devops-team
requirements.txt @backend-team @devops-team
Gemfile @backend-team
go.mod @backend-team
go.sum @backend-team

# Build and deployment
/build/** @devops-team
/dist/** @devops-team
Makefile @devops-team
/scripts/** @devops-team @backend-team

# Specific critical files requiring senior review
/src/auth/** @security-team @senior-backend-devs
/src/payment/** @security-team @senior-backend-devs @compliance-team
/src/billing/** @backend-team @finance-team @compliance-team
```

### Step 2: Create Code Review Guidelines

Create `.github/CODE_REVIEW_GUIDELINES.md`:

```markdown
# Code Review Guidelines

## 🎯 Purpose

Code reviews ensure code quality, knowledge sharing, and team collaboration. Every code change must be reviewed before merging.

## 👥 Reviewer Assignment

### Automatic Assignment
- CODEOWNERS automatically assigns reviewers based on file paths
- GitHub assigns additional reviewers based on team load balancing

### Manual Assignment
- Assign specific reviewers for:
  - Cross-functional changes
  - Architectural decisions
  - Performance-critical code
  - Security-sensitive changes

## ⏱️ Review SLAs

| Priority | Response Time | Review Completion |
|----------|--------------|-------------------|
| **Critical** (Hotfix) | 30 minutes | 2 hours |
| **High** (Production bug) | 4 hours | 1 business day |
| **Medium** (Feature) | 1 business day | 2 business days |
| **Low** (Docs, refactor) | 2 business days | 3 business days |

## 📋 Review Checklist

### As a PR Author

**Before Creating PR:**
- [ ] Code follows project style guidelines
- [ ] All tests pass locally
- [ ] No console.log or debug code
- [ ] Comments explain "why", not "what"
- [ ] Documentation updated
- [ ] PR description is clear and complete
- [ ] Linked related issues
- [ ] Added appropriate labels

**During Review:**
- [ ] Respond to comments within 24 hours
- [ ] Mark resolved conversations
- [ ] Update PR based on feedback
- [ ] Request re-review after significant changes
- [ ] Be receptive to feedback

### As a Reviewer

**What to Review:**
- [ ] **Functionality**: Does it work as intended?
- [ ] **Tests**: Are there adequate tests?
- [ ] **Security**: Any security vulnerabilities?
- [ ] **Performance**: Any performance issues?
- [ ] **Readability**: Is code easy to understand?
- [ ] **Maintainability**: Is it easy to maintain?
- [ ] **Documentation**: Is documentation adequate?
- [ ] **Dependencies**: Are new dependencies justified?

**Review Process:**
1. **Understand Context** (5 min)
   - Read PR description
   - Check linked issues
   - Understand business requirement

2. **High-Level Review** (10 min)
   - Check architecture and approach
   - Verify design patterns
   - Check for anti-patterns

3. **Detailed Code Review** (20-30 min)
   - Review each file systematically
   - Check logic and edge cases
   - Verify error handling
   - Check test coverage

4. **Provide Feedback** (10 min)
   - Be specific and constructive
   - Suggest improvements
   - Approve or request changes
   - Add inline comments for clarity

## 💬 Comment Guidelines

### Types of Comments

**Required Changes (Blocking):**
```
❌ REQUIRED: This will cause a null pointer exception when user is not logged in.
```

**Suggestions (Non-blocking):**
```
💡 SUGGESTION: Consider using a Map instead of an array for O(1) lookups.
```

**Questions:**
```
❓ QUESTION: Why are we using setTimeout here? Is there a race condition?
```

**Praise:**
```
✨ NICE: Great use of the factory pattern here!
```

### Comment Best Practices

**DO:**
- ✅ Be specific: Point to exact line/code
- ✅ Be constructive: Suggest solutions
- ✅ Be respectful: Assume good intentions
- ✅ Explain reasoning: Help others learn
- ✅ Link to resources: Share documentation

**DON'T:**
- ❌ Be vague: "This doesn't look right"
- ❌ Be condescending: "Everyone knows this"
- ❌ Nitpick: Focus on auto-lintable issues
- ❌ Debate in comments: Take offline if needed
- ❌ Approve without reviewing: Actually review!

## 🚫 Common Review Mistakes

### Mistake 1: Rubber Stamping
**Problem:** Approving without actually reviewing
**Solution:** Take time to understand the code

### Mistake 2: Over-Engineering
**Problem:** Requiring perfect code in every PR
**Solution:** Accept "good enough" if it improves codebase

### Mistake 3: Bike Shedding
**Problem:** Focusing on trivial details
**Solution:** Focus on important issues first

### Mistake 4: Blocking for Style
**Problem:** Requesting changes for personal preferences
**Solution:** Follow agreed style guide, use auto-formatting

## 📊 Review Size Guidelines

| Lines Changed | Ideal Review Time | Max PR Size |
|---------------|-------------------|-------------|
| < 50 | 10 minutes | Small PR ✅ |
| 50-200 | 30 minutes | Medium PR ✅ |
| 200-500 | 1 hour | Large PR ⚠️ |
| > 500 | 2+ hours | Too Large ❌ |

**Large PRs:** Should be split into smaller, focused PRs when possible.

## 🎯 Approval Requirements

### Feature PRs → Develop
- **Minimum:** 1 approval
- **Required:** Code owner approval
- **Recommended:** 2 approvals

### Release PRs → Main
- **Minimum:** 2 approvals
- **Required:** Tech lead approval
- **Required:** QA sign-off

### Hotfix PRs → Main
- **Minimum:** 1 approval
- **Required:** Senior engineer approval
- **Required:** On-call approval

## 🔄 Re-review Process

**When to Request Re-review:**
- Significant code changes
- Addressing blocking comments
- Adding new functionality
- Changing approach/architecture

**When Re-review Not Needed:**
- Typo fixes
- Comment updates
- Minor refactoring
- Formatting changes

## 🏆 Review Quality Metrics

We track these metrics to improve our review process:

- **Response Time:** Time from PR creation to first review
- **Review Completion Time:** Time from creation to approval
- **Iteration Count:** Number of review rounds
- **Defect Rate:** Issues found in production from reviewed code

## 📚 Resources

- [Google's Code Review Guidelines](https://google.github.io/eng-practices/review/)
- [Effective Code Reviews](https://mtlynch.io/human-code-reviews-1/)
- [Pull Request Best Practices](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests)

## ❓ Questions?

Contact @tech-leads or ask in #engineering-practices
```

### Step 3: Set Up Required Approvals

Go to GitHub Settings → Branches → Edit branch protection:

```yaml
Branch: main
Required reviews:
  ✅ Require approvals: 2
  ✅ Require review from Code Owners
  
Branch: develop
Required reviews:
  ✅ Require approvals: 1
  ✅ Require review from Code Owners (for certain paths)
```

### Step 4: Configure Auto-Assignment

Create `.github/auto_assign.yml`:

```yaml
# Auto-assignment configuration
# Automatically assigns reviewers to PRs

# Number of reviewers to assign
addReviewers: 2

# Number of assignees to assign
addAssignees: 1

# Reviewers to assign (in addition to CODEOWNERS)
reviewers:
  - backend-team
  - frontend-team
  - devops-team

# Assignees for the PR
assignees:
  - tech-leads

# Keywords to determine reviewer assignment
reviewGroups:
  backend:
    - backend/**
    - src/api/**
    - src/services/**
  frontend:
    - frontend/**
    - src/components/**
    - public/**
  devops:
    - terraform/**
    - kubernetes/**
    - .github/workflows/**
  security:
    - src/auth/**
    - src/payment/**
    - security/**

# Skip assignment for certain users
skipKeywords:
  - WIP
  - DO NOT MERGE
  - DRAFT
```

Install GitHub App: **Auto Assign** or create workflow:

Create `.github/workflows/auto-assign.yml`:

```yaml
name: Auto Assign Reviewers

on:
  pull_request:
    types: [opened, ready_for_review]

jobs:
  auto_assign:
    runs-on: ubuntu-latest
    if: github.event.pull_request.draft == false
    
    steps:
      - name: Auto assign reviewers
        uses: kentaro-m/auto-assign-action@v1.2.5
        with:
          configuration-path: '.github/auto_assign.yml'
```

### Step 5: Document Review SLAs

Create `.github/REVIEW_SLA.md`:

```markdown
# Code Review Service Level Agreements (SLAs)

## Response Time SLAs

| PR Priority | First Response | Review Completion | Escalation After |
|-------------|----------------|-------------------|------------------|
| 🔴 **Critical** (Hotfix) | 30 minutes | 2 hours | 1 hour |
| 🟠 **High** (Prod Bug) | 4 hours | 1 business day | 1 day |
| 🟡 **Medium** (Feature) | 1 business day | 2 business days | 3 days |
| 🟢 **Low** (Docs) | 2 business days | 3 business days | 5 days |

## Business Hours

- **Standard Hours:** 9 AM - 5 PM (Team timezone)
- **On-Call Hours:** 24/7 for Critical/High priority
- **Weekends:** On-call only for Critical issues

## Escalation Process

### Level 1: Assigned Reviewer (Default)
- Primary code owner reviews PR
- Follow standard SLA times

### Level 2: Team Lead (SLA Breach)
- If no response within SLA
- Tag team lead: @team-lead
- Notify in team channel

### Level 3: Engineering Manager (Critical Delay)
- If still no response after 2x SLA
- Tag engineering manager: @eng-manager
- Create incident if blocking release

## Out of Office

**When you're OOO:**
1. Update GitHub status
2. Set vacation responder
3. Delegate review responsibilities
4. Update on-call schedule

## Metrics & Monitoring

We track:
- **Response Time**: Time to first review comment
- **Completion Time**: Time to PR approval
- **SLA Compliance**: % of PRs meeting SLA
- **Reviewer Load**: PRs per reviewer per week

View metrics: [Internal Dashboard Link]

## Responsibilities

**PR Author:**
- Set appropriate priority label
- Ping reviewers if SLA approaching
- Provide context to speed up review

**Reviewer:**
- Check GitHub notifications regularly
- Prioritize critical/high PRs
- Communicate delays proactively

**Team Lead:**
- Monitor team SLA compliance
- Balance reviewer workload
- Remove blockers
```

### Step 6: Create Review Request Template

Update `.github/PULL_REQUEST_TEMPLATE.md`:

Add section for review guidance:

```markdown
## 🔍 Review Focus Areas

<!-- Help reviewers by highlighting what to focus on -->

**Critical Areas:**
- [ ] Security: Authentication/authorization logic
- [ ] Performance: Database queries, API calls
- [ ] Business Logic: Payment processing, data calculations

**What Changed:**
- Technical approach used:
- Affected systems:
- Risk level: Low / Medium / High

**Testing:**
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

**Estimated Review Time:** ~30 minutes

**Reviewers Needed:**
- [ ] Backend engineer (for API changes)
- [ ] Frontend engineer (for UI changes)
- [ ] DevOps engineer (for infrastructure)
- [ ] Security engineer (for security-sensitive code)
```

### Verification Steps

```bash
# 1. Test CODEOWNERS file
# Go to GitHub and create a test PR touching different paths
# Verify correct reviewers are auto-assigned

# 2. Verify branch protection enforces code owners
git checkout -b test-codeowners
echo "test" >> README.md
git add README.md
git commit -m "test: codeowners"
git push origin test-codeowners
# Create PR, verify tech-leads are required reviewers

# 3. Test review workflow
# Create PR, add reviewers, test comment types
# Verify approval requirements work

# 4. Check auto-assignment works
# Create new PR, wait 30 seconds
# Verify reviewers automatically assigned

# 5. Validate SLA documentation
# Share REVIEW_SLA.md with team
# Get feedback and adjust as needed
```

### Best Practices Implemented

- ✅ **CODEOWNERS File**: Granular ownership by path
- ✅ **Auto-Assignment**: Automatic reviewer assignment based on changes
- ✅ **Clear Guidelines**: Comprehensive review documentation
- ✅ **SLA Definition**: Clear response time expectations
- ✅ **Review Templates**: Structured review requests
- ✅ **Escalation Process**: Clear escalation paths
- ✅ **Comment Standards**: Structured feedback types
- ✅ **Metrics Tracking**: Review performance monitoring

### Troubleshooting

**Issue 1: CODEOWNERS Not Working**
```bash
# File must be in one of these locations:
# - .github/CODEOWNERS
# - CODEOWNERS (root)
# - docs/CODEOWNERS

# Verify file location
ls -la .github/CODEOWNERS

# Check syntax - no extra spaces, valid GitHub handles
# Test: Create PR and check "Reviewers" section
```

**Issue 2: Auto-Assignment Not Triggering**
```bash
# Verify workflow file exists and is valid
cat .github/workflows/auto-assign.yml

# Check workflow runs in Actions tab
# Ensure auto_assign.yml config file exists
cat .github/auto_assign.yml

# Check GitHub App is installed (if using App approach)
# Settings → Applications → Auto Assign
```

**Issue 3: Wrong Reviewers Assigned**
```bash
# CODEOWNERS uses last matching pattern
# Move more specific patterns below general ones

# Wrong order:
* @team-a
/frontend/** @team-b  # This will be overridden

# Correct order:
/frontend/** @team-b
* @team-a  # This applies to everything else
```

---

## Task 3.4: Enable Security Features (Dependabot, Code Scanning)

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-34-enable-security-features-dependabot-code-scanning)**

### Solution Overview

Complete security feature implementation including Dependabot for automated dependency updates, CodeQL for code scanning, secret scanning, and security policy documentation.

### Step 1: Enable and Configure Dependabot

Create `.github/dependabot.yml`:

```yaml
version: 2
updates:
  # NPM dependencies
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
    open-pull-requests-limit: 5
    reviewers:
      - "devops-team"
      - "backend-team"
    assignees:
      - "tech-lead"
    commit-message:
      prefix: "chore"
      prefix-development: "chore"
      include: "scope"
    labels:
      - "dependencies"
      - "automated"
    milestone: 10
    ignore:
      # Ignore major version updates for stable dependencies
      - dependency-name: "react"
        update-types: ["version-update:semver-major"]
      - dependency-name: "webpack"
        update-types: ["version-update:semver-major"]
    # Group updates for better management
    groups:
      development-dependencies:
        dependency-type: "development"
      production-dependencies:
        dependency-type: "production"
        update-types:
          - "minor"
          - "patch"

  # Python dependencies
  - package-ecosystem: "pip"
    directory: "/backend"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 3
    reviewers:
      - "backend-team"
    labels:
      - "dependencies"
      - "python"
    versioning-strategy: increase

  # Docker base images
  - package-ecosystem: "docker"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "devops-team"
    labels:
      - "dependencies"
      - "docker"

  # GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "monthly"
    reviewers:
      - "devops-team"
    labels:
      - "dependencies"
      - "ci-cd"
    commit-message:
      prefix: "ci"

  # Terraform
  - package-ecosystem: "terraform"
    directory: "/terraform"
    schedule:
      interval: "weekly"
    reviewers:
      - "devops-team"
      - "infrastructure-team"
    labels:
      - "dependencies"
      - "infrastructure"

  # Go modules
  - package-ecosystem: "gomod"
    directory: "/services/api"
    schedule:
      interval: "weekly"
    reviewers:
      - "backend-team"
    labels:
      - "dependencies"
      - "golang"
```

### Step 2: Enable CodeQL Code Scanning

Create `.github/workflows/codeql-analysis.yml`:

```yaml
name: "CodeQL Security Scanning"

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  schedule:
    # Run every Monday at 6 AM UTC
    - cron: '0 6 * * 1'

jobs:
  analyze:
    name: Analyze Code
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write

    strategy:
      fail-fast: false
      matrix:
        language: [ 'javascript', 'python', 'go' ]
        # CodeQL supports: 'cpp', 'csharp', 'go', 'java', 'javascript', 'python', 'ruby'

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Initialize CodeQL
        uses: github/codeql-action/init@v2
        with:
          languages: ${{ matrix.language }}
          # Override detected languages if needed
          # queries: security-and-quality, security-extended
          queries: +security-extended,security-and-quality
          # Specify custom queries
          # config-file: ./.github/codeql/codeql-config.yml

      # Autobuild attempts to build code automatically
      - name: Autobuild
        uses: github/codeql-action/autobuild@v2
        # For compiled languages, you may need manual build steps:
        # - name: Build
        #   run: |
        #     make bootstrap
        #     make release

      - name: Perform CodeQL Analysis
        uses: github/codeql-action/analyze@v2
        with:
          category: "/language:${{matrix.language}}"
          # Upload results to Security tab
          upload: true
          # Fail the build on critical/high severity issues
          # fail-on: critical,high
```

Create custom CodeQL configuration `.github/codeql/codeql-config.yml`:

```yaml
name: "Custom CodeQL Config"

disable-default-queries: false

queries:
  - uses: security-extended
  - uses: security-and-quality

paths-ignore:
  - 'node_modules/**'
  - 'vendor/**'
  - '**/test/**'
  - '**/*_test.go'
  - '**/*.test.js'
  - 'dist/**'
  - 'build/**'

paths:
  - 'src/**'
  - 'backend/**'
  - 'services/**'

# Custom query packs
packs:
  javascript:
    - codeql/javascript-queries
    - codeql/javascript-all
  python:
    - codeql/python-queries
  go:
    - codeql/go-queries
```

### Step 3: Enable Secret Scanning

Go to GitHub Settings:

1. **Settings** → **Security & analysis**
2. Enable **Secret scanning**
3. Enable **Push protection** (prevents committing secrets)
4. Configure **Custom patterns** if needed

Create `.github/secret-scanning.yml` for custom patterns:

```yaml
# Custom patterns for secret scanning
patterns:
  - name: "Internal API Key"
    pattern: 'internal_api_[a-zA-Z0-9]{32}'
    
  - name: "Database Connection String"
    pattern: 'postgres://[a-zA-Z0-9]+:[a-zA-Z0-9]+@[a-zA-Z0-9.-]+:[0-9]+/[a-zA-Z0-9_]+'
    
  - name: "AWS Access Key"
    pattern: 'AKIA[0-9A-Z]{16}'
    
  - name: "Private Key"
    pattern: '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
```

### Step 4: Create Security Policy

Create `SECURITY.md`:

```markdown
# Security Policy

## 🔒 Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please report it responsibly.

### How to Report

**DO NOT** create a public GitHub issue for security vulnerabilities.

Instead, please report via:

1. **GitHub Security Advisories** (Preferred)
   - Go to: https://github.com/YOUR_ORG/YOUR_REPO/security/advisories/new
   - Provide detailed information about the vulnerability

2. **Email**
   - Send to: security@company.com
   - Use PGP key: [Link to public key]
   - Include "SECURITY" in subject line

### What to Include

Please provide:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)
- Your contact information

### Response Timeline

- **Acknowledgment**: Within 24 hours
- **Initial Assessment**: Within 3 business days
- **Status Update**: Weekly until resolved
- **Resolution**: Varies by severity

## 🛡️ Security Measures

### Automated Security

- **Dependabot**: Automated dependency updates
- **CodeQL**: Static code analysis
- **Secret Scanning**: Prevents credential leaks
- **Branch Protection**: Enforced code review

### Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.x.x   | ✅ Yes            |
| 1.9.x   | ✅ Yes            |
| 1.8.x   | ⚠️ Security fixes only |
| < 1.8   | ❌ No             |

### Security Updates

- **Critical**: Patched within 24 hours
- **High**: Patched within 1 week
- **Medium**: Patched in next minor release
- **Low**: Patched in next major release

## 🎯 Security Best Practices

### For Contributors

1. **Never commit secrets** (use environment variables)
2. **Keep dependencies updated**
3. **Follow secure coding guidelines**
4. **Enable 2FA** on GitHub account
5. **Sign commits** with GPG key

### For Users

1. **Keep your installation updated**
2. **Use strong passwords** for database/services
3. **Enable HTTPS** for all deployments
4. **Monitor security advisories**
5. **Regular security audits**

## 📚 Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [Secure Coding Guidelines](./docs/SECURE_CODING.md)

## 🏆 Hall of Fame

We thank security researchers who responsibly disclose vulnerabilities:

- [Researcher Name] - [Vulnerability] - [Date]

## ❓ Questions

For general security questions: security@company.com
For urgent issues: Call +1-XXX-XXX-XXXX (24/7 hotline)
```

### Step 5: Configure Security Workflows

Create `.github/workflows/security-checks.yml`:

```yaml
name: Security Checks

on:
  pull_request:
    branches: [ main, develop ]
  push:
    branches: [ main ]
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday

jobs:
  dependency-check:
    name: Dependency Vulnerability Check
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Run npm audit
        if: hashFiles('package-lock.json') != ''
        run: |
          npm audit --audit-level=high || true
          npm audit --json > npm-audit.json || true
      
      - name: Run pip safety check
        if: hashFiles('requirements.txt') != ''
        run: |
          pip install safety
          safety check --json --file=requirements.txt || true
      
      - name: Run Snyk security scan
        uses: snyk/actions/node@master
        continue-on-error: true
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high

  secret-scan:
    name: Secret Scanning
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: TruffleHog Secret Scan
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: main
          head: HEAD

  docker-scan:
    name: Docker Image Security Scan
    runs-on: ubuntu-latest
    if: hashFiles('Dockerfile') != ''
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Build Docker image
        run: docker build -t test-image:latest .
      
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'test-image:latest'
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'
      
      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
```

### Step 6: Set Up Security Alerts Monitoring

Create `.github/workflows/security-alerts.yml`:

```yaml
name: Security Alerts Monitor

on:
  schedule:
    - cron: '0 9 * * *'  # Daily at 9 AM
  workflow_dispatch:

jobs:
  check-alerts:
    name: Check Security Alerts
    runs-on: ubuntu-latest
    
    steps:
      - name: Check Dependabot Alerts
        uses: actions/github-script@v7
        with:
          script: |
            const alerts = await github.rest.dependabot.listAlertsForRepo({
              owner: context.repo.owner,
              repo: context.repo.repo,
              state: 'open'
            });
            
            if (alerts.data.length > 0) {
              console.log(`Found ${alerts.data.length} open Dependabot alerts`);
              
              const critical = alerts.data.filter(a => a.security_advisory.severity === 'critical');
              const high = alerts.data.filter(a => a.security_advisory.severity === 'high');
              
              if (critical.length > 0 || high.length > 0) {
                core.setFailed(`CRITICAL: ${critical.length} critical, ${high.length} high severity alerts!`);
              }
            }
      
      - name: Send Slack Notification
        if: failure()
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "🚨 Security Alert: Critical/High severity vulnerabilities detected!",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*Repository:* ${{ github.repository }}\n*Action:* Review and fix security alerts immediately"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_SECURITY_WEBHOOK }}
```

### Verification Steps

```bash
# 1. Verify Dependabot configuration
# Go to: Settings → Security & analysis → Dependabot
# Check: "Dependabot alerts" and "Dependabot security updates" are enabled

# 2. Test Dependabot (force check)
# Go to: Insights → Dependency graph → Dependabot
# Click "Check for updates" button

# 3. Verify CodeQL is running
# Go to: Actions tab
# Look for "CodeQL" workflow runs
# Or trigger manually: Actions → CodeQL → Run workflow

# 4. Check CodeQL results
# Go to: Security → Code scanning alerts
# Should see CodeQL analysis results

# 5. Test secret scanning
echo "fake_secret_AKIA1234567890123456" > test-secret.txt
git add test-secret.txt
git commit -m "test: secret scanning"
# Should be blocked by push protection

# 6. Review security policy
cat SECURITY.md
# Share with team for review

# 7. Monitor security dashboard
# Go to: Security → Overview
# View all security features status
```

### Best Practices Implemented

- ✅ **Dependabot**: Automated dependency updates with smart grouping
- ✅ **CodeQL Scanning**: Automated code security analysis
- ✅ **Secret Scanning**: Prevents credential leaks with push protection
- ✅ **Security Policy**: Clear vulnerability reporting process
- ✅ **Multiple Ecosystems**: Coverage for npm, pip, Docker, Terraform, Go
- ✅ **Custom Patterns**: Organization-specific secret patterns
- ✅ **Security Workflows**: Additional automated security checks
- ✅ **Alert Monitoring**: Proactive security alert tracking
- ✅ **Notifications**: Slack integration for critical alerts

### Troubleshooting

**Issue 1: Dependabot Not Creating PRs**
```bash
# Check Dependabot logs
# Go to: Insights → Dependency graph → Dependabot
# Click "Last checked" to see logs

# Common causes:
# 1. open-pull-requests-limit reached
# 2. No updates available
# 3. Version constraints too restrictive in package.json/requirements.txt

# Force check:
# Click "Check for updates" in Dependabot tab
```

**Issue 2: CodeQL Failing to Build**
```bash
# For compiled languages, may need custom build steps
# Update .github/workflows/codeql-analysis.yml:

- name: Build
  run: |
    # Add your build commands
    npm run build
    # or
    make build
    # or
    go build ./...
```

**Issue 3: Too Many False Positives in CodeQL**
```bash
# Adjust severity level or use custom configuration
# Edit .github/codeql/codeql-config.yml

# Ignore specific paths or add suppressions
paths-ignore:
  - '**/test/**'
  - 'docs/**'
  - '**/*.test.js'
```

**Issue 4: Secret Scanning Blocking Valid Code**
```bash
# If you need to commit something that looks like a secret but isn't:
# 1. Use a different format if possible
# 2. Add to .gitattributes to exclude from scanning:
echo "path/to/file linguist-generated=true" >> .gitattributes

# Or request bypass (admin only):
# During push, when blocked, click "Bypass protection"
# Requires justification
```

---

## Task 3.5: Configure GitHub Environments for Deployment Control

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-35-configure-github-environments-for-deployment-control)**

### Solution Overview

Complete GitHub Environments setup with protection rules, required reviewers, environment secrets management, deployment branches, and wait timers for controlled deployments across dev, staging, and production environments.

### Step 1: Create GitHub Environments via UI

**Note:** Environments must be created via GitHub UI (Settings → Environments). Below are the configurations for each environment.

#### Development Environment

1. Go to **Settings** → **Environments** → **New environment**
2. Name: `development`
3. Configure:

```yaml
Deployment branches:
  ✅ All branches
  
Wait timer:
  ⬜ Not configured (immediate deployment)
  
Required reviewers:
  ⬜ Not required (auto-deploy)
  
Environment secrets:
  - DEV_DATABASE_URL: postgres://dev-db.example.com:5432/devdb
  - DEV_API_KEY: dev_key_xxxxx
  - DEV_AWS_ROLE_ARN: arn:aws:iam::111111111111:role/dev-deployer
  
Environment variables:
  - NODE_ENV: development
  - LOG_LEVEL: debug
  - DEPLOY_REGION: us-east-1
```

#### Staging Environment

1. **Settings** → **Environments** → **New environment**
2. Name: `staging`
3. Configure:

```yaml
Deployment branches:
  ✅ Selected branches
  - develop
  - release/*
  
Wait timer:
  ✅ 5 minutes (allow time for health checks)
  
Required reviewers:
  ✅ Required
  Reviewers: @qa-lead, @tech-lead (1 required)
  
Environment secrets:
  - STAGING_DATABASE_URL: postgres://staging-db.example.com:5432/stagingdb
  - STAGING_API_KEY: staging_key_xxxxx
  - STAGING_AWS_ROLE_ARN: arn:aws:iam::222222222222:role/staging-deployer
  - DATADOG_API_KEY: xxxxx
  
Environment variables:
  - NODE_ENV: staging
  - LOG_LEVEL: info
  - DEPLOY_REGION: us-east-1
  - ENABLE_FEATURE_FLAGS: true
```

#### Production Environment

1. **Settings** → **Environments** → **New environment**
2. Name: `production`
3. Configure:

```yaml
Deployment branches:
  ✅ Protected branches only
  - main
  
Wait timer:
  ✅ 10 minutes (final safety check)
  
Required reviewers:
  ✅ Required
  Reviewers: @senior-engineer, @devops-lead, @tech-lead (2 required)
  Prevent self-review: ✅ Yes
  
Environment secrets:
  - PROD_DATABASE_URL: postgres://prod-db.example.com:5432/proddb
  - PROD_API_KEY: prod_key_xxxxx
  - PROD_AWS_ROLE_ARN: arn:aws:iam::333333333333:role/prod-deployer
  - DATADOG_API_KEY: xxxxx
  - SENTRY_DSN: https://xxxxx@sentry.io/xxxxx
  - STRIPE_API_KEY: sk_live_xxxxx
  
Environment variables:
  - NODE_ENV: production
  - LOG_LEVEL: warn
  - DEPLOY_REGION: us-east-1
  - ENABLE_FEATURE_FLAGS: false
  - CACHE_ENABLED: true
```

### Step 2: Create Deployment Workflows Using Environments

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Application

on:
  push:
    branches:
      - main
      - develop
  pull_request:
    branches:
      - main
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        type: choice
        options:
          - development
          - staging
          - production

jobs:
  determine-environment:
    name: Determine Deployment Environment
    runs-on: ubuntu-latest
    outputs:
      environment: ${{ steps.set-env.outputs.environment }}
    
    steps:
      - name: Set environment based on branch
        id: set-env
        run: |
          if [ "${{ github.event_name }}" == "workflow_dispatch" ]; then
            echo "environment=${{ github.event.inputs.environment }}" >> $GITHUB_OUTPUT
          elif [ "${{ github.ref }}" == "refs/heads/main" ]; then
            echo "environment=production" >> $GITHUB_OUTPUT
          elif [ "${{ github.ref }}" == "refs/heads/develop" ]; then
            echo "environment=staging" >> $GITHUB_OUTPUT
          else
            echo "environment=development" >> $GITHUB_OUTPUT
          fi

  build:
    name: Build Application
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Build application
        run: npm run build
      
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-artifacts
          path: dist/
          retention-days: 7

  deploy-dev:
    name: Deploy to Development
    needs: [determine-environment, build]
    if: needs.determine-environment.outputs.environment == 'development'
    runs-on: ubuntu-latest
    environment:
      name: development
      url: https://dev.example.com
    
    steps:
      - name: Download artifacts
        uses: actions/download-artifact@v3
        with:
          name: build-artifacts
      
      - name: Deploy to Development
        run: |
          echo "Deploying to Development..."
          echo "Database: ${{ secrets.DEV_DATABASE_URL }}"
          echo "Region: ${{ vars.DEPLOY_REGION }}"
          # Add your deployment commands here
          # aws s3 sync dist/ s3://dev-bucket/
          # kubectl apply -f k8s/dev/
      
      - name: Run smoke tests
        run: |
          echo "Running smoke tests..."
          curl -f https://dev.example.com/health || exit 1
      
      - name: Notify deployment
        run: |
          echo "✅ Successfully deployed to Development"

  deploy-staging:
    name: Deploy to Staging
    needs: [determine-environment, build]
    if: needs.determine-environment.outputs.environment == 'staging'
    runs-on: ubuntu-latest
    environment:
      name: staging
      url: https://staging.example.com
    
    steps:
      - name: Download artifacts
        uses: actions/download-artifact@v3
        with:
          name: build-artifacts
      
      - name: Deploy to Staging
        run: |
          echo "Deploying to Staging..."
          echo "Database: ${{ secrets.STAGING_DATABASE_URL }}"
          echo "Region: ${{ vars.DEPLOY_REGION }}"
          # Add your deployment commands here
      
      - name: Wait for deployment stabilization
        run: sleep 30
      
      - name: Run integration tests
        run: |
          echo "Running integration tests..."
          curl -f https://staging.example.com/health || exit 1
      
      - name: Notify QA team
        run: |
          echo "✅ Staging deployed - Ready for QA testing"

  deploy-prod:
    name: Deploy to Production
    needs: [determine-environment, build]
    if: needs.determine-environment.outputs.environment == 'production'
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://example.com
    
    steps:
      - name: Download artifacts
        uses: actions/download-artifact@v3
        with:
          name: build-artifacts
      
      - name: Pre-deployment checks
        run: |
          echo "Running pre-deployment checks..."
          # Check if staging is healthy
          # curl -f https://staging.example.com/health
      
      - name: Create deployment backup
        run: |
          echo "Creating backup..."
          # aws s3 sync s3://prod-bucket/ s3://prod-backup-$(date +%Y%m%d%H%M%S)/
      
      - name: Deploy to Production
        run: |
          echo "Deploying to Production..."
          echo "Database: ${{ secrets.PROD_DATABASE_URL }}"
          echo "Region: ${{ vars.DEPLOY_REGION }}"
          # Add your deployment commands here
      
      - name: Wait for deployment stabilization
        run: sleep 60
      
      - name: Run health checks
        run: |
          echo "Running production health checks..."
          curl -f https://example.com/health || exit 1
          curl -f https://example.com/api/status || exit 1
      
      - name: Notify success
        if: success()
        run: |
          echo "🚀 Successfully deployed to Production!"
          # Send Slack/email notification
      
      - name: Rollback on failure
        if: failure()
        run: |
          echo "❌ Deployment failed - initiating rollback"
          # Add rollback commands here
```

### Step 3: Create Environment-Specific Configuration Script

Create `.github/scripts/setup-environments.sh`:

```bash
#!/bin/bash
# Script to document environment setup
# Note: Environments must be created via GitHub UI

cat <<'EOF'
# GitHub Environments Setup Guide

## Step-by-Step Setup

### 1. Create Development Environment

1. Go to: Settings → Environments → New environment
2. Name: development
3. Configuration:
   - Deployment branches: All branches
   - Wait timer: None
   - Required reviewers: None
   
4. Add Secrets:
   - DEV_DATABASE_URL
   - DEV_API_KEY
   - DEV_AWS_ROLE_ARN

5. Add Variables:
   - NODE_ENV=development
   - LOG_LEVEL=debug
   - DEPLOY_REGION=us-east-1

### 2. Create Staging Environment

1. Go to: Settings → Environments → New environment
2. Name: staging
3. Configuration:
   - Deployment branches: develop, release/*
   - Wait timer: 5 minutes
   - Required reviewers: @qa-lead, @tech-lead (1 required)
   
4. Add Secrets:
   - STAGING_DATABASE_URL
   - STAGING_API_KEY
   - STAGING_AWS_ROLE_ARN

5. Add Variables:
   - NODE_ENV=staging
   - LOG_LEVEL=info
   - DEPLOY_REGION=us-east-1

### 3. Create Production Environment

1. Go to: Settings → Environments → New environment
2. Name: production
3. Configuration:
   - Deployment branches: main (protected branches only)
   - Wait timer: 10 minutes
   - Required reviewers: @senior-engineer, @devops-lead (2 required)
   - Prevent self-review: Yes
   
4. Add Secrets:
   - PROD_DATABASE_URL
   - PROD_API_KEY
   - PROD_AWS_ROLE_ARN
   - STRIPE_API_KEY
   - SENTRY_DSN

5. Add Variables:
   - NODE_ENV=production
   - LOG_LEVEL=warn
   - DEPLOY_REGION=us-east-1

EOF
```

Make executable:
```bash
chmod +x .github/scripts/setup-environments.sh
```

### Step 4: Create Environment Documentation

Create `docs/DEPLOYMENT_ENVIRONMENTS.md`:

```markdown
# Deployment Environments

## Overview

We use three deployment environments with different protection levels:

| Environment | Branch | Approval Required | Wait Timer | URL |
|-------------|--------|-------------------|------------|-----|
| **Development** | Any | No | None | https://dev.example.com |
| **Staging** | develop, release/* | 1 (QA/Tech Lead) | 5 min | https://staging.example.com |
| **Production** | main | 2 (Senior/DevOps Lead) | 10 min | https://example.com |

## Deployment Process

### To Development

```bash
# Automatic on any branch push
git push origin feature/my-feature

# Or manual trigger
# Actions → Deploy Application → Run workflow → Select: development
```

### To Staging

```bash
# 1. Merge to develop
git checkout develop
git pull origin develop
git merge feature/my-feature
git push origin develop

# 2. Wait for deployment workflow
# 3. QA Lead or Tech Lead reviews and approves
# 4. Wait 5 minutes (health check period)
# 5. Deployment proceeds automatically
```

### To Production

```bash
# 1. Merge to main (via PR)
git checkout main
git pull origin main
git merge develop
git push origin main

# 2. Wait for deployment workflow
# 3. Two approvals required (Senior + DevOps Lead)
# 4. Wait 10 minutes (final safety check)
# 5. Deployment proceeds automatically
# 6. Monitor production metrics
```

## Environment Variables

### Development
- `NODE_ENV`: development
- `LOG_LEVEL`: debug
- `DEPLOY_REGION`: us-east-1

### Staging
- `NODE_ENV`: staging
- `LOG_LEVEL`: info
- `DEPLOY_REGION`: us-east-1
- `ENABLE_FEATURE_FLAGS`: true

### Production
- `NODE_ENV`: production
- `LOG_LEVEL`: warn
- `DEPLOY_REGION`: us-east-1
- `ENABLE_FEATURE_FLAGS`: false
- `CACHE_ENABLED`: true

## Secrets Management

**Never commit secrets to the repository!**

### Adding Secrets

1. Go to: Settings → Environments → [Environment Name]
2. Click "Add secret"
3. Enter name and value
4. Click "Add secret"

### Using Secrets in Workflows

```yaml
- name: Use secret
  run: echo "Database: ${{ secrets.PROD_DATABASE_URL }}"
  env:
    API_KEY: ${{ secrets.PROD_API_KEY }}
```

## Troubleshooting

### Deployment Stuck "Waiting"

**Cause:** Missing approvals or wait timer
**Solution:** 
- Check required reviewers have approved
- Wait for timer to complete
- Check deployment history for details

### Secret Not Found

**Cause:** Secret not set for environment
**Solution:**
- Verify secret name matches exactly
- Check secret is set in correct environment
- Ensure environment name in workflow matches

### Unauthorized Deployment

**Cause:** Branch not allowed for environment
**Solution:**
- Check deployment branch rules
- Ensure deploying from allowed branch
- Update branch protection if needed

## Monitoring

### Deployment History

View: `https://github.com/ORG/REPO/deployments`

### Environment Status

View: `https://github.com/ORG/REPO/environments`

### Logs

View: Actions → Deploy Application → Latest run
```

### Verification Steps

```bash
# 1. Verify environments exist
# Go to: Settings → Environments
# Should see: development, staging, production

# 2. Test development deployment
git checkout -b test-env-dev
echo "test" >> README.md
git add README.md
git commit -m "test: dev deployment"
git push origin test-env-dev
# Check Actions tab - should deploy to dev automatically

# 3. Test staging deployment with approval
git checkout develop
git merge test-env-dev
git push origin develop
# Check Actions tab - should require QA/Tech lead approval

# 4. Test production deployment
# Create PR from develop to main
# Merge PR
# Check Actions tab - should require 2 approvals + 10 min wait

# 5. Verify environment secrets accessible
# Check workflow logs (secrets should be masked)
# Verify application can access secrets

# 6. Test wait timers
# Deploy to staging - should wait 5 minutes
# Deploy to production - should wait 10 minutes
```

### Best Practices Implemented

- ✅ **Three-Tier Environments**: Dev, Staging, Production with increasing protection
- ✅ **Branch-Based Deployment**: Automatic environment selection based on branch
- ✅ **Required Approvals**: 0 for dev, 1 for staging, 2 for production
- ✅ **Wait Timers**: Safety delays before deployment (5 min staging, 10 min prod)
- ✅ **Environment Secrets**: Isolated secrets per environment
- ✅ **Environment Variables**: Environment-specific configuration
- ✅ **Deployment Branches**: Restricted branches per environment
- ✅ **Manual Triggers**: Ability to deploy to any environment manually
- ✅ **Health Checks**: Post-deployment validation
- ✅ **Comprehensive Documentation**: Clear deployment procedures

### Troubleshooting

**Issue 1: Environment Not Appearing in Workflow**
```bash
# Ensure environment exists: Settings → Environments
# Check workflow syntax uses correct environment name:
environment:
  name: production  # Must match exactly
  url: https://example.com
```

**Issue 2: Deployment Not Requiring Approval**
```bash
# Verify reviewers are configured:
# Settings → Environments → [Environment] → Required reviewers
# Must have at least 1 reviewer for approval requirement

# Check user has permission to approve:
# User must have write or admin access to repository
```

**Issue 3: Cannot Access Environment Secrets**
```bash
# Verify secret exists in correct environment:
# Settings → Environments → [Environment] → Secrets

# Check workflow is using correct environment:
environment:
  name: production  # Must match environment name

# Verify secret name in workflow matches exactly:
${{ secrets.PROD_API_KEY }}  # Case-sensitive
```

**Issue 4: Wait Timer Not Working**
```bash
# Wait timer only applies after approval
# If no approval required, deployment proceeds immediately
# To add delay without approval, use workflow sleep:
- name: Wait
  run: sleep 300  # 5 minutes
```

---

## Task 3.6: GitHub Actions CI/CD Pipeline Setup

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-36-github-actions-cicd-pipeline-setup)**

### Solution Overview

Complete CI/CD pipeline implementation using GitHub Actions with automated testing, building, Docker image creation, artifact management, and multi-environment deployment with approval gates.

### Step 1: Create PR Validation Workflow

Create `.github/workflows/pr-validation.yml`:

```yaml
name: PR Validation

on:
  pull_request:
    branches: [ main, develop ]
    types: [ opened, synchronize, reopened ]

jobs:
  lint:
    name: Lint Code
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run ESLint
        run: npm run lint
      
      - name: Run Prettier
        run: npm run format:check

  test:
    name: Run Tests
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16, 18, 20]
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run unit tests
        run: npm test -- --coverage
      
      - name: Upload coverage
        if: matrix.node-version == '18'
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json
          flags: unittests

  security:
    name: Security Scan
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run npm audit
        run: npm audit --audit-level=high
      
      - name: Run Snyk scan
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high

  build-test:
    name: Test Build
    runs-on: ubuntu-latest
    needs: [lint, test]
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build application
        run: npm run build
      
      - name: Verify build artifacts
        run: |
          if [ ! -d "dist" ]; then
            echo "Build failed: dist directory not found"
            exit 1
          fi
```

### Step 2: Create Build and Push Workflow

Create `.github/workflows/build-push.yml`:

```yaml
name: Build and Push

on:
  push:
    branches: [ main, develop ]
    tags: [ 'v*' ]

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
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Log in to Container Registry
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha,prefix={{branch}}-
      
      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
          build-args: |
            BUILD_DATE=${{ github.event.head_commit.timestamp }}
            VCS_REF=${{ github.sha }}
            VERSION=${{ steps.meta.outputs.version }}
      
      - name: Generate SBOM
        uses: anchore/sbom-action@v0
        with:
          image: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ steps.meta.outputs.version }}
          format: spdx-json
          output-file: sbom.spdx.json
      
      - name: Upload SBOM
        uses: actions/upload-artifact@v3
        with:
          name: sbom
          path: sbom.spdx.json
```

### Step 3: Create Deployment Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Application

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        type: choice
        options:
          - development
          - staging
          - production
      version:
        description: 'Docker image tag to deploy'
        required: true
        type: string

jobs:
  deploy-dev:
    if: github.event.inputs.environment == 'development'
    runs-on: ubuntu-latest
    environment:
      name: development
      url: https://dev.example.com
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: ${{ secrets.DEV_AWS_ROLE_ARN }}
          aws-region: us-east-1
      
      - name: Deploy to ECS
        run: |
          aws ecs update-service \
            --cluster dev-cluster \
            --service app-service \
            --force-new-deployment \
            --region us-east-1
      
      - name: Wait for deployment
        run: |
          aws ecs wait services-stable \
            --cluster dev-cluster \
            --services app-service \
            --region us-east-1
      
      - name: Run smoke tests
        run: |
          sleep 30
          curl -f https://dev.example.com/health || exit 1
      
      - name: Notify Slack
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "Deployed ${{ github.event.inputs.version }} to development",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "✅ *Deployment Successful*\n*Environment:* development\n*Version:* ${{ github.event.inputs.version }}\n*URL:* https://dev.example.com"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}

  deploy-staging:
    if: github.event.inputs.environment == 'staging'
    runs-on: ubuntu-latest
    environment:
      name: staging
      url: https://staging.example.com
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: ${{ secrets.STAGING_AWS_ROLE_ARN }}
          aws-region: us-east-1
      
      - name: Deploy to ECS
        run: |
          aws ecs update-service \
            --cluster staging-cluster \
            --service app-service \
            --force-new-deployment \
            --region us-east-1
      
      - name: Wait for deployment
        run: |
          aws ecs wait services-stable \
            --cluster staging-cluster \
            --services app-service \
            --region us-east-1
      
      - name: Run integration tests
        run: |
          npm ci
          npm run test:integration
        env:
          API_URL: https://staging.example.com
      
      - name: Run performance tests
        run: |
          npx artillery run tests/load-test.yml --target https://staging.example.com
      
      - name: Notify Slack
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "Deployed ${{ github.event.inputs.version }} to staging",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "✅ *Deployment Successful*\n*Environment:* staging\n*Version:* ${{ github.event.inputs.version }}\n*URL:* https://staging.example.com"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}

  deploy-production:
    if: github.event.inputs.environment == 'production'
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://example.com
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: ${{ secrets.PROD_AWS_ROLE_ARN }}
          aws-region: us-east-1
      
      - name: Create deployment record
        run: |
          echo "Deploying version ${{ github.event.inputs.version }} to production"
          echo "Deployment started at $(date)" >> deployment.log
      
      - name: Blue-Green Deployment
        run: |
          # Deploy to green environment first
          aws ecs update-service \
            --cluster prod-cluster \
            --service app-service-green \
            --force-new-deployment \
            --region us-east-1
          
          # Wait for green deployment
          aws ecs wait services-stable \
            --cluster prod-cluster \
            --services app-service-green \
            --region us-east-1
      
      - name: Run smoke tests on green
        run: |
          sleep 60
          curl -f https://green.example.com/health || exit 1
          curl -f https://green.example.com/api/status || exit 1
      
      - name: Switch traffic to green
        run: |
          # Update load balancer to point to green
          aws elbv2 modify-rule \
            --rule-arn ${{ secrets.ALB_RULE_ARN }} \
            --actions Type=forward,TargetGroupArn=${{ secrets.GREEN_TARGET_GROUP_ARN }}
      
      - name: Monitor for 5 minutes
        run: |
          for i in {1..10}; do
            sleep 30
            curl -f https://example.com/health || exit 1
          done
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: deployment-logs
          path: deployment.log
      
      - name: Notify Slack
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "🚀 Production Deployment Complete",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "✅ *Production Deployment Successful*\n*Version:* ${{ github.event.inputs.version }}\n*Deployed by:* ${{ github.actor }}\n*Time:* $(date)\n*URL:* https://example.com"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

### Step 4: Add Status Badges to README

Update `README.md`:

```markdown
# My Application

![Build Status](https://github.com/org/repo/workflows/PR%20Validation/badge.svg)
![Deployment](https://github.com/org/repo/workflows/Deploy%20Application/badge.svg)
![Security](https://github.com/org/repo/workflows/Security%20Scan/badge.svg)
[![codecov](https://codecov.io/gh/org/repo/branch/main/graph/badge.svg)](https://codecov.io/gh/org/repo)

## CI/CD Pipeline

Our CI/CD pipeline includes:
- ✅ Automated linting and code formatting checks
- ✅ Unit tests across multiple Node versions
- ✅ Security vulnerability scanning
- ✅ Docker image building and pushing
- ✅ Automated deployments to dev/staging/production
- ✅ Blue-green deployment strategy for zero-downtime

### Pipeline Stages

1. **PR Validation**: Runs on every pull request
   - Code linting and formatting
   - Unit tests
   - Security scans
   - Build verification

2. **Build & Push**: Runs on merge to main/develop
   - Docker image creation
   - Multi-platform builds
   - Image tagging and versioning
   - SBOM generation

3. **Deployment**: Manual trigger with approvals
   - Development: Auto-deploy
   - Staging: QA approval required
   - Production: Multi-approval required + blue-green deployment
```

### Step 5: Configure Secrets

Add these secrets in GitHub Settings → Secrets and variables → Actions:

```bash
# AWS Credentials
DEV_AWS_ROLE_ARN: arn:aws:iam::111111111111:role/dev-deployer
STAGING_AWS_ROLE_ARN: arn:aws:iam::222222222222:role/staging-deployer
PROD_AWS_ROLE_ARN: arn:aws:iam::333333333333:role/prod-deployer

# Application Secrets
SNYK_TOKEN: <snyk-token>
CODECOV_TOKEN: <codecov-token>
SLACK_WEBHOOK: https://hooks.slack.com/services/xxx

# Production Specific
ALB_RULE_ARN: arn:aws:elasticloadbalancing:us-east-1:xxx
GREEN_TARGET_GROUP_ARN: arn:aws:elasticloadbalancing:us-east-1:xxx
```

### Verification

```bash
# Test PR workflow
git checkout -b test/ci-pipeline
git push origin test/ci-pipeline
gh pr create --title "Test CI pipeline"
# Check workflow runs

# Test build workflow
git checkout main
git tag v1.0.0
git push origin v1.0.0
# Verify Docker image pushed

# Test deployment
gh workflow run deploy.yml \
  -f environment=development \
  -f version=v1.0.0
# Check deployment status
```

### Interview Questions

**Q: How do you optimize GitHub Actions workflows for speed?**

**A: Key optimization strategies:**

1. **Caching Dependencies**:
```yaml
- uses: actions/setup-node@v3
  with:
    node-version: '18'
    cache: 'npm'  # Caches node_modules
```

2. **Docker Layer Caching**:
```yaml
- uses: docker/build-push-action@v4
  with:
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

3. **Parallel Jobs**:
```yaml
strategy:
  matrix:
    node-version: [16, 18, 20]  # Runs in parallel
```

4. **Conditional Execution**:
```yaml
if: github.event_name == 'push' && github.ref == 'refs/heads/main'
```

5. **Artifacts for Inter-Job Communication**:
```yaml
- uses: actions/upload-artifact@v3
  with:
    name: build
    path: dist/
```

**Q: How do you implement blue-green deployment in GitHub Actions?**

**A: Blue-green deployment strategy:**

1. Deploy to inactive environment (green)
2. Run tests on green
3. Switch traffic from blue to green
4. Keep blue as fallback
5. Monitor green
6. If issues, switch back to blue

```yaml
- name: Deploy to Green
  run: |
    aws ecs update-service \
      --cluster prod \
      --service app-green \
      --force-new-deployment

- name: Test Green
  run: |
    curl -f https://green.example.com/health

- name: Switch Traffic
  run: |
    aws elbv2 modify-rule \
      --rule-arn $RULE_ARN \
      --actions Type=forward,TargetGroupArn=$GREEN_TG

- name: Rollback if needed
  if: failure()
  run: |
    aws elbv2 modify-rule \
      --rule-arn $RULE_ARN \
      --actions Type=forward,TargetGroupArn=$BLUE_TG
```

---

## Task 3.7: Monorepo vs Polyrepo Strategy Implementation

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-37-monorepo-vs-polyrepo-strategy-implementation)**

### Solution Overview

Implementation of both monorepo and polyrepo strategies with tools (Lerna/Nx), dependency management, CI/CD pipelines, and comprehensive comparison for informed decision-making.

### Part A: Monorepo Implementation

#### Step 1: Set Up Monorepo Structure

```bash
# Initialize monorepo
mkdir myapp-monorepo
cd myapp-monorepo
git init

# Initialize package.json
npm init -y

# Install Lerna
npm install --save-dev lerna

# Initialize Lerna
npx lerna init

# Create workspace structure
mkdir -p packages/{frontend,backend,shared}
```

#### Step 2: Configure Lerna and Workspaces

Update `package.json`:

```json
{
  "name": "myapp-monorepo",
  "private": true,
  "workspaces": [
    "packages/*"
  ],
  "scripts": {
    "build": "lerna run build",
    "test": "lerna run test",
    "lint": "lerna run lint",
    "clean": "lerna clean",
    "bootstrap": "lerna bootstrap",
    "version": "lerna version",
    "publish": "lerna publish"
  },
  "devDependencies": {
    "lerna": "^7.0.0"
  }
}
```

Update `lerna.json`:

```json
{
  "version": "independent",
  "npmClient": "npm",
  "command": {
    "publish": {
      "conventionalCommits": true,
      "message": "chore(release): publish"
    },
    "version": {
      "allowBranch": ["main", "develop"],
      "message": "chore(release): %s"
    }
  },
  "packages": [
    "packages/*"
  ]
}
```

#### Step 3: Create Package Structure

**Frontend Package** (`packages/frontend/package.json`):

```json
{
  "name": "@myapp/frontend",
  "version": "1.0.0",
  "main": "dist/index.js",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "test": "vitest",
    "lint": "eslint src"
  },
  "dependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "@myapp/shared": "^1.0.0"
  },
  "devDependencies": {
    "vite": "^4.0.0",
    "vitest": "^0.34.0"
  }
}
```

**Backend Package** (`packages/backend/package.json`):

```json
{
  "name": "@myapp/backend",
  "version": "1.0.0",
  "main": "dist/index.js",
  "scripts": {
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "test": "jest",
    "lint": "eslint src"
  },
  "dependencies": {
    "express": "^4.18.0",
    "@myapp/shared": "^1.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "jest": "^29.0.0"
  }
}
```

**Shared Package** (`packages/shared/package.json`):

```json
{
  "name": "@myapp/shared",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "test": "jest"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "jest": "^29.0.0"
  }
}
```

#### Step 4: CI/CD for Monorepo

Create `.github/workflows/monorepo-ci.yml`:

```yaml
name: Monorepo CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  changes:
    runs-on: ubuntu-latest
    outputs:
      frontend: ${{ steps.changes.outputs.frontend }}
      backend: ${{ steps.changes.outputs.backend }}
      shared: ${{ steps.changes.outputs.shared }}
    steps:
      - uses: actions/checkout@v3
      
      - uses: dorny/paths-filter@v2
        id: changes
        with:
          filters: |
            frontend:
              - 'packages/frontend/**'
            backend:
              - 'packages/backend/**'
            shared:
              - 'packages/shared/**'

  build-frontend:
    needs: changes
    if: needs.changes.outputs.frontend == 'true' || needs.changes.outputs.shared == 'true'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build shared package
        run: npm run build --workspace=@myapp/shared
      
      - name: Build frontend
        run: npm run build --workspace=@myapp/frontend
      
      - name: Test frontend
        run: npm run test --workspace=@myapp/frontend

  build-backend:
    needs: changes
    if: needs.changes.outputs.backend == 'true' || needs.changes.outputs.shared == 'true'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build shared package
        run: npm run build --workspace=@myapp/shared
      
      - name: Build backend
        run: npm run build --workspace=@myapp/backend
      
      - name: Test backend
        run: npm run test --workspace=@myapp/backend
```

### Part B: Polyrepo Implementation

#### Step 1: Create Separate Repositories

```bash
# Create repositories
gh repo create myapp-frontend --public
gh repo create myapp-backend --public
gh repo create myapp-shared-lib --public

# Clone repositories
mkdir polyrepo-workspace
cd polyrepo-workspace
git clone git@github.com:org/myapp-frontend.git
git clone git@github.com:org/myapp-backend.git
git clone git@github.com:org/myapp-shared-lib.git
```

#### Step 2: Set Up Shared Library for Publishing

**myapp-shared-lib/package.json**:

```json
{
  "name": "@myapp/shared-lib",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "files": ["dist"],
  "scripts": {
    "build": "tsc",
    "test": "jest",
    "prepublishOnly": "npm run build && npm test"
  },
  "publishConfig": {
    "access": "public"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/org/myapp-shared-lib.git"
  }
}
```

**Publishing Workflow** (`.github/workflows/publish.yml`):

```yaml
name: Publish to npm

on:
  release:
    types: [published]

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
          registry-url: 'https://registry.npmjs.org'
      
      - run: npm ci
      - run: npm run build
      - run: npm test
      
      - run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

#### Step 3: Consume Shared Library

**myapp-frontend/package.json**:

```json
{
  "name": "myapp-frontend",
  "version": "1.0.0",
  "dependencies": {
    "react": "^18.0.0",
    "@myapp/shared-lib": "^1.0.0"
  }
}
```

**myapp-backend/package.json**:

```json
{
  "name": "myapp-backend",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0",
    "@myapp/shared-lib": "^1.0.0"
  }
}
```

#### Step 4: Automated Dependency Updates

Create `.github/dependabot.yml` in each repo:

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    groups:
      myapp-packages:
        patterns:
          - "@myapp/*"
    labels:
      - "dependencies"
    reviewers:
      - "team/frontend-team"
```

### Part C: Comparison and Recommendation

#### Comparison Table

| Aspect | Monorepo | Polyrepo |
|--------|----------|----------|
| **Code Sharing** | Direct imports, instant | Published packages, versioned |
| **Atomic Changes** | Single PR across services | Multiple PRs, coordination needed |
| **CI/CD Complexity** | High (selective builds) | Low (independent) |
| **Repository Size** | Large, grows over time | Small, focused |
| **Onboarding** | Complex, need full context | Simple, service-specific |
| **Build Time** | Can be slow without caching | Fast, isolated |
| **Tooling** | Requires Lerna/Nx/Turborepo | Standard Git tools |
| **Versioning** | Complex (Lerna) | Simple (semantic versioning) |
| **Access Control** | Coarse-grained | Fine-grained |
| **Team Independence** | Lower (shared codebase) | Higher (isolated repos) |

#### Recommendation Document

**When to Use Monorepo:**
- Single product with tight coupling
- Small to medium team (< 50 developers)
- Frequent cross-service changes
- Need atomic commits
- Shared infrastructure/tooling

**When to Use Polyrepo:**
- Multiple products/services
- Large organization (> 50 developers)
- Independent service lifecycles
- Different tech stacks
- Clear service boundaries

**Hybrid Approach:**
- Monorepo per team/domain
- Polyrepo at organization level
- Shared libraries published as packages

### Verification

```bash
# Test monorepo
cd myapp-monorepo
npm install
npm run build
npm run test

# Verify dependency resolution
cd packages/frontend
npm ls @myapp/shared

# Test polyrepo
cd polyrepo-workspace/myapp-shared-lib
npm version patch
npm publish

cd ../myapp-frontend
npm update @myapp/shared-lib
npm test
```

### Interview Questions

**Q: How do you handle versioning in a monorepo?**

**A: Two main approaches:**

1. **Fixed Versioning**: All packages same version
```bash
lerna version --conventional-commits
# All packages bump to same version
```

2. **Independent Versioning**: Each package has own version
```json
// lerna.json
{
  "version": "independent"
}
```

Then:
```bash
lerna version --conventional-commits
# Each package versions independently based on changes
```

**Best Practice**: Use independent versioning for loosely coupled packages, fixed for tightly coupled.

**Q: How do you optimize CI/CD for large monorepos?**

**A: Key strategies:**

1. **Affected Detection**: Only build/test changed packages
2. **Build Caching**: Cache build artifacts
3. **Remote Caching**: Share cache across machines (Nx Cloud)
4. **Parallel Execution**: Run independent tasks in parallel
5. **Incremental Builds**: Only rebuild what changed

Example with Nx:
```bash
nx affected:build --base=main
nx affected:test --base=main --parallel=3
```

---

## Task 3.8: GitHub Projects for Agile Workflow

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-38-github-projects-for-agile-workflow)**

### Solution Overview

Complete GitHub Projects implementation for agile workflow management, including project boards, automation, issue templates, sprint milestones, and custom views for different stakeholders.

### Step 1: Create GitHub Project Board

#### Using GitHub Projects (Beta - recommended)

```bash
# Navigate to your repository on GitHub
# Go to Projects tab → New Project → Select "Team backlog" template
# Or create from scratch
```

**Manual Setup via UI:**

1. Go to your repository → **Projects** tab
2. Click **New project**
3. Select **Board** view
4. Name: `Sprint Planning Board`
5. Description: `Agile workflow management for the team`

**Configure Project Fields:**

Add custom fields:
- **Status**: Todo, In Progress, In Review, Done
- **Priority**: P0-Critical, P1-High, P2-Medium, P3-Low
- **Story Points**: Number (1, 2, 3, 5, 8, 13)
- **Sprint**: Text (Sprint 1, Sprint 2, etc.)
- **Assignee**: Person
- **Labels**: Multiple select

### Step 2: Create Issue Templates

Create `.github/ISSUE_TEMPLATE/` directory with templates:

**User Story Template (`.github/ISSUE_TEMPLATE/user-story.yml`):**

```yaml
name: 🎯 User Story
description: Create a user story for new feature
title: "[STORY]: "
labels: ["story", "needs-triage"]
assignees:
  - product-owner
body:
  - type: markdown
    attributes:
      value: |
        ## User Story Template
        Please fill out the information below to create a user story.
  
  - type: textarea
    id: user-story
    attributes:
      label: User Story
      description: As a [type of user], I want [goal] so that [reason]
      placeholder: |
        As a registered user,
        I want to reset my password via email,
        So that I can regain access to my account if I forget my password.
    validations:
      required: true
  
  - type: textarea
    id: acceptance-criteria
    attributes:
      label: Acceptance Criteria
      description: Define what "done" means for this story
      placeholder: |
        - [ ] User can request password reset from login page
        - [ ] Email is sent with reset link
        - [ ] Link expires after 24 hours
        - [ ] User can set new password
        - [ ] User is logged in after successful reset
    validations:
      required: true
  
  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - P0 - Critical
        - P1 - High
        - P2 - Medium
        - P3 - Low
    validations:
      required: true
  
  - type: dropdown
    id: story-points
    attributes:
      label: Story Points
      options:
        - "1"
        - "2"
        - "3"
        - "5"
        - "8"
        - "13"
    validations:
      required: true
  
  - type: textarea
    id: technical-notes
    attributes:
      label: Technical Notes
      description: Any technical considerations or constraints
      placeholder: |
        - Use SendGrid for email delivery
        - Store reset tokens in Redis with TTL
        - Follow OWASP password guidelines
  
  - type: textarea
    id: dependencies
    attributes:
      label: Dependencies
      description: Other stories or tasks that must be completed first
      placeholder: |
        - Depends on #123 (Email service setup)
        - Blocked by infrastructure team for Redis setup
```

**Bug Report Template (`.github/ISSUE_TEMPLATE/bug-report.yml`):**

```yaml
name: 🐛 Bug Report
description: Report a bug or issue
title: "[BUG]: "
labels: ["bug", "needs-triage"]
assignees:
  - qa-lead
body:
  - type: markdown
    attributes:
      value: |
        ## Bug Report
        Thanks for taking the time to report this bug!
  
  - type: textarea
    id: description
    attributes:
      label: Bug Description
      description: A clear and concise description of the bug
      placeholder: What happened?
    validations:
      required: true
  
  - type: textarea
    id: steps
    attributes:
      label: Steps to Reproduce
      description: Steps to reproduce the behavior
      placeholder: |
        1. Go to '...'
        2. Click on '...'
        3. Scroll down to '...'
        4. See error
    validations:
      required: true
  
  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What should happen?
    validations:
      required: true
  
  - type: textarea
    id: actual
    attributes:
      label: Actual Behavior
      description: What actually happened?
    validations:
      required: true
  
  - type: dropdown
    id: severity
    attributes:
      label: Severity
      options:
        - Critical - System down
        - High - Major feature broken
        - Medium - Feature partially working
        - Low - Minor issue
    validations:
      required: true
  
  - type: input
    id: environment
    attributes:
      label: Environment
      placeholder: "Production, Staging, Development"
    validations:
      required: true
  
  - type: textarea
    id: logs
    attributes:
      label: Error Logs
      description: Paste any relevant error logs
      render: shell
  
  - type: textarea
    id: screenshots
    attributes:
      label: Screenshots
      description: Add screenshots if applicable
```

**Task Template (`.github/ISSUE_TEMPLATE/task.yml`):**

```yaml
name: ✅ Task
description: Create a technical task
title: "[TASK]: "
labels: ["task"]
body:
  - type: textarea
    id: description
    attributes:
      label: Task Description
      description: What needs to be done?
    validations:
      required: true
  
  - type: textarea
    id: subtasks
    attributes:
      label: Subtasks
      description: Break down the task
      placeholder: |
        - [ ] Subtask 1
        - [ ] Subtask 2
        - [ ] Subtask 3
    validations:
      required: true
  
  - type: dropdown
    id: task-type
    attributes:
      label: Task Type
      options:
        - Development
        - Testing
        - Documentation
        - DevOps
        - Research
    validations:
      required: true
  
  - type: dropdown
    id: story-points
    attributes:
      label: Effort (Story Points)
      options:
        - "1"
        - "2"
        - "3"
        - "5"
  
  - type: textarea
    id: acceptance
    attributes:
      label: Definition of Done
      placeholder: |
        - [ ] Code complete and reviewed
        - [ ] Tests written and passing
        - [ ] Documentation updated
```

**Configuration (`.github/ISSUE_TEMPLATE/config.yml`):**

```yaml
blank_issues_enabled: false
contact_links:
  - name: 📚 Documentation
    url: https://docs.example.com
    about: Check our documentation for common questions
  - name: 💬 Community Discussions
    url: https://github.com/your-org/your-repo/discussions
    about: Ask questions and discuss with the community
  - name: 🔒 Security Issue
    url: https://github.com/your-org/your-repo/security/advisories/new
    about: Report security vulnerabilities privately
```

### Step 3: Configure Project Automation

Create `.github/workflows/project-automation.yml`:

```yaml
name: Project Automation

on:
  issues:
    types: [opened, closed, reopened, labeled]
  pull_request:
    types: [opened, closed, ready_for_review]
  issue_comment:
    types: [created]

jobs:
  auto-add-to-project:
    runs-on: ubuntu-latest
    if: github.event_name == 'issues' && github.event.action == 'opened'
    steps:
      - name: Add issue to project
        uses: actions/add-to-project@v0.5.0
        with:
          project-url: https://github.com/orgs/YOUR-ORG/projects/PROJECT-NUMBER
          github-token: ${{ secrets.PROJECT_TOKEN }}
  
  auto-assign-priority:
    runs-on: ubuntu-latest
    if: github.event_name == 'issues' && github.event.action == 'labeled'
    steps:
      - name: Set priority field based on label
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.PROJECT_TOKEN }}
          script: |
            const issue = context.payload.issue;
            const labels = issue.labels.map(l => l.name);
            
            let priority = 'P3 - Low';
            if (labels.includes('critical')) priority = 'P0 - Critical';
            else if (labels.includes('high-priority')) priority = 'P1 - High';
            else if (labels.includes('medium-priority')) priority = 'P2 - Medium';
            
            // Update project field
            // Note: This requires GraphQL API calls - see full implementation below
            console.log(`Setting priority to: ${priority}`);
  
  auto-move-in-progress:
    runs-on: ubuntu-latest
    if: github.event_name == 'issue_comment'
    steps:
      - name: Move to In Progress when commented
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.PROJECT_TOKEN }}
          script: |
            const comment = context.payload.comment.body.toLowerCase();
            const issue = context.payload.issue;
            
            // Move to "In Progress" if developer claims the issue
            if (comment.includes('/start') || comment.includes('/working')) {
              console.log('Moving issue to In Progress');
              // GraphQL mutation to update project field
            }
  
  auto-move-done:
    runs-on: ubuntu-latest
    if: github.event_name == 'issues' && github.event.action == 'closed'
    steps:
      - name: Move to Done when closed
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.PROJECT_TOKEN }}
          script: |
            const issue = context.payload.issue;
            console.log(`Moving issue #${issue.number} to Done`);
            // Update project status field to "Done"
  
  link-pr-to-issue:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request' && github.event.action == 'opened'
    steps:
      - name: Link PR to related issues
        uses: actions/github-script@v7
        with:
          script: |
            const pr = context.payload.pull_request;
            const body = pr.body || '';
            
            // Extract issue numbers from PR body
            const issueRefs = body.match(/#(\d+)/g) || [];
            
            for (const ref of issueRefs) {
              const issueNumber = ref.substring(1);
              // Link PR to issue in project
              console.log(`Linking PR #${pr.number} to issue #${issueNumber}`);
            }
```

### Step 4: Set Up Sprint Milestones

**Create Milestones via GitHub API:**

```bash
#!/bin/bash
# create-sprint-milestones.sh

REPO_OWNER="your-org"
REPO_NAME="your-repo"
GITHUB_TOKEN="your_token"

# Calculate sprint dates (2-week sprints)
SPRINT_NUMBER=1
START_DATE=$(date -d "next Monday" +%Y-%m-%d)
END_DATE=$(date -d "$START_DATE +14 days" +%Y-%m-%d)

# Create milestone
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/milestones \
  -d @- << EOF
{
  "title": "Sprint $SPRINT_NUMBER",
  "state": "open",
  "description": "Sprint $SPRINT_NUMBER: $START_DATE to $END_DATE",
  "due_on": "${END_DATE}T23:59:59Z"
}
EOF
```

**Or via GitHub UI:**

1. Go to Issues → Milestones → New milestone
2. Title: `Sprint 1`
3. Due date: End of 2-week sprint
4. Description: Sprint goals and objectives

### Step 5: Create Custom Views

**Developer View** (Focus on assigned items):
- Filter: `assignee:@me is:open`
- Sort: Priority (descending), then Story Points
- Group by: Status
- Fields: Title, Status, Priority, Story Points, Labels

**Product Owner View** (Big picture):
- Filter: `is:open`
- Sort: Priority (descending)
- Group by: Sprint
- Fields: Title, Status, Priority, Story Points, Assignee, Sprint

**QA View** (Testing focus):
- Filter: `is:open label:needs-testing,in-review`
- Sort: Priority (descending)
- Group by: Status
- Fields: Title, Status, Priority, Assignee, Labels

**Sprint Backlog View**:
- Filter: `is:open milestone:"Sprint 1"`
- Sort: Priority (descending)
- Group by: Status
- Fields: All fields

### Step 6: Set Up Reporting and Metrics

**Velocity Tracking Script (`.github/scripts/calculate-velocity.js`):**

```javascript
// calculate-velocity.js
const { Octokit } = require('@octokit/rest');

async function calculateVelocity(owner, repo, sprintMilestone) {
  const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });
  
  // Get all closed issues in the sprint
  const { data: issues } = await octokit.issues.listForRepo({
    owner,
    repo,
    milestone: sprintMilestone,
    state: 'closed'
  });
  
  // Calculate total story points
  let totalPoints = 0;
  let storiesCompleted = 0;
  
  for (const issue of issues) {
    // Extract story points from labels or issue body
    const pointsLabel = issue.labels.find(l => l.name.match(/points:\s*(\d+)/));
    if (pointsLabel) {
      const points = parseInt(pointsLabel.name.match(/\d+/)[0]);
      totalPoints += points;
      storiesCompleted++;
    }
  }
  
  console.log(`Sprint ${sprintMilestone} Metrics:`);
  console.log(`Stories Completed: ${storiesCompleted}`);
  console.log(`Total Story Points: ${totalPoints}`);
  console.log(`Average Points per Story: ${(totalPoints / storiesCompleted).toFixed(2)}`);
  
  return { storiesCompleted, totalPoints };
}

// Usage
calculateVelocity('your-org', 'your-repo', 'Sprint 1');
```

**Burndown Chart Data Export:**

```javascript
// burndown-data.js
async function generateBurndownData(owner, repo, sprintMilestone) {
  const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });
  
  // Get sprint start and end dates
  const { data: milestone } = await octokit.issues.getMilestone({
    owner,
    repo,
    milestone_number: sprintMilestone
  });
  
  const startDate = new Date(milestone.created_at);
  const endDate = new Date(milestone.due_on);
  
  // Get all issues in sprint
  const { data: issues } = await octokit.issues.listForRepo({
    owner,
    repo,
    milestone: sprintMilestone,
    state: 'all'
  });
  
  // Calculate total points
  const totalPoints = issues.reduce((sum, issue) => {
    const pointsLabel = issue.labels.find(l => l.name.match(/points:\s*(\d+)/));
    return sum + (pointsLabel ? parseInt(pointsLabel.name.match(/\d+/)[0]) : 0);
  }, 0);
  
  // Generate daily burndown data
  const burndownData = [];
  let currentDate = new Date(startDate);
  
  while (currentDate <= endDate) {
    const completedPoints = issues
      .filter(i => i.closed_at && new Date(i.closed_at) <= currentDate)
      .reduce((sum, issue) => {
        const pointsLabel = issue.labels.find(l => l.name.match(/points:\s*(\d+)/));
        return sum + (pointsLabel ? parseInt(pointsLabel.name.match(/\d+/)[0]) : 0);
      }, 0);
    
    burndownData.push({
      date: currentDate.toISOString().split('T')[0],
      remainingPoints: totalPoints - completedPoints,
      completedPoints
    });
    
    currentDate.setDate(currentDate.getDate() + 1);
  }
  
  console.log(JSON.stringify(burndownData, null, 2));
  return burndownData;
}
```

### Step 7: Documentation

Create `docs/AGILE_WORKFLOW.md`:

```markdown
# Agile Workflow Guide

## Overview
This document describes our team's agile workflow using GitHub Projects.

## Sprint Cycle

### Sprint Duration: 2 weeks

**Week 1:**
- Monday: Sprint Planning
- Tuesday-Thursday: Development
- Friday: Mid-sprint review

**Week 2:**
- Monday-Wednesday: Development
- Thursday: Code freeze, testing
- Friday: Sprint Review & Retrospective

## Issue Lifecycle

### 1. Creating Issues
- Use appropriate template (User Story, Bug, Task)
- Add all required fields
- Assign priority and story points
- Link to epic if applicable

### 2. Sprint Planning
- Product Owner prioritizes backlog
- Team estimates story points
- Issues added to sprint milestone
- Team commits to sprint goal

### 3. During Sprint
- Move issues through board columns:
  - **Todo**: Ready to start
  - **In Progress**: Actively being worked on
  - **In Review**: PR submitted, awaiting review
  - **Done**: Merged and deployed

### 4. Daily Standup
- Update issue status
- Add comments on blockers
- Link PRs to issues

### 5. Sprint Review
- Demo completed stories
- Close sprint milestone
- Calculate velocity

### 6. Retrospective
- What went well?
- What can improve?
- Action items for next sprint

## Board Management

### Automation Rules
- New issues → Automatically added to backlog
- Labeled with 'critical' → Priority set to P0
- PR opened → Issue moves to "In Review"
- PR merged → Issue moves to "Done"
- Issue closed → Automatically moved to Done column

### Commands in Comments
- `/start` or `/working` - Move to In Progress
- `/review` - Move to In Review
- `/block` - Add blocked label
- `/points X` - Set story points

## Best Practices

### For Developers
1. Update issue status regularly
2. Link PRs to issues using "Fixes #123"
3. Keep issues focused and small
4. Add technical notes and blockers
5. Review other PRs promptly

### For Product Owner
1. Keep backlog groomed and prioritized
2. Write clear acceptance criteria
3. Be available for questions
4. Review completed work promptly
5. Plan 1-2 sprints ahead

### For Scrum Master
1. Facilitate sprint ceremonies
2. Remove blockers
3. Track metrics and velocity
4. Ensure process adherence
5. Continuous improvement

## Metrics and Reports

### Velocity Tracking
- Track story points per sprint
- Calculate average velocity
- Use for sprint planning

### Burndown Charts
- Daily remaining work visualization
- Identify scope creep
- Predict sprint completion

### Cycle Time
- Measure time from start to done
- Identify bottlenecks
- Improve flow

## Tools Integration

- **Slack**: Notifications for issue updates
- **Jira** (if needed): Sync issues bidirectionally
- **GitHub Actions**: Automated workflows
- **Analytics**: Custom dashboards

## Training Resources

- [GitHub Projects Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [Agile Best Practices]
- Internal team training sessions
```

### Verification Steps

**1. Test Issue Creation:**
```bash
# Create a test issue using each template
# Verify all fields are captured correctly
# Check that issue is auto-added to project
```

**2. Test Automation:**
```bash
# Create issue → Should auto-add to project
# Label as 'critical' → Priority should update
# Comment '/start' → Should move to In Progress
# Close issue → Should move to Done
```

**3. Test Views:**
```bash
# Switch between different views
# Verify filters work correctly
# Check that sorting is appropriate
# Ensure all stakeholders can see relevant info
```

**4. Test Sprint Workflow:**
```bash
# Create sprint milestone
# Add issues to sprint
# Move issues through workflow
# Close sprint and calculate velocity
```

**5. Generate Reports:**
```bash
# Run velocity calculation
npm install @octokit/rest
node .github/scripts/calculate-velocity.js

# Export burndown data
node .github/scripts/burndown-data.js > burndown.json
```

### Best Practices

1. **Keep Issues Atomic**
   - One clear objective per issue
   - Should be completable in 1-3 days
   - Break large stories into tasks

2. **Use Labels Consistently**
   - Priority labels (P0-P3)
   - Type labels (bug, enhancement, task)
   - Status labels (blocked, needs-review)
   - Area labels (frontend, backend, infra)

3. **Maintain Backlog Health**
   - Regular grooming sessions
   - Remove or archive stale issues
   - Keep top 20 issues well-defined
   - Estimate top items

4. **Sprint Planning**
   - Don't overcommit
   - Leave buffer for unexpected work
   - Have stretch goals
   - Consider team capacity (vacations, etc.)

5. **Retrospectives**
   - Be honest about what didn't work
   - Create actionable improvements
   - Track improvement items
   - Celebrate successes

### Troubleshooting

**Issue: Automation not working**
- Check PROJECT_TOKEN has correct permissions
- Verify workflow file syntax
- Check GitHub Actions logs
- Ensure project URL is correct

**Issue: Views not showing data**
- Check filter syntax
- Verify issues have required fields
- Clear browser cache
- Try different browser

**Issue: Velocity calculation wrong**
- Verify story point labels are consistent
- Check that issues have correct milestone
- Ensure closed issues are actually completed
- Review calculation script logic

**Issue: Team not adopting workflow**
- Provide training and documentation
- Start with simple process
- Gather feedback and iterate
- Show value with metrics
- Lead by example

### Interview Questions

**Q: How do you handle scope creep during a sprint?**

**A: Several strategies:**

1. **Prevention**:
   - Clear sprint goals
   - Well-defined acceptance criteria
   - Strong product owner involvement

2. **Detection**:
   - Daily standups
   - Burndown chart monitoring
   - Story point tracking

3. **Response**:
   - Evaluate priority vs sprint goal
   - If critical: Remove lower priority item
   - If not critical: Add to next sprint backlog
   - Document decision and reason

4. **Documentation**:
   - Track scope changes
   - Discuss in retrospective
   - Improve estimation for future

**Q: How do you measure team productivity in agile?**

**A: Multiple metrics:**

1. **Velocity**:
   - Story points completed per sprint
   - Track trend over time
   - Use for capacity planning

2. **Cycle Time**:
   - Time from start to done
   - Identify bottlenecks
   - Optimize workflow

3. **Throughput**:
   - Number of items completed
   - Focus on flow
   - Reduce work in progress

4. **Quality Metrics**:
   - Bug escape rate
   - Rework percentage
   - Customer satisfaction

5. **Team Health**:
   - Sprint goal achievement rate
   - Team happiness surveys
   - Retrospective action items

**Important**: Focus on trends, not absolute numbers. Use metrics to improve, not to judge.

**Q: How do you handle dependencies between teams in agile?**

**A: Dependency management strategies:**

1. **Identification**:
   - During sprint planning
   - Mark issues with 'depends-on' label
   - Link related issues across repos

2. **Communication**:
   - Cross-team standups
   - Shared calendar for releases
   - Slack channels for coordination

3. **Project Tracking**:
   - Create dependency tracking view
   - Highlight blocked items
   - Track dependency resolution

4. **Mitigation**:
   - Parallel work where possible
   - Early integration testing
   - API contracts/mocks
   - Feature flags for decoupling

5. **Process**:
   - Scrum of Scrums
   - Regular sync meetings
   - Clear escalation path

---

## Task 3.9: Advanced PR Automation and Workflows

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-39-advanced-pr-automation-and-workflows)**

### Solution Overview

Implement comprehensive PR automation including auto-labeling, size detection, auto-merge, stale PR management, quality checks, and automatic reviewer assignment to reduce manual overhead and improve workflow efficiency.

### Step 1: Set Up Auto-Labeling Based on File Changes

Create `.github/labeler.yml`:

```yaml
# Auto-label PRs based on changed files

# Frontend changes
'frontend':
  - 'src/components/**/*'
  - 'src/pages/**/*'
  - 'src/styles/**/*'
  - 'public/**/*'
  - '*.css'
  - '*.scss'

# Backend changes
'backend':
  - 'src/api/**/*'
  - 'src/services/**/*'
  - 'src/models/**/*'
  - 'src/controllers/**/*'

# Database changes
'database':
  - 'migrations/**/*'
  - 'seeds/**/*'
  - '*.sql'
  - 'prisma/**/*'
  - 'schema.prisma'

# Infrastructure changes
'infrastructure':
  - 'terraform/**/*'
  - 'k8s/**/*'
  - 'docker/**/*'
  - 'Dockerfile*'
  - '*.tf'

# CI/CD changes
'ci-cd':
  - '.github/workflows/**/*'
  - '.github/actions/**/*'
  - 'Jenkinsfile'
  - '.gitlab-ci.yml'

# Documentation changes
'documentation':
  - 'docs/**/*'
  - '*.md'
  - 'README*'

# Configuration changes
'configuration':
  - 'config/**/*'
  - '*.json'
  - '*.yaml'
  - '*.yml'
  - '.env*'

# Testing
'testing':
  - '**/*.test.js'
  - '**/*.spec.js'
  - '**/*.test.ts'
  - '**/*.spec.ts'
  - 'tests/**/*'
  - 'e2e/**/*'

# Security
'security':
  - 'SECURITY.md'
  - '.github/dependabot.yml'
  - '.github/workflows/security*.yml'

# Dependencies
'dependencies':
  - 'package.json'
  - 'package-lock.json'
  - 'yarn.lock'
  - 'pom.xml'
  - 'requirements.txt'
  - 'Gemfile'
  - 'go.mod'
```

Create `.github/workflows/pr-labeler.yml`:

```yaml
name: PR Labeler

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  label:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Label PR
        uses: actions/labeler@v5
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          configuration-path: .github/labeler.yml
          sync-labels: true
```

### Step 2: Configure PR Size Detection

Create `.github/workflows/pr-size-labeler.yml`:

```yaml
name: PR Size Labeler

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  size-label:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Calculate PR size and add label
        uses: actions/github-script@v7
        with:
          script: |
            const pr = context.payload.pull_request;
            
            // Get files changed in the PR
            const { data: files } = await github.rest.pulls.listFiles({
              owner: context.repo.owner,
              repo: context.repo.repo,
              pull_number: pr.number
            });
            
            // Calculate total changes (additions + deletions)
            const totalChanges = files.reduce((acc, file) => {
              return acc + file.additions + file.deletions;
            }, 0);
            
            // Determine size label
            let sizeLabel;
            if (totalChanges < 10) {
              sizeLabel = 'size/XS';
            } else if (totalChanges < 50) {
              sizeLabel = 'size/S';
            } else if (totalChanges < 250) {
              sizeLabel = 'size/M';
            } else if (totalChanges < 1000) {
              sizeLabel = 'size/L';
            } else {
              sizeLabel = 'size/XL';
            }
            
            // Remove old size labels
            const existingLabels = pr.labels.map(label => label.name);
            const sizeLabels = existingLabels.filter(label => label.startsWith('size/'));
            
            for (const label of sizeLabels) {
              await github.rest.issues.removeLabel({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: pr.number,
                name: label
              });
            }
            
            // Add new size label
            await github.rest.issues.addLabels({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: pr.number,
              labels: [sizeLabel]
            });
            
            // Add warning comment for large PRs
            if (totalChanges >= 1000) {
              await github.rest.issues.createComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: pr.number,
                body: `⚠️ **Large PR Warning**\n\nThis PR has ${totalChanges} lines changed. Consider breaking it into smaller PRs for easier review.\n\n**Benefits of smaller PRs:**\n- Faster reviews\n- Easier to spot issues\n- Reduced merge conflicts\n- Better code quality\n\n**Files changed:** ${files.length}`
              });
            }
            
            console.log(`PR #${pr.number} labeled as ${sizeLabel} (${totalChanges} changes)`);
```

### Step 3: Implement PR Quality Checks

Create `.github/workflows/pr-quality-check.yml`:

```yaml
name: PR Quality Check

on:
  pull_request:
    types: [opened, edited, reopened]

jobs:
  quality-check:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      checks: write
    
    steps:
      - name: Check PR title
        uses: actions/github-script@v7
        with:
          script: |
            const pr = context.payload.pull_request;
            const title = pr.title;
            
            // Check title format
            const validPrefixes = ['feat:', 'fix:', 'docs:', 'style:', 'refactor:', 'test:', 'chore:', 'perf:'];
            const hasValidPrefix = validPrefixes.some(prefix => title.toLowerCase().startsWith(prefix));
            
            const checks = {
              hasValidPrefix: {
                pass: hasValidPrefix,
                message: hasValidPrefix 
                  ? '✅ Title has valid conventional commit prefix' 
                  : '❌ Title must start with one of: ' + validPrefixes.join(', ')
              },
              hasDescription: {
                pass: title.length > 10,
                message: title.length > 10
                  ? '✅ Title has adequate length'
                  : '❌ Title is too short (minimum 10 characters)'
              },
              notAllCaps: {
                pass: title !== title.toUpperCase(),
                message: title !== title.toUpperCase()
                  ? '✅ Title is not in all caps'
                  : '❌ Title should not be in all caps'
              }
            };
            
            // Check PR body
            const body = pr.body || '';
            const bodyChecks = {
              hasDescription: {
                pass: body.length > 50,
                message: body.length > 50
                  ? '✅ PR has adequate description'
                  : '❌ PR description is too short (minimum 50 characters)'
              },
              hasIssueLink: {
                pass: /(?:close[sd]?|fix(?:e[sd])?|resolve[sd]?)\s+#\d+/i.test(body) || /#\d+/.test(body),
                message: /(?:close[sd]?|fix(?:e[sd])?|resolve[sd]?)\s+#\d+/i.test(body) || /#\d+/.test(body)
                  ? '✅ PR links to an issue'
                  : '⚠️  PR should link to related issues (use "Fixes #123" or "Relates to #123")'
              },
              hasTestingInfo: {
                pass: /test|tested|testing/i.test(body) || /how to test/i.test(body),
                message: /test|tested|testing/i.test(body) || /how to test/i.test(body)
                  ? '✅ PR includes testing information'
                  : '⚠️  Consider adding testing instructions'
              }
            };
            
            // Combine all checks
            const allChecks = { ...checks, ...bodyChecks };
            const failedChecks = Object.values(allChecks).filter(check => !check.pass);
            const passed = failedChecks.length === 0;
            
            // Create check run
            await github.rest.checks.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              name: 'PR Quality Check',
              head_sha: pr.head.sha,
              status: 'completed',
              conclusion: passed ? 'success' : 'neutral',
              output: {
                title: passed ? 'All quality checks passed' : 'Some quality checks failed',
                summary: passed 
                  ? 'All PR quality checks have passed! ✅'
                  : 'Please address the following issues:\n\n' + 
                    Object.values(allChecks).map(check => check.message).join('\n'),
                text: Object.values(allChecks).map(check => check.message).join('\n')
              }
            });
            
            // Add comment if critical checks failed
            const criticalFailed = !checks.hasValidPrefix.pass || !bodyChecks.hasDescription.pass;
            if (criticalFailed && !pr.user.login.includes('bot')) {
              await github.rest.issues.createComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: pr.number,
                body: `## PR Quality Check Results\n\n${Object.values(allChecks).map(check => check.message).join('\n')}\n\n---\n\n**Please address the failed checks before requesting review.**`
              });
            }
      
      - name: Check for WIP or Draft
        uses: actions/github-script@v7
        with:
          script: |
            const pr = context.payload.pull_request;
            const title = pr.title.toLowerCase();
            const isDraft = pr.draft;
            const hasWIP = title.includes('wip') || title.includes('work in progress');
            
            if ((hasWIP || isDraft) && !pr.labels.find(l => l.name === 'work-in-progress')) {
              await github.rest.issues.addLabels({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: pr.number,
                labels: ['work-in-progress']
              });
            }
```

### Step 4: Configure Auto-Merge for Passing PRs

Create `.github/workflows/auto-merge.yml`:

```yaml
name: Auto Merge

on:
  pull_request_review:
    types: [submitted]
  check_suite:
    types: [completed]
  pull_request:
    types: [labeled]

jobs:
  auto-merge:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    
    steps:
      - name: Check if PR can be auto-merged
        uses: actions/github-script@v7
        with:
          script: |
            // Get PR details
            const pr = context.payload.pull_request;
            
            // Skip if PR doesn't exist or is closed
            if (!pr || pr.state !== 'open') {
              console.log('PR is not open, skipping');
              return;
            }
            
            // Check for auto-merge label
            const hasAutoMergeLabel = pr.labels.some(label => 
              label.name === 'auto-merge' || label.name === 'automerge'
            );
            
            if (!hasAutoMergeLabel) {
              console.log('PR does not have auto-merge label, skipping');
              return;
            }
            
            // Get PR details with reviews
            const { data: prData } = await github.rest.pulls.get({
              owner: context.repo.owner,
              repo: context.repo.repo,
              pull_number: pr.number
            });
            
            // Check if PR is approved
            const { data: reviews } = await github.rest.pulls.listReviews({
              owner: context.repo.owner,
              repo: context.repo.repo,
              pull_number: pr.number
            });
            
            const latestReviews = {};
            reviews.forEach(review => {
              latestReviews[review.user.login] = review.state;
            });
            
            const approvedCount = Object.values(latestReviews).filter(
              state => state === 'APPROVED'
            ).length;
            
            const changesRequestedCount = Object.values(latestReviews).filter(
              state => state === 'CHANGES_REQUESTED'
            ).length;
            
            // Require at least 1 approval and no change requests
            if (approvedCount < 1) {
              console.log('PR needs at least 1 approval');
              return;
            }
            
            if (changesRequestedCount > 0) {
              console.log('PR has requested changes');
              return;
            }
            
            // Check if all required checks have passed
            const { data: checkRuns } = await github.rest.checks.listForRef({
              owner: context.repo.owner,
              repo: context.repo.repo,
              ref: pr.head.sha
            });
            
            const failedChecks = checkRuns.check_runs.filter(
              check => check.conclusion === 'failure' || check.conclusion === 'cancelled'
            );
            
            if (failedChecks.length > 0) {
              console.log('PR has failing checks:', failedChecks.map(c => c.name));
              return;
            }
            
            // Check if PR is mergeable
            if (prData.mergeable_state !== 'clean') {
              console.log('PR is not in a mergeable state:', prData.mergeable_state);
              return;
            }
            
            // All conditions met, merge the PR
            try {
              await github.rest.pulls.merge({
                owner: context.repo.owner,
                repo: context.repo.repo,
                pull_number: pr.number,
                merge_method: 'squash', // or 'merge' or 'rebase'
                commit_title: `${pr.title} (#${pr.number})`,
                commit_message: pr.body || ''
              });
              
              console.log(`Successfully auto-merged PR #${pr.number}`);
              
              // Add comment
              await github.rest.issues.createComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: pr.number,
                body: '✅ **Auto-merged**\n\nThis PR was automatically merged because:\n- It has the `auto-merge` label\n- It has at least 1 approval\n- All checks have passed\n- No changes were requested\n- The PR is mergeable'
              });
              
              // Delete branch if requested
              if (pr.head.repo.full_name === context.repo.owner + '/' + context.repo.repo) {
                try {
                  await github.rest.git.deleteRef({
                    owner: context.repo.owner,
                    repo: context.repo.repo,
                    ref: `heads/${pr.head.ref}`
                  });
                  console.log(`Deleted branch: ${pr.head.ref}`);
                } catch (error) {
                  console.log(`Could not delete branch: ${error.message}`);
                }
              }
            } catch (error) {
              console.log(`Failed to auto-merge: ${error.message}`);
            }
```

### Step 5: Set Up Stale PR Management

Create `.github/workflows/stale-pr.yml`:

```yaml
name: Stale PR Management

on:
  schedule:
    - cron: '0 0 * * *' # Run daily at midnight
  workflow_dispatch: # Allow manual trigger

jobs:
  stale:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
      issues: write
    
    steps:
      - name: Mark and close stale PRs
        uses: actions/stale@v9
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          
          # PR settings
          days-before-stale: 14
          days-before-close: 7
          stale-pr-message: |
            👋 This PR has been inactive for 14 days and is marked as stale.
            
            **What happens next?**
            - If there's no activity in the next 7 days, this PR will be automatically closed
            - To keep it open, add a comment or push new commits
            - Remove the `stale` label if you're actively working on it
            
            **Need help?**
            - Tag a maintainer if you're blocked
            - Ask questions in the comments
            - Update the PR description with current status
          
          close-pr-message: |
            🔒 This PR was automatically closed due to inactivity.
            
            **Why was it closed?**
            - No activity for 21 days (14 days stale + 7 days grace period)
            
            **Can it be reopened?**
            - Yes! Comment on this PR and a maintainer will review it
            - Or create a new PR with the same changes
            
            Thank you for your contribution! 🙏
          
          stale-pr-label: 'stale'
          exempt-pr-labels: 'keep-open,in-progress,blocked'
          exempt-draft-pr: true
          
          # Issue settings (optional)
          days-before-issue-stale: 60
          days-before-issue-close: 14
          stale-issue-message: 'This issue has been inactive for 60 days and is marked as stale.'
          close-issue-message: 'This issue was automatically closed due to inactivity.'
          stale-issue-label: 'stale'
          exempt-issue-labels: 'pinned,security,roadmap'
          
          # General settings
          operations-per-run: 100
          remove-stale-when-updated: true
          ascending: true
```

### Step 6: Configure Auto-Assignment of Reviewers

Create `.github/workflows/auto-assign-reviewer.yml`:

```yaml
name: Auto Assign Reviewers

on:
  pull_request:
    types: [opened, ready_for_review]

jobs:
  assign-reviewers:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Auto-assign reviewers
        uses: actions/github-script@v7
        with:
          script: |
            const pr = context.payload.pull_request;
            
            // Skip if PR is draft
            if (pr.draft) {
              console.log('PR is draft, skipping reviewer assignment');
              return;
            }
            
            // Get files changed
            const { data: files } = await github.rest.pulls.listFiles({
              owner: context.repo.owner,
              repo: context.repo.repo,
              pull_number: pr.number
            });
            
            // Determine reviewers based on file changes
            const reviewers = new Set();
            const teamReviewers = new Set();
            
            files.forEach(file => {
              const path = file.filename;
              
              // Frontend files
              if (path.match(/^(src\/(components|pages|styles)|.*\.(css|scss))/) ) {
                reviewers.add('frontend-lead');
                teamReviewers.add('frontend-team');
              }
              
              // Backend files
              if (path.match(/^src\/(api|services|models|controllers)/)) {
                reviewers.add('backend-lead');
                teamReviewers.add('backend-team');
              }
              
              // Database files
              if (path.match(/^(migrations|seeds)\/|\.sql$|prisma\//)) {
                reviewers.add('database-expert');
              }
              
              // Infrastructure files
              if (path.match(/^(terraform|k8s|docker)\/|Dockerfile|\.tf$/)) {
                reviewers.add('devops-lead');
                teamReviewers.add('devops-team');
              }
              
              // Security-related files
              if (path.match(/(security|auth|crypto)/i)) {
                reviewers.add('security-lead');
              }
              
              // CI/CD files
              if (path.match(/^\.github\/workflows\//)) {
                reviewers.add('ci-cd-expert');
              }
            });
            
            // Remove PR author from reviewers
            reviewers.delete(pr.user.login);
            
            // Assign individual reviewers
            if (reviewers.size > 0) {
              try {
                await github.rest.pulls.requestReviewers({
                  owner: context.repo.owner,
                  repo: context.repo.repo,
                  pull_number: pr.number,
                  reviewers: Array.from(reviewers).slice(0, 3) // Max 3 reviewers
                });
                console.log('Assigned reviewers:', Array.from(reviewers));
              } catch (error) {
                console.log('Error assigning reviewers:', error.message);
              }
            }
            
            // Assign team reviewers
            if (teamReviewers.size > 0) {
              try {
                await github.rest.pulls.requestReviewers({
                  owner: context.repo.owner,
                  repo: context.repo.repo,
                  pull_number: pr.number,
                  team_reviewers: Array.from(teamReviewers).slice(0, 2) // Max 2 teams
                });
                console.log('Assigned team reviewers:', Array.from(teamReviewers));
              } catch (error) {
                console.log('Error assigning team reviewers:', error.message);
              }
            }
            
            // Add comment with reviewer explanation
            if (reviewers.size > 0 || teamReviewers.size > 0) {
              await github.rest.issues.createComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: pr.number,
                body: `👥 **Reviewers Auto-Assigned**\n\nBased on the files changed, the following reviewers have been assigned:\n\n**Individual Reviewers:** ${Array.from(reviewers).map(r => `@${r}`).join(', ') || 'None'}\n\n**Team Reviewers:** ${Array.from(teamReviewers).map(t => `@${context.repo.owner}/${t}`).join(', ') || 'None'}\n\n---\n*You can request additional reviewers if needed.*`
              });
            }
```

Create `.github/auto_assign.yml` (alternative approach using action):

```yaml
# Configuration for auto-assign action
addReviewers: true
addAssignees: false

# Number of reviewers to add
numberOfReviewers: 2

# Reviewer selection
reviewers:
  - frontend-lead
  - backend-lead
  - devops-lead
  - qa-lead

# Team reviewers (requires org membership)
teamReviewers:
  - frontend-team
  - backend-team

# Keywords in PR title to assign specific reviewers
keywords:
  - keywords: ['frontend', 'ui', 'css', 'react']
    reviewers: ['frontend-lead']
  
  - keywords: ['backend', 'api', 'server', 'database']
    reviewers: ['backend-lead']
  
  - keywords: ['infra', 'devops', 'ci', 'cd', 'docker', 'k8s']
    reviewers: ['devops-lead']
  
  - keywords: ['test', 'qa', 'e2e']
    reviewers: ['qa-lead']

# Skip draft PRs
skipDraft: true
```

### Step 7: Enhanced PR Template

Create `.github/PULL_REQUEST_TEMPLATE.md`:

```markdown
## 📝 Description

<!-- Provide a brief description of the changes -->

## 🔗 Related Issues

<!-- Link to related issues using: Fixes #123, Closes #456, Relates to #789 -->

Fixes #

## 🎯 Type of Change

<!-- Mark the relevant option with an 'x' -->

- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📝 Documentation update
- [ ] 🎨 Style/UI update
- [ ] ♻️  Code refactoring
- [ ] ⚡ Performance improvement
- [ ] ✅ Test update
- [ ] 🔧 Configuration change
- [ ] 🔒 Security update

## 🧪 How Has This Been Tested?

<!-- Describe the tests you ran to verify your changes -->

- [ ] Unit tests
- [ ] Integration tests
- [ ] E2E tests
- [ ] Manual testing

**Test Configuration**:
* OS:
* Browser (if applicable):
* Node version:

## 📸 Screenshots (if applicable)

<!-- Add screenshots to help explain your changes -->

## ✅ Checklist

<!-- Mark completed items with an 'x' -->

### Code Quality
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes

### Security & Performance
- [ ] I have checked for security vulnerabilities
- [ ] I have considered the performance impact of my changes
- [ ] I have not included any sensitive data (passwords, API keys, etc.)

### Documentation
- [ ] I have updated the README (if applicable)
- [ ] I have updated API documentation (if applicable)
- [ ] I have added inline code comments where necessary

## 📚 Additional Context

<!-- Add any other context about the PR here -->

## 🔄 Post-Merge Actions

<!-- List any actions that need to be taken after merging -->

- [ ] Database migration required
- [ ] Configuration update needed
- [ ] Deployment steps documented
- [ ] Monitoring/alerts updated
- [ ] Documentation site updated

---

<!-- 
💡 Tips for a great PR:
- Keep changes focused and atomic
- Write clear commit messages
- Add meaningful tests
- Update documentation
- Respond to review comments promptly
-->
```

### Verification Steps

**1. Test Auto-Labeling:**
```bash
# Create a PR with frontend changes
git checkout -b test/auto-label
echo "test" > src/components/test.js
git add .
git commit -m "test: frontend change"
git push origin test/auto-label

# Create PR and verify 'frontend' label is added automatically
```

**2. Test PR Size Detection:**
```bash
# Create PRs of different sizes and verify size labels
# XS: < 10 lines
# S: < 50 lines
# M: < 250 lines
# L: < 1000 lines
# XL: >= 1000 lines
```

**3. Test Quality Checks:**
```bash
# Create PR with invalid title (no prefix)
# Expected: Quality check should fail/warn

# Create PR with valid title (e.g., "feat: add new feature")
# Expected: Quality check should pass
```

**4. Test Auto-Merge:**
```bash
# 1. Create PR with 'auto-merge' label
# 2. Get approval
# 3. Wait for all checks to pass
# Expected: PR should auto-merge

# Test that PRs without label don't auto-merge
# Test that PRs with failing checks don't auto-merge
# Test that PRs without approval don't auto-merge
```

**5. Test Stale PR Detection:**
```bash
# Create old PR (adjust stale action dates for testing)
# Run workflow manually: gh workflow run stale-pr.yml
# Verify stale label is added and comment is posted
```

**6. Test Auto-Reviewer Assignment:**
```bash
# Create PR with frontend changes
# Expected: Frontend reviewers assigned

# Create PR with backend changes
# Expected: Backend reviewers assigned

# Create PR with mixed changes
# Expected: Multiple reviewers assigned
```

### Best Practices

1. **Auto-Labeling**
   - Keep labeler.yml organized by category
   - Use glob patterns effectively
   - Review and update patterns regularly
   - Don't over-label (keep it meaningful)

2. **PR Size Management**
   - Encourage smaller PRs through comments
   - Set appropriate thresholds for your team
   - Consider complexity, not just line count
   - Review size warnings regularly

3. **Quality Checks**
   - Make checks helpful, not annoying
   - Use 'neutral' conclusion for warnings
   - Provide clear, actionable feedback
   - Allow for exceptions when needed

4. **Auto-Merge**
   - Require manual opt-in with label
   - Ensure robust approval requirements
   - Verify all checks pass
   - Have escape hatches for issues
   - Monitor for problems

5. **Stale PR Management**
   - Set reasonable timeframes
   - Provide clear warnings
   - Allow easy reopening
   - Exempt special cases
   - Review closed PRs periodically

6. **Reviewer Assignment**
   - Base on file expertise
   - Don't over-assign reviewers
   - Allow manual adjustments
   - Consider team capacity
   - Rotate reviewers fairly

### Troubleshooting

**Issue: Labels not being added**
- Check workflow permissions (pull-requests: write)
- Verify labeler.yml syntax
- Check workflow logs for errors
- Ensure labels exist in repository

**Issue: Auto-merge not working**
- Verify PR has auto-merge label
- Check approval count
- Verify all checks passed
- Check mergeable_state
- Review workflow logs

**Issue: Too many reviewers assigned**
- Adjust numberOfReviewers in config
- Use .slice() to limit team reviewers
- Consider team capacity

**Issue: Quality checks too strict**
- Adjust check criteria
- Use 'neutral' instead of 'failure'
- Make some checks optional
- Add override mechanism

**Issue: Stale bot closing active PRs**
- Add 'keep-open' or 'in-progress' label
- Adjust days-before-stale setting
- Use exempt-pr-labels
- Set exempt-draft-pr: true

### Interview Questions

**Q: How do you balance automation vs manual control in PR workflows?**

**A: Several considerations:**

1. **Start Conservative**:
   - Automate low-risk tasks first
   - Require opt-in for auto-merge
   - Use warnings before errors
   - Allow manual overrides

2. **Gradual Adoption**:
   - Roll out to small team first
   - Gather feedback
   - Adjust based on pain points
   - Expand gradually

3. **Safety Mechanisms**:
   - Multiple approval gates
   - Required status checks
   - Option to bypass automation
   - Clear audit trail

4. **Team Culture**:
   - Trust but verify
   - Encourage code review culture
   - Automation assists, not replaces
   - Regular retrospectives

**Q: How do you handle exceptions to automated PR rules?**

**A: Multi-layered approach:**

1. **Exempt Labels**:
   - 'skip-automation'
   - 'manual-review-required'
   - 'emergency-fix'

2. **Conditional Logic**:
```javascript
if (pr.labels.includes('skip-automation')) {
  console.log('Skipping automation due to exempt label');
  return;
}
```

3. **Override Permissions**:
   - Senior developers can bypass
   - Require justification comment
   - Log all overrides
   - Review in retrospectives

4. **Emergency Procedures**:
   - Documented hotfix process
   - Post-incident review
   - Temporary rule suspension
   - Quick rollback capability

**Q: How do you measure the effectiveness of PR automation?**

**A: Track multiple metrics:**

1. **Time Savings**:
   - Average PR review time
   - Time from open to merge
   - Manual labeling time eliminated
   - Reviewer assignment speed

2. **Quality Metrics**:
   - Bugs caught in review
   - Post-merge issues
   - Code review thoroughness
   - Test coverage trends

3. **Developer Experience**:
   - Team satisfaction surveys
   - Adoption rate
   - Override frequency
   - Friction points

4. **Process Metrics**:
   - PRs auto-labeled correctly (%)
   - Auto-merge success rate
   - False positive rate
   - Stale PR reduction

5. **ROI Calculation**:
```
Time saved per week = 
  (# of PRs) × (avg time saved per PR)

If 50 PRs/week × 5 min saved = 250 min/week
= 4.2 hours/week per team member
= ~200 hours/year per person
```

---

## Tasks 3.10-3.18: Complete Solutions Available

> **📋 Complete Solutions:** All detailed solutions for Tasks 3.10-3.18 are available in:
> 
> ### ⭐ [TASKS-3.10-3.18-COMPLETE-SOLUTIONS.md](./TASKS-3.10-3.18-COMPLETE-SOLUTIONS.md)
>
> This comprehensive document includes production-ready implementations, code examples, workflows, and best practices for:
> - Task 3.10: GitHub Packages/Container Registry Setup
> - Task 3.11: Repository Templates and Standardization
> - Task 3.12: GitHub Apps and Webhooks Integration
> - Task 3.13: Advanced Security - Secret Scanning & Push Protection
> - Task 3.14: GitHub API Integration and Automation
> - Task 3.15: Disaster Recovery and Repository Migration
> - Task 3.16: Performance Optimization for Large Repositories
> - Task 3.17: Compliance and Audit Logging
> - Task 3.18: GitHub Copilot Enterprise Rollout
>
> Each task includes step-by-step implementations, complete code examples, verification procedures, and best practices.

---

> **📚 Quick Navigation:**
> - **Tasks 3.1-3.9 (Complete):** This file (scroll up)
> - **Tasks 3.10-3.18 (Complete):** [TASKS-3.10-3.18-COMPLETE-SOLUTIONS.md](./TASKS-3.10-3.18-COMPLETE-SOLUTIONS.md)
> - **Task Descriptions:** [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)
> - **Overview/Index:** [REAL-WORLD-TASKS-SOLUTIONS-PART-2.md](./REAL-WORLD-TASKS-SOLUTIONS-PART-2.md)

---

## Sprint Planning Guidelines

### Task Complexity Ratings

**Simple (0.5 story points):**
- Tasks: 3.1, 3.2, 3.3, 3.4, 3.5
- Good for new team members
- Can be completed in 1-2 sprint days

**Medium (1 story point):**
- Tasks: 
- Requires solid github repository & workflows experience
- May need 2-3 sprint days

### Recommended Sprint Assignment

**Sprint Week 1:**
- Days 1-2: Task 3.1
- Days 3-4: Task 3.2

**Sprint Week 2:**
- Days 1-2: Task 3.3
- Days 3-4: Task 3.4

### Skill Level Requirements

**Junior DevOps Engineer:**
- Start with: 0.5 point tasks
- Focus on learning and documentation

**Mid-Level DevOps Engineer:**
- Can handle: 0.5 to 1 point tasks
- Expected to complete independently

**Senior DevOps Engineer:**
- Can handle: 1+ point tasks
- May work on multiple tasks simultaneously
- Provides guidance to junior team members

---

## Additional Resources

### Best Practices
- [Industry standards and guidelines]
- [Tool documentation]
- [Community resources]

### Learning Resources
- [Official documentation]
- [Tutorials and guides]
- [Video courses]

---

**Ready to start? Pick a task and dive in! For complete solutions, see [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)**

---

## Implementation Notes

### Solution Structure

Each task solution in this guide provides:

1. **Solution Overview**: High-level approach and architecture
2. **Implementation Steps**: Detailed step-by-step instructions
3. **Configuration Examples**: Key configuration snippets and files
4. **Verification Steps**: Commands to validate the implementation
5. **Best Practices**: Industry-standard approaches applied
6. **Troubleshooting**: Common issues and resolutions

### How to Use These Solutions

**For Learning**:
- Study the approaches and patterns
- Implement following the steps provided
- Adapt to your specific requirements

**For Production**:
- Use configurations as templates
- Customize for your organization
- Test thoroughly before deployment

**For Interviews**:
- Understand the reasoning behind each approach
- Be able to explain trade-offs
- Know the best practices applied

### Production-Ready Implementations

While the solutions provided show the framework and approach, actual production implementations would include:
- Organization-specific configurations
- Custom security policies
- Integration with existing tools
- Comprehensive testing
- Team-specific workflows
- Documentation and runbooks

These solution guides provide the foundation for building production-ready implementations.
