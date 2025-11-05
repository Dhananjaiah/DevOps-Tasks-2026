# Part 1: Linux Server Administration

## Overview

This section covers comprehensive Linux skills required for DevOps engineers managing production infrastructure. All tasks are built around operating our 3-tier web application (Frontend, Backend API, PostgreSQL) on AWS EC2 instances running Ubuntu/Amazon Linux.

## 📚 Available Resources

- **[QUICK-START-GUIDE.md](QUICK-START-GUIDE.md)** - 🚀 **START HERE!** Quick reference with task lookup table and learning paths
- **[REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)** - 18 practical, executable tasks with scenarios, requirements, and validation checklists for hands-on learning and assignments
- **[REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)** - ✨ **NEW!** Complete, production-ready solutions for all 18 real-world tasks with step-by-step commands, scripts, and configurations
- **[TASKS-1.4-1.18.md](TASKS-1.4-1.18.md)** - Additional task implementations and examples
- **[task-1.3-user-group-management.md](task-1.3-user-group-management.md)** - Detailed user and group management guide

---

## Task 1.1: Harden an EC2 Linux Instance for Production

### Goal / Why It's Important

Hardening a Linux server is the **first line of defense** against security breaches. In production environments, unhardened servers are vulnerable to:
- Unauthorized access attempts
- Brute force SSH attacks
- Privilege escalation exploits
- Data breaches

This task is critical for any production deployment and is a common interview topic.

### Prerequisites

- EC2 instance running Ubuntu 20.04 or Amazon Linux 2
- SSH access with sudo privileges
- Basic understanding of Linux security concepts

### Step-by-Step Implementation

#### Step 1: Update System Packages

```bash
# Update package lists
sudo apt update

# Upgrade all installed packages
sudo apt upgrade -y

# Install security updates (Ubuntu)
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure -plow unattended-upgrades
```

#### Step 2: Configure Automatic Security Updates

```bash
# Create or edit unattended-upgrades configuration
sudo vi /etc/apt/apt.conf.d/50unattended-upgrades
```

Add these lines:
```
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
```

#### Step 3: Disable Root Login

```bash
# Edit SSH configuration
sudo vi /etc/ssh/sshd_config

# Find and modify these lines:
PermitRootLogin no
```

#### Step 4: Configure Fail2Ban

```bash
# Install fail2ban
sudo apt install fail2ban -y

# Create local configuration
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit configuration
sudo vi /etc/fail2ban/jail.local
```

Add this configuration:
```ini
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
```

```bash
# Start and enable fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban
```

#### Step 5: Configure UFW Firewall

```bash
# Install UFW
sudo apt install ufw -y

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (important: do this before enabling!)
sudo ufw allow 22/tcp

# Allow application ports
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS
sudo ufw allow 8080/tcp    # Backend API

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status verbose
```

#### Step 6: Disable Unnecessary Services

```bash
# List all running services
sudo systemctl list-units --type=service --state=running

# Disable unnecessary services (example)
sudo systemctl disable bluetooth.service
sudo systemctl stop bluetooth.service

# For production API server, typically disable:
# - avahi-daemon (if not using local discovery)
# - cups (printing service)
# - bluetooth
```

#### Step 7: Configure Kernel Parameters

```bash
# Edit sysctl configuration
sudo vi /etc/sysctl.conf
```

Add these security parameters:
```ini
# IP Spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0

# Log Martians
net.ipv4.conf.all.log_martians = 1

# Ignore ICMP ping requests
net.ipv4.icmp_echo_ignore_all = 0

# Ignore Broadcast ping requests
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Increase system file descriptor limit
fs.file-max = 65535

# TCP SYN cookie protection
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5
```

Apply changes:
```bash
sudo sysctl -p
```

#### Step 8: Set Up File Integrity Monitoring

```bash
# Install AIDE (Advanced Intrusion Detection Environment)
sudo apt install aide -y

# Initialize AIDE database (this takes time)
sudo aideinit

# Move database to proper location
sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Run integrity check
sudo aide --check
```

#### Step 9: Configure Audit Logging

```bash
# Install auditd
sudo apt install auditd audispd-plugins -y

# Enable and start auditd
sudo systemctl enable auditd
sudo systemctl start auditd

# Add audit rules
sudo vi /etc/audit/rules.d/audit.rules
```

Add these rules:
```bash
# Monitor changes to system configuration
-w /etc/passwd -p wa -k passwd_changes
-w /etc/group -p wa -k group_changes
-w /etc/shadow -p wa -k shadow_changes
-w /etc/sudoers -p wa -k sudoers_changes

# Monitor SSH access
-w /var/log/auth.log -p wa -k auth_log_changes

# Monitor critical directories
-w /etc/ssh/sshd_config -p wa -k sshd_config_changes
-w /etc/systemd/system/ -p wa -k systemd_changes
```

```bash
# Restart auditd
sudo service auditd restart
```

#### Step 10: Harden SSH Configuration

```bash
sudo vi /etc/ssh/sshd_config
```

Configure these settings:
```ini
# Change default port (optional but recommended)
Port 2222

# Protocol
Protocol 2

# Authentication
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no

# Limit user logins
AllowUsers deploy ubuntu

# Security settings
X11Forwarding no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
MaxSessions 2

# Logging
SyslogFacility AUTH
LogLevel VERBOSE
```

```bash
# Restart SSH (careful with port changes!)
sudo systemctl restart sshd
```

### Key Commands Summary

```bash
# Security audit commands
sudo apt update && sudo apt upgrade -y              # Update system
sudo ufw status                                      # Check firewall
sudo fail2ban-client status sshd                    # Check fail2ban
sudo aide --check                                    # File integrity check
sudo ausearch -k passwd_changes                     # Check audit logs
sudo last -a                                         # Recent logins
sudo lastb                                           # Failed login attempts
cat /var/log/auth.log | grep "Failed password"     # SSH failures
sudo netstat -tulpn                                  # Open ports

# Service management
sudo systemctl list-units --type=service --state=running  # Running services
sudo systemctl disable <service>                          # Disable service
```

### Verification

#### 1. Test Firewall Configuration
```bash
# From your local machine
nmap -p 1-10000 <your-server-ip>

# Should only show allowed ports
```

#### 2. Verify SSH Hardening
```bash
# Check SSH configuration
sudo sshd -t

# Test from different terminal (DON'T close current session)
ssh -p 2222 user@server-ip
```

#### 3. Check Security Updates
```bash
# View unattended upgrades log
sudo tail -f /var/log/unattended-upgrades/unattended-upgrades.log
```

#### 4. Verify Fail2Ban
```bash
# Check fail2ban status
sudo fail2ban-client status sshd

# Attempt failed logins to test (from another machine)
# Then check if IP is banned
sudo fail2ban-client get sshd banned
```

#### 5. Review Audit Logs
```bash
# Search for specific events
sudo ausearch -m USER_LOGIN -sv no

# Generate audit report
sudo aureport --auth
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Locking Yourself Out

**Problem**: Changing SSH port or disabling password auth without testing

**Solution**:
- Always keep one SSH session open while testing
- Test new SSH config before closing: `sudo sshd -t`
- Keep AWS Systems Manager Session Manager as backup access

#### Mistake 2: UFW Blocks Everything

**Problem**: Enabling UFW without allowing SSH first

**Solution**:
```bash
# If locked out, use AWS console to access
sudo ufw allow 22/tcp
sudo ufw enable
```

#### Mistake 3: Fail2Ban Banning Yourself

**Problem**: Testing too many failed logins from your own IP

**Solution**:
```bash
# Unban your IP
sudo fail2ban-client set sshd unbanip YOUR_IP

# Add your IP to whitelist
sudo vi /etc/fail2ban/jail.local
# Add: ignoreip = 127.0.0.1/8 YOUR_IP
```

#### Mistake 4: Kernel Parameters Not Applied

**Problem**: Changes to sysctl.conf not taking effect

**Solution**:
```bash
# Verify syntax
sudo sysctl -p

# Check specific parameter
sysctl net.ipv4.conf.all.rp_filter
```

#### Troubleshooting: Service Won't Start After Hardening

```bash
# Check service status
sudo systemctl status <service-name>

# View detailed logs
sudo journalctl -xe -u <service-name>

# Check SELinux (if applicable)
sudo getenforce
sudo ausearch -m avc -ts recent
```

### Interview Questions with Answers

#### Q1: What is the difference between iptables and UFW?

**Answer**: 
- **iptables** is the low-level Linux firewall utility that directly interacts with netfilter in the kernel
- **UFW (Uncomplicated Firewall)** is a user-friendly frontend to iptables, providing simpler syntax
- UFW is recommended for most use cases due to ease of use
- iptables provides more granular control and is necessary for complex rules
- UFW rules are converted to iptables rules behind the scenes

#### Q2: Explain what Fail2Ban does and how it works.

**Answer**:
Fail2Ban monitors log files (like /var/log/auth.log) for failed authentication attempts. When it detects a pattern of failures exceeding a threshold:
1. It automatically creates firewall rules (iptables/UFW) to ban the offending IP
2. Ban duration is configurable (default: 10 minutes)
3. Protects against brute force attacks
4. Uses "jails" for different services (SSH, Apache, Nginx)
5. Can send email notifications on bans

#### Q3: What does the Linux kernel parameter `net.ipv4.tcp_syncookies` do?

**Answer**:
TCP SYN cookies protect against SYN flood attacks (DoS):
- When SYN queue is full, server sends back SYN-ACK with a cryptographic cookie
- Doesn't store connection state until ACK is received
- Prevents memory exhaustion from incomplete connections
- Essential for production servers facing the internet
- Value of 1 enables this protection

#### Q4: How would you investigate a suspected security breach on a Linux server?

**Answer**:
```bash
# 1. Check recent logins
last -a
lastb  # failed logins

# 2. Review active connections
ss -tunapl
netstat -tulpn

# 3. Check running processes
ps auxf
top

# 4. Review audit logs
ausearch -m USER_LOGIN -sv no
aureport --auth

# 5. Check for unauthorized changes
aide --check

# 6. Review system logs
journalctl -p err -b
tail -f /var/log/auth.log
grep -i "failed\|error" /var/log/syslog

# 7. Check for suspicious files
find /tmp -type f -mtime -1
find / -name "*.sh" -mtime -1

# 8. Review crontabs
crontab -l
ls -la /etc/cron*
```

#### Q5: What is the purpose of changing the default SSH port?

**Answer**:
- **Security through obscurity**: Reduces automated bot attacks scanning port 22
- **Log noise reduction**: Fewer failed login attempts in logs
- **Not a primary security measure**: Should be combined with key-based auth
- **Cons**: Non-standard port can complicate automation and firewall rules
- **Best practice**: Use non-standard port + key auth + fail2ban for defense in depth

#### Q6: How do you disable root login while ensuring you don't lose access?

**Answer**:
```bash
# 1. Create a sudo user first
sudo adduser deploy
sudo usermod -aG sudo deploy

# 2. Test sudo access in new session
su - deploy
sudo ls /root

# 3. Copy SSH keys to new user
sudo cp -r ~/.ssh /home/deploy/
sudo chown -R deploy:deploy /home/deploy/.ssh

# 4. Test SSH as new user (keep current session open!)
# From local: ssh deploy@server

# 5. Only then disable root login
sudo vi /etc/ssh/sshd_config
# Set: PermitRootLogin no
sudo systemctl restart sshd
```

#### Q7: Explain the difference between `apt update` and `apt upgrade`.

**Answer**:
- **apt update**: Updates the package index/lists from repositories
  - Checks for available updates
  - Doesn't install anything
  - Should be run first
  
- **apt upgrade**: Installs available updates
  - Upgrades packages to newer versions
  - Never removes packages
  - Safe to run automatically
  
- **apt full-upgrade**: Can add/remove packages to resolve dependencies
  - More aggressive than upgrade
  - May remove packages if needed
  - Use with caution in production

#### Q8: How would you automate security patching in production?

**Answer**:
```bash
# 1. Install unattended-upgrades
sudo apt install unattended-upgrades -y

# 2. Configure for security updates only
sudo vi /etc/apt/apt.conf.d/50unattended-upgrades
# Allow only security updates
# Set Automatic-Reboot "false" for production

# 3. Schedule updates during maintenance window
sudo vi /etc/apt/apt.conf.d/20auto-upgrades
# APT::Periodic::Update-Package-Lists "1";
# APT::Periodic::Unattended-Upgrade "1";

# 4. Monitor update logs
tail -f /var/log/unattended-upgrades/unattended-upgrades.log

# 5. Set up alerting for failed updates
# Use monitoring tools (Prometheus, CloudWatch)
```

#### Q9: What are the risks of disabling SELinux or AppArmor?

**Answer**:
- **Mandatory Access Control (MAC) loss**: These provide additional security layer beyond standard permissions
- **Privilege escalation risk**: Attackers can more easily exploit vulnerabilities
- **Compliance issues**: Many security standards require MAC systems
- **Container security**: Especially important for Docker/Kubernetes
- **Better approach**: Learn to write policies rather than disable
- **Troubleshooting**: Use permissive mode temporarily to identify issues, then fix policies

#### Q10: How do you secure a Linux server that will run Docker containers?

**Answer**:
```bash
# 1. Harden host OS (all previous steps)

# 2. Configure Docker daemon securely
sudo vi /etc/docker/daemon.json
{
  "icc": false,
  "userland-proxy": false,
  "no-new-privileges": true,
  "userns-remap": "default"
}

# 3. Run containers with security options
docker run --security-opt=no-new-privileges \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  --read-only \
  --tmpfs /tmp \
  my-app

# 4. Use user namespaces
# Remap container root to unprivileged host user

# 5. Implement AppArmor/SELinux policies for containers

# 6. Regular image scanning
docker scan my-app:latest

# 7. Minimal base images (alpine, distroless)
```

---

## Task 1.2: Configure SSH Key-Based Authentication and SSH Hardening

### Goal / Why It's Important

SSH key-based authentication is **dramatically more secure** than password authentication:
- **Prevents brute force attacks**: Keys have enormous entropy
- **No password to steal or forget**: Can't be phished or guessed
- **Enables automation**: CI/CD tools can authenticate securely
- **Audit trail**: Each key can be identified and traced
- **Standard practice**: Required in virtually all production environments

This is fundamental DevOps knowledge tested in every interview.

### Prerequisites

- Linux server with SSH access
- Local machine with SSH client
- Sudo privileges on the server

### Step-by-Step Implementation

#### Step 1: Generate SSH Key Pair on Local Machine

```bash
# Generate ED25519 key (recommended - faster and more secure than RSA)
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519_prod

# For compatibility with older systems, use RSA 4096
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/id_rsa_prod

# When prompted:
# - Enter a strong passphrase (recommended)
# - Or press Enter for no passphrase (for automation)
```

**Output**:
```
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase): 
Your identification has been saved in ~/.ssh/id_ed25519_prod
Your public key has been saved in ~/.ssh/id_ed25519_prod.pub
The key fingerprint is:
SHA256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx your_email@example.com
```

#### Step 2: Copy Public Key to Server

**Method 1: Using ssh-copy-id (easiest)**
```bash
# Copy key to server
ssh-copy-id -i ~/.ssh/id_ed25519_prod.pub ubuntu@your-server-ip

# If using non-standard port
ssh-copy-id -i ~/.ssh/id_ed25519_prod.pub -p 2222 ubuntu@your-server-ip
```

**Method 2: Manual copy**
```bash
# Display public key
cat ~/.ssh/id_ed25519_prod.pub

# On server, create .ssh directory and add key
mkdir -p ~/.ssh
chmod 700 ~/.ssh
vi ~/.ssh/authorized_keys
# Paste the public key
chmod 600 ~/.ssh/authorized_keys
```

**Method 3: Using AWS EC2 (for new instances)**
```bash
# When launching EC2, specify key pair
# Or add to user data:
#!/bin/bash
echo "ssh-ed25519 AAAAC3Nza... your_email@example.com" >> /home/ubuntu/.ssh/authorized_keys
```

#### Step 3: Test Key-Based Authentication

```bash
# Test SSH with key
ssh -i ~/.ssh/id_ed25519_prod ubuntu@your-server-ip

# Should login without password prompt
```

#### Step 4: Configure SSH Client for Easy Access

Create or edit `~/.ssh/config`:
```bash
vi ~/.ssh/config
```

Add configuration:
```
# Production API Server
Host prod-api
    HostName 54.123.45.67
    User ubuntu
    Port 22
    IdentityFile ~/.ssh/id_ed25519_prod
    ServerAliveInterval 60
    ServerAliveCountMax 3

# Staging Server
Host staging-api
    HostName 54.123.45.68
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519_staging

# Development Server
Host dev-api
    HostName 54.123.45.69
    User deploy
    IdentityFile ~/.ssh/id_ed25519_dev

# Bastion Host
Host bastion
    HostName 54.123.45.70
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519_bastion
    
# Private servers through bastion
Host private-db
    HostName 10.0.1.50
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519_prod
    ProxyJump bastion
```

Set proper permissions:
```bash
chmod 600 ~/.ssh/config
```

Now you can connect simply:
```bash
ssh prod-api
ssh staging-api
ssh private-db  # automatically jumps through bastion
```

#### Step 5: Disable Password Authentication

**CRITICAL**: Only do this after verifying key-based auth works!

```bash
# On the server
sudo vi /etc/ssh/sshd_config
```

Modify these settings:
```ini
# Authentication
PubkeyAuthentication yes
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
PermitEmptyPasswords no
```

Restart SSH:
```bash
# Test config first
sudo sshd -t

# Restart SSH service
sudo systemctl restart sshd

# DON'T close your current session until you test from another terminal!
```

#### Step 6: Advanced SSH Hardening

```bash
sudo vi /etc/ssh/sshd_config
```

Complete hardened configuration:
```ini
# Port and Protocol
Port 2222
Protocol 2
AddressFamily inet

# Host Keys
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key

# Ciphers and Keying
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512

# Logging
SyslogFacility AUTH
LogLevel VERBOSE

# Authentication
LoginGraceTime 30
PermitRootLogin no
StrictModes yes
MaxAuthTries 3
MaxSessions 2
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM no

# Limit user logins
AllowUsers ubuntu deploy
# Or by group: AllowGroups sshusers

# Disable dangerous features
PermitUserEnvironment no
X11Forwarding no
PrintMotd no
PrintLastLog yes
TCPKeepAlive no
PermitTunnel no
Banner /etc/ssh/banner

# Connection settings
ClientAliveInterval 300
ClientAliveCountMax 2
MaxStartups 10:30:60
```

Create SSH banner:
```bash
sudo vi /etc/ssh/banner
```

Content:
```
***************************************************************************
                         AUTHORIZED ACCESS ONLY
                         
This system is for authorized use only. Unauthorized access is prohibited
and will be prosecuted to the full extent of the law.

All activities are monitored and logged.
***************************************************************************
```

Restart SSH:
```bash
sudo systemctl restart sshd
```

#### Step 7: Configure SSH Agent for Key Management

On your local machine:

```bash
# Start SSH agent
eval "$(ssh-agent -s)"

# Add key to agent (with passphrase)
ssh-add ~/.ssh/id_ed25519_prod

# List loaded keys
ssh-add -l

# Remove all keys
ssh-add -D
```

For persistent agent (add to `~/.bashrc` or `~/.zshrc`):
```bash
# SSH Agent setup
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519_prod
fi
```

#### Step 8: Implement SSH Key Rotation Policy

Create a key rotation script:

```bash
vi ~/rotate-ssh-keys.sh
```

```bash
#!/bin/bash
set -euo pipefail

# Configuration
KEY_TYPE="ed25519"
KEY_FILE="$HOME/.ssh/id_${KEY_TYPE}_prod"
SERVERS=(
    "ubuntu@prod-api-1.example.com"
    "ubuntu@prod-api-2.example.com"
    "ubuntu@staging-api.example.com"
)

echo "=== SSH Key Rotation Script ==="
echo "Current date: $(date)"

# Backup old key
if [ -f "$KEY_FILE" ]; then
    echo "Backing up old key..."
    cp "$KEY_FILE" "$KEY_FILE.backup.$(date +%Y%m%d)"
    cp "$KEY_FILE.pub" "$KEY_FILE.pub.backup.$(date +%Y%m%d)"
fi

# Generate new key
echo "Generating new SSH key..."
ssh-keygen -t "$KEY_TYPE" -C "rotation-$(date +%Y%m%d)" -f "$KEY_FILE" -N ""

# Deploy to servers
echo "Deploying new key to servers..."
for server in "${SERVERS[@]}"; do
    echo "Updating $server..."
    ssh-copy-id -i "$KEY_FILE.pub" "$server" || echo "Failed to update $server"
done

echo "=== Key rotation complete ==="
echo "Test new key before removing old one from servers!"
```

Make it executable:
```bash
chmod +x ~/rotate-ssh-keys.sh
```

#### Step 9: Set Up SSH Audit and Monitoring

Create audit script:

```bash
sudo vi /usr/local/bin/ssh-audit.sh
```

```bash
#!/bin/bash

# SSH Security Audit Script
echo "=== SSH Security Audit Report ==="
echo "Generated: $(date)"
echo ""

# Check SSH configuration
echo "=== SSH Configuration Issues ==="
sudo grep -E "PermitRootLogin yes|PasswordAuthentication yes|PermitEmptyPasswords yes" /etc/ssh/sshd_config && echo "⚠ WARNING: Insecure settings detected!" || echo "✓ SSH configuration looks secure"
echo ""

# Check for weak keys
echo "=== Weak SSH Keys Check ==="
find /home -name "authorized_keys" -exec sh -c 'echo "Checking {}"; grep -v "^#" {} | grep -E "ssh-rsa [^ ]* (1024|2048)" && echo "⚠ Weak RSA key found in {}"' \; || echo "✓ No weak keys detected"
echo ""

# Recent SSH logins
echo "=== Recent SSH Logins ==="
last -a -n 20
echo ""

# Failed login attempts
echo "=== Recent Failed Login Attempts ==="
grep "Failed password" /var/log/auth.log | tail -20 || echo "No recent failures"
echo ""

# Active SSH connections
echo "=== Active SSH Connections ==="
who
echo ""
ss -tn | grep :22
```

Make it executable and run:
```bash
sudo chmod +x /usr/local/bin/ssh-audit.sh
sudo /usr/local/bin/ssh-audit.sh
```

### Key Commands Summary

```bash
# Key generation
ssh-keygen -t ed25519 -C "comment" -f ~/.ssh/keyfile
ssh-keygen -t rsa -b 4096 -C "comment" -f ~/.ssh/keyfile

# Key deployment
ssh-copy-id -i ~/.ssh/key.pub user@host
cat ~/.ssh/key.pub | ssh user@host "cat >> ~/.ssh/authorized_keys"

# SSH connection
ssh -i ~/.ssh/key user@host
ssh -p 2222 user@host
ssh -o "ProxyJump=bastion" user@private-host

# SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/key
ssh-add -l
ssh-add -D

# Testing and debugging
ssh -v user@host                    # Verbose mode
ssh -vv user@host                   # More verbose
ssh -T git@github.com               # Test GitHub connection
sudo sshd -t                        # Test SSH config syntax
sudo systemctl status sshd          # Check SSH service

# Key management
ssh-keygen -l -f ~/.ssh/key.pub     # Show key fingerprint
ssh-keygen -R hostname              # Remove host from known_hosts
ssh-keygen -y -f ~/.ssh/private_key # Generate public key from private
```

### Verification

#### 1. Verify Key-Based Authentication Works

```bash
# Should login without password
ssh -i ~/.ssh/id_ed25519_prod ubuntu@your-server-ip

# Verify with verbose output
ssh -v -i ~/.ssh/id_ed25519_prod ubuntu@your-server-ip 2>&1 | grep "Offering public key"
```

#### 2. Confirm Password Authentication is Disabled

```bash
# Try to connect with password (should fail)
ssh -o PreferredAuthentications=password ubuntu@your-server-ip
# Expected: Permission denied (publickey)
```

#### 3. Check SSH Configuration

```bash
# On server
sudo sshd -t                                    # Syntax check
sudo sshd -T | grep -E "passwordauth|pubkeyauth|permitroot"  # Show effective config

# Expected output:
# passwordauthentication no
# pubkeyauthentication yes
# permitrootlogin no
```

#### 4. Verify Authorized Keys Permissions

```bash
# On server
ls -la ~/.ssh/
# drwx------ .ssh/          (700)
# -rw------- authorized_keys (600)

# Check permissions script
find ~/.ssh -type f -exec ls -l {} \; | awk '$1 !~ /^-rw-------/ {print "Wrong permissions:", $0}'
```

#### 5. Test SSH Agent

```bash
# List loaded keys
ssh-add -l

# Test connection using agent
ssh -A ubuntu@your-server-ip  # With agent forwarding
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Wrong File Permissions

**Problem**: SSH refuses key authentication

```bash
# Error in /var/log/auth.log:
# Authentication refused: bad ownership or modes for file /home/user/.ssh/authorized_keys
```

**Solution**:
```bash
# Fix permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 644 ~/.ssh/known_hosts
chmod 600 ~/.ssh/config

# Verify ownership
ls -la ~/.ssh/
# Should be owned by your user, not root
```

#### Mistake 2: Locking Yourself Out

**Problem**: Disabled password auth before testing keys

**Solution Prevention**:
```bash
# Always test in a new terminal BEFORE closing current session
# Keep current session open until verified

# Emergency access methods:
# 1. AWS Systems Manager Session Manager
aws ssm start-session --target i-1234567890abcdef0

# 2. EC2 Serial Console (if enabled)
# Access via AWS Console

# 3. Re-attach volume to another instance
```

#### Mistake 3: SELinux Blocking SSH Keys

**Problem**: Keys work on one server but not another (RHEL/CentOS)

**Solution**:
```bash
# Check SELinux status
getenforce

# Restore correct context
restorecon -R -v ~/.ssh

# Or temporarily set permissive mode to test
sudo setenforce 0

# Check audit log
sudo ausearch -m avc -ts recent
```

#### Mistake 4: SSH Agent Not Working

**Problem**: Agent forwarding doesn't work

**Solution**:
```bash
# Start agent
eval "$(ssh-agent -s)"

# Add key
ssh-add ~/.ssh/id_ed25519_prod

# Verify
echo $SSH_AUTH_SOCK    # Should show socket path
ssh-add -l             # Should list keys

# Enable agent forwarding in config
vi ~/.ssh/config
# Add: ForwardAgent yes

# Or use -A flag
ssh -A user@host
```

#### Mistake 5: Wrong Public Key Format

**Problem**: Key copied incorrectly (line breaks, spaces)

**Solution**:
```bash
# Public key should be single line
cat ~/.ssh/id_ed25519_prod.pub
# Should output one long line starting with "ssh-ed25519"

# On server, check authorized_keys
cat ~/.ssh/authorized_keys
# Each key should be on a single line

# Remove and re-add if needed
ssh-copy-id -i ~/.ssh/id_ed25519_prod.pub user@host
```

#### Troubleshooting: Debug SSH Connection Issues

```bash
# Maximum verbosity
ssh -vvv user@host

# Common issues to check:

# 1. Network connectivity
ping host
telnet host 22

# 2. SSH service running
sudo systemctl status sshd

# 3. Firewall allows SSH
sudo ufw status
sudo iptables -L -n | grep 22

# 4. Check server logs in real-time
# On server:
sudo tail -f /var/log/auth.log

# 5. Verify key is being offered
ssh -v user@host 2>&1 | grep "Offering public key"

# 6. Check authorized_keys
cat ~/.ssh/authorized_keys
```

### Interview Questions with Answers

#### Q1: What's the difference between RSA and ED25519 SSH keys?

**Answer**:
- **ED25519**: Modern elliptic curve algorithm
  - Faster performance
  - Smaller key size (68 characters vs 700+)
  - More secure against side-channel attacks
  - Fixed key size (256-bit)
  - Recommended for new deployments
  
- **RSA**: Traditional algorithm
  - Widely supported (including very old systems)
  - Requires larger key size for security (4096-bit)
  - Slower than ED25519
  - Use for compatibility with legacy systems

**Recommendation**: Use ED25519 unless compatibility with old systems is required.

#### Q2: How does SSH key-based authentication work?

**Answer**:
1. **Key Generation**: User generates a public/private key pair locally
2. **Public Key Distribution**: Public key is copied to server's `~/.ssh/authorized_keys`
3. **Connection Initiation**: Client connects and offers to authenticate with public key
4. **Challenge**: Server generates random data, encrypts with public key
5. **Response**: Client decrypts with private key, hashes with session ID
6. **Verification**: Server verifies the response matches
7. **Authentication**: If match, user is authenticated without transmitting the private key

Private key NEVER leaves the client machine.

#### Q3: What is SSH agent forwarding and when should you use it?

**Answer**:
**SSH Agent Forwarding** allows you to use your local SSH keys on a remote server without copying them:

```bash
ssh -A user@bastion
# From bastion, can now SSH to other servers using local keys
ssh internal-server
```

**When to use**:
- Jumping through bastion hosts
- Running Git operations on remote servers
- Deploying from jump boxes

**Security risks**:
- Anyone with root on intermediate server can use your agent
- Socket hijacking possible
- Better alternatives: ProxyJump, separate keys for automation

**Safer alternative**:
```bash
# Use ProxyJump instead
ssh -J bastion internal-server
```

#### Q4: How would you automate SSH access for CI/CD without storing private keys?

**Answer**:
**Best Practices**:

1. **Use deployment keys** (GitHub/GitLab):
```bash
# Generate deploy key without passphrase
ssh-keygen -t ed25519 -C "deploy-key" -f deploy_key -N ""
# Add public key to repo deploy keys (read-only)
```

2. **Use AWS Systems Manager Session Manager**:
```bash
# No SSH keys needed
aws ssm start-session --target i-instance-id
```

3. **Use short-lived credentials**:
```bash
# HashiCorp Vault SSH secrets engine
vault write ssh/creds/deploy ip=10.0.1.50
```

4. **Use EC2 Instance Connect**:
```bash
# Temporary SSH key pushed by AWS
aws ec2-instance-connect send-ssh-public-key \
    --instance-id i-instance-id \
    --availability-zone us-east-1a \
    --instance-os-user ubuntu \
    --ssh-public-key file://temp_key.pub
```

5. **Separate keys for automation**:
- Create dedicated key pairs for CI/CD
- Store in secure secret management (AWS Secrets Manager, Vault)
- Rotate regularly
- Minimal permissions

#### Q5: What are the security implications of using SSH with no passphrase?

**Answer**:
**Risks**:
- If private key file is stolen, immediate access to all systems
- No second factor of authentication
- Common requirement for automation (CI/CD)

**Mitigations**:
1. **Strict file permissions**: `chmod 600` on private key
2. **Separate keys for automation**: Different keys for manual vs automated access
3. **Short-lived credentials**: Use temporary keys that expire
4. **Restrict key usage**: Use `from=` in authorized_keys:
   ```
   from="192.168.1.0/24" ssh-ed25519 AAAAC3... jenkins
   ```
5. **Command restriction**:
   ```
   command="/usr/local/bin/deploy.sh" ssh-ed25519 AAAAC3... deploy
   ```
6. **Hardware keys**: YubiKey with SSH support
7. **Monitoring**: Alert on key usage from unexpected locations

**For manual access**: Always use passphrase
**For automation**: Use other mitigations above

#### Q6: How do you restrict SSH access to specific IP addresses?

**Answer**:
**Multiple layers**:

1. **Firewall level** (recommended):
```bash
# UFW
sudo ufw allow from 192.168.1.0/24 to any port 22

# iptables
sudo iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j DROP
```

2. **SSH configuration**:
```bash
# /etc/ssh/sshd_config
Match Address 192.168.1.0/24
    PasswordAuthentication yes
    
Match Address *
    PasswordAuthentication no
```

3. **authorized_keys restrictions**:
```
from="192.168.1.100,192.168.1.101" ssh-ed25519 AAAAC3... user
```

4. **TCP Wrappers**:
```bash
# /etc/hosts.allow
sshd: 192.168.1.0/24

# /etc/hosts.deny
sshd: ALL
```

5. **AWS Security Groups** (for EC2):
- Only allow SSH from specific IPs or security groups
- Best practice: Use bastion with restricted access

#### Q7: Explain the `authorized_keys` file format and options.

**Answer**:
**Basic format**:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... comment
```

**With options** (comma-separated, before key type):
```
option1,option2,option3 ssh-ed25519 AAAAC3... comment
```

**Common options**:

1. **Restrict source IP**:
```
from="192.168.1.100" ssh-ed25519 AAAAC3...
```

2. **Command restriction** (forced command):
```
command="/usr/local/bin/backup.sh" ssh-ed25519 AAAAC3...
```

3. **Disable features**:
```
no-port-forwarding,no-X11-forwarding,no-agent-forwarding ssh-ed25519 AAAAC3...
```

4. **Environment variables**:
```
environment="PATH=/usr/local/bin:/usr/bin" ssh-ed25519 AAAAC3...
```

5. **Combined example** (typical for automation):
```
from="10.0.1.50",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,command="/opt/deploy/run.sh" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGq... jenkins@ci-server
```

**Permissions**: Must be 600, owned by user, in home directory

#### Q8: How would you debug a "Permission denied (publickey)" error?

**Answer**:
**Systematic debugging**:

```bash
# 1. Verbose SSH connection
ssh -vvv user@host

# Look for:
# - "Offering public key" - which keys are tried
# - "Server refused our key" - key not accepted
# - Connection attempts and failures

# 2. Check local key exists
ls -la ~/.ssh/
cat ~/.ssh/id_ed25519.pub

# 3. Verify public key on server
ssh user@host "cat ~/.ssh/authorized_keys"

# 4. Check permissions on server
ssh user@host "ls -la ~/.ssh/"
# Must be:
# drwx------ .ssh (700)
# -rw------- authorized_keys (600)

# 5. Check SSH server logs
sudo tail -f /var/log/auth.log

# Common issues revealed:
# - "Authentication refused: bad ownership or modes"
# - SELinux denials
# - Wrong user/path

# 6. Verify SSH server config
sudo sshd -T | grep -i pubkey
# Should show: pubkeyauthentication yes

# 7. Check SELinux (RHEL/CentOS)
getenforce
sudo ausearch -m avc -ts recent

# 8. Restore SELinux context
restorecon -R -v ~/.ssh

# 9. Test with password temporarily
# In /etc/ssh/sshd_config:
# PasswordAuthentication yes
# Restart sshd, test, then disable again

# 10. Try different key
ssh -i ~/.ssh/another_key user@host
```

#### Q9: What's the difference between `~/.ssh/config` and `/etc/ssh/ssh_config`?

**Answer**:

**`~/.ssh/config`** (User-level):
- Per-user SSH client configuration
- Located in user's home directory
- Overrides system-wide config
- Used for personal preferences
- Example: host aliases, identity files

**`/etc/ssh/ssh_config`** (System-wide):
- Global SSH client configuration for all users
- Applied to all users on the system
- Requires root to edit
- Base configuration

**`/etc/ssh/sshd_config`** (Server):
- SSH server (daemon) configuration
- Controls how SSH server behaves
- Affects incoming connections
- Examples: PermitRootLogin, PasswordAuthentication

**Priority order**:
1. Command line options (`ssh -o Option=value`)
2. `~/.ssh/config` (user)
3. `/etc/ssh/ssh_config` (system-wide client)
4. `The SSH daemon uses /etc/ssh/sshd_config` (different file!)

#### Q10: How do you implement SSH certificate-based authentication?

**Answer**:
SSH certificates provide **centralized authentication** without distributing keys:

**Setup Certificate Authority (CA)**:
```bash
# 1. Generate CA key (secure this!)
ssh-keygen -t ed25519 -f ca_key -C "CA Key"

# 2. Configure sshd to trust CA
# /etc/ssh/sshd_config
TrustedUserCAKeys /etc/ssh/ca_key.pub

sudo systemctl restart sshd
```

**Issue User Certificate**:
```bash
# 3. User generates key
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# 4. User submits public key to CA

# 5. CA signs user's public key
ssh-keygen -s ca_key \
  -I john.doe \
  -n ubuntu,root \
  -V +52w \
  ~/.ssh/id_ed25519.pub

# Creates: ~/.ssh/id_ed25519-cert.pub
```

**User connects**:
```bash
# Certificate is automatically used
ssh ubuntu@server

# Certificate contains:
# - Valid principals (usernames)
# - Expiration date
# - Serial number
# - Signature from CA
```

**Benefits**:
- No need to distribute keys to every server
- Centralized revocation
- Time-limited access
- Audit trail (serial numbers)
- Used by large organizations (Google, Facebook)

**Certificate details**:
```bash
ssh-keygen -L -f ~/.ssh/id_ed25519-cert.pub
```

---

