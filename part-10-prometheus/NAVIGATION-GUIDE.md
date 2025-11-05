# 📚 Navigation Guide: Prometheus Real-World Tasks

## Quick Overview

The real-world tasks for Part 10 (Prometheus) are organized in **two separate files** for optimal learning:

### 📝 [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)
**Contains:** Task questions, requirements, and validation checklists  
**Use this when:** You want to attempt a task on your own

### ✅ [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)
**Contains:** Complete step-by-step solutions with configurations and code  
**Use this when:** You need to verify your solution or get unblocked

---

## Why Two Files?

### Learning Benefits
- **Encourages self-learning**: Try the task before seeing the solution
- **Prevents accidental spoilers**: Solutions are in a separate file
- **Easy comparison**: Compare your approach with the official solution
- **Better organization**: Clear separation of questions and answers

### Navigation Features
Both files include:
- ✅ Links to navigate between tasks and solutions
- ✅ Quick reference tables with all tasks
- ✅ Direct links to specific sections
- ✅ Breadcrumb navigation at the top

---

## How to Use These Files

### Recommended Workflow

#### Step 1: Open the Tasks File
Start with [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)

#### Step 2: Choose a Task
Use the **Task Index** table to select a task based on:
- Your skill level
- Time available
- Topic of interest

#### Step 3: Attempt the Task
- Read the scenario carefully
- Note the time limit
- Follow the requirements
- Complete the validation checklist

#### Step 4: When You Need Help
Click the **"View Complete Solution"** link at the top of any task to jump directly to its solution

#### Step 5: Compare Your Solution
After completing the task:
1. Open the solution file
2. Compare your approach
3. Learn from differences
4. Note any best practices you missed

---

## Navigation Tips

### From Tasks to Solutions
Every task has a solution link in two places:
1. **Task Index table** - Quick access from the index
2. **Task header** - Direct link at the start of each task

Example:
```
## Task 10.5: PromQL Query Optimization

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-105-promql-query-optimization)
```

### From Solutions to Tasks
Every solution has a back link:
```
## Task 10.5: PromQL Query Optimization

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-105-promql-query-optimization)
```

### Keep Both Files Open
**Pro Tip:** Open both files in separate browser tabs or editor panes for easy switching!

---

## File Structure at a Glance

```
part-10-prometheus/
│
├── REAL-WORLD-TASKS.md              ← Start here (Questions)
│   ├── Overview & instructions
│   ├── Task Index (with solution links)
│   ├── Task 10.1 with requirements
│   ├── Task 10.2 with requirements
│   └── ... (18 tasks total)
│
├── REAL-WORLD-TASKS-SOLUTIONS.md    ← Reference here (Answers)
│   ├── Overview & warnings
│   ├── Table of Contents
│   ├── Task 10.1 solution (with back link)
│   ├── Task 10.2 solution (with back link)
│   └── ... (18 solutions total)
│
└── NAVIGATION-GUIDE.md              ← You are here!
```

---

## Quick Reference

### All 18 Tasks Overview

| Task # | Name | Difficulty | Time | Files |
|--------|------|------------|------|-------|
| 10.1 | Prometheus Installation & Setup | Medium | 90 min | [Task](./REAL-WORLD-TASKS.md#task-101-prometheus-installation--setup) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-101-prometheus-installation--setup) |
| 10.2 | Node Exporter Deployment | Easy | 45 min | [Task](./REAL-WORLD-TASKS.md#task-102-node-exporter-deployment) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-102-node-exporter-deployment) |
| 10.3 | Application Metrics with Client Libraries | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-103-application-metrics-with-client-libraries) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-103-application-metrics-with-client-libraries) |
| 10.4 | Service Discovery Configuration | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-104-service-discovery-configuration) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-104-service-discovery-configuration) |
| 10.5 | PromQL Query Optimization | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-105-promql-query-optimization) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-105-promql-query-optimization) |
| 10.6 | Recording Rules Implementation | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-106-recording-rules-implementation) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-106-recording-rules-implementation) |
| 10.7 | Alerting Rules Configuration | Medium | 90 min | [Task](./REAL-WORLD-TASKS.md#task-107-alerting-rules-configuration) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-107-alerting-rules-configuration) |
| 10.8 | Alertmanager Setup & Integration | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-108-alertmanager-setup--integration) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-108-alertmanager-setup--integration) |
| 10.9 | Alert Routing & Grouping | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-109-alert-routing--grouping) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-109-alert-routing--grouping) |
| 10.10 | SLO-Based Alerting | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-1010-slo-based-alerting) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-1010-slo-based-alerting) |
| 10.11 | Blackbox Exporter for Endpoint Monitoring | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-1011-blackbox-exporter-for-endpoint-monitoring) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-1011-blackbox-exporter-for-endpoint-monitoring) |
| 10.12 | Pushgateway for Batch Jobs | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-1012-pushgateway-for-batch-jobs) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-1012-pushgateway-for-batch-jobs) |
| 10.13 | High Availability Prometheus Setup | Hard | 120 min | [Task](./REAL-WORLD-TASKS.md#task-1013-high-availability-prometheus-setup) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-1013-high-availability-prometheus-setup) |
| 10.14 | Long-term Storage with Thanos | Hard | 120 min | [Task](./REAL-WORLD-TASKS.md#task-1014-long-term-storage-with-thanos) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-1014-long-term-storage-with-thanos) |
| 10.15 | Kubernetes Monitoring with kube-state-metrics | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-1015-kubernetes-monitoring-with-kube-state-metrics) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-1015-kubernetes-monitoring-with-kube-state-metrics) |
| 10.16 | Custom Exporter Development | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-1016-custom-exporter-development) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-1016-custom-exporter-development) |
| 10.17 | Prometheus Federation Setup | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-1017-prometheus-federation-setup) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-1017-prometheus-federation-setup) |
| 10.18 | Performance Tuning & Troubleshooting | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-1018-performance-tuning--troubleshooting) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-1018-performance-tuning--troubleshooting) |

---

## Need Help?

### If You're Lost
1. **Start here:** [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)
2. **Read the overview** to understand the task structure
3. **Use the Task Index** to find a task matching your skill level
4. **Follow the recommended workflow** above

### If You're Stuck on a Task
1. **Review the validation checklist** - it often contains hints
2. **Click the solution link** at the top of the task
3. **Compare your approach** with the official solution
4. **Learn from the differences**

### Common Questions

**Q: Should I look at the solution before attempting the task?**  
A: No! Try the task first. The learning happens when you struggle a bit. Use the solution only when stuck or to verify your approach.

**Q: Are the solutions the only correct way?**  
A: No! There are usually multiple valid approaches. The solutions show one production-ready approach with best practices.

**Q: Can I modify the tasks?**  
A: Absolutely! Feel free to adjust scenarios, add requirements, or create variations based on your environment.

**Q: How do I track my progress?**  
A: Keep a personal checklist or use the Task Index table to mark completed tasks.

---

## Related Documents

- 📖 [Part 10 README](./README.md) - Overview of all Part 10 materials
- 🚀 [Quick Start Guide](./QUICK-START-GUIDE.md) - Getting started with Prometheus tasks
- 📊 [Task Status](../TASK_STATUS.md) - Track completion status
- 🏠 [Main README](../README.md) - Repository home page

---

**Happy Learning!** 🚀

Remember: The goal is not just to complete tasks, but to truly understand Prometheus concepts and be able to apply them in real production scenarios.
