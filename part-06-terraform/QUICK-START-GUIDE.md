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
