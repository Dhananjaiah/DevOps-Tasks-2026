# 📚 Navigation Guide: Ansible Real-World Tasks

## Quick Overview

The real-world tasks for Part 4 (Ansible) are organized in **two separate files** for optimal learning:

### 📝 [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)
**Contains:** Task questions, requirements, and validation checklists  
**Use this when:** You want to attempt a task on your own

### ✅ [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)
**Contains:** Complete step-by-step solutions with playbooks, roles, and configurations  
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
- What you need to learn for interviews

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
## Task 4.3: Create Ansible Role for Backend API Service

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-43-create-ansible-role-for-backend-api-service)
```

### From Solutions to Tasks
Every solution has a back link:
```
## Task 4.3: Create Ansible Role for Backend API Service

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-43-create-ansible-role-for-backend-api-service)
```

### Keep Both Files Open
**Pro Tip:** Open both files in separate browser tabs or editor panes for easy switching!

---

## File Structure at a Glance

```
part-04-ansible/
│
├── REAL-WORLD-TASKS.md              ← Start here (Questions)
│   ├── Overview & instructions
│   ├── Task Index (with solution links)
│   ├── Task 4.1 with requirements
│   ├── Task 4.2 with requirements
│   └── ... (14 tasks total)
│
├── REAL-WORLD-TASKS-SOLUTIONS.md    ← Reference here (Answers)
│   ├── Overview & warnings
│   ├── Table of Contents
│   ├── Task 4.1 solution (with back link)
│   ├── Task 4.2 solution (with back link)
│   └── ... (14 solutions total)
│
├── NAVIGATION-GUIDE.md              ← You are here!
├── QUICK-START-GUIDE.md             ← Quick reference and lookup
└── README.md                        ← Comprehensive guide with theory
```

---

## Quick Reference

### All 14 Tasks Overview

| Task # | Name | Difficulty | Time | Files |
|--------|------|------------|------|-------|
| 4.1 | Ansible Directory Structure & Best Practices | Easy | 60 min | [Task](./REAL-WORLD-TASKS.md#task-41-ansible-directory-structure-and-best-practices) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-41-ansible-directory-structure-and-best-practices) |
| 4.2 | Multi-Environment Inventory Management | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-42-multi-environment-inventory-management) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-42-multi-environment-inventory-management) |
| 4.3 | Create Role for Backend API Service | Medium | 90 min | [Task](./REAL-WORLD-TASKS.md#task-43-create-ansible-role-for-backend-api-service) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-43-create-ansible-role-for-backend-api-service) |
| 4.4 | Configure Nginx Reverse Proxy with TLS | Medium | 90 min | [Task](./REAL-WORLD-TASKS.md#task-44-configure-nginx-reverse-proxy-with-tls) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-44-configure-nginx-reverse-proxy-with-tls) |
| 4.5 | Ansible Vault for Secrets Management | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-45-ansible-vault-for-secrets-management) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-45-ansible-vault-for-secrets-management) |
| 4.6 | PostgreSQL Installation and Configuration | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-46-postgresql-installation-and-configuration) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-46-postgresql-installation-and-configuration) |
| 4.7 | Application Deployment Playbook | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-47-application-deployment-playbook) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-47-application-deployment-playbook) |
| 4.8 | Zero-Downtime Rolling Updates | Hard | 90 min | [Task](./REAL-WORLD-TASKS.md#task-48-zero-downtime-rolling-updates) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-48-zero-downtime-rolling-updates) |
| 4.9 | Dynamic Inventory for AWS EC2 | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-49-dynamic-inventory-for-aws-ec2) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-49-dynamic-inventory-for-aws-ec2) |
| 4.10 | Ansible Templates with Jinja2 | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-410-ansible-templates-with-jinja2) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-410-ansible-templates-with-jinja2) |
| 4.11 | Handlers and Service Management | Easy | 60 min | [Task](./REAL-WORLD-TASKS.md#task-411-handlers-and-service-management) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-411-handlers-and-service-management) |
| 4.12 | Conditional Execution and Loops | Medium | 75 min | [Task](./REAL-WORLD-TASKS.md#task-412-conditional-execution-and-loops) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-412-conditional-execution-and-loops) |
| 4.13 | Error Handling and Retries | Medium | 60 min | [Task](./REAL-WORLD-TASKS.md#task-413-error-handling-and-retries) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-413-error-handling-and-retries) |
| 4.14 | Ansible Tags for Selective Execution | Easy | 45 min | [Task](./REAL-WORLD-TASKS.md#task-414-ansible-tags-for-selective-execution) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-414-ansible-tags-for-selective-execution) |

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

**Q: Do I need actual AWS infrastructure?**  
A: Most tasks can be practiced with local VMs or containers. AWS-specific tasks can be adapted or practiced with free tier resources.

---

## Related Documents

- 📖 [Part 4 README](./README.md) - Comprehensive Ansible guide with theory and examples
- 🚀 [Quick Start Guide](./QUICK-START-GUIDE.md) - Quick reference and task lookup
- 📊 [Task Status](../TASK_STATUS.md) - Track completion status
- 🏠 [Main README](../README.md) - Repository home page

---

**Happy Learning!** 🚀

Remember: The goal is not just to complete tasks, but to truly understand Ansible concepts and be able to apply them in real production scenarios and ace your DevOps interviews.
