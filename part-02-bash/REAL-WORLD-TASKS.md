# Part 2: Bash Scripting Real-World Tasks for DevOps Engineers

> **📚 Navigation:** [Solutions →](./REAL-WORLD-TASKS-SOLUTIONS.md) | [Part 2 README](./README.md) | [Quick Start](./QUICK-START-GUIDE.md) | [Navigation Guide](./NAVIGATION-GUIDE.md) | [Main README](../README.md)

## 🎯 Overview

This document provides **real-world, executable Bash scripting tasks** designed as sprint assignments. Each task simulates actual production automation scenarios that DevOps engineers face daily.

**What You'll Find:**
- Clear scenarios with business context
- Time estimates for sprint planning (2-5 hours per task)
- Step-by-step assignment instructions
- Validation checklists
- Expected deliverables
- Sprint-ready task format (0.5-1 story points)

> **💡 Looking for solutions?** Complete solutions with production-ready scripts are available in [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)

---

## 📑 Task Index

Quick navigation to tasks and their solutions:

| # | Task Name | Difficulty | Time | Story Points | Solution Link |
|---|-----------|------------|------|--------------|---------------|
| 2.1 | [Production Deployment Automation](#task-21-production-deployment-automation-script) | Medium | 3-4h | 0.5 | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-21-production-deployment-automation-script) |
| 2.2 | [Log Analysis and Alert Script](#task-22-log-analysis-and-alert-script) | Medium | 2-3h | 0.5 | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-22-log-analysis-and-alert-script) |
| 2.3 | [Automated Backup and Restore](#task-23-automated-backup-and-restore-script) | Medium | 3-4h | 0.5 | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-23-automated-backup-and-restore-script) |
| 2.4 | [Infrastructure Health Check](#task-24-infrastructure-health-check-script) | Medium | 3-4h | 0.5 | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-24-infrastructure-health-check-script) |
| 2.5 | [CI/CD Pipeline Helper Scripts](#task-25-cicd-pipeline-helper-scripts) | Hard | 4-5h | 1.0 | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-25-cicd-pipeline-helper-scripts) |
| 2.6 | [Multi-Environment Configuration Manager](#task-26-multi-environment-configuration-manager) | Medium | 2-3h | 0.5 | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-26-multi-environment-configuration-manager) |

---

## How to Use This Guide

### For Managers/Team Leads:
1. Assign tasks based on engineer skill level and sprint capacity
2. Use time estimates and story points for sprint planning
3. Verify completion using validation checklists
4. Review deliverables for code quality and security

### For DevOps Engineers:
1. Read the scenario and understand business requirements
2. Plan your approach within the time estimate
3. Implement the solution following best practices
4. Test thoroughly using validation criteria
5. Submit deliverables with documentation

### For Self-Study:
1. Start with easier tasks (2.2 or 2.6) to build confidence
2. Try implementing without looking at solutions
3. Use validation checklists to verify your work
4. Compare your solution with the provided one
5. Learn from differences in approach and best practices

---

## Task 2.1: Production Deployment Automation Script

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-21-production-deployment-automation-script)**

### 🎬 Real-World Scenario
Your company deploys a microservices application to multiple environments (dev, staging, prod). Currently, deployments are done manually with inconsistent steps, leading to errors and downtime. You've been assigned to create a robust deployment automation script that the team can use for all environments.

### ⏱️ Time to Complete: 3-4 hours (Sprint: 0.5 story points)

### 📋 Assignment Instructions

**Your Mission:**
Create a production-grade Bash script that automates the deployment process for the backend API across multiple environments.

**Requirements:**
1. Support multiple environments (dev, staging, prod) via command-line arguments
2. Implement proper error handling (exit on errors, trap signals)
3. Include pre-deployment validation checks:
   - Verify environment is valid
   - Check if required files exist
   - Validate configuration
4. Execute deployment steps:
   - Pull latest code from Git repository
   - Build Docker image
   - Tag image with version
   - Push to container registry
   - Update Kubernetes deployment
5. Post-deployment verification:
   - Check deployment status
   - Run health checks
   - Send notification on success/failure
6. Include rollback capability
7. Log all operations with timestamps
8. Support dry-run mode for testing

**Environment Details:**
- Git repository: https://github.com/company/backend-api
- Container registry: AWS ECR (account-id.dkr.ecr.region.amazonaws.com)
- Kubernetes cluster: EKS
- Notification: Slack webhook or email

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Script Structure:**
- [ ] Shebang and shell options (set -euo pipefail)
- [ ] Clear script header with usage instructions
- [ ] Configuration section with variables
- [ ] Reusable functions
- [ ] Error handling and cleanup
- [ ] Logging mechanism

**Command-Line Interface:**
- [ ] Accepts environment argument (--env or -e)
- [ ] Accepts version argument (--version or -v)
- [ ] Supports dry-run mode (--dry-run)
- [ ] Shows help message (--help or -h)
- [ ] Validates all required arguments

**Pre-Deployment Checks:**
- [ ] Validates environment name
- [ ] Checks Git repository connectivity
- [ ] Verifies Docker is installed and running
- [ ] Confirms kubectl access to cluster
- [ ] Validates AWS credentials for ECR

**Deployment Process:**
- [ ] Pulls correct Git branch based on environment
- [ ] Builds Docker image successfully
- [ ] Tags image with proper version format
- [ ] Pushes image to ECR
- [ ] Updates Kubernetes deployment manifest
- [ ] Applies changes to cluster

**Post-Deployment:**
- [ ] Waits for rollout to complete
- [ ] Checks pod status
- [ ] Performs health check on API endpoint
- [ ] Logs deployment details
- [ ] Sends success/failure notification

**Error Handling:**
- [ ] Catches and handles errors gracefully
- [ ] Provides clear error messages
- [ ] Cleans up on failure
- [ ] Supports rollback to previous version

**Testing:**
- [ ] Dry-run mode works correctly
- [ ] Script tested in dev environment
- [ ] Script tested in staging environment
- [ ] All error scenarios handled
- [ ] Script is idempotent (safe to re-run)

### 📦 Deliverables

1. **deploy.sh**: The deployment automation script
2. **config/**: Directory with environment-specific configurations
   - `dev.env`
   - `staging.env`
   - `prod.env`
3. **README.md**: Documentation including:
   - Usage examples
   - Prerequisites
   - Troubleshooting guide
4. **Test results**: Screenshots or logs from dev/staging deployments

### 🎯 Success Criteria

- Script deploys successfully to dev and staging environments
- Dry-run mode accurately predicts actions without executing
- Error handling prevents partial deployments
- Rollback works when deployment fails
- Team members can use script without additional training

---

## Task 2.2: Log Analysis and Alert Script

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-22-log-analysis-and-alert-script)**

### 🎬 Real-World Scenario
Your production API generates massive log files daily. The operations team manually reviews logs each morning to identify errors, which is time-consuming and error-prone. You've been assigned to create an automated log analysis script that runs via cron and alerts the team of critical issues.

### ⏱️ Time to Complete: 2-3 hours (Sprint: 0.5 story points)

### 📋 Assignment Instructions

**Your Mission:**
Create a Bash script that analyzes application logs, identifies patterns of concern, and sends alerts when thresholds are exceeded.

**Requirements:**
1. Parse multiple log files (support wildcards)
2. Search for critical patterns:
   - HTTP 5xx errors
   - Application exceptions
   - Database connection failures
   - High response times (>5 seconds)
   - Security-related events (failed auth attempts)
3. Count occurrences within a time window
4. Generate a summary report
5. Send alerts when thresholds exceeded:
   - >50 5xx errors in 1 hour
   - >10 exceptions in 1 hour
   - >5 DB connection failures in 30 minutes
6. Support email and Slack notifications
7. Archive old logs (older than 7 days)
8. Generate daily summary report

**Environment:**
- Log location: `/var/log/api/`
- Log format: JSON with timestamp, level, message, request_id
- Cron schedule: Every 15 minutes
- Alert destinations: Slack and email

### ✅ Validation Checklist

**Log Processing:**
- [ ] Reads multiple log files correctly
- [ ] Handles compressed logs (.gz)
- [ ] Parses JSON log format
- [ ] Filters logs by time range
- [ ] Handles large files efficiently (>1GB)

**Pattern Detection:**
- [ ] Identifies HTTP 5xx errors
- [ ] Detects application exceptions
- [ ] Finds database connection failures
- [ ] Tracks slow requests
- [ ] Monitors failed authentication attempts

**Analysis & Reporting:**
- [ ] Counts occurrences accurately
- [ ] Calculates rates (errors per hour)
- [ ] Generates summary statistics
- [ ] Creates human-readable report
- [ ] Includes sample log entries in alerts

**Alerting:**
- [ ] Sends Slack notification when thresholds exceeded
- [ ] Sends email alerts for critical issues
- [ ] Includes relevant context in alerts
- [ ] Prevents alert spam (rate limiting)
- [ ] Alert format is clear and actionable

**Maintenance:**
- [ ] Archives old logs
- [ ] Rotates analysis reports
- [ ] Cleans up temporary files
- [ ] Handles log rotation properly

### 📦 Deliverables

1. **log_analyzer.sh**: Main analysis script
2. **config.conf**: Configuration file with:
   - Log paths and patterns
   - Thresholds
   - Alert destinations
3. **crontab.txt**: Cron schedule
4. **sample_report.txt**: Example output report
5. **Documentation**: Setup and configuration guide

### 🎯 Success Criteria

- Script processes 1 hour of logs in <30 seconds
- Correctly identifies all error patterns
- Alerts arrive within 1 minute of threshold breach
- Zero false positives in testing
- Runs reliably via cron without supervision

---

## Task 2.3: Automated Backup and Restore Script

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-23-automated-backup-and-restore-script)**

### 🎬 Real-World Scenario
Your team manages multiple PostgreSQL databases for different microservices. Database backups are currently manual and inconsistent. You need to create an automated backup solution that runs nightly, maintains retention policies, and can quickly restore in emergencies.

### ⏱️ Time to Complete: 3-4 hours (Sprint: 0.5 story points)

### 📋 Assignment Instructions

**Your Mission:**
Create a comprehensive database backup and restore automation script with retention management.

**Requirements:**

**Backup Functionality:**
1. Support multiple databases
2. Create full backups using pg_dump
3. Compress backups (gzip)
4. Upload to S3 bucket
5. Maintain local copies for quick restore
6. Include metadata file (timestamp, size, database info)
7. Implement retention policy:
   - Daily backups: Keep 7 days
   - Weekly backups: Keep 4 weeks
   - Monthly backups: Keep 12 months

**Restore Functionality:**
1. List available backups
2. Restore from specific backup
3. Validate backup before restore
4. Support point-in-time restore
5. Create pre-restore backup
6. Verify restore success

**Additional Features:**
1. Email notification on success/failure
2. Backup verification (test restore to temp database)
3. Encryption for backups at rest
4. Parallel backups for multiple databases
5. Bandwidth throttling for uploads

### ✅ Validation Checklist

**Backup Process:**
- [ ] Connects to PostgreSQL successfully
- [ ] Creates consistent database dumps
- [ ] Compresses backups efficiently (>70% compression)
- [ ] Uploads to S3 reliably
- [ ] Maintains local copies as configured
- [ ] Generates metadata files

**Retention Management:**
- [ ] Correctly identifies backups to delete
- [ ] Implements daily/weekly/monthly logic
- [ ] Deletes from both local and S3
- [ ] Prevents accidental deletion of recent backups
- [ ] Logs retention actions

**Restore Capability:**
- [ ] Lists available backups with details
- [ ] Downloads from S3 successfully
- [ ] Validates backup integrity before restore
- [ ] Restores database completely
- [ ] Verifies restored data

**Error Handling:**
- [ ] Handles database connection failures
- [ ] Manages insufficient disk space
- [ ] Handles S3 upload failures
- [ ] Recovers from partial backups
- [ ] Provides clear error messages

**Monitoring & Alerts:**
- [ ] Sends success notifications
- [ ] Alerts on backup failures
- [ ] Includes backup size and duration
- [ ] Tracks backup history

### 📦 Deliverables

1. **backup.sh**: Backup automation script
2. **restore.sh**: Restore utility script
3. **config/backup.conf**: Configuration file
4. **cron/backup-schedule**: Cron configuration
5. **docs/BACKUP_RESTORE_GUIDE.md**: Complete documentation
6. **test_results/**: Backup and restore test logs

### 🎯 Success Criteria

- Backups complete in <15 minutes per database
- 100% successful backup rate for 7 days
- Restore completes in <5 minutes
- Retention policy works correctly
- Zero data loss in restore tests

---

## Task 2.4: Infrastructure Health Check Script

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-24-infrastructure-health-check-script)**

### 🎬 Real-World Scenario
Your infrastructure includes multiple components: web servers, API servers, databases, cache servers, and load balancers. Currently, there's no unified way to check the health of all components. You need to create a comprehensive health check script that the operations team can run before and after deployments.

### ⏱️ Time to Complete: 3-4 hours (Sprint: 0.5 story points)

### 📋 Assignment Instructions

**Your Mission:**
Create a comprehensive health check script that validates all infrastructure components and generates a detailed status report.

**Requirements:**

**Components to Check:**
1. **Web Servers** (Nginx/Apache):
   - Service status
   - Port availability (80, 443)
   - SSL certificate validity
   - Response time
   - Error rate from logs

2. **API Servers**:
   - Process running
   - Health endpoint responding
   - Response time
   - Database connectivity
   - Cache connectivity

3. **Databases** (PostgreSQL):
   - Service status
   - Connection pool usage
   - Replication lag
   - Disk space
   - Active connections

4. **Cache** (Redis):
   - Service status
   - Memory usage
   - Hit rate
   - Connected clients
   - Key count

5. **Load Balancers**:
   - All backend servers healthy
   - SSL configuration
   - Traffic distribution

**Script Features:**
1. Parallel health checks for speed
2. Configurable timeout values
3. Color-coded output (green/yellow/red)
4. JSON output option for monitoring tools
5. Detailed vs summary mode
6. Export report to file
7. Integration with monitoring systems

### ✅ Validation Checklist

**Health Checks:**
- [ ] Verifies all web server components
- [ ] Tests API endpoints thoroughly
- [ ] Checks database health metrics
- [ ] Validates cache functionality
- [ ] Confirms load balancer status
- [ ] Tests SSL certificates

**Performance:**
- [ ] Completes all checks in <60 seconds
- [ ] Runs checks in parallel
- [ ] Handles timeouts gracefully
- [ ] Minimal resource usage

**Reporting:**
- [ ] Clear visual output with colors
- [ ] Detailed error messages
- [ ] Summary statistics
- [ ] JSON output for automation
- [ ] Saves reports with timestamps

**Reliability:**
- [ ] Handles network failures
- [ ] Manages connection timeouts
- [ ] Works with partial infrastructure
- [ ] Accurate status reporting
- [ ] No false positives

### 📦 Deliverables

1. **health_check.sh**: Main health check script
2. **config/**: Component configurations
   - `servers.conf`
   - `thresholds.conf`
3. **lib/**: Helper functions
   - `check_web.sh`
   - `check_api.sh`
   - `check_db.sh`
   - `check_cache.sh`
4. **README.md**: Usage guide and examples
5. **sample_outputs/**: Example reports (normal and failure scenarios)

### 🎯 Success Criteria

- Detects 100% of infrastructure issues in testing
- Completes full check in under 60 seconds
- Clear, actionable output for operations team
- Zero false alarms
- Successfully used in 3 production deployments

---

## Task 2.5: CI/CD Pipeline Helper Scripts

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-25-cicd-pipeline-helper-scripts)**

### 🎬 Real-World Scenario
Your team uses Jenkins for CI/CD but several manual steps are still required: image tagging, manifest updates, deployment rollback, and artifact cleanup. You've been tasked to create helper scripts that Jenkins can call to automate these operations.

### ⏱️ Time to Complete: 4-5 hours (Sprint: 1 story point)

### 📋 Assignment Instructions

**Your Mission:**
Create a collection of modular Bash scripts that automate common CI/CD pipeline operations.

**Scripts to Create:**

1. **docker_build_push.sh**:
   - Build Docker image
   - Tag with multiple tags (commit SHA, branch, version)
   - Push to multiple registries
   - Clean up old images
   - Generate image manifest

2. **k8s_manifest_update.sh**:
   - Update Kubernetes manifest with new image tag
   - Validate manifest syntax
   - Update ConfigMap values
   - Update Secret references
   - Commit changes back to Git

3. **deploy_verify.sh**:
   - Deploy to Kubernetes
   - Wait for rollout completion
   - Check pod health
   - Run smoke tests
   - Verify application endpoints

4. **rollback.sh**:
   - Find previous deployment version
   - Rollback Kubernetes deployment
   - Verify rollback success
   - Update Git tags
   - Send notification

5. **cleanup.sh**:
   - Clean old Docker images from local and registry
   - Remove old artifacts from S3
   - Clean old deployments from Kubernetes
   - Maintain retention policy

**Common Requirements for All Scripts:**
- Proper error handling
- Clear logging
- Exit codes for Jenkins integration
- JSON output option
- Dry-run mode
- Configuration file support

### ✅ Validation Checklist

**docker_build_push.sh:**
- [ ] Builds image successfully
- [ ] Tags with all required formats
- [ ] Pushes to ECR/Docker Hub
- [ ] Cleans up local images
- [ ] Generates SBOM (Software Bill of Materials)

**k8s_manifest_update.sh:**
- [ ] Updates image tags correctly
- [ ] Validates YAML syntax
- [ ] Commits changes to Git
- [ ] Creates pull request (optional)
- [ ] Handles merge conflicts

**deploy_verify.sh:**
- [ ] Applies manifests correctly
- [ ] Waits for deployment completion
- [ ] Runs health checks
- [ ] Verifies application functionality
- [ ] Fails fast on errors

**rollback.sh:**
- [ ] Identifies previous version
- [ ] Executes rollback quickly (<2 min)
- [ ] Verifies rollback success
- [ ] Updates documentation/tags
- [ ] Sends alerts

**cleanup.sh:**
- [ ] Identifies old artifacts correctly
- [ ] Respects retention policy
- [ ] Deletes safely (no active resources)
- [ ] Logs cleanup actions
- [ ] Reports space saved

**Integration:**
- [ ] All scripts work in Jenkins pipeline
- [ ] Exit codes appropriate for CI/CD
- [ ] Logs parseable by Jenkins
- [ ] Scripts can be chained together
- [ ] Error messages actionable

### 📦 Deliverables

1. **scripts/**: All five scripts
   - `docker_build_push.sh`
   - `k8s_manifest_update.sh`
   - `deploy_verify.sh`
   - `rollback.sh`
   - `cleanup.sh`
2. **lib/common.sh**: Shared functions library
3. **config/**: Environment configurations
4. **Jenkinsfile.example**: Sample pipeline using the scripts
5. **docs/CICD_SCRIPTS.md**: Complete documentation
6. **tests/**: Test scripts and validation

### 🎯 Success Criteria

- All scripts integrated into Jenkins pipeline
- 10 successful deployments using the scripts
- Rollback tested and working
- Build time reduced by 30%
- Zero manual interventions needed
- Team trained on using scripts

---

## Task 2.6: Multi-Environment Configuration Manager

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-26-multi-environment-configuration-manager)**

### 🎬 Real-World Scenario
Your application runs in dev, staging, and production with different configurations for each. Currently, configuration files are manually edited before deployment, leading to mistakes. You need to create a configuration management script that generates environment-specific configs from templates.

### ⏱️ Time to Complete: 2-3 hours (Sprint: 0.5 story points)

### 📋 Assignment Instructions

**Your Mission:**
Create a configuration management script that generates environment-specific configuration files from templates.

**Requirements:**

**Core Functionality:**
1. Read configuration templates
2. Support multiple template formats:
   - Property files (.properties)
   - YAML files (.yml)
   - JSON files (.json)
   - Environment files (.env)
3. Substitute variables with environment-specific values
4. Validate generated configurations
5. Support encrypted secrets
6. Generate configurations for all environments

**Variable Management:**
1. Load variables from multiple sources:
   - Environment files (dev.env, staging.env, prod.env)
   - AWS Parameter Store
   - Vault (HashiCorp)
   - Command-line overrides
2. Support variable interpolation
3. Handle default values
4. Validate required variables

**Security:**
1. Encrypt sensitive values at rest
2. Support AWS KMS for encryption
3. Never log sensitive values
4. Restrict file permissions on generated configs

**Additional Features:**
1. Dry-run mode to preview changes
2. Diff mode to compare configurations
3. Backup existing configurations before overwrite
4. Generate configuration change log

### ✅ Validation Checklist

**Template Processing:**
- [ ] Reads template files correctly
- [ ] Supports all required formats
- [ ] Handles nested configurations
- [ ] Preserves formatting
- [ ] Handles special characters

**Variable Substitution:**
- [ ] Replaces all variables correctly
- [ ] Handles missing variables appropriately
- [ ] Supports default values
- [ ] Manages environment-specific values
- [ ] Interpolates complex expressions

**Validation:**
- [ ] Validates YAML syntax
- [ ] Validates JSON structure
- [ ] Checks required variables present
- [ ] Verifies configuration semantics
- [ ] Catches common mistakes

**Security:**
- [ ] Encrypts sensitive data
- [ ] Proper file permissions (600)
- [ ] No secrets in logs
- [ ] Secure temporary file handling
- [ ] Audit trail for config changes

**Usability:**
- [ ] Clear error messages
- [ ] Helpful usage examples
- [ ] Dry-run shows preview
- [ ] Diff mode shows changes
- [ ] Backup/restore works

### 📦 Deliverables

1. **config_manager.sh**: Main configuration script
2. **templates/**: Configuration templates
   - `application.yml.tmpl`
   - `database.properties.tmpl`
   - `.env.tmpl`
3. **environments/**: Environment variable files
   - `dev.env`
   - `staging.env`
   - `prod.env`
4. **docs/CONFIG_MANAGEMENT.md**: Documentation
5. **examples/**: Usage examples and test cases

### 🎯 Success Criteria

- Generates valid configs for all environments
- Zero configuration-related deployment failures
- Secrets properly encrypted and handled
- Team can generate configs without errors
- Configuration changes tracked and auditable

---

## Sprint Planning Guidelines

### Task Complexity Ratings

**Simple (0.5 story points):**
- Tasks 2.2, 2.3, 2.4, 2.6
- Good for new team members
- Can be completed in one sprint day

**Medium (1 story point):**
- Tasks 2.1, 2.5
- Requires solid Bash experience
- May need multiple sprint days

### Recommended Sprint Assignment

**Sprint Week 1:**
- Day 1-2: Task 2.1 (Deployment Script)
- Day 3: Task 2.2 (Log Analysis)
- Day 4: Task 2.6 (Config Manager)

**Sprint Week 2:**
- Day 1-2: Task 2.5 (CI/CD Scripts)
- Day 3: Task 2.3 (Backup Script)
- Day 4: Task 2.4 (Health Check)

### Skill Level Requirements

**Junior DevOps Engineer:**
- Start with: Task 2.2 (Log Analysis)
- Then: Task 2.6 (Config Manager)

**Mid-Level DevOps Engineer:**
- Start with: Task 2.1 (Deployment)
- Then: Task 2.3 (Backup)
- Then: Task 2.4 (Health Check)

**Senior DevOps Engineer:**
- Start with: Task 2.5 (CI/CD Scripts) - requires architectural understanding
- Can handle multiple tasks simultaneously

---

## Additional Resources

### Best Practices Reference
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls)
- [ShellCheck](https://www.shellcheck.net/) - Linting tool

### Testing Tools
- [BATS](https://github.com/bats-core/bats-core) - Bash Automated Testing System
- [Shunit2](https://github.com/kward/shunit2) - Unit testing framework

### Learning Resources
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)

---

**Ready to start? Pick a task and dive in! For complete solutions, see [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)**
