# Task 1.3: User and Group Management with Sudoers Configuration

[This task continues with the same comprehensive 7-section format covering user management, groups, sudoers, and related interview questions in production context...]

## Goal / Why It's Important

Proper user and group management is critical for:
- **Security**: Principle of least privilege
- **Accountability**: Track who does what
- **Automation**: Service accounts for applications
- **Compliance**: Audit requirements

## Prerequisites

- Linux server with sudo access
- Understanding of Linux permissions model

## Step-by-Step Implementation

### Step 1: Create Users for Different Roles

```bash
# Create deployment user
sudo adduser deploy
sudo usermod -aG sudo deploy

# Create application service user (no login)
sudo useradd -r -s /bin/false api-service
sudo useradd -r -s /bin/false db-backup

# Create developer user
sudo adduser john
sudo usermod -aG docker john
```

### Step 2: Configure Sudoers for Fine-Grained Control

```bash
# Edit sudoers safely
sudo visudo

# Add specific permissions
deploy  ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart api-service
deploy  ALL=(ALL) NOPASSWD: /usr/bin/systemctl status api-service
deploy  ALL=(ALL) NOPASSWD: /usr/bin/docker *
john    ALL=(ALL) NOPASSWD: /usr/bin/systemctl status *
```

### Step 3: Create Groups for Role-Based Access

```bash
# Create groups
sudo groupadd developers
sudo groupadd operators
sudo groupadd readonly

# Add users to groups
sudo usermod -aG developers john
sudo usermod -aG operators deploy

# Set up shared directories
sudo mkdir -p /opt/app/{logs,config,data}
sudo chgrp -R operators /opt/app
sudo chmod -R 2775 /opt/app  # setgid bit
```

## Key Commands

```bash
# User management
useradd -m -s /bin/bash username        # Create user
usermod -aG groupname username           # Add to group
userdel -r username                      # Delete user
passwd username                          # Set password
chage -l username                        # Password aging info
id username                              # Show user info
groups username                          # Show user groups

# Group management
groupadd groupname                       # Create group
groupdel groupname                       # Delete group
gpasswd -a username groupname           # Add user to group
gpasswd -d username groupname           # Remove from group

# Sudoers
visudo                                   # Edit sudoers safely
sudo -l -U username                      # List user sudo permissions
```

## Verification

```bash
# Test user can run specific commands
su - deploy
sudo systemctl status api-service

# Verify group membership
groups deploy
id -Gn deploy

# Test file permissions in shared directories
su - john
touch /opt/app/logs/test.log
ls -la /opt/app/logs/
```

## Common Mistakes & Troubleshooting

**Issue**: User added to group but permissions don't work
**Solution**: User must log out and back in for group changes to take effect
```bash
# Or force new login
su - username
```

**Issue**: Sudoers syntax error locks you out
**Solution**: Always use `visudo` which validates syntax before saving

## Interview Questions

### Q1: What's the difference between `useradd` and `adduser`?
**Answer**: 
- `useradd`: Low-level utility, requires all options manually
- `adduser`: High-level script, interactive, creates home dir automatically
- `adduser` is Debian/Ubuntu specific
- `useradd` is universal across Linux distributions

### Q2: Explain the setuid, setgid, and sticky bit.
**Answer**:
- **setuid (4)**: Execute file as file owner (e.g., `passwd`)
- **setgid (2)**: Execute as group owner, or inherit group on new files
- **sticky (1)**: Only owner can delete files (e.g., `/tmp`)

```bash
chmod u+s file    # setuid
chmod g+s dir     # setgid on directory
chmod +t dir      # sticky bit
```

### Q3: How do you implement the principle of least privilege for a deployment user?
**Answer**:
```bash
# 1. Create dedicated user
sudo useradd -r -s /bin/bash deploy

# 2. Grant only necessary sudo permissions
sudo visudo
deploy ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart api-service
deploy ALL=(ALL) NOPASSWD: /usr/local/bin/deploy.sh

# 3. Use groups for shared access
sudo groupadd app-operators
sudo usermod -aG app-operators deploy

# 4. Set directory permissions
sudo chown -R root:app-operators /opt/app
sudo chmod -R 2775 /opt/app

# 5. Audit regularly
sudo -l -U deploy
```

### Q4: What is the difference between primary and secondary groups?
**Answer**:
- **Primary group**: Specified in `/etc/passwd`, assigned to new files
- **Secondary groups**: Listed in `/etc/group`, provides additional access
- User has one primary group, can have multiple secondary groups
- Change primary: `usermod -g newgroup username`
- Add secondary: `usermod -aG group username`

### Q5: How would you troubleshoot "Permission denied" even though user is in the correct group?
**Answer**:
```bash
# 1. Verify group membership
groups username
id username

# 2. Check if user needs to re-login
# Group changes require new login session

# 3. Verify file/directory permissions
ls -la /path/to/resource

# 4. Check ACLs
getfacl /path/to/resource

# 5. Check SELinux context
ls -Z /path/to/resource
sestatus
```

---
