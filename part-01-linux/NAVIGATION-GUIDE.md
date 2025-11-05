# 📚 Navigation Guide: Real-World Tasks

## Quick Overview

The real-world tasks for Part 1 (Linux) are organized in **two separate files** for optimal learning:

### 📝 [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)
**Contains:** Task questions, requirements, and validation checklists  
**Use this when:** You want to attempt a task on your own

### ✅ [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)
**Contains:** Complete step-by-step solutions with scripts and configurations  
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
## Task 1.5: Systemd Service Creation

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-15-systemd-service-creation-for-backend-api)
```

### From Solutions to Tasks
Every solution has a back link:
```
## Task 1.5: Systemd Service Creation

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-15-systemd-service-creation-for-backend-api)
```

### Keep Both Files Open
**Pro Tip:** Open both files in separate browser tabs or editor panes for easy switching!

---

## File Structure at a Glance

```
part-01-linux/
│
├── REAL-WORLD-TASKS.md              ← Start here (Questions)
│   ├── Overview & instructions
│   ├── Task Index (with solution links)
│   ├── Task 1.1 with requirements
│   ├── Task 1.2 with requirements
│   └── ... (18 tasks total)
│
├── REAL-WORLD-TASKS-SOLUTIONS.md    ← Reference here (Answers)
│   ├── Overview & warnings
│   ├── Table of Contents
│   ├── Task 1.1 solution (with back link)
│   ├── Task 1.2 solution (with back link)
│   └── ... (18 solutions total)
│
└── NAVIGATION-GUIDE.md              ← You are here!
```

---

## Quick Reference

### All 18 Tasks Overview

| Task # | Name | Difficulty | Time | Files |
|--------|------|------------|------|-------|
| 1.1 | Production Server Hardening | Medium | 90 min | [Task](./REAL-WORLD-TASKS.md#task-11-production-server-hardening) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-11-production-server-hardening) |
| 1.2 | SSH Key Management | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-12-ssh-key-management-for-team-access) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-12-ssh-key-management-for-team-access) |
| 1.3 | User and Group Management | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-13-user-and-group-management-for-application-deployment) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-13-user-and-group-management-for-application-deployment) |
| 1.4 | Filesystem & Quotas | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-14-filesystem-management-and-quota-setup) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-14-filesystem-management-and-quota-setup) |
| 1.5 | Systemd Service | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-15-systemd-service-creation-for-backend-api) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-15-systemd-service-creation-for-backend-api) |
| 1.6 | Firewall Configuration | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-16-firewall-configuration-for-multi-tier-application) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-16-firewall-configuration-for-multi-tier-application) |
| 1.7 | Centralized Logging | Medium | 90 min | [Task](./REAL-WORLD-TASKS.md#task-17-centralized-logging-setup-with-journald) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-17-centralized-logging-setup-with-journald) |
| 1.8 | Performance Monitoring | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-18-performance-monitoring-and-troubleshooting) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-18-performance-monitoring-and-troubleshooting) |
| 1.9 | Package Management | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-19-package-management-and-custom-repository) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-19-package-management-and-custom-repository) |
| 1.10 | PostgreSQL Backup | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-110-postgresql-backup-automation) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-110-postgresql-backup-automation) |
| 1.11 | Log Rotation | Easy | 45 min | [Task](./REAL-WORLD-TASKS.md#task-111-log-rotation-configuration) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-111-log-rotation-configuration) |
| 1.12 | Disk Space Crisis | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-112-disk-space-crisis-management) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-112-disk-space-crisis-management) |
| 1.13 | Network Troubleshooting | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-113-network-connectivity-troubleshooting) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-113-network-connectivity-troubleshooting) |
| 1.14 | Systemd Timers | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-114-systemd-timers-for-scheduled-tasks) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-114-systemd-timers-for-scheduled-tasks) |
| 1.15 | Security Incident Response | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-115-security-incident-response) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-115-security-incident-response) |
| 1.16 | DNS Configuration | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-116-dns-configuration-and-troubleshooting) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-116-dns-configuration-and-troubleshooting) |
| 1.17 | Process Priority | Easy | 45 min | [Task](./REAL-WORLD-TASKS.md#task-117-process-priority-management) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-117-process-priority-management) |
| 1.18 | High CPU/Memory Issues | Hard | 75 min | [Task](./REAL-WORLD-TASKS.md#task-118-high-cpu-and-memory-troubleshooting) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-118-high-cpu-and-memory-troubleshooting) |

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

- 📖 [Part 1 README](./README.md) - Overview of all Part 1 materials
- 🚀 [Quick Start Guide](../REAL-WORLD-TASKS-GUIDE.md) - Getting started with real-world tasks
- 📊 [Task Status](../TASK_STATUS.md) - Track completion status
- 🏠 [Main README](../README.md) - Repository home page

---

**Happy Learning!** 🚀

Remember: The goal is not just to complete tasks, but to truly understand the concepts and be able to apply them in real production scenarios.
