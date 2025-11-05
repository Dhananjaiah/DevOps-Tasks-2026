# Part 9: GitHub Actions CI/CD

## Overview
Modern CI/CD pipelines using GitHub Actions for automated workflows.

## Tasks Overview
1. **Task 9.1**: GitHub Actions Workflow Basics
2. **Task 9.2**: CI Pipeline for Pull Requests
3. **Task 9.3**: Docker Build and Push to ECR
4. **Task 9.4**: Kubernetes Deployment with GitHub Actions
5. **Task 9.5**: Environment Protection and Approvals
6. **Task 9.6**: Reusable Workflows
7. **Task 9.7**: Matrix Strategy for Multi-Version Testing
8. **Task 9.8**: Caching Dependencies for Faster Builds
9. **Task 9.9**: Scheduled Workflows for Maintenance
10. **Task 9.10**: Custom Actions and Composite Actions
11. **Task 9.11**: Secrets Management and Environment Variables
12. **Task 9.12**: Status Badges and Notifications

For detailed implementations, see [COMPREHENSIVE_GUIDE.md](../COMPREHENSIVE_GUIDE.md#part-9-github-actions-cicd)

## Quick Start
```yaml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm test
```

Continue to [Part 10: Prometheus](../part-10-prometheus/README.md)
