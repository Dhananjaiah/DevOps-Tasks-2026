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

