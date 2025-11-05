# Part 3: GitHub Repository & Workflows

## Overview

This section covers professional Git workflows and GitHub best practices for team collaboration on our 3-tier application project.

---

## Task 3.1: Design Monorepo vs Polyrepo Structure

### Goal / Why It's Important

Repository structure impacts:
- **Team collaboration**: How teams work together
- **CI/CD complexity**: Build and deployment workflows
- **Code sharing**: Reusability across projects
- **Versioning**: Release management strategy

Critical architectural decision for any organization.

### Prerequisites

- GitHub account with repository creation permissions
- Understanding of application architecture
- Knowledge of team structure

### Step-by-Step Implementation

#### Option 1: Monorepo Structure

**When to use**: Single product, shared dependencies, atomic changes across services

```
myapp-monorepo/
├── .github/
│   ├── workflows/
│   │   ├── frontend-ci.yml
│   │   ├── backend-ci.yml
│   │   ├── deploy-dev.yml
│   │   └── deploy-prod.yml
│   ├── CODEOWNERS
│   └── dependabot.yml
├── packages/
│   ├── frontend/
│   │   ├── package.json
│   │   ├── src/
│   │   └── Dockerfile
│   ├── backend/
│   │   ├── package.json
│   │   ├── src/
│   │   └── Dockerfile
│   └── shared/
│       ├── types/
│       ├── utils/
│       └── constants/
├── infrastructure/
│   ├── terraform/
│   │   ├── modules/
│   │   ├── environments/
│   │   └── backend.tf
│   └── kubernetes/
│       ├── base/
│       └── overlays/
├── ansible/
│   ├── inventories/
│   ├── playbooks/
│   └── roles/
├── scripts/
│   ├── deploy.sh
│   ├── build.sh
│   └── test.sh
├── docs/
│   ├── architecture/
│   ├── operations/
│   └── development/
├── package.json          # Root workspace config
├── lerna.json           # Monorepo tool config
└── README.md
```

**Pros**:
- Single source of truth
- Atomic commits across services
- Easier code sharing
- Consistent tooling
- Simplified dependency management

**Cons**:
- Larger repository size
- CI/CD more complex
- All teams have access to everything
- Potential for slow git operations

#### Option 2: Polyrepo Structure

**When to use**: Multiple products, independent teams, different tech stacks

```
Organization: mycompany
├── myapp-frontend (repo)
│   ├── src/
│   ├── Dockerfile
│   ├── package.json
│   └── .github/workflows/
├── myapp-backend (repo)
│   ├── src/
│   ├── Dockerfile
│   ├── package.json
│   └── .github/workflows/
├── myapp-infrastructure (repo)
│   ├── terraform/
│   ├── kubernetes/
│   └── ansible/
├── myapp-shared-lib (repo)
│   ├── src/
│   └── package.json (published to npm)
└── myapp-docs (repo)
    ├── architecture/
    └── operations/
```

**Pros**:
- Clear ownership boundaries
- Faster git operations
- Independent versioning
- Better access control
- Simpler CI/CD per repo

**Cons**:
- Harder to make atomic changes
- Dependency management complexity
- Code sharing requires publishing
- Multiple PRs for cross-service changes

### Implementation Steps

#### Setting Up Monorepo

```bash
# 1. Create repository
gh repo create mycompany/myapp-monorepo --public

# 2. Clone and set up structure
git clone git@github.com:mycompany/myapp-monorepo.git
cd myapp-monorepo

# 3. Initialize monorepo tool (Lerna example)
npm init -y
npm install --save-dev lerna
npx lerna init

# 4. Configure workspace
cat > package.json << 'EOF'
{
  "name": "myapp-monorepo",
  "private": true,
  "workspaces": [
    "packages/*"
  ],
  "scripts": {
    "build": "lerna run build",
    "test": "lerna run test",
    "lint": "lerna run lint"
  },
  "devDependencies": {
    "lerna": "^6.0.0"
  }
}
EOF

# 5. Create packages
mkdir -p packages/{frontend,backend,shared}

# 6. Set up CODEOWNERS
cat > .github/CODEOWNERS << 'EOF'
# Default owners
* @mycompany/platform-team

# Frontend team owns frontend code
/packages/frontend/ @mycompany/frontend-team

# Backend team owns backend code
/packages/backend/ @mycompany/backend-team

# Infrastructure requires approval from SRE
/infrastructure/ @mycompany/sre-team
/ansible/ @mycompany/sre-team

# Shared code requires both teams
/packages/shared/ @mycompany/frontend-team @mycompany/backend-team
EOF
```

#### Setting Up Polyrepo

```bash
# 1. Create repositories
gh repo create mycompany/myapp-frontend --public
gh repo create mycompany/myapp-backend --public
gh repo create mycompany/myapp-infrastructure --public
gh repo create mycompany/myapp-shared-lib --public

# 2. Clone and set up each repo
for repo in frontend backend infrastructure shared-lib; do
    git clone git@github.com:mycompany/myapp-$repo.git
    cd myapp-$repo
    
    # Initialize based on type
    if [ "$repo" != "infrastructure" ]; then
        npm init -y
    fi
    
    # Create basic structure
    mkdir -p src .github/workflows
    
    cd ..
done

# 3. Set up shared library publishing
cd myapp-shared-lib
cat > package.json << 'EOF'
{
  "name": "@mycompany/shared-lib",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "files": ["dist"],
  "publishConfig": {
    "access": "public"
  }
}
EOF
```

### Key Commands

```bash
# Monorepo operations
lerna bootstrap              # Install dependencies
lerna run build             # Build all packages
lerna run test              # Test all packages
lerna version               # Version all packages
lerna publish               # Publish all packages

# Check what changed
lerna changed               # List changed packages
lerna diff                  # Show changes

# Polyrepo operations
# Each repo is independent
cd myapp-frontend && npm run build
cd myapp-backend && npm run build
```

### Verification

```bash
# Monorepo: Verify workspace setup
npm run build              # Should build all packages
lerna list                 # List all packages

# Verify CODEOWNERS
cat .github/CODEOWNERS

# Test cross-package dependencies
cd packages/frontend
npm run build
# Should access shared package

# Polyrepo: Verify each repo works independently
for repo in frontend backend infrastructure; do
    cd myapp-$repo
    git status
    cd ..
done
```

### Common Mistakes & Troubleshooting

**Issue**: Circular dependencies in monorepo
```bash
# Use lerna to detect
npx lerna list --graph

# Or use madge
npm install -g madge
madge --circular packages/
```

**Issue**: Polyrepo version conflicts
```bash
# Use exact versions for shared libraries
# In package.json:
{
  "dependencies": {
    "@mycompany/shared-lib": "1.2.3"  // Exact, not ^1.2.3
  }
}
```

### Interview Questions

**Q1: What are the main differences between monorepo and polyrepo?**

**Answer**:

| Aspect | Monorepo | Polyrepo |
|--------|----------|----------|
| **Code location** | Single repository | Multiple repositories |
| **Atomic changes** | Easy (single commit) | Hard (multiple PRs) |
| **Access control** | Coarse-grained | Fine-grained |
| **CI/CD** | Complex (selective builds) | Simple (per repo) |
| **Code sharing** | Direct imports | Published packages |
| **Tooling** | Lerna, Nx, Turborepo | Standard Git |
| **Best for** | Single product, tight coupling | Multiple products, loose coupling |

**Q2: How do you handle versioning in a monorepo?**

**Answer**:

```bash
# Option 1: Fixed versioning (all packages same version)
lerna version --conventional-commits

# Option 2: Independent versioning
lerna version --independent

# Option 3: Semantic versioning with conventional commits
# In lerna.json:
{
  "version": "independent",
  "command": {
    "version": {
      "conventionalCommits": true,
      "message": "chore(release): publish"
    }
  }
}

# Commit format affects version bump:
# feat: ... -> minor version bump
# fix: ... -> patch version bump
# BREAKING CHANGE: -> major version bump
```

**Q3: How do you optimize CI/CD for monorepos?**

**Answer**:
```yaml
# .github/workflows/ci.yml
name: CI

on: [push]

jobs:
  detect-changes:
    runs-on: ubuntu-latest
    outputs:
      frontend: ${{ steps.changes.outputs.frontend }}
      backend: ${{ steps.changes.outputs.backend }}
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

  build-frontend:
    needs: detect-changes
    if: needs.detect-changes.outputs.frontend == 'true'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build frontend
        run: npm run build --workspace=packages/frontend

  build-backend:
    needs: detect-changes
    if: needs.detect-changes.outputs.backend == 'true'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build backend
        run: npm run build --workspace=packages/backend
```

**Q4: How do you manage dependencies across microservices in polyrepo?**

**Answer**:

1. **Shared library approach**:
```bash
# Publish shared code as npm package
cd shared-lib
npm version patch
npm publish

# Consume in other repos
cd frontend
npm install @mycompany/shared-lib@1.2.3
```

2. **Git submodules** (not recommended):
```bash
git submodule add git@github.com:mycompany/shared-lib.git shared
```

3. **Renovate/Dependabot for updates**:
```json
// renovate.json
{
  "extends": ["config:base"],
  "packageRules": [
    {
      "matchPackagePatterns": ["^@mycompany/"],
      "groupName": "internal packages"
    }
  ]
}
```

4. **Version pinning in package.json**:
```json
{
  "dependencies": {
    "@mycompany/shared-lib": "1.2.3"  // Exact version
  }
}
```

**Q5: How do you implement CODEOWNERS effectively?**

**Answer**:
```
# .github/CODEOWNERS

# Default: Platform team reviews everything
* @org/platform-team

# Teams own their services
/services/frontend/ @org/frontend-team
/services/backend/ @org/backend-team
/services/api/ @org/api-team

# Critical paths require multiple approvers
/infrastructure/ @org/sre-team @org/security-team
/database/migrations/ @org/backend-team @org/dba-team

# Configuration files
*.yml @org/devops-team
Dockerfile @org/devops-team

# Documentation
/docs/ @org/tech-writers @org/platform-team

# CI/CD workflows
/.github/workflows/ @org/devops-team

# Security-sensitive files
/secrets/ @org/security-team
*.key @org/security-team
```

Benefits:
- Automatic reviewer assignment
- Enforced code review by domain experts
- Audit trail
- Knowledge distribution

---

## Task 3.2: Implement Git Branching Strategy (GitFlow)

### Goal / Why It's Important

A clear branching strategy ensures:
- **Organized development**: Clear purpose for each branch
- **Safe releases**: Tested code before production
- **Parallel work**: Multiple features in progress
- **Easy rollbacks**: Tagged releases for quick revert

Standard practice in professional development.

### Prerequisites

- Git installed
- Understanding of Git basics
- Team agreement on workflow

### Step-by-Step Implementation

#### GitFlow Strategy

```
main (production)
  ↑
  merge via PR
  ↑
release/v1.2.0
  ↑
  merge via PR
  ↑
develop (integration)
  ↑
  merge via PR
  ↑
feature/user-authentication
feature/api-optimization
hotfix/security-patch
```

#### 1. Set Up Main Branches

```bash
# Initialize repository
git init myapp
cd myapp

# Create initial commit
echo "# MyApp" > README.md
git add README.md
git commit -m "Initial commit"

# Create develop branch
git checkout -b develop
git push -u origin develop

# Protect main branch (GitHub CLI)
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["ci/build","ci/test"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"dismissal_restrictions":{},"dismiss_stale_reviews":true,"require_code_owner_reviews":true,"required_approving_review_count":2}'

# Protect develop branch
gh api repos/:owner/:repo/branches/develop/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["ci/build"]}' \
  --field required_pull_request_reviews='{"required_approving_review_count":1}'
```

#### 2. Feature Development Workflow

```bash
# Create feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/user-authentication

# Make changes
# ... develop feature ...

# Commit changes
git add .
git commit -m "feat: add JWT authentication

- Implement JWT token generation
- Add middleware for token validation
- Create login and refresh endpoints

Closes #123"

# Push feature branch
git push -u origin feature/user-authentication

# Create pull request
gh pr create \
  --base develop \
  --title "feat: Add JWT authentication" \
  --body "Implementation of JWT-based authentication system

## Changes
- JWT token generation and validation
- Login and refresh token endpoints
- Authentication middleware

## Testing
- Unit tests for auth service
- Integration tests for endpoints
- Manual testing completed

Closes #123" \
  --label "feature" \
  --label "authentication"

# After PR approval, merge to develop
# (Done via GitHub UI or)
gh pr merge --squash --delete-branch
```

#### 3. Release Workflow

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# Update version numbers
npm version 1.2.0 --no-git-tag-version
git add package.json package-lock.json
git commit -m "chore: bump version to 1.2.0"

# Create CHANGELOG
cat > CHANGELOG.md << 'EOF'
# Changelog

## [1.2.0] - 2024-01-15

### Added
- JWT authentication system
- User profile endpoints
- Password reset functionality

### Fixed
- Memory leak in WebSocket connections
- Race condition in cache updates

### Changed
- Upgraded Node.js to v20
- Improved error messages
EOF

git add CHANGELOG.md
git commit -m "docs: update changelog for v1.2.0"

# Push release branch
git push -u origin release/v1.2.0

# Create PR to main
gh pr create \
  --base main \
  --title "Release v1.2.0" \
  --body "Release version 1.2.0

See CHANGELOG.md for details." \
  --label "release"

# After PR approval and merge to main:
git checkout main
git pull origin main
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0

# Merge back to develop
git checkout develop
git merge main
git push origin develop

# Delete release branch
git branch -d release/v1.2.0
git push origin --delete release/v1.2.0
```

#### 4. Hotfix Workflow

```bash
# Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/security-patch

# Apply fix
# ... make changes ...

git add .
git commit -m "fix: patch SQL injection vulnerability

Critical security fix for SQL injection in user search.

CVE-2024-12345"

# Update version (patch bump)
npm version patch --no-git-tag-version
git add package.json
git commit -m "chore: bump version to 1.2.1"

# Push hotfix
git push -u origin hotfix/security-patch

# Create PR to main
gh pr create \
  --base main \
  --title "Hotfix: Security patch v1.2.1" \
  --body "**URGENT: Security fix**

Patches SQL injection vulnerability in user search.

CVE-2024-12345" \
  --label "hotfix" \
  --label "security"

# After PR approval:
git checkout main
git pull origin main
git tag -a v1.2.1 -m "Hotfix version 1.2.1"
git push origin v1.2.1

# Merge to develop
git checkout develop
git merge main
git push origin develop

# Delete hotfix branch
git branch -d hotfix/security-patch
git push origin --delete hotfix/security-patch
```

### Commit Message Convention

```bash
# Format:
<type>(<scope>): <subject>

<body>

<footer>

# Types:
feat:     New feature
fix:      Bug fix
docs:     Documentation only
style:    Formatting (no code change)
refactor: Code refactoring
perf:     Performance improvement
test:     Adding tests
chore:    Maintenance tasks
ci:       CI/CD changes

# Examples:
git commit -m "feat(auth): add OAuth2 login"
git commit -m "fix(api): resolve race condition in cache"
git commit -m "docs: update API documentation"
git commit -m "chore(deps): upgrade dependencies"
```

### Key Commands

```bash
# Branch management
git checkout -b branch-name         # Create branch
git branch -d branch-name           # Delete local branch
git push origin --delete branch-name # Delete remote branch

# Merging
git merge branch-name               # Merge branch
git merge --squash branch-name      # Squash merge
git merge --no-ff branch-name       # Force merge commit

# Rebasing
git rebase develop                  # Rebase on develop
git rebase -i HEAD~3                # Interactive rebase

# Tags
git tag -a v1.0.0 -m "message"     # Create annotated tag
git push origin v1.0.0              # Push tag
git tag -d v1.0.0                   # Delete local tag
```

### Verification

```bash
# View branch strategy
git log --oneline --graph --all --decorate

# Check branch protection
gh api repos/:owner/:repo/branches/main/protection

# List all branches
git branch -a

# Verify tags
git tag -l
```

### Common Mistakes & Troubleshooting

**Issue**: Merge conflicts when merging feature to develop
```bash
# Update feature branch with latest develop
git checkout feature/my-feature
git fetch origin
git rebase origin/develop

# Resolve conflicts
# ... edit files ...
git add .
git rebase --continue

# Force push (updates PR)
git push --force-with-lease
```

**Issue**: Forgot to branch from develop
```bash
# Move commits to correct branch
git checkout main  # Wrong base
git log            # Note commit SHAs

git checkout develop
git cherry-pick <commit-sha>

# Remove from main
git checkout main
git reset --hard origin/main
```

### Interview Questions

**Q1: Explain GitFlow and when to use it.**

**Answer**:
GitFlow is a branching model with:

**Branches**:
- **main**: Production code, tagged releases
- **develop**: Integration branch
- **feature/***: New features
- **release/***: Release preparation
- **hotfix/***: Emergency fixes

**When to use**:
- ✅ Scheduled releases
- ✅ Multiple versions in production
- ✅ Large teams
- ✅ Need for stable releases

**When NOT to use**:
- ❌ Continuous deployment
- ❌ Small teams
- ❌ Simple projects
- Use GitHub Flow or Trunk-based instead

**Q2: What's the difference between merge, squash, and rebase?**

**Answer**:

```bash
# Merge: Preserves all commits
git checkout develop
git merge feature/auth
# Result: Merge commit + all feature commits

# Squash: Combines into single commit
git merge --squash feature/auth
git commit -m "feat: add authentication"
# Result: Single commit with all changes

# Rebase: Replays commits on top of target
git checkout feature/auth
git rebase develop
# Result: Linear history, no merge commit
```

**Use cases**:
- **Merge**: Keep full history
- **Squash**: Clean history, group related changes
- **Rebase**: Linear history, during feature development

**Q3: How do you handle long-running feature branches?**

**Answer**:

```bash
# Keep feature branch updated
git checkout feature/long-running
git fetch origin

# Option 1: Rebase (preferred, cleaner history)
git rebase origin/develop

# Option 2: Merge
git merge origin/develop

# Option 3: Feature flags (best practice)
# Merge incomplete feature with flag disabled
if (featureFlags.newFeature) {
  // New code
} else {
  // Old code
}
```

**Best practices**:
- Keep features small and short-lived
- Use feature flags for long features
- Rebase regularly
- Break into smaller PRs

**Q4: How do you create a good pull request?**

**Answer**:

```markdown
## PR Title
feat: Add user authentication system

## Description
Implementation of JWT-based authentication with role-based access control.

## Changes
- Added JWT token generation and validation
- Implemented login, logout, and refresh endpoints
- Created authentication middleware
- Added RBAC with admin and user roles

## Type of Change
- [x] New feature
- [ ] Bug fix
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [x] Unit tests added/updated
- [x] Integration tests added
- [x] Manual testing completed
- [ ] Performance testing

## Screenshots
![Login Page](url-to-screenshot)

## Related Issues
Closes #123
Related to #456

## Checklist
- [x] Code follows style guide
- [x] Self-review completed
- [x] Comments added for complex logic
- [x] Documentation updated
- [x] No new warnings generated
- [x] Tests pass locally
```

**Q5: How do you revert a deployed release?**

**Answer**:

```bash
# Option 1: Revert commit
git checkout main
git revert v1.2.0
git push origin main
git tag -a v1.2.1 -m "Revert v1.2.0"
git push origin v1.2.1

# Option 2: Rollback to previous tag
git checkout main
git reset --hard v1.1.0
git push --force origin main
# ⚠️ Dangerous: Rewrites history

# Option 3: New hotfix (preferred)
git checkout -b hotfix/rollback-v1.2.0
# Remove problematic changes
git commit -m "fix: rollback changes from v1.2.0"
# Follow hotfix workflow

# Option 4: Deploy previous version (Kubernetes)
kubectl set image deployment/api api=myapp:v1.1.0
```

**Best practice**: Use `git revert` (creates new commit) instead of `git reset` (rewrites history).

---

## Task 3.3: Configure Branch Protection and Required Reviews

### Goal / Why It's Important

Branch protection ensures:
- **Code quality**: No direct pushes to important branches
- **Peer review**: All changes reviewed before merge
- **CI validation**: Tests must pass before merge
- **Audit trail**: Track who approved what

Critical for maintaining production stability and compliance.

### Prerequisites

- GitHub repository with admin access
- Understanding of branching strategy
- CI/CD workflows configured

### Step-by-Step Implementation

#### 1. Protect Main Branch via GitHub UI

**Navigate to**: Repository → Settings → Branches → Add rule

Configure these settings:
```
Branch name pattern: main

☑ Require a pull request before merging
  ☑ Require approvals: 2
  ☑ Dismiss stale pull request approvals when new commits are pushed
  ☑ Require review from Code Owners

☑ Require status checks to pass before merging
  ☑ Require branches to be up to date before merging
  Status checks: ci/build, ci/test, security/scan

☑ Require conversation resolution before merging

☑ Require signed commits

☑ Require linear history

☑ Include administrators

☑ Restrict who can push to matching branches
  Select: No one (force PRs for everyone)

☑ Allow force pushes: Disabled
☑ Allow deletions: Disabled
```

#### 2. Configure Branch Protection via GitHub CLI

```bash
# Install GitHub CLI if needed
brew install gh  # macOS
# or
sudo apt install gh  # Ubuntu

# Authenticate
gh auth login

# Set branch protection for main
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["ci/build","ci/test"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{
    "dismissal_restrictions":{},
    "dismiss_stale_reviews":true,
    "require_code_owner_reviews":true,
    "required_approving_review_count":2,
    "require_last_push_approval":false
  }' \
  --field restrictions=null \
  --field required_linear_history=true \
  --field allow_force_pushes=false \
  --field allow_deletions=false \
  --field required_conversation_resolution=true \
  --field lock_branch=false \
  --field allow_fork_syncing=true
```

#### 3. Configure Different Protection Levels

**Main/Production Branch**:
```bash
# Maximum protection
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_pull_request_reviews.required_approving_review_count=2 \
  --field required_pull_request_reviews.require_code_owner_reviews=true \
  --field required_status_checks.strict=true \
  --field enforce_admins=true
```

**Develop Branch**:
```bash
# Moderate protection
gh api repos/:owner/:repo/branches/develop/protection \
  --method PUT \
  --field required_pull_request_reviews.required_approving_review_count=1 \
  --field required_status_checks.strict=true \
  --field enforce_admins=false
```

**Feature Branches**:
```bash
# Pattern protection for feature/*
gh api repos/:owner/:repo/branches/feature*/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["ci/build"]}' \
  --field required_pull_request_reviews.required_approving_review_count=1
```

#### 4. Bypass Protection for Emergency Fixes

```bash
# Create a bypass list for specific users/teams
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field restrictions='{
    "users":["admin-user"],
    "teams":["platform-leads"],
    "apps":[]
  }'
```

### Key Commands

```bash
# View current protection settings
gh api repos/:owner/:repo/branches/main/protection

# List protected branches
gh api repos/:owner/:repo/branches --jq '.[] | select(.protected==true) | .name'

# Remove protection (use carefully!)
gh api repos/:owner/:repo/branches/main/protection --method DELETE

# Check if commits are signed
git log --show-signature

# Sign commits globally
git config --global commit.gpgsign true
git config --global user.signingkey YOUR_GPG_KEY_ID
```

### Verification

```bash
# Test protection is working
git checkout main
echo "test" >> README.md
git add README.md
git commit -m "test: direct commit"
git push origin main
# Should fail with: "protected branch hook declined"

# Verify via API
gh api repos/:owner/:repo/branches/main/protection | jq '{
  required_status_checks,
  required_pull_request_reviews,
  enforce_admins
}'

# Test PR workflow
git checkout -b test/branch-protection
echo "test" >> README.md
git add README.md
git commit -m "test: via PR"
git push origin test/branch-protection
gh pr create --base main --title "Test branch protection"
# Should show required checks and reviewers
```

### Common Mistakes & Troubleshooting

**Issue**: Can't merge PR even with approvals
```bash
# Check if status checks are passing
gh pr checks <PR-number>

# Check if branch is up to date
git fetch origin
git log HEAD..origin/main
# If behind, rebase:
git rebase origin/main
git push --force-with-lease
```

**Issue**: Accidentally locked out of main branch
```bash
# Temporarily disable "Include administrators"
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field enforce_admins=false

# Make your change
git push origin main

# Re-enable protection
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field enforce_admins=true
```

**Issue**: Status checks not showing up
```bash
# Verify check name matches exactly
gh api repos/:owner/:repo/commits/HEAD/check-runs

# Update protection with correct check names
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks.contexts='["ci/build","test"]'
```

### Interview Questions

**Q1: What are the different levels of branch protection you can configure?**

**Answer**:

| Protection Level | Configuration | Use Case |
|-----------------|---------------|----------|
| **Minimal** | Require 1 approval | Feature branches, personal projects |
| **Standard** | 1-2 approvals + status checks | Development branches |
| **Strict** | 2+ approvals + status checks + code owners + signed commits | Main/production branches |
| **Maximum** | All protections + administrator enforcement + no force push | Compliance-critical repositories |

Key settings:
- **Required reviews**: 1-2 for dev, 2+ for production
- **Status checks**: CI/CD must pass
- **Code owners**: Domain experts must approve
- **Signed commits**: Verify commit authenticity
- **Linear history**: No merge commits allowed
- **Administrator enforcement**: Even admins follow rules

**Q2: How do you configure different status checks for different branches?**

**Answer**:
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: ['**']
  pull_request:
    branches: ['**']

jobs:
  # Always run for all branches
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build
        run: npm run build

  # Only run for PRs to main
  security-scan:
    if: github.base_ref == 'main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Security scan
        run: npm audit

  # Only run for PRs to main/develop
  e2e-tests:
    if: contains(fromJSON('["main","develop"]'), github.base_ref)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: E2E tests
        run: npm run test:e2e
```

Configure branch-specific requirements:
```bash
# Main: All checks required
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks.contexts='["build","security-scan","e2e-tests"]'

# Develop: Only build and e2e required
gh api repos/:owner/:repo/branches/develop/protection \
  --method PUT \
  --field required_status_checks.contexts='["build","e2e-tests"]'
```

**Q3: What is the difference between "Require branches to be up to date" being enabled vs disabled?**

**Answer**:

**Enabled (Strict Merge)**:
```
main:     A---B
               \
feature:        C---D
# Must rebase/merge B into feature before merging
# Ensures no conflicts, tests run on latest code
```

**Disabled (Non-strict)**:
```
main:     A---B
               \
feature:        C---D
# Can merge D directly even though it doesn't include B
# Risk: Potential conflicts or broken tests
```

**When to use**:
- **Enable**: Production branches, high-traffic repos, strict quality requirements
- **Disable**: Low-risk branches, small teams, when frequent rebases are impractical

**Trade-offs**:
- Strict = Safer but slower (requires rebase for every new commit to base)
- Non-strict = Faster but riskier (may miss integration issues)

**Q4: How do you handle emergency hotfixes with branch protection?**

**Answer**:

**Option 1: Bypass protection temporarily (not recommended)**
```bash
# Disable protection
gh api repos/:owner/:repo/branches/main/protection --method DELETE

# Make hotfix
git checkout main
git pull
# ... apply fix ...
git commit -m "hotfix: critical security patch"
git push origin main

# Re-enable protection
gh api repos/:owner/:repo/branches/main/protection --method PUT # ... config
```

**Option 2: Use bypass permissions (recommended)**
```bash
# Grant bypass to security team
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field restrictions='{
    "users":[],
    "teams":["security-team"],
    "apps":[]
  }'
```

**Option 3: Expedited PR process (best practice)**
```bash
# Create hotfix branch
git checkout main
git pull
git checkout -b hotfix/critical-fix

# Apply fix
# ... changes ...
git commit -m "hotfix: critical security patch"
git push origin hotfix/critical-fix

# Create PR with priority label
gh pr create --base main --title "HOTFIX: Critical security patch" --label "hotfix" --label "priority:critical"

# Quick review and merge (still maintains audit trail)
# Reviewers can approve quickly, tests still run
```

**Best practice**: Always prefer Option 3 to maintain audit trail and code quality.

**Q5: How do you configure signed commits and why are they important?**

**Answer**:

**Why signed commits matter**:
- Verify commit author identity
- Prevent commit spoofing
- Meet compliance requirements
- Ensure supply chain security

**Setup GPG signing**:
```bash
# 1. Generate GPG key
gpg --full-generate-key
# Choose RSA, 4096 bits, no expiration (or set expiration)

# 2. List keys
gpg --list-secret-keys --keyid-format=long
# Output: sec rsa4096/ABC123DEF456 2024-01-15

# 3. Get public key
gpg --armor --export ABC123DEF456
# Copy output to GitHub Settings → SSH and GPG keys → New GPG key

# 4. Configure Git
git config --global user.signingkey ABC123DEF456
git config --global commit.gpgsign true
git config --global tag.gpgsign true

# 5. Configure GPG TTY (for prompts)
echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
source ~/.bashrc
```

**Verify commits**:
```bash
# Sign a commit
git commit -S -m "feat: signed commit"

# Verify signature
git log --show-signature

# Verify via GitHub API
gh api repos/:owner/:repo/commits/HEAD | jq '.commit.verification'
```

**Enforce in branch protection**:
```bash
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_signatures=true
```

---

## Task 3.4: Pull Request Workflow and Templates

### Goal / Why It's Important

Well-structured PRs ensure:
- **Clear communication**: Reviewers understand changes quickly
- **Consistent process**: Standard workflow for all changes
- **Better reviews**: Templates guide complete information
- **Audit trail**: Document decision-making process

Essential for team collaboration and code quality.

### Prerequisites

- GitHub repository access
- Understanding of Git workflow
- Team agreement on PR process

### Step-by-Step Implementation

#### 1. Create Pull Request Template

```bash
# Create PR template directory
mkdir -p .github

# Create default template
cat > .github/pull_request_template.md << 'EOF'
## Description
<!-- Provide a clear and concise description of your changes -->

## Type of Change
<!-- Mark relevant option with an 'x' -->
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring
- [ ] CI/CD changes

## Related Issues
<!-- Link related issues using keywords: Fixes #123, Closes #456, Related to #789 -->
Fixes #

## Changes Made
<!-- List specific changes made in this PR -->
- 
- 
- 

## Testing Performed
<!-- Describe testing performed to verify changes -->
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing performed
- [ ] All existing tests pass

### Test Evidence
<!-- Provide test results, screenshots, or logs -->
```
Test output:
```

## Deployment Notes
<!-- Any special deployment considerations -->
- Database migrations required: Yes/No
- Configuration changes required: Yes/No
- Dependent PRs: None
- Rollback procedure documented: Yes/No

## Checklist
<!-- Complete checklist before submitting PR -->
- [ ] Code follows project style guide
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated (README, API docs, etc.)
- [ ] No new warnings or errors introduced
- [ ] Tests added/updated and all pass
- [ ] Branch is up to date with base branch
- [ ] Commits are well-formatted and descriptive
- [ ] Breaking changes documented
- [ ] Security considerations reviewed

## Screenshots / Recordings
<!-- If applicable, add screenshots or recordings of UI changes -->

## Reviewer Notes
<!-- Additional context for reviewers -->

## Post-Merge Actions
<!-- Actions to take after merging -->
- [ ] Delete feature branch
- [ ] Update related documentation
- [ ] Notify stakeholders
- [ ] Monitor deployment

EOF
```

#### 2. Create Multiple PR Templates for Different Types

```bash
# Create templates directory
mkdir -p .github/PULL_REQUEST_TEMPLATE

# Feature template
cat > .github/PULL_REQUEST_TEMPLATE/feature.md << 'EOF'
## Feature Description
<!-- What functionality does this add? -->

## User Story
**As a** [user type]
**I want** [goal]
**So that** [benefit]

## Acceptance Criteria
- [ ] 
- [ ] 
- [ ] 

## Implementation Details
<!-- Technical approach taken -->

## Screenshots
<!-- UI changes -->

## Testing
- [ ] Unit tests
- [ ] Integration tests
- [ ] Manual testing
- [ ] Accessibility testing

Closes #
EOF

# Bugfix template
cat > .github/PULL_REQUEST_TEMPLATE/bugfix.md << 'EOF'
## Bug Description
<!-- What was the bug? -->

## Root Cause
<!-- Why did the bug occur? -->

## Fix Applied
<!-- How does this fix resolve the issue? -->

## Reproduction Steps (Before Fix)
1. 
2. 
3. 

## Verification Steps (After Fix)
1. 
2. 
3. 

## Regression Testing
- [ ] Related features still work
- [ ] No new bugs introduced
- [ ] Edge cases tested

Fixes #
EOF

# Hotfix template
cat > .github/PULL_REQUEST_TEMPLATE/hotfix.md << 'EOF'
## 🚨 HOTFIX: Critical Issue

### Severity
- [ ] Production down
- [ ] Major functionality broken
- [ ] Security vulnerability
- [ ] Data integrity issue

### Issue Description
<!-- Describe the critical issue -->

### Impact
**Affected Users**: 
**Services Down**: 
**Data at Risk**: 

### Fix Applied
<!-- Emergency fix implemented -->

### Testing in Production
<!-- How to verify fix works -->

### Rollback Plan
<!-- How to revert if needed -->

### Post-Incident Actions
- [ ] Create postmortem issue
- [ ] Schedule RCA meeting
- [ ] Update runbook
- [ ] Implement preventive measures

Fixes #
EOF
```

#### 3. Configure Pull Request Settings

```bash
# Via GitHub CLI
gh repo edit --enable-squash-merge --enable-merge-commit --enable-rebase-merge

# Default PR to squash merge
gh repo edit --default-branch-merge-type squash

# Automatically delete head branches
gh repo edit --delete-branch-on-merge

# Allow auto-merge
gh repo edit --enable-auto-merge
```

#### 4. Create PR Review Workflow

```yaml
# .github/workflows/pr-checks.yml
name: PR Checks

on:
  pull_request:
    types: [opened, synchronize, reopened, edited]

jobs:
  validate-pr:
    runs-on: ubuntu-latest
    steps:
      - name: Check PR title format
        uses: amannn/action-semantic-pull-request@v5
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          types: |
            feat
            fix
            docs
            style
            refactor
            perf
            test
            build
            ci
            chore

      - name: Check PR size
        uses: actions/github-script@v7
        with:
          script: |
            const pr = context.payload.pull_request;
            const additions = pr.additions;
            const deletions = pr.deletions;
            const changes = additions + deletions;
            
            if (changes > 500) {
              core.setFailed(`PR too large (${changes} lines). Consider breaking it down.`);
            }

      - name: Check PR has linked issue
        uses: actions/github-script@v7
        with:
          script: |
            const pr = context.payload.pull_request;
            const body = pr.body || '';
            
            const hasIssueLink = /(?:close|closes|closed|fix|fixes|fixed|resolve|resolves|resolved)\s+#\d+/i.test(body);
            
            if (!hasIssueLink && !pr.labels.find(l => l.name === 'no-issue-needed')) {
              core.setFailed('PR must link to an issue or have "no-issue-needed" label');
            }

  label-pr:
    runs-on: ubuntu-latest
    steps:
      - name: Label based on files changed
        uses: actions/labeler@v4
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          configuration-path: .github/labeler.yml

  size-label:
    runs-on: ubuntu-latest
    steps:
      - name: Add size label
        uses: codelytv/pr-size-labeler@v1
        with:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          xs_label: 'size/XS'
          xs_max_size: 10
          s_label: 'size/S'
          s_max_size: 100
          m_label: 'size/M'
          m_max_size: 500
          l_label: 'size/L'
          l_max_size: 1000
          xl_label: 'size/XL'
```

#### 5. Configure Auto-labeling

```yaml
# .github/labeler.yml
'frontend':
  - 'packages/frontend/**/*'
  - 'apps/web/**/*'

'backend':
  - 'packages/backend/**/*'
  - 'apps/api/**/*'

'infrastructure':
  - 'infrastructure/**/*'
  - 'terraform/**/*'
  - 'kubernetes/**/*'

'documentation':
  - '**/*.md'
  - 'docs/**/*'

'ci/cd':
  - '.github/workflows/**/*'
  - '.github/actions/**/*'
  - 'Jenkinsfile'

'dependencies':
  - 'package.json'
  - 'package-lock.json'
  - 'go.mod'
  - 'go.sum'
  - 'requirements.txt'
```

### Key Commands

```bash
# Create PR with template
gh pr create --title "feat: add user authentication" --body-file .github/pull_request_template.md

# Create PR with specific template
gh pr create --title "fix: resolve API timeout" --template bugfix

# Create PR with labels
gh pr create --title "feat: new feature" --label "enhancement" --label "frontend"

# Draft PR (work in progress)
gh pr create --draft --title "WIP: new feature"

# Mark draft as ready
gh pr ready <PR-number>

# Add reviewers
gh pr edit <PR-number> --add-reviewer "@org/team-name,username"

# Request review from code owners
gh pr create --title "feat: new feature" --reviewer $(gh api repos/:owner/:repo/contents/.github/CODEOWNERS --jq '.content' | base64 -d | grep -o '@[a-zA-Z0-9_-]*')

# View PR checks
gh pr checks <PR-number>

# View PR diff
gh pr diff <PR-number>

# View PR comments
gh pr view <PR-number>

# Merge PR
gh pr merge <PR-number> --squash --delete-branch
```

### Verification

```bash
# Verify template exists
ls -la .github/pull_request_template.md

# Test PR creation
gh pr create --title "test: PR template" --draft

# Verify PR has template content
gh pr view <PR-number> --json body --jq '.body'

# Check PR labels
gh pr view <PR-number> --json labels --jq '.labels[].name'

# Verify checks are running
gh pr checks <PR-number>
```

### Common Mistakes & Troubleshooting

**Issue**: PR template not showing up
```bash
# Check file name and location
# Must be one of:
# - .github/pull_request_template.md
# - .github/PULL_REQUEST_TEMPLATE.md
# - docs/pull_request_template.md

# Verify file is committed
git ls-files .github/

# Push template
git add .github/pull_request_template.md
git commit -m "chore: add PR template"
git push origin main
```

**Issue**: PR checks not running
```bash
# Verify workflow file
cat .github/workflows/pr-checks.yml

# Check workflow runs
gh run list --workflow=pr-checks.yml

# View workflow logs
gh run view <run-id> --log
```

**Issue**: Can't auto-merge PR
```bash
# Check if auto-merge is enabled
gh repo view --json autoMergeAllowed

# Enable auto-merge
gh repo edit --enable-auto-merge

# Enable auto-merge for specific PR
gh pr merge <PR-number> --auto --squash
```

### Interview Questions

**Q1: What makes a good pull request description?**

**Answer**:

A good PR description includes:

1. **Clear Title**: Follow conventional commit format
```
feat: Add user authentication system
fix: Resolve memory leak in cache module
docs: Update API documentation
```

2. **Context**: Why the change is needed
```
## Context
Users are unable to authenticate using OAuth2, causing a 50% drop in new signups.
This PR implements OAuth2 authentication to resolve the issue.
```

3. **Changes**: What was modified
```
## Changes
- Added OAuth2 client configuration
- Implemented token refresh mechanism
- Added user session management
- Updated API endpoints to require authentication
```

4. **Testing**: How it was verified
```
## Testing
- Unit tests: 95% coverage for auth module
- Integration tests: All OAuth2 flows tested
- Manual testing: Tested with Google, GitHub, Facebook providers
- Load testing: 1000 concurrent authentications successful
```

5. **Impact**: Deployment considerations
```
## Impact
- **Database**: No migrations required
- **Config**: Add OAUTH2_CLIENT_ID and OAUTH2_CLIENT_SECRET to environment
- **Deployment**: Can be deployed without downtime
- **Rollback**: Simply revert to previous version
```

6. **Screenshots/Evidence**: Visual changes
7. **Related Issues**: Fixes #123, Related to #456

**Q2: How do you handle large pull requests?**

**Answer**:

**Prevention** (best approach):
```bash
# Break into smaller PRs
# Instead of one 2000-line PR:

# PR 1: Database schema changes
git checkout -b feat/auth-db-schema
# Add migrations
git commit -m "feat: add user authentication tables"

# PR 2: API endpoints
git checkout -b feat/auth-api
# Add API logic
git commit -m "feat: add authentication API endpoints"

# PR 3: Frontend integration
git checkout -b feat/auth-frontend
# Add UI components
git commit -m "feat: add login UI components"
```

**If already large**:
```bash
# Option 1: Stack PRs
# Create dependent PRs that build on each other

# Base PR
git checkout -b feat/auth-part1
# ... changes ...
git push origin feat/auth-part1
gh pr create --base develop

# Part 2 builds on part 1
git checkout -b feat/auth-part2
# ... more changes ...
git push origin feat/auth-part2
gh pr create --base feat/auth-part1  # Note: base is part1, not develop

# Option 2: Feature flags
# Merge incomplete feature with flags
if (featureFlags.isEnabled('new-auth')) {
  // New code
} else {
  // Old code
}

# Option 3: Review in parts
# Add review comments like:
# "Part 1 (files 1-10): Database changes"
# "Part 2 (files 11-20): API layer"
# "Part 3 (files 21-30): Frontend"
```

**Guidelines**:
- **Ideal PR size**: < 250 lines changed
- **Maximum**: < 500 lines changed
- **If larger**: Break it down or add detailed explanation

**Q3: How do you implement a code review checklist?**

**Answer**:

**Automated Checklist** (in PR template):
```markdown
## Code Review Checklist

### Functionality
- [ ] Code accomplishes stated goal
- [ ] Edge cases handled
- [ ] Error handling implemented
- [ ] No obvious bugs

### Code Quality
- [ ] Code is readable and well-structured
- [ ] Follows project conventions
- [ ] No code duplication
- [ ] No commented-out code
- [ ] Complex logic has comments

### Testing
- [ ] Unit tests added/updated
- [ ] Tests cover edge cases
- [ ] All tests passing
- [ ] Test coverage maintained/improved

### Security
- [ ] No sensitive data in code
- [ ] Input validation implemented
- [ ] SQL injection prevented
- [ ] XSS vulnerabilities addressed
- [ ] Authentication/authorization correct

### Performance
- [ ] No performance regressions
- [ ] Database queries optimized
- [ ] No N+1 queries
- [ ] Caching used appropriately

### Documentation
- [ ] README updated if needed
- [ ] API docs updated
- [ ] Code comments added
- [ ] CHANGELOG updated

### Dependencies
- [ ] No unnecessary dependencies added
- [ ] Dependencies up to date
- [ ] Security vulnerabilities checked

### Deployment
- [ ] Database migrations reviewed
- [ ] Backward compatible
- [ ] Feature flags used if needed
- [ ] Rollback plan exists
```

**Enforce with GitHub Action**:
```yaml
# .github/workflows/pr-review-checklist.yml
name: PR Review Checklist

on:
  pull_request:
    types: [opened, edited]

jobs:
  check-description:
    runs-on: ubuntu-latest
    steps:
      - name: Check checklist completion
        uses: actions/github-script@v7
        with:
          script: |
            const pr = context.payload.pull_request;
            const body = pr.body || '';
            
            // Count checked items
            const checkedItems = (body.match(/- \[x\]/gi) || []).length;
            const totalItems = (body.match(/- \[ \]/gi) || []).length + checkedItems;
            
            if (totalItems === 0) {
              core.setFailed('PR description must include checklist from template');
            } else if (checkedItems < totalItems * 0.8) {
              core.warning(`Only ${checkedItems}/${totalItems} checklist items completed`);
            }
```

**Reviewer's checklist**:
```bash
# Script to help reviewers
#!/bin/bash

echo "=== Code Review Checklist ==="
echo ""
echo "1. Checkout PR branch"
gh pr checkout $1

echo "2. Check diff size"
git diff origin/develop --stat

echo "3. Run tests"
npm test

echo "4. Check for TODOs"
git diff origin/develop | grep -i "TODO\|FIXME"

echo "5. Check for console.logs"
git diff origin/develop | grep "console.log"

echo "6. Check security issues"
npm audit

echo "7. Check code coverage"
npm run test:coverage
```

**Q4: What are the different PR merge strategies and when to use each?**

**Answer**:

**1. Merge Commit** (`--merge`)
```bash
git merge feature/branch
# Creates merge commit preserving all history
```
```
main:    A---B---C-------M
              \         /
feature:       D---E---F
```

**When to use**:
- Want complete history
- Multiple developers on feature
- Need to preserve context
- Long-running feature branches

**Pros**: Complete history, easy to revert
**Cons**: Cluttered history, harder to read

**2. Squash and Merge** (`--squash`)
```bash
git merge --squash feature/branch
git commit -m "feat: new feature"
```
```
main:    A---B---C---S
              \
feature:       D---E---F (all commits squashed into S)
```

**When to use**:
- Clean history desired
- Feature branch has many WIP commits
- Want single atomic change
- Default for most teams

**Pros**: Clean history, easy to read
**Cons**: Loses granular history

**3. Rebase and Merge** (`--rebase`)
```bash
git rebase develop
git checkout develop
git merge feature/branch --ff-only
```
```
main:    A---B---C---D'---E'---F'
```

**When to use**:
- Want linear history
- Each commit is meaningful
- Commits are already clean
- Want to preserve individual commits

**Pros**: Linear history, preserves commits
**Cons**: Rewrites history (can cause conflicts)

**Comparison Table**:

| Strategy | History | Use Case | Revert |
|----------|---------|----------|--------|
| **Merge** | Complete | Long features | Easy (one commit) |
| **Squash** | Clean | Default | Easy (one commit) |
| **Rebase** | Linear | Meaningful commits | Medium (multiple) |

**GitHub Settings**:
```bash
# Allow all strategies
gh repo edit --enable-merge-commit --enable-squash-merge --enable-rebase-merge

# Set default
gh repo edit --default-branch-merge-type squash

# Require specific strategy per branch
# (Configure in branch protection rules via UI)
```

**Q5: How do you handle PR conflicts?**

**Answer**:

**Prevention**:
```bash
# Keep feature branch updated
git checkout feature/branch
git fetch origin
git rebase origin/develop  # or git merge origin/develop
```

**When conflicts occur**:

**Option 1: Rebase (recommended)**
```bash
# Update feature branch
git checkout feature/branch
git fetch origin
git rebase origin/develop

# Resolve conflicts
# Git will stop at first conflict
git status  # Shows conflicting files

# Edit conflicted files (look for markers)
# <<<<<<< HEAD
# Current branch code
# =======
# Incoming code
# >>>>>>> commit-message

# After fixing
git add <resolved-files>
git rebase --continue

# If stuck, abort
git rebase --abort

# Force push (updates PR)
git push --force-with-lease origin feature/branch
```

**Option 2: Merge**
```bash
# Merge develop into feature
git checkout feature/branch
git merge origin/develop

# Resolve conflicts
git add <resolved-files>
git commit -m "Merge develop into feature/branch"
git push origin feature/branch
```

**Option 3: Using GitHub UI**
```bash
# For simple conflicts, use GitHub's web editor
# Navigate to PR → "Resolve conflicts" button
# Edit in web UI → Mark as resolved → Commit
```

**Best Practices**:
- Update branches frequently
- Small, focused PRs (less conflict chance)
- Communicate with team about overlapping work
- Use feature flags for long-running features
- Prefer rebase for cleaner history

**Automatic conflict detection**:
```yaml
# .github/workflows/conflict-check.yml
name: Check for conflicts

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  check-conflicts:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Check for merge conflicts
        run: |
          git fetch origin ${{ github.base_ref }}
          if git merge-tree $(git merge-base HEAD origin/${{ github.base_ref }}) origin/${{ github.base_ref }} HEAD | grep -q '<<<<<<<'; then
            echo "::error::This PR has merge conflicts"
            exit 1
          fi
```

---
## Task 3.5: Issue Templates and Project Management

### Goal / Why It's Important

Structured issues ensure:
- **Complete information**: All necessary details captured upfront
- **Faster triage**: Quickly categorize and prioritize
- **Better tracking**: Consistent format for project management
- **User experience**: Guide users to provide useful information

Critical for maintaining organized development workflow.

### Prerequisites

- GitHub repository with issue access
- Understanding of issue workflow
- Team consensus on issue categories

### Step-by-Step Implementation

#### 1. Create Bug Report Template

```bash
# Create templates directory
mkdir -p .github/ISSUE_TEMPLATE

# Bug report template
cat > .github/ISSUE_TEMPLATE/bug_report.yml << 'EOF'
name: Bug Report
description: File a bug report to help us improve
title: "[BUG]: "
labels: ["bug", "triage"]
assignees:
  - octocat

body:
  - type: markdown
    attributes:
      value: |
        Thanks for taking the time to fill out this bug report!

  - type: input
    id: contact
    attributes:
      label: Contact Details
      description: How can we get in touch with you if we need more info?
      placeholder: ex. email@example.com
    validations:
      required: false

  - type: textarea
    id: what-happened
    attributes:
      label: What happened?
      description: Also tell us, what did you expect to happen?
      placeholder: Tell us what you see!
      value: "A bug happened!"
    validations:
      required: true

  - type: dropdown
    id: version
    attributes:
      label: Version
      description: What version of our software are you running?
      options:
        - 1.0.0
        - 1.1.0
        - 1.2.0 (Latest)
      default: 2
    validations:
      required: true

  - type: dropdown
    id: environment
    attributes:
      label: Environment
      description: Where did this bug occur?
      options:
        - Production
        - Staging
        - Development
        - Local
      multiple: false
    validations:
      required: true

  - type: dropdown
    id: browsers
    attributes:
      label: What browsers are you seeing the problem on?
      multiple: true
      options:
        - Firefox
        - Chrome
        - Safari
        - Microsoft Edge

  - type: textarea
    id: reproduction
    attributes:
      label: Reproduction Steps
      description: Please provide steps to reproduce the issue
      placeholder: |
        1. Go to '...'
        2. Click on '....'
        3. Scroll down to '....'
        4. See error
    validations:
      required: true

  - type: textarea
    id: logs
    attributes:
      label: Relevant log output
      description: Please copy and paste any relevant log output. This will be automatically formatted into code, so no need for backticks.
      render: shell

  - type: checkboxes
    id: terms
    attributes:
      label: Code of Conduct
      description: By submitting this issue, you agree to follow our [Code of Conduct](https://example.com)
      options:
        - label: I agree to follow this project's Code of Conduct
          required: true
EOF
```

#### 2. Create Feature Request Template

```bash
cat > .github/ISSUE_TEMPLATE/feature_request.yml << 'EOF'
name: Feature Request
description: Suggest an idea for this project
title: "[FEATURE]: "
labels: ["enhancement", "triage"]

body:
  - type: markdown
    attributes:
      value: |
        ## Feature Request
        Thanks for suggesting a new feature!

  - type: textarea
    id: problem
    attributes:
      label: Problem Description
      description: Is your feature request related to a problem? Please describe.
      placeholder: I'm always frustrated when...
    validations:
      required: true

  - type: textarea
    id: solution
    attributes:
      label: Proposed Solution
      description: Describe the solution you'd like
      placeholder: A clear and concise description of what you want to happen.
    validations:
      required: true

  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives Considered
      description: Describe alternatives you've considered
      placeholder: A clear and concise description of any alternative solutions or features you've considered.

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      description: How important is this feature to you?
      options:
        - Critical - Blocking work
        - High - Important for workflow
        - Medium - Nice to have
        - Low - Can work around it
    validations:
      required: true

  - type: textarea
    id: context
    attributes:
      label: Additional Context
      description: Add any other context or screenshots about the feature request here.

  - type: checkboxes
    id: implementation
    attributes:
      label: Are you willing to contribute to this feature?
      options:
        - label: Yes, I can submit a PR
        - label: I can help with testing
        - label: I can provide design input
EOF
```

#### 3. Create Configuration for Issue Templates

```bash
cat > .github/ISSUE_TEMPLATE/config.yml << 'EOF'
blank_issues_enabled: false
contact_links:
  - name: 💬 Community Support
    url: https://discord.gg/yourproject
    about: Join our Discord for community support and discussions
  - name: 📚 Documentation
    url: https://docs.yourproject.com
    about: Check our documentation for guides and references
  - name: 🔒 Security Issue
    url: https://github.com/yourorg/yourrepo/security/advisories/new
    about: Please report security vulnerabilities privately
EOF
```

#### 4. Create Additional Templates

```bash
# Performance issue template
cat > .github/ISSUE_TEMPLATE/performance.yml << 'EOF'
name: Performance Issue
description: Report a performance problem
title: "[PERF]: "
labels: ["performance", "triage"]

body:
  - type: textarea
    id: description
    attributes:
      label: Performance Issue Description
      description: Describe the performance problem you're experiencing
    validations:
      required: true

  - type: textarea
    id: metrics
    attributes:
      label: Performance Metrics
      description: Provide metrics (response time, memory usage, CPU, etc.)
      placeholder: |
        - Response time: 5 seconds (expected: < 1 second)
        - Memory usage: 2GB (expected: < 500MB)
        - CPU usage: 80% (expected: < 50%)
    validations:
      required: true

  - type: textarea
    id: reproduction
    attributes:
      label: Steps to Reproduce
      description: How can we reproduce this performance issue?
    validations:
      required: true

  - type: textarea
    id: profiling
    attributes:
      label: Profiling Data
      description: Attach any profiling data, flamegraphs, or performance traces
      render: shell
EOF

# Documentation update template
cat > .github/ISSUE_TEMPLATE/documentation.yml << 'EOF'
name: Documentation Update
description: Suggest improvements to documentation
title: "[DOCS]: "
labels: ["documentation"]

body:
  - type: dropdown
    id: doc-type
    attributes:
      label: Documentation Type
      options:
        - API Documentation
        - User Guide
        - Tutorial
        - README
        - Code Comments
        - Other
    validations:
      required: true

  - type: input
    id: location
    attributes:
      label: Documentation Location
      description: Which document needs updating?
      placeholder: docs/api/authentication.md
    validations:
      required: true

  - type: textarea
    id: issue
    attributes:
      label: What's wrong with the current documentation?
      description: Describe the issue with existing docs
    validations:
      required: true

  - type: textarea
    id: suggestion
    attributes:
      label: Suggested Improvement
      description: How should it be improved?
    validations:
      required: true
EOF
```

#### 5. Set Up GitHub Projects

```bash
# Create project via CLI
gh project create \
  --owner @me \
  --title "Development Sprint" \
  --body "Current sprint tasks and issues"

# Create project fields
gh project field-create PROJECT_NUMBER \
  --owner @me \
  --name "Status" \
  --data-type "SINGLE_SELECT" \
  --single-select-options "Todo,In Progress,In Review,Done"

gh project field-create PROJECT_NUMBER \
  --owner @me \
  --name "Priority" \
  --data-type "SINGLE_SELECT" \
  --single-select-options "Critical,High,Medium,Low"

gh project field-create PROJECT_NUMBER \
  --owner @me \
  --name "Sprint" \
  --data-type "TEXT"

# Link issue to project
gh issue create \
  --title "Implement user authentication" \
  --body "Add JWT-based authentication" \
  --label "enhancement" \
  --project "Development Sprint"
```

#### 6. Automate Issue Management

```yaml
# .github/workflows/issue-management.yml
name: Issue Management

on:
  issues:
    types: [opened, edited, labeled, assigned]

jobs:
  auto-label:
    runs-on: ubuntu-latest
    steps:
      - name: Label based on title
        uses: actions/github-script@v7
        with:
          script: |
            const issue = context.payload.issue;
            const title = issue.title.toLowerCase();
            let labels = [];
            
            if (title.includes('bug') || title.includes('error') || title.includes('fail')) {
              labels.push('bug');
            }
            if (title.includes('feature') || title.includes('add')) {
              labels.push('enhancement');
            }
            if (title.includes('docs') || title.includes('documentation')) {
              labels.push('documentation');
            }
            if (title.includes('perf') || title.includes('slow')) {
              labels.push('performance');
            }
            
            if (labels.length > 0) {
              await github.rest.issues.addLabels({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: issue.number,
                labels: labels
              });
            }

  auto-assign:
    runs-on: ubuntu-latest
    steps:
      - name: Auto-assign based on label
        uses: actions/github-script@v7
        with:
          script: |
            const issue = context.payload.issue;
            const labels = issue.labels.map(l => l.name);
            let assignees = [];
            
            if (labels.includes('frontend')) {
              assignees.push('frontend-lead');
            }
            if (labels.includes('backend')) {
              assignees.push('backend-lead');
            }
            if (labels.includes('infrastructure')) {
              assignees.push('devops-lead');
            }
            
            if (assignees.length > 0 && issue.assignees.length === 0) {
              await github.rest.issues.addAssignees({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: issue.number,
                assignees: assignees
              });
            }

  add-to-project:
    runs-on: ubuntu-latest
    steps:
      - name: Add issue to project board
        uses: actions/add-to-project@v0.5.0
        with:
          project-url: https://github.com/orgs/YOUR_ORG/projects/1
          github-token: ${{ secrets.PROJECT_TOKEN }}
          labeled: bug, enhancement
          label-operator: OR

  stale-issues:
    runs-on: ubuntu-latest
    steps:
      - name: Mark/Close Stale Issues
        uses: actions/stale@v8
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          stale-issue-message: 'This issue is stale because it has been open 30 days with no activity. Remove stale label or comment or this will be closed in 7 days.'
          close-issue-message: 'This issue was closed because it has been stalled for 7 days with no activity.'
          days-before-stale: 30
          days-before-close: 7
          stale-issue-label: 'stale'
          exempt-issue-labels: 'pinned,security,roadmap'
```

### Key Commands

```bash
# Create issue from CLI
gh issue create \
  --title "Bug: API returns 500 error" \
  --body "Description of bug..." \
  --label "bug" \
  --assignee @me

# Create issue with template
gh issue create --template bug_report.yml

# List issues
gh issue list --label "bug" --state open

# Update issue
gh issue edit 123 --add-label "priority:high" --add-assignee username

# Link PR to issue
gh pr create --title "Fix API error" --body "Fixes #123"

# Close issue
gh issue close 123 --comment "Fixed in PR #456"

# Reopen issue
gh issue reopen 123

# View issue
gh issue view 123

# Search issues
gh issue list --search "is:open label:bug sort:created-desc"

# Create project
gh project create --owner @me --title "Sprint 1"

# List projects
gh project list --owner @me

# Add issue to project
gh project item-add PROJECT_NUMBER --owner @me --url "https://github.com/owner/repo/issues/123"
```

### Verification

```bash
# Test issue creation
gh issue create --title "Test issue" --body "Testing templates"

# Verify templates exist
ls -la .github/ISSUE_TEMPLATE/

# Check if template is valid YAML
yamllint .github/ISSUE_TEMPLATE/*.yml

# View rendered template on GitHub
# Navigate to: https://github.com/owner/repo/issues/new/choose

# Test automation workflows
gh workflow run issue-management.yml
gh run watch
```

### Common Mistakes & Troubleshooting

**Issue**: Issue templates not showing up
```bash
# Check file location and names
# Must be in: .github/ISSUE_TEMPLATE/
# Valid extensions: .yml, .yaml, .md

# Check YAML syntax
yamllint .github/ISSUE_TEMPLATE/bug_report.yml

# Commit and push templates
git add .github/ISSUE_TEMPLATE/
git commit -m "Add issue templates"
git push origin main

# Wait a few minutes for GitHub to process
```

**Issue**: Automation not triggering
```bash
# Check workflow syntax
gh workflow view issue-management.yml

# Check workflow permissions
# Go to: Settings → Actions → General → Workflow permissions
# Should be: "Read and write permissions"

# View workflow runs
gh run list --workflow=issue-management.yml

# Check logs
gh run view <run-id> --log
```

**Issue**: Can't add issues to project
```bash
# Create personal access token with project scope
# Settings → Developer settings → Personal access tokens
# Scopes needed: repo, project

# Use token in workflow
# Add token to: Settings → Secrets → Actions
# Name: PROJECT_TOKEN

# Or use GitHub App token (recommended)
# Create GitHub App with project permissions
```

### Interview Questions

**Q1: How do you design effective issue templates?**

**Answer**:

**Key principles**:

1. **Required vs Optional Fields**
```yaml
- type: textarea
  id: description
  attributes:
    label: Bug Description
  validations:
    required: true  # Must be filled

- type: input
  id: contact
  validations:
    required: false  # Optional
```

2. **Field Types**
```yaml
# Text input (short)
- type: input
  id: title
  attributes:
    label: Title

# Text area (long)
- type: textarea
  id: description
  attributes:
    label: Description
    placeholder: Detailed description...

# Dropdown (single selection)
- type: dropdown
  id: priority
  attributes:
    options:
      - High
      - Medium
      - Low

# Checkboxes (multiple selection)
- type: checkboxes
  id: features
  attributes:
    options:
      - label: Feature A
      - label: Feature B
```

3. **Validation**
```yaml
- type: input
  id: email
  attributes:
    label: Email
  validations:
    required: true

- type: dropdown
  id: version
  attributes:
    options: ['1.0', '2.0']
  validations:
    required: true
```

4. **Good Defaults**
```yaml
- type: dropdown
  id: environment
  attributes:
    options:
      - Production
      - Staging
      - Development
    default: 2  # Development (index starts at 0)
```

**Best practices**:
- Keep it short (5-10 fields max)
- Use dropdowns to limit choices
- Provide examples in placeholders
- Make only essential fields required
- Test templates before deploying

**Q2: How do you implement issue triage workflow?**

**Answer**:

**Triage Process**:

```yaml
# .github/workflows/issue-triage.yml
name: Issue Triage

on:
  issues:
    types: [opened]

jobs:
  triage:
    runs-on: ubuntu-latest
    steps:
      # Step 1: Add triage label
      - name: Add triage label
        uses: actions/github-script@v7
        with:
          script: |
            await github.rest.issues.addLabels({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              labels: ['triage']
            });

      # Step 2: Validate required information
      - name: Check for required info
        uses: actions/github-script@v7
        with:
          script: |
            const issue = context.payload.issue;
            const body = issue.body || '';
            const hasReproSteps = body.includes('Reproduction Steps') || body.includes('Steps to reproduce');
            const hasVersion = body.includes('Version');
            
            if (!hasReproSteps || !hasVersion) {
              const comment = '⚠️ **Missing Information**\n\n' +
                'This issue is missing required information:\n' +
                (!hasReproSteps ? '- Reproduction steps\n' : '') +
                (!hasVersion ? '- Version information\n' : '') +
                '\nPlease update the issue with this information.';
              
              await github.rest.issues.createComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: issue.number,
                body: comment
              });
              
              await github.rest.issues.addLabels({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: issue.number,
                labels: ['needs-more-info']
              });
            }

      # Step 3: Auto-categorize
      - name: Auto-categorize by keywords
        uses: actions/github-script@v7
        with:
          script: |
            const issue = context.payload.issue;
            const title = issue.title.toLowerCase();
            const body = (issue.body || '').toLowerCase();
            const text = title + ' ' + body;
            
            let labels = [];
            let priority = 'medium';
            
            // Categorize by keywords
            if (text.match(/crash|critical|down|outage|data loss/)) {
              labels.push('critical');
              priority = 'critical';
            } else if (text.match(/security|vulnerability|exploit/)) {
              labels.push('security');
              priority = 'high';
            } else if (text.match(/performance|slow|timeout/)) {
              labels.push('performance');
            } else if (text.match(/ui|ux|frontend|design/)) {
              labels.push('frontend');
            } else if (text.match(/api|backend|database/)) {
              labels.push('backend');
            }
            
            // Add priority label
            labels.push(`priority:${priority}`);
            
            if (labels.length > 0) {
              await github.rest.issues.addLabels({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: issue.number,
                labels: labels
              });
            }

      # Step 4: Notify relevant team
      - name: Notify team
        uses: actions/github-script@v7
        with:
          script: |
            const issue = context.payload.issue;
            const labels = issue.labels.map(l => l.name);
            
            let mentions = [];
            if (labels.includes('critical')) {
              mentions.push('@org/oncall-team');
            }
            if (labels.includes('security')) {
              mentions.push('@org/security-team');
            }
            if (labels.includes('frontend')) {
              mentions.push('@org/frontend-team');
            }
            
            if (mentions.length > 0) {
              await github.rest.issues.createComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: issue.number,
                body: `🔔 ${mentions.join(' ')} - New issue requires attention`
              });
            }
```

**Triage Labels**:
- `triage` - Needs initial review
- `needs-more-info` - Insufficient information
- `duplicate` - Duplicate of existing issue
- `wontfix` - Not planned to fix
- `priority:critical/high/medium/low` - Priority level
- `good-first-issue` - Good for newcomers

**Q3: How do you manage issue lifecycle?**

**Answer**:

**Issue States and Transitions**:

```
New → Triaged → In Progress → In Review → Done → Closed
  ↓       ↓          ↓            ↓         ↓
Blocked  Needs Info  Stale       Duplicate  Wontfix
```

**Workflow Implementation**:

```yaml
# Project board automation
name: Issue Lifecycle

on:
  issues:
    types: [opened, assigned, labeled, closed]
  pull_request:
    types: [opened]

jobs:
  update-project:
    runs-on: ubuntu-latest
    steps:
      - name: Move to appropriate column
        uses: actions/github-script@v7
        with:
          script: |
            const issue = context.payload.issue;
            
            // Determine target column
            let column;
            if (issue.state === 'open') {
              if (issue.assignees.length > 0) {
                column = 'In Progress';
              } else if (issue.labels.find(l => l.name === 'triage')) {
                column = 'Triage';
              } else {
                column = 'To Do';
              }
            } else {
              column = 'Done';
            }
            
            // Move card (requires project API - complex, use GitHub App)
```

**Lifecycle Management Commands**:

```bash
# New issue
gh issue create --title "Bug" --label "bug,triage"

# Assign and move to "In Progress"
gh issue edit 123 --add-assignee username --remove-label "triage" --add-label "in-progress"

# Link to PR (moves to "In Review")
gh pr create --title "Fix bug" --body "Fixes #123"

# Close issue (moves to "Done")
gh issue close 123

# Reopen if needed
gh issue reopen 123

# Mark as duplicate
gh issue close 123 --comment "Duplicate of #456"
gh issue edit 123 --add-label "duplicate"

# Mark as wontfix
gh issue close 123 --comment "Not planned"
gh issue edit 123 --add-label "wontfix"
```

**Stale Issue Handling**:

```yaml
# .github/workflows/stale.yml
name: Close stale issues

on:
  schedule:
    - cron: '0 0 * * *'  # Daily

jobs:
  stale:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@v8
        with:
          stale-issue-message: |
            This issue has been automatically marked as stale because it has not had 
            recent activity. It will be closed if no further activity occurs within 7 days.
            Thank you for your contributions.
          close-issue-message: 'Closed due to inactivity.'
          days-before-stale: 60
          days-before-close: 7
          stale-issue-label: 'stale'
          exempt-issue-labels: 'pinned,security,in-progress'
          operations-per-run: 100
```

**Metrics and Reporting**:

```bash
# Script to generate issue metrics
#!/bin/bash

echo "=== Issue Metrics ==="

# Total open issues
echo "Open issues: $(gh issue list --state open --json number --jq 'length')"

# Issues by label
echo ""
echo "By Label:"
gh issue list --json labels --jq '.[] | .labels[].name' | sort | uniq -c | sort -rn

# Issues by priority
echo ""
echo "By Priority:"
gh issue list --label "priority:*" --json labels --jq '.[] | .labels[] | select(.name | startswith("priority:")) | .name' | sort | uniq -c

# Average time to close
echo ""
echo "Average time to close (days):"
gh issue list --state closed --limit 100 --json createdAt,closedAt --jq '[.[] | (((.closedAt | fromdateiso8601) - (.createdAt | fromdateiso8601)) / 86400)] | add / length'

# Stale issues
echo ""
echo "Stale issues (>30 days no activity):"
gh issue list --search "updated:<$(date -d '30 days ago' +%Y-%m-%d)" --json number --jq 'length'
```

---

## Task 3.6: Release Process with Tags and Changelogs

### Goal / Why It's Important

Structured releases ensure:
- **Version tracking**: Clear history of changes
- **Rollback capability**: Easy to revert to previous versions
- **Communication**: Users know what changed
- **Compliance**: Audit trail of releases

Essential for production deployments and user communication.

### Prerequisites

- Git repository with version control
- Understanding of semantic versioning
- CI/CD pipeline for releases

### Step-by-Step Implementation

#### 1. Set Up Semantic Versioning

**Version Format**: `MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]`

```bash
# Examples
1.0.0         # Major release
1.1.0         # Minor release (new features)
1.1.1         # Patch release (bug fixes)
1.0.0-alpha.1 # Pre-release
1.0.0+20240115.abc123  # With build metadata
```

**Versioning Rules**:
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)
- **PRERELEASE**: alpha, beta, rc (release candidate)

#### 2. Create Manual Release

```bash
# Update version in code
npm version 1.2.0 --no-git-tag-version
# Updates package.json automatically

# Or manually update
sed -i 's/"version": ".*"/"version": "1.2.0"/' package.json

# Create tag
git tag -a v1.2.0 -m "Release version 1.2.0

## Features
- Add user authentication
- Implement role-based access control

## Bug Fixes
- Fix memory leak in WebSocket connections
- Resolve race condition in cache updates

## Breaking Changes
- Remove deprecated API endpoints"

# Push tag
git push origin v1.2.0

# Create release on GitHub
gh release create v1.2.0 \
  --title "Release v1.2.0" \
  --notes "$(git tag -l --format='%(contents)' v1.2.0)" \
  --target main
```

#### 3. Automated Release with GitHub Actions

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - 'v*.*.*'

permissions:
  contents: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0  # Full history for changelog

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test

      - name: Build
        run: npm run build

      - name: Create artifacts
        run: |
          mkdir -p dist
          tar -czf dist/myapp-${{ github.ref_name }}.tar.gz -C build .
          zip -r dist/myapp-${{ github.ref_name }}.zip build

      - name: Generate changelog
        id: changelog
        uses: metcalfc/changelog-generator@v4.1.0
        with:
          myToken: ${{ secrets.GITHUB_TOKEN }}

      - name: Create Release
        uses: ncipollo/release-action@v1
        with:
          artifacts: "dist/*"
          body: ${{ steps.changelog.outputs.changelog }}
          token: ${{ secrets.GITHUB_TOKEN }}
          prerelease: ${{ contains(github.ref_name, '-alpha') || contains(github.ref_name, '-beta') }}
```

#### 4. Generate Changelog Automatically

**Using conventional-changelog**:

```bash
# Install tool
npm install --save-dev conventional-changelog-cli

# Add script to package.json
{
  "scripts": {
    "changelog": "conventional-changelog -p angular -i CHANGELOG.md -s -r 0"
  }
}

# Generate changelog
npm run changelog

# Changelog is generated from commit messages
# Requires conventional commits:
# feat: new feature
# fix: bug fix
# docs: documentation
# etc.
```

**Manual CHANGELOG.md Structure**:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New feature in development

### Changed
- Updates to existing feature

### Deprecated
- Features to be removed

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security patches

## [1.2.0] - 2024-01-15

### Added
- JWT authentication system (#123)
- Role-based access control (#124)
- User profile endpoints (#125)

### Changed
- Upgraded Node.js to v20 (#126)
- Improved error messages (#127)

### Fixed
- Memory leak in WebSocket connections (#128)
- Race condition in cache updates (#129)

### Security
- Patched SQL injection vulnerability (CVE-2024-1234)

## [1.1.0] - 2023-12-01

### Added
- WebSocket support
- Real-time notifications

### Fixed
- Login timeout issues

## [1.0.0] - 2023-11-01

### Added
- Initial release
- Basic REST API
- User management
- Database integration

[Unreleased]: https://github.com/owner/repo/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/owner/repo/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/owner/repo/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/owner/repo/releases/tag/v1.0.0
```

#### 5. Automated Versioning and Changelog

```yaml
# .github/workflows/release-please.yml
name: Release Please

on:
  push:
    branches:
      - main

permissions:
  contents: write
  pull-requests: write

jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      - uses: google-github-actions/release-please-action@v3
        id: release
        with:
          release-type: node
          package-name: myapp
          changelog-types: '[{"type":"feat","section":"Features","hidden":false},{"type":"fix","section":"Bug Fixes","hidden":false},{"type":"chore","section":"Miscellaneous","hidden":false}]'

      # Build and upload artifacts if release was created
      - uses: actions/checkout@v3
        if: ${{ steps.release.outputs.release_created }}

      - name: Build
        if: ${{ steps.release.outputs.release_created }}
        run: npm ci && npm run build

      - name: Upload Release Assets
        if: ${{ steps.release.outputs.release_created }}
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ steps.release.outputs.upload_url }}
          asset_path: ./dist/myapp.zip
          asset_name: myapp-${{ steps.release.outputs.tag_name }}.zip
          asset_content_type: application/zip
```

**How it works**:
1. Analyzes conventional commits since last release
2. Determines version bump (major/minor/patch)
3. Creates/updates release PR
4. When PR is merged, creates release and tag
5. Generates changelog automatically

#### 6. Pre-release and Release Channels

```bash
# Alpha release (unstable)
git tag -a v2.0.0-alpha.1 -m "Alpha release"
git push origin v2.0.0-alpha.1
gh release create v2.0.0-alpha.1 --prerelease --title "v2.0.0 Alpha 1"

# Beta release (feature complete, testing)
git tag -a v2.0.0-beta.1 -m "Beta release"
git push origin v2.0.0-beta.1
gh release create v2.0.0-beta.1 --prerelease --title "v2.0.0 Beta 1"

# Release candidate (final testing)
git tag -a v2.0.0-rc.1 -m "Release candidate"
git push origin v2.0.0-rc.1
gh release create v2.0.0-rc.1 --prerelease --title "v2.0.0 RC 1"

# Stable release
git tag -a v2.0.0 -m "Stable release"
git push origin v2.0.0
gh release create v2.0.0 --title "Version 2.0.0" --latest
```

### Key Commands

```bash
# List tags
git tag -l
git tag -l "v1.*"  # Filter tags

# View tag details
git show v1.2.0

# Delete tag
git tag -d v1.2.0                 # Local
git push origin --delete v1.2.0   # Remote

# List releases
gh release list

# View release
gh release view v1.2.0

# Download release assets
gh release download v1.2.0

# Edit release
gh release edit v1.2.0 --notes "Updated notes"

# Mark as latest
gh release edit v1.2.0 --latest

# Delete release
gh release delete v1.2.0

# Create release from existing tag
gh release create v1.2.0 --notes "Release notes" --title "Version 1.2.0"
```

### Verification

```bash
# Verify tag was created
git tag -l v1.2.0
git show v1.2.0

# Verify tag on remote
git ls-remote --tags origin

# Verify release on GitHub
gh release view v1.2.0

# Test download
gh release download v1.2.0 --pattern "*.tar.gz"

# Verify changelog
cat CHANGELOG.md

# Check version in code
cat package.json | jq '.version'
```

### Common Mistakes & Troubleshooting

**Issue**: Tag already exists
```bash
# Delete and recreate
git tag -d v1.2.0
git push origin --delete v1.2.0

# Create new tag
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0
```

**Issue**: Pushed wrong tag
```bash
# Delete from GitHub first
gh release delete v1.2.0 --yes
git push origin --delete v1.2.0

# Delete locally
git tag -d v1.2.0

# Recreate correctly
git tag -a v1.2.0 -m "Correct release"
git push origin v1.2.0
```

**Issue**: Changelog not generating
```bash
# Check commit format
git log --oneline
# Should see: "feat:", "fix:", etc.

# Install conventional-changelog
npm install --save-dev conventional-changelog-cli

# Generate manually
npx conventional-changelog -p angular -i CHANGELOG.md -s
```

**Issue**: Release workflow not triggering
```bash
# Check workflow file
cat .github/workflows/release.yml

# Verify tag pattern matches
# Workflow: tags: ['v*.*.*']
# Your tag: v1.2.0 ✓

# Check workflow runs
gh run list --workflow=release.yml

# Manual trigger if needed
gh workflow run release.yml
```

### Interview Questions

**Q1: Explain semantic versioning and when to bump each version number.**

**Answer**:

**Semantic Versioning (SemVer)**: `MAJOR.MINOR.PATCH`

**Examples**:

| Change Type | Current | New | Reasoning |
|-------------|---------|-----|-----------|
| **Bug fix** | 1.2.3 | 1.2.4 | PATCH - backward compatible fix |
| **New feature** | 1.2.4 | 1.3.0 | MINOR - new functionality, backward compatible |
| **Breaking change** | 1.3.0 | 2.0.0 | MAJOR - breaks backward compatibility |
| **Multiple fixes** | 2.0.0 | 2.0.1 | PATCH - multiple bug fixes |
| **Feature + fixes** | 2.0.1 | 2.1.0 | MINOR - new feature (fixes included) |

**Decision Tree**:
```
Does it break backward compatibility?
├─ Yes → MAJOR bump (1.0.0 → 2.0.0)
└─ No → Does it add new functionality?
    ├─ Yes → MINOR bump (1.0.0 → 1.1.0)
    └─ No → PATCH bump (1.0.0 → 1.0.1)
```

**Breaking Changes Examples**:
```javascript
// MAJOR version bump required

// 1. Removed function
- function getUser(id) { }  // Removed
+ // Use getUserById(id) instead

// 2. Changed function signature
- function saveUser(user) { }
+ function saveUser(user, options) { }  // Added required parameter

// 3. Changed return type
- function getUsers(): User[] { }
+ function getUsers(): Promise<User[]> { }

// 4. Renamed function/class
- class UserService { }
+ class UserManager { }

// 5. Changed behavior significantly
- function divide(a, b) { return a / b; }  // Returned Infinity for b=0
+ function divide(a, b) { if (b === 0) throw new Error(); }  // Now throws
```

**Non-Breaking (MINOR) Examples**:
```javascript
// MINOR version bump

// 1. New function
+ function getUserByEmail(email) { }

// 2. New optional parameter
function saveUser(user, options = {}) { }  // options is optional

// 3. New class/module
+ class AdminService { }
```

**Pre-release Versions**:
```
1.0.0-alpha.1   # Very unstable, testing new features
1.0.0-alpha.2
1.0.0-beta.1    # Feature complete, testing for bugs
1.0.0-beta.2
1.0.0-rc.1      # Release candidate, final testing
1.0.0-rc.2
1.0.0           # Stable release
```

**Q2: How do you manage changelogs effectively?**

**Answer**:

**Automated vs Manual Changelogs**:

**Automated (Recommended for large teams)**:
```bash
# Tool: conventional-changelog
npm install --save-dev conventional-changelog-cli

# Generate from conventional commits
npm run changelog

# Commits must follow format:
git commit -m "feat: add user authentication"
git commit -m "fix: resolve memory leak"
git commit -m "docs: update API documentation"
```

**Manual (Recommended for small teams or complex changes)**:
```markdown
# CHANGELOG.md

## [1.2.0] - 2024-01-15

### Added
- JWT authentication system for secure user sessions
  - Implements RS256 signing algorithm
  - Automatic token refresh before expiration
  - Supports multi-device sessions

### Changed
- **BREAKING**: Database connection pool settings
  - Minimum connections increased from 5 to 10
  - Required env var: `DB_POOL_MIN=10`
- Improved error messages with context codes

### Fixed
- Memory leak in WebSocket connections affecting long-running sessions
- Race condition causing duplicate cache entries under high load

### Security
- Patched SQL injection vulnerability in user search (CVE-2024-1234)
  - All user input now properly sanitized
  - Parameterized queries enforced

### Deprecated
- `/api/v1/users` endpoint (use `/api/v2/users` instead)
  - Will be removed in v2.0.0

## Migrations Required
```sql
ALTER TABLE users ADD COLUMN last_login TIMESTAMP;
CREATE INDEX idx_users_email ON users(email);
```

## Upgrade Guide
1. Update environment variables (see `.env.example`)
2. Run database migrations: `npm run migrate`
3. Restart application
4. Update API calls to v2 endpoints
```

**Best Practices**:
1. **Keep a Changelog format**: Standard, well-documented
2. **Group by type**: Added, Changed, Fixed, Deprecated, Removed, Security
3. **Include issue/PR numbers**: Easy to find details
4. **Add context**: Why the change matters
5. **Migration instructions**: Steps to upgrade
6. **Breaking changes**: Clearly marked
7. **Security fixes**: CVE numbers if applicable
8. **Date format**: ISO 8601 (YYYY-MM-DD)

**Tools**:
- conventional-changelog: Auto-generate from commits
- release-please: Auto-versioning and changelog
- github-changelog-generator: Generate from PRs and issues
- Manual: For complex releases with context

**Q3: How do you handle hotfixes in the release process?**

**Answer**:

**Hotfix Process**:

```bash
# Scenario: Production has v1.2.0, critical bug found

# 1. Branch from production tag
git checkout v1.2.0
git checkout -b hotfix/critical-fix

# 2. Apply minimal fix
# ... make changes ...
git add .
git commit -m "fix: patch critical security vulnerability

Fixes SQL injection in user search endpoint.
CVE-2024-5678"

# 3. Test thoroughly
npm test
npm run test:integration

# 4. Bump patch version
npm version patch  # 1.2.0 → 1.2.1

# 5. Create hotfix tag
git tag -a v1.2.1 -m "Hotfix: Security patch

## Fixed
- SQL injection vulnerability in user search (CVE-2024-5678)

## Testing
- All tests passing
- Verified on staging environment
- Security scan clean"

# 6. Push to repository
git push origin hotfix/critical-fix
git push origin v1.2.1

# 7. Create release
gh release create v1.2.1 \
  --title "🚨 Hotfix v1.2.1 - Security Patch" \
  --notes "**Critical security update**

## Security Fixes
- Patched SQL injection vulnerability (CVE-2024-5678)

## Upgrade
Deploy immediately. No breaking changes." \
  --latest

# 8. Merge hotfix back to main/develop
git checkout main
git merge hotfix/critical-fix
git push origin main

git checkout develop
git merge hotfix/critical-fix
git push origin develop

# 9. Delete hotfix branch
git branch -d hotfix/critical-fix
git push origin --delete hotfix/critical-fix

# 10. Deploy to production
# (via your CI/CD pipeline)
```

**Automated Hotfix Release**:

```yaml
# .github/workflows/hotfix-release.yml
name: Hotfix Release

on:
  push:
    branches:
      - 'hotfix/**'

jobs:
  hotfix:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Run tests
        run: |
          npm ci
          npm test
          npm run test:integration

      - name: Security scan
        run: npm audit --audit-level=high

      - name: Get current version
        id: version
        run: echo "current=$(cat package.json | jq -r '.version')" >> $GITHUB_OUTPUT

      - name: Bump patch version
        run: npm version patch --no-git-tag-version

      - name: Get new version
        id: new_version
        run: echo "new=v$(cat package.json | jq -r '.version')" >> $GITHUB_OUTPUT

      - name: Create tag
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add package.json
          git commit -m "chore: bump version to ${{ steps.new_version.outputs.new }}"
          git tag -a ${{ steps.new_version.outputs.new }} -m "Hotfix release"
          git push origin HEAD:main
          git push origin ${{ steps.new_version.outputs.new }}

      - name: Create release
        run: |
          gh release create ${{ steps.new_version.outputs.new }} \
            --title "🚨 Hotfix ${{ steps.new_version.outputs.new }}" \
            --notes "Critical hotfix from ${{ steps.version.outputs.current }} to ${{ steps.new_version.outputs.new }}" \
            --latest
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Notify team
        run: |
          # Send Slack notification
          curl -X POST ${{ secrets.SLACK_WEBHOOK }} \
            -H 'Content-Type: application/json' \
            -d '{"text":"🚨 Hotfix ${{ steps.new_version.outputs.new }} released"}'
```

**Hotfix Checklist**:
- [ ] Bug is critical (production down, data loss, security)
- [ ] Minimal changes (only fix the critical issue)
- [ ] Tests added/updated
- [ ] Security scan passed
- [ ] Tested on staging environment
- [ ] Changelog updated
- [ ] Team notified
- [ ] Merge back to all branches (main, develop)
- [ ] Monitor production after deployment

**Q4: How do you implement release notes automation?**

**Answer**:

**Using GitHub Actions**:

```yaml
# .github/workflows/release-notes.yml
name: Generate Release Notes

on:
  release:
    types: [created]

jobs:
  generate-notes:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Get previous tag
        id: previous_tag
        run: |
          PREV_TAG=$(git tag --sort=-creatordate | sed -n '2p')
          echo "tag=$PREV_TAG" >> $GITHUB_OUTPUT

      - name: Generate changelog
        id: changelog
        run: |
          CHANGELOG=$(git log ${{ steps.previous_tag.outputs.tag }}..${{ github.ref_name }} \
            --pretty=format:"- %s (%h)" \
            --no-merges)
          echo "changelog<<EOF" >> $GITHUB_OUTPUT
          echo "$CHANGELOG" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Categorize changes
        id: categorize
        uses: actions/github-script@v7
        with:
          script: |
            const changelog = process.env.CHANGELOG;
            const lines = changelog.split('\n');
            
            let features = [];
            let fixes = [];
            let breaking = [];
            let other = [];
            
            lines.forEach(line => {
              if (line.includes('feat:') || line.includes('feature:')) {
                features.push(line.replace(/.*feat(ure)?:\s*/, '- '));
              } else if (line.includes('fix:')) {
                fixes.push(line.replace(/.*fix:\s*/, '- '));
              } else if (line.includes('BREAKING')) {
                breaking.push(line);
              } else if (line.trim()) {
                other.push(line);
              }
            });
            
            let notes = '## Release Notes\n\n';
            
            if (breaking.length > 0) {
              notes += '### ⚠️ BREAKING CHANGES\n' + breaking.join('\n') + '\n\n';
            }
            
            if (features.length > 0) {
              notes += '### ✨ Features\n' + features.join('\n') + '\n\n';
            }
            
            if (fixes.length > 0) {
              notes += '### 🐛 Bug Fixes\n' + fixes.join('\n') + '\n\n';
            }
            
            if (other.length > 0) {
              notes += '### 📝 Other Changes\n' + other.join('\n') + '\n\n';
            }
            
            core.setOutput('notes', notes);
        env:
          CHANGELOG: ${{ steps.changelog.outputs.changelog }}

      - name: Update release
        run: |
          gh release edit ${{ github.ref_name }} \
            --notes "${{ steps.categorize.outputs.notes }}"
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Add contributors
        uses: actions/github-script@v7
        with:
          script: |
            const { data: commits } = await github.rest.repos.compareCommits({
              owner: context.repo.owner,
              repo: context.repo.repo,
              base: process.env.PREV_TAG,
              head: context.ref
            });
            
            const contributors = [...new Set(commits.commits.map(c => c.author.login))];
            const contributorsList = contributors.map(c => `@${c}`).join(', ');
            
            const currentNotes = await github.rest.repos.getReleaseByTag({
              owner: context.repo.owner,
              repo: context.repo.repo,
              tag: context.ref.replace('refs/tags/', '')
            });
            
            const updatedNotes = currentNotes.data.body + 
              `\n\n### 👥 Contributors\n${contributorsList}\n\nThank you!`;
            
            await github.rest.repos.updateRelease({
              owner: context.repo.owner,
              repo: context.repo.repo,
              release_id: currentNotes.data.id,
              body: updatedNotes
            });
        env:
          PREV_TAG: ${{ steps.previous_tag.outputs.tag }}
```

**Release Notes Template**:

```markdown
## What's Changed

### ✨ New Features
- Add OAuth2 authentication (#123) @user1
- Implement rate limiting (#124) @user2
- Add export to CSV functionality (#125) @user3

### 🐛 Bug Fixes
- Fix memory leak in WebSocket (#126) @user1
- Resolve race condition in cache (#127) @user2
- Fix incorrect date formatting (#128) @user3

### ⚠️ BREAKING CHANGES
- **API**: Removed deprecated `/api/v1` endpoints
  - Migration: Update all API calls to `/api/v2`
  - See migration guide: [docs/migration-v2.md](docs/migration-v2.md)

### 📚 Documentation
- Update API documentation (#129)
- Add deployment guide (#130)

### 🔧 Maintenance
- Upgrade dependencies to latest versions (#131)
- Improve test coverage to 85% (#132)

### 📦 Dependencies
- Upgrade React from 17 to 18
- Update Node.js requirement to >=18

## Upgrade Instructions

```bash
# 1. Update dependencies
npm install myapp@latest

# 2. Run migrations
npm run migrate

# 3. Update configuration
# Add new env vars to .env:
API_VERSION=v2
RATE_LIMIT_MAX=100
```

## Full Changelog
https://github.com/owner/repo/compare/v1.1.0...v1.2.0

## Downloads
- [Source code (zip)](link)
- [Source code (tar.gz)](link)
- [Binary for Linux](link)
- [Binary for macOS](link)
- [Binary for Windows](link)

## Contributors
@user1, @user2, @user3, @user4, @user5

Thank you to all our contributors! 🎉
```

**Automated Tools**:
1. **release-please**: Auto-generates based on conventional commits
2. **semantic-release**: Full automation (version, changelog, release)
3. **conventional-changelog**: Generate changelog from commits
4. **github-changelog-generator**: Uses PR and issue data

**Best Practices**:
- **Consistent format**: Same structure every release
- **Emoji/Icons**: Visual categorization (✨ features, 🐛 bugs)
- **Links**: PRs, issues, commits for details
- **Contributors**: Recognize contributions
- **Upgrade instructions**: Clear migration steps
- **Breaking changes**: Highlighted prominently
- **Downloads**: Easy access to artifacts

---

(continuing with tasks 3.7-3.10...)
## Task 3.7: CODEOWNERS Implementation

[Note: This task was already covered in detail in Task 3.1, Q5. See above for complete CODEOWNERS implementation]

---

## Task 3.8: Semantic Versioning Implementation

[Note: This task was already covered in detail in Task 3.6, Q1. See above for complete Semantic Versioning guide]

---

## Task 3.9: GitHub Security Features (Dependabot, Code Scanning)

### Goal / Why It's Important

Security automation ensures:
- **Vulnerability detection**: Auto-discover security issues
- **Dependency updates**: Keep dependencies secure and up-to-date
- **Code analysis**: Find security flaws before deployment
- **Compliance**: Meet security standards

Critical for production security.

### Prerequisites

- GitHub repository with admin access
- Understanding of security concepts
- CI/CD pipeline configured

### Step-by-Step Implementation

#### 1. Enable Dependabot

```yaml
# .github/dependabot.yml
version: 2
updates:
  # Enable version updates for npm
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
    open-pull-requests-limit: 10
    reviewers:
      - "security-team"
    assignees:
      - "lead-developer"
    labels:
      - "dependencies"
      - "security"
    commit-message:
      prefix: "chore"
      include: "scope"
    # Group updates
    groups:
      development-dependencies:
        dependency-type: "development"
      production-dependencies:
        dependency-type: "production"

  # Docker dependencies
  - package-ecosystem: "docker"
    directory: "/"
    schedule:
      interval: "weekly"

  # GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    commit-message:
      prefix: "ci"
```

#### 2. Enable Security Scanning

```yaml
# .github/workflows/codeql-analysis.yml
name: "CodeQL"

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write

    strategy:
      fail-fast: false
      matrix:
        language: [ 'javascript', 'python' ]

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Initialize CodeQL
        uses: github/codeql-action/init@v2
        with:
          languages: ${{ matrix.language }}
          queries: security-and-quality

      - name: Autobuild
        uses: github/codeql-action/autobuild@v2

      - name: Perform CodeQL Analysis
        uses: github/codeql-action/analyze@v2
```

#### 3. Secret Scanning

```bash
# Enable via GitHub UI:
# Repository → Settings → Security → Secret scanning

# Or via GitHub CLI:
gh api repos/:owner/:repo/secret-scanning/alerts

# Configure push protection
gh api repos/:owner/:repo \
  --method PATCH \
  --field security_and_analysis='{"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}'
```

#### 4. Security Policy

```markdown
# .github/SECURITY.md
# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.x.x   | :white_check_mark: |
| 1.9.x   | :white_check_mark: |
| 1.8.x   | :x:                |
| < 1.8   | :x:                |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via:
- Email: security@example.com
- GitHub Security Advisories: [Create advisory](https://github.com/owner/repo/security/advisories/new)

You should receive a response within 48 hours. If not, please follow up.

## Security Update Process

1. Security team triages report
2. Fix developed privately
3. CVE assigned if applicable
4. Security advisory published
5. Patch released
6. Public disclosure

## Bug Bounty Program

We offer rewards for valid security reports:
- Critical: $500-$1000
- High: $250-$500
- Medium: $100-$250
- Low: Recognition
```

### Key Commands

```bash
# View Dependabot alerts
gh api repos/:owner/:repo/dependabot/alerts

# View security advisories
gh api repos/:owner/:repo/security-advisories

# Create security advisory
gh api repos/:owner/:repo/security-advisories \
  --method POST \
  --field summary="SQL Injection vulnerability" \
  --field description="..." \
  --field severity="high"

# View CodeQL alerts
gh api repos/:owner/:repo/code-scanning/alerts
```

---

## Task 3.10: GitHub Environments for Deployment Control

### Goal / Why It's Important

Environment protection ensures:
- **Controlled deployments**: Require approvals before production
- **Environment-specific secrets**: Separate configs per environment
- **Deployment tracking**: History of what was deployed when
- **Compliance**: Audit trail for deployments

Essential for production safety.

### Prerequisites

- GitHub repository with deployments
- Understanding of CI/CD pipelines
- Team structure defined

### Step-by-Step Implementation

#### 1. Create Environments via GitHub UI

```
Repository → Settings → Environments → New environment

Environments to create:
- development
- staging
- production
```

#### 2. Configure Environment Protection

**Production Environment**:
```
Environment name: production

Protection rules:
☑ Required reviewers: 2
  Select: @org/platform-leads, @org/security-team

☑ Wait timer: 30 minutes
  (Cool-down period before deployment)

☑ Deployment branches: Selected branches
  - main

Environment secrets:
- DATABASE_URL
- API_KEY
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
```

**Staging Environment**:
```
Environment name: staging

Protection rules:
☑ Required reviewers: 1
  Select: @org/qa-team

Deployment branches:
  - main
  - develop

Environment secrets:
- DATABASE_URL (staging DB)
- API_KEY (staging keys)
```

#### 3. Use Environments in Workflows

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [ main, develop ]

jobs:
  deploy-staging:
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    environment:
      name: staging
      url: https://staging.example.com
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to staging
        run: |
          echo "Deploying to staging..."
          # Use environment secrets
          echo "DB: ${{ secrets.DATABASE_URL }}"
        env:
          API_KEY: ${{ secrets.API_KEY }}

  deploy-production:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://example.com
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to production
        run: |
          echo "Deploying to production..."
          # This will wait for manual approval
        env:
          API_KEY: ${{ secrets.API_KEY }}
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

### Key Commands

```bash
# View deployments
gh api repos/:owner/:repo/deployments

# Create deployment
gh api repos/:owner/:repo/deployments \
  --method POST \
  --field ref="main" \
  --field environment="production" \
  --field description="Deploy v1.2.0"

# View deployment status
gh api repos/:owner/:repo/deployments/:deployment_id/statuses
```

### Verification

```bash
# Test deployment workflow
git checkout main
git tag v1.0.0
git push origin v1.0.0

# Check if approval required
gh run list --workflow=deploy.yml
gh run view <run-id>

# Approve deployment (via GitHub UI)
# Repository → Actions → Select run → Review deployments → Approve
```

---

**🎉 Congratulations!** You've completed all GitHub tasks covering repository management, workflows, security, and deployment controls.

---

Continue to [Part 4: Ansible Configuration Management](../part-04-ansible/README.md)
