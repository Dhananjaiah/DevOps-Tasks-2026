# Part 1: Linux Real-World Tasks for DevOps Engineers

> **📚 Navigation:** [Solutions →](./REAL-WORLD-TASKS-SOLUTIONS.md) | [Part 1 README](./README.md) | [Main README](../README.md)

## 🎯 Overview

This document provides **real-world, executable tasks** that you can assign to DevOps engineers. Each task includes:
- **Clear scenario and context**
- **Time estimate for completion**
- **Step-by-step assignment instructions**
- **Validation checklist**
- **Expected deliverables**

These tasks are designed to be practical assignments that simulate actual production work.

> **💡 Looking for solutions?** Complete solutions with step-by-step implementations are available in [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)

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

---

## 📑 Task Index

Quick navigation to tasks and their solutions:

| # | Task Name | Difficulty | Time | Solution Link |
|---|-----------|------------|------|---------------|
| 1.1 | [Production Server Hardening](#task-11-production-server-hardening) | Medium | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-11-production-server-hardening) |
| 1.2 | [SSH Key Management](#task-12-ssh-key-management-for-team-access) | Medium | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-12-ssh-key-management-for-team-access) |
| 1.3 | [User and Group Management](#task-13-user-and-group-management-for-application-deployment) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-13-user-and-group-management-for-application-deployment) |
| 1.4 | [Filesystem Management and Quota Setup](#task-14-filesystem-management-and-quota-setup) | Hard | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-14-filesystem-management-and-quota-setup) |
| 1.5 | [Systemd Service Creation](#task-15-systemd-service-creation-for-backend-api) | Medium | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-15-systemd-service-creation-for-backend-api) |
| 1.6 | [Firewall Configuration](#task-16-firewall-configuration-for-multi-tier-application) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-16-firewall-configuration-for-multi-tier-application) |
| 1.7 | [Centralized Logging](#task-17-centralized-logging-setup-with-journald) | Medium | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-17-centralized-logging-setup-with-journald) |
| 1.8 | [Performance Monitoring](#task-18-performance-monitoring-and-troubleshooting) | Hard | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-18-performance-monitoring-and-troubleshooting) |
| 1.9 | [Package Management](#task-19-package-management-and-custom-repository) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-19-package-management-and-custom-repository) |
| 1.10 | [PostgreSQL Backup Automation](#task-110-postgresql-backup-automation) | Hard | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-110-postgresql-backup-automation) |
| 1.11 | [Log Rotation Configuration](#task-111-log-rotation-configuration) | Easy | 45 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-111-log-rotation-configuration) |
| 1.12 | [Disk Space Crisis Management](#task-112-disk-space-crisis-management) | Medium | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-112-disk-space-crisis-management) |
| 1.13 | [Network Troubleshooting](#task-113-network-connectivity-troubleshooting) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-113-network-connectivity-troubleshooting) |
| 1.14 | [Systemd Timers](#task-114-systemd-timers-for-scheduled-tasks) | Medium | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-114-systemd-timers-for-scheduled-tasks) |
| 1.15 | [Security Incident Response](#task-115-security-incident-response) | Hard | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-115-security-incident-response) |
| 1.16 | [DNS Configuration](#task-116-dns-configuration-and-troubleshooting) | Medium | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-116-dns-configuration-and-troubleshooting) |
| 1.17 | [Process Priority Management](#task-117-process-priority-management) | Easy | 45 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-117-process-priority-management) |
| 1.18 | [High CPU/Memory Troubleshooting](#task-118-high-cpu-and-memory-troubleshooting) | Hard | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-118-high-cpu-and-memory-troubleshooting) |

---

## Task 1.1: Production Server Hardening

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-11-production-server-hardening)**

### 🎬 Real-World Scenario
Your company is launching a new web application. You've been assigned to harden a new Ubuntu 20.04 EC2 instance that will host the backend API. The instance must meet security compliance requirements before the application can be deployed.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Harden an EC2 Linux instance following security best practices. The server will be exposed to the internet and must be protected against common attacks.

**Requirements:**
1. Update all system packages to latest versions
2. Configure automatic security updates
3. Set up and configure fail2ban to prevent brute force attacks
4. Configure UFW firewall (allow SSH, HTTP, HTTPS only)
5. Disable unnecessary services
6. Apply kernel security parameters
7. Set up basic audit logging
8. Harden SSH configuration (disable root login, key-only auth)

**Environment:**
- Fresh Ubuntu 20.04 EC2 instance
- Public IP address provided
- Initial SSH access via password (your responsibility to secure it)
- sudo access available

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **System Updates**
  - [ ] All packages updated to latest versions
  - [ ] Unattended-upgrades installed and configured
  - [ ] Security updates set to automatic

- [ ] **Fail2Ban**
  - [ ] Fail2ban installed and running
  - [ ] SSH jail enabled with maxretry=3
  - [ ] Ban time set to 1 hour
  - [ ] Service status shows active

- [ ] **Firewall (UFW)**
  - [ ] UFW enabled and active
  - [ ] Only ports 22, 80, 443 allowed
  - [ ] Default incoming policy: deny
  - [ ] Default outgoing policy: allow

- [ ] **Service Hardening**
  - [ ] At least 3 unnecessary services disabled
  - [ ] List of disabled services documented

- [ ] **Kernel Parameters**
  - [ ] IP spoofing protection enabled
  - [ ] ICMP redirects disabled
  - [ ] TCP SYN cookies enabled
  - [ ] Changes persisted in /etc/sysctl.conf

- [ ] **Audit Logging**
  - [ ] auditd installed and running
  - [ ] Rules for monitoring /etc/passwd, /etc/shadow, /etc/sudoers
  - [ ] SSH configuration changes monitored

- [ ] **SSH Hardening**
  - [ ] Root login disabled (PermitRootLogin no)
  - [ ] Password authentication disabled
  - [ ] Key-based authentication working
  - [ ] MaxAuthTries set to 3
  - [ ] ClientAliveInterval configured

### 📦 Required Deliverables

Submit the following:

1. **Security Audit Report** (text file)
   ```
   hostname: [server hostname]
   date: [completion date]
   
   System Updates:
   - Packages updated: [count]
   - Unattended upgrades: [enabled/disabled]
   
   Fail2Ban Status:
   [output of: sudo fail2ban-client status]
   
   Firewall Rules:
   [output of: sudo ufw status verbose]
   
   Disabled Services:
   [list services disabled and why]
   
   Active Kernel Parameters:
   [output of: sysctl net.ipv4.tcp_syncookies net.ipv4.conf.all.rp_filter]
   
   SSH Configuration:
   [relevant lines from /etc/ssh/sshd_config]
   ```

2. **Screenshot Evidence**
   - UFW status showing active firewall
   - Fail2ban status showing SSH jail enabled
   - Successful SSH connection using key (no password prompt)

3. **Test Results**
   - Attempt failed SSH login 4 times (should trigger ban)
   - Show IP banned: `sudo fail2ban-client get sshd banned`
   - Port scan results showing only 22, 80, 443 open

### 🎯 Success Criteria

Your hardening is successful if:
- ✅ All validation checklist items are complete
- ✅ Failed SSH attempts trigger automatic IP bans
- ✅ Port scan shows only allowed ports open
- ✅ SSH works only with keys (password rejected)
- ✅ System survives reboot with all settings intact
- ✅ Audit logs capture security-relevant events

---

## Task 1.2: SSH Key Management for Team Access

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-12-ssh-key-management-for-team-access)**

### 🎬 Real-World Scenario
Your team is growing. You need to set up secure SSH access for 3 new DevOps engineers joining next week. Each engineer needs access to production servers with different permission levels. You must implement key-based authentication with proper access controls.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Set up SSH key-based authentication for 3 team members with different access levels on a Linux server.

**Team Members & Access:**
1. **Senior Engineer (alice)**: Full sudo access, can SSH directly
2. **Mid-Level Engineer (bob)**: Limited sudo access (specific commands only)
3. **Junior Engineer (charlie)**: No sudo access, specific directory access only

**Requirements:**
1. Create user accounts for all three engineers
2. Configure SSH key-based authentication for each
3. Disable password authentication server-wide
4. Set up appropriate sudo permissions
5. Configure SSH client config for easy access
6. Implement key rotation procedure
7. Document the access structure

**Environment:**
- Ubuntu 20.04 server with sudo access
- You'll need to generate keys for testing (simulate user keys)
- Server has internet connectivity

### ✅ Validation Checklist

- [ ] **User Accounts**
  - [ ] User 'alice' created with home directory
  - [ ] User 'bob' created with home directory
  - [ ] User 'charlie' created with home directory
  - [ ] All users in appropriate groups

- [ ] **SSH Key Setup**
  - [ ] SSH keys generated for each user (ED25519 or RSA 4096)
  - [ ] Public keys added to each user's authorized_keys
  - [ ] Correct permissions: ~/.ssh (700), authorized_keys (600)
  - [ ] Key comments identify each user

- [ ] **SSH Configuration**
  - [ ] Password authentication disabled globally
  - [ ] PubkeyAuthentication enabled
  - [ ] PermitRootLogin set to no
  - [ ] Each user can SSH with their key only

- [ ] **Sudo Configuration**
  - [ ] alice has full sudo access (wheel/sudo group)
  - [ ] bob can only run: systemctl restart nginx, journalctl, docker commands
  - [ ] charlie has no sudo access
  - [ ] Sudoers configuration tested and working

- [ ] **SSH Client Configuration**
  - [ ] ~/.ssh/config created with entries for all users
  - [ ] Host aliases configured (alice-prod, bob-prod, charlie-prod)
  - [ ] Connection works with simple: ssh alice-prod

- [ ] **Documentation**
  - [ ] Access matrix documented
  - [ ] Key rotation procedure written
  - [ ] Emergency access procedure documented

### 📦 Required Deliverables

1. **Access Matrix Document**
   ```
   # SSH Access Configuration
   
   ## User Access Levels
   | User    | SSH Access | Sudo Access | Allowed Commands              |
   |---------|-----------|-------------|-------------------------------|
   | alice   | Yes       | Full        | All                           |
   | bob     | Yes       | Limited     | systemctl, journalctl, docker |
   | charlie | Yes       | None        | N/A                           |
   
   ## SSH Keys
   - alice: [key fingerprint]
   - bob: [key fingerprint]
   - charlie: [key fingerprint]
   
   ## Key Rotation Schedule
   [Describe rotation process and frequency]
   ```

2. **Configuration Files**
   - `/etc/sudoers.d/devops-team` (or relevant sudoers config)
   - Sample `~/.ssh/config` for client machines
   - Each user's authorized_keys file content

3. **Test Results**
   ```
   # alice tests
   $ ssh alice-prod "sudo ls /root"
   [should succeed]
   
   # bob tests
   $ ssh bob-prod "sudo systemctl restart nginx"
   [should succeed]
   $ ssh bob-prod "sudo cat /etc/shadow"
   [should fail]
   
   # charlie tests
   $ ssh charlie-prod "sudo ls"
   [should fail - no sudo access]
   $ ssh charlie-prod "ls ~"
   [should succeed]
   ```

4. **Key Rotation Procedure**
   Write a bash script that automates key rotation:
   - Generates new key pair
   - Adds new key to authorized_keys (keeping old one)
   - Waits for confirmation
   - Removes old key
   - Tests new key

### 🎯 Success Criteria

- ✅ All three users can SSH using keys only
- ✅ Password authentication fails for all users
- ✅ alice has full sudo access
- ✅ bob can only run specified commands with sudo
- ✅ charlie cannot use sudo at all
- ✅ SSH config allows easy connection (ssh hostname)
- ✅ Key rotation procedure is documented and tested

---

## Task 1.3: User and Group Management for Application Deployment

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-13-user-and-group-management-for-application-deployment)**

### 🎬 Real-World Scenario
Your company is deploying a new microservices application. You need to set up proper user and group structures for the deployment pipeline. The CI/CD system needs limited access to deploy apps, developers need read-only access for debugging, and the applications themselves need minimal privileges to run.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create a secure user and group structure for a multi-tier application with proper separation of privileges.

**System Requirements:**
1. **Deployment User (deploy)**: 
   - Can start/stop application services
   - Can deploy new code to /opt/applications
   - Cannot modify system configurations
   - Can view logs

2. **Application Users**:
   - frontend-app: Runs the frontend service
   - backend-app: Runs the backend API
   - worker-app: Runs background workers
   - Each should have minimal privileges

3. **Developer Group (developers)**:
   - Read-only access to application directories
   - Can view application logs
   - Cannot modify running services

4. **Groups Structure**:
   - app-services: Contains all application service users
   - deployers: Contains deploy user
   - developers: Contains developer users

**Environment:**
- Ubuntu 20.04 server
- Application directory: /opt/applications
- Log directory: /var/log/applications
- Systemd for service management

### ✅ Validation Checklist

- [ ] **User Creation**
  - [ ] deploy user created with home directory
  - [ ] frontend-app user created (system user, no login)
  - [ ] backend-app user created (system user, no login)
  - [ ] worker-app user created (system user, no login)
  - [ ] Two test developer users created (dev1, dev2)

- [ ] **Group Structure**
  - [ ] app-services group created
  - [ ] deployers group created
  - [ ] developers group created
  - [ ] Users assigned to correct groups

- [ ] **Directory Permissions**
  - [ ] /opt/applications created (owner: deploy, group: app-services)
  - [ ] /opt/applications/frontend (owner: frontend-app, group: app-services)
  - [ ] /opt/applications/backend (owner: backend-app, group: app-services)
  - [ ] /opt/applications/worker (owner: worker-app, group: app-services)
  - [ ] /var/log/applications created with appropriate permissions
  - [ ] Developers have read access to app directories
  - [ ] Developers have read access to log directories

- [ ] **Sudoers Configuration**
  - [ ] deploy can run: systemctl start/stop/restart/status app-*
  - [ ] deploy can run: journalctl for application services
  - [ ] deploy CANNOT run: systemctl daemon-reload, edit configs
  - [ ] sudoers syntax validated

- [ ] **ACLs (if needed)**
  - [ ] ACLs set for developer group to read application files
  - [ ] ACLs documented

- [ ] **Security**
  - [ ] Application users cannot login (shell: /sbin/nologin)
  - [ ] Home directories have correct permissions
  - [ ] No world-writable files in application directories

### 📦 Required Deliverables

1. **User and Group Report**
   ```
   # System Users and Groups Configuration
   Date: [date]
   
   ## Users Created
   [output of: getent passwd | grep -E 'deploy|frontend-app|backend-app|worker-app|dev1|dev2']
   
   ## Groups Created
   [output of: getent group | grep -E 'app-services|deployers|developers']
   
   ## Group Memberships
   deploy: [groups deploy is in]
   frontend-app: [groups]
   backend-app: [groups]
   worker-app: [groups]
   dev1: [groups]
   dev2: [groups]
   
   ## Directory Permissions
   [output of: ls -la /opt/applications]
   [output of: ls -la /opt/applications/*/]
   [output of: ls -la /var/log/applications]
   ```

2. **Sudoers Configuration**
   Content of `/etc/sudoers.d/deploy-user`:
   ```
   # Deploy user permissions
   # [paste your sudoers config]
   ```

3. **Test Results Document**
   ```
   # Permission Tests Performed
   
   ## Deploy User Tests
   $ sudo -u deploy systemctl restart app-frontend
   [result: should succeed]
   
   $ sudo -u deploy systemctl daemon-reload
   [result: should fail]
   
   $ sudo -u deploy cat /var/log/applications/frontend.log
   [result: should succeed]
   
   ## Developer Tests
   $ sudo -u dev1 ls /opt/applications/frontend
   [result: should succeed - read only]
   
   $ sudo -u dev1 touch /opt/applications/frontend/test.txt
   [result: should fail - no write]
   
   $ sudo -u dev1 tail /var/log/applications/frontend.log
   [result: should succeed - read only]
   
   ## Application User Tests
   $ sudo -u frontend-app bash
   [result: should fail - nologin shell]
   
   $ sudo -u frontend-app ls /opt/applications/frontend
   [result: should succeed]
   ```

4. **Setup Script**
   Provide a bash script that recreates your entire setup:
   ```bash
   #!/bin/bash
   # User and Group Setup Script
   # This script creates all users, groups, and permissions
   
   # [Your script here]
   ```

### 🎯 Success Criteria

- ✅ All users and groups created correctly
- ✅ deploy user can manage application services but not system
- ✅ Application users cannot login interactively
- ✅ Developers have read-only access to app directories and logs
- ✅ Directory permissions follow principle of least privilege
- ✅ Sudoers configuration is secure and tested
- ✅ Setup can be reproduced with provided script
- ✅ No security warnings from: `sudo visudo -c` and permission checks

---

## Task 1.4: Filesystem Management and Quota Setup

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-14-filesystem-management-and-quota-setup)**

### 🎬 Real-World Scenario
Your application generates large amounts of log files and user uploads. The disk on your production server is 100GB, and you've noticed the /var partition is filling up quickly. You need to implement a proper filesystem structure with quotas to prevent any single service from filling the disk.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Set up proper filesystem management with disk quotas for application services.

**Requirements:**
1. Create separate mount points for critical directories
2. Implement disk quotas for application users
3. Set up ACLs for shared directories
4. Configure proper permissions on all filesystems
5. Monitor disk usage and set up alerts
6. Create a disk management script

**Filesystem Structure:**
```
/opt/applications     (main application code)
/var/log/applications (application logs) - quota: 10GB per app
/opt/uploads          (user file uploads) - quota: 20GB total
/opt/backups          (database backups) - quota: 30GB
```

**Quota Limits:**
- frontend-app logs: 5GB
- backend-app logs: 10GB
- worker-app logs: 5GB
- uploads directory: 20GB total
- backup directory: 30GB total

### ✅ Validation Checklist

- [ ] **Directory Structure**
  - [ ] All required directories created
  - [ ] Ownership set correctly
  - [ ] Base permissions configured (755 for directories)

- [ ] **Disk Quotas**
  - [ ] Quota support enabled on filesystem
  - [ ] User quotas configured for application users
  - [ ] Soft and hard limits set
  - [ ] Grace periods configured
  - [ ] Quotas active and enforced

- [ ] **ACLs Configuration**
  - [ ] ACLs enabled on filesystem
  - [ ] Shared directories have ACLs for groups
  - [ ] Default ACLs set for new files
  - [ ] ACLs tested and verified

- [ ] **Permissions**
  - [ ] Sticky bit set on shared directories
  - [ ] SGID bit set where appropriate
  - [ ] No world-writable directories without sticky bit
  - [ ] Critical files have immutable attribute (if needed)

- [ ] **Monitoring**
  - [ ] Disk usage monitoring script created
  - [ ] Script checks quota usage
  - [ ] Alert mechanism implemented
  - [ ] Cron job scheduled for regular checks

### 📦 Required Deliverables

1. **Filesystem Configuration Report**
   ```
   # Filesystem Management Report
   
   ## Directory Structure
   [output of: tree -L 2 -d /opt /var/log/applications]
   
   ## Ownership and Permissions
   [output of: ls -lhd /opt/applications /var/log/applications/* /opt/uploads /opt/backups]
   
   ## Quota Status
   [output of: sudo repquota -a]
   
   ## Disk Usage
   [output of: df -h]
   
   ## ACL Configuration
   [output of: getfacl /opt/uploads /opt/applications]
   ```

2. **Quota Configuration Details**
   ```
   # Quota Setup Documentation
   
   User: frontend-app
   - Soft Limit: 4GB
   - Hard Limit: 5GB
   - Grace Period: 7 days
   
   User: backend-app
   - Soft Limit: 8GB
   - Hard Limit: 10GB
   - Grace Period: 7 days
   
   [etc...]
   ```

3. **Disk Monitoring Script** (`/usr/local/bin/check_disk_usage.sh`)
   ```bash
   #!/bin/bash
   # Disk Usage Monitoring Script
   # Checks disk usage and quota status
   # Sends alerts if thresholds exceeded
   
   # [Your script here]
   ```

4. **ACL Configuration**
   Document all ACL settings:
   ```
   # /opt/uploads ACLs
   [output of: getfacl /opt/uploads]
   
   # Purpose: Allow developers read access, deployers read/write
   
   [repeat for each directory with ACLs]
   ```

5. **Test Results**
   ```
   # Test 1: Quota Enforcement
   $ sudo -u frontend-app dd if=/dev/zero of=/var/log/applications/frontend/test.img bs=1M count=6000
   [should fail when hitting hard limit]
   
   # Test 2: ACL Permissions
   $ sudo -u dev1 cat /opt/uploads/test-file.txt
   [should succeed - read access]
   
   $ sudo -u dev1 rm /opt/uploads/test-file.txt
   [should fail - no write access]
   
   # Test 3: Monitoring Script
   $ sudo /usr/local/bin/check_disk_usage.sh
   [should report current usage and any alerts]
   ```

### 🎯 Success Criteria

- ✅ All directories created with correct ownership
- ✅ Disk quotas active and enforcing limits
- ✅ User cannot exceed hard quota limit (tested)
- ✅ ACLs properly configured for shared access
- ✅ Monitoring script detects and alerts on high usage
- ✅ Quota reports show current usage for all users
- ✅ Grace periods work correctly for soft limits
- ✅ System prevents disk from filling completely

---

## Task 1.5: Systemd Service Creation for Backend API

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-15-systemd-service-creation-for-backend-api)**

### 🎬 Real-World Scenario
Your team has developed a Node.js backend API that needs to run as a service on the production server. The application must start automatically on boot, restart on failure, and be manageable through systemctl. You need to create a robust systemd service unit.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create and configure a production-ready systemd service for a backend API application.

**Application Details:**
- Application: Node.js REST API
- Location: /opt/applications/backend/
- Main file: /opt/applications/backend/server.js
- Port: 8080
- User: backend-app
- Environment: production
- Dependencies: PostgreSQL database, Redis cache

**Service Requirements:**
1. Auto-start on boot
2. Auto-restart on failure (with backoff)
3. Proper logging to journald
4. Resource limits (memory, CPU)
5. Security restrictions
6. Health check integration
7. Graceful shutdown handling

**Environment:**
- Ubuntu 20.04
- Node.js 16+ installed
- Application files already deployed
- backend-app user already created

### ✅ Validation Checklist

- [ ] **Service Unit File**
  - [ ] Unit file created at /etc/systemd/system/backend-api.service
  - [ ] Description and documentation provided
  - [ ] Dependencies specified (After=, Requires=)
  - [ ] User and Group specified
  - [ ] Working directory set

- [ ] **Service Configuration**
  - [ ] ExecStart command correct
  - [ ] ExecStop for graceful shutdown
  - [ ] Restart policy configured (on-failure)
  - [ ] RestartSec with backoff
  - [ ] Type= set appropriately (simple, forking, etc.)

- [ ] **Environment Variables**
  - [ ] NODE_ENV=production
  - [ ] PORT=8080
  - [ ] Other required variables
  - [ ] Secrets handled securely (not in unit file)

- [ ] **Resource Limits**
  - [ ] Memory limit set (MemoryLimit=)
  - [ ] CPU quota if needed (CPUQuota=)
  - [ ] File descriptor limits (LimitNOFILE=)
  - [ ] Number of processes limited

- [ ] **Security Hardening**
  - [ ] PrivateTmp=yes
  - [ ] NoNewPrivileges=yes
  - [ ] ProtectSystem=strict or full
  - [ ] ProtectHome=yes
  - [ ] ReadOnlyPaths for sensitive directories
  - [ ] Appropriate capabilities (drop all, add only needed)

- [ ] **Service Management**
  - [ ] Service enabled for auto-start
  - [ ] Service starts successfully
  - [ ] Service stops gracefully
  - [ ] Service restarts on failure
  - [ ] systemctl status shows active (running)

### 📦 Required Deliverables

1. **Systemd Service Unit File** (`/etc/systemd/system/backend-api.service`)
   ```ini
   [Unit]
   Description=Backend API Service
   # [Complete your unit file here]
   
   [Service]
   # [Service configuration]
   
   [Install]
   # [Install section]
   ```

2. **Service Management Documentation**
   ```
   # Backend API Service Management
   
   ## Start/Stop/Restart
   sudo systemctl start backend-api
   sudo systemctl stop backend-api
   sudo systemctl restart backend-api
   
   ## Enable/Disable
   sudo systemctl enable backend-api
   sudo systemctl disable backend-api
   
   ## Check Status
   sudo systemctl status backend-api
   journalctl -u backend-api -f
   
   ## Health Check
   curl http://localhost:8080/health
   
   ## Configuration Reload
   [steps to reload config without downtime]
   ```

3. **Test Results**
   ```
   # Service Tests
   
   ## Test 1: Service starts successfully
   $ sudo systemctl start backend-api
   $ sudo systemctl status backend-api
   [should show active (running)]
   
   ## Test 2: Auto-restart on failure
   $ sudo kill -9 $(pgrep -f server.js)
   $ sleep 3
   $ sudo systemctl status backend-api
   [should show restarted automatically]
   
   ## Test 3: Graceful shutdown
   $ sudo systemctl stop backend-api
   $ journalctl -u backend-api -n 20
   [should show graceful shutdown, no errors]
   
   ## Test 4: Auto-start on boot
   $ sudo systemctl is-enabled backend-api
   [should show: enabled]
   
   ## Test 5: Resource limits
   $ systemctl show backend-api | grep -E 'Memory|CPU|LimitNOFILE'
   [should show configured limits]
   
   ## Test 6: Health check
   $ curl http://localhost:8080/health
   [should return healthy status]
   ```

4. **Troubleshooting Guide**
   ```
   # Common Issues and Solutions
   
   ## Service won't start
   Problem: [describe]
   Solution: [steps to diagnose and fix]
   
   ## Service keeps restarting
   Problem: [describe]
   Solution: [steps to diagnose and fix]
   
   ## High memory usage
   Problem: [describe]
   Solution: [steps to diagnose and fix]
   
   [Add more scenarios]
   ```

5. **Monitoring Script** (bonus)
   ```bash
   #!/bin/bash
   # backend-api-monitor.sh
   # Checks service health and alerts if down
   
   # [Your monitoring script]
   ```

### 🎯 Success Criteria

- ✅ Service starts and stops correctly
- ✅ Service auto-starts on system boot
- ✅ Service restarts automatically on failure
- ✅ Graceful shutdown works (no connections dropped)
- ✅ Resource limits are enforced
- ✅ Security features enabled (PrivateTmp, NoNewPrivileges, etc.)
- ✅ Logs appear in journald
- ✅ Health check endpoint responds
- ✅ Service survives system reboot
- ✅ All systemd best practices followed

---

## Task 1.6: Firewall Configuration for Multi-Tier Application

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-16-firewall-configuration-for-multi-tier-application)**

### 🎬 Real-World Scenario
Your company runs a 3-tier web application: frontend (port 80/443), backend API (port 8080), and PostgreSQL database (port 5432). Currently, all ports are open, which is a security risk. You need to configure firewall rules that allow only necessary traffic between components while blocking everything else.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Configure UFW/iptables firewall rules for a multi-tier application with proper network segmentation.

**Application Architecture:**
```
Internet → Frontend (80/443) → Backend API (8080) → PostgreSQL (5432)
         ↓
    SSH Access (22) - Limited IPs only
    Monitoring (9090) - Internal network only
```

**Requirements:**
1. Frontend server accepts HTTP/HTTPS from anywhere
2. Backend API accepts connections only from frontend server
3. PostgreSQL accepts connections only from backend server
4. SSH access only from company IP range (e.g., 203.0.113.0/24)
5. Monitoring port (9090) accessible only from monitoring server
6. All other incoming traffic blocked
7. Outgoing traffic allowed for updates
8. Rules persist across reboots

**Environment:**
- Ubuntu 20.04 servers (you can use 3 VMs or simulate with network namespaces)
- Frontend IP: 10.0.1.10
- Backend IP: 10.0.2.10
- Database IP: 10.0.3.10
- Monitoring IP: 10.0.4.10
- Company IP range: 203.0.113.0/24

### ✅ Validation Checklist

- [ ] **Frontend Server Firewall**
  - [ ] Allows HTTP (80) from anywhere (0.0.0.0/0)
  - [ ] Allows HTTPS (443) from anywhere
  - [ ] Allows SSH (22) only from 203.0.113.0/24
  - [ ] Blocks all other incoming traffic
  - [ ] Allows outgoing to backend API on 8080

- [ ] **Backend Server Firewall**
  - [ ] Allows port 8080 only from frontend server (10.0.1.10)
  - [ ] Allows SSH (22) only from 203.0.113.0/24
  - [ ] Allows monitoring (9090) only from 10.0.4.10
  - [ ] Blocks all other incoming traffic
  - [ ] Allows outgoing to database on 5432

- [ ] **Database Server Firewall**
  - [ ] Allows port 5432 only from backend server (10.0.2.10)
  - [ ] Allows SSH (22) only from 203.0.113.0/24
  - [ ] Blocks all other incoming traffic
  - [ ] No direct internet access except for updates

- [ ] **Persistence**
  - [ ] Rules persist after reboot
  - [ ] Firewall starts automatically on boot
  - [ ] Backup of rules created

- [ ] **Logging**
  - [ ] Dropped packets logged
  - [ ] Rate limiting on logs to prevent flooding
  - [ ] Log file rotation configured

### 📦 Required Deliverables

1. **Firewall Rules Documentation**
   ```
   # Frontend Server (10.0.1.10)
   [output of: sudo ufw status verbose]
   or
   [output of: sudo iptables -L -n -v]
   
   # Backend Server (10.0.2.10)
   [output of firewall rules]
   
   # Database Server (10.0.3.10)
   [output of firewall rules]
   ```

2. **Configuration Scripts**
   ```bash
   #!/bin/bash
   # frontend-firewall.sh
   # Configures firewall rules for frontend server
   
   # [Your script for frontend]
   
   #!/bin/bash
   # backend-firewall.sh
   # [Your script for backend]
   
   #!/bin/bash
   # database-firewall.sh
   # [Your script for database]
   ```

3. **Network Flow Diagram**
   Document the allowed traffic flows:
   ```
   Internet → Frontend:80/443
   Frontend:* → Backend:8080
   Backend:* → Database:5432
   203.0.113.0/24 → All:22
   10.0.4.10 → Backend:9090
   ```

4. **Test Results**
   ```
   # Test 1: HTTP access to frontend (should work)
   $ curl http://10.0.1.10
   [result]
   
   # Test 2: Direct access to backend from internet (should fail)
   $ curl http://10.0.2.10:8080
   [result: connection refused/timeout]
   
   # Test 3: Frontend to backend (should work)
   $ ssh 10.0.1.10 "curl http://10.0.2.10:8080"
   [result: success]
   
   # Test 4: Direct database access from internet (should fail)
   $ telnet 10.0.3.10 5432
   [result: connection refused/timeout]
   
   # Test 5: Backend to database (should work)
   $ ssh 10.0.2.10 "psql -h 10.0.3.10 -U appuser -c '\l'"
   [result: success]
   
   # Test 6: SSH from company IP (should work)
   $ ssh -o "ProxyCommand ssh 203.0.113.1 -W %h:%p" 10.0.1.10
   [result: success]
   
   # Test 7: SSH from other IP (should fail)
   [simulate from different IP, should timeout]
   ```

5. **Troubleshooting Log**
   ```
   # Firewall Logs Analysis
   $ sudo tail -f /var/log/ufw.log
   [show dropped connections]
   
   $ sudo journalctl -k | grep "UFW BLOCK"
   [show blocked attempts]
   ```

### 🎯 Success Criteria

- ✅ Frontend accessible from internet on 80/443 only
- ✅ Backend NOT accessible directly from internet
- ✅ Database NOT accessible directly from internet
- ✅ Application communication works (frontend→backend→database)
- ✅ SSH access restricted to company IP range
- ✅ Monitoring access restricted to monitoring server
- ✅ All rules persist after reboot
- ✅ Unauthorized access attempts are logged
- ✅ Zero security warnings from security scan

---

## Task 1.7: Centralized Logging Setup with Journald

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-17-centralized-logging-setup-with-journald)**

### 🎬 Real-World Scenario
Your team manages 5 application servers, and troubleshooting issues requires checking logs on each server individually. This is time-consuming and inefficient. You need to set up centralized logging and implement log analysis procedures for faster incident response.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Configure centralized logging using journald and rsyslog, implement log rotation, and create log analysis tools.

**Requirements:**
1. Configure persistent journald logging
2. Set up log forwarding to a central log server (or simulate)
3. Implement structured logging for applications
4. Create log retention policies
5. Build log analysis scripts for common issues
6. Set up log-based alerting
7. Document log access procedures

**Log Sources:**
- System logs (auth, kernel, systemd)
- Application logs (backend-api, frontend, worker)
- Security logs (fail2ban, ufw)
- Access logs (nginx/apache)

**Environment:**
- Ubuntu 20.04
- Multiple application services running
- Central log storage location: /var/log/central
- Log retention: 30 days for app logs, 90 days for security logs

### ✅ Validation Checklist

- [ ] **Journald Configuration**
  - [ ] Persistent storage enabled
  - [ ] Storage size limits configured
  - [ ] Log compression enabled
  - [ ] System forward-to-syslog enabled

- [ ] **Log Collection**
  - [ ] System logs collected and stored
  - [ ] Application logs standardized (JSON format recommended)
  - [ ] Security logs separated
  - [ ] Access logs parsed and structured

- [ ] **Log Rotation**
  - [ ] Logrotate configured for all log files
  - [ ] Rotation based on size and time
  - [ ] Compression enabled
  - [ ] Retention policy enforced
  - [ ] Old logs automatically deleted

- [ ] **Log Analysis Tools**
  - [ ] Script to search logs by time range
  - [ ] Script to find application errors
  - [ ] Script to detect security events
  - [ ] Script to generate daily summaries

- [ ] **Alerting**
  - [ ] Critical error detection
  - [ ] Security event alerting
  - [ ] Disk space monitoring for logs
  - [ ] Alert notification mechanism (email/slack)

### 📦 Required Deliverables

1. **Journald Configuration** (`/etc/systemd/journald.conf`)
   ```ini
   [Journal]
   Storage=persistent
   Compress=yes
   # [Complete configuration]
   ```

2. **Logrotate Configuration** (`/etc/logrotate.d/applications`)
   ```
   /var/log/applications/*.log {
       daily
       rotate 30
       compress
       delaycompress
       notifempty
       create 0640 appuser appgroup
       sharedscripts
       postrotate
           # [reload commands]
       endscript
   }
   
   # [Additional configurations]
   ```

3. **Log Analysis Scripts**
   
   **Script 1: Error Search** (`/usr/local/bin/search-errors.sh`)
   ```bash
   #!/bin/bash
   # Search for errors in application logs
   # Usage: search-errors.sh [service-name] [time-range]
   
   # [Your script]
   ```
   
   **Script 2: Security Event Monitor** (`/usr/local/bin/security-monitor.sh`)
   ```bash
   #!/bin/bash
   # Monitor security logs for suspicious activity
   
   # [Your script]
   ```
   
   **Script 3: Log Summary** (`/usr/local/bin/log-summary.sh`)
   ```bash
   #!/bin/bash
   # Generate daily log summary
   
   # [Your script]
   ```

4. **Log Access Documentation**
   ```
   # Log Access Guide
   
   ## View Real-time Logs
   # System logs
   sudo journalctl -f
   
   # Specific service
   sudo journalctl -u backend-api -f
   
   # Since specific time
   sudo journalctl --since "1 hour ago"
   
   ## Application Logs
   # Backend API errors
   sudo tail -f /var/log/applications/backend-api.log | grep ERROR
   
   # Frontend access log
   sudo tail -f /var/log/nginx/access.log
   
   ## Search Logs
   # Find all 500 errors in last 24 hours
   ./search-errors.sh backend-api "24 hours ago"
   
   # Security events in last hour
   ./security-monitor.sh --since "1 hour ago"
   
   ## Log Locations
   - System: /var/log/syslog, journalctl
   - Applications: /var/log/applications/
   - Security: /var/log/auth.log, /var/log/fail2ban.log
   - Web: /var/log/nginx/
   ```

5. **Test Results and Examples**
   ```
   # Test 1: Find all errors in backend API
   $ sudo journalctl -u backend-api | grep ERROR | tail -5
   [sample output]
   
   # Test 2: Security events in last hour
   $ sudo grep "Failed password" /var/log/auth.log | tail -10
   [sample output]
   
   # Test 3: Log rotation works
   $ ls -lh /var/log/applications/
   [show rotated files with dates]
   
   # Test 4: Disk usage for logs
   $ du -sh /var/log/*
   [show log sizes]
   
   # Test 5: Daily summary generation
   $ sudo /usr/local/bin/log-summary.sh
   [sample summary report]
   ```

### 🎯 Success Criteria

- ✅ All logs centrally accessible and searchable
- ✅ Journald persists logs across reboots
- ✅ Log rotation prevents disk space issues
- ✅ Analysis scripts provide quick insights
- ✅ Security events detected and reported
- ✅ Old logs automatically archived/deleted per policy
- ✅ Log access procedures documented
- ✅ Can find root cause of issues within 5 minutes

---

## Task 1.8: Performance Monitoring and Troubleshooting

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-18-performance-monitoring-and-troubleshooting)**

### 🎬 Real-World Scenario
Users are complaining about slow response times. Your manager asks you to investigate and identify the bottleneck. You need to set up performance monitoring, collect metrics, analyze system performance, and provide a detailed report with recommendations.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Investigate system performance issues, identify bottlenecks, and implement monitoring solutions.

**Symptoms Reported:**
- Web pages load slowly (5-10 seconds instead of <1 second)
- API response times degraded
- Occasional database timeouts
- Users see "Service Unavailable" errors

**Your Tasks:**
1. Collect baseline system metrics
2. Identify resource bottlenecks (CPU, memory, disk, network)
3. Analyze process performance
4. Check for I/O wait issues
5. Monitor network connections
6. Install and configure monitoring tools
7. Create performance report with recommendations

**Environment:**
- Ubuntu 20.04 server
- Running: nginx, backend API (Node.js), PostgreSQL
- 2 CPU cores, 4GB RAM
- 50GB disk

### ✅ Validation Checklist

- [ ] **Initial Assessment**
  - [ ] System load average collected (1, 5, 15 min)
  - [ ] CPU utilization checked (per core and overall)
  - [ ] Memory usage analyzed (used, cached, available)
  - [ ] Disk I/O metrics collected
  - [ ] Network statistics gathered

- [ ] **Process Analysis**
  - [ ] Top CPU-consuming processes identified
  - [ ] Top memory-consuming processes identified
  - [ ] Zombie processes checked
  - [ ] Process priorities reviewed
  - [ ] Thread counts analyzed

- [ ] **Disk Performance**
  - [ ] Disk I/O wait times measured
  - [ ] Disk space utilization checked
  - [ ] Inode usage verified
  - [ ] Slow queries identified (if database issue)

- [ ] **Network Performance**
  - [ ] Active connections counted
  - [ ] Network throughput measured
  - [ ] Packet loss checked
  - [ ] DNS resolution time tested
  - [ ] Connection queue depths checked

- [ ] **Monitoring Setup**
  - [ ] Performance monitoring tools installed
  - [ ] Baseline metrics documented
  - [ ] Real-time monitoring dashboard created
  - [ ] Alert thresholds configured

### 📦 Required Deliverables

1. **Performance Analysis Report**
   ```
   # System Performance Analysis Report
   Date: [date]
   Server: [hostname]
   
   ## Executive Summary
   - Issue: [brief description]
   - Root Cause: [identified bottleneck]
   - Impact: [performance degradation metrics]
   - Recommendation: [immediate action needed]
   
   ## System Metrics Baseline
   
   ### CPU
   - Load Average: [1min] [5min] [15min]
   - CPU Utilization: [%]
   - CPU Steal Time: [%] (for VMs)
   - Context Switches: [per second]
   
   ### Memory
   - Total: [GB]
   - Used: [GB] ([%])
   - Available: [GB]
   - Cached: [GB]
   - Swap Used: [GB]
   
   ### Disk
   - I/O Wait: [%]
   - Read Throughput: [MB/s]
   - Write Throughput: [MB/s]
   - Disk Utilization: [%]
   - Average Queue Depth: [number]
   
   ### Network
   - Active Connections: [count]
   - Throughput IN: [Mbps]
   - Throughput OUT: [Mbps]
   - Packet Loss: [%]
   
   ## Top Resource Consumers
   
   ### CPU
   1. [process name]: [%CPU]
   2. [process name]: [%CPU]
   3. [process name]: [%CPU]
   
   ### Memory
   1. [process name]: [MB] ([%])
   2. [process name]: [MB] ([%])
   3. [process name]: [MB] ([%])
   
   ## Identified Issues
   
   ### Issue 1: [Title]
   - Symptom: [description]
   - Evidence: [metrics/logs]
   - Impact: [severity]
   - Root Cause: [analysis]
   
   ### Issue 2: [Title]
   [repeat structure]
   
   ## Recommendations
   
   ### Immediate Actions (0-24 hours)
   1. [action] - [expected impact]
   2. [action] - [expected impact]
   
   ### Short-term (1-7 days)
   1. [action] - [expected impact]
   2. [action] - [expected impact]
   
   ### Long-term (1-3 months)
   1. [action] - [expected impact]
   2. [action] - [expected impact]
   ```

2. **Monitoring Scripts**
   
   **Script 1: System Health Check** (`/usr/local/bin/system-health.sh`)
   ```bash
   #!/bin/bash
   # Quick system health check
   # Shows: CPU, Memory, Disk, Top Processes
   
   # [Your script]
   ```
   
   **Script 2: Performance Monitor** (`/usr/local/bin/perf-monitor.sh`)
   ```bash
   #!/bin/bash
   # Continuous performance monitoring
   # Logs metrics every N seconds
   
   # [Your script]
   ```
   
   **Script 3: Bottleneck Detector** (`/usr/local/bin/detect-bottleneck.sh`)
   ```bash
   #!/bin/bash
   # Automatically detect performance bottlenecks
   
   # [Your script]
   ```

3. **Command Reference Sheet**
   ```
   # Performance Troubleshooting Commands
   
   ## CPU
   # Overall CPU usage
   top -bn1 | head -20
   mpstat 1 5
   
   # Per-process CPU
   ps aux --sort=-%cpu | head -10
   pidstat 1 5
   
   # CPU load history
   uptime
   cat /proc/loadavg
   
   ## Memory
   # Memory overview
   free -h
   vmstat 1 5
   
   # Per-process memory
   ps aux --sort=-%mem | head -10
   pmap -x [PID]
   
   # Memory details
   cat /proc/meminfo
   slabtop
   
   ## Disk I/O
   # I/O statistics
   iostat -x 1 5
   iotop -o
   
   # Disk usage
   df -h
   du -sh /* | sort -h
   
   # Inode usage
   df -i
   
   ## Network
   # Connections
   ss -tunapl
   netstat -ant | awk '{print $6}' | sort | uniq -c
   
   # Throughput
   iftop -i eth0
   vnstat -i eth0
   
   # Latency
   ping -c 10 [target]
   traceroute [target]
   
   ## Process Analysis
   # List all processes
   ps auxf
   
   # Process tree
   pstree -p
   
   # Process details
   cat /proc/[PID]/status
   lsof -p [PID]
   
   # System calls
   strace -c -p [PID]
   ```

4. **Evidence Collection**
   ```
   # Performance Data Snapshots
   
   ## Snapshot 1: During slowdown
   [output of top -bn1]
   [output of iostat -x]
   [output of vmstat]
   [output of ss -s]
   
   ## Snapshot 2: Normal operation
   [same commands for comparison]
   
   ## Database Metrics (if applicable)
   [slow query log analysis]
   [connection pool stats]
   [query execution times]
   ```

5. **Before/After Comparison**
   ```
   # Performance Improvements
   
   ## Before Optimization
   - Page Load Time: [seconds]
   - API Response Time: [ms]
   - Error Rate: [%]
   - System Load: [average]
   
   ## After Optimization
   - Page Load Time: [seconds] ([-X%])
   - API Response Time: [ms] ([-X%])
   - Error Rate: [%] ([-X%])
   - System Load: [average] ([-X%])
   ```

### 🎯 Success Criteria

- ✅ Root cause identified with evidence
- ✅ Performance bottleneck clearly explained
- ✅ Comprehensive metrics collected
- ✅ Monitoring scripts functional
- ✅ Recommendations are actionable and prioritized
- ✅ Performance improved after implementing fixes
- ✅ Can reproduce analysis process
- ✅ Report is clear enough for non-technical stakeholders

---

## Task 1.9: Package Management and Custom Repository

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-19-package-management-and-custom-repository)**

### 🎬 Real-World Scenario
Your company develops internal tools that need to be distributed to all servers. Managing manual installations is error-prone. You need to set up a custom APT repository for internal packages and implement a standardized package management procedure.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create a custom APT repository, package an internal application, and set up automated package distribution.

**Requirements:**
1. Set up a custom APT repository
2. Create a .deb package for an internal tool
3. Configure package signing (GPG)
4. Set up repository on all target servers
5. Implement automated package updates
6. Create package versioning strategy
7. Document package management procedures

**Internal Application:**
- Name: company-monitor
- Location: /usr/local/bin/company-monitor
- Simple bash script that reports system status
- Should install dependencies: curl, jq
- Should create systemd service

**Environment:**
- Ubuntu 20.04 servers
- Repository server available (can be same server)
- GPG for package signing
- Web server (nginx/apache) for repository hosting

### ✅ Validation Checklist

- [ ] **Repository Setup**
  - [ ] Repository directory structure created
  - [ ] GPG key generated for signing
  - [ ] Repository metadata generated
  - [ ] Web server configured to serve repository
  - [ ] Repository accessible via HTTP/HTTPS

- [ ] **Package Creation**
  - [ ] .deb package built correctly
  - [ ] Package includes all files
  - [ ] Dependencies specified
  - [ ] Postinst/prerm scripts work
  - [ ] Package signed with GPG key

- [ ] **Client Configuration**
  - [ ] Repository added to sources.list.d
  - [ ] GPG key imported and trusted
  - [ ] apt update works without errors
  - [ ] Package installs successfully
  - [ ] Package version tracked

- [ ] **Automation**
  - [ ] Script to build and publish packages
  - [ ] Script to update repository metadata
  - [ ] Automated testing of new packages
  - [ ] Version bumping automated

- [ ] **Documentation**
  - [ ] Package build instructions
  - [ ] Repository setup guide
  - [ ] Version control strategy
  - [ ] Rollback procedures

### 📦 Required Deliverables

1. **Package Structure**
   ```
   company-monitor_1.0.0/
   ├── DEBIAN/
   │   ├── control
   │   ├── postinst
   │   ├── prerm
   │   └── changelog
   ├── usr/
   │   └── local/
   │       └── bin/
   │           └── company-monitor
   └── etc/
       └── systemd/
           └── system/
               └── company-monitor.service
   ```

2. **DEBIAN/control File**
   ```
   Package: company-monitor
   Version: 1.0.0
   Section: admin
   Priority: optional
   Architecture: all
   Depends: curl, jq, systemd
   Maintainer: DevOps Team <devops@company.com>
   Description: Company internal monitoring tool
    Collects and reports system metrics for internal monitoring.
    This tool is required on all production servers.
   ```

3. **Build Script** (`build-package.sh`)
   ```bash
   #!/bin/bash
   # Build company-monitor package
   
   set -e
   
   PACKAGE_NAME="company-monitor"
   VERSION="1.0.0"
   ARCH="all"
   
   # [Your complete build script]
   ```

4. **Repository Setup Script** (`setup-repo.sh`)
   ```bash
   #!/bin/bash
   # Set up custom APT repository
   
   # [Your script to create repository]
   ```

5. **Client Configuration Script** (`add-repo-client.sh`)
   ```bash
   #!/bin/bash
   # Add custom repository to client servers
   
   # [Your script]
   ```

6. **Repository Documentation**
   ```
   # Custom APT Repository Guide
   
   ## Repository Structure
   /var/www/apt-repo/
   ├── dists/
   │   └── stable/
   │       └── main/
   │           └── binary-amd64/
   │               ├── Packages
   │               ├── Packages.gz
   │               └── Release
   ├── pool/
   │   └── main/
   │       └── c/
   │           └── company-monitor/
   │               └── company-monitor_1.0.0_all.deb
   └── public.gpg
   
   ## Repository URL
   http://apt.company.internal/
   
   ## Adding Repository to Client
   # 1. Add GPG key
   curl -fsSL http://apt.company.internal/public.gpg | sudo gpg --dearmor -o /usr/share/keyrings/company-archive-keyring.gpg
   
   # 2. Add repository
   echo "deb [signed-by=/usr/share/keyrings/company-archive-keyring.gpg] http://apt.company.internal stable main" | sudo tee /etc/apt/sources.list.d/company.list
   
   # 3. Update and install
   sudo apt update
   sudo apt install company-monitor
   
   ## Publishing New Package Version
   1. Update version in control file
   2. Build package: ./build-package.sh
   3. Sign package: dpkg-sig --sign builder package.deb
   4. Copy to repository pool
   5. Update repository metadata: reprepro includedeb stable package.deb
   6. Test on staging server
   7. Deploy to production repository
   
   ## Version Management
   - Major.Minor.Patch (1.0.0)
   - Major: Breaking changes
   - Minor: New features (backward compatible)
   - Patch: Bug fixes
   ```

7. **Test Results**
   ```
   # Test 1: Package installs successfully
   $ sudo apt update
   $ sudo apt install company-monitor
   [should install without errors]
   
   # Test 2: Application works
   $ company-monitor --status
   [should display system status]
   
   # Test 3: Service starts
   $ sudo systemctl start company-monitor
   $ sudo systemctl status company-monitor
   [should show active (running)]
   
   # Test 4: Package upgrade works
   $ sudo apt upgrade company-monitor
   [should upgrade to new version]
   
   # Test 5: Package removal works
   $ sudo apt remove company-monitor
   [should remove cleanly]
   ```

### 🎯 Success Criteria

- ✅ Custom repository accessible and working
- ✅ Package builds successfully
- ✅ Package installs and runs on target systems
- ✅ Dependencies resolved automatically
- ✅ Package signing and verification works
- ✅ Updates can be pushed to all servers
- ✅ Version management strategy documented
- ✅ Rollback to previous version possible

---

## Task 1.10: PostgreSQL Backup Automation

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-110-postgresql-backup-automation)**

### 🎬 Real-World Scenario
Your production PostgreSQL database contains critical business data. Currently, there's no backup system in place. You need to implement an automated backup solution with retention policies, backup verification, and disaster recovery procedures.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement a comprehensive PostgreSQL backup and recovery system with automation.

**Requirements:**
1. Daily full backups
2. Hourly WAL archiving for point-in-time recovery
3. Backup retention: 7 daily, 4 weekly, 3 monthly
4. Backup verification (restore test)
5. Offsite backup copy (S3 or remote server)
6. Monitoring and alerting for backup failures
7. Disaster recovery documentation

**Database Details:**
- PostgreSQL 12+ on Ubuntu 20.04
- Database size: ~10GB
- Database name: production_db
- Critical data, < 1 hour RPO acceptable

**Environment:**
- Ubuntu 20.04 with PostgreSQL installed
- Backup storage: /backup/postgres/
- Optional: AWS S3 bucket for offsite storage
- Monitoring system available

### ✅ Validation Checklist

- [ ] **Backup Configuration**
  - [ ] pg_dump configured for daily backups
  - [ ] WAL archiving enabled
  - [ ] Archive location configured
  - [ ] Backup scripts created
  - [ ] Compression enabled

- [ ] **Automation**
  - [ ] Cron jobs scheduled for backups
  - [ ] Backup rotation script working
  - [ ] Old backups automatically deleted
  - [ ] WAL files archived continuously

- [ ] **Retention Policy**
  - [ ] 7 daily backups retained
  - [ ] 4 weekly backups retained
  - [ ] 3 monthly backups retained
  - [ ] Policy enforced automatically

- [ ] **Backup Verification**
  - [ ] Backup integrity check script
  - [ ] Automated restore test
  - [ ] Verification logs maintained
  - [ ] Failed backups reported

- [ ] **Offsite Copy**
  - [ ] Backups copied to remote location
  - [ ] Transfer encrypted
  - [ ] Transfer automated
  - [ ] Remote backups verified

- [ ] **Monitoring**
  - [ ] Backup success/failure logged
  - [ ] Alerts configured for failures
  - [ ] Backup size monitored
  - [ ] Backup age checked

- [ ] **Documentation**
  - [ ] Recovery procedures documented
  - [ ] Restore tested and documented
  - [ ] Emergency contacts listed
  - [ ] RTO/RPO documented

### 📦 Required Deliverables

1. **PostgreSQL Backup Configuration**
   
   **postgresql.conf settings:**
   ```
   # WAL archiving
   wal_level = replica
   archive_mode = on
   archive_command = 'test ! -f /backup/postgres/wal_archive/%f && cp %p /backup/postgres/wal_archive/%f'
   archive_timeout = 300
   ```

2. **Backup Scripts**
   
   **Main Backup Script** (`/usr/local/bin/postgres-backup.sh`)
   ```bash
   #!/bin/bash
   # PostgreSQL Backup Script
   # Performs full database backup with pg_dump
   
   set -euo pipefail
   
   # Configuration
   BACKUP_DIR="/backup/postgres"
   DB_NAME="production_db"
   DB_USER="postgres"
   TIMESTAMP=$(date +%Y%m%d_%H%M%S)
   RETENTION_DAYS=7
   
   # [Your complete backup script]
   
   # Functions:
   # - take_backup()
   # - verify_backup()
   # - rotate_old_backups()
   # - send_notification()
   ```
   
   **WAL Archive Script** (`/usr/local/bin/archive-wal.sh`)
   ```bash
   #!/bin/bash
   # WAL Archive Management
   # Archives and manages WAL files
   
   # [Your WAL management script]
   ```
   
   **Restore Script** (`/usr/local/bin/postgres-restore.sh`)
   ```bash
   #!/bin/bash
   # PostgreSQL Restore Script
   # Restores database from backup
   # Usage: postgres-restore.sh [backup-file] [target-database]
   
   # [Your restore script]
   ```
   
   **Offsite Copy Script** (`/usr/local/bin/offsite-backup.sh`)
   ```bash
   #!/bin/bash
   # Copy backups to offsite location (S3 or remote server)
   
   # [Your offsite copy script]
   ```

3. **Cron Configuration** (`/etc/cron.d/postgres-backup`)
   ```
   # PostgreSQL Backup Schedule
   
   # Daily full backup at 2 AM
   0 2 * * * postgres /usr/local/bin/postgres-backup.sh >> /var/log/postgres-backup.log 2>&1
   
   # Weekly backup (kept longer) every Sunday at 3 AM
   0 3 * * 0 postgres /usr/local/bin/postgres-backup.sh --type weekly >> /var/log/postgres-backup.log 2>&1
   
   # Monthly backup (kept longest) on 1st of month at 4 AM
   0 4 1 * * postgres /usr/local/bin/postgres-backup.sh --type monthly >> /var/log/postgres-backup.log 2>&1
   
   # Offsite copy every 6 hours
   0 */6 * * * postgres /usr/local/bin/offsite-backup.sh >> /var/log/offsite-backup.log 2>&1
   
   # Backup verification daily at 6 AM
   0 6 * * * postgres /usr/local/bin/verify-backup.sh >> /var/log/backup-verify.log 2>&1
   ```

4. **Disaster Recovery Documentation**
   ```
   # PostgreSQL Disaster Recovery Procedures
   
   ## RPO/RTO Targets
   - Recovery Point Objective (RPO): < 1 hour
   - Recovery Time Objective (RTO): < 4 hours
   
   ## Backup Locations
   - Primary: /backup/postgres/
   - Offsite: s3://company-backups/postgres/ (or remote server)
   - WAL Archive: /backup/postgres/wal_archive/
   
   ## Backup Schedule
   - Full backup: Daily at 2 AM
   - WAL archiving: Continuous (every 5 minutes)
   - Offsite copy: Every 6 hours
   - Retention: 7 daily, 4 weekly, 3 monthly
   
   ## Recovery Scenarios
   
   ### Scenario 1: Complete Database Loss
   **Steps:**
   1. Stop PostgreSQL service
   2. Remove old data directory
   3. Initialize new data directory
   4. Restore latest full backup
   5. Apply WAL files for point-in-time recovery
   6. Start PostgreSQL service
   7. Verify data integrity
   
   **Commands:**
   ```bash
   sudo systemctl stop postgresql
   sudo rm -rf /var/lib/postgresql/12/main/
   sudo -u postgres /usr/local/bin/postgres-restore.sh /backup/postgres/latest.dump production_db
   sudo systemctl start postgresql
   ```
   
   ### Scenario 2: Accidental Data Deletion
   **Steps:**
   1. Determine point in time before deletion
   2. Restore to test database
   3. Extract missing data
   4. Insert into production
   
   ### Scenario 3: Corruption Detected
   **Steps:**
   1. Stop writes to database
   2. Dump current state if possible
   3. Restore from last known good backup
   4. Apply WAL files up to corruption point
   5. Verify data integrity
   
   ## Testing Schedule
   - Monthly: Full restore test to staging
   - Quarterly: Disaster recovery drill
   - Annually: Complete DR simulation
   
   ## Emergency Contacts
   - On-call DBA: [phone]
   - DevOps Lead: [phone]
   - CTO: [phone]
   ```

5. **Monitoring Script** (`/usr/local/bin/backup-monitor.sh`)
   ```bash
   #!/bin/bash
   # Backup Monitoring Script
   # Checks backup status and sends alerts
   
   # Checks:
   # - Last backup age
   # - Backup size trends
   # - Backup success/failure
   # - Disk space for backups
   # - Offsite copy status
   
   # [Your monitoring script]
   ```

6. **Test Results Documentation**
   ```
   # Backup System Tests
   
   ## Test 1: Full Backup
   $ sudo -u postgres /usr/local/bin/postgres-backup.sh
   [output showing successful backup]
   $ ls -lh /backup/postgres/
   [backup files with timestamps]
   
   ## Test 2: Restore to Test Database
   $ sudo -u postgres /usr/local/bin/postgres-restore.sh \
       /backup/postgres/production_db_20231105.dump test_restore
   [output showing successful restore]
   $ psql test_restore -c "\dt"
   [list of tables confirming data restored]
   
   ## Test 3: Point-in-Time Recovery
   [document PITR test results]
   
   ## Test 4: Backup Rotation
   $ ls -lt /backup/postgres/ | head -20
   [show old backups removed correctly]
   
   ## Test 5: Offsite Copy
   $ aws s3 ls s3://company-backups/postgres/
   [or: ssh remote-server "ls /backups/postgres/"]
   [show backups copied offsite]
   
   ## Test 6: Monitoring Alerts
   [simulate backup failure and verify alert sent]
   ```

### 🎯 Success Criteria

- ✅ Daily backups running automatically
- ✅ WAL archiving working continuously
- ✅ Backup retention policy enforced
- ✅ Successful restore test completed
- ✅ Offsite backups verified
- ✅ Backup failures trigger alerts
- ✅ Recovery procedures documented and tested
- ✅ Can recover to any point within last 7 days
- ✅ RTO/RPO targets achievable

---

## Quick Reference: Time Estimates Summary

| Task | Difficulty | Time | Prerequisites |
|------|-----------|------|---------------|
| 1.1 - Server Hardening | Medium | 90 min | Basic Linux, SSH access |
| 1.2 - SSH Key Management | Medium | 60 min | SSH basics, user management |
| 1.3 - User/Group Management | Medium | 75 min | Linux permissions, groups |
| 1.4 - Filesystem & Quotas | Hard | 90 min | Disk management, ACLs |
| 1.5 - Systemd Service | Medium | 60 min | Systemd basics, service management |
| 1.6 - Firewall Configuration | Medium | 75 min | Networking basics, UFW/iptables |
| 1.7 - Centralized Logging | Medium | 90 min | Log management, journald |
| 1.8 - Performance Monitoring | Hard | 90 min | System monitoring tools |
| 1.9 - Package Management | Medium | 75 min | APT/DEB packages, repository setup |
| 1.10 - Database Backup | Hard | 90 min | PostgreSQL, backup strategies |
| 1.11 - Log Rotation | Easy | 45 min | Logrotate basics |
| 1.12 - Disk Space Crisis | Medium | 60 min | Disk commands, troubleshooting |
| 1.13 - Network Troubleshooting | Medium | 75 min | Networking fundamentals |
| 1.14 - Systemd Timers | Medium | 60 min | Systemd, cron basics |
| 1.15 - Security Incident Response | Hard | 90 min | Security fundamentals, forensics |
| 1.16 - DNS Configuration | Medium | 60 min | DNS basics, systemd-resolved |
| 1.17 - Process Priority | Easy | 45 min | Process management, nice/renice |
| 1.18 - High CPU/Memory Issues | Hard | 75 min | Performance analysis, troubleshooting |

**Total Time**: ~23 hours (1,305 minutes)  
**Average Time**: ~72 minutes per task

---

## Tips for Success

### For Engineers:
- ✅ Read the entire task before starting
- ✅ Document everything as you go
- ✅ Test each step before moving to the next
- ✅ Use the validation checklist
- ✅ Keep track of commands you run (history)
- ✅ Take screenshots of key validations
- ✅ If stuck, check man pages and official docs

### For Reviewers:
- ✅ Verify all checklist items are complete
- ✅ Test the configuration yourself
- ✅ Review security implications
- ✅ Check if solution is production-ready
- ✅ Verify documentation is clear and complete
- ✅ Test failure scenarios (chaos engineering)

---

## Task 1.11: Log Rotation Configuration

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-111-log-rotation-configuration)**

### 🎬 Real-World Scenario
Your application servers are running out of disk space because application logs are growing unchecked. A production server went down last week when /var filled up completely. You need to implement comprehensive log rotation to prevent this from happening again.

### ⏱️ Time to Complete: 45 minutes

### 📋 Assignment Instructions

**Your Mission:**
Configure logrotate for all application and system logs with appropriate retention policies.

**Log Files to Manage:**
- Application logs: /var/log/applications/*.log (5GB+/day)
- Nginx access/error logs (2GB/day)
- PostgreSQL logs (500MB/day)
- System logs already managed by default

**Retention Requirements:**
- Application logs: 14 days, compress after 1 day
- Nginx logs: 30 days for access, 14 days for errors
- PostgreSQL logs: 30 days
- Rotate when size > 100MB or daily (whichever comes first)

### ✅ Validation Checklist

- [ ] **Logrotate Configuration**
  - [ ] Configuration files created in /etc/logrotate.d/
  - [ ] Syntax validated (logrotate -d)
  - [ ] Rotation frequency configured
  - [ ] Compression enabled
  - [ ] Retention policies set

- [ ] **Service Handling**
  - [ ] Services reloaded after rotation (postrotate)
  - [ ] No log entries lost during rotation
  - [ ] Services continue logging to correct files

- [ ] **Testing**
  - [ ] Manual rotation tested
  - [ ] Rotation creates expected files
  - [ ] Old files deleted per policy
  - [ ] Compression works correctly

### 📦 Required Deliverables

1. **Logrotate Configuration** (`/etc/logrotate.d/applications`)
   ```
   /var/log/applications/*.log {
       daily
       missingok
       rotate 14
       compress
       delaycompress
       notifempty
       create 0640 appuser appgroup
       size 100M
       sharedscripts
       postrotate
           systemctl reload application-service > /dev/null 2>&1 || true
       endscript
   }
   ```

2. **Test Results**
   ```bash
   # Test rotation manually
   sudo logrotate -f /etc/logrotate.d/applications
   
   # Verify rotated files
   ls -lh /var/log/applications/
   # Expected: app.log, app.log.1, app.log.2.gz, etc.
   ```

3. **Monitoring Script** for disk space
   ```bash
   #!/bin/bash
   # Alert if /var reaches 80% capacity
   ```

### 🎯 Success Criteria
- ✅ Logs rotate automatically
- ✅ Old logs compressed and deleted per policy
- ✅ Services continue logging without interruption
- ✅ Disk space usage stays under control
- ✅ No manual intervention needed

---

## Task 1.12: Disk Space Crisis Management

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-112-disk-space-crisis-management)**

### 🎬 Real-World Scenario
**URGENT**: Production server at 98% disk usage. Applications are failing. Database cannot write. You need to quickly identify what's using space and free up disk immediately without breaking anything.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Quickly identify and resolve disk space issues on a production server while maintaining service availability.

**Current Situation:**
- /dev/sda1 mounted on / at 98% used
- Services failing with "No space left on device"
- Need to free at least 20GB immediately
- Cannot reboot server (production)

**Your Tasks:**
1. Identify what's consuming disk space
2. Safely remove/archive large files
3. Implement immediate space reclamation
4. Set up monitoring to prevent recurrence
5. Document findings and actions taken

### ✅ Validation Checklist

- [ ] **Investigation**
  - [ ] Disk usage by directory identified (du)
  - [ ] Large files found (find)
  - [ ] Deleted files still held open found (lsof)
  - [ ] Log files checked for growth

- [ ] **Immediate Actions**
  - [ ] At least 20GB freed
  - [ ] Services restored to normal operation
  - [ ] No critical data deleted
  - [ ] Backup created before deletion

- [ ] **Monitoring Setup**
  - [ ] Disk usage alerts configured
  - [ ] Automated cleanup script created
  - [ ] Log rotation verified
  - [ ] Growth trend analysis performed

### 📦 Required Deliverables

1. **Investigation Report**
   ```
   # Disk Space Investigation
   
   ## Initial State
   df -h: [output]
   
   ## Top Space Consumers
   1. /var/log/old_logs: 15GB
   2. /tmp/build-artifacts: 8GB
   3. /opt/applications/cache: 5GB
   4. Docker images: 12GB
   
   ## Files Deleted But Still Open
   [lsof +L1 output]
   ```

2. **Cleanup Script** (`/usr/local/bin/emergency-cleanup.sh`)
   ```bash
   #!/bin/bash
   # Emergency disk space cleanup
   # Safe for production use
   
   # [Your script that:]
   # - Archives old logs
   # - Cleans temp files
   # - Removes old backups
   # - Cleans package cache
   # - Removes old docker images/containers
   ```

3. **Monitoring Script** (`/usr/local/bin/disk-monitor.sh`)
   ```bash
   #!/bin/bash
   # Alert when disk usage > 80%
   ```

4. **Action Log**
   ```
   # Actions Taken
   [Timestamp] - Investigated disk usage
   [Timestamp] - Archived /var/log/old_logs (15GB freed)
   [Timestamp] - Deleted old build artifacts (8GB freed)
   [Timestamp] - Cleared application cache (5GB freed)
   [Timestamp] - Pruned docker images (12GB freed)
   Total freed: 40GB
   Current usage: 58%
   ```

### 🎯 Success Criteria
- ✅ Freed at least 20GB within 30 minutes
- ✅ All services operational
- ✅ No data loss
- ✅ Monitoring in place
- ✅ Recurrence prevention implemented

---

## Task 1.13: Network Connectivity Troubleshooting

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-113-network-connectivity-troubleshooting)**

### 🎬 Real-World Scenario
Users report intermittent connectivity issues to your web application. Some requests succeed, others timeout. Database connections are dropping. You need to diagnose and fix the network issues.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Diagnose and resolve network connectivity issues affecting production services.

**Symptoms:**
- Intermittent timeouts (works sometimes, fails other times)
- Database connection errors
- High latency on API calls
- Some users affected, others not

**Your Tasks:**
1. Check network interface status and errors
2. Test connectivity at each network layer
3. Analyze DNS resolution
4. Check firewall rules
5. Monitor network traffic
6. Identify and fix root cause

### ✅ Validation Checklist

- [ ] **Interface Status**
  - [ ] Interface up and configured
  - [ ] No packet drops or errors
  - [ ] MTU settings correct
  - [ ] Link speed verified

- [ ] **Connectivity Tests**
  - [ ] Ping to gateway successful
  - [ ] Ping to external hosts works
  - [ ] DNS resolution working
  - [ ] Traceroute shows complete path

- [ ] **Service-Level Tests**
  - [ ] Application ports reachable
  - [ ] Database connections stable
  - [ ] API response times normal
  - [ ] No packet loss

- [ ] **Monitoring**
  - [ ] Network metrics collected
  - [ ] Baseline established
  - [ ] Alerts configured
  - [ ] Documentation updated

### 📦 Required Deliverables

1. **Network Diagnostic Report**
   ```
   # Network Troubleshooting Report
   
   ## Interface Status
   [ip addr show]
   [ethtool eth0]
   
   ## Connectivity Tests
   Ping gateway: [result]
   Ping external: [result]
   DNS resolution: [result]
   Traceroute: [result]
   
   ## Service Tests
   Telnet to DB: [result]
   Curl to API: [result]
   
   ## Identified Issues
   1. [Issue]: [Description]
      Root cause: [Cause]
      Fix: [Action taken]
   ```

2. **Network Testing Script** (`/usr/local/bin/network-test.sh`)
   ```bash
   #!/bin/bash
   # Comprehensive network connectivity test
   
   # Tests:
   # - Interface status
   # - Gateway reachability
   # - DNS resolution
   # - External connectivity
   # - Service availability
   # - Latency measurements
   ```

3. **Test Results**
   ```bash
   # Before fix
   [show failing tests]
   
   # After fix
   [show all tests passing]
   ```

### 🎯 Success Criteria
- ✅ Root cause identified
- ✅ Connectivity restored
- ✅ No more timeouts
- ✅ Latency within acceptable range
- ✅ All services reachable
- ✅ Monitoring in place

---

## Task 1.14: Systemd Timers for Scheduled Tasks

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-114-systemd-timers-for-scheduled-tasks)**

### 🎬 Real-World Scenario
Your team uses multiple cron jobs, but they're scattered across different files and hard to manage. You need to migrate critical scheduled tasks to systemd timers for better management, logging, and reliability.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Convert existing cron jobs to systemd timers with proper service units.

**Tasks to Convert:**
1. Database backup (daily at 2 AM)
2. Log cleanup (weekly)
3. Health check report (every 15 minutes)
4. Certificate renewal check (daily)

**Requirements:**
- Each timer has a corresponding service unit
- Proper logging through journald
- Error handling and notifications
- Easy to enable/disable
- Can run manually for testing

### ✅ Validation Checklist

- [ ] **Timer Units Created**
  - [ ] .timer files in /etc/systemd/system/
  - [ ] OnCalendar or OnUnitActiveSec configured
  - [ ] Persistent=true for missed runs
  - [ ] Accuracy settings appropriate

- [ ] **Service Units Created**
  - [ ] Corresponding .service files
  - [ ] Type=oneshot for run-once tasks
  - [ ] Proper error handling
  - [ ] ExecStart commands tested

- [ ] **Management**
  - [ ] Timers enabled and started
  - [ ] Can list all timers (systemctl list-timers)
  - [ ] Can manually trigger (systemctl start)
  - [ ] Logs available (journalctl -u)

### 📦 Required Deliverables

1. **Timer Configuration** (`backup.timer`)
   ```ini
   [Unit]
   Description=Daily Database Backup Timer
   
   [Timer]
   OnCalendar=daily
   OnCalendar=02:00
   Persistent=true
   
   [Install]
   WantedBy=timers.target
   ```

2. **Service Configuration** (`backup.service`)
   ```ini
   [Unit]
   Description=Database Backup Service
   
   [Service]
   Type=oneshot
   ExecStart=/usr/local/bin/backup-database.sh
   User=postgres
   ```

3. **Management Commands**
   ```bash
   # Enable timer
   sudo systemctl enable backup.timer
   sudo systemctl start backup.timer
   
   # Check status
   systemctl list-timers
   systemctl status backup.timer
   
   # View logs
   journalctl -u backup.service
   
   # Manual run
   sudo systemctl start backup.service
   ```

4. **Migration Documentation**
   ```
   # Cron to Systemd Timer Migration
   
   ## Before (cron)
   0 2 * * * /usr/local/bin/backup.sh
   
   ## After (systemd)
   - backup.timer (schedule)
   - backup.service (actual task)
   
   ## Benefits
   - Better logging
   - Dependency management
   - Resource control
   - Easier monitoring
   ```

### 🎯 Success Criteria
- ✅ All timers running on schedule
- ✅ Services execute successfully
- ✅ Logs available in journalctl
- ✅ Can manually trigger for testing
- ✅ Old cron jobs disabled
- ✅ Documentation complete

---

## Task 1.15: Security Incident Response

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-115-security-incident-response)**

### 🎬 Real-World Scenario
**ALERT**: Unusual activity detected on production server. Multiple failed login attempts from unknown IPs. Possible compromise. You need to investigate immediately and secure the system.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Investigate security alert, contain potential breach, and implement additional security measures.

**Alerts Received:**
- 500+ failed SSH attempts in last hour
- New user account created: "backdoor"
- Suspicious process consuming CPU
- Outbound connections to unknown IPs

**Your Tasks:**
1. Investigate the alerts
2. Contain the threat
3. Analyze the extent of compromise
4. Remove malicious elements
5. Harden the system
6. Document the incident

### ✅ Validation Checklist

- [ ] **Investigation**
  - [ ] Failed login attempts analyzed
  - [ ] Unauthorized accounts identified
  - [ ] Suspicious processes found
  - [ ] Network connections checked
  - [ ] File integrity verified (AIDE)

- [ ] **Containment**
  - [ ] Suspicious accounts disabled/removed
  - [ ] Malicious processes terminated
  - [ ] Firewall rules tightened
  - [ ] System isolated if needed

- [ ] **Remediation**
  - [ ] Malware removed
  - [ ] Backdoors closed
  - [ ] Passwords changed
  - [ ] Keys rotated
  - [ ] System hardened

- [ ] **Documentation**
  - [ ] Timeline of events
  - [ ] Actions taken
  - [ ] Impact assessment
  - [ ] Lessons learned

### 📦 Required Deliverables

1. **Incident Response Report**
   ```
   # Security Incident Report
   Date: [date]
   Severity: [High/Medium/Low]
   Status: [Contained/Resolved]
   
   ## Timeline
   [HH:MM] - Alert received: Failed login attempts
   [HH:MM] - Investigation started
   [HH:MM] - Suspicious user found: backdoor
   [HH:MM] - Malicious process identified: /tmp/miner
   [HH:MM] - System contained
   [HH:MM] - Cleanup completed
   
   ## Indicators of Compromise
   - User: backdoor (UID 1337)
   - Process: /tmp/miner (crypto miner)
   - Connections: 185.220.101.x:8333
   - Modified files: /etc/cron.d/persistence
   
   ## Actions Taken
   1. Disabled backdoor account
   2. Killed malicious process
   3. Removed cron persistence
   4. Blocked malicious IPs
   5. Changed all passwords
   6. Rotated SSH keys
   
   ## Impact Assessment
   - Duration: X hours
   - Data accessed: [Unknown/None/Limited]
   - Services affected: [None/Some/All]
   - Estimated cost: [Impact]
   
   ## Root Cause
   - Weak SSH password
   - Default credentials not changed
   - No fail2ban configured
   
   ## Recommendations
   1. Enforce SSH key-only authentication
   2. Implement fail2ban
   3. Regular security audits
   4. Enable file integrity monitoring
   5. Implement IDS/IPS
   ```

2. **Investigation Commands Used**
   ```bash
   # Check failed logins
   sudo grep "Failed password" /var/log/auth.log | tail -100
   
   # Find suspicious users
   sudo awk -F: '$3 >= 1000 {print $1}' /etc/passwd
   
   # Check running processes
   ps auxf
   top -bn1
   
   # Check network connections
   sudo ss -tunapl
   sudo netstat -ant
   
   # Check cron jobs
   sudo cat /etc/cron.d/*
   sudo crontab -l -u backdoor
   
   # Check file modifications
   sudo find / -mtime -1 -type f
   sudo aide --check
   
   # Check audit logs
   sudo ausearch -m USER_AUTH -sv no
   ```

3. **Remediation Script** (`/usr/local/bin/incident-cleanup.sh`)
   ```bash
   #!/bin/bash
   # Clean up after security incident
   
   # [Your script to:]
   # - Remove backdoor accounts
   # - Kill suspicious processes
   # - Remove persistence mechanisms
   # - Block malicious IPs
   # - Harden system
   ```

4. **Post-Incident Hardening**
   ```bash
   # Additional security measures implemented
   1. SSH key-only auth enforced
   2. Fail2ban configured
   3. AIDE scheduled daily
   4. Additional audit rules
   5. IDS installed (optional)
   ```

### 🎯 Success Criteria
- ✅ Threat contained and removed
- ✅ No ongoing malicious activity
- ✅ System hardened
- ✅ Incident fully documented
- ✅ Lessons learned applied
- ✅ Similar attacks prevented

---

## Task 1.16: DNS Configuration and Troubleshooting

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-116-dns-configuration-and-troubleshooting)**

### 🎬 Real-World Scenario
Your team is migrating to a new internal DNS setup. You need to configure DNS resolution on application servers and ensure all services can resolve internal and external hostnames correctly.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Configure DNS resolution for internal and external domains with proper fallback and caching.

**Requirements:**
- Internal domains: *.company.internal → 10.0.0.10 (internal DNS)
- External domains → 8.8.8.8, 1.1.1.1 (public DNS)
- DNS caching for performance
- Proper fallback if primary DNS fails
- Fast failover (< 5 seconds)

**Environment:**
- Ubuntu 20.04
- Systemd-resolved available
- Internal DNS server: 10.0.0.10
- Split DNS configuration needed

### ✅ Validation Checklist

- [ ] **DNS Configuration**
  - [ ] systemd-resolved or dnsmasq configured
  - [ ] Split DNS working (internal vs external)
  - [ ] Fallback DNS configured
  - [ ] DNS caching enabled

- [ ] **Resolution Tests**
  - [ ] Internal hostnames resolve correctly
  - [ ] External hostnames resolve correctly
  - [ ] Fast resolution times (< 100ms cached)
  - [ ] Fallback works when primary DNS down

- [ ] **Troubleshooting Tools**
  - [ ] dig/nslookup available
  - [ ] DNS query logging enabled (if needed)
  - [ ] Resolution debugging possible

### 📦 Required Deliverables

1. **DNS Configuration** (`/etc/systemd/resolved.conf`)
   ```ini
   [Resolve]
   DNS=10.0.0.10 8.8.8.8 1.1.1.1
   FallbackDNS=8.8.4.4 1.0.0.1
   Domains=~company.internal
   Cache=yes
   CacheFromLocalhost=no
   DNSStubListener=yes
   ```

2. **Split DNS Configuration**
   ```bash
   # Configure internal DNS for .company.internal
   # Configure public DNS for everything else
   ```

3. **DNS Testing Script** (`/usr/local/bin/test-dns.sh`)
   ```bash
   #!/bin/bash
   # DNS Resolution Test Script
   
   echo "Testing DNS Resolution..."
   
   # Test internal domain
   dig app.company.internal +short
   
   # Test external domain
   dig google.com +short
   
   # Test resolution time
   time dig google.com > /dev/null
   
   # Test DNS failover
   # (simulate primary DNS down)
   ```

4. **Troubleshooting Guide**
   ```
   # DNS Troubleshooting Commands
   
   ## Check DNS configuration
   systemd-resolve --status
   cat /etc/resolv.conf
   
   ## Test resolution
   dig example.com
   nslookup example.com
   host example.com
   
   ## Check which DNS server responded
   dig example.com +trace
   
   ## Clear DNS cache
   sudo systemd-resolve --flush-caches
   
   ## Monitor DNS queries
   sudo tcpdump -i any port 53
   
   ## Common Issues
   1. Slow resolution → check cache settings
   2. Can't resolve internal → check split DNS
   3. Intermittent failures → check fallback DNS
   ```

5. **Test Results**
   ```bash
   # Internal domain resolution
   $ dig app.company.internal +short
   10.0.1.100
   
   # External domain resolution
   $ dig google.com +short
   142.250.185.78
   
   # Resolution speed
   $ time dig google.com > /dev/null
   real    0m0.015s  # Fast (cached)
   
   # Fallback test
   [show fallback working when primary DNS down]
   ```

### 🎯 Success Criteria
- ✅ All internal domains resolve correctly
- ✅ External domains resolve correctly
- ✅ DNS caching improves performance
- ✅ Fallback DNS works
- ✅ Resolution time < 100ms (cached)
- ✅ Split DNS properly configured

---

## Task 1.17: Process Priority Management

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-117-process-priority-management)**

### 🎬 Real-World Scenario
Your batch processing job is consuming too much CPU and affecting interactive application performance. Users are experiencing slowness. You need to manage process priorities to ensure critical services perform well.

### ⏱️ Time to Complete: 45 minutes

### 📋 Assignment Instructions

**Your Mission:**
Configure process priorities (nice/renice) and resource limits to ensure critical services get priority.

**Current Situation:**
- Batch job using 90% CPU
- Web application sluggish
- Database queries timing out
- All processes running at default priority

**Requirements:**
- Lower batch job priority (nice +15)
- Ensure web application runs at high priority (nice -5)
- Database should have highest priority (nice -10)
- Configure permanent priorities via systemd
- Limit batch job to 50% CPU max

### ✅ Validation Checklist

- [ ] **Process Priorities**
  - [ ] Batch jobs reniced to +15 or higher
  - [ ] Web application at nice -5
  - [ ] Database at nice -10
  - [ ] Priorities persist across restarts

- [ ] **Resource Limits**
  - [ ] CPU limits configured
  - [ ] Process count limits set
  - [ ] Memory limits appropriate
  - [ ] Limits enforced by systemd

- [ ] **Testing**
  - [ ] Application performance improved
  - [ ] Batch job still completes
  - [ ] No resource starvation
  - [ ] Priorities working as expected

### 📦 Required Deliverables

1. **Process Priority Commands**
   ```bash
   # Check current priorities
   ps -eo pid,ni,cmd --sort=ni
   
   # Renice running process
   sudo renice -n 15 -p [PID]
   
   # Start process with priority
   nice -n 15 /usr/local/bin/batch-job.sh
   
   # Change priority for all processes of user
   sudo renice +10 -u batchuser
   ```

2. **Systemd Service Configuration** (for permanent priority)
   ```ini
   # /etc/systemd/system/batch-job.service
   [Service]
   Nice=15
   CPUQuota=50%
   MemoryLimit=2G
   ```

3. **Resource Monitoring Script**
   ```bash
   #!/bin/bash
   # Monitor process priorities and resource usage
   
   watch -n 2 'ps -eo pid,ni,pcpu,pmem,cmd --sort=-pcpu | head -20'
   ```

4. **Before/After Comparison**
   ```
   # Before Priority Adjustment
   Web app response time: 5 seconds
   Batch job CPU: 90%
   Database queries: timing out
   
   # After Priority Adjustment
   Web app response time: 0.5 seconds
   Batch job CPU: 50% (limited)
   Database queries: normal
   ```

### 🎯 Success Criteria
- ✅ Web application responsive
- ✅ Database performs normally
- ✅ Batch job completes (just slower)
- ✅ CPU distributed fairly
- ✅ Priorities persist across reboots
- ✅ No process starvation

---

## Task 1.18: High CPU and Memory Troubleshooting

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-118-high-cpu-and-memory-troubleshooting)**

### 🎬 Real-World Scenario
**CRITICAL**: Production server CPU at 100%, memory exhausted, swap thrashing. Applications are crashing. You need to identify the culprit and resolve immediately without losing data.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Identify and resolve high CPU and memory usage causing production issues.

**Symptoms:**
- CPU at 95-100% constantly
- Memory usage at 98%
- Swap usage at 100%
- System very slow/unresponsive
- Applications crashing with OOM
- Load average: 25, 30, 35 (2 CPU server)

**Your Tasks:**
1. Identify process(es) causing high CPU
2. Identify memory leaks
3. Analyze what triggered the issue
4. Resolve without data loss
5. Prevent recurrence
6. Implement monitoring

### ✅ Validation Checklist

- [ ] **Investigation**
  - [ ] Top CPU consumers identified
  - [ ] Top memory consumers identified
  - [ ] Load average analyzed
  - [ ] OOM killer events checked
  - [ ] Memory leak detected (if applicable)

- [ ] **Resolution**
  - [ ] Offending process handled appropriately
  - [ ] CPU usage back to normal
  - [ ] Memory usage reasonable
  - [ ] Swap usage minimal
  - [ ] Load average < number of CPUs

- [ ] **Prevention**
  - [ ] Resource limits configured
  - [ ] Monitoring alerts set up
  - [ ] Auto-restart configured for crashed services
  - [ ] Memory leak fixed (if code issue)

### 📦 Required Deliverables

1. **Investigation Report**
   ```
   # High Resource Usage Investigation
   
   ## Initial State
   Load Average: 25.23, 30.45, 35.67
   CPU: 100%
   Memory: 15.8G / 16G (98%)
   Swap: 8G / 8G (100%)
   
   ## Top CPU Consumers
   1. java (PID 1234): 85% CPU
   2. postgres (PID 5678): 10% CPU
   
   ## Top Memory Consumers
   1. java (PID 1234): 12G RAM
   2. postgres (PID 5678): 2G RAM
   
   ## Root Cause
   Java application memory leak
   - Heap size: 12GB (max 12GB)
   - Old Gen: 11.8GB (99%)
   - GC thrashing
   - Memory leak in cache implementation
   
   ## Resolution
   1. Restarted Java application
   2. Applied memory leak fix
   3. Tuned JVM parameters
   4. Configured proper limits
   ```

2. **Diagnostic Commands**
   ```bash
   # CPU Investigation
   top -bn1
   ps aux --sort=-%cpu | head -10
   mpstat -P ALL 1 5
   pidstat -u 1 5
   
   # Memory Investigation  
   free -h
   ps aux --sort=-%mem | head -10
   pmap -x [PID]
   smem -tk
   
   # Check OOM killer
   dmesg | grep -i "out of memory"
   grep -i "killed process" /var/log/syslog
   
   # Check swap usage
   swapon --show
   vmstat 1 5
   
   # Java-specific (if applicable)
   jstat -gcutil [PID] 1000
   jmap -heap [PID]
   ```

3. **Immediate Resolution Script**
   ```bash
   #!/bin/bash
   # Emergency resource usage resolution
   
   # 1. Identify top CPU/memory process
   TOP_CPU_PID=$(ps aux --sort=-%cpu | awk 'NR==2 {print $2}')
   TOP_MEM_PID=$(ps aux --sort=-%mem | awk 'NR==2 {print $2}')
   
   # 2. Get process details
   ps aux | grep $TOP_CPU_PID
   
   # 3. Check if it's a known service
   # 4. Gracefully restart if possible
   # 5. Or kill if necessary
   
   # 6. Clear cache if safe
   sync; echo 3 > /proc/sys/vm/drop_caches
   ```

4. **Monitoring Configuration**
   ```bash
   # Set up alerts for high CPU/memory
   # Alert if:
   # - CPU > 80% for 5 minutes
   # - Memory > 90% for 5 minutes
   # - Swap > 50%
   # - Load average > (cores * 2)
   ```

5. **Prevention Measures**
   ```
   # Implemented Prevention
   
   1. Resource Limits (systemd)
   MemoryLimit=8G
   CPUQuota=200%
   
   2. OOM Score Adjustment
   OOMScoreAdjust=-500 (for critical services)
   
   3. Application Fixes
   - Fixed memory leak
   - Optimized queries
   - Added connection pooling
   
   4. Monitoring
   - CPU/Memory alerts
   - Trend analysis
   - Capacity planning
   ```

### 🎯 Success Criteria
- ✅ CPU usage back to normal (< 70%)
- ✅ Memory usage reasonable (< 80%)
- ✅ No swap thrashing
- ✅ Load average < 2x CPU count
- ✅ Applications stable
- ✅ Root cause identified and fixed
- ✅ Monitoring prevents recurrence
- ✅ No data loss during resolution

---

## All Real-World Tasks Complete! 🎉

You now have **18 comprehensive, executable real-world tasks** for Linux server administration, each with:
- Clear scenarios
- Time estimates
- Detailed instructions
- Validation checklists
- Expected deliverables
- Success criteria

These tasks are ready to be assigned to DevOps engineers for practical, hands-on learning and assessment.

---

**Document Version**: 1.0  
**Last Updated**: November 2025  
**Author**: DevOps Tasks 2026 Team

