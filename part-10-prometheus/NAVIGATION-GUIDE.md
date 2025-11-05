# 📚 Navigation Guide: Real-World Prometheus Tasks
# 📚 Navigation Guide: Prometheus Real-World Tasks

## Quick Overview

The real-world tasks for Part 10 (Prometheus) are organized in **two separate files** for optimal learning:

### 📝 [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)
**Contains:** Task questions, requirements, and validation checklists  
**Use this when:** You want to attempt a task on your own

### ✅ [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)
**Contains:** Complete step-by-step solutions with configurations and PromQL queries  
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
- Try to implement on your own

#### Step 4: Check Your Solution
When ready, open [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)
- Navigate to the same task number
- Compare your approach
- Learn from the differences
- Understand best practices

#### Step 5: Iterate and Improve
- Refine your solution based on what you learned
- Try variations and edge cases
- Move to the next task

---

## Task Organization

### All Tasks Include:
1. **Real-World Scenario**: Practical context from production environments
2. **Time Estimate**: Sprint planning with story points
3. **Requirements**: Clear deliverables and acceptance criteria
4. **Validation Checklist**: Step-by-step verification guide
5. **Success Criteria**: Definition of done

### Solutions Include:
1. **Step-by-Step Implementation**: Detailed setup and configuration steps
2. **Complete Configurations**: Working Prometheus configs and PromQL queries
3. **Best Practices**: Monitoring and observability recommendations
4. **Troubleshooting Tips**: Common issues and their solutions
5. **Verification Steps**: How to test and validate your work

---

## Quick Reference: All Tasks

| Task | Title | Time | Story Points |
|------|-------|------|--------------|
| 10.1 | Deploy Prometheus Stack on Kubernetes | 4-5 hrs | 1.0 |
| 10.2 | Instrument Application with Custom Metrics | 3-4 hrs | 0.5 |
| 10.3 | Create Alerting Rules and Notifications | 4-5 hrs | 1.0 |
| 10.4 | Build Grafana Dashboards for Monitoring | 3-4 hrs | 0.5 |
| 10.5 | Implement SLO-Based Alerting | 4-5 hrs | 1.0 |

---

## File Navigation Tips

### Using GitHub's Navigation
- Use the **Table of Contents** icon (top-left in file view) to see all headings
- Click any heading to jump directly to that section
- Use browser's Find (Ctrl+F / Cmd+F) to search for specific terms

### Cross-Reference Links
- Each task in REAL-WORLD-TASKS.md links to its solution
- Each solution links back to the task description
- Use these links to quickly navigate between files

### Breadcrumb Navigation
Look for navigation links at the top of each file:
```
📖 [Main README](../README.md) | [Tasks](./REAL-WORLD-TASKS.md) | [Solutions](./REAL-WORLD-TASKS-SOLUTIONS.md)
```

---

## Additional Resources

### For Deeper Learning
- **[README.md](./README.md)**: Comprehensive Prometheus guide with theory and examples
- **[Main Repository README](../README.md)**: Overview of all DevOps tasks

### For Reference
- Prometheus Documentation: https://prometheus.io/docs/
- PromQL Documentation: https://prometheus.io/docs/prometheus/latest/querying/basics/
- Alertmanager Documentation: https://prometheus.io/docs/alerting/latest/alertmanager/

---

## Tips for Effective Learning

### Before Starting
1. Read the scenario completely
2. Understand the business context
3. Identify the key requirements
4. Plan your monitoring strategy

### During Implementation
1. Start with a simple working setup
2. Test queries in Prometheus UI
3. Add complexity incrementally
4. Document as you go

### After Completion
1. Compare with the provided solution
2. Note differences in approach
3. Understand trade-offs
4. Consider scalability implications

### Common Pitfalls to Avoid
- Skipping the planning phase
- Not understanding metric types
- Ignoring cardinality issues
- Missing documentation
- Overlooking alert fatigue

---

## Need Help?

### Stuck on a Task?
1. Review the task requirements carefully
2. Check if you've met all prerequisites
3. Look at the validation checklist
4. Consult the solution file for hints
5. Review the main README for additional context

### Found an Issue?
If you notice any errors or have suggestions:
- Open an issue in the repository
- Provide specific details about the problem
- Suggest improvements if possible

---

## Track Your Progress

Consider creating a personal checklist:
- [ ] Task 10.1: Deploy Prometheus Stack on Kubernetes
- [ ] Task 10.2: Instrument Application with Custom Metrics
- [ ] Task 10.3: Create Alerting Rules and Notifications
- [ ] Task 10.4: Build Grafana Dashboards for Monitoring
- [ ] Task 10.5: Implement SLO-Based Alerting

Mark tasks as complete as you finish them!

---

**Ready to start?** Head over to [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md) and pick your first task!
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
