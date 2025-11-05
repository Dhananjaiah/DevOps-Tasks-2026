# 📚 Navigation Guide: Bash Scripting Real-World Tasks

## Quick Overview

The real-world Bash scripting tasks for Part 2 are organized in **two separate files** for optimal learning:

### 📝 [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)
**Contains:** Task questions, requirements, and validation checklists  
**Use this when:** You want to attempt a task on your own

### ✅ [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)
**Contains:** Complete step-by-step solutions with production-ready scripts  
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
- Your skill level (Junior/Mid/Senior)
- Time available (2-5 hours)
- Sprint capacity (0.5-1 story points)
- Topic of interest (Deployment, Monitoring, Backup, etc.)

#### Step 3: Attempt the Task
- Read the scenario carefully
- Note the time estimate and story points
- Review requirements and deliverables
- Follow the validation checklist
- Implement your solution

#### Step 4: When You Need Help
Click the **"View Complete Solution"** link at the top of any task to jump directly to its solution

#### Step 5: Compare Your Solution
After completing the task:
1. Open the solution file
2. Compare your approach with the production-ready solution
3. Learn from differences
4. Note any best practices you missed
5. Review security and error handling patterns

---

## Navigation Tips

### From Tasks to Solutions
Every task has a solution link at the beginning:

Example:
```
## Task 2.1: Production Deployment Automation Script

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-21-production-deployment-automation-script)
```

### From Solutions to Tasks
Every solution has a back link:
```
## Task 2.1: Production Deployment Automation Script

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-21-production-deployment-automation-script)
```

### Keep Both Files Open
**Pro Tip:** Open both files in separate browser tabs or editor panes for easy switching!

---

## File Structure at a Glance

```
part-02-bash/
│
├── REAL-WORLD-TASKS.md              ← Start here (Questions)
│   ├── Overview & instructions
│   ├── How to use guide
│   ├── Task 2.1: Deployment Automation
│   ├── Task 2.2: Log Analysis
│   ├── Task 2.3: Backup & Restore
│   ├── Task 2.4: Health Check
│   ├── Task 2.5: CI/CD Helpers
│   └── Task 2.6: Config Manager
│
├── REAL-WORLD-TASKS-SOLUTIONS.md    ← Reference here (Answers)
│   ├── Overview & warnings
│   ├── Table of Contents
│   ├── Task 2.1 complete solution
│   ├── Task 2.2 complete solution
│   ├── Task 2.3 complete solution
│   ├── Task 2.4 complete solution
│   ├── Task 2.5 complete solution
│   └── Task 2.6 complete solution
│
├── NAVIGATION-GUIDE.md              ← You are here!
├── QUICK-START-GUIDE.md             ← Quick reference
├── README.md                        ← Comprehensive tutorial
└── TASKS-2.3-2.14.md               ← Additional practice tasks
```

---

## Quick Reference

### All 6 Tasks Overview

| Task # | Name | Difficulty | Time | Story Points | Files |
|--------|------|------------|------|--------------|-------|
| 2.1 | Production Deployment Automation | Medium | 3-4h | 0.5 | [Task](./REAL-WORLD-TASKS.md#task-21-production-deployment-automation-script) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-21-production-deployment-automation-script) |
| 2.2 | Log Analysis and Alert Script | Medium | 2-3h | 0.5 | [Task](./REAL-WORLD-TASKS.md#task-22-log-analysis-and-alert-script) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-22-log-analysis-and-alert-script) |
| 2.3 | Automated Backup and Restore | Medium | 3-4h | 0.5 | [Task](./REAL-WORLD-TASKS.md#task-23-automated-backup-and-restore-script) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-23-automated-backup-and-restore-script) |
| 2.4 | Infrastructure Health Check | Medium | 3-4h | 0.5 | [Task](./REAL-WORLD-TASKS.md#task-24-infrastructure-health-check-script) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-24-infrastructure-health-check-script) |
| 2.5 | CI/CD Pipeline Helper Scripts | Hard | 4-5h | 1.0 | [Task](./REAL-WORLD-TASKS.md#task-25-cicd-pipeline-helper-scripts) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-25-cicd-pipeline-helper-scripts) |
| 2.6 | Multi-Environment Configuration Manager | Medium | 2-3h | 0.5 | [Task](./REAL-WORLD-TASKS.md#task-26-multi-environment-configuration-manager) \| [Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-26-multi-environment-configuration-manager) |

### Task Categories

#### 🚀 Deployment & Automation
- **Task 2.1**: Deployment Automation - Full deployment pipeline script
- **Task 2.5**: CI/CD Helpers - Modular pipeline automation scripts

#### 📊 Monitoring & Analysis
- **Task 2.2**: Log Analysis - Parse logs, detect patterns, send alerts
- **Task 2.4**: Health Check - Comprehensive infrastructure validation

#### 💾 Backup & Data Management
- **Task 2.3**: Backup & Restore - Database backup automation with S3

#### ⚙️ Configuration Management
- **Task 2.6**: Config Manager - Template-based configuration generation

---

## Skill Level Recommendations

### 👨‍💻 Junior DevOps Engineers
**Start with these tasks:**
1. **Task 2.2** (Log Analysis) - Good introduction to log parsing and regex
2. **Task 2.6** (Config Manager) - Learn template processing and variable substitution

**Skills you'll develop:**
- Text processing with grep, awk, sed
- Regular expressions
- File I/O operations
- Basic error handling

### 👨‍💼 Mid-Level DevOps Engineers
**Recommended sequence:**
1. **Task 2.1** (Deployment) - End-to-end deployment automation
2. **Task 2.3** (Backup) - Database operations and S3 integration
3. **Task 2.4** (Health Check) - Multi-component system validation

**Skills you'll develop:**
- Docker and Kubernetes integration
- AWS service integration
- Parallel processing
- Complex error handling
- Notification systems

### 👨‍🏫 Senior DevOps Engineers
**Advanced challenges:**
1. **Task 2.5** (CI/CD Helpers) - Requires architectural understanding
2. Combine multiple tasks into a complete workflow
3. Optimize existing scripts for performance
4. Add security scanning and compliance checks

**Skills you'll demonstrate:**
- System architecture design
- Security best practices
- Performance optimization
- Code modularity and reusability
- Enterprise-grade error handling

---

## Sprint Planning Guide

### Task Complexity by Story Points

#### 0.5 Story Points (1-2 days)
- Task 2.2: Log Analysis
- Task 2.3: Backup & Restore
- Task 2.4: Health Check
- Task 2.6: Config Manager

#### 1.0 Story Point (2-3 days)
- Task 2.1: Deployment Automation
- Task 2.5: CI/CD Pipeline Helpers

### Sample Sprint Plan

**Sprint Week 1:**
- Monday-Tuesday: Task 2.1 (Deployment Script)
- Wednesday: Task 2.2 (Log Analysis)
- Thursday: Task 2.6 (Config Manager)
- Friday: Testing and refinement

**Sprint Week 2:**
- Monday-Tuesday: Task 2.5 (CI/CD Scripts)
- Wednesday: Task 2.3 (Backup Script)
- Thursday: Task 2.4 (Health Check)
- Friday: Integration and documentation

---

## Learning Path

### Beginner Path (2-3 weeks)
```
Week 1: Task 2.6 (Config Manager)
        └─> Learn variables and templates
        
Week 2: Task 2.2 (Log Analysis)
        └─> Learn text processing
        
Week 3: Task 2.4 (Health Check)
        └─> Learn system monitoring
```

### Intermediate Path (2 weeks)
```
Week 1: Task 2.1 (Deployment)
        └─> Learn Docker/K8s automation
        
        Task 2.3 (Backup)
        └─> Learn database operations
        
Week 2: Task 2.4 (Health Check)
        └─> Learn parallel processing
        
        Review and optimize all scripts
```

### Advanced Path (1-2 weeks)
```
Week 1: Task 2.5 (CI/CD Helpers) - All 5 scripts
        └─> Learn modular design
        
Week 2: Integration project
        └─> Combine all scripts into complete DevOps workflow
```

---

## Common Patterns Across Tasks

### Error Handling Pattern
All tasks follow this pattern:
```bash
set -euo pipefail    # Exit on error, undefined vars, pipe failures
trap cleanup EXIT    # Always cleanup
trap error_exit INT  # Handle interrupts
```

### Logging Pattern
```bash
log() {
    local level="$1"
    local message="$2"
    echo "[$(date)] [$level] $message" | tee -a "$LOG_FILE"
}
```

### Configuration Pattern
```bash
# Load environment-specific config
source "config/${ENVIRONMENT}.env"

# Validate required variables
for var in "${REQUIRED_VARS[@]}"; do
    [[ -z "${!var:-}" ]] && error_exit "Missing: $var"
done
```

### Dry-Run Pattern
```bash
execute_command() {
    local cmd="$*"
    if [[ "$DRY_RUN" == true ]]; then
        log INFO "[DRY-RUN] Would execute: $cmd"
    else
        eval "$cmd"
    fi
}
```

---

## Need Help?

### If You're Lost
1. **Start here:** [QUICK-START-GUIDE.md](./QUICK-START-GUIDE.md)
2. **Read the overview** in [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md)
3. **Pick a task** matching your skill level
4. **Follow the recommended workflow** above

### If You're Stuck on a Task
1. **Review the validation checklist** - it contains hints
2. **Check common Bash pitfalls** - see Resources section
3. **Run ShellCheck** on your script for immediate feedback
4. **Click the solution link** to see the production approach
5. **Compare and learn** from the differences

### Common Questions

**Q: Should I look at the solution before attempting the task?**  
A: No! The learning happens when you struggle and solve problems yourself. Use the solution only when stuck or to verify your approach.

**Q: Are the solutions the only correct way?**  
A: No! There are multiple valid approaches. Our solutions show production-ready patterns with best practices, security, and error handling.

**Q: Can I modify the tasks?**  
A: Absolutely! Adapt scenarios to your environment, add requirements, or combine tasks. Real-world scenarios are always unique.

**Q: How do I test my scripts safely?**  
A: Always use:
1. `--dry-run` mode first
2. Test in dev/staging before production
3. Run in containers or VMs
4. Keep backups before automation

**Q: What if my solution is different?**  
A: That's great! Compare approaches:
- Is yours more efficient?
- Does it handle edge cases?
- Is error handling robust?
- Is it maintainable?

**Q: How do I track my progress?**  
A: 
- Keep a personal checklist
- Mark completed tasks in the Task Index
- Save your solutions in a Git repository
- Document lessons learned

---

## Testing Your Scripts

### Essential Testing Steps

1. **Syntax Check**
   ```bash
   bash -n your_script.sh
   shellcheck your_script.sh
   ```

2. **Dry-Run Mode**
   ```bash
   ./your_script.sh --dry-run
   ```

3. **Unit Testing** (if applicable)
   ```bash
   bats test/your_script.bats
   ```

4. **Integration Testing**
   - Test in dev environment
   - Verify all success paths
   - Test all error conditions
   - Check rollback functionality

5. **Load Testing** (for performance-critical scripts)
   - Test with large datasets
   - Test concurrent execution
   - Monitor resource usage

---

## Best Practices Checklist

Apply these to every script you write:

### Code Quality
- [ ] Uses `set -euo pipefail`
- [ ] Proper shebang (`#!/bin/bash`)
- [ ] Clear comments and documentation
- [ ] Consistent naming conventions
- [ ] Functions are small and focused
- [ ] No hardcoded values (use config files)

### Error Handling
- [ ] Validates all inputs
- [ ] Checks command exit codes
- [ ] Uses trap for cleanup
- [ ] Provides clear error messages
- [ ] Logs all operations
- [ ] Fails fast on critical errors

### Security
- [ ] No secrets in code
- [ ] Proper file permissions
- [ ] Validates user input
- [ ] Escapes variables in commands
- [ ] Uses secure temporary files
- [ ] Audits sensitive operations

### Usability
- [ ] Provides help message (`--help`)
- [ ] Supports dry-run mode
- [ ] Clear and colored output
- [ ] Progress indicators
- [ ] Detailed logging
- [ ] Examples in documentation

---

## Additional Resources

### Essential Tools
- **[ShellCheck](https://www.shellcheck.net/)** - Static analysis for shell scripts
- **[BATS](https://github.com/bats-core/bats-core)** - Bash testing framework
- **[bashate](https://github.com/openstack/bashate)** - Code style checker

### Learning Resources
- **[Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)**
- **[Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)**
- **[Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls)**
- **[Bash Hackers Wiki](https://wiki.bash-hackers.org/)**

### Related Documentation
- 📖 [Part 2 README](./README.md) - Comprehensive Bash tutorial
- 🚀 [Quick Start Guide](./QUICK-START-GUIDE.md) - Fast reference
- 📝 [Additional Tasks](./TASKS-2.3-2.14.md) - More practice
- 🏠 [Main README](../README.md) - Repository overview

---

## Success Metrics

Track your progress with these metrics:

### Completion Metrics
- [ ] All 6 tasks completed
- [ ] All scripts pass ShellCheck
- [ ] All validation checklists checked
- [ ] All deliverables submitted
- [ ] Documentation written

### Quality Metrics
- [ ] Scripts handle all error cases
- [ ] Dry-run mode works correctly
- [ ] Scripts are idempotent
- [ ] Performance meets requirements
- [ ] Security best practices followed

### Learning Metrics
- [ ] Can explain each script's logic
- [ ] Can modify scripts for new requirements
- [ ] Can debug script failures
- [ ] Can review others' scripts
- [ ] Can design new automation scripts

---

**Happy Automating! 🚀**

Remember: Great DevOps engineers don't just write scripts that work—they write scripts that are maintainable, secure, and reliable in production. Take your time to understand the patterns and best practices in these tasks. They will serve you well throughout your career.
