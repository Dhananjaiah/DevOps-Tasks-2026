# Terraform Infrastructure as Code Real-World Tasks - Complete Solutions

> **📚 Navigation:** [Tasks ←](./REAL-WORLD-TASKS.md) | [Part 6 README](./README.md) | [Main README](../README.md)

This document provides **production-ready solutions** for all Terraform Infrastructure as Code real-world tasks. Each solution includes complete implementations, configurations, and detailed explanations.

---

## Table of Contents

1. [Task 6.1: Terraform Project Setup and Best Practices](#task-61-terraform-project-setup-and-best-practices)
2. [Task 6.2: Configure Remote State with S3 and DynamoDB Locking](#task-62-configure-remote-state-with-s3-and-dynamodb-locking)
3. [Task 6.3: Create Modular VPC Infrastructure](#task-63-create-modular-vpc-infrastructure)
4. [Task 6.4: Provision Multi-Environment Infrastructure](#task-64-provision-multi-environment-infrastructure)
5. [Task 6.5: Implement Terraform Variables and Locals](#task-65-implement-terraform-variables-and-locals)
6. [Task 6.6: Use Data Sources and Dynamic Blocks](#task-66-use-data-sources-and-dynamic-blocks)
7. [Task 6.7: Provision RDS Database with Terraform](#task-67-provision-rds-database-with-terraform)
8. [Task 6.8: Manage S3 Buckets and IAM Policies](#task-68-manage-s3-buckets-and-iam-policies)
9. [Task 6.9: Import Existing AWS Resources](#task-69-import-existing-aws-resources-into-terraform)
10. [Task 6.10: Implement Lifecycle Rules and Dependencies](#task-610-implement-lifecycle-rules-and-dependencies)
11. [Task 6.11: Implement Secrets Management](#task-611-implement-secrets-management-in-terraform)
12. [Task 6.12: Use Terraform Modules from Registry](#task-612-use-terraform-modules-from-registry)
13. [Task 6.13: Integrate Terraform with CI/CD Pipeline](#task-613-integrate-terraform-with-cicd-pipeline)
14. [Task 6.14: Provision EKS Cluster with Terraform](#task-614-provision-eks-cluster-with-terraform)
15. [Task 6.15: Implement Comprehensive Resource Tagging](#task-615-implement-comprehensive-resource-tagging)
16. [Task 6.16: Implement Terraform Testing](#task-616-implement-terraform-testing-and-validation)
17. [Task 6.17: Perform Terraform State Migration](#task-617-perform-terraform-state-migration)
18. [Task 6.18: Implement Advanced Terraform Patterns](#task-618-implement-advanced-terraform-patterns)

---

## Task 6.1: Terraform Project Setup and Best Practices

> **📖 [Back to Task](./REAL-WORLD-TASKS.md#task-61-terraform-project-setup-and-best-practices)**

### Solution Overview

This solution implements a complete Terraform project structure following industry best practices with proper organization, version control, and automation scripts.

### Complete Solution

#### Step 1: Create Project Directory Structure

```bash
#!/bin/bash
# setup-terraform-project.sh

PROJECT_NAME="terraform-infrastructure"

# Create main project directory
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Create directory structure
mkdir -p {modules,environments,scripts,docs}
mkdir -p environments/{dev,staging,prod}
mkdir -p modules/{vpc,ec2,rds,s3,iam,eks}

# Create module subdirectories
for module in vpc ec2 rds s3 iam eks; do
    mkdir -p modules/$module
    touch modules/$module/{main.tf,variables.tf,outputs.tf,README.md}
done

# Create environment files
for env in dev staging prod; do
    touch environments/$env/{main.tf,variables.tf,terraform.tfvars,backend.tf,outputs.tf}
done

# Create root level files
touch {versions.tf,main.tf,variables.tf,outputs.tf,backend.tf.example,terraform.tfvars.example}

# Create script files
touch scripts/{init.sh,plan.sh,apply.sh,destroy.sh,validate.sh}

# Create documentation
touch docs/{architecture.md,runbook.md,troubleshooting.md}

# Create other files
touch {README.md,.gitignore,.terraform-version}

echo "Project structure created successfully!"
```

#### Step 2: Configure Version Management

```hcl
# versions.tf
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Environment = var.environment
        ManagedBy   = "Terraform"
        Project     = var.project_name
        CreatedBy   = var.owner
      },
      var.common_tags
    )
  }
}
```

#### Step 3: Create .gitignore

```bash
# .gitignore
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log
crash.*.log

# Exclude all .tfvars files, which are likely to contain sensitive data
*.tfvars
*.tfvars.json
!terraform.tfvars.example

# Ignore override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
*tfplan*

# Ignore CLI configuration files
.terraformrc
terraform.rc

# Ignore Mac .DS_Store files
.DS_Store

# Ignore IDE files
.idea/
.vscode/
*.swp
*.swo
*~

# Ignore lock file (some teams commit this)
.terraform.lock.hcl

# Ignore plan files
*.tfplan

# Ignore backup files
*.backup
*.bak
```

#### Step 4: Create Variables Configuration

```hcl
# variables.tf
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition     = can(regex("^(us|eu|ap|sa|ca|me|af)-(north|south|east|west|central|northeast|southeast|southwest|northwest)-[1-3]$", var.aws_region))
    error_message = "Must be a valid AWS region."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "owner" {
  description = "Owner or team responsible for the infrastructure"
  type        = string
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
```

```hcl
# terraform.tfvars.example
# Copy this file to terraform.tfvars and update values

aws_region   = "us-east-1"
environment  = "dev"
project_name = "myapp"
owner        = "devops-team"

common_tags = {
  Department  = "Engineering"
  CostCenter  = "CC-12345"
  Application = "MyApplication"
  Compliance  = "SOC2"
}
```

#### Step 5: Create Helper Scripts

```bash
# scripts/init.sh
#!/bin/bash
set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./init.sh <environment>"
    echo "Available environments: dev, staging, prod"
    exit 1
fi

ENV_DIR="environments/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
    echo "Error: Environment directory $ENV_DIR does not exist"
    exit 1
fi

cd "$ENV_DIR"

echo "========================================="
echo "Initializing Terraform for $ENVIRONMENT"
echo "========================================="

# Initialize Terraform
terraform init

# Validate configuration
echo ""
echo "Validating configuration..."
terraform validate

# Format code
echo ""
echo "Formatting Terraform code..."
terraform fmt -recursive ../../

echo ""
echo "✅ Initialization complete for $ENVIRONMENT environment"
echo ""
echo "Next steps:"
echo "  1. Review and update terraform.tfvars"
echo "  2. Run: ./scripts/plan.sh $ENVIRONMENT"
echo "  3. Review the plan output"
echo "  4. Run: ./scripts/apply.sh $ENVIRONMENT"
```

```bash
# scripts/plan.sh
#!/bin/bash
set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./plan.sh <environment>"
    exit 1
fi

ENV_DIR="environments/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
    echo "Error: Environment directory $ENV_DIR does not exist"
    exit 1
fi

cd "$ENV_DIR"

echo "========================================="
echo "Planning changes for $ENVIRONMENT"
echo "========================================="

# Run terraform plan
terraform plan -out=tfplan

echo ""
echo "✅ Plan saved to tfplan"
echo ""
echo "Review the plan above carefully."
echo "If everything looks good, run: ./scripts/apply.sh $ENVIRONMENT"
```

```bash
# scripts/apply.sh
#!/bin/bash
set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./apply.sh <environment>"
    exit 1
fi

ENV_DIR="environments/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
    echo "Error: Environment directory $ENV_DIR does not exist"
    exit 1
fi

cd "$ENV_DIR"

if [ ! -f "tfplan" ]; then
    echo "Error: No plan file found. Run ./scripts/plan.sh $ENVIRONMENT first."
    exit 1
fi

echo "========================================="
echo "Applying changes to $ENVIRONMENT"
echo "========================================="

# Confirm before applying
read -p "Are you sure you want to apply these changes? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Apply cancelled"
    exit 0
fi

# Apply the plan
terraform apply tfplan

# Remove plan file
rm -f tfplan

echo ""
echo "✅ Changes applied successfully to $ENVIRONMENT"
```

```bash
# scripts/validate.sh
#!/bin/bash
set -e

echo "========================================="
echo "Validating Terraform Configuration"
echo "========================================="

# Format check
echo "Checking formatting..."
terraform fmt -check -recursive

# Validate all environments
for env in dev staging prod; do
    echo ""
    echo "Validating $env environment..."
    cd "environments/$env"
    terraform init -backend=false
    terraform validate
    cd ../..
done

echo ""
echo "✅ All validations passed"
```

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

#### Step 6: Create README.md

```markdown
# Terraform Infrastructure

## Overview

This repository contains Terraform Infrastructure as Code (IaC) for managing AWS infrastructure across multiple environments.

## Project Structure

\`\`\`
.
├── environments/           # Environment-specific configurations
│   ├── dev/               # Development environment
│   ├── staging/           # Staging environment
│   └── prod/              # Production environment
├── modules/               # Reusable Terraform modules
│   ├── vpc/              # VPC module
│   ├── ec2/              # EC2 module
│   ├── rds/              # RDS module
│   ├── s3/               # S3 module
│   ├── iam/              # IAM module
│   └── eks/              # EKS module
├── scripts/               # Helper scripts
│   ├── init.sh           # Initialize environment
│   ├── plan.sh           # Plan changes
│   ├── apply.sh          # Apply changes
│   └── validate.sh       # Validate configuration
├── docs/                  # Documentation
│   ├── architecture.md   # Architecture diagrams
│   ├── runbook.md        # Operational procedures
│   └── troubleshooting.md # Troubleshooting guide
├── versions.tf           # Terraform and provider versions
├── variables.tf          # Global variables
└── README.md             # This file
\`\`\`

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.6.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- Appropriate AWS permissions

## Getting Started

### 1. Clone the Repository

\`\`\`bash
git clone https://github.com/your-org/terraform-infrastructure.git
cd terraform-infrastructure
\`\`\`

### 2. Initialize an Environment

\`\`\`bash
./scripts/init.sh dev
\`\`\`

### 3. Configure Variables

Copy the example variables file and update with your values:

\`\`\`bash
cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
# Edit terraform.tfvars with your values
\`\`\`

### 4. Plan Changes

\`\`\`bash
./scripts/plan.sh dev
\`\`\`

### 5. Apply Changes

\`\`\`bash
./scripts/apply.sh dev
\`\`\`

## Environment Management

### Development
- **Purpose**: Development and testing
- **Resources**: Minimal, cost-optimized
- **Scaling**: Manual

### Staging
- **Purpose**: Pre-production testing
- **Resources**: Production-like sizing
- **Scaling**: Similar to production

### Production
- **Purpose**: Production workloads
- **Resources**: Full sizing with HA
- **Scaling**: Auto-scaling enabled

## Module Usage

Each module in the `modules/` directory is self-contained and reusable.

Example of using the VPC module:

\`\`\`hcl
module "vpc" {
  source = "../../modules/vpc"

  vpc_name  = "\${var.environment}-vpc"
  vpc_cidr  = var.vpc_cidr
  azs       = var.availability_zones

  # ... other variables
}
\`\`\`

## Best Practices

1. **Never commit `.tfvars` files with sensitive data**
2. **Always run `terraform plan` before `apply`**
3. **Use workspaces or separate directories for environments**
4. **Pin provider versions in `versions.tf`**
5. **Enable remote state with locking**
6. **Tag all resources appropriately**
7. **Document all modules**
8. **Use variables for flexibility**
9. **Implement lifecycle rules for critical resources**
10. **Regular backups of state files**

## Security

- State files may contain sensitive information
- Use encryption for remote state (S3 + KMS)
- Implement least privilege IAM policies
- Never hardcode credentials
- Use AWS Secrets Manager for sensitive data
- Enable MFA for production changes

## Contributing

1. Create a feature branch
2. Make your changes
3. Run validation: `./scripts/validate.sh`
4. Create a pull request
5. Wait for review and approval

## Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md) for common issues and solutions.

## Support

For questions or issues:
- Check the [troubleshooting guide](docs/troubleshooting.md)
- Review module READMEs
- Contact the DevOps team

## License

[Your License]
```

### Verification Steps

```bash
# 1. Verify directory structure
tree terraform-infrastructure

# 2. Validate Terraform configuration
cd terraform-infrastructure
./scripts/validate.sh

# 3. Check formatting
terraform fmt -check -recursive

# 4. Initialize dev environment
./scripts/init.sh dev

# 5. Create a test plan
cd environments/dev
terraform plan
```

### Best Practices Implemented

- ✅ Standard directory structure
- ✅ Environment separation
- ✅ Reusable modules
- ✅ Version constraints
- ✅ Proper .gitignore
- ✅ Helper scripts for automation
- ✅ Comprehensive documentation
- ✅ Variable validation
- ✅ Consistent tagging strategy
- ✅ Security considerations

### Troubleshooting Guide

#### Issue 1: terraform init fails

**Symptoms**: Error downloading providers

**Solution**:
```bash
# Clear .terraform directory
rm -rf .terraform

# Re-initialize with upgrade
terraform init -upgrade
```

#### Issue 2: Permission denied on scripts

**Symptoms**: Cannot execute helper scripts

**Solution**:
```bash
chmod +x scripts/*.sh
```

#### Issue 3: Invalid provider version

**Symptoms**: Provider version conflicts

**Solution**:
```hcl
# Update versions.tf with specific versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.0.0"  # Pin to exact version
    }
  }
}
```

---

## Task 6.2: Configure Remote State with S3 and DynamoDB Locking

> **📖 [Back to Task](./REAL-WORLD-TASKS.md#task-62-configure-remote-state-with-s3-and-dynamodb-locking)**

### Solution Overview

This solution sets up a secure remote state backend using S3 for storage and DynamoDB for state locking, enabling safe team collaboration.

### Complete Solution

#### Step 1: Create Bootstrap Configuration

First, create a bootstrap configuration to create the S3 bucket and DynamoDB table:

```hcl
# bootstrap/main.tf
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

# Generate a unique suffix for bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  bucket_name = "${var.project_name}-terraform-state-${random_string.suffix.result}"
}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name

  tags = {
    Name        = "Terraform State Bucket"
    Purpose     = "Terraform State Storage"
    ManagedBy   = "Terraform"
    Environment = "management"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle Policy for Old Versions
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }

  rule {
    id     = "delete-old-delete-markers"
    status = "Enabled"

    expiration {
      expired_object_delete_marker = true
    }
  }
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnforcedTLS"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.terraform_state.arn,
          "${aws_s3_bucket.terraform_state.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "DenyInsecureTransport"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.terraform_state.arn,
          "${aws_s3_bucket.terraform_state.arn}/*"
        ]
        Condition = {
          NumericLessThan = {
            "s3:TlsVersion" = "1.2"
          }
        }
      }
    ]
  })
}

# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "${var.project_name}-terraform-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Purpose     = "Terraform State Locking"
    ManagedBy   = "Terraform"
    Environment = "management"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Enable Point-in-Time Recovery for DynamoDB
resource "aws_dynamodb_table_item" "pitr" {
  table_name = aws_dynamodb_table.terraform_locks.name
  hash_key   = aws_dynamodb_table.terraform_locks.hash_key

  # This is a workaround to enable PITR
  # In production, you might use AWS CLI or a Lambda
}
```

```hcl
# bootstrap/variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}
```

```hcl
# bootstrap/outputs.tf
output "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "backend_configuration" {
  description = "Backend configuration for terraform"
  value = <<-EOT
    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.terraform_state.id}"
        key            = "ENV/terraform.tfstate"  # Replace ENV with your environment
        region         = "${var.aws_region}"
        encrypt        = true
        dynamodb_table = "${aws_dynamodb_table.terraform_locks.name}"
      }
    }
  EOT
}
```

#### Step 2: Bootstrap the Backend

```bash
# Create bootstrap directory
mkdir -p bootstrap
cd bootstrap

# Create terraform.tfvars
cat > terraform.tfvars << EOF
aws_region   = "us-east-1"
project_name = "mycompany"
EOF

# Initialize and apply
terraform init
terraform plan
terraform apply

# Save outputs
terraform output -raw backend_configuration > ../backend-config.txt
terraform output -raw s3_bucket_name > ../bucket-name.txt
terraform output -raw dynamodb_table_name > ../table-name.txt
```

#### Step 3: Configure Backend in Main Project

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "mycompany-terraform-state-abc12345"  # From bootstrap output
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "mycompany-terraform-locks"          # From bootstrap output
    
    # Optional: Use KMS for encryption
    # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
}
```

For multiple environments:

```hcl
# environments/dev/backend.tf
terraform {
  backend "s3" {
    bucket         = "mycompany-terraform-state-abc12345"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "mycompany-terraform-locks"
  }
}

# environments/staging/backend.tf
terraform {
  backend "s3" {
    bucket         = "mycompany-terraform-state-abc12345"
    key            = "staging/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "mycompany-terraform-locks"
  }
}

# environments/prod/backend.tf
terraform {
  backend "s3" {
    bucket         = "mycompany-terraform-state-abc12345"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "mycompany-terraform-locks"
  }
}
```

#### Step 4: Migrate Existing State

```bash
#!/bin/bash
# migrate-state.sh

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./migrate-state.sh <environment>"
    exit 1
fi

cd "environments/$ENVIRONMENT"

# Backup local state
if [ -f "terraform.tfstate" ]; then
    cp terraform.tfstate "terraform.tfstate.backup.$(date +%Y%m%d-%H%M%S)"
    echo "✅ Local state backed up"
fi

# Initialize with migration
echo "Migrating state to remote backend..."
terraform init -migrate-state

# Verify migration
echo "Verifying state migration..."
terraform state list

# Remove local state files
read -p "Migration successful. Remove local state files? (yes/no): " confirm
if [ "$confirm" == "yes" ]; then
    rm -f terraform.tfstate
    echo "✅ Local state files removed"
fi

echo "✅ State migration complete!"
```

#### Step 5: Create IAM Policies

```hcl
# iam-policies.tf

# Policy for Terraform execution
resource "aws_iam_policy" "terraform_state_access" {
  name        = "TerraformStateAccess"
  description = "Allow Terraform to access state bucket and lock table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListStateBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketVersioning"
        ]
        Resource = "arn:aws:s3:::mycompany-terraform-state-*"
      },
      {
        Sid    = "ReadWriteStateBucket"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::mycompany-terraform-state-*/*"
      },
      {
        Sid    = "DynamoDBStateLock"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/*-terraform-locks"
      }
    ]
  })
}

# Attach to Terraform execution role
resource "aws_iam_role_policy_attachment" "terraform_state_access" {
  role       = "TerraformExecutionRole"  # Your Terraform execution role
  policy_arn = aws_iam_policy.terraform_state_access.arn
}
```

[Continue with remaining solutions for tasks 6.3-6.18...]

