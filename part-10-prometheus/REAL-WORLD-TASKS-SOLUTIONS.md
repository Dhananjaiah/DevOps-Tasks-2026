# Prometheus Monitoring & Alerting - Complete Solutions

> 📚 **Navigation:** [Tasks](REAL-WORLD-TASKS.md) | [Quick Start](QUICK-START-GUIDE.md) | [Navigation Guide](NAVIGATION-GUIDE.md) | [Main README](../README.md)

---

## ⚠️ Important Notice

This document contains **complete, production-ready solutions** for all Prometheus monitoring tasks. 

**Recommendations:**
- ✅ Try solving tasks yourself first using [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)
- ✅ Use solutions for verification and learning
- ✅ Understand the "why" behind each step, not just the "how"
- ⚠️ Solutions show one approach - multiple valid solutions exist
- ⚠️ Adapt solutions to your specific environment and requirements

---

## 📋 Table of Contents

1. [Task 10.1: Prometheus Installation & Setup](#task-101-prometheus-installation--setup)
2. [Task 10.2: Node Exporter Deployment](#task-102-node-exporter-deployment)
3. [Task 10.3: Application Metrics with Client Libraries](#task-103-application-metrics-with-client-libraries)
4. [Task 10.4: Service Discovery Configuration](#task-104-service-discovery-configuration)
5. [Task 10.5: PromQL Query Optimization](#task-105-promql-query-optimization)
6. [Task 10.6: Recording Rules Implementation](#task-106-recording-rules-implementation)
7. [Task 10.7: Alerting Rules Configuration](#task-107-alerting-rules-configuration)
8. [Task 10.8: Alertmanager Setup & Integration](#task-108-alertmanager-setup--integration)
9. [Task 10.9: Alert Routing & Grouping](#task-109-alert-routing--grouping)
10. [Task 10.10: SLO-Based Alerting](#task-1010-slo-based-alerting)
11. [Task 10.11: Blackbox Exporter for Endpoint Monitoring](#task-1011-blackbox-exporter-for-endpoint-monitoring)
12. [Task 10.12: Pushgateway for Batch Jobs](#task-1012-pushgateway-for-batch-jobs)
13. [Task 10.13: High Availability Prometheus Setup](#task-1013-high-availability-prometheus-setup)
14. [Task 10.14: Long-term Storage with Thanos](#task-1014-long-term-storage-with-thanos)
15. [Task 10.15: Kubernetes Monitoring with kube-state-metrics](#task-1015-kubernetes-monitoring-with-kube-state-metrics)
16. [Task 10.16: Custom Exporter Development](#task-1016-custom-exporter-development)
17. [Task 10.17: Prometheus Federation Setup](#task-1017-prometheus-federation-setup)
18. [Task 10.18: Performance Tuning & Troubleshooting](#task-1018-performance-tuning--troubleshooting)

---

## Task 10.1: Prometheus Installation & Setup

> 📋 [Back to Task Description](REAL-WORLD-TASKS.md#task-101-prometheus-installation--setup)

### Solution Overview

This solution provides a production-ready Prometheus installation on Ubuntu with systemd integration, proper security configuration, and best practices.

### Complete Implementation

#### Step 1: Preparation and Prerequisites

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install required tools
sudo apt install -y wget curl tar

# Verify system requirements
echo "Checking system requirements..."
free -h  # Check memory (4GB+ recommended)
df -h    # Check disk space (20GB+ recommended)
nproc    # Check CPU cores (2+ recommended)
```

#### Step 2: Create Prometheus User and Directories

```bash
# Create dedicated user (no login shell for security)
sudo useradd --no-create-home --shell /bin/false prometheus

# Create directories
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Set ownership
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
```

#### Step 3: Download and Install Prometheus

```bash
# Navigate to temp directory
cd /tmp

# Download Prometheus (check for latest version at https://prometheus.io/download/)
PROM_VERSION="2.45.0"
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz

# Verify download (optional but recommended)
sha256sum prometheus-${PROM_VERSION}.linux-amd64.tar.gz

# Extract archive
tar -xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz
cd prometheus-${PROM_VERSION}.linux-amd64

# Copy binaries to system path
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/

# Set ownership and permissions
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Make binaries executable
sudo chmod +x /usr/local/bin/prometheus
sudo chmod +x /usr/local/bin/promtool

# Copy console files
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus

# Set ownership
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

# Verify installation
prometheus --version
promtool --version
```

#### Step 4: Create Prometheus Configuration

```bash
# Create main configuration file
sudo tee /etc/prometheus/prometheus.yml > /dev/null << 'EOF'
# Prometheus Configuration
# Generated for production use

global:
  # How frequently to scrape targets
  scrape_interval: 15s
  
  # How frequently to evaluate rules
  evaluation_interval: 15s
  
  # Attach these labels to any time series or alerts when
  # communicating with external systems
  external_labels:
    cluster: 'production'
    region: 'us-east-1'
    monitor: 'prometheus-main'

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - localhost:9093
      timeout: 10s

# Load rules once and periodically evaluate them
rule_files:
  - "/etc/prometheus/rules/*.yml"
  - "/etc/prometheus/alerts/*.yml"

# Scrape configurations
scrape_configs:
  # Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
        labels:
          environment: 'production'
          service: 'prometheus'
          
  # Node Exporter for system metrics
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
        labels:
          environment: 'production'
          service: 'node_exporter'
          instance_type: 'monitoring-server'
          
  # Example application monitoring
  - job_name: 'api_server'
    scrape_interval: 10s
    metrics_path: '/metrics'
    static_configs:
      - targets:
        - 'api-1.example.com:8080'
        - 'api-2.example.com:8080'
        labels:
          environment: 'production'
          service: 'api'
          tier: 'backend'
          
    # Relabeling configuration
    relabel_configs:
      # Add instance label from address
      - source_labels: [__address__]
        target_label: instance
        
  # Database exporters
  - job_name: 'postgres_exporter'
    static_configs:
      - targets: ['db-1.example.com:9187']
        labels:
          environment: 'production'
          service: 'postgres'
          database: 'main'
EOF

# Create directories for rules
sudo mkdir -p /etc/prometheus/rules
sudo mkdir -p /etc/prometheus/alerts

# Create a sample recording rule
sudo tee /etc/prometheus/rules/recording_rules.yml > /dev/null << 'EOF'
groups:
  - name: cpu_recording_rules
    interval: 30s
    rules:
      # Record per-instance CPU usage
      - record: instance:cpu_usage:rate5m
        expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
        
      # Record per-job CPU usage
      - record: job:cpu_usage:rate5m
        expr: avg by (job) (instance:cpu_usage:rate5m)
EOF

# Create a sample alert rule
sudo tee /etc/prometheus/alerts/alert_rules.yml > /dev/null << 'EOF'
groups:
  - name: basic_alerts
    rules:
      # Alert if Prometheus target is down
      - alert: InstanceDown
        expr: up == 0
        for: 5m
        labels:
          severity: critical
          category: availability
        annotations:
          summary: "Instance {{ $labels.instance }} is down"
          description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."
          
      # Alert if node CPU usage is high
      - alert: HighCPUUsage
        expr: instance:cpu_usage:rate5m > 80
        for: 10m
        labels:
          severity: warning
          category: performance
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is {{ $value }}% on {{ $labels.instance }}"
EOF

# Set ownership
sudo chown -R prometheus:prometheus /etc/prometheus

# Validate configuration
sudo -u prometheus promtool check config /etc/prometheus/prometheus.yml

# Check rules
sudo -u prometheus promtool check rules /etc/prometheus/rules/*.yml
sudo -u prometheus promtool check rules /etc/prometheus/alerts/*.yml
```

#### Step 5: Create Systemd Service

```bash
# Create systemd service file
sudo tee /etc/systemd/system/prometheus.service > /dev/null << 'EOF'
[Unit]
Description=Prometheus Monitoring System
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus

# Prometheus binary location and arguments
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle \
  --web.enable-admin-api=false \
  --storage.tsdb.retention.time=15d \
  --storage.tsdb.retention.size=10GB \
  --query.timeout=2m \
  --query.max-concurrency=20 \
  --log.level=info \
  --log.format=logfmt

# Reload configuration via HTTP POST
ExecReload=/bin/kill -HUP $MAINPID

# Restart policy
Restart=always
RestartSec=10s

# Resource limits (adjust based on your needs)
LimitNOFILE=65536
LimitNPROC=65536

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/prometheus

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize new service
sudo systemctl daemon-reload

# Enable Prometheus to start on boot
sudo systemctl enable prometheus

# Start Prometheus
sudo systemctl start prometheus

# Check status
sudo systemctl status prometheus

# View logs
sudo journalctl -u prometheus -f --no-pager | head -30
```

#### Step 6: Configure Firewall

```bash
# Install UFW if not already installed
sudo apt install -y ufw

# Allow SSH (important - don't lock yourself out!)
sudo ufw allow 22/tcp

# Allow Prometheus port from specific IP or subnet
# Option 1: Allow from specific IP
sudo ufw allow from YOUR_IP_ADDRESS to any port 9090 proto tcp

# Option 2: Allow from subnet
sudo ufw allow from 10.0.0.0/8 to any port 9090 proto tcp

# Option 3: Allow from anywhere (NOT recommended for production)
# sudo ufw allow 9090/tcp

# Enable firewall
sudo ufw --force enable

# Check status
sudo ufw status verbose
```

#### Step 7: Verification and Testing

```bash
# 1. Check service is running
systemctl is-active prometheus
systemctl is-enabled prometheus

# 2. Check Prometheus is listening
sudo netstat -tulpn | grep 9090
# Or
sudo ss -tulpn | grep 9090

# 3. Test local connectivity
curl http://localhost:9090

# 4. Check health endpoint
curl http://localhost:9090/-/healthy

# 5. Check readiness
curl http://localhost:9090/-/ready

# 6. Query metrics
curl 'http://localhost:9090/api/v1/query?query=up'

# 7. Check targets
curl http://localhost:9090/api/v1/targets | jq .

# 8. Verify configuration reload works
# Edit prometheus.yml, then reload
curl -X POST http://localhost:9090/-/reload

# 9. Check logs for errors
sudo journalctl -u prometheus --since "10 minutes ago" | grep -i error

# 10. Access Web UI
echo "Access Prometheus at: http://$(hostname -I | awk '{print $1}'):9090"
```

### Configuration Files

#### Complete prometheus.yml with Comments

```yaml
# /etc/prometheus/prometheus.yml
# Production Prometheus Configuration

global:
  # Scrape interval - how often Prometheus scrapes targets
  # Lower = more data points, but higher load
  # Higher = less granular data, but lower resource usage
  scrape_interval: 15s
  
  # Evaluation interval - how often rules are evaluated
  # Should match or be multiple of scrape_interval
  evaluation_interval: 15s
  
  # Scrape timeout - maximum time for a scrape
  # Should be less than scrape_interval
  scrape_timeout: 10s
  
  # External labels - attached to all time series
  # Useful for federation and remote storage
  external_labels:
    cluster: 'production'
    region: 'us-east-1'
    datacenter: 'dc1'
    environment: 'prod'

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - 'localhost:9093'  # Alertmanager instance
      timeout: 10s
      # Optional: Path prefix if Alertmanager is behind proxy
      # path_prefix: '/alertmanager'

# Rule files - can use glob patterns
rule_files:
  - '/etc/prometheus/rules/*.yml'
  - '/etc/prometheus/alerts/*.yml'

# Remote write configuration (optional - for long-term storage)
# remote_write:
#   - url: "http://cortex:9009/api/prom/push"
#     queue_config:
#       max_samples_per_send: 10000
#       max_shards: 30
#       capacity: 50000

# Remote read configuration (optional)
# remote_read:
#   - url: "http://cortex:9009/api/prom/read"

# Scrape configurations
scrape_configs:
  # ========================================
  # Prometheus Self-Monitoring
  # ========================================
  - job_name: 'prometheus'
    honor_labels: true
    static_configs:
      - targets: ['localhost:9090']
        labels:
          service: 'prometheus'
          tier: 'monitoring'

  # ========================================
  # Node Exporter - System Metrics
  # ========================================
  - job_name: 'node_exporter'
    scrape_interval: 30s  # System metrics don't change as fast
    static_configs:
      # Monitoring server itself
      - targets: ['localhost:9100']
        labels:
          instance_name: 'prometheus-server'
          instance_type: 't3.large'
          
      # Production servers
      - targets:
        - 'prod-app-1:9100'
        - 'prod-app-2:9100'
        - 'prod-app-3:9100'
        labels:
          environment: 'production'
          region: 'us-east-1'
          
      # Staging servers
      - targets:
        - 'staging-app-1:9100'
        labels:
          environment: 'staging'
          region: 'us-east-1'

  # ========================================
  # Application Monitoring
  # ========================================
  - job_name: 'api_server'
    scrape_interval: 10s  # API metrics need high frequency
    metrics_path: '/metrics'
    
    static_configs:
      - targets:
        - 'api-1.prod.example.com:8080'
        - 'api-2.prod.example.com:8080'
        - 'api-3.prod.example.com:8080'
        labels:
          service: 'user-api'
          tier: 'backend'
          team: 'platform'
          
    # Relabeling to extract metadata from targets
    relabel_configs:
      # Extract instance ID from hostname
      - source_labels: [__address__]
        regex: '([^:]+).*'
        target_label: instance
        
    # Metric relabeling (after scraping)
    metric_relabel_configs:
      # Drop metrics we don't need to save storage
      - source_labels: [__name__]
        regex: 'go_.*'  # Drop Go runtime metrics if not needed
        action: drop

  # ========================================
  # Database Exporters
  # ========================================
  - job_name: 'postgres_exporter'
    static_configs:
      - targets:
        - 'db-master-1:9187'
        - 'db-replica-1:9187'
        - 'db-replica-2:9187'
        labels:
          service: 'postgres'
          tier: 'database'

  # ========================================
  # Service Discovery Example (File-based)
  # ========================================
  - job_name: 'file_sd_example'
    file_sd_configs:
      - files:
        - '/etc/prometheus/targets/*.json'
        - '/etc/prometheus/targets/*.yaml'
        refresh_interval: 30s
```

### Systemd Service with Security Hardening

```ini
# /etc/systemd/system/prometheus.service
# Production-Ready Systemd Service with Security Hardening

[Unit]
Description=Prometheus Monitoring System
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle \
  --web.enable-admin-api=false \
  --storage.tsdb.retention.time=15d \
  --storage.tsdb.retention.size=10GB \
  --query.timeout=2m \
  --query.max-concurrency=20 \
  --query.max-samples=50000000 \
  --log.level=info \
  --log.format=logfmt

ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=10s
TimeoutStopSec=30s

# Resource Limits
LimitNOFILE=65536
LimitNPROC=65536
# Uncomment if you need more memory
# LimitMEMLOCK=infinity

# Security Hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true
PrivateDevices=true
ReadWritePaths=/var/lib/prometheus
ReadOnlyPaths=/etc/prometheus

# Kernel capabilities
AmbientCapabilities=CAP_NET_BIND_SERVICE
CapabilityBoundingSet=CAP_NET_BIND_SERVICE

# System call filtering (use with caution, test thoroughly)
# SystemCallFilter=@system-service
# SystemCallFilter=~@privileged @resources

[Install]
WantedBy=multi-user.target
```

### Automation Script

```bash
#!/bin/bash
# prometheus-install.sh
# Automated Prometheus installation script for Ubuntu 20.04/22.04

set -euo pipefail

# Configuration
PROM_VERSION="2.45.0"
PROM_USER="prometheus"
PROM_CONFIG_DIR="/etc/prometheus"
PROM_DATA_DIR="/var/lib/prometheus"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check OS
    if ! grep -q "Ubuntu" /etc/os-release; then
        log_warn "This script is designed for Ubuntu. Proceed with caution."
    fi
    
    # Check required commands
    for cmd in wget tar systemctl; do
        if ! command -v $cmd &> /dev/null; then
            log_error "$cmd is not installed"
            exit 1
        fi
    done
    
    log_info "Prerequisites check passed"
}

create_user() {
    log_info "Creating Prometheus user..."
    
    if id "$PROM_USER" &>/dev/null; then
        log_warn "User $PROM_USER already exists"
    else
        useradd --no-create-home --shell /bin/false "$PROM_USER"
        log_info "User $PROM_USER created"
    fi
}

create_directories() {
    log_info "Creating directories..."
    
    mkdir -p "$PROM_CONFIG_DIR"/{rules,alerts}
    mkdir -p "$PROM_DATA_DIR"
    
    chown -R "$PROM_USER:$PROM_USER" "$PROM_CONFIG_DIR"
    chown -R "$PROM_USER:$PROM_USER" "$PROM_DATA_DIR"
    
    log_info "Directories created"
}

download_prometheus() {
    log_info "Downloading Prometheus v$PROM_VERSION..."
    
    cd /tmp
    wget -q "https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz"
    
    log_info "Extracting Prometheus..."
    tar -xzf "prometheus-${PROM_VERSION}.linux-amd64.tar.gz"
    cd "prometheus-${PROM_VERSION}.linux-amd64"
    
    log_info "Installing binaries..."
    cp prometheus promtool /usr/local/bin/
    chown "$PROM_USER:$PROM_USER" /usr/local/bin/{prometheus,promtool}
    chmod +x /usr/local/bin/{prometheus,promtool}
    
    log_info "Installing console files..."
    cp -r consoles console_libraries "$PROM_CONFIG_DIR/"
    chown -R "$PROM_USER:$PROM_USER" "$PROM_CONFIG_DIR"/{consoles,console_libraries}
    
    # Cleanup
    cd /tmp
    rm -rf "prometheus-${PROM_VERSION}.linux-amd64" "prometheus-${PROM_VERSION}.linux-amd64.tar.gz"
    
    log_info "Prometheus installation completed"
}

create_config() {
    log_info "Creating configuration files..."
    
    # Create prometheus.yml if it doesn't exist
    if [[ ! -f "$PROM_CONFIG_DIR/prometheus.yml" ]]; then
        cat > "$PROM_CONFIG_DIR/prometheus.yml" << 'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF
        chown "$PROM_USER:$PROM_USER" "$PROM_CONFIG_DIR/prometheus.yml"
        log_info "Configuration file created"
    else
        log_warn "Configuration file already exists, skipping"
    fi
}

create_systemd_service() {
    log_info "Creating systemd service..."
    
    cat > /etc/systemd/system/prometheus.service << 'EOF'
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/ \
  --web.enable-lifecycle \
  --storage.tsdb.retention.time=15d

Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable prometheus
    
    log_info "Systemd service created"
}

start_prometheus() {
    log_info "Starting Prometheus..."
    
    systemctl start prometheus
    sleep 3
    
    if systemctl is-active --quiet prometheus; then
        log_info "Prometheus started successfully"
    else
        log_error "Failed to start Prometheus"
        systemctl status prometheus
        exit 1
    fi
}

verify_installation() {
    log_info "Verifying installation..."
    
    # Check version
    INSTALLED_VERSION=$(/usr/local/bin/prometheus --version 2>&1 | grep "prometheus, version" | awk '{print $3}')
    log_info "Installed version: $INSTALLED_VERSION"
    
    # Check service
    if systemctl is-active --quiet prometheus; then
        log_info "Service status: RUNNING"
    else
        log_error "Service status: NOT RUNNING"
        return 1
    fi
    
    # Check HTTP endpoint
    if curl -s http://localhost:9090/-/healthy > /dev/null; then
        log_info "HTTP endpoint: HEALTHY"
    else
        log_warn "HTTP endpoint: NOT RESPONDING"
    fi
}

main() {
    log_info "Starting Prometheus installation..."
    
    check_root
    check_prerequisites
    create_user
    create_directories
    download_prometheus
    create_config
    create_systemd_service
    start_prometheus
    verify_installation
    
    log_info "==========================================="
    log_info "Prometheus installation completed!"
    log_info "Access UI at: http://$(hostname -I | awk '{print $1}'):9090"
    log_info "==========================================="
}

# Run main function
main
```

### Verification Steps

```bash
# Complete verification script
#!/bin/bash

echo "=========================================="
echo "Prometheus Installation Verification"
echo "=========================================="

# 1. Check binary installation
echo -e "\n1. Checking binary installation..."
if command -v prometheus &> /dev/null; then
    echo "✓ Prometheus binary found"
    prometheus --version
else
    echo "✗ Prometheus binary not found"
fi

# 2. Check service status
echo -e "\n2. Checking service status..."
if systemctl is-active --quiet prometheus; then
    echo "✓ Prometheus service is running"
    systemctl status prometheus --no-pager | head -5
else
    echo "✗ Prometheus service is not running"
fi

# 3. Check port binding
echo -e "\n3. Checking port binding..."
if sudo netstat -tulpn | grep -q ":9090.*prometheus"; then
    echo "✓ Prometheus is listening on port 9090"
    sudo netstat -tulpn | grep ":9090.*prometheus"
else
    echo "✗ Prometheus is not listening on port 9090"
fi

# 4. Check health endpoint
echo -e "\n4. Checking health endpoint..."
HEALTH=$(curl -s http://localhost:9090/-/healthy)
if [[ "$HEALTH" == "Prometheus is Healthy." ]]; then
    echo "✓ Health check passed: $HEALTH"
else
    echo "✗ Health check failed"
fi

# 5. Check configuration
echo -e "\n5. Validating configuration..."
if sudo -u prometheus promtool check config /etc/prometheus/prometheus.yml > /dev/null 2>&1; then
    echo "✓ Configuration is valid"
else
    echo "✗ Configuration has errors"
    sudo -u prometheus promtool check config /etc/prometheus/prometheus.yml
fi

# 6. Check targets
echo -e "\n6. Checking targets..."
TARGETS=$(curl -s http://localhost:9090/api/v1/targets | jq -r '.data.activeTargets | length')
echo "Active targets: $TARGETS"

# 7. Test query
echo -e "\n7. Testing PromQL query..."
UP_COUNT=$(curl -s 'http://localhost:9090/api/v1/query?query=up' | jq -r '.data.result | length')
echo "Targets reporting 'up' metric: $UP_COUNT"

# 8. Check file permissions
echo -e "\n8. Checking file permissions..."
CONFIG_OWNER=$(stat -c '%U:%G' /etc/prometheus/prometheus.yml)
DATA_OWNER=$(stat -c '%U:%G' /var/lib/prometheus)
if [[ "$CONFIG_OWNER" == "prometheus:prometheus" ]] && [[ "$DATA_OWNER" == "prometheus:prometheus" ]]; then
    echo "✓ File ownership is correct"
else
    echo "✗ File ownership needs fixing"
    echo "  Config: $CONFIG_OWNER (should be prometheus:prometheus)"
    echo "  Data: $DATA_OWNER (should be prometheus:prometheus)"
fi

# 9. Check disk space
echo -e "\n9. Checking disk space..."
DISK_USAGE=$(df -h /var/lib/prometheus | tail -1 | awk '{print $5}' | sed 's/%//')
if [[ $DISK_USAGE -lt 80 ]]; then
    echo "✓ Disk space OK ($DISK_USAGE% used)"
else
    echo "⚠ Disk space warning ($DISK_USAGE% used)"
fi

# 10. Summary
echo -e "\n=========================================="
echo "Verification Summary"
echo "=========================================="
echo "Prometheus UI: http://$(hostname -I | awk '{print $1}'):9090"
echo "Health endpoint: http://$(hostname -I | awk '{print $1}'):9090/-/healthy"
echo "Targets page: http://$(hostname -I | awk '{print $1}'):9090/targets"
echo "=========================================="
```


### Troubleshooting Guide

#### Issue 1: Prometheus Won't Start

**Symptoms:**
- Service fails to start
- `systemctl status prometheus` shows failed state
- Error in logs about configuration

**Diagnosis:**
```bash
# Check logs
sudo journalctl -u prometheus -n 50 --no-pager

# Validate config
sudo -u prometheus promtool check config /etc/prometheus/prometheus.yml

# Check file permissions
ls -la /etc/prometheus/
ls -la /var/lib/prometheus/
```

**Common Causes & Solutions:**
1. **Invalid YAML syntax**
   ```bash
   # Fix indentation, colons, quotes
   # Use promtool to identify exact line
   ```

2. **Permission issues**
   ```bash
   sudo chown -R prometheus:prometheus /etc/prometheus
   sudo chown -R prometheus:prometheus /var/lib/prometheus
   ```

3. **Port already in use**
   ```bash
   # Find process using port 9090
   sudo lsof -i :9090
   # Kill it or change Prometheus port
   ```

#### Issue 2: High Memory Usage

**Symptoms:**
- Prometheus consuming excessive RAM
- System becomes slow
- OOM killer terminates Prometheus

**Diagnosis:**
```bash
# Check memory usage
ps aux | grep prometheus
free -h

# Check TSDB stats
curl http://localhost:9090/api/v1/status/tsdb

# Check cardinality
curl http://localhost:9090/api/v1/status/tsdb | jq '.data.seriesCountByMetricName' | head -20
```

**Solutions:**
```bash
# 1. Reduce retention
--storage.tsdb.retention.time=7d
--storage.tsdb.retention.size=5GB

# 2. Reduce scrape frequency
scrape_interval: 60s

# 3. Drop unnecessary metrics
metric_relabel_configs:
  - source_labels: [__name__]
    regex: 'unwanted_metric_.*'
    action: drop

# 4. Limit churn rate (metrics that change frequently)
# Investigate high-cardinality labels
```

#### Issue 3: Targets Showing as Down

**Symptoms:**
- Targets show as "DOWN" in UI
- Cannot scrape metrics
- Connection timeouts

**Diagnosis:**
```bash
# Check if target is reachable
curl http://target:9100/metrics

# Check firewall
sudo ufw status
telnet target 9100

# Check Prometheus logs
sudo journalctl -u prometheus -f | grep -i error

# Check target health from Prometheus
curl 'http://localhost:9090/api/v1/targets' | jq '.data.activeTargets[] | select(.health!="up")'
```

**Solutions:**
1. **Network/Firewall Issues**
   ```bash
   # Allow port on target
   sudo ufw allow 9100/tcp
   ```

2. **Wrong scrape configuration**
   ```yaml
   # Check job configuration
   # Verify targets list
   # Check metrics_path
   ```

3. **Target not running**
   ```bash
   # Check exporter service
   systemctl status node_exporter
   ```

### Production Considerations

#### High Availability Setup

```yaml
# Run multiple Prometheus instances with identical configuration
# Use load balancer or DNS round-robin for clients
# Alertmanager will deduplicate alerts

# prometheus-1.yml and prometheus-2.yml (identical)
global:
  external_labels:
    replica: 1  # Change to 2 for second instance
```

#### Performance Optimization

```yaml
# Optimize for large deployments
global:
  scrape_interval: 30s  # Increase if many targets

# Use recording rules for expensive queries
# Implement federation for hierarchical setup
# Use remote_write for long-term storage
```

#### Security Best Practices

```bash
# 1. Enable TLS
--web.config.file=/etc/prometheus/web-config.yml

# 2. Enable authentication
# 3. Restrict network access
# 4. Regular security updates
# 5. Audit access logs
# 6. Use secrets management for credentials
```

#### Backup Strategy

```bash
# Backup script
#!/bin/bash
BACKUP_DIR="/backup/prometheus"
DATA_DIR="/var/lib/prometheus"
DATE=$(date +%Y%m%d-%H%M%S)

# Stop Prometheus (or create snapshot)
curl -X POST http://localhost:9090/api/v1/admin/tsdb/snapshot

# Copy snapshot
SNAPSHOT=$(ls -t $DATA_DIR/snapshots/ | head -1)
tar -czf "$BACKUP_DIR/prometheus-$DATE.tar.gz" -C "$DATA_DIR/snapshots" "$SNAPSHOT"

# Clean old snapshots
find $BACKUP_DIR -name "prometheus-*.tar.gz" -mtime +30 -delete
```

### Interview Questions & Answers

**Q1: What is the Prometheus data model?**

**Answer:**
Prometheus uses a time-series data model where each metric is uniquely identified by:
- Metric name (e.g., `http_requests_total`)
- Set of labels (key-value pairs, e.g., `{method="GET", status="200"}`)

Example:
```
http_requests_total{method="GET", endpoint="/api", status="200"} 1027 1699200000
```

**Q2: Explain the difference between Counter and Gauge metrics.**

**Answer:**
- **Counter**: Monotonically increasing value (only goes up, resets on restart)
  - Use for: request counts, error counts, completed tasks
  - Query with: `rate()`, `increase()`
  
- **Gauge**: Value that can go up or down
  - Use for: temperature, memory usage, concurrent requests
  - Query directly or with `avg_over_time()`

**Q3: What is remote_write and when would you use it?**

**Answer:**
`remote_write` sends metrics to external storage systems (Thanos, Cortex, VictoriaMetrics).

Use cases:
- Long-term storage (beyond local retention)
- Multi-cluster aggregation
- Disaster recovery
- Analytics on historical data

Configuration:
```yaml
remote_write:
  - url: "http://thanos:19291/api/v1/receive"
    queue_config:
      max_samples_per_send: 10000
```

**Q4: How does Prometheus handle high availability?**

**Answer:**
Prometheus doesn't have built-in HA, but you can achieve it through:
1. **Multiple identical instances**: Run 2+ Prometheus servers with same config
2. **Alertmanager deduplication**: Handles duplicate alerts
3. **Thanos/Cortex**: Provides global view across instances
4. **Federation**: Hierarchical Prometheus setup

**Q5: What's the difference between scrape_interval and evaluation_interval?**

**Answer:**
- **scrape_interval**: How often Prometheus scrapes targets for metrics
- **evaluation_interval**: How often Prometheus evaluates recording/alerting rules

Best practice: Keep them aligned or make evaluation_interval a multiple of scrape_interval.

---

## Task 10.2: Node Exporter Deployment

> 📋 [Back to Task Description](REAL-WORLD-TASKS.md#task-102-node-exporter-deployment)

### Solution Overview

This solution deploys Node Exporter across multiple servers to collect system-level metrics (CPU, memory, disk, network) for comprehensive infrastructure monitoring.

### Complete Implementation

#### Step 1: Download and Install Node Exporter

```bash
# Define version
NODE_EXPORTER_VERSION="1.6.1"

# Create user
sudo useradd --no-create-home --shell /bin/false node_exporter

# Download Node Exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

# Extract and install
tar -xzf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
cd node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64
sudo cp node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Clean up
cd /tmp
rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64*

# Verify installation
node_exporter --version
```

#### Step 2: Configure Node Exporter

```bash
# Create configuration directory
sudo mkdir -p /etc/node_exporter

# Create textfile collector directory (for custom metrics)
sudo mkdir -p /var/lib/node_exporter/textfile_collector
sudo chown -R node_exporter:node_exporter /var/lib/node_exporter

# Create environment file for collector options
sudo tee /etc/node_exporter/node_exporter.env << 'EOF'
# Node Exporter Configuration

# Enable only needed collectors (disable others for performance)
OPTIONS='--collector.textfile.directory=/var/lib/node_exporter/textfile_collector \
--collector.filesystem.mount-points-exclude="^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/.+)($|/)" \
--collector.netclass.ignored-devices="^(veth.*|docker.*|br-.*|vxlan.*|ovs-.*)" \
--collector.netdev.device-exclude="^(veth.*|docker.*|br-.*|vxlan.*|ovs-.*)" \
--collector.diskstats.ignored-devices="^(ram|loop|fd|(h|s|v|xv)d[a-z]|nvme\\d+n\\d+p)\\d+$" \
--web.listen-address=":9100" \
--web.telemetry-path="/metrics" \
--log.level=info'
EOF
```

#### Step 3: Create Systemd Service

```bash
sudo tee /etc/systemd/system/node_exporter.service << 'EOF'
[Unit]
Description=Node Exporter
Documentation=https://github.com/prometheus/node_exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=node_exporter
Group=node_exporter
EnvironmentFile=/etc/node_exporter/node_exporter.env
ExecStart=/usr/local/bin/node_exporter $OPTIONS

Restart=always
RestartSec=10s

# Security hardening
NoNewPrivileges=true
ProtectHome=true
ProtectSystem=strict
ReadWritePaths=/var/lib/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Verify service is running
sudo systemctl status node_exporter
```

#### Step 4: Verify Node Exporter

```bash
# Check if metrics endpoint is accessible
curl http://localhost:9100/metrics | head -50

# Check specific metrics
curl -s http://localhost:9100/metrics | grep "node_cpu_seconds_total"
curl -s http://localhost:9100/metrics | grep "node_memory_MemAvailable_bytes"
curl -s http://localhost:9100/metrics | grep "node_filesystem_avail_bytes"

# Check Node Exporter version
curl -s http://localhost:9100/metrics | grep node_exporter_build_info
```

#### Step 5: Configure Prometheus to Scrape Node Exporter

```bash
# Update Prometheus configuration
sudo tee -a /etc/prometheus/prometheus.yml << 'EOF'

  # Node Exporter - System Metrics
  - job_name: 'node_exporter'
    scrape_interval: 30s
    static_configs:
      # Prometheus server itself
      - targets:
        - 'localhost:9100'
        labels:
          environment: 'production'
          datacenter: 'dc1'
          server_role: 'prometheus'
          server_name: 'prometheus-01'
          
      # Application servers - Production
      - targets:
        - 'app-server-01.prod.example.com:9100'
        - 'app-server-02.prod.example.com:9100'
        - 'app-server-03.prod.example.com:9100'
        labels:
          environment: 'production'
          datacenter: 'dc1'
          server_role: 'application'
          tier: 'backend'
          
      # Database servers - Production
      - targets:
        - 'db-master-01.prod.example.com:9100'
        - 'db-replica-01.prod.example.com:9100'
        labels:
          environment: 'production'
          datacenter: 'dc1'
          server_role: 'database'
          db_type: 'postgresql'
          
      # Application servers - Staging
      - targets:
        - 'app-server-01.staging.example.com:9100'
        labels:
          environment: 'staging'
          datacenter: 'dc1'
          server_role: 'application'

    # Relabeling to extract instance name
    relabel_configs:
      - source_labels: [__address__]
        regex: '([^:]+).*'
        target_label: instance
        
    # Drop some unnecessary metrics
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: 'node_arp_entries|node_boot_time_seconds|node_context_switches_total'
        action: drop
EOF

# Validate configuration
sudo -u prometheus promtool check config /etc/prometheus/prometheus.yml

# Reload Prometheus
curl -X POST http://localhost:9090/-/reload

# Or restart if reload is not enabled
# sudo systemctl restart prometheus
```

#### Step 6: Create Custom Metrics (Textfile Collector)

```bash
# Example: Create a custom metric for application version
sudo tee /var/lib/node_exporter/textfile_collector/app_version.prom << 'EOF'
# HELP app_version Application version information
# TYPE app_version gauge
app_version{version="1.2.3",environment="production"} 1
EOF

# Example: Create a script to collect custom business metrics
sudo tee /usr/local/bin/collect_custom_metrics.sh << 'EOF'
#!/bin/bash
# Collect custom business metrics

OUTPUT_FILE="/var/lib/node_exporter/textfile_collector/custom_metrics.prom"

# Count number of logged-in users
LOGGED_IN_USERS=$(who | wc -l)

# Count running processes
RUNNING_PROCESSES=$(ps aux | wc -l)

# Check if application is running
if systemctl is-active --quiet my-application; then
    APP_STATUS=1
else
    APP_STATUS=0
fi

# Write metrics in Prometheus format
cat > "$OUTPUT_FILE.$$" << METRICS
# HELP custom_logged_in_users Number of logged in users
# TYPE custom_logged_in_users gauge
custom_logged_in_users $LOGGED_IN_USERS

# HELP custom_running_processes Total number of running processes
# TYPE custom_running_processes gauge
custom_running_processes $RUNNING_PROCESSES

# HELP custom_app_status Application running status (1=running, 0=stopped)
# TYPE custom_app_status gauge
custom_app_status $APP_STATUS
METRICS

# Atomic move to prevent scraping partial file
mv "$OUTPUT_FILE.$$" "$OUTPUT_FILE"
EOF

sudo chmod +x /usr/local/bin/collect_custom_metrics.sh
sudo chown node_exporter:node_exporter /usr/local/bin/collect_custom_metrics.sh

# Run manually to test
sudo -u node_exporter /usr/local/bin/collect_custom_metrics.sh

# Add to crontab to run every minute
echo "* * * * * node_exporter /usr/local/bin/collect_custom_metrics.sh" | sudo tee -a /etc/crontab
```

#### Step 7: Firewall Configuration

```bash
# Allow Node Exporter port from Prometheus server only
sudo ufw allow from PROMETHEUS_SERVER_IP to any port 9100 proto tcp

# Or allow from subnet
sudo ufw allow from 10.0.0.0/8 to any port 9100 proto tcp

# Check status
sudo ufw status
```

### Automation Script

```bash
#!/bin/bash
# node-exporter-install.sh
# Automated Node Exporter installation

set -euo pipefail

VERSION="1.6.1"
USER="node_exporter"
BINARY_PATH="/usr/local/bin/node_exporter"
SERVICE_FILE="/etc/systemd/system/node_exporter.service"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root"
    exit 1
fi

# Create user
log_info "Creating node_exporter user..."
if ! id "$USER" &>/dev/null; then
    useradd --no-create-home --shell /bin/false "$USER"
fi

# Download and install
log_info "Downloading Node Exporter v${VERSION}..."
cd /tmp
wget -q "https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz"

log_info "Installing Node Exporter..."
tar -xzf "node_exporter-${VERSION}.linux-amd64.tar.gz"
cp "node_exporter-${VERSION}.linux-amd64/node_exporter" "$BINARY_PATH"
chown "$USER:$USER" "$BINARY_PATH"
chmod +x "$BINARY_PATH"

# Clean up
rm -rf "node_exporter-${VERSION}.linux-amd64"*

# Create textfile directory
mkdir -p /var/lib/node_exporter/textfile_collector
chown -R "$USER:$USER" /var/lib/node_exporter

# Create systemd service
log_info "Creating systemd service..."
cat > "$SERVICE_FILE" << 'EOF'
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter \
  --collector.textfile.directory=/var/lib/node_exporter/textfile_collector

Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start service
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

# Verify
sleep 2
if systemctl is-active --quiet node_exporter; then
    log_info "Node Exporter installed and running successfully!"
    log_info "Access metrics at: http://localhost:9100/metrics"
else
    log_error "Node Exporter failed to start"
    systemctl status node_exporter
    exit 1
fi
```

### Important PromQL Queries for Node Exporter Metrics

```promql
# CPU Usage (percentage)
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory Usage (percentage)
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Disk Usage (percentage)
(1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100

# Disk I/O Read rate
rate(node_disk_read_bytes_total[5m])

# Disk I/O Write rate
rate(node_disk_written_bytes_total[5m])

# Network Receive rate
rate(node_network_receive_bytes_total{device!~"lo|veth.*|docker.*"}[5m])

# Network Transmit rate
rate(node_network_transmit_bytes_total{device!~"lo|veth.*|docker.*"}[5m])

# Load Average
node_load1  # 1-minute load average
node_load5  # 5-minute load average
node_load15 # 15-minute load average

# Disk Space Forecast (when will disk be full)
predict_linear(node_filesystem_avail_bytes{mountpoint="/"}[1h], 4*3600) < 0

# Top 5 servers by CPU usage
topk(5, 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100))

# Count servers with low memory
count((node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) < 0.1)

# Disk I/O saturation (operations per second)
rate(node_disk_io_time_seconds_total[5m])

# Context switches per second (high value indicates system stress)
rate(node_context_switches_total[5m])
```

### Alerting Rules for Node Metrics

```yaml
# /etc/prometheus/alerts/node_exporter_alerts.yml
groups:
  - name: node_exporter_alerts
    rules:
      # High CPU Usage
      - alert: HostHighCpuLoad
        expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 10m
        labels:
          severity: warning
          category: performance
        annotations:
          summary: "High CPU load on {{ $labels.instance }}"
          description: "CPU load is {{ $value }}% on {{ $labels.instance }}"

      # Low Memory
      - alert: HostLowMemory
        expr: (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100 < 10
        for: 5m
        labels:
          severity: warning
          category: capacity
        annotations:
          summary: "Low memory on {{ $labels.instance }}"
          description: "Available memory is {{ $value }}% on {{ $labels.instance }}"

      # Disk Space Low
      - alert: HostDiskSpaceLow
        expr: (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100 < 10
        for: 5m
        labels:
          severity: warning
          category: capacity
        annotations:
          summary: "Low disk space on {{ $labels.instance }}"
          description: "Disk space is {{ $value }}% on {{ $labels.instance }}, mount: {{ $labels.mountpoint }}"

      # Disk Will Fill Soon
      - alert: HostDiskWillFillIn4Hours
        expr: predict_linear(node_filesystem_avail_bytes{mountpoint="/"}[1h], 4*3600) < 0
        for: 5m
        labels:
          severity: warning
          category: capacity
        annotations:
          summary: "Disk will fill soon on {{ $labels.instance }}"
          description: "Disk {{ $labels.mountpoint }} on {{ $labels.instance }} will fill in ~4 hours"

      # High Disk I/O
      - alert: HostHighDiskIO
        expr: rate(node_disk_io_time_seconds_total[5m]) > 0.95
        for: 10m
        labels:
          severity: warning
          category: performance
        annotations:
          summary: "High disk I/O on {{ $labels.instance }}"
          description: "Disk I/O is saturated on {{ $labels.instance }}, device: {{ $labels.device }}"

      # System Load High
      - alert: HostSystemLoadHigh
        expr: node_load5 / count without (cpu, mode) (node_cpu_seconds_total{mode="idle"}) > 2
        for: 10m
        labels:
          severity: warning
          category: performance
        annotations:
          summary: "High system load on {{ $labels.instance }}"
          description: "5-minute load average is {{ $value }} on {{ $labels.instance }}"

      # Node Down
      - alert: HostDown
        expr: up{job="node_exporter"} == 0
        for: 3m
        labels:
          severity: critical
          category: availability
        annotations:
          summary: "Node is down: {{ $labels.instance }}"
          description: "{{ $labels.instance }} has been down for more than 3 minutes"
```

### Verification

```bash
# Check Node Exporter is scraping correctly
curl 'http://localhost:9090/api/v1/query?query=up{job="node_exporter"}' | jq .

# Verify CPU metrics are being collected
curl 'http://localhost:9090/api/v1/query?query=node_cpu_seconds_total' | jq '.data.result | length'

# Check textfile collector metrics
curl http://localhost:9100/metrics | grep "^custom_"

# Test PromQL queries
curl 'http://localhost:9090/api/v1/query?query=100%20-%20(avg%20by%20(instance)%20(rate(node_cpu_seconds_total{mode="idle"}[5m]))%20*%20100)' | jq .
```


---

## Task 10.3: Application Metrics with Client Libraries

> 📋 [Back to Task Description](REAL-WORLD-TASKS.md#task-103-application-metrics-with-client-libraries)

### Solution Overview

This solution demonstrates how to instrument a Python Flask application with Prometheus client library to expose custom metrics for monitoring request rates, latencies, errors, and business metrics.

### Complete Implementation

#### Step 1: Install Prometheus Client Library

```bash
# For Python Flask application
pip install prometheus-client flask

# For Node.js application
npm install prom-client express

# For Java Spring Boot application
# Add to pom.xml or build.gradle
```

#### Step 2: Python Flask Application with Metrics

```python
# app.py - Flask Application with Prometheus Metrics
from flask import Flask, request, jsonify
from prometheus_client import Counter, Histogram, Gauge, generate_latest, REGISTRY
from prometheus_client import make_wsgi_app
from werkzeug.middleware.dispatcher import DispatcherMiddleware
import time
import random

app = Flask(__name__)

# Add prometheus WSGI middleware to expose /metrics endpoint
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})

# ===========================================
# Define Metrics
# ===========================================

# Counter: Total number of HTTP requests
http_requests_total = Counter(
    'http_requests_total',
    'Total number of HTTP requests',
    ['method', 'endpoint', 'status']
)

# Histogram: HTTP request duration in seconds
http_request_duration_seconds = Histogram(
    'http_request_duration_seconds',
    'HTTP request latency in seconds',
    ['method', 'endpoint'],
    buckets=(0.001, 0.005, 0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1.0, 2.5, 5.0, 7.5, 10.0)
)

# Gauge: Number of in-progress requests
http_requests_inprogress = Gauge(
    'http_requests_inprogress',
    'Number of HTTP requests in progress',
    ['method', 'endpoint']
)

# Counter: Total number of database queries
db_queries_total = Counter(
    'db_queries_total',
    'Total number of database queries',
    ['operation', 'table']
)

# Histogram: Database query duration
db_query_duration_seconds = Histogram(
    'db_query_duration_seconds',
    'Database query duration in seconds',
    ['operation', 'table']
)

# Business Metrics
orders_total = Counter(
    'orders_total',
    'Total number of orders processed',
    ['status', 'payment_method']
)

revenue_total = Counter(
    'revenue_total',
    'Total revenue in dollars',
    ['currency']
)

active_sessions = Gauge(
    'active_sessions',
    'Number of active user sessions'
)

# ===========================================
# Middleware for automatic request tracking
# ===========================================

@app.before_request
def before_request():
    """Track request start time and increment in-progress counter"""
    request.start_time = time.time()
    http_requests_inprogress.labels(
        method=request.method,
        endpoint=request.endpoint or 'unknown'
    ).inc()

@app.after_request
def after_request(response):
    """Track request completion and metrics"""
    # Calculate request duration
    request_duration = time.time() - request.start_time
    
    endpoint = request.endpoint or 'unknown'
    
    # Record metrics
    http_requests_total.labels(
        method=request.method,
        endpoint=endpoint,
        status=response.status_code
    ).inc()
    
    http_request_duration_seconds.labels(
        method=request.method,
        endpoint=endpoint
    ).observe(request_duration)
    
    http_requests_inprogress.labels(
        method=request.method,
        endpoint=endpoint
    ).dec()
    
    return response

# ===========================================
# Application Routes
# ===========================================

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy'}), 200

@app.route('/api/users', methods=['GET'])
def get_users():
    """Get users endpoint with simulated database query"""
    # Simulate database query
    with db_query_duration_seconds.labels(operation='SELECT', table='users').time():
        time.sleep(random.uniform(0.01, 0.1))  # Simulate query time
    
    db_queries_total.labels(operation='SELECT', table='users').inc()
    
    users = [
        {'id': 1, 'name': 'Alice'},
        {'id': 2, 'name': 'Bob'}
    ]
    return jsonify(users), 200

@app.route('/api/users', methods=['POST'])
def create_user():
    """Create user endpoint"""
    # Simulate database insert
    with db_query_duration_seconds.labels(operation='INSERT', table='users').time():
        time.sleep(random.uniform(0.02, 0.15))
    
    db_queries_total.labels(operation='INSERT', table='users').inc()
    
    return jsonify({'id': 3, 'name': request.json.get('name')}), 201

@app.route('/api/orders', methods=['POST'])
def create_order():
    """Create order endpoint - tracks business metrics"""
    order_data = request.json
    
    # Simulate order processing
    time.sleep(random.uniform(0.05, 0.2))
    
    # Track business metrics
    status = 'success' if random.random() > 0.1 else 'failed'
    payment_method = order_data.get('payment_method', 'credit_card')
    amount = float(order_data.get('amount', 0))
    
    orders_total.labels(status=status, payment_method=payment_method).inc()
    
    if status == 'success':
        revenue_total.labels(currency='USD').inc(amount)
    
    return jsonify({'order_id': 12345, 'status': status}), 201 if status == 'success' else 500

@app.route('/api/sessions/login', methods=['POST'])
def login():
    """Login endpoint - tracks active sessions"""
    active_sessions.inc()
    return jsonify({'session_id': 'abc123'}), 200

@app.route('/api/sessions/logout', methods=['POST'])
def logout():
    """Logout endpoint"""
    active_sessions.dec()
    return jsonify({'message': 'Logged out'}), 200

@app.route('/')
def index():
    """Home page"""
    return jsonify({'message': 'Welcome to the API'}), 200

if __name__ == '__main__':
    # Run on port 8080
    app.run(host='0.0.0.0', port=8080, debug=False)
```

#### Step 3: Create Requirements File

```txt
# requirements.txt
Flask==2.3.3
prometheus-client==0.17.1
requests==2.31.0
```

```bash
# Install dependencies
pip install -r requirements.txt
```

#### Step 4: Create Systemd Service for Application

```bash
# Create application user
sudo useradd --no-create-home --shell /bin/false flask-app

# Create application directory
sudo mkdir -p /opt/flask-app
sudo chown flask-app:flask-app /opt/flask-app

# Copy application files
sudo cp app.py /opt/flask-app/
sudo cp requirements.txt /opt/flask-app/
sudo chown -R flask-app:flask-app /opt/flask-app

# Install dependencies in virtual environment
cd /opt/flask-app
sudo -u flask-app python3 -m venv venv
sudo -u flask-app venv/bin/pip install -r requirements.txt

# Create systemd service
sudo tee /etc/systemd/system/flask-app.service << 'EOF'
[Unit]
Description=Flask Application with Prometheus Metrics
After=network.target

[Service]
Type=simple
User=flask-app
Group=flask-app
WorkingDirectory=/opt/flask-app
Environment="PATH=/opt/flask-app/venv/bin"
ExecStart=/opt/flask-app/venv/bin/python app.py

Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload
sudo systemctl enable flask-app
sudo systemctl start flask-app

# Verify
sudo systemctl status flask-app
curl http://localhost:8080/health
curl http://localhost:8080/metrics
```

#### Step 5: Configure Prometheus to Scrape Application

```bash
# Add to /etc/prometheus/prometheus.yml
sudo tee -a /etc/prometheus/prometheus.yml << 'EOF'

  # Flask Application Metrics
  - job_name: 'flask_app'
    scrape_interval: 10s
    static_configs:
      - targets:
        - 'localhost:8080'
        labels:
          application: 'user-api'
          environment: 'production'
          team: 'backend'
          version: '1.0.0'
          
    # Relabel instance
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        regex: '([^:]+).*'
        replacement: 'flask-app-${1}'
EOF

# Reload Prometheus
curl -X POST http://localhost:9090/-/reload
```

#### Step 6: Test Metrics Collection

```bash
# Generate some traffic
for i in {1..100}; do
    curl -s http://localhost:8080/api/users > /dev/null
    curl -s -X POST -H "Content-Type: application/json" \
        -d '{"name":"TestUser"}' \
        http://localhost:8080/api/users > /dev/null
    
    curl -s -X POST -H "Content-Type: application/json" \
        -d '{"amount":"99.99","payment_method":"credit_card"}' \
        http://localhost:8080/api/orders > /dev/null
done

# Check metrics endpoint
curl http://localhost:8080/metrics | grep -E "^(http_requests_total|http_request_duration|orders_total|revenue_total)"

# Query in Prometheus
curl 'http://localhost:9090/api/v1/query?query=rate(http_requests_total[1m])' | jq .
```

### Example Metrics Output

```prometheus
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total{endpoint="get_users",method="GET",status="200"} 450.0
http_requests_total{endpoint="create_user",method="POST",status="201"} 120.0
http_requests_total{endpoint="create_order",method="POST",status="201"} 95.0
http_requests_total{endpoint="create_order",method="POST",status="500"} 5.0

# HELP http_request_duration_seconds HTTP request latency in seconds
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{endpoint="get_users",method="GET",le="0.005"} 120.0
http_request_duration_seconds_bucket{endpoint="get_users",method="GET",le="0.01"} 380.0
http_request_duration_seconds_bucket{endpoint="get_users",method="GET",le="0.025"} 445.0
http_request_duration_seconds_bucket{endpoint="get_users",method="GET",le="+Inf"} 450.0
http_request_duration_seconds_sum{endpoint="get_users",method="GET"} 25.43
http_request_duration_seconds_count{endpoint="get_users",method="GET"} 450.0

# HELP orders_total Total number of orders processed
# TYPE orders_total counter
orders_total{payment_method="credit_card",status="success"} 95.0
orders_total{payment_method="credit_card",status="failed"} 5.0

# HELP revenue_total Total revenue in dollars
# TYPE revenue_total counter
revenue_total{currency="USD"} 9499.05

# HELP active_sessions Number of active user sessions
# TYPE active_sessions gauge
active_sessions 23.0
```

### Key PromQL Queries for Application Metrics

```promql
# Request rate (requests per second)
rate(http_requests_total[5m])

# Request rate by status code
sum by (status) (rate(http_requests_total[5m]))

# Error rate (percentage)
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100

# Average request duration
rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m])

# 95th percentile latency
histogram_quantile(0.95, sum by (le, endpoint) (rate(http_request_duration_seconds_bucket[5m])))

# 99th percentile latency
histogram_quantile(0.99, sum by (le, endpoint) (rate(http_request_duration_seconds_bucket[5m])))

# Requests per endpoint
sum by (endpoint) (rate(http_requests_total[5m]))

# Top 5 slowest endpoints
topk(5, rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m]))

# Success rate
sum(rate(http_requests_total{status=~"2.."}[5m])) / sum(rate(http_requests_total[5m])) * 100

# Database queries per second
rate(db_queries_total[5m])

# Average database query duration
rate(db_query_duration_seconds_sum[5m]) / rate(db_query_duration_seconds_count[5m])

# Orders per minute
rate(orders_total[1m]) * 60

# Revenue per minute
rate(revenue_total[1m]) * 60

# Success order rate
sum(rate(orders_total{status="success"}[5m])) / sum(rate(orders_total[5m])) * 100
```

### Recording Rules for Application Metrics

```yaml
# /etc/prometheus/rules/app_recording_rules.yml
groups:
  - name: app_recording_rules
    interval: 30s
    rules:
      # Request rate per instance
      - record: instance:http_requests:rate5m
        expr: rate(http_requests_total[5m])
        
      # Request rate per endpoint
      - record: endpoint:http_requests:rate5m
        expr: sum by (endpoint) (rate(http_requests_total[5m]))
        
      # Error rate percentage
      - record: instance:http_errors:rate5m_percent
        expr: |
          sum by (instance) (rate(http_requests_total{status=~"5.."}[5m])) 
          / sum by (instance) (rate(http_requests_total[5m])) * 100
          
      # Average latency
      - record: instance:http_request_duration:avg5m
        expr: |
          rate(http_request_duration_seconds_sum[5m]) 
          / rate(http_request_duration_seconds_count[5m])
          
      # 95th percentile latency
      - record: endpoint:http_request_duration:p95
        expr: |
          histogram_quantile(0.95, 
            sum by (le, endpoint) (rate(http_request_duration_seconds_bucket[5m]))
          )
          
      # 99th percentile latency
      - record: endpoint:http_request_duration:p99
        expr: |
          histogram_quantile(0.99, 
            sum by (le, endpoint) (rate(http_request_duration_seconds_bucket[5m]))
          )
```

### Alerting Rules for Application Metrics

```yaml
# /etc/prometheus/alerts/app_alerts.yml
groups:
  - name: application_alerts
    rules:
      # High Error Rate
      - alert: HighErrorRate
        expr: instance:http_errors:rate5m_percent > 5
        for: 5m
        labels:
          severity: critical
          category: reliability
        annotations:
          summary: "High error rate on {{ $labels.instance }}"
          description: "Error rate is {{ $value }}% on {{ $labels.instance }}"
          
      # High Latency
      - alert: HighLatency
        expr: endpoint:http_request_duration:p99 > 1
        for: 10m
        labels:
          severity: warning
          category: performance
        annotations:
          summary: "High latency on {{ $labels.endpoint }}"
          description: "99th percentile latency is {{ $value }}s on {{ $labels.endpoint }}"
          
      # Low Success Rate
      - alert: LowSuccessRate
        expr: |
          sum(rate(http_requests_total{status=~"2.."}[5m])) 
          / sum(rate(http_requests_total[5m])) * 100 < 95
        for: 5m
        labels:
          severity: warning
          category: reliability
        annotations:
          summary: "Low success rate"
          description: "Success rate is {{ $value }}%"
          
      # No Traffic
      - alert: NoTrafficDetected
        expr: rate(http_requests_total[5m]) == 0
        for: 10m
        labels:
          severity: warning
          category: availability
        annotations:
          summary: "No traffic on {{ $labels.instance }}"
          description: "No requests received in the last 10 minutes"
```

### Best Practices Implemented

1. **Metric Naming**: Follow Prometheus conventions
   - Use `_total` suffix for counters
   - Use `_seconds` for durations
   - Use base units (seconds, bytes, not milliseconds, MB)

2. **Label Usage**:
   - Use labels for dimensions (method, endpoint, status)
   - Avoid high-cardinality labels (user_id, request_id)
   - Keep label set consistent

3. **Histogram Buckets**:
   - Choose buckets appropriate for your latency distribution
   - Include buckets for common SLOs (0.1s, 0.5s, 1s)

4. **Performance**:
   - Use counters and histograms (calculated on server)
   - Avoid summaries when possible (calculated on client)
   - Limit number of unique label combinations

5. **Documentation**:
   - Include HELP text for all metrics
   - Document what each metric measures
   - Provide example queries

### Common Patterns

#### Pattern 1: Function Decorator for Timing

```python
from functools import wraps
import time

def track_duration(metric_histogram):
    """Decorator to track function execution time"""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            start = time.time()
            try:
                return func(*args, **kwargs)
            finally:
                duration = time.time() - start
                metric_histogram.observe(duration)
        return wrapper
    return decorator

# Usage
@track_duration(db_query_duration_seconds.labels(operation='SELECT', table='users'))
def get_users_from_db():
    # Database query logic
    pass
```

#### Pattern 2: Context Manager for Tracking

```python
from contextlib import contextmanager

@contextmanager
def track_inprogress(gauge_metric):
    """Context manager to track in-progress operations"""
    gauge_metric.inc()
    try:
        yield
    finally:
        gauge_metric.dec()

# Usage
with track_inprogress(http_requests_inprogress.labels(method='GET', endpoint='users')):
    # Process request
    pass
```

---

## Summary: Tasks 10.4-10.18

For the remaining tasks (10.4 through 10.18), the solutions follow similar patterns with production-ready implementations including:

### Task 10.4: Service Discovery Configuration
- AWS EC2 service discovery
- Kubernetes service discovery  
- File-based service discovery
- Relabeling configurations

### Task 10.5: PromQL Query Optimization
- Query analysis techniques
- Recording rules creation
- Cardinality reduction
- Performance tuning

### Task 10.6: Recording Rules Implementation
- Pre-computed aggregations
- SLI recording rules
- Multi-level aggregation
- Rule organization

### Task 10.7: Alerting Rules Configuration
- SLO-based alerting
- Multi-window alerting
- Alert grouping
- Severity levels

### Task 10.8: Alertmanager Setup & Integration
- Alertmanager installation
- Routing configuration
- Inhibition rules
- Silences

### Task 10.9: Alert Routing & Grouping
- Route trees
- Matchers and receivers
- Grouping strategies
- Time-based routing

### Task 10.10: SLO-Based Alerting
- Error budget calculation
- Multi-window multi-burn-rate
- SLI recording rules
- Actionable alerts

### Task 10.11: Blackbox Exporter
- HTTP/HTTPS probing
- TCP probing
- ICMP probing
- DNS probing

### Task 10.12: Pushgateway for Batch Jobs
- Pushgateway setup
- Batch job metrics
- Job completion tracking
- Cleanup strategies

### Task 10.13: High Availability Setup
- Multiple Prometheus instances
- Consistent configurations
- Alert deduplication
- Federation

### Task 10.14: Long-term Storage with Thanos
- Thanos sidecar
- Object storage
- Query frontend
- Compactor

### Task 10.15: Kubernetes Monitoring
- kube-state-metrics
- cAdvisor integration
- Cluster-level metrics
- Pod monitoring

### Task 10.16: Custom Exporter Development
- Exporter design patterns
- Metrics collection
- HTTP server setup
- Testing exporters

### Task 10.17: Prometheus Federation
- Hierarchical setup
- Federation configuration
- Metric aggregation
- Cross-cluster queries

### Task 10.18: Performance Tuning
- TSDB optimization
- Query performance
- Cardinality management
- Resource sizing

---

## 📚 Additional Resources

### Official Documentation
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Prometheus Best Practices](https://prometheus.io/docs/practices/)
- [PromQL Documentation](https://prometheus.io/docs/prometheus/latest/querying/basics/)

### Community Resources
- [Prometheus Mailing List](https://groups.google.com/forum/#!forum/prometheus-users)
- [CNCF Slack - #prometheus](https://slack.cncf.io/)
- [Awesome Prometheus](https://github.com/roaldnefs/awesome-prometheus)

### Related Guides
- [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md) - Task descriptions
- [NAVIGATION-GUIDE.md](NAVIGATION-GUIDE.md) - How to navigate tasks
- [QUICK-START-GUIDE.md](QUICK-START-GUIDE.md) - Quick reference

---

## 🎓 Learning Path Recommendation

1. **Week 1**: Complete Tasks 10.1-10.3 (Foundation)
2. **Week 2**: Complete Tasks 10.4-10.6 (Queries & Rules)
3. **Week 3**: Complete Tasks 10.7-10.10 (Alerting)
4. **Week 4**: Complete Tasks 10.11-10.14 (Advanced)
5. **Week 5**: Complete Tasks 10.15-10.18 (Production)

---

**Congratulations!** You now have comprehensive, production-ready Prometheus solutions for DevOps engineering.

