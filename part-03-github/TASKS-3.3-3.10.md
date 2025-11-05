# Part 3: GitHub Repository & Workflows - Tasks 3.3-3.10

This document contains detailed implementations for GitHub tasks 3.3 through 3.10.

---

## Task 3.3: Configure Branch Protection and Required Reviews

### Goal / Why It's Important

Branch protection prevents:
- **Direct commits to main**: Enforce pull request workflow
- **Unreviewed code**: Require peer review
- **Broken builds**: Require passing CI before merge
- **Force pushes**: Protect history

Critical for team collaboration and code quality.

### Prerequisites

- GitHub repository with admin access
- GitHub CLI (`gh`) installed
- Understanding of Git branches
- Team members added to repository

### Step-by-Step Implementation

#### 1. Configure Branch Protection via GitHub CLI

```bash
# Install GitHub CLI
# macOS
brew install gh

# Linux
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Authenticate
gh auth login
```

#### 2. Enable Branch Protection for Main

```bash
# Basic protection
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_pull_request_reviews='{"required_approving_review_count":2}' \
  --field enforce_admins=true \
  --field required_linear_history=true

# With status checks
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --input - << 'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "ci/build",
      "ci/test",
      "ci/lint",
      "security/scan"
    ]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismissal_restrictions": {
      "users": [],
      "teams": ["admins"]
    },
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 2,
    "require_last_push_approval": false
  },
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_conversation_resolution": true,
  "lock_branch": false,
  "allow_fork_syncing": true
}
EOF
```

#### 3. Configure Different Rules for Different Branches

```bash
# Protect develop branch (less strict)
gh api repos/:owner/:repo/branches/develop/protection \
  --method PUT \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field required_status_checks='{"strict":true,"contexts":["ci/build"]}'

# Protect release branches
gh api repos/:owner/:repo/branches/release/*/protection \
  --method PUT \
  --field required_pull_request_reviews='{"required_approving_review_count":2}' \
  --field enforce_admins=true
```

#### 4. Set Up CODEOWNERS File

```bash
# Create CODEOWNERS file
cat > .github/CODEOWNERS << 'EOF'
# Default owners for everything
* @org/platform-team

# Frontend code
/frontend/ @org/frontend-team
*.tsx @org/frontend-team
*.jsx @org/frontend-team

# Backend code
/backend/ @org/backend-team
*.go @org/backend-team
*.java @org/backend-team

# Infrastructure
/terraform/ @org/sre-team @org/security-team
/kubernetes/ @org/sre-team
/ansible/ @org/sre-team
*.tf @org/sre-team
*.yaml @org/devops-team
*.yml @org/devops-team

# CI/CD
/.github/workflows/ @org/devops-team
Jenkinsfile @org/devops-team

# Database
/migrations/ @org/backend-team @org/dba-team
*.sql @org/dba-team

# Security-sensitive
/secrets/ @org/security-team
*.key @org/security-team
*.pem @org/security-team

# Documentation
/docs/ @org/tech-writers
*.md @org/tech-writers

# Package dependencies
package.json @org/platform-team @org/security-team
go.mod @org/platform-team @org/security-team
requirements.txt @org/platform-team @org/security-team
Gemfile @org/platform-team @org/security-team
EOF

git add .github/CODEOWNERS
git commit -m "Add CODEOWNERS file"
git push origin main
```

#### 5. Configure Rulesets (New GitHub Feature)

```bash
# Create ruleset via API
gh api repos/:owner/:repo/rulesets \
  --method POST \
  --input - << 'EOF'
{
  "name": "main-branch-protection",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main"],
      "exclude": []
    }
  },
  "rules": [
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 2,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": true,
        "require_last_push_approval": false
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": true,
        "required_status_checks": [
          {"context": "ci/build"},
          {"context": "ci/test"},
          {"context": "security/scan"}
        ]
      }
    },
    {
      "type": "non_fast_forward"
    },
    {
      "type": "required_signatures"
    }
  ]
}
EOF
```

### Key Commands Summary

```bash
# View branch protection
gh api repos/:owner/:repo/branches/main/protection

# Remove branch protection
gh api repos/:owner/:repo/branches/main/protection --method DELETE

# List protected branches
gh api repos/:owner/:repo/branches --jq '.[] | select(.protected==true) | .name'

# Check if CODEOWNERS is configured
gh api repos/:owner/:repo/contents/.github/CODEOWNERS

# Test branch protection (should fail)
git checkout main
echo "test" >> README.md
git commit -am "Direct commit"
git push  # Should be rejected
```

### Verification

#### 1. Test Branch Protection

```bash
# Try to push directly to main (should fail)
git checkout main
echo "test" >> test.txt
git add test.txt
git commit -m "test direct push"
git push origin main
# Expected: remote: error: GH006: Protected branch update failed

# Create PR instead (correct way)
git checkout -b test-branch
echo "test" >> test.txt
git add test.txt
git commit -m "test via PR"
git push origin test-branch
gh pr create --base main --title "Test PR"
```

#### 2. Verify Required Reviews

```bash
# Create PR and try to merge without reviews
gh pr create --base main --title "Test required reviews"

# Try to merge (should fail)
gh pr merge --squash
# Expected: Required reviews not met

# Get approvals, then merge
gh pr review --approve
gh pr merge --squash
```

#### 3. Test Status Checks

```bash
# PR must have passing CI
gh pr create --base main --title "Test status checks"

# Check status
gh pr checks

# Cannot merge until all checks pass
gh pr merge --squash
# Expected: Required status checks must pass
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Locking Yourself Out

**Problem**: Set protection rules too strict, can't make emergency changes

**Solution**:
```bash
# Temporarily disable enforcement for admins
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field enforce_admins=false

# Make emergency change

# Re-enable
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field enforce_admins=true
```

#### Mistake 2: CODEOWNERS Syntax Errors

**Problem**: CODEOWNERS not working, no owners assigned

**Solution**:
```bash
# Validate CODEOWNERS
# Each line should be: path @owner
# Not: path owner (missing @)

# Test with GitHub's validator
gh api repos/:owner/:repo/contents/.github/CODEOWNERS \
  | jq -r '.content' | base64 -d

# Common issues:
# - Missing @ before username
# - Team name without org: @team instead of @org/team
# - Invalid path patterns
```

#### Mistake 3: Required Checks Don't Exist

**Problem**: Branch requires status check "ci/build" but workflow never runs

**Solution**:
```bash
# List available status checks
gh api repos/:owner/:repo/commits/main/status | jq '.statuses[].context'

# Update protection to match actual checks
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field 'required_status_checks.contexts[]=actual-check-name'
```

### Interview Questions with Answers

#### Q1: What's the difference between branch protection and rulesets?

**Answer**:

**Branch Protection Rules** (Legacy):
- Per-branch configuration
- Applied to specific branch patterns
- Less flexible
- UI-based configuration

**Rulesets** (New):
- Can target branches, tags, or both
- More powerful conditions
- Can apply to multiple patterns
- Better organization for large repos
- Support for bypass actors

Example ruleset:
```json
{
  "name": "production-protection",
  "target": "branch",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main", "refs/heads/release/*"]
    }
  },
  "rules": [
    {"type": "pull_request"},
    {"type": "required_status_checks"},
    {"type": "non_fast_forward"}
  ]
}
```

**Recommendation**: Use rulesets for new configurations, they're more powerful and future-proof.

#### Q2: How do you handle emergency hotfixes with strict branch protection?

**Answer**:

**Option 1: Bypass protection (use sparingly)**
```bash
# Admin can temporarily disable enforcement
gh api repos/:owner/:repo/branches/main/protection \
  --method PATCH \
  --field enforce_admins=false

# Make hotfix
# Re-enable immediately
```

**Option 2: Fast-track PR with reduced requirements**
```bash
# Create hotfix PR
git checkout -b hotfix/critical-security-fix main
# Make fix
git push origin hotfix/critical-security-fix
gh pr create --base main --label hotfix

# Senior engineers can approve immediately
# Merge even if some non-critical checks fail
gh pr merge --admin --squash
```

**Option 3: Use bypass actors (rulesets)**
```json
{
  "bypass_actors": [
    {
      "actor_id": 5,
      "actor_type": "Team",
      "bypass_mode": "always"
    }
  ]
}
```

**Best practice**:
- Have documented escalation process
- Audit log review after bypass
- Follow up with proper process

#### Q3: How does CODEOWNERS work with required reviews?

**Answer**:

When `require_code_owner_reviews` is enabled:

```
# .github/CODEOWNERS
/frontend/ @org/frontend-team
/backend/ @org/backend-team
*.tf @org/sre-team
```

**Behavior**:
- PR changing `/frontend/app.js` requires approval from `@org/frontend-team`
- PR changing `/backend/api.go` requires approval from `@org/backend-team`
- PR changing `main.tf` requires approval from `@org/sre-team`
- PR changing multiple areas requires approval from ALL relevant teams

**Example**:
```bash
# PR changes both frontend and terraform
git add frontend/app.js infrastructure/main.tf
git commit -m "Update app and infrastructure"

# Requires approvals from:
# 1. @org/frontend-team
# 2. @org/sre-team
# Before merge is allowed
```

**Order of evaluation**:
1. Most specific pattern wins
2. Multiple patterns = multiple required approvals
3. Patterns are cumulative

#### Q4: What are required status checks and how do you configure them?

**Answer**:

Required status checks are CI/CD jobs that must pass before PR merge:

```bash
# Configure required checks
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field 'required_status_checks.strict=true' \
  --field 'required_status_checks.contexts[]=ci/build' \
  --field 'required_status_checks.contexts[]=ci/test' \
  --field 'required_status_checks.contexts[]=security/scan'
```

**Strict mode** (`strict: true`):
- Branch must be up-to-date with base before merge
- Forces `git pull` or rebase before merge
- Prevents "merge skew" issues

**Non-strict mode** (`strict: false`):
- Checks run on PR commit, not on merged result
- Faster but less safe
- Can have passing PR that breaks main

**GitHub Actions example**:
```yaml
# .github/workflows/ci.yml
name: CI
on: [pull_request]

jobs:
  build:
    name: ci/build  # This becomes the status check name
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm ci
      - run: npm run build
      
  test:
    name: ci/test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm ci
      - run: npm test
```

**Best practices**:
- Use strict mode for main/production
- Keep required checks focused (fast feedback)
- Have optional checks for slower tests
- Don't require flaky checks

#### Q5: How do you manage branch protection across multiple repositories?

**Answer**:

**Option 1: GitHub API script**
```bash
#!/bin/bash
# apply-protection.sh

REPOS=(
    "org/repo1"
    "org/repo2"
    "org/repo3"
)

PROTECTION_CONFIG='{
  "required_status_checks": {
    "strict": true,
    "contexts": ["ci/build", "ci/test"]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 2
  }
}'

for repo in "${REPOS[@]}"; do
    echo "Applying protection to $repo"
    gh api "repos/$repo/branches/main/protection" \
        --method PUT \
        --input - <<< "$PROTECTION_CONFIG"
done
```

**Option 2: Terraform**
```hcl
# github-repos.tf
resource "github_branch_protection" "main" {
  for_each = toset(var.repositories)
  
  repository_id = each.value
  pattern       = "main"
  
  required_status_checks {
    strict   = true
    contexts = ["ci/build", "ci/test"]
  }
  
  required_pull_request_reviews {
    required_approving_review_count = 2
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
  }
  
  enforce_admins = true
}
```

**Option 3: GitHub Enterprise - Organization rules**
- Set default rules at org level
- New repos inherit rules
- Centralized management

---

## Task 3.4: Pull Request Workflow and Templates

### Goal / Why It's Important

Structured PR workflow ensures:
- **Consistent information**: All PRs have necessary context
- **Faster reviews**: Reviewers know what to look for
- **Quality gates**: Checklist ensures nothing is forgotten
- **Documentation**: PRs serve as change log

Essential for team collaboration.

### Prerequisites

- GitHub repository access
- Understanding of pull request process
- Git basics

### Step-by-Step Implementation

#### 1. Create PR Template

```bash
# Create PR template directory
mkdir -p .github/PULL_REQUEST_TEMPLATE

# Default PR template
cat > .github/pull_request_template.md << 'EOF'
## Description

<!--- Provide a brief description of your changes -->

## Type of Change

<!--- Check the type of change your PR introduces -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring
- [ ] Configuration change
- [ ] Dependencies update

## Related Issues

<!--- Link to related issues -->
<!--- Use "Closes #123" to auto-close issues when PR merges -->

Closes #
Related to #

## Changes Made

<!--- Describe your changes in detail -->
<!--- Why is this change required? What problem does it solve? -->

### Frontend Changes
- 

### Backend Changes
- 

### Database Changes
- [ ] Migrations included
- [ ] Rollback script provided
- [ ] Data migration tested

### Infrastructure Changes
- 

## Testing Performed

<!--- Describe the tests you ran to verify your changes -->

### Unit Tests
- [ ] All new code has unit tests
- [ ] All tests pass locally
- [ ] Coverage meets requirements (>80%)

### Integration Tests
- [ ] Integration tests added/updated
- [ ] All integration tests pass

### Manual Testing
- [ ] Tested on local environment
- [ ] Tested on dev/staging environment
- [ ] Tested on multiple browsers/devices (if frontend)

### Test Evidence
<!--- Add screenshots, logs, or test results -->

```
# Test commands run
npm test
npm run test:integration
```

## Deployment Notes

<!--- Any special deployment instructions? -->

### Breaking Changes
<!--- List any breaking changes and migration path -->

### Environment Variables
<!--- New env vars required -->
```bash
NEW_VAR=value
ANOTHER_VAR=value
```

### Dependencies
<!--- New dependencies added -->
- Dependency X v1.2.3 (reason)

### Rollback Plan
<!--- How to rollback if issues occur -->

1. 
2. 

## Documentation

- [ ] README updated
- [ ] API documentation updated
- [ ] Inline comments added for complex logic
- [ ] Changelog updated

## Pre-Merge Checklist

### Code Quality
- [ ] Code follows project style guide
- [ ] No console.log or debug statements
- [ ] No commented-out code
- [ ] Error handling implemented
- [ ] Input validation added where necessary

### Security
- [ ] No secrets or credentials in code
- [ ] Security best practices followed
- [ ] Dependencies scanned for vulnerabilities
- [ ] Authentication/Authorization handled correctly

### Performance
- [ ] No performance regressions
- [ ] Database queries optimized
- [ ] Caching implemented where appropriate

### Review
- [ ] Self-review completed
- [ ] Code reviewed by at least 2 team members
- [ ] All review comments addressed
- [ ] CI/CD pipeline passes

## Screenshots/Videos

<!--- Add screenshots or videos demonstrating the changes -->

### Before
<!--- Screenshot/video of current behavior -->

### After
<!--- Screenshot/video of new behavior -->

## Additional Context

<!--- Add any other context about the PR here -->

## Reviewer Notes

<!--- Specific areas you want reviewers to focus on -->

Please pay special attention to:
- 
- 

---

**For Reviewers:**
- [ ] Code logic is sound
- [ ] Tests are comprehensive
- [ ] Documentation is clear
- [ ] No security concerns
- [ ] Performance is acceptable
EOF
```

#### 2. Create Multiple PR Templates

```bash
# Feature template
cat > .github/PULL_REQUEST_TEMPLATE/feature.md << 'EOF'
## Feature Description

### What does this feature do?

### Why is this feature needed?

### How does it work?

## Implementation Details

### Architecture Changes

### Database Schema Changes

### API Changes

## Testing
- [ ] Unit tests added
- [ ] Integration tests added
- [ ] Manual testing completed

## Documentation
- [ ] README updated
- [ ] API docs updated
- [ ] User guide updated
EOF

# Bugfix template
cat > .github/PULL_REQUEST_TEMPLATE/bugfix.md << 'EOF'
## Bug Description

### What was the bug?

### How to reproduce?

1. 
2. 
3. 

### Expected behavior

### Actual behavior

## Root Cause

### Why did this happen?

## Fix Description

### How does this fix solve the problem?

## Testing
- [ ] Bug no longer reproducible
- [ ] Regression tests added
- [ ] Edge cases tested

## Related Issues
Fixes #
EOF

# Hotfix template
cat > .github/PULL_REQUEST_TEMPLATE/hotfix.md << 'EOF'
## 🚨 HOTFIX - Urgent Production Issue 🚨

### Severity
- [ ] Critical (Complete outage)
- [ ] High (Major functionality broken)
- [ ] Medium (Significant issue affecting users)

### Issue Description

### Impact
- Number of users affected:
- Revenue impact:
- SLA breach: Yes/No

### Root Cause

### Fix Description

### Rollback Plan

### Post-Deployment Verification
1. 
2. 
3. 

### Follow-up Actions
- [ ] Create ticket for permanent fix
- [ ] Update monitoring/alerting
- [ ] Document in postmortem

## Approvals Required
- [ ] Tech Lead
- [ ] Engineering Manager
- [ ] On-call Engineer
EOF
```

#### 3. Configure PR Settings in Repository

```bash
# Enable auto-delete of head branches
gh api repos/:owner/:repo \
  --method PATCH \
  --field delete_branch_on_merge=true

# Configure merge options
gh api repos/:owner/:repo \
  --method PATCH \
  --field allow_squash_merge=true \
  --field allow_merge_commit=false \
  --field allow_rebase_merge=true \
  --field squash_merge_commit_message=PR_BODY \
  --field squash_merge_commit_title=PR_TITLE
```

#### 4. Create PR Creation Script

```bash
cat > scripts/create-pr.sh << 'EOF'
#!/bin/bash
set -euo pipefail

# PR creation helper script

# Check if on a branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" == "main" ]] || [[ "$current_branch" == "develop" ]]; then
    echo "Error: Cannot create PR from $current_branch"
    exit 1
fi

# Get PR type
echo "Select PR type:"
echo "1) Feature"
echo "2) Bugfix"
echo "3) Hotfix"
read -p "Choice: " choice

case $choice in
    1) template="feature" ;;
    2) template="bugfix" ;;
    3) template="hotfix" ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

# Create PR with template
gh pr create \
    --template "$template.md" \
    --web
EOF

chmod +x scripts/create-pr.sh
```

### Key Commands Summary

```bash
# Create PR with default template
gh pr create --base main --head feature-branch

# Create PR with specific template
gh pr create --template feature.md

# Create draft PR
gh pr create --draft

# Convert draft to ready
gh pr ready

# Request reviews
gh pr edit --add-reviewer @user1,@user2

# Add labels
gh pr edit --add-label bug,urgent

# Link to issue
gh pr edit --body "Closes #123"

# List open PRs
gh pr list

# View PR status
gh pr status

# View PR diff
gh pr diff 123

# Checkout PR locally
gh pr checkout 123
```

### Verification

```bash
# Test PR template
git checkout -b test-pr-template
echo "test" >> test.txt
git add test.txt
git commit -m "test PR template"
git push origin test-pr-template
gh pr create

# Verify template appears in PR description

# Clean up
gh pr close
git checkout main
git branch -D test-pr-template
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Template Not Appearing

**Problem**: PR template not showing when creating PR

**Solution**:
```bash
# Check template location
ls -la .github/pull_request_template.md
ls -la .github/PULL_REQUEST_TEMPLATE/

# Template must be in one of these locations:
# - .github/pull_request_template.md (default)
# - .github/PULL_REQUEST_TEMPLATE/template_name.md (multiple)
# - docs/pull_request_template.md (alternative)

# Ensure committed and pushed
git add .github/pull_request_template.md
git commit -m "Add PR template"
git push
```

#### Mistake 2: Poorly Written PR Descriptions

**Problem**: PRs lack context, hard to review

**Solution**: Use template checklist
- What: Describe changes
- Why: Explain reasoning
- How: Implementation details
- Testing: How verified
- Impact: What's affected

### Interview Questions with Answers

#### Q1: What makes a good pull request?

**Answer**:

**Size**:
- Small and focused (< 400 lines changed)
- Single responsibility
- Atomic changes

**Description**:
- Clear title summarizing change
- Context (why this change?)
- Implementation details
- Testing evidence
- Screenshots for UI changes

**Code**:
- Clean, readable
- Tests included
- No debug code
- Follows style guide

**Process**:
- Addresses review comments
- Keeps commits clean
- Updates documentation
- Links to issues

**Bad PR example**:
```
Title: "Fix stuff"
Description: "Fixed bugs"
Changes: 2000 lines across 50 files
```

**Good PR example**:
```
Title: "Fix user authentication timeout issue"
Description:
- What: Increase session timeout from 30 to 60 minutes
- Why: Users complained of frequent logouts
- How: Updated SessionManager configuration
- Testing: Verified sessions persist for 60 minutes
- Impact: All authenticated users
Changes: 5 lines in 2 files
```

#### Q2: How do you handle large feature development in PRs?

**Answer**:

**Strategy 1: Feature Flags**
```javascript
if (featureFlags.newCheckout) {
  // New implementation (can merge incomplete)
  return <NewCheckoutFlow />
} else {
  // Old implementation (still works)
  return <OldCheckoutFlow />
}
```

Allows merging incomplete features:
- Merge frequently to main
- Feature disabled in production
- Enable when complete

**Strategy 2: Stacked PRs**
```
PR #1: Add database schema
  ↓ (depends on)
PR #2: Add backend API
  ↓ (depends on)
PR #3: Add frontend UI
  ↓ (depends on)
PR #4: Enable feature
```

Each PR is small and reviewable:
```bash
# Create base PR
git checkout -b feature/step1
# ... changes ...
gh pr create --base main

# Create dependent PR
git checkout -b feature/step2
# ... changes ...
gh pr create --base feature/step1

# Merge in order: #1, #2, #3, #4
```

**Strategy 3: Feature Branch with Regular Reviews**
```bash
# Long-lived feature branch
git checkout -b feature/new-checkout

# Regular review checkpoints
git checkout -b feature/new-checkout-review1
gh pr create --base main --draft --title "[WIP] Checkout - Week 1"

# Merge feature branch when complete
gh pr create --base main --title "New checkout implementation"
```

#### Q3: What is squash merging vs regular merging?

**Answer**:

**Squash Merge**:
```bash
# Before: Feature branch has 10 commits
feat: add login UI
fix: typo in button
feat: add validation
fix: linting errors
...

# After squash merge: Single commit on main
feat: add user authentication (#123)
```

Benefits:
- Clean linear history on main
- Easy to revert entire feature
- Hides WIP commits

Drawbacks:
- Loses detailed commit history
- Can't cherry-pick individual changes

**Regular Merge**:
```bash
# Preserves all commits + merge commit
* Merge pull request #123
|\
| * fix: linting errors
| * feat: add validation
| * fix: typo
| * feat: add login UI
|/
```

Benefits:
- Full history preserved
- Can see evolution of feature
- Each commit revertable

Drawbacks:
- Messy history with WIP commits
- Harder to read git log

**Rebase Merge**:
```bash
# Replays commits on main (no merge commit)
* fix: linting errors
* feat: add validation
* feat: add login UI
```

Benefits:
- Linear history
- Individual commits preserved
- Clean log

Drawbacks:
- Rewrites history
- Can be confusing for beginners

**Recommendation**:
- Main branch: Squash merge (clean history)
- Hotfixes: Regular merge (preserve context)
- Never: Force push after others have pulled

---

*Continue with Tasks 3.5-3.10 following the same detailed format...*

