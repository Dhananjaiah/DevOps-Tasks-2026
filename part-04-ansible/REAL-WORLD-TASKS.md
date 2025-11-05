# Part 4: Ansible Real-World Tasks for DevOps Engineers

> **📚 Navigation:** [Solutions →](./REAL-WORLD-TASKS-SOLUTIONS.md) | [Navigation Guide](./NAVIGATION-GUIDE.md) | [Quick Start](./QUICK-START-GUIDE.md) | [Part 4 README](./README.md) | [Main README](../README.md)

## 🎯 Overview

This document provides **real-world, executable Ansible tasks** that you can practice or assign to DevOps engineers. Each task includes:
- **Clear scenario and context**
- **Time estimate for completion**
- **Step-by-step assignment instructions**
- **Validation checklist**
- **Expected deliverables**

These tasks are designed to be practical assignments that simulate actual production work for configuration management and automation.

> **💡 Looking for solutions?** Complete solutions with step-by-step implementations, playbooks, and roles are available in [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)

---

## How to Use This Guide

### For Managers/Team Leads:
1. Select a task based on the engineer's skill level
2. Provide the task description and time limit
3. Use the validation checklist to verify completion
4. Review the deliverables

### For DevOps Engineers:
1. Read the scenario carefully
2. Note the time estimate (plan accordingly)
3. Complete all steps in the task
4. Verify your work using the checklist
5. Submit the required deliverables

### For Interview Preparation:
1. Practice implementing tasks without looking at solutions
2. Time yourself to improve efficiency
3. Compare your solution with provided answers
4. Study the interview questions in the solutions file

---

## 📑 Task Index

Quick navigation to tasks and their solutions:

| # | Task Name | Difficulty | Time | Solution Link |
|---|-----------|------------|------|---------------|
| 4.1 | [Ansible Directory Structure & Best Practices](#task-41-ansible-directory-structure-and-best-practices) | Easy | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-41-ansible-directory-structure-and-best-practices) |
| 4.2 | [Multi-Environment Inventory Management](#task-42-multi-environment-inventory-management) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-42-multi-environment-inventory-management) |
| 4.3 | [Create Role for Backend API Service](#task-43-create-ansible-role-for-backend-api-service) | Medium | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-43-create-ansible-role-for-backend-api-service) |
| 4.4 | [Configure Nginx Reverse Proxy with TLS](#task-44-configure-nginx-reverse-proxy-with-tls) | Medium | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-44-configure-nginx-reverse-proxy-with-tls) |
| 4.5 | [Ansible Vault for Secrets Management](#task-45-ansible-vault-for-secrets-management) | Medium | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-45-ansible-vault-for-secrets-management) |
| 4.6 | [PostgreSQL Installation and Configuration](#task-46-postgresql-installation-and-configuration) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-46-postgresql-installation-and-configuration) |
| 4.7 | [Application Deployment Playbook](#task-47-application-deployment-playbook) | Hard | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-47-application-deployment-playbook) |
| 4.8 | [Zero-Downtime Rolling Updates](#task-48-zero-downtime-rolling-updates) | Hard | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-48-zero-downtime-rolling-updates) |
| 4.9 | [Dynamic Inventory for AWS EC2](#task-49-dynamic-inventory-for-aws-ec2) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-49-dynamic-inventory-for-aws-ec2) |
| 4.10 | [Ansible Templates with Jinja2](#task-410-ansible-templates-with-jinja2) | Medium | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-410-ansible-templates-with-jinja2) |
| 4.11 | [Handlers and Service Management](#task-411-handlers-and-service-management) | Easy | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-411-handlers-and-service-management) |
| 4.12 | [Conditional Execution and Loops](#task-412-conditional-execution-and-loops) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-412-conditional-execution-and-loops) |
| 4.13 | [Error Handling and Retries](#task-413-error-handling-and-retries) | Medium | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-413-error-handling-and-retries) |
| 4.14 | [Ansible Tags for Selective Execution](#task-414-ansible-tags-for-selective-execution) | Easy | 45 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-414-ansible-tags-for-selective-execution) |

---

## Task 4.1: Ansible Directory Structure and Best Practices

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-41-ansible-directory-structure-and-best-practices)**

### 🎬 Real-World Scenario
Your team is starting a new project to automate infrastructure management for a 3-tier web application across multiple environments (dev, staging, production). You need to set up a proper Ansible project structure that will scale as the team and infrastructure grow. The structure must follow best practices and be easily maintainable by the entire DevOps team.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create a production-ready Ansible project structure with proper directory organization, configuration files, and documentation.

**Requirements:**
1. Create standard Ansible directory structure with:
   - Separate inventory directories for each environment
   - Roles directory with proper structure
   - Playbooks directory for different purposes
   - Group and host variable directories
2. Configure ansible.cfg with production-ready settings
3. Create .gitignore for Ansible projects
4. Set up role templates using ansible-galaxy
5. Create sample playbooks demonstrating structure usage
6. Document the structure and conventions

**Environment:**
- Local machine with Ansible installed (version 2.12+)
- Git repository for version control
- Access to create files and directories

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Directory Structure**
  - [ ] Created inventories/{production,staging,development} directories
  - [ ] Each inventory has group_vars and host_vars subdirectories
  - [ ] Created roles directory with at least one sample role
  - [ ] Created playbooks directory with organized playbooks
  - [ ] Created library and filter_plugins directories

- [ ] **Configuration Files**
  - [ ] ansible.cfg configured with appropriate settings
  - [ ] .gitignore includes Ansible-specific patterns
  - [ ] vault_password_file location specified (but not committed)

- [ ] **Role Structure**
  - [ ] At least one role created using ansible-galaxy init
  - [ ] Role contains all standard directories (tasks, handlers, templates, etc.)
  - [ ] Role README.md documents purpose and usage

- [ ] **Playbooks**
  - [ ] Created site.yml master playbook
  - [ ] Created specific playbooks for different purposes
  - [ ] Playbooks reference roles correctly

- [ ] **Verification**
  - [ ] ansible.cfg validates without errors
  - [ ] Directory structure visible with tree command
  - [ ] Sample playbook syntax validates successfully
  - [ ] Documentation is clear and complete

### 📦 Deliverables

1. **Project Structure**: Complete directory tree
2. **Configuration Files**: ansible.cfg, .gitignore
3. **Sample Role**: At least one complete role
4. **Sample Playbooks**: site.yml and task-specific playbooks
5. **Documentation**: README.md explaining structure and conventions
6. **Validation Output**: Screenshots/logs of successful validation

### 🎯 Success Criteria

- Directory structure follows Ansible best practices
- Configuration is production-ready
- Structure is scalable and maintainable
- Documentation enables new team members to understand quickly
- All validation checks pass

---

## Task 4.2: Multi-Environment Inventory Management

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-42-multi-environment-inventory-management)**

### 🎬 Real-World Scenario
Your company has infrastructure across three environments: development (5 servers), staging (10 servers), and production (30 servers). Each environment has different configurations for web servers, API servers, and databases. You need to create an inventory management system that allows easy targeting of specific environments and server groups, with appropriate variables for each.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create a comprehensive multi-environment inventory system with static and dynamic inventory capabilities.

**Requirements:**
1. Create static inventory files for all three environments
2. Organize hosts into functional groups (webservers, api, database, loadbalancers)
3. Create nested groups (production:children, etc.)
4. Set up group_vars for each server type
5. Set up host_vars for specific servers with unique configurations
6. Implement YAML inventory format for better readability
7. Configure environment-specific variables
8. Test inventory with ansible commands

**Server Layout:**
- **Development**: 2 web, 2 api, 1 database
- **Staging**: 3 web, 4 api, 2 database, 1 loadbalancer
- **Production**: 10 web, 12 api, 6 database, 2 loadbalancers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Static Inventory**
  - [ ] Created inventory files for dev, staging, production
  - [ ] Hosts organized into functional groups
  - [ ] Nested groups configured (environment:children)
  - [ ] Host connection parameters specified

- [ ] **Group Variables**
  - [ ] group_vars/all.yml with common variables
  - [ ] group_vars/webservers.yml with web-specific config
  - [ ] group_vars/api.yml with API-specific config
  - [ ] group_vars/database.yml with DB-specific config
  - [ ] Environment-specific variables in respective directories

- [ ] **Host Variables**
  - [ ] host_vars created for servers with unique config
  - [ ] Variables properly override group variables

- [ ] **Testing**
  - [ ] ansible-inventory --list works for all environments
  - [ ] ansible-inventory --graph shows proper hierarchy
  - [ ] ansible all -m ping succeeds (or explains why it can't)
  - [ ] Variable precedence works as expected

- [ ] **Documentation**
  - [ ] Documented inventory structure
  - [ ] Explained variable precedence
  - [ ] Provided examples of targeting different groups

### 📦 Deliverables

1. **Inventory Files**: Complete static inventory for all environments
2. **Variable Files**: All group_vars and host_vars files
3. **Documentation**: Inventory structure and usage guide
4. **Test Results**: Output from ansible-inventory commands
5. **Examples**: Sample commands for different targeting scenarios

### 🎯 Success Criteria

- Can target any combination of environment and server type
- Variables cascade properly from all → group → host
- Inventory is easy to maintain and extend
- Clear separation between environments prevents accidental changes
- Documentation enables team to use inventory effectively

---

## Task 4.3: Create Ansible Role for Backend API Service

> **�� [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-43-create-ansible-role-for-backend-api-service)**

### 🎬 Real-World Scenario
Your backend API is a Node.js application that needs to be deployed consistently across multiple servers. Currently, deployment is manual and error-prone. Create an Ansible role that automates the complete installation, configuration, and deployment of the backend API, including systemd service setup and health checks.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create a complete, reusable Ansible role for deploying and managing a Node.js backend API service.

**Requirements:**
1. Install Node.js (specific version)
2. Create application user and directories
3. Deploy application code
4. Install npm dependencies
5. Configure environment variables from template
6. Create systemd service unit
7. Configure log rotation
8. Implement health checks
9. Set up handlers for service restart
10. Make role idempotent

**Application Details:**
- Node.js version: 18.x
- Application port: 8080
- Application directory: /opt/backend-api
- Service user: apiuser
- Logs directory: /var/log/backend-api

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Role Structure**
  - [ ] Role created with ansible-galaxy init
  - [ ] All standard directories present (tasks, handlers, templates, defaults, etc.)
  - [ ] README.md documents role usage

- [ ] **Tasks Implementation**
  - [ ] Node.js repository added and installed
  - [ ] Application user created with correct permissions
  - [ ] Application directory structure created
  - [ ] Code deployment task implemented
  - [ ] npm install task implemented
  - [ ] Environment file created from template
  - [ ] Systemd service unit deployed
  - [ ] Service enabled and started

- [ ] **Templates**
  - [ ] systemd service template created
  - [ ] Environment file template created
  - [ ] Templates use variables correctly

- [ ] **Handlers**
  - [ ] reload systemd handler defined
  - [ ] restart service handler defined
  - [ ] Handlers triggered appropriately

- [ ] **Variables**
  - [ ] defaults/main.yml contains sensible defaults
  - [ ] All configurable values parameterized
  - [ ] Variables well-documented

- [ ] **Testing**
  - [ ] Role runs successfully with --check mode
  - [ ] Service starts and runs correctly
  - [ ] Running role twice produces no changes (idempotent)
  - [ ] Health check endpoint responds

### 📦 Deliverables

1. **Complete Role**: Full role directory structure with all files
2. **Playbook**: Test playbook that uses the role
3. **Documentation**: README with role variables and usage examples
4. **Test Results**: Logs showing successful deployment
5. **Service Status**: Output showing service running correctly

### 🎯 Success Criteria

- Role deploys backend API successfully
- Service runs and responds to health checks
- Role is idempotent (can run multiple times safely)
- Role is reusable and configurable
- Code follows Ansible best practices
- Documentation is comprehensive

---

## Task 4.4: Configure Nginx Reverse Proxy with TLS

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-44-configure-nginx-reverse-proxy-with-tls)**

### 🎬 Real-World Scenario
Your backend API is running on port 8080, but it needs to be accessible via HTTPS on the standard port 443. Create an Ansible role that installs and configures Nginx as a reverse proxy with TLS termination. The configuration should support multiple backend servers with load balancing and health checks.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create an Ansible role that configures Nginx as a reverse proxy with TLS/SSL support, load balancing, and security hardening.

**Requirements:**
1. Install Nginx
2. Configure reverse proxy to backend API
3. Set up TLS/SSL with Let's Encrypt (or self-signed for testing)
4. Implement load balancing across multiple backend servers
5. Configure health checks
6. Apply security headers and hardening
7. Set up access and error logging
8. Configure log rotation
9. Implement HTTP to HTTPS redirect
10. Create handlers for configuration reload

**Configuration Details:**
- Listen on ports 80 (HTTP) and 443 (HTTPS)
- Proxy to backend servers on port 8080
- Support at least 3 backend servers
- Enable HTTP/2
- Security headers: X-Frame-Options, X-Content-Type-Options, X-XSS-Protection

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Nginx Installation**
  - [ ] Nginx installed from official repository
  - [ ] Service enabled and running

- [ ] **Reverse Proxy Configuration**
  - [ ] Main nginx.conf optimized
  - [ ] Site configuration created
  - [ ] Proxy headers configured correctly
  - [ ] Upstream servers defined

- [ ] **Load Balancing**
  - [ ] Multiple backend servers configured
  - [ ] Health checks implemented
  - [ ] Load balancing algorithm specified

- [ ] **TLS/SSL Configuration**
  - [ ] SSL certificate deployed
  - [ ] Modern SSL protocols only (TLS 1.2+)
  - [ ] Strong cipher suites configured
  - [ ] HTTP to HTTPS redirect working

- [ ] **Security Hardening**
  - [ ] Security headers configured
  - [ ] Server tokens hidden
  - [ ] Rate limiting implemented
  - [ ] Client body size limited

- [ ] **Testing**
  - [ ] nginx -t validates configuration
  - [ ] Service restarts successfully
  - [ ] HTTPS connection works
  - [ ] Backend API accessible through proxy
  - [ ] Health checks functioning
  - [ ] SSL Labs test (if possible): Grade A

### 📦 Deliverables

1. **Nginx Role**: Complete role with all configurations
2. **Templates**: nginx.conf, site config, and SSL config templates
3. **Variables**: Well-documented defaults and configuration options
4. **Test Playbook**: Playbook demonstrating role usage
5. **Test Results**: Evidence of successful configuration
6. **SSL Configuration**: SSL certificate setup (self-signed or Let's Encrypt)

### 🎯 Success Criteria

- Nginx serves as effective reverse proxy
- TLS/SSL properly configured and secure
- Load balancing distributes traffic correctly
- Security headers present in responses
- Configuration is maintainable and well-documented
- Role is idempotent and reusable

---

## Task 4.5: Ansible Vault for Secrets Management

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-45-ansible-vault-for-secrets-management)**

### 🎬 Real-World Scenario
Your playbooks contain sensitive information like database passwords, API keys, and SSL private keys in plain text. This is a security risk and fails compliance audits. Implement Ansible Vault to encrypt all sensitive data, set up a secure vault password management strategy, and integrate it with your existing playbooks and CI/CD pipeline.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement comprehensive secrets management using Ansible Vault across all environments.

**Requirements:**
1. Identify all sensitive variables in existing playbooks
2. Create vault-encrypted variable files for each environment
3. Implement vault password file strategy (not committed to git)
4. Use vault_ prefix naming convention
5. Reference vault variables in regular variable files
6. Configure ansible.cfg for vault password file
7. Create documentation for vault usage
8. Set up vault password rotation procedure
9. Integrate with CI/CD (vault password from secrets manager)

**Secrets to Encrypt:**
- Database passwords
- API keys and tokens
- SSL private keys
- AWS access credentials
- Application secret keys

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Vault Files Created**
  - [ ] vault.yml file for each environment
  - [ ] All sensitive data encrypted
  - [ ] vault_ prefix used for encrypted variables

- [ ] **Variable Structure**
  - [ ] Regular vars.yml references vault variables
  - [ ] No plain text secrets remain
  - [ ] Variable names are clear and consistent

- [ ] **Vault Password Management**
  - [ ] .vault_pass file created (and gitignored)
  - [ ] ansible.cfg configured with vault_password_file
  - [ ] Alternative methods documented (--ask-vault-pass)

- [ ] **Testing**
  - [ ] Playbooks run successfully with vault
  - [ ] Can encrypt new files: ansible-vault create
  - [ ] Can edit encrypted files: ansible-vault edit
  - [ ] Can view encrypted files: ansible-vault view
  - [ ] Can rekey encrypted files: ansible-vault rekey

- [ ] **Security**
  - [ ] .vault_pass in .gitignore
  - [ ] Encrypted files committed to git successfully
  - [ ] Vault password not exposed in logs or output

- [ ] **Documentation**
  - [ ] Vault usage documented
  - [ ] Password rotation procedure documented
  - [ ] CI/CD integration documented

### 📦 Deliverables

1. **Encrypted Vault Files**: vault.yml for each environment
2. **Variable Files**: Regular variable files referencing vault vars
3. **Configuration**: Updated ansible.cfg
4. **Documentation**: Vault usage guide and procedures
5. **Scripts**: Helper scripts for vault operations (optional)
6. **Test Results**: Evidence that playbooks work with vault

### 🎯 Success Criteria

- All secrets encrypted and secure
- Playbooks run successfully using vault
- No plain text secrets in version control
- Vault password management is secure
- Team can work with vault effectively
- Documentation is comprehensive

---

## Task 4.6: PostgreSQL Installation and Configuration

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-46-postgresql-installation-and-configuration)**

### 🎬 Real-World Scenario
Your application requires a PostgreSQL database. Create an Ansible role that installs PostgreSQL, creates databases and users, configures connection settings, and sets up automated backups. The role should support both standalone and replication configurations.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create a comprehensive Ansible role for PostgreSQL installation, configuration, and management.

**Requirements:**
1. Install PostgreSQL (specific version: 14)
2. Configure PostgreSQL for production (memory, connections)
3. Create application databases
4. Create database users with appropriate privileges
5. Configure pg_hba.conf for secure connections
6. Set up connection from application servers
7. Implement automated backup script
8. Configure log rotation
9. Set up basic monitoring
10. Make role support different OS distributions

**Database Details:**
- PostgreSQL version: 14
- Database name: production_db
- Database user: appuser
- Max connections: 200
- Shared buffers: 256MB

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Installation**
  - [ ] PostgreSQL 14 installed
  - [ ] Required dependencies installed
  - [ ] Service enabled and running

- [ ] **Configuration**
  - [ ] postgresql.conf customized for production
  - [ ] Memory settings optimized
  - [ ] Connection settings configured
  - [ ] pg_hba.conf configured for security

- [ ] **Database Setup**
  - [ ] Database created successfully
  - [ ] Application user created with password
  - [ ] Correct privileges granted
  - [ ] User can connect remotely (if required)

- [ ] **Security**
  - [ ] Passwords stored in vault
  - [ ] pg_hba.conf uses md5 or scram-sha-256
  - [ ] Remote access restricted appropriately
  - [ ] Firewall configured (if applicable)

- [ ] **Backup**
  - [ ] Backup script created and deployed
  - [ ] Backup cron job or systemd timer set up
  - [ ] Backup retention policy implemented
  - [ ] Backup restoration tested

- [ ] **Testing**
  - [ ] Can connect to database from application server
  - [ ] Can perform basic SQL operations
  - [ ] Backup script executes successfully
  - [ ] Role is idempotent

### 📦 Deliverables

1. **PostgreSQL Role**: Complete role directory
2. **Configuration Templates**: postgresql.conf, pg_hba.conf templates
3. **Backup Script**: Automated backup script
4. **Test Playbook**: Playbook using the role
5. **Verification**: Screenshots/logs of successful setup
6. **Documentation**: Role README with variables and usage

### 🎯 Success Criteria

- PostgreSQL installed and configured correctly
- Database and user created successfully
- Application can connect and query database
- Automated backups working
- Role is reusable across environments
- Security best practices followed

---

## Task 4.7: Application Deployment Playbook

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-47-application-deployment-playbook)**

### 🎬 Real-World Scenario
Create a complete deployment playbook that orchestrates the deployment of your entire 3-tier application (frontend, backend API, database) across multiple servers. The playbook should handle pre-deployment checks, deployment, post-deployment validation, and provide rollback capabilities.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create an orchestrated deployment playbook that safely deploys all application components in the correct order.

**Requirements:**
1. Pre-deployment checks (disk space, service status)
2. Deploy database changes first
3. Deploy backend API with health checks
4. Deploy frontend with health checks
5. Update load balancer configuration
6. Post-deployment smoke tests
7. Implement rollback capability
8. Send deployment notifications
9. Support different deployment strategies (all-at-once, rolling)
10. Create deployment runbook

**Deployment Order:**
1. Database migrations
2. Backend API (with rolling restart)
3. Frontend
4. Load balancer config update
5. Smoke tests

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Playbook Structure**
  - [ ] Main deployment playbook created
  - [ ] Pre-tasks for checks implemented
  - [ ] Post-tasks for validation implemented
  - [ ] Proper use of blocks for error handling

- [ ] **Pre-Deployment**
  - [ ] Disk space check
  - [ ] Service status verification
  - [ ] Backup current version
  - [ ] Maintenance mode enabled (if applicable)

- [ ] **Deployment Steps**
  - [ ] Database deployed and migrated
  - [ ] Backend API deployed
  - [ ] Frontend deployed
  - [ ] Each step has proper health checks

- [ ] **Post-Deployment**
  - [ ] Health check endpoints verified
  - [ ] Smoke tests executed
  - [ ] Maintenance mode disabled
  - [ ] Success notification sent

- [ ] **Error Handling**
  - [ ] Rollback procedure defined
  - [ ] Errors trigger appropriate actions
  - [ ] Failure notifications sent
  - [ ] Safe to retry after failure

- [ ] **Testing**
  - [ ] Dry run with --check succeeds
  - [ ] Deployment completes successfully
  - [ ] Application accessible after deployment
  - [ ] Rollback tested and works

### 📦 Deliverables

1. **Deployment Playbook**: Complete deploy.yml playbook
2. **Rollback Playbook**: rollback.yml for emergency rollback
3. **Helper Scripts**: Pre and post deployment scripts
4. **Deployment Runbook**: Step-by-step manual
5. **Test Results**: Logs of successful deployment
6. **Documentation**: Deployment process and procedures

### 🎯 Success Criteria

- Complete application deploys successfully
- All health checks pass
- Deployment is automated and repeatable
- Rollback capability exists and works
- Minimal to zero downtime during deployment
- Clear documentation for operations team

---

## Task 4.8: Zero-Downtime Rolling Updates

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-48-zero-downtime-rolling-updates)**

### 🎬 Real-World Scenario
Your application updates currently cause downtime because all servers are updated at once. Implement a rolling update strategy that updates servers one at a time (or in small batches) while keeping the application available. This requires integration with the load balancer to drain connections before updating each server.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement zero-downtime rolling deployment for your backend API servers with load balancer integration.

**Requirements:**
1. Use serial execution to control update batch size
2. Remove server from load balancer before updating
3. Wait for connection draining
4. Update application code and restart service
5. Perform health checks before continuing
6. Add server back to load balancer
7. Wait for server to be healthy in load balancer
8. Continue with next server
9. Implement max_fail_percentage safety
10. Support different batch sizes

**Infrastructure:**
- 6 backend API servers behind load balancer
- HAProxy or AWS ELB load balancer
- Health check endpoint: /health
- Batch size: 2 servers at a time (33%)

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Rolling Update Configuration**
  - [ ] serial parameter set appropriately
  - [ ] max_fail_percentage configured
  - [ ] Batching strategy defined

- [ ] **Load Balancer Integration**
  - [ ] Remove server from LB task
  - [ ] Wait for connection draining
  - [ ] Add server back to LB task
  - [ ] Verify server healthy in LB

- [ ] **Deployment Steps**
  - [ ] Pre-update health check
  - [ ] Application update
  - [ ] Service restart
  - [ ] Post-update health check

- [ ] **Health Checks**
  - [ ] HTTP health check endpoint queried
  - [ ] Retries with delays implemented
  - [ ] Timeout handling
  - [ ] Proper error handling if health check fails

- [ ] **Safety Features**
  - [ ] Deployment pauses between batches
  - [ ] Failure stops deployment
  - [ ] Manual approval option (optional)
  - [ ] Rollback on failure

- [ ] **Testing**
  - [ ] Rolling update completes successfully
  - [ ] Application remains available during update
  - [ ] No requests fail during update
  - [ ] Failed update stops gracefully

### 📦 Deliverables

1. **Rolling Update Playbook**: deploy-rolling.yml
2. **Load Balancer Role**: Role for LB operations
3. **Health Check Tasks**: Health check implementation
4. **Test Results**: Logs showing rolling update
5. **Monitoring**: Evidence of zero downtime
6. **Documentation**: Rolling update procedure

### 🎯 Success Criteria

- Updates complete without downtime
- Application remains available throughout
- Failed servers don't break deployment
- Load balancer integration works correctly
- Process is automated and reliable
- Can handle different batch sizes

---

## Task 4.9: Dynamic Inventory for AWS EC2

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-49-dynamic-inventory-for-aws-ec2)**

### 🎬 Real-World Scenario
Your infrastructure is on AWS EC2, and servers are frequently created/destroyed by auto-scaling. Static inventory files become outdated quickly. Implement dynamic inventory using the AWS EC2 plugin to automatically discover and group instances based on tags, regions, and other attributes.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Configure Ansible to use dynamic inventory with AWS EC2, enabling automatic discovery of instances.

**Requirements:**
1. Install and configure AWS EC2 inventory plugin
2. Configure AWS credentials properly
3. Set up filters to include only relevant instances
4. Group instances by tags (Environment, Role, etc.)
5. Group instances by region and availability zone
6. Configure host variables from instance metadata
7. Set up caching for performance
8. Create example playbooks using dynamic inventory
9. Test with different filters and groups

**AWS Setup:**
- Instances tagged with: Environment (dev/staging/prod)
- Instances tagged with: Role (web/api/database)
- Instances in multiple regions: us-east-1, us-west-2
- Some instances in different VPCs

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **AWS Configuration**
  - [ ] AWS credentials configured (IAM role or profile)
  - [ ] Required IAM permissions documented
  - [ ] boto3 library installed

- [ ] **Inventory Plugin Setup**
  - [ ] aws_ec2.yml inventory file created
  - [ ] Plugin specified correctly
  - [ ] Regions configured

- [ ] **Filters**
  - [ ] Filter by instance state (running)
  - [ ] Filter by tags
  - [ ] Exclude instances appropriately

- [ ] **Grouping**
  - [ ] Keyed groups by Environment tag
  - [ ] Keyed groups by Role tag
  - [ ] Groups by region/AZ
  - [ ] Nested groups work correctly

- [ ] **Host Variables**
  - [ ] ansible_host set to correct IP (public/private)
  - [ ] Tags available as host variables
  - [ ] Compose section creates useful variables

- [ ] **Testing**
  - [ ] ansible-inventory --list works
  - [ ] ansible-inventory --graph shows structure
  - [ ] Can target instances by tag groups
  - [ ] ansible all -m ping succeeds
  - [ ] Caching works (verify cache file)

- [ ] **Documentation**
  - [ ] AWS setup requirements documented
  - [ ] IAM permissions listed
  - [ ] Usage examples provided

### 📦 Deliverables

1. **Inventory Configuration**: aws_ec2.yml file
2. **AWS Documentation**: IAM setup and permissions
3. **Test Playbooks**: Examples using dynamic inventory
4. **Test Results**: Output from inventory commands
5. **Screenshot**: Inventory graph showing groups
6. **Usage Guide**: How to work with dynamic inventory

### 🎯 Success Criteria

- Dynamic inventory successfully discovers instances
- Instances grouped logically by tags and attributes
- Can target any group of instances easily
- Inventory updates automatically as infrastructure changes
- Performance is acceptable (caching works)
- Documentation enables team to use effectively

---

## Task 4.10: Ansible Templates with Jinja2

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-410-ansible-templates-with-jinja2)**

### 🎬 Real-World Scenario
Your application configuration files need to be customized for each environment and server. Rather than maintaining separate config files, create Jinja2 templates that generate configurations dynamically based on variables. This includes Nginx configs, application configs, and environment files.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create comprehensive Jinja2 templates for application and service configuration files.

**Requirements:**
1. Create Nginx configuration template with conditionals
2. Create application configuration template with loops
3. Create environment file template with filters
4. Implement default values with fallbacks
5. Use complex Jinja2 expressions (if/else, for loops, filters)
6. Create templates for multiple file formats (conf, ini, yaml, env)
7. Test templates with different variable sets
8. Document template variables and usage

**Templates to Create:**
- Nginx site configuration
- Application config.yml
- Environment .env file
- Systemd service unit
- Logging configuration

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Nginx Template**
  - [ ] Server name and ports configurable
  - [ ] Conditional SSL configuration
  - [ ] Loop for multiple upstream servers
  - [ ] Location blocks from variables
  - [ ] Security headers included

- [ ] **Application Config Template**
  - [ ] YAML structure maintained
  - [ ] Nested variables handled correctly
  - [ ] Lists and dictionaries from variables
  - [ ] Default values for optional settings

- [ ] **Environment File Template**
  - [ ] Key=value format correct
  - [ ] Boolean values handled properly
  - [ ] Lists converted to comma-separated strings
  - [ ] Sensitive values from vault variables

- [ ] **Jinja2 Features Used**
  - [ ] Conditionals (if/elif/else)
  - [ ] Loops (for loop)
  - [ ] Filters (default, bool, join, etc.)
  - [ ] Variables with dot notation
  - [ ] Comments in templates

- [ ] **Testing**
  - [ ] Templates render without errors
  - [ ] Generated files have correct syntax
  - [ ] Different variable sets produce correct output
  - [ ] Default values work when variables missing

- [ ] **Documentation**
  - [ ] Template variables documented
  - [ ] Examples of variable structures
  - [ ] Edge cases explained

### 📦 Deliverables

1. **Template Files**: All Jinja2 templates (.j2 files)
2. **Variable Files**: Example variable files for testing
3. **Rendered Examples**: Sample output from templates
4. **Test Playbook**: Playbook that deploys templates
5. **Documentation**: Template variable reference
6. **Comparison**: Before/after showing template benefits

### 🎯 Success Criteria

- Templates generate correct configuration files
- Templates are flexible and reusable
- Jinja2 syntax is correct and efficient
- Templates work with various variable combinations
- Generated files validated by target application
- Documentation is clear and complete

---

## Task 4.11: Handlers and Service Management

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-411-handlers-and-service-management)**

### 🎬 Real-World Scenario
Your playbooks restart services every time they run, causing unnecessary downtime. Implement proper handler usage so services only restart when configuration actually changes. Also implement proper service management with health checks and graceful restarts.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement proper handler-based service management across your Ansible roles.

**Requirements:**
1. Create handlers for service operations (restart, reload, stop/start)
2. Notify handlers only when changes occur
3. Implement handler ordering with meta: flush_handlers
4. Create handlers for multiple related services
5. Implement health checks after service restart
6. Add conditional handler execution
7. Implement graceful shutdown procedures
8. Test handler idempotency

**Services to Manage:**
- Nginx (reload vs restart)
- Backend API (graceful restart)
- PostgreSQL (restart only when necessary)
- Load balancer (reload configuration)

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Handler Definition**
  - [ ] Handlers defined in handlers/main.yml
  - [ ] Clear, descriptive handler names
  - [ ] Handlers use appropriate service module

- [ ] **Handler Types**
  - [ ] reload systemd handler
  - [ ] restart service handlers
  - [ ] stop/start service handlers
  - [ ] run command handlers (for scripts)

- [ ] **Notification**
  - [ ] Tasks notify handlers appropriately
  - [ ] Multiple tasks can notify same handler
  - [ ] Handler runs only once even if notified multiple times
  - [ ] Changed_when used correctly

- [ ] **Handler Ordering**
  - [ ] meta: flush_handlers used when immediate execution needed
  - [ ] Handler dependencies handled correctly
  - [ ] Order matters when multiple handlers

- [ ] **Health Checks**
  - [ ] Service status checked after restart
  - [ ] Health check endpoint verified
  - [ ] Wait for service to be ready

- [ ] **Testing**
  - [ ] Running playbook twice doesn't restart services
  - [ ] Changing config file triggers handler
  - [ ] Handler executes successfully
  - [ ] Services remain running after handler

### 📦 Deliverables

1. **Handlers File**: Complete handlers/main.yml
2. **Tasks File**: Tasks with proper notifications
3. **Test Playbook**: Demonstrating handler behavior
4. **Test Results**: Logs showing handlers triggered/not triggered
5. **Documentation**: Handler usage guide
6. **Examples**: Common handler patterns

### 🎯 Success Criteria

- Handlers only run when configuration changes
- Services restart gracefully without errors
- Health checks verify service health
- No unnecessary service disruptions
- Handler implementation follows best practices
- Idempotency maintained

---

## Task 4.12: Conditional Execution and Loops

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-412-conditional-execution-and-loops)**

### 🎬 Real-World Scenario
Your playbooks need to handle different operating systems, environments, and configurations. Implement conditional task execution based on various factors and use loops to avoid repetitive tasks. This makes playbooks more maintainable and flexible.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create playbooks that use conditionals and loops effectively to handle various scenarios.

**Requirements:**
1. Implement OS-specific tasks (Ubuntu vs CentOS vs Amazon Linux)
2. Create environment-specific conditionals (dev vs staging vs prod)
3. Use when conditions with various operators
4. Implement loops with loop, with_items, with_dict
5. Use loop control features (loop_var, index_var, pause)
6. Combine conditionals with loops
7. Use complex conditional expressions (and, or, not)
8. Implement register and use in conditionals

**Scenarios to Implement:**
- Install packages based on OS family
- Configure firewall rules with loops
- Deploy features only in specific environments
- Process list of users/databases/files
- Skip tasks based on previous task results

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Conditional Execution**
  - [ ] when with simple comparison (==, !=, <, >)
  - [ ] when with boolean variables
  - [ ] when with ansible_facts
  - [ ] when with in/not in operators
  - [ ] Complex conditions (and, or, not)

- [ ] **Different Loop Types**
  - [ ] loop with simple list
  - [ ] loop with list of dictionaries
  - [ ] with_dict for dictionary iteration
  - [ ] with_fileglob for file iteration
  - [ ] with_subelements for nested data

- [ ] **Loop Features**
  - [ ] loop_var for custom variable name
  - [ ] index_var for loop index
  - [ ] pause between iterations
  - [ ] label for cleaner output

- [ ] **Combining Conditionals and Loops**
  - [ ] Skip loop items with when
  - [ ] Filter loop items before iteration
  - [ ] Conditional within loop

- [ ] **Register and Conditionals**
  - [ ] Register task results
  - [ ] Use registered variable in when
  - [ ] Check if task changed
  - [ ] Access loop results

- [ ] **Testing**
  - [ ] Playbook runs on different OS
  - [ ] Tasks execute correctly based on conditions
  - [ ] Loops process all items
  - [ ] No items skipped incorrectly

### 📦 Deliverables

1. **Playbooks**: Multiple playbooks demonstrating concepts
2. **Inventory**: Test inventory with different host types
3. **Variables**: Variable files for different scenarios
4. **Test Results**: Output showing conditional execution
5. **Documentation**: Guide to conditionals and loops
6. **Examples**: Common patterns and use cases

### 🎯 Success Criteria

- Conditionals work correctly in all scenarios
- Loops process collections efficiently
- Playbooks adapt to different environments
- Code is readable and maintainable
- No unnecessary task execution
- Documentation explains patterns clearly

---

## Task 4.13: Error Handling and Retries

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-413-error-handling-and-retries)**

### 🎬 Real-World Scenario
Your playbooks sometimes fail due to transient issues like network problems or services not ready. Implement proper error handling with retries, rescue blocks, and failure handling to make playbooks more resilient. This is crucial for production deployments.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement comprehensive error handling and retry logic in Ansible playbooks.

**Requirements:**
1. Use block/rescue/always for error handling
2. Implement retries with until for transient failures
3. Use failed_when to customize failure conditions
4. Use changed_when to control change reporting
5. Implement ignore_errors strategically
6. Use any_errors_fatal for critical playbooks
7. Create error notification tasks
8. Implement rollback in rescue blocks
9. Test failure scenarios

**Scenarios to Handle:**
- Package download failures (retry)
- Service not ready after start (wait and retry)
- Database connection failures (retry with delay)
- API calls with transient failures
- Cleanup operations that should always run

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Block/Rescue/Always**
  - [ ] Block contains risky operations
  - [ ] Rescue handles errors appropriately
  - [ ] Always ensures cleanup
  - [ ] Nested blocks work correctly

- [ ] **Retry Logic**
  - [ ] until condition defined correctly
  - [ ] retries parameter set appropriately
  - [ ] delay between retries configured
  - [ ] Register used to check results

- [ ] **Failure Customization**
  - [ ] failed_when used to define failure
  - [ ] changed_when controls change reporting
  - [ ] ignore_errors used selectively
  - [ ] any_errors_fatal for critical sections

- [ ] **Error Handling Patterns**
  - [ ] HTTP requests with retry
  - [ ] Service health checks with wait
  - [ ] Database operations with retry
  - [ ] File downloads with retry

- [ ] **Cleanup and Rollback**
  - [ ] Always block ensures cleanup
  - [ ] Rescue block performs rollback
  - [ ] Temporary files removed
  - [ ] State restored on failure

- [ ] **Testing**
  - [ ] Transient failures recovered automatically
  - [ ] Permanent failures handled gracefully
  - [ ] Cleanup executes even on failure
  - [ ] Notifications sent on failure

### 📦 Deliverables

1. **Playbooks**: Examples with error handling
2. **Roles**: Roles with retry logic
3. **Test Scenarios**: Scripts to simulate failures
4. **Test Results**: Logs showing error handling
5. **Documentation**: Error handling patterns guide
6. **Best Practices**: Guidelines for error handling

### 🎯 Success Criteria

- Transient failures recovered automatically
- Permanent failures fail gracefully
- Cleanup always executes
- Playbooks are more resilient
- Error messages are clear
- Documentation covers all patterns

---

## Task 4.14: Ansible Tags for Selective Execution

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-414-ansible-tags-for-selective-execution)**

### 🎬 Real-World Scenario
Your deployment playbook takes 30 minutes to run, but you only need to update Nginx configuration. Implement tags to enable selective execution of specific parts of playbooks without running everything. This dramatically speeds up targeted changes and troubleshooting.

### ⏱️ Time to Complete: 45 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement a comprehensive tagging strategy for your playbooks and roles.

**Requirements:**
1. Tag tasks by function (install, configure, deploy, test)
2. Tag tasks by component (nginx, api, database)
3. Tag tasks by phase (pre, main, post)
4. Use multiple tags on single tasks
5. Tag entire plays
6. Tag included tasks and roles
7. Use special tags (always, never, tagged, untagged)
8. Create tag usage documentation

**Tagging Strategy:**
- Function: install, configure, deploy, restart, backup, test
- Component: nginx, backend, database, loadbalancer
- Phase: pre-deploy, deploy, post-deploy, verify

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Task Tagging**
  - [ ] Tasks tagged by function
  - [ ] Tasks tagged by component
  - [ ] Multiple tags on tasks where appropriate
  - [ ] Consistent tag naming

- [ ] **Play Tagging**
  - [ ] Plays tagged appropriately
  - [ ] Tags inherited by tasks

- [ ] **Special Tags**
  - [ ] always tag for mandatory tasks
  - [ ] never tag for manual-only tasks
  - [ ] Pre-tasks and post-tasks tagged

- [ ] **Role Tagging**
  - [ ] Roles tagged when included
  - [ ] Tags passed to roles appropriately

- [ ] **Testing**
  - [ ] --tags "tag1,tag2" works
  - [ ] --skip-tags works
  - [ ] --tags all works
  - [ ] --list-tags shows all tags
  - [ ] --list-tasks shows tasks for tag

- [ ] **Documentation**
  - [ ] Available tags documented
  - [ ] Tag combinations explained
  - [ ] Common use cases provided
  - [ ] Examples of tag usage

### 📦 Deliverables

1. **Tagged Playbooks**: All playbooks with tags
2. **Tag Reference**: Documentation of all tags
3. **Usage Examples**: Common tag command combinations
4. **Test Results**: Output showing selective execution
5. **Cheat Sheet**: Quick reference for tags
6. **Best Practices**: Tagging conventions guide

### �� Success Criteria

- Tags enable efficient selective execution
- Tag naming is consistent and intuitive
- Can target any combination of tasks
- Documentation makes tags easy to use
- Significantly reduces execution time for targeted changes
- Team adopts tagging strategy

---

## Appendix: Common Patterns and Tips

### Best Practices Summary

1. **Structure**: Follow standard Ansible directory layout
2. **Idempotency**: Ensure tasks can run multiple times safely
3. **Variables**: Use clear naming and appropriate precedence
4. **Secrets**: Always use Ansible Vault for sensitive data
5. **Testing**: Test with --check and --diff before applying
6. **Tags**: Use tags for selective execution
7. **Handlers**: Only restart services when necessary
8. **Error Handling**: Implement retries and rescue blocks
9. **Documentation**: Document everything for the team
10. **Version Control**: Commit all code except secrets

### Common Commands Reference

```bash
# Playbook execution
ansible-playbook playbook.yml
ansible-playbook playbook.yml --check              # Dry run
ansible-playbook playbook.yml --diff               # Show changes
ansible-playbook playbook.yml --tags "deploy"      # Run specific tags
ansible-playbook playbook.yml --skip-tags "slow"   # Skip tags
ansible-playbook playbook.yml -e "var=value"       # Extra vars

# Inventory
ansible-inventory --list
ansible-inventory --graph
ansible-inventory --host hostname

# Vault
ansible-vault create secret.yml
ansible-vault edit secret.yml
ansible-vault view secret.yml
ansible-vault encrypt file.yml
ansible-vault decrypt file.yml
ansible-vault rekey secret.yml

# Ad-hoc commands
ansible all -m ping
ansible webservers -m shell -a "uptime"
ansible database -m service -a "name=postgresql state=restarted" --become

# Validation
ansible-playbook playbook.yml --syntax-check
ansible-lint playbook.yml
yamllint playbook.yml
```

### Troubleshooting Tips

1. **Use verbose mode**: `-v`, `-vv`, `-vvv`, `-vvvv`
2. **Check syntax**: `--syntax-check`
3. **Dry run**: `--check --diff`
4. **Debug tasks**: Use `debug` module
5. **Register variables**: Examine task output
6. **Check connectivity**: `ansible all -m ping`
7. **Verify inventory**: `ansible-inventory --list`
8. **Check facts**: `ansible hostname -m setup`

---

**Ready to master Ansible?** Start with Task 4.1 and work through each task systematically. For complete solutions with detailed implementations, see [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)
