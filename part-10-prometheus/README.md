# Part 10: Prometheus Monitoring & Alerting

## Overview

This section covers comprehensive Prometheus monitoring skills required for DevOps engineers managing production observability. All tasks are built around real-world scenarios for monitoring cloud-native applications, Kubernetes clusters, and distributed systems.

## 📚 Available Resources

### Real-World Tasks (Recommended Starting Point)
- **[REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)** - 📝 18 practical, executable tasks with scenarios, requirements, and validation checklists
- **[REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)** - ✅ Complete, production-ready solutions with step-by-step implementations
- **[NAVIGATION-GUIDE.md](NAVIGATION-GUIDE.md)** - 📚 **NEW!** Learn how to navigate between tasks and solutions efficiently

### Quick Start & Additional Resources
- **[QUICK-START-GUIDE.md](QUICK-START-GUIDE.md)** - 🚀 Quick reference with task lookup table and learning paths

> **💡 New to Prometheus monitoring?** Check out the [Navigation Guide](NAVIGATION-GUIDE.md) to understand how tasks and solutions are organized!

---

## What You'll Learn

### Core Prometheus Concepts
- **Metrics Collection**: Time-series data model, metric types (Counter, Gauge, Histogram, Summary)
- **Service Discovery**: Dynamic target discovery for Kubernetes, Consul, EC2, and more
- **PromQL**: Powerful query language for metrics analysis and visualization
- **Recording Rules**: Pre-computing expensive queries for performance
- **Alerting**: Rule-based alerting with Alertmanager integration

### Production Skills
- **High Availability**: Multi-replica Prometheus with Thanos for long-term storage
- **Federation**: Hierarchical monitoring across multiple clusters
- **Performance Tuning**: Optimizing cardinality, retention, and query performance
- **Security**: Authentication, authorization, and TLS configuration
- **Troubleshooting**: Debugging metric collection, alerts, and performance issues

### Real-World Applications
- Monitoring microservices and APIs
- Kubernetes cluster observability
- SLO/SLA tracking and error budgets
- Custom exporters for legacy applications
- Multi-region monitoring architectures

---

## Task 10.1: Prometheus Installation & Setup

### Goal / Why It's Important

Setting up Prometheus correctly is the **foundation of your monitoring infrastructure**. A properly configured Prometheus server enables:
- Reliable metric collection from all targets
- Efficient storage and retrieval of time-series data
- Scalable monitoring as your infrastructure grows
- Integration with alerting and visualization tools

This is the first step in building production-grade observability and a common interview topic.

### Prerequisites

- Linux server (Ubuntu 20.04+ recommended) or Kubernetes cluster
- Basic understanding of YAML configuration
- Root or sudo access
- Ports 9090 (Prometheus UI) and required exporter ports available

### Step-by-Step Implementation

#### Step 1: Download and Install Prometheus

```bash
# Create prometheus user
sudo useradd --no-create-home --shell /bin/false prometheus

# Create directories
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# Download Prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
tar -xvf prometheus-2.45.0.linux-amd64.tar.gz
cd prometheus-2.45.0.linux-amd64

# Copy binaries
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Copy configuration files
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
```

#### Step 2: Create Prometheus Configuration

```bash
sudo vi /etc/prometheus/prometheus.yml
```

Basic configuration:
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'production'
    region: 'us-east-1'

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - localhost:9093

# Rule files
rule_files:
  - "/etc/prometheus/rules/*.yml"

# Scrape configurations
scrape_configs:
  # Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node Exporter
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
        labels:
          environment: 'production'

  # Example application
  - job_name: 'api-server'
    static_configs:
      - targets: ['localhost:8080']
        labels:
          service: 'api'
          tier: 'backend'
```

```bash
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
```

#### Step 3: Create Systemd Service

```bash
sudo vi /etc/systemd/system/prometheus.service
```

```ini
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle \
  --storage.tsdb.retention.time=15d \
  --storage.tsdb.retention.size=10GB

Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target
```

#### Step 4: Start Prometheus

```bash
# Reload systemd
sudo systemctl daemon-reload

# Start Prometheus
sudo systemctl start prometheus

# Enable at boot
sudo systemctl enable prometheus

# Check status
sudo systemctl status prometheus

# View logs
sudo journalctl -u prometheus -f
```

#### Step 5: Verify Installation

```bash
# Check Prometheus is running
curl http://localhost:9090

# Validate configuration
promtool check config /etc/prometheus/prometheus.yml

# Check targets
curl http://localhost:9090/api/v1/targets

# Test a simple query
curl 'http://localhost:9090/api/v1/query?query=up'
```

Access Prometheus UI: `http://your-server-ip:9090`

### Key Configuration Options

```yaml
# Storage configuration
storage:
  tsdb:
    retention.time: 15d      # How long to keep data
    retention.size: 10GB     # Maximum storage size
    path: /var/lib/prometheus/

# Web configuration
web:
  listen-address: 0.0.0.0:9090
  enable-lifecycle: true     # Enable reload via HTTP POST
  enable-admin-api: false    # Disable dangerous admin operations
  
# Query configuration
query:
  timeout: 2m
  max-concurrency: 20
  max-samples: 50000000

# Alerting configuration
alerting:
  alert_relabel_configs:
    - source_labels: [severity]
      target_label: priority
      replacement: P${1}
```

### Verification

#### 1. Check Prometheus Health
```bash
curl http://localhost:9090/-/healthy
# Expected: Prometheus is Healthy.

curl http://localhost:9090/-/ready
# Expected: Prometheus is Ready.
```

#### 2. Verify Metrics Collection
```bash
# Check if Prometheus is scraping itself
curl 'http://localhost:9090/api/v1/query?query=up{job="prometheus"}'

# Check scrape duration
curl 'http://localhost:9090/api/v1/query?query=scrape_duration_seconds'
```

#### 3. Test Configuration Reload
```bash
# Make a change to prometheus.yml
# Reload without restart (if --web.enable-lifecycle is set)
curl -X POST http://localhost:9090/-/reload

# Or restart service
sudo systemctl restart prometheus
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Incorrect File Permissions

**Problem**: Prometheus fails to start with permission errors

**Solution**:
```bash
# Fix ownership
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Check permissions
ls -la /etc/prometheus
ls -la /var/lib/prometheus
```

#### Mistake 2: Port Already in Use

**Problem**: Cannot bind to port 9090

**Solution**:
```bash
# Check what's using the port
sudo netstat -tulpn | grep 9090
sudo lsof -i :9090

# Kill the process or change Prometheus port
# Edit /etc/systemd/system/prometheus.service
# Change --web.listen-address=0.0.0.0:9091
```

#### Mistake 3: Configuration Syntax Errors

**Problem**: Prometheus fails to start due to YAML errors

**Solution**:
```bash
# Validate configuration
promtool check config /etc/prometheus/prometheus.yml

# Check for common issues:
# - Incorrect indentation
# - Missing colons
# - Duplicate keys
```

#### Mistake 4: High Memory Usage

**Problem**: Prometheus consuming too much memory

**Solution**:
```bash
# Reduce retention
# In prometheus.service:
--storage.tsdb.retention.time=7d
--storage.tsdb.retention.size=5GB

# Reduce scrape frequency for non-critical targets
scrape_interval: 60s  # Instead of 15s

# Check cardinality
curl http://localhost:9090/api/v1/status/tsdb
```

### Interview Questions with Answers

#### Q1: What is the Prometheus time-series data model?

**Answer**: 
Prometheus stores data as time-series, identified by metric name and key-value pairs (labels):
```
metric_name{label1="value1", label2="value2"} value timestamp
```

Example:
```
http_requests_total{method="GET", endpoint="/api", status="200"} 1234 1634567890
```

**Key concepts**:
- **Metric name**: Identifies what is being measured (e.g., `http_requests_total`)
- **Labels**: Dimensions for filtering and aggregation (e.g., `method`, `endpoint`)
- **Sample**: A single data point (value + timestamp)
- **Series**: Unique combination of metric name and label set

#### Q2: What are the four metric types in Prometheus?

**Answer**:

1. **Counter**: Monotonically increasing value (only goes up)
   - Use for: Request counts, error counts, tasks completed
   - Example: `http_requests_total`

2. **Gauge**: Value that can go up or down
   - Use for: Temperature, memory usage, concurrent connections
   - Example: `node_memory_available_bytes`

3. **Histogram**: Samples observations and counts them in configurable buckets
   - Use for: Request durations, response sizes
   - Provides: `_bucket`, `_sum`, `_count`
   - Example: `http_request_duration_seconds`

4. **Summary**: Similar to histogram but calculates quantiles on client side
   - Use for: Request latencies when you need exact percentiles
   - Provides: `_sum`, `_count`, quantiles
   - Example: `rpc_duration_seconds{quantile="0.95"}`

#### Q3: Explain the difference between scraping and pushing metrics

**Answer**:

**Scraping (Pull Model)** - Prometheus default:
- Prometheus pulls metrics from targets' HTTP endpoints
- Targets expose metrics on `/metrics` endpoint
- Prometheus controls when and how often to collect

**Advantages**:
- Service discovery works naturally
- Easy to detect if target is down
- No need for targets to know about Prometheus
- Can scrape multiple times for testing

**Pushing (Push Model)** - Using Pushgateway:
- Short-lived jobs push metrics to Pushgateway
- Prometheus scrapes Pushgateway
- Needed for batch jobs that don't run long enough to be scraped

**When to use push**:
- Batch jobs, cron jobs
- Serverless functions
- Jobs behind firewalls

#### Q4: What is the difference between recording rules and alerting rules?

**Answer**:

**Recording Rules**: Pre-compute frequently used or expensive queries
```yaml
groups:
  - name: example
    interval: 30s
    rules:
      - record: job:http_requests:rate5m
        expr: sum(rate(http_requests_total[5m])) by (job)
```
- **Purpose**: Performance optimization
- **Output**: New time-series
- **Use**: Speed up dashboards, reduce query load

**Alerting Rules**: Define conditions for alerts
```yaml
groups:
  - name: alerts
    rules:
      - alert: HighErrorRate
        expr: job:http_errors:rate5m > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: High error rate detected
```
- **Purpose**: Detect problems
- **Output**: Alerts to Alertmanager
- **Use**: Monitor SLOs, trigger notifications

#### Q5: How does Prometheus handle high availability?

**Answer**:

Prometheus itself is designed for reliability but not HA out of the box:

**Challenges**:
- Single instance = single point of failure
- No built-in data replication
- Local storage only

**HA Solutions**:

1. **Multiple Prometheus Instances**:
```yaml
# Run 2+ identical Prometheus servers
# Both scrape same targets independently
# Alertmanager deduplicates alerts
```

2. **Thanos/Cortex for Long-term Storage**:
- Extends Prometheus with object storage
- Provides global query view
- Enables multi-cluster federation

3. **Prometheus Federation**:
```yaml
# Central Prometheus scrapes from edge Prometheus servers
scrape_configs:
  - job_name: 'federate'
    honor_labels: true
    metrics_path: '/federate'
    params:
      'match[]':
        - '{job="important"}'
    static_configs:
      - targets:
        - 'prometheus1:9090'
        - 'prometheus2:9090'
```

**Best Practice**: Run 2 identical Prometheus instances + Thanos for long-term storage

---

## Quick Start

### Basic Installation (Docker)
```bash
# Run Prometheus with Docker
docker run -d \
  --name=prometheus \
  -p 9090:9090 \
  -v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus
```

### Basic Configuration
```yaml
# prometheus.yml - Minimal setup
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

### First Query (PromQL)
```promql
# Check if Prometheus is up
up

# CPU usage rate
rate(node_cpu_seconds_total[5m])

# Memory available
node_memory_AvailMem_bytes / node_memory_MemTotal_bytes * 100
```

---

## Learning Path

**Week 1**: Basics
- Install Prometheus and Node Exporter
- Understand metric types
- Write basic PromQL queries
- Create simple dashboards

**Week 2**: Application Monitoring
- Instrument applications with client libraries
- Configure service discovery
- Create recording rules
- Set up basic alerts

**Week 3**: Advanced Features
- Configure Alertmanager
- Implement SLO-based alerting
- Set up Blackbox monitoring
- Configure Pushgateway

**Week 4**: Production Setup
- Implement high availability
- Configure long-term storage (Thanos)
- Set up federation
- Performance tuning

---

## Related Documentation

- 📖 [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md) - Hands-on tasks to build skills
- ✅ [REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md) - Complete solutions
- 📚 [NAVIGATION-GUIDE.md](NAVIGATION-GUIDE.md) - How to navigate the resources
- 🚀 [QUICK-START-GUIDE.md](QUICK-START-GUIDE.md) - Quick reference guide

---

## External Resources

- [Official Prometheus Documentation](https://prometheus.io/docs/)
- [PromQL Cheat Sheet](https://promlabs.com/promql-cheat-sheet/)
- [Prometheus Best Practices](https://prometheus.io/docs/practices/naming/)
- [Awesome Prometheus](https://github.com/roaldnefs/awesome-prometheus)

---

**Ready to start?** Begin with [Task 10.1 in REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md#task-101-prometheus-installation--setup)!
