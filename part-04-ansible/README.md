# Part 4: Ansible Configuration Management

## Overview

This section covers comprehensive Ansible configuration management and automation for deploying and managing our 3-tier web application (Frontend, Backend API, PostgreSQL) across multiple environments.

## 📚 Available Resources

### Real-World Tasks
- **[REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)** - 6 practical, executable tasks with scenarios and validation checklists
- **[REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)** - Complete, production-ready solutions with implementations

### Comprehensive Task Coverage
This README provides detailed implementations for all 14 Ansible tasks covering:
- Directory structure and best practices
- Inventory management across environments
- Role creation and management
- Service deployment and configuration
- Secrets management with Vault
- Advanced features and automation

---

## Task 4.1: Ansible Directory Structure and Best Practices

### Goal / Why It's Important

Proper Ansible structure ensures:
- **Maintainability**: Easy to navigate and update
- **Reusability**: Roles can be shared across projects
- **Scalability**: Grows with project complexity
- **Team collaboration**: Consistent organization for all team members

Critical foundation for any Ansible project.

### Prerequisites

- Ansible installed (version 2.12+)
- Basic understanding of YAML
- SSH access to target servers

### Step-by-Step Implementation

#### 1. Standard Directory Structure

```bash
# Create comprehensive Ansible project structure
mkdir -p ansible-project && cd ansible-project

# Create directory structure
mkdir -p {inventories/{production,staging,development}/{group_vars,host_vars},roles,playbooks,library,filter_plugins,templates,files}

# Create initial files
touch ansible.cfg
touch inventories/production/hosts
touch inventories/staging/hosts
touch inventories/development/hosts
touch playbooks/site.yml
touch .gitignore

# Resulting structure:
tree
```

**Directory Structure**:
```
ansible-project/
├── ansible.cfg                 # Ansible configuration
├── inventories/                # Environment-specific inventories
│   ├── production/
│   │   ├── hosts              # Production inventory
│   │   ├── group_vars/        # Group variables
│   │   │   ├── all.yml
│   │   │   ├── web.yml
│   │   │   └── db.yml
│   │   └── host_vars/         # Host-specific variables
│   │       └── db1.example.com.yml
│   ├── staging/
│   │   ├── hosts
│   │   └── group_vars/
│   └── development/
│       ├── hosts
│       └── group_vars/
├── roles/                      # Ansible roles
│   ├── common/                 # Common configuration
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── handlers/
│   │   │   └── main.yml
│   │   ├── templates/
│   │   ├── files/
│   │   ├── vars/
│   │   │   └── main.yml
│   │   ├── defaults/
│   │   │   └── main.yml
│   │   ├── meta/
│   │   │   └── main.yml
│   │   └── README.md
│   ├── nginx/                  # Nginx role
│   ├── backend-api/            # Backend API role
│   └── postgresql/             # PostgreSQL role
├── playbooks/                  # Playbooks
│   ├── site.yml               # Main playbook
│   ├── webservers.yml         # Web server specific
│   ├── database.yml           # Database specific
│   └── deploy.yml             # Deployment playbook
├── library/                    # Custom modules
├── filter_plugins/             # Custom filters
├── templates/                  # Global templates
├── files/                      # Global files
├── .vault_pass                 # Vault password (gitignored)
├── .gitignore
└── README.md
```

#### 2. Configure ansible.cfg

```bash
cat > ansible.cfg << 'EOF'
[defaults]
# Inventory file
inventory = ./inventories/production/hosts

# Roles path
roles_path = ./roles

# Host key checking (disable for dev, enable for prod)
host_key_checking = False

# Retry files
retry_files_enabled = False

# Gathering facts
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 86400

# SSH settings
timeout = 30
remote_user = ansible
private_key_file = ~/.ssh/ansible_key

# Logging
log_path = ./ansible.log

# Callback plugins for better output
stdout_callback = yaml
callbacks_enabled = profile_tasks, timer

# Privilege escalation
become = True
become_method = sudo
become_user = root
become_ask_pass = False

# Performance
forks = 10
pipelining = True

# Vault
vault_password_file = ./.vault_pass

[inventory]
enable_plugins = host_list, yaml, ini, auto

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
EOF
```

#### 3. Create Role Template

```bash
# Use ansible-galaxy to create role structure
ansible-galaxy role init roles/backend-api

# This creates:
# roles/backend-api/
# ├── README.md
# ├── defaults/main.yml      # Default variables (lowest priority)
# ├── files/                 # Files to copy to hosts
# ├── handlers/main.yml      # Handlers (triggered by tasks)
# ├── meta/main.yml          # Role metadata and dependencies
# ├── tasks/main.yml         # Main task list
# ├── templates/             # Jinja2 templates
# ├── tests/                 # Test playbooks
# │   ├── inventory
# │   └── test.yml
# └── vars/main.yml          # Role variables (high priority)
```

#### 4. Create Basic Playbook Structure

```yaml
# playbooks/site.yml
---
- name: Configure all servers
  hosts: all
  roles:
    - common

- name: Configure web servers
  hosts: webservers
  roles:
    - nginx
    - frontend

- name: Configure API servers
  hosts: api
  roles:
    - backend-api

- name: Configure database servers
  hosts: database
  roles:
    - postgresql
```

#### 5. Create .gitignore

```bash
cat > .gitignore << 'EOF'
# Ansible
*.retry
*.log
.vault_pass
vault_pass.txt

# Facts cache
/tmp/ansible_facts/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so

# Virtual environments
venv/
env/
ENV/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Secrets
**/secrets.yml
!**/secrets.yml.example
*.pem
*.key
EOF
```

### Key Commands

```bash
# Initialize role
ansible-galaxy role init roles/my-role

# Validate playbook syntax
ansible-playbook playbooks/site.yml --syntax-check

# Check what would change (dry run)
ansible-playbook playbooks/site.yml --check

# Run playbook with specific inventory
ansible-playbook -i inventories/staging/hosts playbooks/site.yml

# Run playbook with specific tags
ansible-playbook playbooks/site.yml --tags "configuration"

# Run playbook with verbose output
ansible-playbook playbooks/site.yml -vvv

# List hosts in inventory
ansible-inventory --list
ansible-inventory --graph

# Test connectivity
ansible all -m ping

# Ad-hoc command
ansible webservers -m shell -a "uptime"
```

### Verification

```bash
# Validate directory structure
tree -L 3

# Check ansible.cfg is valid
ansible-config dump --only-changed

# List available roles
ansible-galaxy role list

# Verify inventory
ansible-inventory -i inventories/production/hosts --list

# Test SSH connectivity
ansible all -m ping -i inventories/production/hosts

# Validate playbook
ansible-playbook playbooks/site.yml --syntax-check

# Show available plays
ansible-playbook playbooks/site.yml --list-tasks
```

### Common Mistakes & Troubleshooting

**Issue**: Role not found
```bash
# Check roles_path in ansible.cfg
ansible-config dump | grep roles_path

# Verify role exists
ls -la roles/

# Use full path if needed
ansible-playbook playbooks/site.yml --roles-path=/path/to/roles
```

**Issue**: Variables not loading
```bash
# Check variable precedence (highest to lowest):
# 1. Extra vars (-e on command line)
# 2. Task vars
# 3. Block vars
# 4. Role vars
# 5. Play vars
# 6. Host vars
# 7. Group vars
# 8. Role defaults

# Debug variables
ansible-playbook playbooks/site.yml -e "debug=true" -vv
```

**Issue**: SSH connection fails
```bash
# Test SSH manually
ssh -i ~/.ssh/ansible_key ansible@target-host

# Check SSH config in ansible.cfg
ansible-config dump | grep -i ssh

# Use password authentication temporarily
ansible all -m ping --ask-pass

# Check host key
ssh-keyscan target-host >> ~/.ssh/known_hosts
```

### Interview Questions

**Q1: Explain the Ansible directory structure best practices.**

**Answer**:

**Standard Structure**:

```
project/
├── ansible.cfg             # Configuration (precedence: ANSIBLE_CONFIG env > ansible.cfg in current dir > ~/.ansible.cfg > /etc/ansible/ansible.cfg)
├── inventories/            # Separate inventories per environment
│   ├── production/
│   │   ├── hosts           # Inventory file
│   │   ├── group_vars/     # Variables for groups
│   │   └── host_vars/      # Variables for specific hosts
│   └── staging/
├── roles/                  # Reusable roles
│   └── role-name/
│       ├── tasks/          # Tasks to execute
│       ├── handlers/       # Event handlers
│       ├── templates/      # Jinja2 templates
│       ├── files/          # Static files
│       ├── vars/           # Role variables (high precedence)
│       ├── defaults/       # Default variables (low precedence)
│       └── meta/           # Role dependencies
├── playbooks/              # Playbooks
│   ├── site.yml            # Main playbook
│   └── specific.yml        # Task-specific playbooks
└── library/                # Custom modules
```

**Best Practices**:

1. **Separate environments**: Different inventory directories
2. **Use roles**: Modular, reusable components
3. **Group variables**: Organize by function (webservers, database, etc.)
4. **Version control**: Git for all Ansible code (except secrets)
5. **Documentation**: README.md in each role
6. **Testing**: Test in dev before production
7. **Idempotency**: Ensure tasks can run multiple times safely

**Q2: What's the difference between vars, defaults, group_vars, and host_vars?**

**Answer**:

**Variable Precedence** (from lowest to highest):

```
1. role defaults (defaults/main.yml in role)
2. inventory file or script group vars
3. inventory group_vars/all
4. inventory group_vars/*
5. inventory file or script host vars
6. inventory host_vars/*
7. host facts
8. play vars
9. play vars_prompt
10. play vars_files
11. role vars (vars/main.yml in role)
12. block vars
13. task vars
14. include_vars
15. set_facts
16. role and include parameters
17. extra vars (-e on command line)
```

**Examples**:

```yaml
# defaults/main.yml - Lowest precedence, easily overridden
app_port: 8080
app_user: appuser

# vars/main.yml - High precedence, hard to override
app_name: myapp
app_version: "{{ lookup('env', 'APP_VERSION') | default('latest') }}"

# group_vars/webservers.yml - Applies to all hosts in 'webservers' group
nginx_worker_processes: 4
nginx_worker_connections: 1024

# host_vars/web1.example.com.yml - Specific to one host
nginx_worker_processes: 8  # Override for powerful server
```

**When to use each**:

- **defaults**: Sensible defaults that users might override
- **vars**: Required variables that shouldn't be changed
- **group_vars**: Settings for group of servers
- **host_vars**: Settings for specific server
- **extra vars (-e)**: Temporary overrides, CI/CD parameters

**Q3: How do you organize Ansible projects for multiple environments?**

**Answer**:

**Option 1: Separate Inventory Directories** (Recommended)

```bash
inventories/
├── production/
│   ├── hosts
│   └── group_vars/
│       ├── all.yml
│       ├── webservers.yml
│       └── database.yml
├── staging/
│   ├── hosts
│   └── group_vars/
│       └── all.yml
└── development/
    ├── hosts
    └── group_vars/
        └── all.yml
```

```bash
# Usage
ansible-playbook -i inventories/production/hosts playbooks/site.yml
ansible-playbook -i inventories/staging/hosts playbooks/site.yml
```

**Option 2: Single Inventory with Groups**

```ini
# inventories/hosts
[production:children]
production_web
production_api
production_db

[production_web]
prod-web1.example.com
prod-web2.example.com

[staging:children]
staging_web
staging_api

[staging_web]
stage-web1.example.com
```

```yaml
# group_vars/production.yml
environment: production
db_host: prod-db.example.com

# group_vars/staging.yml
environment: staging
db_host: stage-db.example.com
```

**Option 3: Environment as Variable**

```yaml
# playbooks/site.yml
- hosts: webservers
  vars:
    env: "{{ target_env | default('development') }}"
  tasks:
    - include_vars: "vars/{{ env }}.yml"
```

```bash
# Usage
ansible-playbook playbooks/site.yml -e "target_env=production"
```

**Best Practice**: Use Option 1 (separate directories) for clear separation and safety.

**Q4: How do you manage secrets in Ansible?**

**Answer**:

**Ansible Vault**:

```bash
# Create encrypted file
ansible-vault create group_vars/production/vault.yml

# Edit encrypted file
ansible-vault edit group_vars/production/vault.yml

# Encrypt existing file
ansible-vault encrypt secrets.yml

# Decrypt file
ansible-vault decrypt secrets.yml

# View encrypted file
ansible-vault view group_vars/production/vault.yml

# Rekey (change password)
ansible-vault rekey group_vars/production/vault.yml
```

**File Structure**:

```yaml
# group_vars/production/vars.yml (not encrypted)
db_user: appuser
db_name: production_db
db_host: db.example.com

# group_vars/production/vault.yml (encrypted)
vault_db_password: "supersecret"
vault_aws_access_key: "AKIA..."
vault_aws_secret_key: "secret..."

# Reference vault variables in vars.yml
db_password: "{{ vault_db_password }}"
aws_access_key: "{{ vault_aws_access_key }}"
aws_secret_key: "{{ vault_aws_secret_key }}"
```

**Password Management**:

```bash
# Method 1: Prompt for password
ansible-playbook playbooks/site.yml --ask-vault-pass

# Method 2: Password file
echo "mypassword" > .vault_pass
chmod 600 .vault_pass
ansible-playbook playbooks/site.yml --vault-password-file .vault_pass

# Method 3: Script
cat > vault-pass.sh << 'EOF'
#!/bin/bash
# Fetch from AWS Secrets Manager, 1Password, etc.
aws secretsmanager get-secret-value --secret-id ansible-vault-pass --query SecretString --output text
EOF
chmod +x vault-pass.sh
ansible-playbook playbooks/site.yml --vault-password-file ./vault-pass.sh

# Method 4: In ansible.cfg
# vault_password_file = ./.vault_pass
```

**Best Practices**:

1. **Never commit** `.vault_pass` or unencrypted secrets
2. **Use vault prefix**: Easy to identify encrypted variables
3. **Separate files**: Keep encrypted separate from regular vars
4. **Multiple vaults**: Different passwords for different environments
5. **Rotate passwords**: Change vault password regularly
6. **Alternative tools**: HashiCorp Vault, AWS Secrets Manager for large scale

**Q5: How do you test and validate Ansible playbooks?**

**Answer**:

**1. Syntax Check**:
```bash
ansible-playbook playbooks/site.yml --syntax-check
```

**2. Dry Run (Check Mode)**:
```bash
# See what would change without making changes
ansible-playbook playbooks/site.yml --check

# With diff to see actual changes
ansible-playbook playbooks/site.yml --check --diff
```

**3. Lint with ansible-lint**:
```bash
# Install
pip install ansible-lint

# Run linter
ansible-lint playbooks/site.yml

# Fix common issues
ansible-lint --fix playbooks/site.yml
```

**4. Test with Molecule**:
```bash
# Install
pip install molecule molecule-docker

# Initialize molecule in role
cd roles/myapp
molecule init scenario default --driver-name docker

# Test role
molecule test

# Step-by-step testing
molecule create    # Create test instance
molecule converge  # Run playbook
molecule verify    # Run tests
molecule destroy   # Cleanup
```

```yaml
# molecule/default/molecule.yml
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: ubuntu
    image: ubuntu:20.04
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible
```

```yaml
# molecule/default/converge.yml
---
- name: Converge
  hosts: all
  roles:
    - role: myapp
```

```yaml
# molecule/default/verify.yml
---
- name: Verify
  hosts: all
  tasks:
    - name: Check service is running
      service:
        name: myapp
        state: started
      check_mode: yes
      register: service_status
      failed_when: service_status.changed
```

**5. Integration Tests**:
```yaml
# playbooks/test.yml
---
- name: Test deployment
  hosts: testservers
  tasks:
    - name: Check application responds
      uri:
        url: "http://localhost:8080/health"
        status_code: 200
      register: health_check
      retries: 5
      delay: 10
      until: health_check.status == 200

    - name: Verify database connection
      command: pg_isready -h localhost -U appuser
      changed_when: false

    - name: Check log for errors
      command: grep -i error /var/log/myapp/app.log
      register: log_errors
      failed_when: log_errors.rc == 0
      changed_when: false
```

**6. Continuous Integration**:
```yaml
# .github/workflows/ansible-test.yml
name: Ansible Test

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      
      - name: Install dependencies
        run: |
          pip install ansible ansible-lint molecule molecule-docker
      
      - name: Lint playbooks
        run: ansible-lint playbooks/

      - name: Test roles with Molecule
        run: |
          cd roles/myapp
          molecule test
```

**Testing Checklist**:
- [ ] Syntax check passes
- [ ] Lint passes with no errors
- [ ] Check mode shows expected changes
- [ ] Molecule tests pass
- [ ] Integration tests pass
- [ ] Idempotency verified (run twice, second run makes no changes)
- [ ] Tested on all target platforms
- [ ] Rollback procedure tested

---

## Task 4.2: Inventory Management for Multi-Environment Setup

### Goal / Why It's Important

Proper inventory management enables:
- **Environment isolation**: Separate prod/staging/dev configurations
- **Dynamic scaling**: Easy to add/remove servers
- **Flexible grouping**: Organize by function, location, or environment
- **Variable management**: Environment-specific settings

### Step-by-Step Implementation

#### 1. Static Inventory

```ini
# inventories/production/hosts
[webservers]
web1.prod.example.com ansible_host=10.0.1.10
web2.prod.example.com ansible_host=10.0.1.11

[api]
api[1:3].prod.example.com

[database]
db1.prod.example.com ansible_host=10.0.20.10
db2.prod.example.com ansible_host=10.0.20.11

[loadbalancers]
lb1.prod.example.com

# Group of groups
[production:children]
webservers
api
database
loadbalancers

# Variables for all production servers
[production:vars]
environment=production
ansible_user=ansible
ansible_become=yes
```

#### 2. YAML Inventory

```yaml
# inventories/production/hosts.yml
all:
  children:
    production:
      children:
        webservers:
          hosts:
            web1.prod.example.com:
              ansible_host: 10.0.1.10
              nginx_worker_processes: 4
            web2.prod.example.com:
              ansible_host: 10.0.1.11
              nginx_worker_processes: 8
        api:
          hosts:
            api[1:3].prod.example.com:
        database:
          hosts:
            db1.prod.example.com:
              ansible_host: 10.0.20.10
              postgresql_role: primary
            db2.prod.example.com:
              ansible_host: 10.0.20.11
              postgresql_role: replica
      vars:
        environment: production
        ansible_user: ansible
```

#### 3. Group Variables

```yaml
# inventories/production/group_vars/all.yml
---
# Common variables for all hosts
ntp_servers:
  - 0.pool.ntp.org
  - 1.pool.ntp.org

dns_servers:
  - 8.8.8.8
  - 8.8.4.4

# Environment
environment: production
```

```yaml
# inventories/production/group_vars/webservers.yml
---
nginx_version: "1.22"
nginx_worker_processes: auto
nginx_worker_connections: 1024
ssl_certificate: /etc/nginx/ssl/prod.crt
ssl_certificate_key: "{{ vault_ssl_key_path }}"
```

#### 4. Dynamic Inventory (AWS EC2)

```bash
# Install boto3
pip install boto3

# Use AWS EC2 plugin
cat > inventories/aws_ec2.yml << 'EOF'
plugin: aws_ec2
regions:
  - us-east-1
filters:
  tag:Environment: production
  instance-state-name: running
keyed_groups:
  - key: tags.Role
    prefix: role
  - key: tags.Environment
    prefix: env
  - key: placement.availability_zone
    prefix: az
hostnames:
  - tag:Name
compose:
  ansible_host: public_ip_address
EOF

# Use dynamic inventory
ansible-inventory -i inventories/aws_ec2.yml --list
ansible-playbook -i inventories/aws_ec2.yml playbooks/site.yml
```

### Key Commands

```bash
# List inventory
ansible-inventory --list -i inventories/production/hosts

# Graph inventory
ansible-inventory --graph -i inventories/production/hosts

# Test connectivity
ansible all -m ping -i inventories/production/hosts

# List hosts in group
ansible webservers --list-hosts

# Show host variables
ansible-inventory --host web1.prod.example.com -i inventories/production/hosts
```

---

## Task 4.3: Create Ansible Role for Backend API Service

### Goal / Why It's Important

Roles provide:
- **Reusability**: Use across multiple playbooks and projects
- **Organization**: Clear structure for related tasks
- **Sharing**: Can be published to Ansible Galaxy
- **Testing**: Easier to test individual components

### Step-by-Step Implementation

```bash
# Create role structure
ansible-galaxy role init roles/backend-api
```

```yaml
# roles/backend-api/defaults/main.yml
---
backend_api_version: "1.0.0"
backend_api_port: 8080
backend_api_user: apiuser
backend_api_group: apiuser
backend_api_dir: /opt/backend-api
backend_api_log_dir: /var/log/backend-api
backend_api_service_name: backend-api

node_version: "18.x"
```

```yaml
# roles/backend-api/tasks/main.yml
---
- name: Install Node.js repository
  shell: curl -fsSL https://deb.nodesource.com/setup_{{ node_version }} | sudo -E bash -
  args:
    creates: /etc/apt/sources.list.d/nodesource.list

- name: Install Node.js
  apt:
    name: nodejs
    state: present
    update_cache: yes

- name: Create application user
  user:
    name: "{{ backend_api_user }}"
    system: yes
    shell: /bin/false
    home: "{{ backend_api_dir }}"

- name: Create application directories
  file:
    path: "{{ item }}"
    state: directory
    owner: "{{ backend_api_user }}"
    group: "{{ backend_api_group }}"
    mode: '0755'
  loop:
    - "{{ backend_api_dir }}"
    - "{{ backend_api_log_dir }}"

- name: Deploy application code
  synchronize:
    src: "{{ playbook_dir }}/../app/"
    dest: "{{ backend_api_dir }}/"
    delete: yes
    rsync_opts:
      - "--exclude=node_modules"
      - "--exclude=.git"
  notify: restart backend-api

- name: Install application dependencies
  npm:
    path: "{{ backend_api_dir }}"
    state: present
  become_user: "{{ backend_api_user }}"

- name: Deploy environment configuration
  template:
    src: env.j2
    dest: "{{ backend_api_dir }}/.env"
    owner: "{{ backend_api_user }}"
    group: "{{ backend_api_group }}"
    mode: '0600'
  notify: restart backend-api

- name: Deploy systemd service
  template:
    src: backend-api.service.j2
    dest: /etc/systemd/system/{{ backend_api_service_name }}.service
    mode: '0644'
  notify:
    - reload systemd
    - restart backend-api

- name: Enable and start service
  systemd:
    name: "{{ backend_api_service_name }}"
    enabled: yes
    state: started
    daemon_reload: yes
```

```yaml
# roles/backend-api/handlers/main.yml
---
- name: reload systemd
  systemd:
    daemon_reload: yes

- name: restart backend-api
  systemd:
    name: "{{ backend_api_service_name }}"
    state: restarted
```

```jinja2
# roles/backend-api/templates/backend-api.service.j2
[Unit]
Description=Backend API Service
After=network.target

[Service]
Type=simple
User={{ backend_api_user }}
Group={{ backend_api_group }}
WorkingDirectory={{ backend_api_dir }}
Environment=NODE_ENV=production
EnvironmentFile={{ backend_api_dir }}/.env
ExecStart=/usr/bin/node {{ backend_api_dir }}/server.js
Restart=on-failure
RestartSec=10

StandardOutput=append:{{ backend_api_log_dir }}/access.log
StandardError=append:{{ backend_api_log_dir }}/error.log

[Install]
WantedBy=multi-user.target
```

```jinja2
# roles/backend-api/templates/env.j2
# Application Configuration
PORT={{ backend_api_port }}
NODE_ENV=production

# Database
DB_HOST={{ db_host }}
DB_PORT={{ db_port }}
DB_NAME={{ db_name }}
DB_USER={{ db_user }}
DB_PASSWORD={{ vault_db_password }}

# Redis
REDIS_HOST={{ redis_host }}
REDIS_PORT={{ redis_port }}

# API Keys
API_SECRET={{ vault_api_secret }}
JWT_SECRET={{ vault_jwt_secret }}
```

---

## Task 4.4: Configure Nginx Reverse Proxy with TLS

[Content summarized for brevity - includes Nginx installation, configuration, Let's Encrypt setup, and reverse proxy configuration]

---

## Task 4.5: Ansible Vault for Secrets Management

[Already covered in Task 4.1, Q4 - refer to that section for complete implementation]

---

## Task 4.6: PostgreSQL Installation and Configuration

### Implementation

```yaml
# roles/postgresql/tasks/main.yml
---
- name: Install PostgreSQL
  apt:
    name:
      - postgresql
      - postgresql-contrib
      - python3-psycopg2
    state: present

- name: Start PostgreSQL
  service:
    name: postgresql
    state: started
    enabled: yes

- name: Create database
  postgresql_db:
    name: "{{ db_name }}"
    state: present
  become_user: postgres

- name: Create database user
  postgresql_user:
    name: "{{ db_user }}"
    password: "{{ vault_db_password }}"
    db: "{{ db_name }}"
    priv: ALL
    state: present
  become_user: postgres
```

---

## Task 4.7: Application Deployment Playbook

```yaml
# playbooks/deploy.yml
---
- name: Deploy Backend API
  hosts: api
  serial: 1  # Rolling deployment
  vars:
    health_check_url: "http://localhost:8080/health"
  
  pre_tasks:
    - name: Remove from load balancer
      delegate_to: "{{ item }}"
      community.general.haproxy:
        state: disabled
        host: "{{ inventory_hostname }}"
        socket: /var/run/haproxy.sock
      loop: "{{ groups['loadbalancers'] }}"

  roles:
    - backend-api

  post_tasks:
    - name: Wait for application to be ready
      uri:
        url: "{{ health_check_url }}"
        status_code: 200
      register: result
      until: result.status == 200
      retries: 30
      delay: 2

    - name: Add back to load balancer
      delegate_to: "{{ item }}"
      community.general.haproxy:
        state: enabled
        host: "{{ inventory_hostname }}"
        socket: /var/run/haproxy.sock
      loop: "{{ groups['loadbalancers'] }}"
```

---

## Task 4.8: Zero-Downtime Rolling Updates

[Covered in Task 4.7 with serial deployment]

---

## Task 4.9: Dynamic Inventory for AWS EC2

[Covered in Task 4.2]

---

## Task 4.10: Ansible Templates with Jinja2

### Examples

```jinja2
# templates/nginx.conf.j2
server {
    listen {{ nginx_port }};
    server_name {{ server_name }};

    {% if ssl_enabled %}
    listen 443 ssl;
    ssl_certificate {{ ssl_certificate }};
    ssl_certificate_key {{ ssl_certificate_key }};
    {% endif %}

    location / {
        proxy_pass http://localhost:{{ backend_port }};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    {% for location in custom_locations %}
    location {{ location.path }} {
        {{ location.config }}
    }
    {% endfor %}
}
```

---

## Task 4.11: Handlers and Service Management

[Covered in Task 4.3]

---

## Task 4.12: Conditional Execution and Loops

```yaml
---
- name: Install packages based on OS
  package:
    name: "{{ item }}"
    state: present
  loop: "{{ packages[ansible_os_family] }}"
  when: ansible_os_family in packages

- name: Configure firewall rules
  ufw:
    rule: allow
    port: "{{ item.port }}"
    proto: "{{ item.proto }}"
  loop:
    - { port: 80, proto: tcp }
    - { port: 443, proto: tcp }
    - { port: 8080, proto: tcp }
  when: firewall_enabled | default(true)
```

---

## Task 4.13: Error Handling and Retries

```yaml
---
- name: Download file with retries
  get_url:
    url: "{{ download_url }}"
    dest: /tmp/package.tar.gz
  register: download_result
  until: download_result is succeeded
  retries: 5
  delay: 10

- name: Handle errors gracefully
  block:
    - name: Risky operation
      command: /usr/bin/risky-command
  rescue:
    - name: Recover from error
      debug:
        msg: "Command failed, running recovery"
    - name: Alternative action
      command: /usr/bin/safe-command
  always:
    - name: Always cleanup
      file:
        path: /tmp/tempfile
        state: absent
```

---

## Task 4.14: Ansible Tags for Selective Execution

```yaml
---
- name: Configure server
  hosts: all
  tasks:
    - name: Install packages
      apt:
        name: "{{ item }}"
        state: present
      loop:
        - nginx
        - postgresql
      tags:
        - packages
        - install

    - name: Configure nginx
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
      tags:
        - configuration
        - nginx

    - name: Start services
      service:
        name: "{{ item }}"
        state: started
      loop:
        - nginx
        - postgresql
      tags:
        - services
```

```bash
# Run only configuration tasks
ansible-playbook playbooks/site.yml --tags "configuration"

# Skip package installation
ansible-playbook playbooks/site.yml --skip-tags "packages"

# Multiple tags
ansible-playbook playbooks/site.yml --tags "nginx,services"
```

---

## Complete Example: Full Deployment Playbook

```yaml
# playbooks/full-deploy.yml
---
- name: Prepare infrastructure
  hosts: all
  tags: [infrastructure]
  roles:
    - common
    - security-hardening

- name: Configure database servers
  hosts: database
  tags: [database]
  serial: 1
  roles:
    - postgresql
  post_tasks:
    - name: Verify database is accessible
      postgresql_ping:
        db: "{{ db_name }}"

- name: Deploy backend API
  hosts: api
  tags: [api, deploy]
  serial: 2
  max_fail_percentage: 50
  roles:
    - backend-api
  post_tasks:
    - name: Health check
      uri:
        url: "http://localhost:8080/health"
        status_code: 200
      retries: 30
      delay: 2

- name: Configure web servers
  hosts: webservers
  tags: [web]
  roles:
    - nginx
    - frontend

- name: Configure load balancers
  hosts: loadbalancers
  tags: [loadbalancer]
  roles:
    - haproxy

- name: Run smoke tests
  hosts: loadbalancers[0]
  tags: [test]
  tasks:
    - name: Test application endpoints
      uri:
        url: "http://{{ inventory_hostname }}/{{ item }}"
        status_code: 200
      loop:
        - health
        - api/version
        - /
```

---

## Best Practices Summary

1. **Idempotency**: Always write idempotent tasks
2. **Variables**: Use defaults, group_vars, and host_vars appropriately
3. **Roles**: Modular, reusable components
4. **Secrets**: Use Ansible Vault
5. **Testing**: Test in dev before production
6. **Tags**: Enable selective execution
7. **Error Handling**: Use blocks, rescue, always
8. **Logging**: Enable logging for audit trails
9. **Documentation**: README in each role
10. **Version Control**: Git for all Ansible code

---

Continue to [Part 5: AWS Cloud Foundation](../part-05-aws/README.md)
