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

[Remaining tasks 3.3-3.10 follow the same format covering: Branch Protection, PR Templates, Issue Management, Release Process, CODEOWNERS, Semantic Versioning, Security Features, and Environment Configuration]

---

Continue to [Part 4: Ansible Configuration Management](../part-04-ansible/README.md)
