# Terraform Quick Start Guide

## 🚀 Quick Reference

This guide provides quick access to Terraform tasks, commands, and learning paths.

## 📑 Task Lookup Table

| Task | Topic | Difficulty | Time | Key Concepts |
|------|-------|------------|------|--------------|
| 6.1 | Project Setup | Easy | 60 min | Structure, Best Practices, .gitignore |
| 6.2 | Remote State | Medium | 75 min | S3, DynamoDB, State Locking |
| 6.3 | VPC Module | Medium | 90 min | Modules, Networking, Subnets |
| 6.4 | Multi-Environment | Medium | 90 min | Dev/Staging/Prod, Variables |
| 6.5 | Variables & Locals | Easy | 60 min | Input Variables, Validation, Locals |
| 6.6 | Data Sources | Medium | 75 min | Data Sources, Dynamic Blocks |
| 6.7 | RDS Database | Medium | 90 min | RDS, Security Groups, Backups |
| 6.8 | S3 & IAM | Medium | 75 min | S3 Buckets, IAM Policies, Encryption |
| 6.9 | Resource Import | Hard | 90 min | Import, State Management |
| 6.10 | Lifecycle Rules | Medium | 75 min | create_before_destroy, Dependencies |
| 6.11 | Secrets Management | Hard | 90 min | Secrets Manager, Sensitive Data |
| 6.12 | Module Registry | Easy | 60 min | Community Modules, Registry |
| 6.13 | CI/CD Integration | Hard | 120 min | GitHub Actions, GitLab CI, Automation |
| 6.14 | EKS Cluster | Hard | 120 min | Kubernetes, EKS, IRSA |
| 6.15 | Resource Tagging | Easy | 60 min | Tags, Cost Allocation, Compliance |
| 6.16 | Testing | Medium | 90 min | Terratest, Validation, Unit Tests |
| 6.17 | State Migration | Hard | 90 min | Backend Migration, State Files |
| 6.18 | Advanced Patterns | Hard | 120 min | for_each, count, Module Composition |

## 🎓 Learning Paths

### Path 1: Beginner (5-6 hours)
Perfect for those new to Terraform.

```
6.1 → 6.5 → 6.15 → 6.12 → 6.6
```

**Topics Covered:**
- Project structure and organization
- Variables and configuration
- Resource tagging
- Using community modules
- Data sources basics

### Path 2: Intermediate (10-12 hours)
Build production-ready infrastructure.

```
6.2 → 6.3 → 6.4 → 6.7 → 6.8 → 6.10
```

**Topics Covered:**
- Remote state management
- VPC and networking
- Multi-environment setups
- Database provisioning
- S3 and IAM management
- Lifecycle management

### Path 3: Advanced (15-18 hours)
Master complex Terraform scenarios.

```
6.9 → 6.11 → 6.13 → 6.14 → 6.16 → 6.17 → 6.18
```

**Topics Covered:**
- Importing existing resources
- Secrets management
- CI/CD automation
- EKS cluster provisioning
- Testing strategies
- State migration
- Advanced patterns

### Path 4: Interview Preparation (8-10 hours)
Focus on commonly asked topics.

```
6.1 → 6.2 → 6.3 → 6.4 → 6.5 → 6.10 → 6.11
```

## ⚡ Essential Commands

### Initialization & Planning
```bash
terraform init                    # Initialize working directory
terraform init -upgrade           # Upgrade providers
terraform validate                # Validate configuration
terraform fmt -recursive          # Format all files
terraform plan                    # Preview changes
terraform plan -out=tfplan        # Save plan to file
```

### Applying Changes
```bash
terraform apply                   # Apply changes (interactive)
terraform apply -auto-approve     # Apply without confirmation
terraform apply tfplan            # Apply saved plan
```

### State Management
```bash
terraform state list              # List resources in state
terraform state show <resource>   # Show resource details
terraform state mv <src> <dest>   # Move resource in state
terraform state rm <resource>     # Remove resource from state
terraform state pull              # Download remote state
terraform state push              # Upload state
```

### Workspace Management
```bash
terraform workspace list          # List workspaces
terraform workspace new <name>    # Create workspace
terraform workspace select <name> # Switch workspace
terraform workspace delete <name> # Delete workspace
```

### Import & Output
```bash
terraform import <resource> <id>  # Import existing resource
terraform output                  # Show all outputs
terraform output <name>           # Show specific output
terraform output -json            # JSON format outputs
```

### Cleanup & Maintenance
```bash
terraform destroy                 # Destroy all resources
terraform destroy -target=<res>   # Destroy specific resource
terraform refresh                 # Update state
terraform graph                   # Generate dependency graph
```

## 🔍 Quick Troubleshooting

### Common Issues & Solutions

| Issue | Quick Fix |
|-------|-----------|
| State lock error | `terraform force-unlock <lock-id>` |
| Provider errors | `terraform init -upgrade` |
| Format issues | `terraform fmt -recursive` |
| Validation errors | `terraform validate` |
| Corrupted state | Restore from S3 version history |
| Import failures | Verify resource ID and config match |

## 📝 Configuration Templates

### Basic Provider Configuration
```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

### Remote Backend Configuration
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

### Variable Definition
```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}
```

## 🎯 By Use Case

### Need to...
- **Start a new project?** → Task 6.1
- **Enable team collaboration?** → Task 6.2
- **Create networking?** → Task 6.3
- **Manage multiple environments?** → Task 6.4
- **Make code flexible?** → Task 6.5
- **Query existing resources?** → Task 6.6
- **Set up a database?** → Task 6.7
- **Manage storage and permissions?** → Task 6.8
- **Bring existing infrastructure under Terraform?** → Task 6.9
- **Control resource updates?** → Task 6.10
- **Handle sensitive data?** → Task 6.11
- **Use community modules?** → Task 6.12
- **Automate deployments?** → Task 6.13
- **Deploy Kubernetes?** → Task 6.14
- **Organize resources?** → Task 6.15
- **Test infrastructure code?** → Task 6.16
- **Move state files?** → Task 6.17
- **Solve complex scenarios?** → Task 6.18

## 📚 Additional Resources

### Official Documentation
- [Terraform Docs](https://www.terraform.io/docs)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Registry](https://registry.terraform.io/)

### Best Practices
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

### Community
- [Terraform GitHub](https://github.com/hashicorp/terraform)
- [r/Terraform](https://www.reddit.com/r/Terraform/)
- [HashiCorp Discuss](https://discuss.hashicorp.com/c/terraform-core/)

---

**Quick Navigation:**
- [README](./README.md) - Detailed tutorials
- [Real-World Tasks](./REAL-WORLD-TASKS.md) - Practice assignments
- [Solutions](./REAL-WORLD-TASKS-SOLUTIONS.md) - Complete solutions
- [Navigation Guide](./NAVIGATION-GUIDE.md) - How to use these docs

Happy Terraforming! 🏗️
# Terraform Infrastructure as Code Real-World Tasks - Quick Start Guide

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
   - Use the provided Terraform configurations
   - Verify your implementation

3. **For deeper understanding:** [README.md](README.md)
   - Explore additional examples
   - Learn the "why" behind each step
   - Understand best practices
   - Review interview questions and answers

## 🎯 Quick Task Lookup

| Task | Scenario | Solution Link | Time | Difficulty |
|------|----------|---------------|------|------------|
| 6.1 | Modular VPC Infrastructure | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-61-build-modular-vpc-infrastructure-with-terraform) | 4-5 hrs | Medium |
| 6.2 | Remote State with S3 and DynamoDB | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-62-implement-remote-state-with-s3-and-dynamodb-locking) | 2-3 hrs | Easy |
| 6.3 | EKS Cluster Provisioning | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-63-provision-eks-cluster-with-terraform) | 5-6 hrs | Medium |
| 6.4 | Multi-Environment Infrastructure | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-64-create-multi-environment-infrastructure-setup) | 4-5 hrs | Medium |
| 6.5 | Terraform CI/CD Pipeline | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-65-implement-terraform-cicd-pipeline) | 4-5 hrs | Medium |

## 🔍 Find Tasks by Category

### Foundation & State Management
- **Task 6.2**: Remote State with S3 and DynamoDB Locking (Easy, 2-3 hrs)
  - Implement S3 backend for state
  - Configure DynamoDB for state locking
  - Set up state encryption
  - Implement state versioning

### Infrastructure Modules
- **Task 6.1**: Modular VPC Infrastructure (Medium, 4-5 hrs)
  - Create reusable VPC module
  - Implement subnet modules
  - Configure NAT Gateway module
  - Set up proper tagging strategy
  - Create module documentation

### Kubernetes Infrastructure
- **Task 6.3**: EKS Cluster Provisioning (Medium, 5-6 hrs)
  - Provision EKS cluster with Terraform
  - Configure node groups
  - Set up IAM roles and policies
  - Implement cluster autoscaling
  - Configure add-ons

### Multi-Environment Management
- **Task 6.4**: Multi-Environment Infrastructure Setup (Medium, 4-5 hrs)
  - Design environment strategy
  - Implement workspace management
  - Configure environment-specific variables
  - Set up terraform.tfvars per environment
  - Implement DRY principles

### Automation & CI/CD
- **Task 6.5**: Terraform CI/CD Pipeline (Medium, 4-5 hrs)
  - Build automated Terraform pipeline
  - Implement plan and apply automation
  - Set up approval gates
  - Configure drift detection
  - Implement policy as code

## 📊 Task Difficulty & Time Estimates

### Easy Tasks (0.5 Story Points)
Perfect for beginners or when time is limited:
- Task 6.2: Remote State with S3 and DynamoDB (2-3 hrs)

### Medium Tasks (1.0 Story Points)
For intermediate learners looking for challenges:
- Task 6.1: Modular VPC Infrastructure (4-5 hrs)
- Task 6.3: EKS Cluster Provisioning (5-6 hrs)
- Task 6.4: Multi-Environment Infrastructure (4-5 hrs)
- Task 6.5: Terraform CI/CD Pipeline (4-5 hrs)

## 🎓 Suggested Learning Paths

### Path 1: Beginner's Journey (Start Here!)
1. **Task 6.2**: Remote State with S3 and DynamoDB
   - Learn state management fundamentals
   - Understand backend configuration
   - Master state locking concepts

2. **Task 6.1**: Modular VPC Infrastructure
   - Create reusable modules
   - Understand module structure
   - Learn input/output patterns

3. **Task 6.4**: Multi-Environment Infrastructure
   - Master workspace management
   - Learn variable management
   - Understand environment strategies

### Path 2: Production Infrastructure Focus
1. **Task 6.2**: Remote State with S3 and DynamoDB
   - Set up shared state infrastructure
   
2. **Task 6.1**: Modular VPC Infrastructure
   - Build network foundation
   
3. **Task 6.3**: EKS Cluster Provisioning
   - Deploy Kubernetes infrastructure
   
4. **Task 6.5**: Terraform CI/CD Pipeline
   - Automate infrastructure deployment

### Path 3: Complete IaC Mastery
Complete all tasks in order:
1. Task 6.2 (Foundation)
2. Task 6.1 (Modules)
3. Task 6.4 (Environments)
4. Task 6.3 (Complex Infrastructure)
5. Task 6.5 (Automation)

## ⚡ Quick Start Steps

### 1. Prerequisites Check
Before starting any task, ensure you have:
- [ ] Terraform installed (1.3+)
- [ ] AWS CLI configured with credentials
- [ ] AWS account with appropriate permissions
- [ ] Basic understanding of HCL syntax
- [ ] Git for version control
- [ ] Text editor (VS Code with Terraform extension recommended)

### 2. Environment Setup
```bash
# Install Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Verify installation
terraform version

# Configure AWS credentials
aws configure

# Clone repository
git clone https://github.com/Dhananjaiah/DevOps-Tasks-2026.git
cd DevOps-Tasks-2026/part-06-terraform

# Create working directory
mkdir -p ~/terraform-practice
cd ~/terraform-practice
```

### 3. Pick Your First Task
- Review the task categories above
- Choose based on your skill level
- Note the time estimate
- Open [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)

### 4. Implementation Workflow
```
Read Task → Plan → Write Config → Init → Plan → Apply → Verify → Compare with Solution
```

## 🛠️ Common Tools & Commands

### Essential Terraform Commands
```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Plan changes
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# List resources
terraform state list

# Output values
terraform output

# Destroy resources
terraform destroy

# Refresh state
terraform refresh
```

### Testing & Validation
```bash
# Run tflint
tflint

# Security scanning with tfsec
tfsec .

# Cost estimation with infracost
infracost breakdown --path .

# Validate with checkov
checkov -d .

# Generate documentation
terraform-docs markdown table .
```

## 📋 Task Completion Checklist

For each task you complete, verify:
- [ ] Meets all requirements from task description
- [ ] Follows Terraform best practices
- [ ] Uses remote state backend
- [ ] Implements state locking
- [ ] Variables properly organized
- [ ] Outputs clearly defined
- [ ] Code is formatted (terraform fmt)
- [ ] Validated successfully (terraform validate)
- [ ] Documentation included
- [ ] Resources properly tagged
- [ ] Tested with terraform plan
- [ ] Applied successfully
- [ ] Compared with provided solution

## 💡 Pro Tips

### Best Practices
1. **Always use remote state**: Never store state locally for team projects
2. **Implement state locking**: Prevent concurrent modifications
3. **Use modules**: Create reusable, composable infrastructure
4. **Version your modules**: Pin module versions for stability
5. **Use variables**: Never hardcode values
6. **Document everything**: Use comments and README files
7. **Tag all resources**: Implement consistent tagging strategy

### Troubleshooting
1. **Check syntax first**: Use `terraform validate`
2. **Format your code**: Run `terraform fmt` regularly
3. **Read error messages carefully**: They usually point to the issue
4. **Use terraform console**: Test expressions interactively
5. **Check state file**: Understand current infrastructure state

### Time-Saving Tricks
1. **Use terraform workspace**: Manage multiple environments
2. **Leverage data sources**: Reference existing resources
3. **Use locals**: Simplify complex expressions
4. **Create helper scripts**: Automate common workflows
5. **Use .terraform.lock.hcl**: Lock provider versions

## 🔗 Quick Links

### Documentation
- [Main README](../README.md) - Repository overview
- [Terraform Docs](https://www.terraform.io/docs/) - Official documentation
- [Terraform Registry](https://registry.terraform.io/) - Module and provider registry

### Within This Section
- [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md) - Task descriptions
- [REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md) - Complete solutions
- [README.md](README.md) - Detailed Terraform guide

## 📈 Track Your Progress

| Task | Status | Date Completed | Notes |
|------|--------|----------------|-------|
| 6.1  | ⬜     |                |       |
| 6.2  | ⬜     |                |       |
| 6.3  | ⬜     |                |       |
| 6.4  | ⬜     |                |       |
| 6.5  | ⬜     |                |       |

Status Legend: ⬜ Not Started | 🔄 In Progress | ✅ Completed

---

**Ready to begin?** Choose your first task from [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md) and start building! 🚀
