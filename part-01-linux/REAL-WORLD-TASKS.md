# Part 1: Linux Real-World Tasks for DevOps Engineers

## 🎯 Overview

This document provides **real-world, executable tasks** that you can assign to DevOps engineers. Each task includes:
- **Clear scenario and context**
- **Time estimate for completion**
- **Step-by-step assignment instructions**
- **Validation checklist**
- **Expected deliverables**

These tasks are designed to be practical assignments that simulate actual production work.

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

## Task 1.1: Production Server Hardening

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

## Quick Reference: Time Estimates Summary

| Task | Difficulty | Time | Prerequisites |
|------|-----------|------|---------------|
| 1.1 - Server Hardening | Medium | 90 min | Basic Linux, SSH access |
| 1.2 - SSH Key Management | Medium | 60 min | SSH basics, user management |
| 1.3 - User/Group Management | Medium | 75 min | Linux permissions, groups |
| 1.4 - Filesystem & Quotas | Hard | 90 min | Disk management, ACLs |
| 1.5 - Systemd Service | Medium | 60 min | Systemd basics, service management |

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

## Additional Real-World Tasks (Coming Soon)

The following tasks will be added with the same real-world format:

- Task 1.6: Firewall Configuration for Multi-Tier Application
- Task 1.7: Centralized Logging Setup
- Task 1.8: Performance Troubleshooting During High Load
- Task 1.9: Package Repository Management
- Task 1.10: Database Backup Automation
- Task 1.11: Log Rotation Strategy
- Task 1.12: Disk Space Crisis Management
- Task 1.13: Network Connectivity Troubleshooting
- Task 1.14: Scheduled Task Management
- Task 1.15: Security Incident Response
- Task 1.16: DNS Configuration and Troubleshooting
- Task 1.17: Process Priority Management
- Task 1.18: Memory Leak Investigation

---

**Document Version**: 1.0  
**Last Updated**: November 2025  
**Author**: DevOps Tasks 2026 Team

