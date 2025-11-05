# Prometheus Monitoring & Alerting Real-World Tasks - Quick Start Guide

This guide helps you quickly find the right resource for your needs.

## 📖 How to Use These Resources

### For Learning and Practice

1. **Start with:** [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)
   - Read the scenario and requirements
   - Understand what needs to be accomplished
   - Review the validation checklist
   - Try to implement the solution yourself

2. **When you need help:** [REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)
   - Find the same task number
   - Follow the step-by-step commands
   - Use the provided configurations
   - Verify your implementation

3. **For deeper understanding:** [README.md](README.md)
   - Explore additional examples
   - Learn the "why" behind each step
   - Understand best practices
   - Review interview questions and answers

## 🎯 Quick Task Lookup

| Task | Scenario | Solution Link | Time | Difficulty |
|------|----------|---------------|------|------------|
| 10.1 | Prometheus Stack Deployment on Kubernetes | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-101-deploy-prometheus-stack-on-kubernetes) | 4-5 hrs | Medium |
| 10.2 | Application Instrumentation with Custom Metrics | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-102-instrument-application-with-custom-metrics) | 3-4 hrs | Easy |
| 10.3 | Alerting Rules and Notifications | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-103-create-alerting-rules-and-notifications) | 4-5 hrs | Medium |
| 10.4 | Grafana Dashboards for Monitoring | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-104-build-grafana-dashboards-for-monitoring) | 3-4 hrs | Easy |
| 10.5 | SLO-Based Alerting Implementation | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-105-implement-slo-based-alerting) | 4-5 hrs | Medium |

## 🔍 Find Tasks by Category

### Infrastructure Setup
- **Task 10.1**: Prometheus Stack Deployment on Kubernetes (Medium, 4-5 hrs)
  - Deploy Prometheus Operator
  - Configure ServiceMonitors
  - Set up persistent storage
  - Configure service discovery
  - Implement high availability

### Application Monitoring
- **Task 10.2**: Application Instrumentation with Custom Metrics (Easy, 3-4 hrs)
  - Add Prometheus client libraries
  - Create custom metrics
  - Expose metrics endpoint
  - Configure scrape configs
  - Test metric collection

### Alerting & Notifications
- **Task 10.3**: Alerting Rules and Notifications (Medium, 4-5 hrs)
  - Create alerting rules
  - Configure Alertmanager
  - Set up notification channels
  - Implement alert routing
  - Test alert firing

### Visualization
- **Task 10.4**: Grafana Dashboards for Monitoring (Easy, 3-4 hrs)
  - Create custom dashboards
  - Build panels with PromQL
  - Set up variables
  - Configure alerts in Grafana
  - Share and export dashboards

### Site Reliability Engineering
- **Task 10.5**: SLO-Based Alerting Implementation (Medium, 4-5 hrs)
  - Define SLIs and SLOs
  - Implement error budget calculations
  - Create SLO-based alerts
  - Set up burn rate alerts
  - Monitor error budgets

## 📊 Task Difficulty & Time Estimates

### Easy Tasks (0.5 Story Points)
Perfect for beginners or when time is limited:
- Task 10.2: Application Instrumentation with Custom Metrics (3-4 hrs)
- Task 10.4: Grafana Dashboards for Monitoring (3-4 hrs)

### Medium Tasks (1.0 Story Points)
For intermediate learners looking for challenges:
- Task 10.1: Prometheus Stack Deployment on Kubernetes (4-5 hrs)
- Task 10.3: Alerting Rules and Notifications (4-5 hrs)
- Task 10.5: SLO-Based Alerting Implementation (4-5 hrs)

## 🎓 Suggested Learning Paths

### Path 1: Beginner's Journey (Start Here!)
1. **Task 10.2**: Application Instrumentation with Custom Metrics
   - Learn metric types
   - Understand instrumentation
   - Master client libraries

2. **Task 10.1**: Prometheus Stack Deployment on Kubernetes
   - Deploy monitoring infrastructure
   - Configure service discovery
   - Learn Prometheus Operator

3. **Task 10.4**: Grafana Dashboards for Monitoring
   - Visualize metrics
   - Learn PromQL
   - Create dashboards

### Path 2: Production Monitoring Focus
1. **Task 10.1**: Prometheus Stack Deployment on Kubernetes
   - Set up monitoring infrastructure
   
2. **Task 10.2**: Application Instrumentation with Custom Metrics
   - Add application metrics
   
3. **Task 10.3**: Alerting Rules and Notifications
   - Implement proactive alerting
   
4. **Task 10.5**: SLO-Based Alerting Implementation
   - Implement SRE practices

### Path 3: Complete Observability Mastery
Complete all tasks in order:
1. Task 10.1 (Infrastructure)
2. Task 10.2 (Instrumentation)
3. Task 10.4 (Visualization)
4. Task 10.3 (Alerting)
5. Task 10.5 (SLO/SRE)

## ⚡ Quick Start Steps

### 1. Prerequisites Check
Before starting any task, ensure you have:
- [ ] Kubernetes cluster (minikube, kind, or cloud)
- [ ] kubectl installed
- [ ] Helm installed (v3+)
- [ ] Basic understanding of PromQL
- [ ] Understanding of monitoring concepts
- [ ] Text editor (VS Code recommended)

### 2. Environment Setup
```bash
# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify installation
helm version

# Add Prometheus community Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create namespace
kubectl create namespace monitoring

# Clone repository
git clone https://github.com/Dhananjaiah/DevOps-Tasks-2026.git
cd DevOps-Tasks-2026/part-10-prometheus

# Create working directory
mkdir -p ~/prometheus-practice
cd ~/prometheus-practice
```

### 3. Pick Your First Task
- Review the task categories above
- Choose based on your skill level
- Note the time estimate
- Open [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)

### 4. Implementation Workflow
```
Read Task → Plan Metrics → Configure → Deploy → Test → Alert → Visualize → Compare with Solution
```

## 🛠️ Common Tools & Commands

### Essential PromQL Queries
```promql
# CPU usage
rate(container_cpu_usage_seconds_total[5m])

# Memory usage
container_memory_usage_bytes

# HTTP request rate
rate(http_requests_total[5m])

# Error rate
rate(http_requests_total{status=~"5.."}[5m])

# Latency percentiles
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

### Prometheus Commands
```bash
# Check Prometheus status
kubectl get pods -n monitoring

# Port forward Prometheus
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090

# Check targets
curl http://localhost:9090/api/v1/targets

# Query metrics
curl http://localhost:9090/api/v1/query?query=up

# Check alerts
curl http://localhost:9090/api/v1/alerts
```

### Testing & Validation
```bash
# Test PromQL query
promtool query instant http://localhost:9090 'up'

# Validate rules file
promtool check rules rules.yaml

# Validate config
promtool check config prometheus.yml

# Test Alertmanager config
amtool check-config alertmanager.yml
```

## 📋 Task Completion Checklist

For each task you complete, verify:
- [ ] Meets all requirements from task description
- [ ] Follows Prometheus best practices
- [ ] Uses appropriate metric types
- [ ] Has proper labeling strategy
- [ ] Avoids high cardinality
- [ ] Documentation included
- [ ] Tested successfully
- [ ] Alerts properly configured
- [ ] Dashboards created
- [ ] Compared with provided solution

## 💡 Pro Tips

### Best Practices
1. **Choose the right metric type**: Counter, Gauge, Histogram, or Summary
2. **Use labels wisely**: Avoid high cardinality
3. **Implement recording rules**: Pre-calculate complex queries
4. **Set appropriate scrape intervals**: Balance freshness and load
5. **Use service discovery**: Automatic target discovery
6. **Document your metrics**: Include descriptions and labels

### Troubleshooting
1. **Check targets**: Verify scrape targets are up
2. **Review logs**: Check Prometheus logs for errors
3. **Test queries**: Use Prometheus UI to test PromQL
4. **Verify labels**: Ensure label names are valid
5. **Check cardinality**: Monitor metric cardinality

### Time-Saving Tricks
1. **Use Prometheus Operator**: Simplify deployment
2. **Use pre-built dashboards**: Import from Grafana.com
3. **Use recording rules**: Speed up complex queries
4. **Use templates**: Reuse alert rules
5. **Use mixins**: Standardized monitoring configs

## 🔗 Quick Links

### Documentation
- [Main README](../README.md) - Repository overview
- [Prometheus Docs](https://prometheus.io/docs/) - Official documentation
- [PromQL Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)

### Within This Section
- [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md) - Task descriptions
- [REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md) - Complete solutions
- [README.md](README.md) - Detailed Prometheus guide

## 📈 Track Your Progress

| Task | Status | Date Completed | Notes |
|------|--------|----------------|-------|
| 10.1 | ⬜     |                |       |
| 10.2 | ⬜     |                |       |
| 10.3 | ⬜     |                |       |
| 10.4 | ⬜     |                |       |
| 10.5 | ⬜     |                |       |

Status Legend: ⬜ Not Started | 🔄 In Progress | ✅ Completed

---

**Ready to begin?** Choose your first task from [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md) and start building! 🚀
