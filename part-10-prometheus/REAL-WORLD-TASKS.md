# Prometheus Monitoring & Alerting - Real-World Tasks

> 📚 **Navigation:** [Quick Start Guide](QUICK-START-GUIDE.md) | [Navigation Guide](NAVIGATION-GUIDE.md) | [Solutions](REAL-WORLD-TASKS-SOLUTIONS.md) | [Main README](../README.md)

---

## 🎯 Overview

This document contains **18 production-ready Prometheus monitoring tasks** designed for DevOps engineers. Each task represents real-world scenarios you'll encounter when implementing observability in production environments.

**What Makes These Tasks Special:**
- ✅ Based on actual production use cases
- ✅ Includes time estimates for planning
- ✅ Complete validation checklists
- ✅ Links to detailed solutions
- ✅ Interview-focused scenarios

---

## 📋 Task Index

| # | Task Name | Difficulty | Time | Quick Link |
|---|-----------|------------|------|------------|
| 10.1 | Prometheus Installation & Setup | Medium | 90 min | [View Task](#task-101-prometheus-installation--setup) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-101-prometheus-installation--setup) |
| 10.2 | Node Exporter Deployment | Easy | 45 min | [View Task](#task-102-node-exporter-deployment) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-102-node-exporter-deployment) |
| 10.3 | Application Metrics with Client Libraries | Medium | 75 min | [View Task](#task-103-application-metrics-with-client-libraries) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-103-application-metrics-with-client-libraries) |
| 10.4 | Service Discovery Configuration | Hard | 90 min | [View Task](#task-104-service-discovery-configuration) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-104-service-discovery-configuration) |
| 10.5 | PromQL Query Optimization | Medium | 60 min | [View Task](#task-105-promql-query-optimization) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-105-promql-query-optimization) |
| 10.6 | Recording Rules Implementation | Medium | 75 min | [View Task](#task-106-recording-rules-implementation) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-106-recording-rules-implementation) |
| 10.7 | Alerting Rules Configuration | Medium | 90 min | [View Task](#task-107-alerting-rules-configuration) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-107-alerting-rules-configuration) |
| 10.8 | Alertmanager Setup & Integration | Hard | 90 min | [View Task](#task-108-alertmanager-setup--integration) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-108-alertmanager-setup--integration) |
| 10.9 | Alert Routing & Grouping | Medium | 60 min | [View Task](#task-109-alert-routing--grouping) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-109-alert-routing--grouping) |
| 10.10 | SLO-Based Alerting | Hard | 90 min | [View Task](#task-1010-slo-based-alerting) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-1010-slo-based-alerting) |
| 10.11 | Blackbox Exporter for Endpoint Monitoring | Medium | 75 min | [View Task](#task-1011-blackbox-exporter-for-endpoint-monitoring) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-1011-blackbox-exporter-for-endpoint-monitoring) |
| 10.12 | Pushgateway for Batch Jobs | Medium | 60 min | [View Task](#task-1012-pushgateway-for-batch-jobs) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-1012-pushgateway-for-batch-jobs) |
| 10.13 | High Availability Prometheus Setup | Hard | 120 min | [View Task](#task-1013-high-availability-prometheus-setup) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-1013-high-availability-prometheus-setup) |
| 10.14 | Long-term Storage with Thanos | Hard | 120 min | [View Task](#task-1014-long-term-storage-with-thanos) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-1014-long-term-storage-with-thanos) |
| 10.15 | Kubernetes Monitoring with kube-state-metrics | Medium | 75 min | [View Task](#task-1015-kubernetes-monitoring-with-kube-state-metrics) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-1015-kubernetes-monitoring-with-kube-state-metrics) |
| 10.16 | Custom Exporter Development | Hard | 90 min | [View Task](#task-1016-custom-exporter-development) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-1016-custom-exporter-development) |
| 10.17 | Prometheus Federation Setup | Medium | 75 min | [View Task](#task-1017-prometheus-federation-setup) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-1017-prometheus-federation-setup) |
| 10.18 | Performance Tuning & Troubleshooting | Hard | 90 min | [View Task](#task-1018-performance-tuning--troubleshooting) · [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-1018-performance-tuning--troubleshooting) |

---

## Task 10.1: Prometheus Installation & Setup

> 📖 [View Complete Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-101-prometheus-installation--setup)

### 🎬 Real-World Scenario

Your company is moving towards a microservices architecture with multiple services deployed across EC2 instances and Kubernetes clusters. The operations team needs a centralized monitoring solution to track service health, performance metrics, and resource utilization. You've been tasked with setting up Prometheus as the monitoring backbone.

**Business Context:**
- 15+ microservices running in production
- Current monitoring is fragmented (CloudWatch, custom scripts)
- Need unified view of system health
- Must support both VM and container-based workloads
- Budget approved for monitoring infrastructure

### ⏱️ Time to Complete
**90 minutes** (Beginner: 120 min | Expert: 60 min)

### 📋 Requirements

**Core Requirements:**
1. Install Prometheus server on Ubuntu 20.04 server
2. Configure Prometheus as a systemd service
3. Set up proper data retention (15 days)
4. Configure scrape intervals and evaluation intervals
5. Enable Prometheus web UI access
6. Implement basic security (firewall rules)

**Configuration Requirements:**
1. Scrape interval: 15 seconds
2. Evaluation interval: 15 seconds
3. Data retention: 15 days or 10GB (whichever comes first)
4. External labels for cluster/environment identification
5. Enable lifecycle API for configuration reloads

**Security Requirements:**
1. Run Prometheus as non-root user
2. Configure UFW firewall rules
3. Restrict access to Prometheus port (9090)
4. Set up proper file permissions

### ✅ Validation Checklist

**Installation Validation:**
- [ ] Prometheus binary installed in `/usr/local/bin/`
- [ ] Prometheus user created with no login shell
- [ ] Configuration directory created at `/etc/prometheus/`
- [ ] Data directory created at `/var/lib/prometheus/`
- [ ] Proper ownership set for all Prometheus directories

**Configuration Validation:**
- [ ] `prometheus.yml` is valid (test with `promtool check config`)
- [ ] Scrape interval set to 15s
- [ ] Evaluation interval set to 15s
- [ ] External labels configured
- [ ] Retention policy configured (15d and 10GB)

**Service Validation:**
- [ ] Systemd service file created
- [ ] Prometheus service starts successfully
- [ ] Prometheus service enabled at boot
- [ ] Service restarts on failure
- [ ] Logs accessible via `journalctl`

**Functionality Validation:**
- [ ] Prometheus UI accessible at `http://server-ip:9090`
- [ ] Prometheus scraping itself (check targets page)
- [ ] Can execute basic PromQL queries (`up`, `prometheus_build_info`)
- [ ] Configuration reload works (`curl -X POST http://localhost:9090/-/reload`)
- [ ] Health endpoint returns OK (`/-/healthy`)

**Security Validation:**
- [ ] Prometheus runs as `prometheus` user (not root)
- [ ] UFW firewall configured
- [ ] Only necessary ports open
- [ ] File permissions are secure (not world-readable/writable)

### 📦 Deliverables

1. **Prometheus Installation Script**
   - Bash script to automate installation
   - Include all prerequisite checks
   - Should be idempotent

2. **Configuration Files**
   - `prometheus.yml` with all required settings
   - Systemd service file
   - UFW configuration

3. **Documentation**
   - Installation steps
   - Configuration explanations
   - How to verify installation
   - Troubleshooting common issues

4. **Verification Report**
   - Screenshots of Prometheus UI
   - Output of validation commands
   - Service status output

### 🎯 Success Criteria

- Prometheus is installed and running as a system service
- Web UI is accessible and functional
- Prometheus is scraping itself successfully
- Configuration can be reloaded without restart
- All validation checks pass
- Documentation is clear and complete

### 💡 Hints

<details>
<summary>Click to view hints</summary>

1. Use `promtool` to validate configuration before starting Prometheus
2. Keep a terminal with `systemctl status prometheus` open while testing
3. Check logs with `journalctl -u prometheus -f` for real-time debugging
4. Test configuration reload before closing your working session
5. Make sure to set ownership on directories before starting service

</details>

### 🔍 Common Pitfalls

- **Pitfall 1:** Starting Prometheus without fixing file permissions
  - *Impact:* Service fails to start or write data
  - *Prevention:* Always run `chown` commands before starting service

- **Pitfall 2:** Not validating configuration file syntax
  - *Impact:* Service starts but doesn't work properly
  - *Prevention:* Use `promtool check config` before every start/reload

- **Pitfall 3:** Forgetting to open firewall ports
  - *Impact:* Cannot access Prometheus UI
  - *Prevention:* Configure UFW before testing UI access

---

## Task 10.2: Node Exporter Deployment

> 📖 [View Complete Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-102-node-exporter-deployment)

### 🎬 Real-World Scenario

After setting up Prometheus, you need to collect system-level metrics (CPU, memory, disk, network) from all Linux servers in your infrastructure. Node Exporter is the standard exporter for hardware and OS metrics. You have 20 Ubuntu servers across production and staging environments that need monitoring.

**Business Context:**
- Need visibility into server resource utilization
- Track disk space to prevent outages
- Monitor CPU and memory for capacity planning
- Detect network issues early
- Support both physical and virtual machines

### ⏱️ Time to Complete
**45 minutes** (Beginner: 60 min | Expert: 30 min)

### 📋 Requirements

**Core Requirements:**
1. Install Node Exporter on all target servers
2. Configure Node Exporter as systemd service
3. Expose metrics on port 9100
4. Configure Prometheus to scrape Node Exporter targets
5. Add labels for environment and region

**Node Exporter Requirements:**
1. Run as dedicated user
2. Enable textfile collector for custom metrics
3. Disable unnecessary collectors
4. Configure TLS (bonus: not required for basic setup)

**Prometheus Configuration:**
1. Create separate job for node metrics
2. Add static targets for servers
3. Include environment labels (prod/staging)
4. Set appropriate scrape interval (15s or 30s)

### ✅ Validation Checklist

**Installation:**
- [ ] Node Exporter installed on target servers
- [ ] Node Exporter user created
- [ ] Systemd service configured
- [ ] Service enabled and running

**Metrics Exposure:**
- [ ] Metrics accessible at `http://server:9100/metrics`
- [ ] Key metrics visible (node_cpu_*, node_memory_*, node_disk_*)
- [ ] Textfile collector directory created
- [ ] Custom metrics can be added via textfile

**Prometheus Integration:**
- [ ] Scrape configuration added to `prometheus.yml`
- [ ] Targets showing as "UP" in Prometheus UI
- [ ] Metrics queryable via PromQL
- [ ] Labels applied correctly

**Monitoring Verification:**
- [ ] CPU metrics: `rate(node_cpu_seconds_total[5m])`
- [ ] Memory metrics: `node_memory_AvailMem_bytes`
- [ ] Disk metrics: `node_filesystem_avail_bytes`
- [ ] Network metrics: `rate(node_network_receive_bytes_total[5m])`

### 📦 Deliverables

1. **Installation Script**
   - Automated Node Exporter installation
   - Systemd service configuration
   - Works on Ubuntu 20.04/22.04

2. **Prometheus Configuration**
   - Updated `prometheus.yml`
   - Node Exporter scrape configuration
   - Proper labeling strategy

3. **Documentation**
   - Installation procedure
   - Available metrics reference
   - Common queries for node metrics

4. **Verification**
   - List of all monitored nodes
   - Sample metrics output
   - Dashboard recommendations

### 🎯 Success Criteria

- Node Exporter running on all target servers
- Metrics successfully scraped by Prometheus
- Can query system metrics via PromQL
- Services configured to auto-start on boot
- Labels correctly identify servers

---

## Task 10.3: Application Metrics with Client Libraries

> 📖 [View Complete Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-103-application-metrics-with-client-libraries)

### 🎬 Real-World Scenario

Your team maintains a REST API built with Python Flask that handles customer requests. To understand application behavior, you need to instrument the code to expose metrics about request rates, latencies, error rates, and business metrics (e.g., orders processed, revenue). This is critical for understanding SLOs and troubleshooting production issues.

**Business Context:**
- Production API serving 1000+ requests per second
- Need to track 99th percentile latency for SLA compliance
- Must monitor error rates to catch issues early
- Business wants visibility into transactions and revenue
- Support debugging performance problems

### ⏱️ Time to Complete
**75 minutes** (Beginner: 90 min | Expert: 60 min)

### 📋 Requirements

**Instrumentation Requirements:**
1. Add Prometheus client library to application
2. Expose `/metrics` endpoint
3. Implement counter for total requests
4. Implement histogram for request duration
5. Implement gauge for active connections
6. Add business metrics (orders, revenue)

**Metric Types to Implement:**
1. **Counter:** `http_requests_total` (by method, endpoint, status)
2. **Histogram:** `http_request_duration_seconds`
3. **Gauge:** `active_connections`, `queue_size`
4. **Counter:** `orders_total`, `revenue_total`

**Best Practices:**
1. Follow Prometheus naming conventions
2. Use appropriate metric types
3. Add relevant labels (but not high cardinality!)
4. Include help text for each metric
5. Avoid storing PII in metric labels

**Prometheus Configuration:**
1. Add scrape config for application
2. Configure ServiceMonitor (if using Kubernetes)
3. Set appropriate scrape interval

### ✅ Validation Checklist

**Code Instrumentation:**
- [ ] Prometheus client library installed
- [ ] `/metrics` endpoint exposed
- [ ] Metrics follow naming conventions
- [ ] Help text provided for each metric
- [ ] Labels are appropriate (low cardinality)

**Metric Implementation:**
- [ ] Counter metrics increment correctly
- [ ] Histogram metrics record durations
- [ ] Gauge metrics reflect current state
- [ ] Business metrics track correctly
- [ ] No PII in labels

**Integration:**
- [ ] Application serves metrics on `/metrics`
- [ ] Metrics format is correct (Prometheus text format)
- [ ] Prometheus scrapes application successfully
- [ ] Metrics queryable in Prometheus

**Functionality:**
- [ ] Can track request rate: `rate(http_requests_total[5m])`
- [ ] Can calculate latency percentiles: `histogram_quantile(0.99, ...)`
- [ ] Can monitor error rate: `rate(http_requests_total{status=~"5.."}[5m])`
- [ ] Business metrics update in real-time

### 📦 Deliverables

1. **Instrumented Application Code**
   - Modified source code with metrics
   - Documented code changes
   - Unit tests for metrics

2. **Metrics Documentation**
   - List of all exposed metrics
   - Metric type and purpose
   - Example queries for each metric

3. **Prometheus Configuration**
   - Scrape configuration
   - Example recording rules
   - Example alerting rules

4. **Dashboard JSON**
   - Grafana dashboard (optional but recommended)
   - Key visualizations
   - SLI tracking

### 🎯 Success Criteria

- Application exposes metrics endpoint
- All required metric types implemented
- Metrics follow Prometheus best practices
- Can calculate SLIs from exposed metrics
- No performance impact on application

---

## Task 10.4: Service Discovery Configuration

> 📖 [View Complete Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-104-service-discovery-configuration)

### 🎬 Real-World Scenario

Your infrastructure is dynamic - EC2 instances and Kubernetes pods are constantly being created and destroyed. Managing static targets in Prometheus configuration is not scalable. You need to implement service discovery to automatically detect and monitor new targets without manual configuration updates.

**Business Context:**
- Auto-scaling groups add/remove instances
- Kubernetes deployments scale based on load
- Manual target management is error-prone
- Need immediate monitoring of new instances
- Support multi-region deployments

### ⏱️ Time to Complete
**90 minutes** (Beginner: 120 min | Expert: 75 min)

### 📋 Requirements

**Service Discovery Types:**
1. Configure EC2 service discovery for AWS instances
2. Configure Kubernetes service discovery
3. Implement file-based service discovery (bonus)
4. Configure relabeling rules

**EC2 Service Discovery:**
1. Use AWS SDK credentials
2. Filter instances by tags
3. Use private IP addresses
4. Add metadata as labels

**Kubernetes Service Discovery:**
1. Configure for pods
2. Configure for services
3. Configure for endpoints
4. Add namespace and pod labels

**Relabeling:**
1. Keep only necessary labels
2. Rename labels for clarity
3. Drop unwanted targets
4. Add custom labels

### ✅ Validation Checklist

**EC2 Discovery:**
- [ ] IAM permissions configured
- [ ] Service discovery finds EC2 instances
- [ ] Correct instances filtered by tags
- [ ] Instance metadata available as labels
- [ ] Targets automatically updated

**Kubernetes Discovery:**
- [ ] RBAC configured correctly
- [ ] Pods discovered automatically
- [ ] Services discovered correctly
- [ ] Namespace filtering works
- [ ] Pod labels applied

**Relabeling:**
- [ ] Unnecessary labels dropped
- [ ] Labels renamed for clarity
- [ ] Custom labels added
- [ ] No label conflicts
- [ ] Low cardinality maintained

**Functionality:**
- [ ] New targets discovered automatically
- [ ] Terminated targets removed
- [ ] Metadata labels useful for querying
- [ ] Relabeling doesn't break existing queries

### 📦 Deliverables

1. **Prometheus Configuration**
   - Complete service discovery configs
   - Relabeling rules
   - Comments explaining each rule

2. **IAM/RBAC Configuration**
   - AWS IAM policy (for EC2 discovery)
   - Kubernetes RBAC rules
   - Security considerations

3. **Documentation**
   - How service discovery works
   - Relabeling rules explanation
   - Troubleshooting guide

4. **Testing Results**
   - Screenshots of discovered targets
   - Before/after relabeling examples
   - Verification of auto-discovery

### 🎯 Success Criteria

- Service discovery automatically finds targets
- New instances monitored within scrape interval
- Removed instances cleaned up promptly
- Labels are useful and not excessive
- No manual target management needed

---

## Task 10.5: PromQL Query Optimization

> 📖 [View Complete Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-105-promql-query-optimization)

### 🎬 Real-World Scenario

Dashboards are loading slowly, and some queries time out during peak hours. You need to optimize PromQL queries to reduce load on Prometheus and improve dashboard performance. This involves understanding query patterns, using recording rules, and writing efficient PromQL.

**Business Context:**
- Grafana dashboards timeout during business hours
- Complex queries causing Prometheus CPU spikes
- Need to support more concurrent users
- Must maintain query accuracy
- Cannot add more Prometheus servers yet

### ⏱️ Time to Complete
**60 minutes** (Beginner: 75 min | Expert: 45 min)

### 📋 Requirements

**Query Analysis:**
1. Identify slow queries in Prometheus logs
2. Analyze query patterns
3. Find queries with high cardinality
4. Identify redundant calculations

**Optimization Techniques:**
1. Use recording rules for complex queries
2. Optimize aggregation operations
3. Reduce time ranges where possible
4. Use `rate()` vs `irate()` appropriately
5. Avoid regex matching in labels

**Recording Rules:**
1. Create rules for dashboard queries
2. Set appropriate evaluation intervals
3. Organize rules into groups
4. Name rules following conventions

**Best Practices:**
1. Limit label combinations
2. Use label matchers efficiently
3. Avoid Cartesian products
4. Pre-aggregate when possible

### ✅ Validation Checklist

**Query Analysis:**
- [ ] Slow queries identified
- [ ] Cardinality issues found
- [ ] Query patterns documented
- [ ] Baseline performance measured

**Recording Rules:**
- [ ] Rules created for slow queries
- [ ] Rules validate successfully
- [ ] Evaluation intervals appropriate
- [ ] Rule names follow conventions

**Optimization Results:**
- [ ] Dashboard load times improved
- [ ] Prometheus CPU usage reduced
- [ ] Query timeouts eliminated
- [ ] Results remain accurate

**Best Practices:**
- [ ] High-cardinality queries optimized
- [ ] Regex matchers minimized
- [ ] Appropriate functions used
- [ ] Time ranges optimized

### 📦 Deliverables

1. **Query Optimization Report**
   - List of slow queries
   - Before/after performance
   - Optimization techniques used

2. **Recording Rules File**
   - All recording rules
   - Comments explaining each rule
   - Organized into logical groups

3. **Best Practices Guide**
   - PromQL optimization tips
   - Common anti-patterns to avoid
   - When to use recording rules

4. **Performance Metrics**
   - Query execution times
   - Prometheus resource usage
   - Dashboard load times

### 🎯 Success Criteria

- All dashboards load within 3 seconds
- No query timeouts under normal load
- Prometheus CPU usage reduced by 30%+
- Recording rules cover frequently used queries
- Queries remain accurate after optimization

---

*[Additional tasks 10.6-10.18 would follow the same detailed format]*

---

## 📚 Additional Resources

- [Navigation Guide](NAVIGATION-GUIDE.md) - How to use these tasks effectively
- [Quick Start Guide](QUICK-START-GUIDE.md) - Fast-track learning paths
- [Solutions](REAL-WORLD-TASKS-SOLUTIONS.md) - Complete implementations

---

**Ready to Start?** Pick a task from the index above and begin your Prometheus journey!
