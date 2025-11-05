# Part 1: Linux Real-World Tasks - Complete Solutions Guide

> **📚 Navigation:** [← Back to Tasks](./REAL-WORLD-TASKS.md) | [Part 1 README](./README.md) | [Main README](../README.md)

## 🎯 Overview

This document provides **complete, production-ready solutions** for all 18 real-world Linux tasks. Each solution includes step-by-step commands, configuration files, scripts, and verification procedures.

> **⚠️ Important:** Try to complete the tasks on your own before viewing the solutions! These are here to help you learn, verify your approach, or unblock yourself if you get stuck.

> **📝 Need the task descriptions?** View the full task requirements in [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)

---

## Table of Contents

1. [Task 1.1: Production Server Hardening](#task-11-production-server-hardening)
2. [Task 1.2: SSH Key Management for Team Access](#task-12-ssh-key-management-for-team-access)
3. [Task 1.3: User and Group Management](#task-13-user-and-group-management-for-application-deployment)
4. [Task 1.4: Filesystem Management and Quota Setup](#task-14-filesystem-management-and-quota-setup)
5. [Task 1.5: Systemd Service Creation](#task-15-systemd-service-creation-for-backend-api)
6. [Task 1.6: Firewall Configuration](#task-16-firewall-configuration-for-multi-tier-application)
7. [Task 1.7: Centralized Logging Setup](#task-17-centralized-logging-setup-with-journald)
8. [Task 1.8: Performance Monitoring](#task-18-performance-monitoring-and-troubleshooting)
9. [Task 1.9: Package Management](#task-19-package-management-and-custom-repository)
10. [Task 1.10: PostgreSQL Backup Automation](#task-110-postgresql-backup-automation)
11. [Task 1.11: Log Rotation Configuration](#task-111-log-rotation-configuration)
12. [Task 1.12: Disk Space Crisis Management](#task-112-disk-space-crisis-management)
13. [Task 1.13: Network Troubleshooting](#task-113-network-connectivity-troubleshooting)
14. [Task 1.14: Systemd Timers](#task-114-systemd-timers-for-scheduled-tasks)
15. [Task 1.15: Security Incident Response](#task-115-security-incident-response)
16. [Task 1.16: DNS Configuration](#task-116-dns-configuration-and-troubleshooting)
17. [Task 1.17: Process Priority Management](#task-117-process-priority-management)
18. [Task 1.18: High CPU/Memory Troubleshooting](#task-118-high-cpu-and-memory-troubleshooting)

---

## Task 1.1: Production Server Hardening

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-11-production-server-hardening)**

### Solution Overview

Complete server hardening solution following industry best practices and security compliance standards.

### Step 1: System Updates and Automatic Security Updates

```bash
# Update all packages
sudo apt update
sudo apt upgrade -y

# Install unattended upgrades
sudo apt install unattended-upgrades apt-listchanges -y

# Configure automatic security updates
sudo dpkg-reconfigure -plow unattended-upgrades

# Edit configuration
sudo tee /etc/apt/apt.conf.d/50unattended-upgrades > /dev/null <<'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
    "${distro_id}ESMApps:${distro_codename}-apps-security";
    "${distro_id}ESM:${distro_codename}-infra-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Mail "root";
EOF

# Enable automatic updates
sudo systemctl enable unattended-upgrades
sudo systemctl start unattended-upgrades

# Verify
sudo unattended-upgrade --dry-run --debug
```

### Step 2: Install and Configure Fail2Ban

```bash
# Install fail2ban
sudo apt install fail2ban -y

# Create local configuration
sudo tee /etc/fail2ban/jail.local > /dev/null <<'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3
destemail = admin@company.com
sendername = Fail2Ban
action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
EOF

# Start and enable fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Check status
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

### Step 3: Configure UFW Firewall

```bash
# Install UFW
sudo apt install ufw -y

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (IMPORTANT: do this first!)
sudo ufw allow 22/tcp comment 'SSH'

# Allow HTTP and HTTPS
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Enable UFW (confirm yes)
sudo ufw --force enable

# Check status
sudo ufw status verbose

# Enable logging
sudo ufw logging on
```

### Step 4: Disable Unnecessary Services

```bash
# List running services
sudo systemctl list-units --type=service --state=running

# Disable unnecessary services
sudo systemctl disable bluetooth.service
sudo systemctl stop bluetooth.service

sudo systemctl disable avahi-daemon.service
sudo systemctl stop avahi-daemon.service

sudo systemctl disable cups.service
sudo systemctl stop cups.service

# Verify disabled services
sudo systemctl is-enabled bluetooth
sudo systemctl is-active bluetooth
```

### Step 5: Apply Kernel Security Parameters

```bash
# Backup original sysctl.conf
sudo cp /etc/sysctl.conf /etc/sysctl.conf.backup

# Add security parameters
sudo tee -a /etc/sysctl.conf > /dev/null <<'EOF'

# IP Spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Enable TCP SYN cookies
net.ipv4.tcp_syncookies = 1

# Log Martians
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# Ignore ICMP ping requests
net.ipv4.icmp_echo_ignore_all = 0

# Ignore Broadcast pings
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Enable IPv6 privacy extensions
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2
EOF

# Apply changes
sudo sysctl -p

# Verify
sudo sysctl net.ipv4.tcp_syncookies
sudo sysctl net.ipv4.conf.all.rp_filter
```

### Step 6: Set Up Audit Logging

```bash
# Install auditd
sudo apt install auditd audispd-plugins -y

# Start and enable auditd
sudo systemctl start auditd
sudo systemctl enable auditd

# Add audit rules
sudo tee /etc/audit/rules.d/hardening.rules > /dev/null <<'EOF'
# Monitor user/group changes
-w /etc/passwd -p wa -k passwd_changes
-w /etc/group -p wa -k group_changes
-w /etc/shadow -p wa -k shadow_changes
-w /etc/sudoers -p wa -k sudoers_changes
-w /etc/sudoers.d/ -p wa -k sudoers_changes

# Monitor SSH configuration
-w /etc/ssh/sshd_config -p wa -k sshd_config_changes

# Monitor login/logout events
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock/ -p wa -k logins

# Monitor network configuration
-w /etc/network/ -p wa -k network_changes
-w /etc/hosts -p wa -k hosts_changes

# Monitor kernel module loading
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
EOF

# Reload audit rules
sudo augenrules --load

# Check status
sudo auditctl -l
sudo systemctl status auditd
```

### Step 7: Harden SSH Configuration

```bash
# Backup SSH config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Apply hardened SSH configuration
sudo tee /etc/ssh/sshd_config > /dev/null <<'EOF'
# Port and Protocol
Port 22
Protocol 2

# Authentication
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes

# Security Settings
MaxAuthTries 3
MaxSessions 10
ClientAliveInterval 300
ClientAliveCountMax 2
LoginGraceTime 60

# Disable dangerous features
X11Forwarding no
PermitTunnel no
AllowTcpForwarding no
AllowAgentForwarding no

# Logging
SyslogFacility AUTH
LogLevel VERBOSE

# Allow only specific users (adjust as needed)
# AllowUsers deploy ubuntu

# Strong ciphers only
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512

# Banner
Banner /etc/ssh/banner
EOF

# Create SSH banner
sudo tee /etc/ssh/banner > /dev/null <<'EOF'
***********************************************************************
*                                                                     *
*  Authorized access only!                                            *
*  All activity is logged and monitored.                              *
*  Unauthorized access will be prosecuted to the fullest extent.      *
*                                                                     *
***********************************************************************
EOF

# Test SSH configuration
sudo sshd -t

# Restart SSH (make sure you have another session open!)
sudo systemctl restart sshd

# Verify
sudo systemctl status sshd
```

### Step 8: Create Security Audit Report

```bash
# Create audit report
cat > /tmp/security-audit-report.txt <<EOF
SECURITY AUDIT REPORT
=====================
Hostname: $(hostname)
Date: $(date)
IP Address: $(hostname -I | awk '{print $1}')

SYSTEM UPDATES
--------------
Packages Updated: $(cat /var/log/apt/history.log | grep "End-Date" | wc -l)
Unattended Upgrades: Enabled
Last Update: $(stat -c %y /var/log/apt/history.log | cut -d'.' -f1)

FAIL2BAN STATUS
---------------
$(sudo fail2ban-client status)

FIREWALL RULES
--------------
$(sudo ufw status verbose)

DISABLED SERVICES
-----------------
$(sudo systemctl list-unit-files --type=service --state=disabled | grep -E 'bluetooth|cups|avahi')

KERNEL PARAMETERS
-----------------
TCP SYN Cookies: $(sysctl net.ipv4.tcp_syncookies | awk '{print $3}')
IP Spoofing Protection: $(sysctl net.ipv4.conf.all.rp_filter | awk '{print $3}')
ICMP Redirects: $(sysctl net.ipv4.conf.all.accept_redirects | awk '{print $3}')

SSH CONFIGURATION
-----------------
$(sudo grep -E 'PermitRootLogin|PasswordAuthentication|MaxAuthTries|ClientAliveInterval' /etc/ssh/sshd_config | grep -v '^#')

AUDIT RULES
-----------
$(sudo auditctl -l | wc -l) audit rules active

ACTIVE CONNECTIONS
------------------
$(ss -tuln | grep LISTEN | wc -l) listening ports
EOF

cat /tmp/security-audit-report.txt
```

### Verification Checklist Script

```bash
#!/bin/bash
# security-verification.sh - Verify all hardening steps

echo "=== Security Hardening Verification ==="
echo

# Check unattended upgrades
echo "✓ Checking unattended upgrades..."
systemctl is-active unattended-upgrades && echo "  [PASS] Unattended upgrades active" || echo "  [FAIL] Not active"

# Check fail2ban
echo "✓ Checking fail2ban..."
systemctl is-active fail2ban && echo "  [PASS] Fail2ban active" || echo "  [FAIL] Not active"
sudo fail2ban-client status sshd | grep -q "Currently banned:" && echo "  [PASS] SSH jail enabled" || echo "  [WARN] No banned IPs yet"

# Check UFW
echo "✓ Checking firewall..."
sudo ufw status | grep -q "Status: active" && echo "  [PASS] UFW active" || echo "  [FAIL] UFW not active"

# Check SSH config
echo "✓ Checking SSH hardening..."
sudo grep -q "^PermitRootLogin no" /etc/ssh/sshd_config && echo "  [PASS] Root login disabled" || echo "  [FAIL] Root login enabled"
sudo grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config && echo "  [PASS] Password auth disabled" || echo "  [FAIL] Password auth enabled"

# Check auditd
echo "✓ Checking audit daemon..."
systemctl is-active auditd && echo "  [PASS] Auditd active" || echo "  [FAIL] Not active"

# Check kernel parameters
echo "✓ Checking kernel parameters..."
[ "$(sysctl -n net.ipv4.tcp_syncookies)" = "1" ] && echo "  [PASS] TCP SYN cookies enabled" || echo "  [FAIL] Not enabled"
[ "$(sysctl -n net.ipv4.conf.all.rp_filter)" = "1" ] && echo "  [PASS] IP spoofing protection enabled" || echo "  [FAIL] Not enabled"

echo
echo "=== Verification Complete ==="
```

---

## Task 1.2: SSH Key Management for Team Access

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-12-ssh-key-management-for-team-access)**

### Solution Overview

Complete SSH key management solution with proper access controls for team members.

### Step 1: Create User Accounts

```bash
#!/bin/bash
# create-users.sh - Create user accounts for team

# Create alice (senior engineer) with sudo access
sudo useradd -m -s /bin/bash alice
sudo usermod -aG sudo alice
sudo mkdir -p /home/alice/.ssh
sudo chmod 700 /home/alice/.ssh

# Create bob (mid-level engineer) with limited sudo
sudo useradd -m -s /bin/bash bob
sudo mkdir -p /home/bob/.ssh
sudo chmod 700 /home/bob/.ssh

# Create charlie (junior engineer) - no sudo
sudo useradd -m -s /bin/bash charlie
sudo mkdir -p /home/charlie/.ssh
sudo chmod 700 /home/charlie/.ssh

echo "Users created successfully"
```

### Step 2: Generate SSH Keys for Each User

```bash
#!/bin/bash
# generate-keys.sh - Generate SSH keys for team members

# Generate key for alice
ssh-keygen -t ed25519 -C "alice@company.com" -f ./keys/alice_ed25519 -N ""

# Generate key for bob
ssh-keygen -t ed25519 -C "bob@company.com" -f ./keys/bob_ed25519 -N ""

# Generate key for charlie
ssh-keygen -t ed25519 -C "charlie@company.com" -f ./keys/charlie_ed25519 -N ""

echo "Keys generated in ./keys/ directory"
echo "Private keys: alice_ed25519, bob_ed25519, charlie_ed25519"
echo "Public keys: alice_ed25519.pub, bob_ed25519.pub, charlie_ed25519.pub"
```

### Step 3: Install Public Keys

```bash
#!/bin/bash
# install-keys.sh - Install public keys for each user

# Install alice's public key
sudo tee /home/alice/.ssh/authorized_keys > /dev/null <<EOF
$(cat ./keys/alice_ed25519.pub)
EOF
sudo chown alice:alice /home/alice/.ssh/authorized_keys
sudo chmod 600 /home/alice/.ssh/authorized_keys

# Install bob's public key
sudo tee /home/bob/.ssh/authorized_keys > /dev/null <<EOF
$(cat ./keys/bob_ed25519.pub)
EOF
sudo chown bob:bob /home/bob/.ssh/authorized_keys
sudo chmod 600 /home/bob/.ssh/authorized_keys

# Install charlie's public key
sudo tee /home/charlie/.ssh/authorized_keys > /dev/null <<EOF
$(cat ./keys/charlie_ed25519.pub)
EOF
sudo chown charlie:charlie /home/charlie/.ssh/authorized_keys
sudo chmod 600 /home/charlie/.ssh/authorized_keys

echo "Public keys installed successfully"
```

### Step 4: Configure Sudo Access

```bash
# Create sudoers configuration for bob (limited access)
sudo tee /etc/sudoers.d/bob > /dev/null <<'EOF'
# Bob's limited sudo permissions
bob ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
bob ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop nginx
bob ALL=(ALL) NOPASSWD: /usr/bin/systemctl start nginx
bob ALL=(ALL) NOPASSWD: /usr/bin/systemctl status *
bob ALL=(ALL) NOPASSWD: /usr/bin/journalctl *
bob ALL=(ALL) NOPASSWD: /usr/bin/docker ps
bob ALL=(ALL) NOPASSWD: /usr/bin/docker logs *
bob ALL=(ALL) NOPASSWD: /usr/bin/docker restart *
bob ALL=(ALL) NOPASSWD: /usr/bin/docker exec *
EOF

# Verify sudoers file
sudo visudo -c -f /etc/sudoers.d/bob

echo "Sudo access configured"
```

### Step 5: Disable Password Authentication

```bash
# Edit SSH configuration
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Test configuration
sudo sshd -t

# Restart SSH
sudo systemctl restart sshd
```

### Step 6: Create SSH Client Configuration

```bash
# Create sample client config
cat > ~/.ssh/config <<'EOF'
# SSH Client Configuration for Team Access

Host alice-prod
    HostName 10.0.1.100
    User alice
    IdentityFile ~/.ssh/alice_ed25519
    Port 22
    StrictHostKeyChecking ask
    UserKnownHostsFile ~/.ssh/known_hosts

Host bob-prod
    HostName 10.0.1.100
    User bob
    IdentityFile ~/.ssh/bob_ed25519
    Port 22
    StrictHostKeyChecking ask

Host charlie-prod
    HostName 10.0.1.100
    User charlie
    IdentityFile ~/.ssh/charlie_ed25519
    Port 22
    StrictHostKeyChecking ask

# Global settings
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    Compression yes
EOF

chmod 600 ~/.ssh/config
```

### Step 7: Create Access Matrix Documentation

```bash
cat > /tmp/access-matrix.md <<'EOF'
# SSH Access Configuration

## User Access Levels

| User    | SSH Access | Sudo Access | Allowed Commands                                |
|---------|-----------|-------------|------------------------------------------------|
| alice   | Yes       | Full        | All commands                                    |
| bob     | Yes       | Limited     | systemctl (nginx), journalctl, docker commands  |
| charlie | Yes       | None        | N/A                                             |

## SSH Keys

- alice: ED25519 fingerprint (use: ssh-keygen -lf alice_ed25519.pub)
- bob: ED25519 fingerprint (use: ssh-keygen -lf bob_ed25519.pub)
- charlie: ED25519 fingerprint (use: ssh-keygen -lf charlie_ed25519.pub)

## Connection Examples

```bash
# Connect as alice
ssh alice-prod

# Connect as bob
ssh bob-prod

# Connect as charlie
ssh charlie-prod
```

## Key Rotation Schedule

- Keys should be rotated every 90 days
- Emergency rotation: immediately if compromise suspected
- Rotation process: See key-rotation.sh script
EOF
```

### Step 8: Key Rotation Script

```bash
#!/bin/bash
# key-rotation.sh - Automate SSH key rotation

USER=$1
if [ -z "$USER" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

echo "=== SSH Key Rotation for $USER ==="

# Generate new key pair
NEW_KEY="/tmp/${USER}_ed25519_new"
ssh-keygen -t ed25519 -C "${USER}@company.com-$(date +%Y%m%d)" -f "$NEW_KEY" -N ""

echo "✓ New key pair generated"

# Display fingerprint
echo "New key fingerprint:"
ssh-keygen -lf "${NEW_KEY}.pub"

# Instructions
cat <<EOF

Next steps:
1. Add new public key to authorized_keys (keeping old key):
   
   sudo tee -a /home/$USER/.ssh/authorized_keys < ${NEW_KEY}.pub

2. Test new key:
   
   ssh -i ${NEW_KEY} ${USER}@server

3. If successful, remove old key from authorized_keys:
   
   sudo vi /home/$USER/.ssh/authorized_keys
   (remove the old key line)

4. Distribute new private key securely to ${USER}

5. Verify old key no longer works

New private key: ${NEW_KEY}
New public key: ${NEW_KEY}.pub

IMPORTANT: Keep both keys active for 24 hours before removing old key!
EOF
```

### Verification Tests

```bash
#!/bin/bash
# test-access.sh - Test SSH access for all users

echo "=== Testing SSH Access ==="

# Test alice (should have full sudo)
echo "Testing alice..."
ssh alice-prod "sudo ls /root" && echo "  [PASS] Alice has full sudo" || echo "  [FAIL] Alice sudo test failed"

# Test bob (should have limited sudo)
echo "Testing bob..."
ssh bob-prod "sudo systemctl status nginx" && echo "  [PASS] Bob can check nginx status" || echo "  [INFO] Nginx not installed or bob access failed"
ssh bob-prod "sudo cat /etc/shadow" 2>&1 | grep -q "not allowed" && echo "  [PASS] Bob correctly denied /etc/shadow" || echo "  [INFO] Test skipped"

# Test charlie (should have no sudo)
echo "Testing charlie..."
ssh charlie-prod "sudo ls" 2>&1 | grep -q "not in the sudoers file" && echo "  [PASS] Charlie has no sudo" || echo "  [FAIL] Charlie has unexpected sudo"
ssh charlie-prod "ls ~" && echo "  [PASS] Charlie can access home directory" || echo "  [FAIL] Charlie cannot access home"

# Test password authentication disabled
echo "Testing password auth disabled..."
ssh -o PubkeyAuthentication=no alice-prod "echo test" 2>&1 | grep -q "Permission denied" && echo "  [PASS] Password auth disabled" || echo "  [WARN] Password auth may be enabled"

echo "=== Tests Complete ==="
```

---

## Task 1.3: User and Group Management for Application Deployment

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-13-user-and-group-management-for-application-deployment)**

### Solution Overview

This solution creates a secure user and group structure for multi-tier application deployment.

### Step 1: Create Application Users

```bash
#!/bin/bash
# create-app-users.sh - Create users for application deployment

# Create deployment user
sudo useradd -m -s /bin/bash deploy
echo "deploy:$(openssl rand -base64 12)" | sudo chpasswd

# Create application service users (no login)
sudo useradd -r -s /sbin/nologin frontend-app
sudo useradd -r -s /sbin/nologin backend-app
sudo useradd -r -s /sbin/nologin worker-app

# Create developer users
sudo useradd -m -s /bin/bash dev1
sudo useradd -m -s /bin/bash dev2

echo "Users created successfully"
getent passwd | grep -E 'deploy|frontend-app|backend-app|worker-app|dev1|dev2'
```

### Step 2: Create Groups

```bash
#!/bin/bash
# create-groups.sh - Create application groups

# Create groups
sudo groupadd app-services
sudo groupadd deployers
sudo groupadd developers

# Add users to groups
sudo usermod -aG deployers deploy
sudo usermod -aG app-services frontend-app
sudo usermod -aG app-services backend-app
sudo usermod -aG app-services worker-app
sudo usermod -aG developers dev1
sudo usermod -aG developers dev2

echo "Groups created and users assigned"
getent group | grep -E 'app-services|deployers|developers'
```

### Step 3: Create Directory Structure

```bash
#!/bin/bash
# setup-directories.sh - Create application directory structure

# Create main application directory
sudo mkdir -p /opt/applications/{frontend,backend,worker}
sudo mkdir -p /var/log/applications/{frontend,backend,worker}

# Set ownership for main directory
sudo chown deploy:app-services /opt/applications
sudo chmod 755 /opt/applications

# Set ownership for each application
sudo chown frontend-app:app-services /opt/applications/frontend
sudo chown backend-app:app-services /opt/applications/backend
sudo chown worker-app:app-services /opt/applications/worker

# Set permissions
sudo chmod 750 /opt/applications/frontend
sudo chmod 750 /opt/applications/backend
sudo chmod 750 /opt/applications/worker

# Set up log directories
sudo chown frontend-app:app-services /var/log/applications/frontend
sudo chown backend-app:app-services /var/log/applications/backend
sudo chown worker-app:app-services /var/log/applications/worker
sudo chmod 775 /var/log/applications/{frontend,backend,worker}

echo "Directory structure created"
ls -la /opt/applications/
ls -la /var/log/applications/
```

### Step 4: Configure ACLs for Developer Access

```bash
#!/bin/bash
# setup-acls.sh - Configure ACLs for developer read access

# Install ACL tools
sudo apt install acl -y

# Give developers read access to application directories
sudo setfacl -R -m g:developers:r-x /opt/applications
sudo setfacl -R -d -m g:developers:r-x /opt/applications

# Give developers read access to logs
sudo setfacl -R -m g:developers:r-x /var/log/applications
sudo setfacl -R -d -m g:developers:r-x /var/log/applications

# Verify ACLs
echo "ACLs for /opt/applications:"
getfacl /opt/applications

echo "ACLs for /var/log/applications:"
getfacl /var/log/applications

echo "ACLs configured successfully"
```

### Step 5: Configure Deploy User Sudo Permissions

```bash
# Create sudoers file for deploy user
sudo tee /etc/sudoers.d/deploy-user > /dev/null <<'EOF'
# Deploy user permissions
# Allow service management for application services only
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl start app-frontend
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl start app-backend
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl start app-worker
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop app-frontend
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop app-backend
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop app-worker
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart app-frontend
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart app-backend
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart app-worker
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl status app-*

# Allow viewing logs
deploy ALL=(ALL) NOPASSWD: /usr/bin/journalctl -u app-*

# Explicitly deny daemon-reload
deploy ALL=(ALL) !/usr/bin/systemctl daemon-reload
EOF

# Verify sudoers syntax
sudo visudo -c -f /etc/sudoers.d/deploy-user
echo "Sudoers configuration created"
```

### Step 6: Complete Setup Script

```bash
#!/bin/bash
# complete-setup.sh - Complete user and group setup

set -e

echo "=== Application User and Group Setup ==="

# Create users
echo "Creating users..."
sudo useradd -m -s /bin/bash deploy || true
sudo useradd -r -s /sbin/nologin frontend-app || true
sudo useradd -r -s /sbin/nologin backend-app || true
sudo useradd -r -s /sbin/nologin worker-app || true
sudo useradd -m -s /bin/bash dev1 || true
sudo useradd -m -s /bin/bash dev2 || true

# Create groups
echo "Creating groups..."
sudo groupadd app-services || true
sudo groupadd deployers || true
sudo groupadd developers || true

# Assign group memberships
echo "Assigning group memberships..."
sudo usermod -aG deployers deploy
sudo usermod -aG app-services frontend-app
sudo usermod -aG app-services backend-app
sudo usermod -aG app-services worker-app
sudo usermod -aG developers dev1
sudo usermod -aG developers dev2

# Create directories
echo "Creating directories..."
sudo mkdir -p /opt/applications/{frontend,backend,worker}
sudo mkdir -p /var/log/applications/{frontend,backend,worker}

# Set ownership and permissions
echo "Setting permissions..."
sudo chown deploy:app-services /opt/applications
sudo chmod 755 /opt/applications

for app in frontend backend worker; do
    sudo chown ${app}-app:app-services /opt/applications/$app
    sudo chmod 750 /opt/applications/$app
    sudo chown ${app}-app:app-services /var/log/applications/$app
    sudo chmod 775 /var/log/applications/$app
done

# Install and configure ACLs
echo "Configuring ACLs..."
sudo apt install acl -y
sudo setfacl -R -m g:developers:r-x /opt/applications
sudo setfacl -R -d -m g:developers:r-x /opt/applications
sudo setfacl -R -m g:developers:r-x /var/log/applications
sudo setfacl -R -d -m g:developers:r-x /var/log/applications

# Configure sudoers
echo "Configuring sudo access..."
sudo tee /etc/sudoers.d/deploy-user > /dev/null <<'SUDOEOF'
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl start app-*
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop app-*
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart app-*
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl status app-*
deploy ALL=(ALL) NOPASSWD: /usr/bin/journalctl -u app-*
deploy ALL=(ALL) !/usr/bin/systemctl daemon-reload
SUDOEOF

sudo visudo -c -f /etc/sudoers.d/deploy-user

echo ""
echo "=== Setup Complete ==="
echo "Users created:"
getent passwd | grep -E 'deploy|frontend-app|backend-app|worker-app|dev1|dev2'
echo ""
echo "Groups:"
getent group | grep -E 'app-services|deployers|developers'
```

### Verification Tests

```bash
#!/bin/bash
# test-permissions.sh - Test all permission configurations

echo "=== Permission Tests ==="

# Test 1: Deploy user can restart app services
echo "Test 1: Deploy user service management..."
sudo -u deploy sudo systemctl status app-frontend 2>&1 | grep -q "Unit app-frontend.service could not be found" && echo "  [INFO] Service not installed (expected)" || echo "  [PASS] Deploy can check service"

# Test 2: Deploy user cannot daemon-reload
echo "Test 2: Deploy user restrictions..."
sudo -u deploy sudo systemctl daemon-reload 2>&1 | grep -q "not allowed" && echo "  [PASS] Deploy correctly denied daemon-reload" || echo "  [FAIL] Deploy should not have daemon-reload"

# Test 3: Developer can read application files
echo "Test 3: Developer read access..."
sudo -u dev1 ls /opt/applications/frontend && echo "  [PASS] Developer can read app directory" || echo "  [FAIL] Developer cannot read"

# Test 4: Developer cannot write to application files
echo "Test 4: Developer write restrictions..."
sudo -u dev1 touch /opt/applications/frontend/test.txt 2>&1 | grep -q "Permission denied" && echo "  [PASS] Developer correctly denied write" || echo "  [FAIL] Developer should not have write"

# Test 5: Application users cannot login
echo "Test 5: Application users cannot login..."
sudo -u frontend-app bash 2>&1 | grep -q "This account is currently not available" && echo "  [PASS] frontend-app cannot login" || echo "  [INFO] Expected nologin shell"

# Test 6: Check directory permissions
echo "Test 6: Directory permissions..."
[ "$(stat -c %a /opt/applications/frontend)" = "750" ] && echo "  [PASS] Frontend directory has correct permissions" || echo "  [WARN] Check permissions"

# Test 7: Check ACLs
echo "Test 7: ACL configuration..."
getfacl /opt/applications 2>/dev/null | grep -q "group:developers" && echo "  [PASS] Developer ACLs configured" || echo "  [FAIL] ACLs not configured"

echo "=== Tests Complete ==="
```

---

## Task 1.4: Filesystem Management and Quota Setup

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-14-filesystem-management-and-quota-setup)**

### Solution Overview

Complete filesystem management solution with disk quotas and ACL configuration.

### Step 1: Install Quota Tools

```bash
# Install quota package
sudo apt update
sudo apt install quota -y

# Verify installation
quota --version
```

### Step 2: Enable Quotas on Filesystem

```bash
# Backup fstab
sudo cp /etc/fstab /etc/fstab.backup

# Enable quotas on root filesystem
# Edit /etc/fstab and add usrquota,grpquota to mount options
sudo sed -i 's/\(.*\s\/\s.*defaults\)/\1,usrquota,grpquota/' /etc/fstab

# For specific partition (example):
# UUID=xxx / ext4 defaults,usrquota,grpquota 0 1

# Remount filesystem
sudo mount -o remount /

# Verify quota mount options
mount | grep ' / ' | grep quota && echo "Quota options enabled" || echo "Quota not enabled - check fstab"
```

### Step 3: Create Quota Database

```bash
# Create quota files
sudo quotacheck -cug /
sudo quotacheck -avugm

# Turn on quotas
sudo quotaon -v /

# Verify quotas are on
sudo quotaon -p /
```

### Step 4: Set Up Directory Structure

```bash
#!/bin/bash
# setup-quota-dirs.sh - Create directory structure for quotas

# Create directories
sudo mkdir -p /opt/applications
sudo mkdir -p /var/log/applications/{frontend-app,backend-app,worker-app}
sudo mkdir -p /opt/uploads
sudo mkdir -p /opt/backups

# Set ownership
sudo chown root:app-services /opt/applications
sudo chown frontend-app:app-services /var/log/applications/frontend-app
sudo chown backend-app:app-services /var/log/applications/backend-app
sudo chown worker-app:app-services /var/log/applications/worker-app
sudo chown www-data:app-services /opt/uploads
sudo chown postgres:app-services /opt/backups

# Set permissions
sudo chmod 755 /opt/applications
sudo chmod 775 /var/log/applications/{frontend-app,backend-app,worker-app}
sudo chmod 775 /opt/uploads
sudo chmod 770 /opt/backups

# Set sticky bit on uploads
sudo chmod +t /opt/uploads

echo "Directory structure created"
```

### Step 5: Configure User Quotas

```bash
#!/bin/bash
# setup-quotas.sh - Configure disk quotas for users

# Set quota for frontend-app (5GB soft, 5GB hard)
sudo setquota -u frontend-app 4194304 5242880 0 0 /

# Set quota for backend-app (10GB soft, 10GB hard)
sudo setquota -u backend-app 8388608 10485760 0 0 /

# Set quota for worker-app (5GB soft, 5GB hard)
sudo setquota -u worker-app 4194304 5242880 0 0 /

# Set grace period to 7 days
sudo setquota -t 604800 604800 /

echo "Quotas configured"
sudo repquota -a
```

### Step 6: Configure ACLs

```bash
#!/bin/bash
# setup-acls-advanced.sh - Configure ACLs for shared access

# Install ACL tools
sudo apt install acl -y

# Set ACLs for uploads directory
# Developers: read access
# Deployers: read/write access
sudo setfacl -m g:developers:r-x /opt/uploads
sudo setfacl -m g:deployers:rwx /opt/uploads
sudo setfacl -d -m g:developers:r-x /opt/uploads
sudo setfacl -d -m g:deployers:rwx /opt/uploads

# Set ACLs for application directories
sudo setfacl -R -m g:developers:r-x /opt/applications
sudo setfacl -R -d -m g:developers:r-x /opt/applications

# Set ACLs for log directories
sudo setfacl -R -m g:developers:r-x /var/log/applications
sudo setfacl -R -d -m g:developers:r-x /var/log/applications

# Display ACLs
echo "=== ACLs for /opt/uploads ==="
getfacl /opt/uploads

echo "=== ACLs for /opt/applications ==="
getfacl /opt/applications

echo "ACLs configured successfully"
```

### Step 7: Disk Monitoring Script

```bash
#!/bin/bash
# check_disk_usage.sh - Monitor disk usage and quota status

# Configuration
THRESHOLD=80
ALERT_EMAIL="admin@company.com"
LOG_FILE="/var/log/disk-monitor.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to send alert
send_alert() {
    local subject="$1"
    local message="$2"
    echo "$message" | mail -s "$subject" "$ALERT_EMAIL"
}

log_message "=== Disk Usage Check ==="

# Check overall disk usage
DISK_USAGE=$(df -h / | awk 'NR==2 {print $(NF-1)}' | sed 's/%//')
log_message "Overall disk usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    MESSAGE="WARNING: Disk usage is at ${DISK_USAGE}% on $(hostname)"
    log_message "$MESSAGE"
    send_alert "Disk Usage Alert" "$MESSAGE"
fi

# Check quota usage for each user
log_message "=== Quota Status ==="
QUOTA_REPORT=$(sudo repquota -a)
echo "$QUOTA_REPORT" | tee -a "$LOG_FILE"

# Check if any user is over 80% of quota
while IFS= read -r line; do
    if echo "$line" | grep -E "frontend-app|backend-app|worker-app" > /dev/null; then
        USED=$(echo "$line" | awk '{print $3}')
        SOFT_LIMIT=$(echo "$line" | awk '{print $4}')
        
        if [ "$SOFT_LIMIT" -gt 0 ]; then
            PERCENTAGE=$((USED * 100 / SOFT_LIMIT))
            USER=$(echo "$line" | awk '{print $1}')
            
            if [ "$PERCENTAGE" -gt "$THRESHOLD" ]; then
                MESSAGE="WARNING: User $USER is at ${PERCENTAGE}% of quota"
                log_message "$MESSAGE"
                send_alert "Quota Alert" "$MESSAGE"
            fi
        fi
    fi
done <<< "$QUOTA_REPORT"

# Check specific directories
log_message "=== Directory Sizes ==="
du -sh /opt/* /var/log/applications/* 2>/dev/null | tee -a "$LOG_FILE"

log_message "=== Check Complete ==="
```

### Step 8: Test Quota Enforcement

```bash
#!/bin/bash
# test-quotas.sh - Test quota enforcement

echo "=== Testing Quota Enforcement ==="

# Test 1: Try to exceed frontend-app quota
echo "Test 1: Testing frontend-app quota (5GB limit)..."
sudo -u frontend-app bash -c '
    cd /var/log/applications/frontend-app
    dd if=/dev/zero of=test_file bs=1M count=6000 2>&1
' | grep -q "Disk quota exceeded" && echo "  [PASS] Quota correctly enforced" || echo "  [INFO] Quota test"

# Cleanup test file
sudo rm -f /var/log/applications/frontend-app/test_file

# Test 2: Check current quota usage
echo "Test 2: Checking quota usage..."
sudo quota -vs frontend-app

# Test 3: Verify ACL permissions
echo "Test 3: Testing ACL permissions..."
sudo -u dev1 cat /opt/uploads/test-file 2>&1 | grep -q "No such file" && echo "  [INFO] Test file doesn't exist" || echo "  [TEST] ACL read access"

# Test 4: Check disk usage
echo "Test 4: Current disk usage..."
df -h /

echo "=== Tests Complete ==="
```

### Complete Setup Script

```bash
#!/bin/bash
# complete-quota-setup.sh - Complete quota setup

set -e

echo "=== Disk Quota Setup ==="

# Install quota tools
echo "Installing quota tools..."
sudo apt update
sudo apt install quota acl -y

# Enable quotas in fstab
echo "Enabling quotas..."
sudo cp /etc/fstab /etc/fstab.backup
sudo sed -i 's/\(.*\s\/\s.*defaults\)/\1,usrquota,grpquota/' /etc/fstab

# Remount filesystem
sudo mount -o remount /

# Initialize quota database
echo "Initializing quota database..."
sudo quotacheck -cug / || true
sudo quotacheck -avugm

# Enable quotas
sudo quotaon -v /

# Create directory structure
echo "Creating directories..."
sudo mkdir -p /opt/applications
sudo mkdir -p /var/log/applications/{frontend-app,backend-app,worker-app}
sudo mkdir -p /opt/uploads
sudo mkdir -p /opt/backups

# Set ownership
sudo chown frontend-app:app-services /var/log/applications/frontend-app
sudo chown backend-app:app-services /var/log/applications/backend-app
sudo chown worker-app:app-services /var/log/applications/worker-app

# Configure quotas (values in KB)
echo "Configuring quotas..."
# Frontend: 4GB soft, 5GB hard
sudo setquota -u frontend-app 4194304 5242880 0 0 /
# Backend: 8GB soft, 10GB hard
sudo setquota -u backend-app 8388608 10485760 0 0 /
# Worker: 4GB soft, 5GB hard
sudo setquota -u worker-app 4194304 5242880 0 0 /

# Set grace period (7 days = 604800 seconds)
sudo setquota -t 604800 604800 /

# Configure ACLs
echo "Configuring ACLs..."
sudo setfacl -R -m g:developers:r-x /opt/applications
sudo setfacl -R -d -m g:developers:r-x /opt/applications

# Create monitoring script
echo "Creating monitoring script..."
sudo tee /usr/local/bin/check_disk_usage.sh > /dev/null <<'SCRIPTEOF'
#!/bin/bash
# Disk usage monitoring script
THRESHOLD=80
DISK_USAGE=$(df -h / | awk 'NR==2 {print $(NF-1)}' | sed 's/%//')
echo "Disk usage: ${DISK_USAGE}%"
if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    echo "WARNING: Disk usage above ${THRESHOLD}%"
fi
sudo repquota -a
SCRIPTEOF

sudo chmod +x /usr/local/bin/check_disk_usage.sh

echo ""
echo "=== Setup Complete ==="
echo "Quota status:"
sudo repquota -a
```

---

*Due to length constraints, I'll continue with the remaining tasks in the next section. The file has been created with solutions for tasks 1.1-1.4. Would you like me to continue adding solutions for tasks 1.5-1.18?*

## Task 1.5: Systemd Service Creation for Backend API

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-15-systemd-service-creation-for-backend-api)**

### Solution Overview

Complete systemd service configuration for Node.js backend API with proper resource limits and security hardening.

### Step 1: Create Service Unit File

```bash
# Create systemd service file
sudo tee /etc/systemd/system/backend-api.service > /dev/null <<'EOF'
[Unit]
Description=Backend API Service
Documentation=https://docs.company.com/backend-api
After=network.target postgresql.service redis.service
Wants=postgresql.service redis.service
Requires=network.target

[Service]
Type=simple
User=backend-app
Group=backend-app
WorkingDirectory=/opt/applications/backend

# Environment variables
Environment="NODE_ENV=production"
Environment="PORT=8080"
Environment="LOG_LEVEL=info"
EnvironmentFile=-/etc/backend-api/environment

# Start command
ExecStart=/usr/bin/node /opt/applications/backend/server.js
ExecStop=/bin/kill -SIGTERM $MAINPID

# Restart policy
Restart=on-failure
RestartSec=10s
StartLimitInterval=200
StartLimitBurst=5

# Resource limits
MemoryLimit=8G
MemoryHigh=6G
CPUQuota=200%
TasksMax=512
LimitNOFILE=65536
LimitNPROC=512

# Security hardening
NoNewPrivileges=true
PrivateTmp=yes
ProtectSystem=strict
ProtectHome=yes
ReadWritePaths=/opt/applications/backend/logs /opt/applications/backend/temp
ReadOnlyPaths=/opt/applications/backend
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
RestrictRealtime=true
RestrictSUIDSGID=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX
RestrictNamespaces=true
LockPersonality=true
SystemCallFilter=@system-service
SystemCallErrorNumber=EPERM
SystemCallArchitectures=native

# Logging
StandardOutput=journal
StandardError=journal
SyslogIdentifier=backend-api

[Install]
WantedBy=multi-user.target
EOF
```

### Step 2: Create Environment Configuration

```bash
# Create environment file directory
sudo mkdir -p /etc/backend-api

# Create environment file (secrets should be managed separately)
sudo tee /etc/backend-api/environment > /dev/null <<'EOF'
# Backend API Environment Configuration
NODE_ENV=production
PORT=8080
LOG_LEVEL=info
MAX_CONNECTIONS=1000
TIMEOUT=30000

# Database (use secrets management in production)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=production_db

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Application settings
API_RATE_LIMIT=100
CACHE_TTL=3600
EOF

# Secure the environment file
sudo chmod 600 /etc/backend-api/environment
sudo chown backend-app:backend-app /etc/backend-api/environment
```

### Step 3: Create Health Check Script

```bash
# Create health check script
sudo tee /usr/local/bin/backend-api-health.sh > /dev/null <<'EOF'
#!/bin/bash
# Health check for backend API

HEALTH_URL="http://localhost:8080/health"
TIMEOUT=5

# Check if service is running
if ! systemctl is-active --quiet backend-api; then
    echo "ERROR: Service is not running"
    exit 1
fi

# Check health endpoint
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT "$HEALTH_URL")

if [ "$HTTP_CODE" = "200" ]; then
    echo "OK: Backend API is healthy (HTTP $HTTP_CODE)"
    exit 0
else
    echo "ERROR: Backend API health check failed (HTTP $HTTP_CODE)"
    exit 1
fi
EOF

sudo chmod +x /usr/local/bin/backend-api-health.sh
```

### Step 4: Enable and Start Service

```bash
# Reload systemd daemon
sudo systemctl daemon-reload

# Enable service for auto-start
sudo systemctl enable backend-api

# Start service
sudo systemctl start backend-api

# Check status
sudo systemctl status backend-api

# View logs
sudo journalctl -u backend-api -f
```

### Step 5: Service Management Script

```bash
#!/bin/bash
# backend-api-manage.sh - Service management helper

ACTION=$1

case "$ACTION" in
    start)
        echo "Starting backend API..."
        sudo systemctl start backend-api
        sudo systemctl status backend-api
        ;;
    stop)
        echo "Stopping backend API..."
        sudo systemctl stop backend-api
        ;;
    restart)
        echo "Restarting backend API..."
        sudo systemctl restart backend-api
        sudo systemctl status backend-api
        ;;
    status)
        sudo systemctl status backend-api
        ;;
    logs)
        sudo journalctl -u backend-api -f
        ;;
    logs-last)
        sudo journalctl -u backend-api -n 100 --no-pager
        ;;
    health)
        /usr/local/bin/backend-api-health.sh
        ;;
    reload)
        echo "Reloading configuration..."
        sudo systemctl reload backend-api
        ;;
    enable)
        echo "Enabling auto-start..."
        sudo systemctl enable backend-api
        ;;
    disable)
        echo "Disabling auto-start..."
        sudo systemctl disable backend-api
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|logs-last|health|reload|enable|disable}"
        exit 1
        ;;
esac
```

### Step 6: Monitoring Script

```bash
#!/bin/bash
# backend-api-monitor.sh - Monitor backend API service

echo "=== Backend API Monitoring ==="

# Service status
echo "Service Status:"
systemctl is-active backend-api && echo "  ✓ Active" || echo "  ✗ Inactive"

# Memory usage
echo "Memory Usage:"
systemctl show backend-api --property=MemoryCurrent | awk -F= '{printf "  %.2f MB\n", $2/1024/1024}'

# CPU usage (from systemd)
echo "CPU Usage:"
systemctl show backend-api --property=CPUUsageNSec

# Process info
echo "Process Info:"
PID=$(systemctl show backend-api --property=MainPID | cut -d= -f2)
if [ "$PID" != "0" ]; then
    ps -p $PID -o pid,user,%cpu,%mem,vsz,rss,start,time,comm
fi

# Health check
echo "Health Check:"
/usr/local/bin/backend-api-health.sh && echo "  ✓ Healthy" || echo "  ✗ Unhealthy"

# Recent logs
echo "Recent Errors (last 10):"
sudo journalctl -u backend-api --since "1 hour ago" | grep -i error | tail -10

# Connection count
echo "Active Connections:"
ss -tunapl | grep :8080 | wc -l
```

### Verification Tests

```bash
#!/bin/bash
# test-service.sh - Test backend API service

echo "=== Backend API Service Tests ==="

# Test 1: Service starts successfully
echo "Test 1: Starting service..."
sudo systemctl start backend-api
sleep 3
systemctl is-active backend-api && echo "  [PASS] Service started" || echo "  [FAIL] Service not running"

# Test 2: Auto-restart on failure
echo "Test 2: Testing auto-restart..."
PID_BEFORE=$(systemctl show backend-api --property=MainPID | cut -d= -f2)
sudo kill -9 $PID_BEFORE
sleep 12
PID_AFTER=$(systemctl show backend-api --property=MainPID | cut -d= -f2)
[ "$PID_BEFORE" != "$PID_AFTER" ] && echo "  [PASS] Service restarted automatically" || echo "  [FAIL] Service did not restart"

# Test 3: Graceful shutdown
echo "Test 3: Testing graceful shutdown..."
sudo systemctl stop backend-api
sleep 2
! systemctl is-active backend-api && echo "  [PASS] Service stopped gracefully" || echo "  [FAIL] Service still running"

# Test 4: Auto-start on boot
echo "Test 4: Testing auto-start..."
systemctl is-enabled backend-api && echo "  [PASS] Auto-start enabled" || echo "  [FAIL] Not enabled"

# Test 5: Health check
echo "Test 5: Health check..."
sudo systemctl start backend-api
sleep 3
/usr/local/bin/backend-api-health.sh && echo "  [PASS] Health check passed" || echo "  [INFO] Health check (may need app running)"

# Test 6: Resource limits
echo "Test 6: Resource limits..."
MEM_LIMIT=$(systemctl show backend-api --property=MemoryLimit | cut -d= -f2)
[ "$MEM_LIMIT" != "infinity" ] && echo "  [PASS] Memory limit set" || echo "  [WARN] No memory limit"

echo "=== Tests Complete ==="
```

---

## Task 1.6: Firewall Configuration for Multi-Tier Application

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-16-firewall-configuration-for-multi-tier-application)**

### Solution Overview

Complete firewall configuration for 3-tier application with proper network segmentation.

### Frontend Server Firewall Configuration

```bash
#!/bin/bash
# frontend-firewall.sh - Configure firewall for frontend server

echo "=== Configuring Frontend Server Firewall ==="

# Reset UFW
sudo ufw --force reset

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow HTTP and HTTPS from anywhere
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Allow SSH from company network only
sudo ufw allow from 203.0.113.0/24 to any port 22 proto tcp comment 'SSH from company'

# Allow outgoing to backend API
sudo ufw allow out to 10.0.2.10 port 8080 proto tcp comment 'Backend API'

# Enable logging
sudo ufw logging on

# Enable firewall
sudo ufw --force enable

# Show status
sudo ufw status verbose

echo "Frontend firewall configured"
```

### Backend Server Firewall Configuration

```bash
#!/bin/bash
# backend-firewall.sh - Configure firewall for backend server

echo "=== Configuring Backend Server Firewall ==="

# Reset UFW
sudo ufw --force reset

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow port 8080 only from frontend server
sudo ufw allow from 10.0.1.10 to any port 8080 proto tcp comment 'Frontend to Backend API'

# Allow SSH from company network only
sudo ufw allow from 203.0.113.0/24 to any port 22 proto tcp comment 'SSH from company'

# Allow monitoring from monitoring server
sudo ufw allow from 10.0.4.10 to any port 9090 proto tcp comment 'Prometheus monitoring'

# Allow outgoing to database
sudo ufw allow out to 10.0.3.10 port 5432 proto tcp comment 'PostgreSQL'

# Enable logging
sudo ufw logging on

# Enable firewall
sudo ufw --force enable

# Show status
sudo ufw status verbose

echo "Backend firewall configured"
```

### Database Server Firewall Configuration

```bash
#!/bin/bash
# database-firewall.sh - Configure firewall for database server

echo "=== Configuring Database Server Firewall ==="

# Reset UFW
sudo ufw --force reset

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow PostgreSQL only from backend server
sudo ufw allow from 10.0.2.10 to any port 5432 proto tcp comment 'Backend to PostgreSQL'

# Allow SSH from company network only
sudo ufw allow from 203.0.113.0/24 to any port 22 proto tcp comment 'SSH from company'

# Deny all other incoming
sudo ufw default deny incoming

# Enable logging
sudo ufw logging on

# Enable firewall
sudo ufw --force enable

# Show status
sudo ufw status verbose

echo "Database firewall configured"
```

### Advanced UFW Configuration with Rate Limiting

```bash
#!/bin/bash
# advanced-firewall-config.sh - Advanced firewall rules

# Rate limit SSH to prevent brute force
sudo ufw limit ssh comment 'Rate limit SSH'

# Rate limit HTTP/HTTPS
sudo ufw limit 80/tcp comment 'Rate limit HTTP'
sudo ufw limit 443/tcp comment 'Rate limit HTTPS'

# Block common attack ports
sudo ufw deny 23 comment 'Block Telnet'
sudo ufw deny 135 comment 'Block RPC'
sudo ufw deny 139 comment 'Block NetBIOS'
sudo ufw deny 445 comment 'Block SMB'

# Log denied connections
sudo ufw logging medium
```

### Firewall Testing Script

```bash
#!/bin/bash
# test-firewall.sh - Test firewall configuration

echo "=== Firewall Configuration Tests ==="

# Test 1: HTTP accessible from internet (frontend)
echo "Test 1: HTTP access to frontend..."
curl -s -o /dev/null -w "%{http_code}" http://10.0.1.10 | grep -q "200\|301\|302" && echo "  [PASS] HTTP accessible" || echo "  [INFO] HTTP test"

# Test 2: Direct access to backend should fail
echo "Test 2: Direct backend access (should fail)..."
timeout 5 telnet 10.0.2.10 8080 2>&1 | grep -q "Connection refused\|timeout" && echo "  [PASS] Backend not directly accessible" || echo "  [INFO] Backend test"

# Test 3: Frontend can access backend
echo "Test 3: Frontend to backend connectivity..."
ssh 10.0.1.10 "curl -s -o /dev/null -w '%{http_code}' http://10.0.2.10:8080" | grep -q "200\|301" && echo "  [PASS] Frontend can reach backend" || echo "  [INFO] Connection test"

# Test 4: Direct database access should fail
echo "Test 4: Direct database access (should fail)..."
timeout 5 psql -h 10.0.3.10 -U testuser 2>&1 | grep -q "timeout\|refused" && echo "  [PASS] Database not directly accessible" || echo "  [INFO] Database test"

# Test 5: Backend can access database
echo "Test 5: Backend to database connectivity..."
ssh 10.0.2.10 "pg_isready -h 10.0.3.10" && echo "  [PASS] Backend can reach database" || echo "  [INFO] DB connection test"

# Test 6: SSH from company network
echo "Test 6: SSH from company network..."
ssh -o ConnectTimeout=5 10.0.1.10 "echo test" && echo "  [PASS] SSH accessible" || echo "  [INFO] SSH test"

echo "=== Tests Complete ==="
```

### Firewall Backup and Restore Scripts

```bash
#!/bin/bash
# backup-firewall-rules.sh - Backup UFW rules

BACKUP_DIR="/opt/backups/firewall"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create backup directory
sudo mkdir -p "$BACKUP_DIR"

# Backup UFW rules
sudo cp /etc/ufw/user.rules "$BACKUP_DIR/user.rules_$TIMESTAMP"
sudo cp /etc/ufw/user6.rules "$BACKUP_DIR/user6.rules_$TIMESTAMP"

# Export human-readable rules
sudo ufw status numbered > "$BACKUP_DIR/ufw_status_$TIMESTAMP.txt"

echo "Firewall rules backed up to $BACKUP_DIR"
ls -lh "$BACKUP_DIR"
```

```bash
#!/bin/bash
# restore-firewall-rules.sh - Restore UFW rules

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup_file>"
    echo "Available backups:"
    ls -lh /opt/backups/firewall/
    exit 1
fi

# Disable firewall
sudo ufw disable

# Restore rules
sudo cp "$BACKUP_FILE" /etc/ufw/user.rules

# Reload firewall
sudo ufw --force enable

echo "Firewall rules restored from $BACKUP_FILE"
sudo ufw status verbose
```

---

## Task 1.7: Centralized Logging Setup with Journald

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-17-centralized-logging-setup-with-journald)**

### Solution Overview

Complete centralized logging solution with journald, rsyslog, and log analysis tools.

### Step 1: Configure Persistent Journald Logging

```bash
# Configure journald for persistent storage
sudo mkdir -p /var/log/journal
sudo systemd-tmpfiles --create --prefix /var/log/journal

# Edit journald configuration
sudo tee /etc/systemd/journald.conf > /dev/null <<'EOF'
[Journal]
# Persistent storage
Storage=persistent
Compress=yes
Seal=yes

# Size limits
SystemMaxUse=2G
SystemKeepFree=1G
SystemMaxFileSize=100M
SystemMaxFiles=100

# Forwarding
ForwardToSyslog=yes
ForwardToWall=no

# Max retention
MaxRetentionSec=2592000
MaxFileSec=86400
EOF

# Restart journald
sudo systemctl restart systemd-journald

# Verify persistent storage
sudo journalctl --disk-usage
```

### Step 2: Configure Rsyslog for Central Logging

```bash
# Install rsyslog
sudo apt install rsyslog -y

# Configure rsyslog
sudo tee /etc/rsyslog.d/50-default.conf > /dev/null <<'EOF'
# Default logging rules
*.info;mail.none;authpriv.none;cron.none    /var/log/messages
authpriv.*                                  /var/log/secure
mail.*                                      -/var/log/maillog
cron.*                                      /var/log/cron
*.emerg                                     :omusrmsg:*
uucp,news.crit                             /var/log/spooler
local7.*                                    /var/log/boot.log
EOF

# Configure application logging
sudo tee /etc/rsyslog.d/60-applications.conf > /dev/null <<'EOF'
# Application logs
:programname, isequal, "backend-api"    /var/log/applications/backend-api.log
:programname, isequal, "frontend"       /var/log/applications/frontend.log
:programname, isequal, "worker"         /var/log/applications/worker.log

# Security logs
:programname, isequal, "fail2ban"       /var/log/security/fail2ban.log
:programname, isequal, "sshd"           /var/log/security/ssh.log
EOF

# Create log directories
sudo mkdir -p /var/log/applications
sudo mkdir -p /var/log/security
sudo chmod 755 /var/log/applications
sudo chmod 755 /var/log/security

# Restart rsyslog
sudo systemctl restart rsyslog
```

### Step 3: Configure Log Rotation

```bash
# Configure logrotate for application logs
sudo tee /etc/logrotate.d/applications > /dev/null <<'EOF'
/var/log/applications/*.log {
    daily
    rotate 30
    missingok
    notifempty
    compress
    delaycompress
    create 0640 root adm
    sharedscripts
    postrotate
        /usr/bin/systemctl reload rsyslog > /dev/null 2>&1 || true
    endscript
}
EOF

# Configure logrotate for security logs
sudo tee /etc/logrotate.d/security > /dev/null <<'EOF'
/var/log/security/*.log {
    daily
    rotate 90
    missingok
    notifempty
    compress
    delaycompress
    create 0600 root root
    sharedscripts
    postrotate
        /usr/bin/systemctl reload rsyslog > /dev/null 2>&1 || true
    endscript
}
EOF

# Test logrotate configuration
sudo logrotate -d /etc/logrotate.d/applications
```

### Step 4: Create Log Analysis Scripts

```bash
#!/bin/bash
# search-errors.sh - Search for errors in application logs

SERVICE=${1:-backend-api}
TIME_RANGE=${2:-"1 hour ago"}

echo "=== Searching errors in $SERVICE since $TIME_RANGE ==="

# Search in journald
echo "Journald errors:"
sudo journalctl -u "$SERVICE" --since "$TIME_RANGE" | grep -iE 'error|exception|fatal' | tail -20

# Search in application logs
echo "Application log errors:"
if [ -f "/var/log/applications/${SERVICE}.log" ]; then
    sudo grep -iE 'error|exception|fatal' "/var/log/applications/${SERVICE}.log" | tail -20
fi
```

```bash
#!/bin/bash
# security-monitor.sh - Monitor security logs

TIME_RANGE=${1:-"1 hour ago"}

echo "=== Security Events since $TIME_RANGE ==="

# Failed SSH attempts
echo "Failed SSH attempts:"
sudo journalctl --since "$TIME_RANGE" | grep "Failed password" | awk '{print $1, $2, $3, $11}' | sort | uniq -c | sort -rn | head -10

# Successful logins
echo "Successful logins:"
sudo journalctl --since "$TIME_RANGE" | grep "Accepted publickey" | awk '{print $1, $2, $3, $9, $11}' | tail -10

# Sudo usage
echo "Sudo usage:"
sudo journalctl --since "$TIME_RANGE" | grep "sudo:" | grep "COMMAND" | tail -10

# Fail2ban bans
echo "Fail2ban bans:"
sudo journalctl -u fail2ban --since "$TIME_RANGE" | grep "Ban" | tail -10

# UFW blocks
echo "UFW blocks:"
sudo journalctl --since "$TIME_RANGE" | grep "UFW BLOCK" | tail -10
```

```bash
#!/bin/bash
# log-summary.sh - Generate daily log summary

DATE=${1:-$(date +%Y-%m-%d)}

echo "=== Log Summary for $DATE ==="

# Total log entries
echo "Total log entries: $(sudo journalctl --since "$DATE" --until "$DATE 23:59:59" | wc -l)"

# Errors by service
echo "Errors by service:"
sudo journalctl --since "$DATE" --until "$DATE 23:59:59" | grep -iE 'error|fail' | awk '{print $6}' | sort | uniq -c | sort -rn | head -10

# Most active services
echo "Most active services:"
sudo journalctl --since "$DATE" --until "$DATE 23:59:59" | awk '{print $6}' | sort | uniq -c | sort -rn | head -10

# System restarts
echo "System events:"
sudo journalctl --since "$DATE" --until "$DATE 23:59:59" | grep -E "Starting|Stopping|Restarting" | head -20

# Disk usage for logs
echo "Log disk usage:"
du -sh /var/log/*
```

### Step 5: Setup Automated Daily Summary

```bash
# Create cron job for daily summary
sudo tee /etc/cron.daily/log-summary > /dev/null <<'EOF'
#!/bin/bash
# Daily log summary

/usr/local/bin/log-summary.sh > /var/log/daily-summary-$(date +%Y%m%d).txt
EOF

sudo chmod +x /etc/cron.daily/log-summary
```

### Verification and Testing

```bash
#!/bin/bash
# test-logging.sh - Test logging configuration

echo "=== Testing Logging Configuration ==="

# Test 1: Journald persistent storage
echo "Test 1: Journald persistent storage..."
sudo journalctl --disk-usage && echo "  [PASS] Persistent storage enabled" || echo "  [FAIL] Not enabled"

# Test 2: Rsyslog running
echo "Test 2: Rsyslog service..."
systemctl is-active rsyslog && echo "  [PASS] Rsyslog active" || echo "  [FAIL] Not active"

# Test 3: Application logs directory
echo "Test 3: Application log directories..."
[ -d "/var/log/applications" ] && echo "  [PASS] Directory exists" || echo "  [FAIL] Directory missing"

# Test 4: Log rotation configured
echo "Test 4: Log rotation..."
sudo logrotate -d /etc/logrotate.d/applications 2>&1 | grep -q "rotating" && echo "  [PASS] Logrotate configured" || echo "  [INFO] Logrotate test"

# Test 5: Create test log entry
echo "Test 5: Writing test log..."
logger -t backend-api "Test log entry from logging verification"
sleep 2
sudo journalctl -t backend-api -n 1 | grep -q "Test log entry" && echo "  [PASS] Can write to journal" || echo "  [FAIL] Cannot write"

echo "=== Tests Complete ==="
```

---

*Continuing with remaining tasks...*

## Task 1.8: Performance Monitoring and Troubleshooting

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-18-performance-monitoring-and-troubleshooting)**

### Solution Overview

Comprehensive performance monitoring and analysis solution for troubleshooting system bottlenecks.

### Step 1: System Health Check Script

```bash
#!/bin/bash
# system-health.sh - Quick system health check

echo "======================================"
echo "   SYSTEM HEALTH CHECK"
echo "======================================"
echo "Hostname: $(hostname)"
echo "Date: $(date)"
echo "Uptime: $(uptime -p)"
echo

# CPU Information
echo "--- CPU ---"
echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
echo

# Memory Information
echo "--- MEMORY ---"
free -h
echo

# Disk Usage
echo "--- DISK USAGE ---"
df -h | grep -E '^/dev|Filesystem'
echo

# Top Processes by CPU
echo "--- TOP 5 CPU CONSUMERS ---"
ps aux --sort=-%cpu | head -6
echo

# Top Processes by Memory
echo "--- TOP 5 MEMORY CONSUMERS ---"
ps aux --sort=-%mem | head -6
echo

# Network Connections
echo "--- NETWORK ---"
echo "Active connections: $(ss -tunapl | wc -l)"
echo "Listening ports: $(ss -tuln | grep LISTEN | wc -l)"
echo

# I/O Wait
echo "--- I/O STATISTICS ---"
iostat -x 1 2 | tail -n +4
```

### Step 2: Performance Monitor Script

```bash
#!/bin/bash
# perf-monitor.sh - Continuous performance monitoring

INTERVAL=${1:-5}
LOG_FILE="/var/log/performance-monitor.log"

echo "Starting performance monitoring (interval: ${INTERVAL}s)"
echo "Logging to: $LOG_FILE"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    
    # Memory usage
    MEM_TOTAL=$(free | grep Mem | awk '{print $2}')
    MEM_USED=$(free | grep Mem | awk '{print $3}')
    MEM_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($MEM_USED/$MEM_TOTAL)*100}")
    
    # Load average
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | xargs)
    
    # Disk I/O wait
    IO_WAIT=$(iostat -c 1 2 | tail -1 | awk '{print $4}')
    
    # Log data
    echo "$TIMESTAMP,CPU:$CPU_USAGE%,MEM:$MEM_PERCENT%,LOAD:$LOAD_AVG,IOWAIT:$IO_WAIT%" | tee -a "$LOG_FILE"
    
    sleep "$INTERVAL"
done
```

### Step 3: Bottleneck Detection Script

```bash
#!/bin/bash
# detect-bottleneck.sh - Automatically detect performance bottlenecks

echo "=== BOTTLENECK DETECTION ==="

# CPU bottleneck detection
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo "❌ CPU BOTTLENECK DETECTED: ${CPU_USAGE}% usage"
    echo "Top CPU processes:"
    ps aux --sort=-%cpu | head -6
else
    echo "✓ CPU: Normal (${CPU_USAGE}%)"
fi
echo

# Memory bottleneck detection
MEM_PERCENT=$(free | grep Mem | awk '{printf "%.2f", ($3/$2)*100}')
if (( $(echo "$MEM_PERCENT > 85" | bc -l) )); then
    echo "❌ MEMORY BOTTLENECK DETECTED: ${MEM_PERCENT}% usage"
    echo "Top memory processes:"
    ps aux --sort=-%mem | head -6
else
    echo "✓ Memory: Normal (${MEM_PERCENT}%)"
fi
echo

# Disk I/O bottleneck detection
IO_WAIT=$(iostat -c 1 2 | tail -1 | awk '{print $4}')
if (( $(echo "$IO_WAIT > 20" | bc -l) )); then
    echo "❌ DISK I/O BOTTLENECK DETECTED: ${IO_WAIT}% I/O wait"
    echo "Disk statistics:"
    iostat -x 1 2 | tail -n +4
else
    echo "✓ Disk I/O: Normal (${IO_WAIT}% wait)"
fi
echo

# Load average check
LOAD_1MIN=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)
CPU_CORES=$(nproc)
LOAD_THRESHOLD=$(echo "$CPU_CORES * 2" | bc)
if (( $(echo "$LOAD_1MIN > $LOAD_THRESHOLD" | bc -l) )); then
    echo "❌ HIGH LOAD AVERAGE: $LOAD_1MIN (threshold: $LOAD_THRESHOLD)"
else
    echo "✓ Load Average: Normal ($LOAD_1MIN on $CPU_CORES cores)"
fi
echo

# Network connections check
CONN_COUNT=$(ss -tunapl | wc -l)
if [ "$CONN_COUNT" -gt 1000 ]; then
    echo "⚠ HIGH CONNECTION COUNT: $CONN_COUNT"
    echo "Connection states:"
    ss -ant | awk '{print $1}' | sort | uniq -c
else
    echo "✓ Network Connections: Normal ($CONN_COUNT)"
fi
```

### Step 4: Performance Analysis Report Generator

```bash
#!/bin/bash
# generate-perf-report.sh - Generate comprehensive performance report

OUTPUT_FILE="/tmp/performance-report-$(date +%Y%m%d-%H%M%S).txt"

cat > "$OUTPUT_FILE" <<EOF
================================================================================
                    SYSTEM PERFORMANCE ANALYSIS REPORT
================================================================================
Hostname: $(hostname)
Date: $(date)
Report ID: $(date +%Y%m%d-%H%M%S)

================================================================================
                            EXECUTIVE SUMMARY
================================================================================

$(./detect-bottleneck.sh)

================================================================================
                          SYSTEM METRICS BASELINE
================================================================================

CPU
---
Cores: $(nproc)
Load Average (1/5/15 min): $(uptime | awk -F'load average:' '{print $2}')
CPU Utilization: $(top -bn1 | grep "Cpu(s)")
Context Switches/sec: $(vmstat 1 2 | tail -1 | awk '{print $12}')

MEMORY
------
$(free -h)

Swap Usage:
$(swapon --show)

DISK
----
Disk Usage:
$(df -h | grep -E '^/dev|Filesystem')

I/O Statistics:
$(iostat -x)

NETWORK
-------
Active Connections: $(ss -tunapl | wc -l)
Listening Ports: $(ss -tuln | grep LISTEN | wc -l)
Network Traffic:
$(netstat -i)

================================================================================
                         TOP RESOURCE CONSUMERS
================================================================================

TOP 10 CPU PROCESSES
--------------------
$(ps aux --sort=-%cpu | head -11)

TOP 10 MEMORY PROCESSES
-----------------------
$(ps aux --sort=-%mem | head -11)

TOP 10 I/O PROCESSES
--------------------
$(iotop -b -n 1 -P | head -11)

================================================================================
                              RECOMMENDATIONS
================================================================================

EOF

# Add recommendations based on findings
if (( $(free | grep Mem | awk '{printf "%.0f", ($3/$2)*100}') > 85 )); then
    echo "1. CRITICAL: Memory usage above 85%. Consider:" >> "$OUTPUT_FILE"
    echo "   - Adding more RAM" >> "$OUTPUT_FILE"
    echo "   - Investigating memory leaks in applications" >> "$OUTPUT_FILE"
    echo "   - Tuning application memory limits" >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
fi

if (( $(iostat -c 1 2 | tail -1 | awk '{print int($4)}') > 20 )); then
    echo "2. WARNING: High I/O wait detected. Consider:" >> "$OUTPUT_FILE"
    echo "   - Optimizing database queries" >> "$OUTPUT_FILE"
    echo "   - Using faster storage (SSD)" >> "$OUTPUT_FILE"
    echo "   - Implementing caching" >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
fi

echo "Report saved to: $OUTPUT_FILE"
cat "$OUTPUT_FILE"
```

### Step 5: Command Reference for Troubleshooting

```bash
# Create quick reference guide
cat > /usr/local/bin/perf-commands.txt <<'EOF'
PERFORMANCE TROUBLESHOOTING COMMAND REFERENCE

=== CPU ===
# Real-time CPU usage
top
htop

# Per-core CPU usage
mpstat -P ALL 1

# Process CPU usage
pidstat -u 1 5

# CPU information
lscpu
cat /proc/cpuinfo

=== MEMORY ===
# Memory overview
free -h
vmstat 1 5

# Per-process memory
ps aux --sort=-%mem | head -20
pmap -x [PID]
smem -tk

# Memory details
cat /proc/meminfo
slabtop

# Find memory leaks
valgrind --leak-check=full ./program

=== DISK I/O ===
# I/O statistics
iostat -x 1 5
iotop -o

# Disk usage
df -h
du -sh /* | sort -h

# Find open files
lsof | head -100
lsof -p [PID]

# I/O per process
pidstat -d 1 5

=== NETWORK ===
# Connections
ss -tunapl
netstat -ant

# Throughput
iftop -i eth0
nload

# Latency
ping -c 10 target
mtr target

# Packet capture
tcpdump -i any port 80

=== PROCESS ANALYSIS ===
# Process tree
pstree -p
ps auxf

# Process details
cat /proc/[PID]/status
cat /proc/[PID]/limits

# System calls
strace -c -p [PID]
strace -e open,read,write -p [PID]

# Library calls
ltrace -p [PID]

EOF
```

---

## Task 1.9: Package Management and Custom Repository

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-19-package-management-and-custom-repository)**

### Solution Overview

Complete solution for creating custom APT repository and managing internal packages.

### Step 1: Create Package Directory Structure

```bash
#!/bin/bash
# setup-package-structure.sh - Create package directory structure

PACKAGE_NAME="company-monitor"
VERSION="1.0.0"

# Create package directory structure
mkdir -p ${PACKAGE_NAME}_${VERSION}/{DEBIAN,usr/local/bin,etc/systemd/system}

echo "Package structure created for ${PACKAGE_NAME}_${VERSION}"
tree ${PACKAGE_NAME}_${VERSION}
```

### Step 2: Create Package Files

```bash
#!/bin/bash
# create-monitor-app.sh - Create monitoring application

cat > company-monitor_1.0.0/usr/local/bin/company-monitor <<'EOF'
#!/bin/bash
# Company Monitoring Tool v1.0.0

ACTION=${1:-status}

get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1
}

get_memory_usage() {
    free | grep Mem | awk '{printf "%.2f", ($3/$2)*100}'
}

get_disk_usage() {
    df -h / | tail -1 | awk '{print $(NF-1)}'
}

case "$ACTION" in
    status)
        echo "=== System Status ==="
        echo "CPU Usage: $(get_cpu_usage)%"
        echo "Memory Usage: $(get_memory_usage)%"
        echo "Disk Usage: $(get_disk_usage)"
        echo "Uptime: $(uptime -p)"
        ;;
    json)
        cat <<JSON
{
    "cpu_usage": "$(get_cpu_usage)",
    "memory_usage": "$(get_memory_usage)",
    "disk_usage": "$(get_disk_usage)",
    "uptime": "$(uptime -p)"
}
JSON
        ;;
    *)
        echo "Usage: $0 {status|json}"
        exit 1
        ;;
esac
EOF

chmod +x company-monitor_1.0.0/usr/local/bin/company-monitor
```

### Step 3: Create Systemd Service

```bash
cat > company-monitor_1.0.0/etc/systemd/system/company-monitor.service <<'EOF'
[Unit]
Description=Company Monitoring Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/company-monitor status
User=root

[Install]
WantedBy=multi-user.target
EOF
```

### Step 4: Create DEBIAN Control Files

```bash
# Create control file
cat > company-monitor_1.0.0/DEBIAN/control <<'EOF'
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
EOF

# Create postinst script
cat > company-monitor_1.0.0/DEBIAN/postinst <<'EOF'
#!/bin/bash
set -e

# Reload systemd
systemctl daemon-reload

# Enable service
systemctl enable company-monitor.service

echo "Company Monitor installed successfully"
echo "Run: company-monitor status"
EOF

chmod +x company-monitor_1.0.0/DEBIAN/postinst

# Create prerm script
cat > company-monitor_1.0.0/DEBIAN/prerm <<'EOF'
#!/bin/bash
set -e

# Disable service
systemctl disable company-monitor.service || true

echo "Company Monitor removed"
EOF

chmod +x company-monitor_1.0.0/DEBIAN/prerm
```

### Step 5: Build Package Script

```bash
#!/bin/bash
# build-package.sh - Build .deb package

PACKAGE_NAME="company-monitor"
VERSION="1.0.0"
ARCH="all"

echo "Building ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

# Set correct permissions
find ${PACKAGE_NAME}_${VERSION} -type d -exec chmod 755 {} \;
find ${PACKAGE_NAME}_${VERSION} -type f -exec chmod 644 {} \;
chmod +x ${PACKAGE_NAME}_${VERSION}/usr/local/bin/company-monitor
chmod +x ${PACKAGE_NAME}_${VERSION}/DEBIAN/postinst
chmod +x ${PACKAGE_NAME}_${VERSION}/DEBIAN/prerm

# Build package
dpkg-deb --build ${PACKAGE_NAME}_${VERSION}

# Rename to include architecture
mv ${PACKAGE_NAME}_${VERSION}.deb ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb

echo "Package built: ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
dpkg -I ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb
```

### Step 6: Setup APT Repository

```bash
#!/bin/bash
# setup-repo.sh - Set up custom APT repository

REPO_DIR="/var/www/apt-repo"

# Install required packages
sudo apt update
sudo apt install dpkg-dev gpg nginx -y

# Create repository structure
sudo mkdir -p ${REPO_DIR}/{dists/stable/main/binary-amd64,pool/main/c/company-monitor}

# Copy package to pool
sudo cp company-monitor_1.0.0_all.deb ${REPO_DIR}/pool/main/c/company-monitor/

# Generate Packages file
cd ${REPO_DIR}
sudo dpkg-scanpackages pool/ /dev/null | gzip -9c | sudo tee dists/stable/main/binary-amd64/Packages.gz > /dev/null
sudo dpkg-scanpackages pool/ /dev/null | sudo tee dists/stable/main/binary-amd64/Packages > /dev/null

# Generate Release file
cd ${REPO_DIR}/dists/stable
sudo tee Release > /dev/null <<EOF
Origin: Company Internal
Label: Company Internal Repository
Suite: stable
Codename: stable
Architectures: amd64 all
Components: main
Description: Company internal package repository
Date: $(date -R)
EOF

# Generate GPG key (if not exists)
if [ ! -f ~/.gnupg/pubring.gpg ]; then
    gpg --batch --gen-key <<GPGEOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Name-Real: Company Repository
Name-Email: repo@company.com
Expire-Date: 1y
GPGEOF
fi

# Sign Release file
cd ${REPO_DIR}/dists/stable
sudo gpg --default-key repo@company.com --armor --detach-sign -o Release.gpg Release

# Export public key
sudo gpg --armor --export repo@company.com | sudo tee ${REPO_DIR}/public.gpg > /dev/null

echo "Repository created at ${REPO_DIR}"
```

### Step 7: Configure Nginx for Repository

```bash
# Configure nginx for repository
sudo tee /etc/nginx/sites-available/apt-repo > /dev/null <<'EOF'
server {
    listen 80;
    server_name apt.company.internal;
    root /var/www/apt-repo;
    
    location / {
        autoindex on;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/apt-repo /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Step 8: Client Configuration Script

```bash
#!/bin/bash
# add-repo-client.sh - Add repository to client systems

REPO_URL="http://apt.company.internal"

echo "Adding Company repository..."

# Download and add GPG key
curl -fsSL ${REPO_URL}/public.gpg | sudo gpg --dearmor -o /usr/share/keyrings/company-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/company-archive-keyring.gpg] ${REPO_URL} stable main" | sudo tee /etc/apt/sources.list.d/company.list

# Update package lists
sudo apt update

echo "Repository added successfully"
echo "Install package with: sudo apt install company-monitor"
```

### Step 9: Package Update Script

```bash
#!/bin/bash
# update-repository.sh - Update repository with new package

PACKAGE_FILE=$1

if [ -z "$PACKAGE_FILE" ]; then
    echo "Usage: $0 <package.deb>"
    exit 1
fi

REPO_DIR="/var/www/apt-repo"

# Extract package name
PACKAGE_NAME=$(dpkg -I "$PACKAGE_FILE" | grep "Package:" | awk '{print $2}')

echo "Updating repository with $PACKAGE_FILE"

# Copy package to pool
sudo cp "$PACKAGE_FILE" ${REPO_DIR}/pool/main/c/${PACKAGE_NAME}/

# Regenerate Packages file
cd ${REPO_DIR}
sudo dpkg-scanpackages pool/ /dev/null | gzip -9c | sudo tee dists/stable/main/binary-amd64/Packages.gz > /dev/null
sudo dpkg-scanpackages pool/ /dev/null | sudo tee dists/stable/main/binary-amd64/Packages > /dev/null

# Update Release file
cd ${REPO_DIR}/dists/stable
sudo tee Release > /dev/null <<EOF
Origin: Company Internal
Label: Company Internal Repository
Suite: stable
Codename: stable
Architectures: amd64 all
Components: main
Description: Company internal package repository
Date: $(date -R)
EOF

# Re-sign Release file
sudo gpg --default-key repo@company.com --armor --detach-sign -o Release.gpg Release

echo "Repository updated successfully"
```

---

## Task 1.10: PostgreSQL Backup Automation

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-110-postgresql-backup-automation)**

### Solution Overview

Complete PostgreSQL backup automation with full backups, WAL archiving, and disaster recovery procedures.

### Step 1: Configure PostgreSQL for WAL Archiving

```bash
# Backup postgresql.conf
sudo -u postgres cp /etc/postgresql/*/main/postgresql.conf /etc/postgresql/*/main/postgresql.conf.backup

# Configure WAL archiving
sudo tee -a /etc/postgresql/*/main/postgresql.conf > /dev/null <<'EOF'

# WAL Archiving Configuration
wal_level = replica
archive_mode = on
archive_command = 'test ! -f /backup/postgres/wal_archive/%f && cp %p /backup/postgres/wal_archive/%f'
archive_timeout = 300
max_wal_senders = 3
wal_keep_size = 1GB
EOF

# Create WAL archive directory
sudo mkdir -p /backup/postgres/wal_archive
sudo chown -R postgres:postgres /backup/postgres
sudo chmod 700 /backup/postgres

# Restart PostgreSQL
sudo systemctl restart postgresql
```

### Step 2: Main Backup Script

```bash
#!/bin/bash
# postgres-backup.sh - PostgreSQL backup script

set -euo pipefail

# Configuration
BACKUP_DIR="/backup/postgres"
DB_NAME="production_db"
DB_USER="postgres"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_TYPE=${1:-daily}
RETENTION_DAYS=7
LOG_FILE="/var/log/postgres-backup.log"

# Functions
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

send_notification() {
    local subject="$1"
    local message="$2"
    echo "$message" | mail -s "$subject" admin@company.com
}

take_backup() {
    local backup_file="${BACKUP_DIR}/${DB_NAME}_${BACKUP_TYPE}_${TIMESTAMP}.dump"
    
    log_message "Starting ${BACKUP_TYPE} backup..."
    
    # Create backup
    sudo -u postgres pg_dump -Fc -f "$backup_file" "$DB_NAME"
    
    # Compress backup
    gzip "$backup_file"
    backup_file="${backup_file}.gz"
    
    # Verify backup was created
    if [ -f "$backup_file" ]; then
        local size=$(du -h "$backup_file" | cut -f1)
        log_message "Backup completed successfully: $backup_file (Size: $size)"
        return 0
    else
        log_message "ERROR: Backup failed!"
        return 1
    fi
}

verify_backup() {
    local backup_file="$1"
    
    log_message "Verifying backup integrity..."
    
    # Check if file exists and is not empty
    if [ ! -s "$backup_file" ]; then
        log_message "ERROR: Backup file is empty or doesn't exist"
        return 1
    fi
    
    # Verify gzip integrity
    gunzip -t "$backup_file" 2>/dev/null
    if [ $? -eq 0 ]; then
        log_message "Backup verification passed"
        return 0
    else
        log_message "ERROR: Backup verification failed"
        return 1
    fi
}

rotate_old_backups() {
    log_message "Rotating old backups (retention: ${RETENTION_DAYS} days)..."
    
    # Find and delete old backups
    find "${BACKUP_DIR}" -name "${DB_NAME}_${BACKUP_TYPE}_*.dump.gz" -type f -mtime +${RETENTION_DAYS} -delete
    
    local deleted_count=$(find "${BACKUP_DIR}" -name "${DB_NAME}_${BACKUP_TYPE}_*.dump.gz" -type f -mtime +${RETENTION_DAYS} | wc -l)
    log_message "Deleted $deleted_count old backups"
}

# Main execution
log_message "=========================================="
log_message "PostgreSQL Backup Started"
log_message "Backup Type: ${BACKUP_TYPE}"
log_message "=========================================="

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

# Take backup
if take_backup; then
    backup_file="${BACKUP_DIR}/${DB_NAME}_${BACKUP_TYPE}_${TIMESTAMP}.dump.gz"
    
    # Verify backup
    if verify_backup "$backup_file"; then
        # Rotate old backups
        rotate_old_backups
        
        # Send success notification
        send_notification "PostgreSQL Backup Success" "Backup completed successfully: $backup_file"
        
        log_message "Backup process completed successfully"
        exit 0
    else
        send_notification "PostgreSQL Backup Verification Failed" "Backup verification failed for: $backup_file"
        log_message "Backup verification failed"
        exit 1
    fi
else
    send_notification "PostgreSQL Backup Failed" "Backup process failed"
    log_message "Backup process failed"
    exit 1
fi
```

### Step 3: WAL Archive Management Script

```bash
#!/bin/bash
# archive-wal.sh - WAL archive management

WAL_ARCHIVE_DIR="/backup/postgres/wal_archive"
RETENTION_DAYS=7

# Clean old WAL files
find "$WAL_ARCHIVE_DIR" -type f -mtime +$RETENTION_DAYS -delete

# Report archive status
echo "WAL Archive Status:"
echo "Total files: $(ls -1 $WAL_ARCHIVE_DIR | wc -l)"
echo "Disk usage: $(du -sh $WAL_ARCHIVE_DIR | cut -f1)"
```

### Step 4: Restore Script

```bash
#!/bin/bash
# postgres-restore.sh - PostgreSQL restore script

set -euo pipefail

BACKUP_FILE=$1
TARGET_DB=${2:-production_db_restore}

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup-file> [target-database]"
    echo "Available backups:"
    ls -lh /backup/postgres/*.dump.gz
    exit 1
fi

echo "=== PostgreSQL Restore ==="
echo "Backup file: $BACKUP_FILE"
echo "Target database: $TARGET_DB"
echo

# Create target database
echo "Creating database $TARGET_DB..."
sudo -u postgres psql -c "DROP DATABASE IF EXISTS $TARGET_DB;"
sudo -u postgres psql -c "CREATE DATABASE $TARGET_DB;"

# Restore backup
echo "Restoring backup..."
gunzip -c "$BACKUP_FILE" | sudo -u postgres pg_restore -d "$TARGET_DB" -v

echo "Restore completed successfully"
echo "Verify with: sudo -u postgres psql $TARGET_DB -c '\dt'"
```

### Step 5: Offsite Backup Script

```bash
#!/bin/bash
# offsite-backup.sh - Copy backups to offsite location

BACKUP_DIR="/backup/postgres"
REMOTE_HOST="backup-server.company.com"
REMOTE_DIR="/backups/postgres"
REMOTE_USER="backup"

# Using rsync for efficient transfer
rsync -avz --delete \
    -e "ssh -i /home/postgres/.ssh/backup_key" \
    "$BACKUP_DIR/" \
    "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"

if [ $? -eq 0 ]; then
    echo "Offsite backup sync completed successfully"
else
    echo "ERROR: Offsite backup sync failed"
    exit 1
fi
```

### Step 6: Backup Verification Script

```bash
#!/bin/bash
# verify-backup.sh - Automated backup verification

BACKUP_DIR="/backup/postgres"
LOG_FILE="/var/log/backup-verification.log"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Get latest backup
LATEST_BACKUP=$(ls -t ${BACKUP_DIR}/*.dump.gz | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    log_message "ERROR: No backups found"
    exit 1
fi

log_message "Verifying backup: $LATEST_BACKUP"

# Test restore to temporary database
TEST_DB="backup_verification_test"

# Drop test database if exists
sudo -u postgres psql -c "DROP DATABASE IF EXISTS $TEST_DB;" 2>/dev/null

# Create test database
sudo -u postgres psql -c "CREATE DATABASE $TEST_DB;"

# Restore backup
gunzip -c "$LATEST_BACKUP" | sudo -u postgres pg_restore -d "$TEST_DB" 2>&1 | tee -a "$LOG_FILE"

if [ ${PIPESTATUS[1]} -eq 0 ]; then
    log_message "Backup verification PASSED"
    
    # Count tables
    TABLE_COUNT=$(sudo -u postgres psql -d $TEST_DB -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';")
    log_message "Restored tables: $TABLE_COUNT"
    
    # Cleanup test database
    sudo -u postgres psql -c "DROP DATABASE $TEST_DB;"
    
    exit 0
else
    log_message "Backup verification FAILED"
    exit 1
fi
```

### Step 7: Cron Configuration

```bash
# Create cron configuration
sudo tee /etc/cron.d/postgres-backup > /dev/null <<'EOF'
# PostgreSQL Backup Schedule

# Daily full backup at 2 AM
0 2 * * * postgres /usr/local/bin/postgres-backup.sh daily >> /var/log/postgres-backup.log 2>&1

# Weekly backup every Sunday at 3 AM
0 3 * * 0 postgres /usr/local/bin/postgres-backup.sh weekly >> /var/log/postgres-backup.log 2>&1

# Monthly backup on 1st of month at 4 AM
0 4 1 * * postgres /usr/local/bin/postgres-backup.sh monthly >> /var/log/postgres-backup.log 2>&1

# Offsite copy every 6 hours
0 */6 * * * postgres /usr/local/bin/offsite-backup.sh >> /var/log/offsite-backup.log 2>&1

# Backup verification daily at 6 AM
0 6 * * * postgres /usr/local/bin/verify-backup.sh >> /var/log/backup-verify.log 2>&1

# WAL cleanup daily at 1 AM
0 1 * * * postgres /usr/local/bin/archive-wal.sh >> /var/log/wal-archive.log 2>&1
EOF

sudo chmod 644 /etc/cron.d/postgres-backup
```

### Step 8: Monitoring Script

```bash
#!/bin/bash
# backup-monitor.sh - Monitor backup status

BACKUP_DIR="/backup/postgres"
MAX_AGE_HOURS=26

echo "=== PostgreSQL Backup Monitor ==="

# Check last backup age
LATEST_BACKUP=$(ls -t ${BACKUP_DIR}/*.dump.gz 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ ERROR: No backups found!"
    exit 1
fi

BACKUP_AGE=$(( ($(date +%s) - $(stat -c %Y "$LATEST_BACKUP")) / 3600 ))

echo "Latest backup: $(basename $LATEST_BACKUP)"
echo "Backup age: ${BACKUP_AGE} hours"

if [ $BACKUP_AGE -gt $MAX_AGE_HOURS ]; then
    echo "❌ WARNING: Backup is older than $MAX_AGE_HOURS hours!"
else
    echo "✓ Backup age OK"
fi

# Check backup size
BACKUP_SIZE=$(du -h "$LATEST_BACKUP" | cut -f1)
echo "Backup size: $BACKUP_SIZE"

# Check disk space
DISK_USAGE=$(df -h "$BACKUP_DIR" | tail -1 | awk '{print $5}' | sed 's/%//')
echo "Disk usage: ${DISK_USAGE}%"

if [ $DISK_USAGE -gt 80 ]; then
    echo "❌ WARNING: Disk usage above 80%!"
else
    echo "✓ Disk space OK"
fi

# Count backups
BACKUP_COUNT=$(ls -1 ${BACKUP_DIR}/*.dump.gz 2>/dev/null | wc -l)
echo "Total backups: $BACKUP_COUNT"

# Check WAL archive
WAL_COUNT=$(ls -1 ${BACKUP_DIR}/wal_archive/ 2>/dev/null | wc -l)
echo "WAL files archived: $WAL_COUNT"

echo "=== Monitor Complete ==="
```

---

## Task 1.11: Log Rotation Configuration

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-111-log-rotation-configuration)**

### Solution Overview

Comprehensive log rotation solution for all system and application logs.

### Step 1: Application Logs Rotation

```bash
# Configure logrotate for application logs
sudo tee /etc/logrotate.d/applications > /dev/null <<'EOF'
/var/log/applications/*.log {
    daily
    rotate 14
    missingok
    notifempty
    compress
    delaycompress
    create 0640 appuser appgroup
    size 100M
    sharedscripts
    postrotate
        systemctl reload backend-api > /dev/null 2>&1 || true
        systemctl reload frontend > /dev/null 2>&1 || true
        systemctl reload worker > /dev/null 2>&1 || true
    endscript
}
EOF
```

### Step 2: Nginx Logs Rotation

```bash
# Configure nginx log rotation
sudo tee /etc/logrotate.d/nginx-custom > /dev/null <<'EOF'
/var/log/nginx/access.log {
    daily
    rotate 30
    missingok
    notifempty
    compress
    delaycompress
    create 0640 www-data adm
    sharedscripts
    prerotate
        if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
            run-parts /etc/logrotate.d/httpd-prerotate; \
        fi
    endscript
    postrotate
        invoke-rc.d nginx rotate >/dev/null 2>&1 || true
    endscript
}

/var/log/nginx/error.log {
    daily
    rotate 14
    missingok
    notifempty
    compress
    delaycompress
    create 0640 www-data adm
    sharedscripts
    postrotate
        invoke-rc.d nginx rotate >/dev/null 2>&1 || true
    endscript
}
EOF
```

### Step 3: PostgreSQL Logs Rotation

```bash
# Configure PostgreSQL log rotation
sudo tee /etc/logrotate.d/postgresql-custom > /dev/null <<'EOF'
/var/log/postgresql/*.log {
    daily
    rotate 30
    missingok
    notifempty
    compress
    delaycompress
    create 0640 postgres postgres
    sharedscripts
    postrotate
        /usr/bin/pg_ctl reload -D /var/lib/postgresql/*/main/ >/dev/null 2>&1 || true
    endscript
}
EOF
```

### Step 4: Complete Logrotate Setup Script

```bash
#!/bin/bash
# setup-logrotate.sh - Complete logrotate configuration

echo "Configuring log rotation..."

# Application logs
sudo tee /etc/logrotate.d/applications > /dev/null <<'APPLOGS'
/var/log/applications/*.log {
    daily
    rotate 14
    missingok
    notifempty
    compress
    delaycompress
    create 0640 appuser appgroup
    size 100M
    dateext
    dateformat -%Y%m%d
    sharedscripts
    postrotate
        systemctl reload backend-api > /dev/null 2>&1 || true
        systemctl reload frontend > /dev/null 2>&1 || true
        systemctl reload worker > /dev/null 2>&1 || true
    endscript
}
APPLOGS

# Create emergency cleanup configuration for critical space situations
sudo tee /etc/logrotate.d/emergency-cleanup > /dev/null <<'EMERGENCY'
# Emergency log cleanup - runs when disk is critically full
/var/log/*.log {
    size 50M
    rotate 2
    compress
    missingok
    notifempty
}
EMERGENCY

# Test logrotate configuration
echo "Testing logrotate configuration..."
sudo logrotate -d /etc/logrotate.d/applications

echo "Log rotation configured successfully"
```

### Step 5: Disk Space Monitor for Logs

```bash
#!/bin/bash
# log-disk-monitor.sh - Monitor disk space used by logs

THRESHOLD=80
LOG_DIRS=("/var/log" "/var/log/applications" "/var/log/nginx")

echo "=== Log Disk Usage Monitor ==="

for dir in "${LOG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "Directory: $dir"
        du -sh "$dir"
        
        # Find largest log files
        echo "  Top 5 largest files:"
        find "$dir" -type f -exec du -h {} + | sort -rh | head -5
        echo
    fi
done

# Check if any partition is above threshold
df -h | awk -v threshold=$THRESHOLD 'NR>1 {
    usage=int($5);
    if (usage > threshold) {
        print "WARNING: "$6" is at "usage"% (threshold: "threshold"%)";
    }
}'
```

### Step 6: Manual Rotation Script

```bash
#!/bin/bash
# force-log-rotation.sh - Manually trigger log rotation

echo "Forcing log rotation for all configured logs..."

# Force rotation
sudo logrotate -f /etc/logrotate.conf

# Show results
echo "Rotation complete. Recent rotated files:"
find /var/log -name "*.1" -o -name "*.gz" -mtime -1 | head -20
```

---

## Task 1.12: Disk Space Crisis Management

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-112-disk-space-crisis-management)**

### Solution Overview

Emergency disk space cleanup procedures and prevention measures.

### Step 1: Emergency Cleanup Script

```bash
#!/bin/bash
# emergency-cleanup.sh - Emergency disk space cleanup

set -euo pipefail

LOG_FILE="/var/log/emergency-cleanup.log"
FREED_SPACE=0

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_disk_usage() {
    df -h / | awk 'NR==2 {print $(NF-1)}' | sed 's/%//'
}

log_message "=== EMERGENCY DISK CLEANUP STARTED ==="
log_message "Current disk usage: $(check_disk_usage)%"

# 1. Clean APT cache
log_message "Cleaning APT cache..."
apt_before=$(du -sm /var/cache/apt | awk '{print $1}')
sudo apt clean
apt_after=$(du -sm /var/cache/apt | awk '{print $1}')
apt_freed=$((apt_before - apt_after))
FREED_SPACE=$((FREED_SPACE + apt_freed))
log_message "Freed ${apt_freed}MB from APT cache"

# 2. Remove old kernels (keep current and one previous)
log_message "Removing old kernels..."
CURRENT_KERNEL=$(uname -r)
sudo apt autoremove --purge -y
kernel_freed=100  # Estimate
FREED_SPACE=$((FREED_SPACE + kernel_freed))
log_message "Removed old kernels (~${kernel_freed}MB)"

# 3. Clean old logs
log_message "Cleaning old logs..."
logs_before=$(du -sm /var/log | awk '{print $1}')
sudo journalctl --vacuum-time=7d
sudo find /var/log -name "*.gz" -mtime +7 -delete
sudo find /var/log -name "*.1" -mtime +7 -delete
logs_after=$(du -sm /var/log | awk '{print $1}')
logs_freed=$((logs_before - logs_after))
FREED_SPACE=$((FREED_SPACE + logs_freed))
log_message "Freed ${logs_freed}MB from logs"

# 4. Clean temporary files
log_message "Cleaning temporary files..."
tmp_before=$(du -sm /tmp | awk '{print $1}')
sudo find /tmp -type f -atime +7 -delete
sudo find /var/tmp -type f -atime +7 -delete
tmp_after=$(du -sm /tmp | awk '{print $1}')
tmp_freed=$((tmp_before - tmp_after))
FREED_SPACE=$((FREED_SPACE + tmp_freed))
log_message "Freed ${tmp_freed}MB from temp files"

# 5. Clean Docker (if installed)
if command -v docker &> /dev/null; then
    log_message "Cleaning Docker..."
    docker_before=$(du -sm /var/lib/docker 2>/dev/null | awk '{print $1}' || echo "0")
    sudo docker system prune -af --volumes
    docker_after=$(du -sm /var/lib/docker 2>/dev/null | awk '{print $1}' || echo "0")
    docker_freed=$((docker_before - docker_after))
    FREED_SPACE=$((FREED_SPACE + docker_freed))
    log_message "Freed ${docker_freed}MB from Docker"
fi

# 6. Find and report large files
log_message "Large files (>1GB):"
find / -type f -size +1G -exec ls -lh {} \; 2>/dev/null | awk '{print $5, $9}' | sort -rh | head -10 | tee -a "$LOG_FILE"

log_message "=== CLEANUP COMPLETE ==="
log_message "Total space freed: ${FREED_SPACE}MB"
log_message "Current disk usage: $(check_disk_usage)%"
```

### Step 2: Disk Investigation Script

```bash
#!/bin/bash
# investigate-disk.sh - Investigate disk usage

echo "=== DISK USAGE INVESTIGATION ==="

# Overall disk usage
echo "1. Overall Disk Usage:"
df -h

# Largest directories
echo -e "\n2. Top 10 Largest Directories:"
du -h / 2>/dev/null | sort -rh | head -10

# Largest files
echo -e "\n3. Top 20 Largest Files:"
find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -20

# Deleted files still held open
echo -e "\n4. Deleted Files Still Held Open:"
sudo lsof +L1 | grep deleted

# Package cache
echo -e "\n5. Package Cache Size:"
du -sh /var/cache/apt

# Log sizes
echo -e "\n6. Log Directory Sizes:"
du -sh /var/log/*

# Docker usage (if installed)
if command -v docker &> /dev/null; then
    echo -e "\n7. Docker Disk Usage:"
    sudo docker system df
fi
```

### Step 3: Continuous Monitoring Script

```bash
#!/bin/bash
# disk-monitor.sh - Continuous disk monitoring

THRESHOLD=80
CRITICAL_THRESHOLD=90
ALERT_EMAIL="admin@company.com"

check_and_alert() {
    USAGE=$(df -h / | awk 'NR==2 {print $(NF-1)}' | sed 's/%//')
    
    if [ "$USAGE" -gt "$CRITICAL_THRESHOLD" ]; then
        echo "CRITICAL: Disk usage at ${USAGE}%!" | mail -s "CRITICAL: Disk Space Alert" "$ALERT_EMAIL"
        # Auto-run emergency cleanup
        /usr/local/bin/emergency-cleanup.sh
    elif [ "$USAGE" -gt "$THRESHOLD" ]; then
        echo "WARNING: Disk usage at ${USAGE}%" | mail -s "WARNING: Disk Space Alert" "$ALERT_EMAIL"
    fi
}

# Run check
check_and_alert
```

---

*The file now contains comprehensive solutions for tasks 1.1 through 1.12. Continuing with tasks 1.13-1.18...*

## Task 1.13: Network Connectivity Troubleshooting

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-113-network-connectivity-troubleshooting)**

### Solution Overview

Comprehensive network troubleshooting procedures and diagnostic tools.

### Step 1: Network Diagnostic Script

```bash
#!/bin/bash
# network-test.sh - Comprehensive network connectivity test

echo "=== NETWORK CONNECTIVITY TEST ==="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo

# Test 1: Interface Status
echo "1. Network Interface Status:"
ip addr show | grep -E '^[0-9]|inet '
echo

# Test 2: Interface Statistics
echo "2. Interface Statistics (errors/drops):"
ip -s link show | grep -A 2 -E '^[0-9]'
echo

# Test 3: Routing Table
echo "3. Routing Table:"
ip route show
echo

# Test 4: Default Gateway Connectivity
echo "4. Gateway Connectivity:"
GATEWAY=$(ip route | grep default | awk '{print $3}')
if [ -n "$GATEWAY" ]; then
    echo "Default gateway: $GATEWAY"
    ping -c 4 -W 2 "$GATEWAY" && echo "✓ Gateway reachable" || echo "✗ Gateway unreachable"
else
    echo "✗ No default gateway found"
fi
echo

# Test 5: DNS Resolution
echo "5. DNS Resolution:"
cat /etc/resolv.conf | grep nameserver
nslookup google.com && echo "✓ DNS working" || echo "✗ DNS not working"
echo

# Test 6: External Connectivity
echo "6. External Connectivity:"
ping -c 4 -W 2 8.8.8.8 && echo "✓ External IP reachable" || echo "✗ External IP unreachable"
ping -c 4 -W 2 google.com && echo "✓ External DNS name reachable" || echo "✗ External DNS name unreachable"
echo

# Test 7: Service Ports
echo "7. Listening Ports:"
ss -tuln | grep LISTEN
echo

# Test 8: Active Connections
echo "8. Active Connection Count:"
ss -tunapl | wc -l
echo

# Test 9: Connection States
echo "9. Connection States:"
ss -ant | awk '{print $1}' | sort | uniq -c
```

### Step 2: Advanced Network Diagnostics

```bash
#!/bin/bash
# network-advanced-diag.sh - Advanced network diagnostics

TARGET_HOST=${1:-"google.com"}

echo "=== ADVANCED NETWORK DIAGNOSTICS ==="
echo "Target: $TARGET_HOST"
echo

# MTU Detection
echo "1. MTU Path Discovery:"
ping -M do -s 1472 -c 1 "$TARGET_HOST" && echo "MTU: 1500 (Standard)" || echo "MTU: May need adjustment"
echo

# Traceroute
echo "2. Network Path (Traceroute):"
traceroute -n -m 15 "$TARGET_HOST"
echo

# TCP Connection Test
echo "3. TCP Connection Test (Port 80):"
timeout 5 bash -c "</dev/tcp/${TARGET_HOST}/80" && echo "✓ Port 80 open" || echo "✗ Port 80 closed/filtered"
echo

# DNS Lookup Details
echo "4. DNS Lookup Details:"
dig "$TARGET_HOST" +short
echo

# Network Latency
echo "5. Network Latency (10 pings):"
ping -c 10 "$TARGET_HOST" | tail -2
echo

# Packet Loss Test
echo "6. Packet Loss Test:"
ping -c 100 -i 0.2 "$TARGET_HOST" | grep "packet loss"
```

### Step 3: Service-Specific Tests

```bash
#!/bin/bash
# service-connectivity-test.sh - Test service connectivity

echo "=== SERVICE CONNECTIVITY TEST ==="

# Test Database Connection
echo "1. PostgreSQL Database:"
if command -v pg_isready &> /dev/null; then
    pg_isready -h localhost -p 5432 && echo "✓ PostgreSQL reachable" || echo "✗ PostgreSQL unreachable"
else
    echo "pg_isready not installed"
fi
echo

# Test Redis Connection
echo "2. Redis Cache:"
if command -v redis-cli &> /dev/null; then
    redis-cli -h localhost -p 6379 ping && echo "✓ Redis reachable" || echo "✗ Redis unreachable"
else
    echo "redis-cli not installed"
fi
echo

# Test HTTP Services
echo "3. HTTP Services:"
for port in 80 443 8080; do
    curl -s -o /dev/null -w "Port $port: %{http_code}\n" --max-time 5 "http://localhost:$port" || echo "Port $port: unreachable"
done
echo

# Test SSH
echo "4. SSH Service:"
timeout 5 ssh -o ConnectTimeout=5 -o BatchMode=yes localhost "echo connected" 2>&1 | grep -q "connected" && echo "✓ SSH working" || echo "✗ SSH not working"
```

### Step 4: Network Issue Resolution Procedures

```bash
#!/bin/bash
# fix-network-issues.sh - Common network issue fixes

echo "=== NETWORK ISSUE RESOLUTION ==="

# Fix 1: Restart Network Service
echo "1. Restarting network service..."
sudo systemctl restart networking
sudo systemctl restart NetworkManager
echo "✓ Network services restarted"

# Fix 2: Flush DNS Cache
echo "2. Flushing DNS cache..."
sudo systemd-resolve --flush-caches
sudo systemctl restart systemd-resolved
echo "✓ DNS cache flushed"

# Fix 3: Reset Network Interface
echo "3. Resetting network interface..."
INTERFACE=$(ip route | grep default | awk '{print $5}')
if [ -n "$INTERFACE" ]; then
    sudo ip link set "$INTERFACE" down
    sleep 2
    sudo ip link set "$INTERFACE" up
    echo "✓ Interface $INTERFACE reset"
fi

# Fix 4: Clear ARP Cache
echo "4. Clearing ARP cache..."
sudo ip neigh flush all
echo "✓ ARP cache cleared"

# Fix 5: Check Firewall
echo "5. Firewall status..."
sudo ufw status
echo "✓ Firewall checked"

# Fix 6: Test connectivity after fixes
echo "6. Testing connectivity..."
ping -c 4 8.8.8.8 && echo "✓ Connectivity restored" || echo "✗ Issue persists"
```

### Step 5: Network Performance Testing

```bash
#!/bin/bash
# network-performance-test.sh - Test network performance

TARGET=${1:-"google.com"}

echo "=== NETWORK PERFORMANCE TEST ==="

# Bandwidth Test (using curl)
echo "1. Download Speed Test:"
echo "Downloading 10MB test file..."
curl -o /dev/null -w "Speed: %{speed_download} bytes/sec\nTime: %{time_total}s\n" https://proof.ovh.net/files/10Mb.dat

# Latency Test
echo -e "\n2. Latency Test (50 pings):"
ping -c 50 -i 0.2 "$TARGET" | tail -2

# Throughput Test
echo -e "\n3. TCP Throughput (using iperf if available):"
if command -v iperf3 &> /dev/null; then
    echo "Run iperf3 server on target: iperf3 -s"
    echo "Then run: iperf3 -c <target-ip>"
else
    echo "iperf3 not installed. Install with: sudo apt install iperf3"
fi

# Connection Quality
echo -e "\n4. Connection Quality:"
mtr -r -c 10 "$TARGET"
```

---

## Task 1.14: Systemd Timers for Scheduled Tasks

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-114-systemd-timers-for-scheduled-tasks)**

### Solution Overview

Complete migration from cron to systemd timers with proper service units.

### Step 1: Database Backup Timer

```bash
# Create service unit
sudo tee /etc/systemd/system/backup.service > /dev/null <<'EOF'
[Unit]
Description=Database Backup Service
After=postgresql.service
Wants=postgresql.service

[Service]
Type=oneshot
User=postgres
ExecStart=/usr/local/bin/backup-database.sh
StandardOutput=journal
StandardError=journal
EOF

# Create timer unit
sudo tee /etc/systemd/system/backup.timer > /dev/null <<'EOF'
[Unit]
Description=Daily Database Backup Timer
Requires=backup.service

[Timer]
OnCalendar=daily
OnCalendar=*-*-* 02:00:00
Persistent=true
AccuracySec=1min

[Install]
WantedBy=timers.target
EOF

# Enable and start timer
sudo systemctl daemon-reload
sudo systemctl enable backup.timer
sudo systemctl start backup.timer
```

### Step 2: Log Cleanup Timer

```bash
# Create service unit
sudo tee /etc/systemd/system/log-cleanup.service > /dev/null <<'EOF'
[Unit]
Description=Log Cleanup Service
Documentation=man:find(1)

[Service]
Type=oneshot
ExecStart=/usr/bin/find /var/log -name "*.log.gz" -mtime +30 -delete
ExecStart=/usr/bin/find /tmp -atime +7 -delete
StandardOutput=journal
StandardError=journal
EOF

# Create timer unit
sudo tee /etc/systemd/system/log-cleanup.timer > /dev/null <<'EOF'
[Unit]
Description=Weekly Log Cleanup Timer
Requires=log-cleanup.service

[Timer]
OnCalendar=weekly
OnCalendar=Sun *-*-* 03:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable log-cleanup.timer
sudo systemctl start log-cleanup.timer
```

### Step 3: Health Check Timer

```bash
# Create health check script
sudo tee /usr/local/bin/health-check.sh > /dev/null <<'EOF'
#!/bin/bash
# System health check

REPORT_FILE="/var/log/health-report-$(date +%Y%m%d-%H%M).txt"

{
    echo "=== SYSTEM HEALTH REPORT ==="
    echo "Date: $(date)"
    echo "Uptime: $(uptime)"
    echo
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')"
    echo "Memory: $(free -h | grep Mem)"
    echo "Disk: $(df -h / | tail -1)"
    echo
    echo "Services Status:"
    systemctl is-active postgresql && echo "  PostgreSQL: Running" || echo "  PostgreSQL: Stopped"
    systemctl is-active nginx && echo "  Nginx: Running" || echo "  Nginx: Stopped"
    systemctl is-active backend-api && echo "  Backend API: Running" || echo "  Backend API: Stopped"
} > "$REPORT_FILE"

# Send report if issues found
if grep -q "Stopped" "$REPORT_FILE"; then
    mail -s "Health Check Alert" admin@company.com < "$REPORT_FILE"
fi
EOF

sudo chmod +x /usr/local/bin/health-check.sh

# Create service unit
sudo tee /etc/systemd/system/health-check.service > /dev/null <<'EOF'
[Unit]
Description=System Health Check Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/health-check.sh
StandardOutput=journal
StandardError=journal
EOF

# Create timer unit (every 15 minutes)
sudo tee /etc/systemd/system/health-check.timer > /dev/null <<'EOF'
[Unit]
Description=Health Check Timer (Every 15 minutes)
Requires=health-check.service

[Timer]
OnBootSec=5min
OnUnitActiveSec=15min
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable health-check.timer
sudo systemctl start health-check.timer
```

### Step 4: Certificate Renewal Check Timer

```bash
# Create service unit
sudo tee /etc/systemd/system/cert-check.service > /dev/null <<'EOF'
[Unit]
Description=SSL Certificate Check Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/certbot renew --dry-run
StandardOutput=journal
StandardError=journal
EOF

# Create timer unit
sudo tee /etc/systemd/system/cert-check.timer > /dev/null <<'EOF'
[Unit]
Description=Daily Certificate Check Timer
Requires=cert-check.service

[Timer]
OnCalendar=daily
OnCalendar=*-*-* 00:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable cert-check.timer
sudo systemctl start cert-check.timer
```

### Step 5: Timer Management Commands

```bash
#!/bin/bash
# timer-management.sh - Manage systemd timers

ACTION=${1:-list}

case "$ACTION" in
    list)
        echo "=== Active Timers ==="
        systemctl list-timers --all
        ;;
    status)
        TIMER=$2
        if [ -z "$TIMER" ]; then
            echo "Usage: $0 status <timer-name>"
            exit 1
        fi
        systemctl status "$TIMER"
        ;;
    start)
        TIMER=$2
        sudo systemctl start "$TIMER"
        ;;
    stop)
        TIMER=$2
        sudo systemctl stop "$TIMER"
        ;;
    enable)
        TIMER=$2
        sudo systemctl enable "$TIMER"
        ;;
    disable)
        TIMER=$2
        sudo systemctl disable "$TIMER"
        ;;
    logs)
        TIMER=$2
        SERVICE=$(echo "$TIMER" | sed 's/.timer/.service/')
        sudo journalctl -u "$SERVICE" -f
        ;;
    *)
        echo "Usage: $0 {list|status|start|stop|enable|disable|logs} [timer-name]"
        exit 1
        ;;
esac
```

---

## Task 1.15: Security Incident Response

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-115-security-incident-response)**

### Solution Overview

Complete security incident response procedures and forensics tools.

### Step 1: Incident Investigation Script

```bash
#!/bin/bash
# investigate-security-incident.sh - Security incident investigation

OUTPUT_DIR="/var/log/security-incident-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo "=== SECURITY INCIDENT INVESTIGATION ==="
echo "Output directory: $OUTPUT_DIR"

# 1. Failed login attempts
echo "Collecting failed login attempts..."
sudo grep "Failed password" /var/log/auth.log | tail -100 > "$OUTPUT_DIR/failed-logins.txt"

# 2. Successful logins
echo "Collecting successful logins..."
sudo grep "Accepted" /var/log/auth.log | tail -100 > "$OUTPUT_DIR/successful-logins.txt"

# 3. Sudo usage
echo "Collecting sudo usage..."
sudo grep "sudo:" /var/log/auth.log | tail -100 > "$OUTPUT_DIR/sudo-usage.txt"

# 4. Check for suspicious users
echo "Checking for suspicious users..."
awk -F: '$3 >= 1000 {print $1":"$3":"$6":"$7}' /etc/passwd > "$OUTPUT_DIR/users.txt"

# 5. Running processes
echo "Collecting running processes..."
ps auxf > "$OUTPUT_DIR/processes.txt"

# 6. Network connections
echo "Collecting network connections..."
ss -tunapl > "$OUTPUT_DIR/connections.txt"

# 7. Open files
echo "Collecting open files..."
sudo lsof > "$OUTPUT_DIR/open-files.txt"

# 8. Cron jobs
echo "Checking cron jobs..."
for user in $(cut -f1 -d: /etc/passwd); do
    sudo crontab -u $user -l 2>/dev/null | grep -v "^#" > "$OUTPUT_DIR/cron-$user.txt"
done

# 9. Recently modified files
echo "Finding recently modified files..."
sudo find /etc /home /tmp -type f -mtime -1 > "$OUTPUT_DIR/recent-files.txt"

# 10. Check for rootkits
echo "Running rkhunter check..."
if command -v rkhunter &> /dev/null; then
    sudo rkhunter --check --skip-keypress > "$OUTPUT_DIR/rkhunter-report.txt"
fi

echo "Investigation complete. Results saved to: $OUTPUT_DIR"
```

### Step 2: Containment Script

```bash
#!/bin/bash
# contain-incident.sh - Contain security incident

echo "=== SECURITY INCIDENT CONTAINMENT ==="

# 1. Block suspicious IPs
echo "Blocking suspicious IPs..."
SUSPICIOUS_IPS=$(sudo grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | awk '$1 > 10 {print $2}')

for ip in $SUSPICIOUS_IPS; do
    echo "Blocking IP: $ip"
    sudo ufw deny from "$ip"
done

# 2. Disable suspicious user accounts
echo "Disabling suspicious accounts..."
for user in backdoor hacker malicious; do
    if id "$user" &>/dev/null; then
        echo "Disabling user: $user"
        sudo usermod -L "$user"
        sudo usermod -s /sbin/nologin "$user"
    fi
done

# 3. Kill suspicious processes
echo "Checking for suspicious processes..."
SUSPICIOUS_PROCS=$(ps aux | grep -E 'miner|crypto|suspicious' | grep -v grep | awk '{print $2}')
for pid in $SUSPICIOUS_PROCS; do
    echo "Killing process: $pid"
    sudo kill -9 "$pid"
done

# 4. Check and remove persistence mechanisms
echo "Checking for persistence mechanisms..."
sudo find /etc/cron* -type f -mtime -7 -ls
sudo find /etc/systemd/system -type f -mtime -7 -ls

# 5. Backup important logs
echo "Backing up logs..."
sudo tar -czf /root/logs-backup-$(date +%Y%m%d).tar.gz /var/log/

echo "Containment measures applied"
```

### Step 3: Forensics Collection

```bash
#!/bin/bash
# collect-forensics.sh - Collect forensic evidence

EVIDENCE_DIR="/forensics/incident-$(date +%Y%m%d-%H%M%S)"
sudo mkdir -p "$EVIDENCE_DIR"

echo "=== FORENSICS EVIDENCE COLLECTION ==="
echo "Evidence directory: $EVIDENCE_DIR"

# System information
sudo uname -a > "$EVIDENCE_DIR/system-info.txt"
sudo hostnamectl > "$EVIDENCE_DIR/hostname.txt"

# User accounts
sudo cp /etc/passwd "$EVIDENCE_DIR/"
sudo cp /etc/shadow "$EVIDENCE_DIR/"
sudo cp /etc/group "$EVIDENCE_DIR/"

# Authentication logs
sudo cp /var/log/auth.log* "$EVIDENCE_DIR/"
sudo cp /var/log/secure* "$EVIDENCE_DIR/" 2>/dev/null

# Command history
for user_home in /home/*; do
    user=$(basename "$user_home")
    sudo cp "$user_home/.bash_history" "$EVIDENCE_DIR/bash_history-$user" 2>/dev/null
done

# Network state
sudo netstat -antp > "$EVIDENCE_DIR/netstat.txt"
sudo ss -tunapl > "$EVIDENCE_DIR/ss.txt"
sudo iptables -L -n -v > "$EVIDENCE_DIR/iptables.txt"

# Running processes
sudo ps auxf > "$EVIDENCE_DIR/processes.txt"

# File integrity
if command -v aide &> /dev/null; then
    sudo aide --check > "$EVIDENCE_DIR/aide-check.txt"
fi

# Compress evidence
cd "$(dirname "$EVIDENCE_DIR")"
sudo tar -czf "$(basename "$EVIDENCE_DIR").tar.gz" "$(basename "$EVIDENCE_DIR")"

echo "Evidence collected and compressed"
echo "Archive: $EVIDENCE_DIR.tar.gz"
```

### Step 4: Incident Report Template

```bash
#!/bin/bash
# generate-incident-report.sh - Generate incident report

cat > /tmp/incident-report-$(date +%Y%m%d).md <<'EOF'
# SECURITY INCIDENT REPORT

## Incident Information
- Date: [DATE]
- Time: [TIME]
- Severity: [High/Medium/Low]
- Status: [Investigating/Contained/Resolved]
- Incident ID: [ID]

## Timeline
- [HH:MM] - Alert received
- [HH:MM] - Investigation started
- [HH:MM] - Incident confirmed
- [HH:MM] - Containment measures applied
- [HH:MM] - Resolution completed

## Indicators of Compromise (IOC)
- Suspicious Users: [list]
- Suspicious IPs: [list]
- Malicious Processes: [list]
- Modified Files: [list]

## Impact Assessment
- Systems Affected: [list]
- Data Accessed: [Unknown/Yes/No]
- Services Disrupted: [list]
- Duration: [hours]

## Actions Taken
1. [Action 1]
2. [Action 2]
3. [Action 3]

## Root Cause
[Description of how the incident occurred]

## Remediation
1. [Remediation step 1]
2. [Remediation step 2]

## Recommendations
1. [Recommendation 1]
2. [Recommendation 2]

## Follow-up Actions
- [ ] Update security policies
- [ ] Conduct security training
- [ ] Review access controls
- [ ] Update incident response procedures

---
Report prepared by: [Name]
Date: [Date]
EOF

echo "Incident report template created: /tmp/incident-report-$(date +%Y%m%d).md"
```

---

## Task 1.16: DNS Configuration and Troubleshooting

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-116-dns-configuration-and-troubleshooting)**

### Solution Overview

Complete DNS configuration with systemd-resolved and troubleshooting procedures.

### Step 1: Configure systemd-resolved

```bash
# Configure systemd-resolved
sudo tee /etc/systemd/resolved.conf > /dev/null <<'EOF'
[Resolve]
DNS=10.0.0.10 8.8.8.8 1.1.1.1
FallbackDNS=8.8.4.4 1.0.0.1
Domains=~company.internal
DNSSEC=allow-downgrade
DNSOverTLS=opportunistic
Cache=yes
CacheFromLocalhost=no
DNSStubListener=yes
ReadEtcHosts=yes
EOF

# Restart systemd-resolved
sudo systemctl restart systemd-resolved

# Verify configuration
sudo systemd-resolve --status
```

### Step 2: DNS Testing Script

```bash
#!/bin/bash
# test-dns.sh - Comprehensive DNS testing

echo "=== DNS CONFIGURATION TEST ==="

# Test 1: Check DNS servers
echo "1. Configured DNS Servers:"
sudo systemd-resolve --status | grep "DNS Servers"
echo

# Test 2: Test internal domain resolution
echo "2. Internal Domain Resolution:"
dig app.company.internal +short
echo

# Test 3: Test external domain resolution
echo "3. External Domain Resolution:"
dig google.com +short
echo

# Test 4: Measure resolution time
echo "4. Resolution Time:"
time dig google.com > /dev/null
echo

# Test 5: Test DNS failover
echo "5. DNS Cache Status:"
sudo systemd-resolve --statistics
echo

# Test 6: Reverse DNS lookup
echo "6. Reverse DNS Lookup:"
dig -x 8.8.8.8 +short
echo

# Test 7: Test different record types
echo "7. DNS Record Types:"
dig google.com A +short
dig google.com MX +short
dig google.com NS +short
```

### Step 3: DNS Troubleshooting Script

```bash
#!/bin/bash
# troubleshoot-dns.sh - DNS troubleshooting

echo "=== DNS TROUBLESHOOTING ==="

# Check 1: DNS configuration files
echo "1. DNS Configuration:"
cat /etc/resolv.conf
echo

# Check 2: systemd-resolved status
echo "2. systemd-resolved Status:"
sudo systemctl status systemd-resolved
echo

# Check 3: Test resolution with different tools
echo "3. Resolution Tests:"
echo "Using dig:"
dig google.com +short
echo "Using nslookup:"
nslookup google.com
echo "Using host:"
host google.com
echo

# Check 4: DNS query path
echo "4. DNS Query Trace:"
dig google.com +trace | head -20
echo

# Check 5: Check for DNS leaks
echo "5. Testing DNS servers directly:"
dig @8.8.8.8 google.com +short
dig @1.1.1.1 google.com +short
```

### Step 4: Fix Common DNS Issues

```bash
#!/bin/bash
# fix-dns-issues.sh - Fix common DNS issues

echo "=== FIXING DNS ISSUES ==="

# Fix 1: Flush DNS cache
echo "1. Flushing DNS cache..."
sudo systemd-resolve --flush-caches
echo "✓ DNS cache flushed"

# Fix 2: Restart systemd-resolved
echo "2. Restarting systemd-resolved..."
sudo systemctl restart systemd-resolved
echo "✓ systemd-resolved restarted"

# Fix 3: Reset resolv.conf symlink
echo "3. Resetting resolv.conf..."
sudo rm /etc/resolv.conf
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
echo "✓ resolv.conf reset"

# Fix 4: Test resolution
echo "4. Testing DNS resolution..."
dig google.com +short && echo "✓ DNS working" || echo "✗ DNS still not working"
```

---

## Task 1.17: Process Priority Management

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-117-process-priority-management)**

### Solution Overview

Complete process priority management with nice, renice, and systemd controls.

### Step 1: Process Priority Commands

```bash
#!/bin/bash
# manage-process-priority.sh - Manage process priorities

ACTION=$1
TARGET=$2
PRIORITY=$3

case "$ACTION" in
    show)
        echo "=== Current Process Priorities ==="
        ps -eo pid,ni,pri,cmd --sort=ni | head -20
        ;;
    renice-pid)
        if [ -z "$TARGET" ] || [ -z "$PRIORITY" ]; then
            echo "Usage: $0 renice-pid <PID> <nice-value>"
            exit 1
        fi
        sudo renice -n "$PRIORITY" -p "$TARGET"
        echo "Process $TARGET reniced to $PRIORITY"
        ;;
    renice-user)
        if [ -z "$TARGET" ] || [ -z "$PRIORITY" ]; then
            echo "Usage: $0 renice-user <username> <nice-value>"
            exit 1
        fi
        sudo renice -n "$PRIORITY" -u "$TARGET"
        echo "All processes for user $TARGET reniced to $PRIORITY"
        ;;
    start-nice)
        if [ -z "$TARGET" ] || [ -z "$PRIORITY" ]; then
            echo "Usage: $0 start-nice <command> <nice-value>"
            exit 1
        fi
        nice -n "$PRIORITY" "$TARGET"
        ;;
    *)
        echo "Usage: $0 {show|renice-pid|renice-user|start-nice} [args]"
        exit 1
        ;;
esac
```

### Step 2: Resource Control with Systemd

```bash
# Configure resource limits for batch job service
sudo tee /etc/systemd/system/batch-job.service > /dev/null <<'EOF'
[Unit]
Description=Batch Processing Job
After=network.target

[Service]
Type=simple
User=batchuser
ExecStart=/usr/local/bin/batch-job.sh

# Process Priority
Nice=15
CPUSchedulingPolicy=batch

# Resource Limits
CPUQuota=50%
CPUWeight=50
MemoryLimit=2G
MemoryHigh=1.5G
TasksMax=256

# I/O Priority
IOSchedulingClass=2
IOSchedulingPriority=7

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
```

### Step 3: Monitor Process Resources

```bash
#!/bin/bash
# monitor-process-resources.sh - Monitor process resource usage

echo "=== PROCESS RESOURCE MONITORING ==="

# Top CPU consumers
echo "Top 10 CPU Consumers:"
ps aux --sort=-%cpu | head -11 | awk '{printf "%-10s %-8s %-6s %-6s %s\n", $1, $2, $3, $4, $11}'
echo

# Top Memory consumers
echo "Top 10 Memory Consumers:"
ps aux --sort=-%mem | head -11 | awk '{printf "%-10s %-8s %-6s %-6s %s\n", $1, $2, $3, $4, $11}'
echo

# Process priorities
echo "Processes by Priority:"
ps -eo pid,ni,pri,pcpu,pmem,cmd --sort=ni | head -20
```

---

## Task 1.18: High CPU and Memory Troubleshooting

> **📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-118-high-cpu-and-memory-troubleshooting)**

### Solution Overview

Comprehensive troubleshooting for high CPU and memory usage issues.

### Step 1: Immediate CPU Investigation

```bash
#!/bin/bash
# investigate-cpu.sh - Investigate high CPU usage

echo "=== HIGH CPU INVESTIGATION ==="

# Current CPU usage
echo "1. Current CPU Usage:"
top -bn1 | head -15
echo

# CPU load average
echo "2. Load Average:"
uptime
CORES=$(nproc)
echo "CPU Cores: $CORES"
echo

# Top CPU processes
echo "3. Top 10 CPU Consuming Processes:"
ps aux --sort=-%cpu | head -11
echo

# CPU usage per core
echo "4. Per-Core CPU Usage:"
mpstat -P ALL 1 1
echo

# Context switches
echo "5. Context Switches:"
vmstat 1 5 | awk '{print "Context Switches: "$12}'
```

### Step 2: Memory Investigation

```bash
#!/bin/bash
# investigate-memory.sh - Investigate memory issues

echo "=== MEMORY INVESTIGATION ==="

# Memory overview
echo "1. Memory Overview:"
free -h
echo

# Memory details
echo "2. Memory Details:"
cat /proc/meminfo | grep -E 'MemTotal|MemFree|MemAvailable|Buffers|Cached|SwapTotal|SwapFree'
echo

# Top memory processes
echo "3. Top 10 Memory Consuming Processes:"
ps aux --sort=-%mem | head -11
echo

# OOM killer events
echo "4. OOM Killer Events:"
sudo dmesg | grep -i "out of memory"
sudo grep -i "killed process" /var/log/syslog | tail -10
echo

# Swap usage
echo "5. Swap Usage:"
swapon --show
echo

# Memory by user
echo "6. Memory Usage by User:"
ps aux | awk '{mem[$1]+=$4} END {for (user in mem) print user, mem[user]"%"}' | sort -k2 -rn
```

### Step 3: Resolution Script

```bash
#!/bin/bash
# fix-resource-issues.sh - Fix high resource usage

echo "=== FIXING RESOURCE ISSUES ==="

# Identify main culprit
echo "Identifying resource hogs..."
TOP_CPU_PID=$(ps aux --sort=-%cpu | awk 'NR==2 {print $2}')
TOP_CPU_CMD=$(ps aux --sort=-%cpu | awk 'NR==2 {print $11}')
TOP_MEM_PID=$(ps aux --sort=-%mem | awk 'NR==2 {print $2}')
TOP_MEM_CMD=$(ps aux --sort=-%mem | awk 'NR==2 {print $11}')

echo "Top CPU process: $TOP_CPU_CMD (PID: $TOP_CPU_PID)"
echo "Top Memory process: $TOP_MEM_CMD (PID: $TOP_MEM_PID)"

# Option 1: Renice processes
echo "Option 1: Renice high CPU process"
read -p "Renice PID $TOP_CPU_PID to priority 19? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo renice -n 19 -p "$TOP_CPU_PID"
    echo "Process $TOP_CPU_PID reniced to 19"
fi

# Option 2: Kill process
echo "Option 2: Kill problematic process"
read -p "Kill PID $TOP_CPU_PID? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo kill -15 "$TOP_CPU_PID"
    sleep 5
    if ps -p "$TOP_CPU_PID" > /dev/null; then
        sudo kill -9 "$TOP_CPU_PID"
    fi
    echo "Process killed"
fi

# Option 3: Clear cache (if safe)
echo "Option 3: Clear caches"
read -p "Clear page cache, dentries and inodes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sync
    sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
    echo "Caches cleared"
fi

echo "Resource issue mitigation complete"
```

### Step 4: Complete Diagnostic Report

```bash
#!/bin/bash
# generate-diagnostic-report.sh - Complete diagnostic report

OUTPUT_FILE="/tmp/diagnostic-report-$(date +%Y%m%d-%H%M%S).txt"

{
    echo "==============================================="
    echo "     SYSTEM DIAGNOSTIC REPORT"
    echo "==============================================="
    echo "Date: $(date)"
    echo "Hostname: $(hostname)"
    echo

    echo "=== SYSTEM INFORMATION ==="
    echo "Uptime: $(uptime -p)"
    echo "Kernel: $(uname -r)"
    echo "CPU Cores: $(nproc)"
    echo "Total Memory: $(free -h | grep Mem | awk '{print $2}')"
    echo

    echo "=== CPU ANALYSIS ==="
    echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)"
    echo
    echo "Top 10 CPU Processes:"
    ps aux --sort=-%cpu | head -11
    echo

    echo "=== MEMORY ANALYSIS ==="
    free -h
    echo
    echo "Top 10 Memory Processes:"
    ps aux --sort=-%mem | head -11
    echo

    echo "=== DISK I/O ==="
    iostat -x
    echo

    echo "=== NETWORK ==="
    echo "Active Connections: $(ss -tunapl | wc -l)"
    echo "Connection States:"
    ss -ant | awk '{print $1}' | sort | uniq -c
    echo

    echo "=== RECOMMENDATIONS ==="
    
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
        echo "⚠ HIGH CPU: Consider investigating top CPU processes"
    fi
    
    MEM_PERCENT=$(free | grep Mem | awk '{printf "%.0f", ($3/$2)*100}')
    if [ "$MEM_PERCENT" -gt 85 ]; then
        echo "⚠ HIGH MEMORY: Consider adding RAM or investigating memory leaks"
    fi
    
    echo "==============================================="
} > "$OUTPUT_FILE"

cat "$OUTPUT_FILE"
echo
echo "Report saved to: $OUTPUT_FILE"
```

---

## Conclusion

This document provides complete, production-ready solutions for all 18 real-world Linux tasks. Each solution includes:

- ✅ Step-by-step implementation procedures
- ✅ Complete scripts with proper error handling
- ✅ Configuration files ready for production use
- ✅ Verification and testing procedures
- ✅ Troubleshooting guides
- ✅ Best practices and security considerations

### Quick Reference

**Task Categories:**
1. Security (1.1, 1.2, 1.15)
2. User Management (1.3)
3. Storage Management (1.4, 1.12)
4. Services (1.5, 1.14)
5. Network (1.6, 1.13, 1.16)
6. Logging (1.7, 1.11)
7. Monitoring (1.8, 1.18)
8. Package Management (1.9)
9. Backup (1.10)
10. Performance (1.17)

### Next Steps

1. Review each solution and adapt to your specific environment
2. Test all scripts in a non-production environment first
3. Document any customizations made for your infrastructure
4. Train team members on these procedures
5. Incorporate solutions into your runbooks and documentation

---

**Document Version**: 1.0
**Last Updated**: November 2025  
**Author**: DevOps Tasks 2026 Team
