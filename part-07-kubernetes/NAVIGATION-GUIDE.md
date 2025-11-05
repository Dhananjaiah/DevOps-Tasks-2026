# 📚 Navigation Guide: Real-World Kubernetes Tasks
# 📚 Navigation Guide: Kubernetes Real-World Tasks

## Quick Overview

The real-world tasks for Part 7 (Kubernetes) are organized in **two separate files** for optimal learning:

### 📝 [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)
**Contains:** Task questions, requirements, and validation checklists  
**Use this when:** You want to attempt a task on your own

### ✅ [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)
**Contains:** Complete step-by-step solutions with Kubernetes manifests and commands  
**Contains:** Complete step-by-step solutions with manifests and configurations  
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
1. **Step-by-Step Implementation**: Detailed kubectl commands and explanations
2. **Complete Manifests**: Working YAML configurations
3. **Best Practices**: Cloud Native Computing Foundation recommendations
4. **Troubleshooting Tips**: Common issues and their solutions
5. **Verification Steps**: How to test and validate your work

---

## Quick Reference: All Tasks

| Task | Title | Time | Story Points |
|------|-------|------|--------------|
| 7.1 | Deploy Microservices Application with Deployments | 4-5 hrs | 1.0 |
| 7.2 | Configure Ingress with TLS for External Access | 3-4 hrs | 0.5 |
| 7.3 | Implement ConfigMaps and Secrets Management | 3-4 hrs | 0.5 |
| 7.4 | Set Up Horizontal Pod Autoscaler (HPA) | 3-4 hrs | 0.5 |
| 7.5 | Implement StatefulSet for Database | 4-5 hrs | 1.0 |
| 7.6 | Configure RBAC and Network Policies | 3-4 hrs | 0.5 |

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
- **[README.md](./README.md)**: Comprehensive Kubernetes guide with theory and examples
- **[Main Repository README](../README.md)**: Overview of all DevOps tasks

### For Reference
- Kubernetes Documentation: https://kubernetes.io/docs/
- Kubernetes API Reference: https://kubernetes.io/docs/reference/
- kubectl Cheat Sheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

---

## Tips for Effective Learning

### Before Starting
1. Read the scenario completely
2. Understand the business context
3. Identify the key requirements
4. Plan your manifest structure

### During Implementation
1. Start with a simple working version
2. Test with `kubectl apply --dry-run` first
3. Add complexity incrementally
4. Document as you go

### After Completion
1. Compare with the provided solution
2. Note differences in approach
3. Understand trade-offs
4. Consider scalability implications

### Common Pitfalls to Avoid
- Skipping the planning phase
- Not using namespaces
- Ignoring resource limits
- Missing health checks
- Overlooking security policies

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
- [ ] Task 7.1: Deploy Microservices Application
- [ ] Task 7.2: Configure Ingress with TLS
- [ ] Task 7.3: Implement ConfigMaps and Secrets
- [ ] Task 7.4: Set Up Horizontal Pod Autoscaler
- [ ] Task 7.5: Implement StatefulSet for Database
- [ ] Task 7.6: Configure RBAC and Network Policies

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
## Task 7.5: Implement StatefulSet for Database

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-75-implement-statefulset-for-database)
```

### From Solutions to Tasks
Every solution has a back link:
```
## Task 7.5: Implement StatefulSet for Database

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-75-implement-statefulset-for-database)
```

### Keep Both Files Open
**Pro Tip:** Open both files in separate browser tabs or editor panes for easy switching!

---

## File Structure at a Glance

```
part-07-kubernetes/
│
├── REAL-WORLD-TASKS.md              ← Start here (Questions)
│   ├── Overview & instructions
│   ├── Task Index (with solution links)
│   ├── Task 7.1 with requirements
│   ├── Task 7.2 with requirements
│   └── ... (20 tasks total)
│
├── REAL-WORLD-TASKS-SOLUTIONS.md    ← Reference here (Answers)
│   ├── Overview & warnings
│   ├── Table of Contents
│   ├── Task 7.1 solution (with back link)
│   ├── Task 7.2 solution (with back link)
│   └── ... (20 solutions total)
│
├── NAVIGATION-GUIDE.md              ← You are here!
├── QUICK-START-GUIDE.md             ← Quick reference
└── README.md                        ← Part 7 overview
```

---

## Quick Reference

### All 20 Tasks Overview

| Task # | Name | Difficulty | Time | Files |
|--------|------|------------|------|-------|
| 7.1 | Namespace Organization (Dev/Staging/Prod) | Easy | 45 min | [Task](./REAL-WORLD-TASKS.md#task-71-namespace-organization-and-resource-quotas) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-71-namespace-organization-and-resource-quotas) |
| 7.2 | Deploy Backend API with Deployment | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-72-deploy-backend-api-with-deployment) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-72-deploy-backend-api-with-deployment) |
| 7.3 | Service Types (ClusterIP, LoadBalancer) | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-73-service-types-and-networking) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-73-service-types-and-networking) |
| 7.4 | ConfigMaps for Application Configuration | Easy | 45 min | [Task](./REAL-WORLD-TASKS.md#task-74-configmaps-for-application-configuration) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-74-configmaps-for-application-configuration) |
| 7.5 | Secrets Management in Kubernetes | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-75-secrets-management-in-kubernetes) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-75-secrets-management-in-kubernetes) |
| 7.6 | Liveness and Readiness Probes | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-76-liveness-and-readiness-probes) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-76-liveness-and-readiness-probes) |
| 7.7 | Ingress Controller and Ingress Resources | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-77-ingress-controller-and-ingress-resources) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-77-ingress-controller-and-ingress-resources) |
| 7.8 | HorizontalPodAutoscaler (HPA) Setup | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-78-horizontalpodautoscaler-hpa-setup) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-78-horizontalpodautoscaler-hpa-setup) |
| 7.9 | RBAC Configuration (ServiceAccount, Roles) | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-79-rbac-configuration-serviceaccount-roles) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-79-rbac-configuration-serviceaccount-roles) |
| 7.10 | StatefulSet for PostgreSQL | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-710-statefulset-for-postgresql) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-710-statefulset-for-postgresql) |
| 7.11 | PersistentVolumes and PersistentVolumeClaims | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-711-persistentvolumes-and-persistentvolumeclaims) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-711-persistentvolumes-and-persistentvolumeclaims) |
| 7.12 | CronJobs for Scheduled Tasks | Easy | 45 min | [Task](./REAL-WORLD-TASKS.md#task-712-cronjobs-for-scheduled-tasks) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-712-cronjobs-for-scheduled-tasks) |
| 7.13 | Resource Requests and Limits | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-713-resource-requests-and-limits) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-713-resource-requests-and-limits) |
| 7.14 | PodDisruptionBudget for High Availability | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-714-poddisruptionbudget-for-high-availability) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-714-poddisruptionbudget-for-high-availability) |
| 7.15 | Rolling Updates and Rollbacks | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-715-rolling-updates-and-rollbacks) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-715-rolling-updates-and-rollbacks) |
| 7.16 | Network Policies for Security | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-716-network-policies-for-security) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-716-network-policies-for-security) |
| 7.17 | Troubleshooting Pods and Deployments | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-717-troubleshooting-pods-and-deployments) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-717-troubleshooting-pods-and-deployments) |
| 7.18 | Jobs for One-Time Tasks | Easy | 45 min | [Task](./REAL-WORLD-TASKS.md#task-718-jobs-for-one-time-tasks) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-718-jobs-for-one-time-tasks) |
| 7.19 | DaemonSets for Node-Level Services | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-719-daemonsets-for-node-level-services) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-719-daemonsets-for-node-level-services) |
| 7.20 | Advanced Kubectl Techniques | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-720-advanced-kubectl-techniques) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-720-advanced-kubectl-techniques) |

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

**Q: Do I need a Kubernetes cluster to practice?**  
A: Yes! You can use:
- Minikube (local development)
- Kind (Kubernetes in Docker)
- k3s (lightweight Kubernetes)
- AWS EKS, GKE, or AKS (cloud-managed)
- Docker Desktop with Kubernetes enabled

---

## Related Documents

- 📖 [Part 7 README](./README.md) - Overview of all Part 7 materials
- 🚀 [Quick Start Guide](./QUICK-START-GUIDE.md) - Getting started with Kubernetes tasks
- 📊 [Task Status](../TASK_STATUS.md) - Track completion status
- 🏠 [Main README](../README.md) - Repository home page

---

**Happy Learning!** 🚀

Remember: The goal is not just to complete tasks, but to truly understand Kubernetes concepts and be able to apply them in real production scenarios.
