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

---

## Task 6.3: Create Modular VPC Infrastructure

> **📖 [Back to Task](./REAL-WORLD-TASKS.md#task-63-create-modular-vpc-infrastructure)**

### Solution Overview

This solution creates a production-ready, reusable VPC module with public, private, and database subnets, NAT gateways, and proper routing configuration.

### Complete Solution

#### Step 1: Create VPC Module Structure

```bash
# Create module directory
mkdir -p modules/vpc
cd modules/vpc

# Create module files
touch main.tf variables.tf outputs.tf versions.tf README.md
```

#### Step 2: VPC Module Variables

```hcl
# modules/vpc/variables.tf
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  validation {
    condition     = length(var.azs) >= 2
    error_message = "At least 2 availability zones are required for high availability."
  }
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "database_subnets" {
  description = "List of database subnet CIDR blocks"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets (cost optimization)"
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN gateway"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_logs_retention_days" {
  description = "Number of days to retain VPC Flow Logs"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
```

#### Step 3: VPC Module Main Configuration

```hcl
# modules/vpc/main.tf
locals {
  max_subnet_length = max(
    length(var.private_subnets),
    length(var.public_subnets)
  )
  
  nat_gateway_count = var.single_nat_gateway ? 1 : (
    var.enable_nat_gateway ? local.max_subnet_length : 0
  )
  
  create_database_subnet_group = length(var.database_subnets) > 0
}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-igw"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-${var.azs[count.index]}"
      Type = "public"
      Tier = "public"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-private-${var.azs[count.index]}"
      Type = "private"
      Tier = "private"
    }
  )
}

# Database Subnets
resource "aws_subnet" "database" {
  count = length(var.database_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-database-${var.azs[count.index]}"
      Type = "database"
      Tier = "database"
    }
  )
}

# Database Subnet Group
resource "aws_db_subnet_group" "database" {
  count = local.create_database_subnet_group ? 1 : 0

  name        = lower("${var.vpc_name}-database")
  description = "Database subnet group for ${var.vpc_name}"
  subnet_ids  = aws_subnet.database[*].id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-database-subnet-group"
    }
  )
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# NAT Gateways
resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nat-gateway-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-rt"
      Type = "public"
    }
  )
}

# Public Route to Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables
resource "aws_route_table" "private" {
  count = local.max_subnet_length

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-private-rt-${count.index + 1}"
      Type = "private"
    }
  )
}

# Private Routes to NAT Gateway
resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? local.max_subnet_length : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, var.single_nat_gateway ? 0 : count.index)

  timeouts {
    create = "5m"
  }
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Database Route Table Associations
resource "aws_route_table_association" "database" {
  count = length(var.database_subnets)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# VPN Gateway
resource "aws_vpn_gateway" "this" {
  count = var.enable_vpn_gateway ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-vpn-gateway"
    }
  )
}

# VPC Flow Logs
resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name              = "/aws/vpc/${var.vpc_name}"
  retention_in_days = var.flow_logs_retention_days

  tags = var.tags
}

resource "aws_iam_role" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name = "${var.vpc_name}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSVPCFlowLogsAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name = "${var.vpc_name}-vpc-flow-logs-policy"
  role = aws_iam_role.flow_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_flow_log" "this" {
  count = var.enable_flow_logs ? 1 : 0

  vpc_id          = aws_vpc.this.id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.flow_logs[0].arn
  log_destination = aws_cloudwatch_log_group.flow_logs[0].arn

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-flow-logs"
    }
  )
}
```

#### Step 4: VPC Module Outputs

```hcl
# modules/vpc/outputs.tf
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "List of CIDR blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_cidrs" {
  description = "List of CIDR blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database[*].id
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = try(aws_db_subnet_group.database[0].id, "")
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = try(aws_db_subnet_group.database[0].name, "")
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat[*].public_ip
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "ID of public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private[*].id
}

output "vpn_gateway_id" {
  description = "The ID of the VPN Gateway"
  value       = try(aws_vpn_gateway.this[0].id, "")
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = var.azs
}
```

#### Step 5: Module Versions

```hcl
# modules/vpc/versions.tf
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
```

#### Step 6: Using the VPC Module

```hcl
# Example usage in main.tf
module "vpc" {
  source = "./modules/vpc"

  vpc_name = "production-vpc"
  vpc_cidr = "10.0.0.0/16"

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false  # One NAT per AZ for HA

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_flow_logs     = true

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Project     = "myapp"
  }
}

# Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}
```

#### Step 7: Module README

```markdown
# VPC Terraform Module

This module creates a VPC with public, private, and database subnets across multiple availability zones.

## Features

- ✅ Multi-AZ VPC with public, private, and database subnets
- ✅ NAT Gateways for private subnet internet access
- ✅ Internet Gateway for public subnets
- ✅ VPC Flow Logs for network monitoring
- ✅ Database subnet group for RDS
- ✅ Optional VPN Gateway support
- ✅ Configurable DNS settings
- ✅ Cost optimization with single NAT option

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_name = "my-vpc"
  vpc_cidr = "10.0.0.0/16"

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_name | Name of the VPC | `string` | n/a | yes |
| vpc_cidr | CIDR block for VPC | `string` | n/a | yes |
| azs | Availability zones | `list(string)` | n/a | yes |
| public_subnets | Public subnet CIDRs | `list(string)` | n/a | yes |
| private_subnets | Private subnet CIDRs | `list(string)` | n/a | yes |
| database_subnets | Database subnet CIDRs | `list(string)` | `[]` | no |
| enable_nat_gateway | Enable NAT Gateway | `bool` | `true` | no |
| single_nat_gateway | Use single NAT | `bool` | `false` | no |
| enable_dns_hostnames | Enable DNS hostnames | `bool` | `true` | no |
| enable_flow_logs | Enable VPC Flow Logs | `bool` | `true` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| vpc_cidr_block | VPC CIDR block |
| public_subnets | Public subnet IDs |
| private_subnets | Private subnet IDs |
| database_subnets | Database subnet IDs |
| nat_gateway_ids | NAT Gateway IDs |
| internet_gateway_id | Internet Gateway ID |
```

### Verification Steps

```bash
# Initialize and validate
terraform init
terraform validate

# Plan the changes
terraform plan

# Apply the configuration
terraform apply

# Verify VPC creation
VPC_ID=$(terraform output -raw vpc_id)
aws ec2 describe-vpcs --vpc-ids $VPC_ID

# Verify subnets
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[*].[SubnetId,CidrBlock,AvailabilityZone,Tags[?Key==`Name`].Value|[0]]' \
  --output table

# Verify NAT Gateways
aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID" \
  --query 'NatGateways[*].[NatGatewayId,State,SubnetId]' \
  --output table

# Verify route tables
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'RouteTables[*].[RouteTableId,Tags[?Key==`Name`].Value|[0],Routes[?GatewayId].GatewayId|[0]]' \
  --output table

# Test connectivity from private subnet
# Launch a test instance in private subnet and verify it can reach internet through NAT
```

### Best Practices Implemented

1. **High Availability**: Resources spread across multiple AZs
2. **Security**: Separate subnet tiers with proper routing
3. **Monitoring**: VPC Flow Logs enabled by default
4. **Cost Optimization**: Optional single NAT Gateway for non-prod
5. **Scalability**: Modular design allows easy expansion
6. **Documentation**: Comprehensive README and examples

---

## Task 6.4: Provision Multi-Environment Infrastructure

> **📖 [Back to Task](./REAL-WORLD-TASKS.md#task-64-provision-multi-environment-infrastructure)**

### Solution Overview

This solution implements a multi-environment Terraform setup with separate configurations for dev, staging, and production, promoting consistency while allowing environment-specific customization.

### Complete Solution

#### Step 1: Directory Structure

```bash
# Create multi-environment structure
mkdir -p terraform-infra/{modules,environments,scripts}
mkdir -p terraform-infra/environments/{dev,staging,prod}

# Create shared modules
mkdir -p terraform-infra/modules/{vpc,eks,rds,s3}

cd terraform-infra
```

#### Step 2: Environment-Specific Configurations

```hcl
# environments/dev/terraform.tfvars
environment = "dev"
aws_region  = "us-east-1"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"
azs      = ["us-east-1a", "us-east-1b"]

# Compute Resources
instance_type     = "t3.small"
min_size          = 1
max_size          = 3
desired_capacity  = 2

# Database Configuration
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_multi_az          = false
db_backup_retention  = 7

# Feature Flags
enable_monitoring     = false
enable_auto_scaling   = false
enable_multi_az       = false

# Cost Optimization
single_nat_gateway = true  # Use one NAT for all AZs in dev

# Tags
tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
  Project     = "myapp"
  CostCenter  = "engineering"
  Owner       = "devops-team"
}
```

```hcl
# environments/staging/terraform.tfvars
environment = "staging"
aws_region  = "us-east-1"

# VPC Configuration
vpc_cidr = "10.1.0.0/16"
azs      = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Compute Resources
instance_type     = "t3.medium"
min_size          = 2
max_size          = 6
desired_capacity  = 3

# Database Configuration
db_instance_class    = "db.t3.small"
db_allocated_storage = 50
db_multi_az          = false
db_backup_retention  = 14

# Feature Flags
enable_monitoring     = true
enable_auto_scaling   = true
enable_multi_az       = false

# Cost Optimization
single_nat_gateway = true  # Still use one NAT for staging

# Tags
tags = {
  Environment = "staging"
  ManagedBy   = "Terraform"
  Project     = "myapp"
  CostCenter  = "engineering"
  Owner       = "devops-team"
}
```

```hcl
# environments/prod/terraform.tfvars
environment = "prod"
aws_region  = "us-east-1"

# VPC Configuration
vpc_cidr = "10.2.0.0/16"
azs      = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Compute Resources
instance_type     = "m5.large"
min_size          = 3
max_size          = 15
desired_capacity  = 6

# Database Configuration
db_instance_class    = "db.r5.xlarge"
db_allocated_storage = 500
db_multi_az          = true
db_backup_retention  = 30

# Feature Flags
enable_monitoring     = true
enable_auto_scaling   = true
enable_multi_az       = true

# High Availability
single_nat_gateway = false  # One NAT per AZ for HA

# Tags
tags = {
  Environment = "prod"
  ManagedBy   = "Terraform"
  Project     = "myapp"
  CostCenter  = "engineering"
  Owner       = "devops-team"
  Compliance  = "required"
}
```

#### Step 3: Shared Main Configuration

```hcl
# environments/dev/main.tf (same structure for staging/prod)
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "mycompany-terraform-state"
    key            = "dev/infrastructure.tfstate"  # Change per environment
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  vpc_name = "${var.environment}-vpc"
  vpc_cidr = var.vpc_cidr

  azs = var.azs

  public_subnets   = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets  = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 10)]
  database_subnets = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 20)]

  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway
  enable_dns_hostnames = true
  enable_flow_logs   = var.enable_monitoring

  tags = var.tags
}

# Security Groups
resource "aws_security_group" "web" {
  name_prefix = "${var.environment}-web-"
  description = "Security group for web servers"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-web-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "database" {
  name_prefix = "${var.environment}-database-"
  description = "Security group for database"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
    description     = "PostgreSQL from web servers"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-database-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# RDS Module
module "rds" {
  source = "../../modules/rds"

  identifier     = "${var.environment}-postgres"
  engine         = "postgres"
  engine_version = "15.3"

  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_encrypted = true

  db_name  = "appdb"
  username = "dbadmin"
  password = random_password.db_password.result

  multi_az               = var.db_multi_az
  backup_retention_period = var.db_backup_retention
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"

  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name

  enabled_cloudwatch_logs_exports = var.enable_monitoring ? ["postgresql", "upgrade"] : []

  tags = var.tags
}

# Random password for database
resource "random_password" "db_password" {
  length  = 32
  special = true
}

# Store password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name_prefix             = "${var.environment}-db-password-"
  recovery_window_in_days = var.environment == "prod" ? 30 : 0

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}

# S3 Bucket for application data
resource "aws_s3_bucket" "app_data" {
  bucket_prefix = "${var.environment}-app-data-"

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  versioning_configuration {
    status = var.environment == "prod" ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudWatch Alarms (production only)
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "${var.environment}-database-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = []  # Add SNS topic ARN for notifications

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }

  tags = var.tags
}
```

#### Step 4: Variables Definition

```hcl
# environments/dev/variables.tf (same for all environments)
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
}

variable "db_multi_az" {
  description = "Enable RDS Multi-AZ"
  type        = bool
}

variable "db_backup_retention" {
  description = "Number of days to retain RDS backups"
  type        = number
}

variable "enable_monitoring" {
  description = "Enable monitoring features"
  type        = bool
}

variable "enable_auto_scaling" {
  description = "Enable auto scaling"
  type        = bool
}

variable "enable_multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
}

variable "single_nat_gateway" {
  description = "Use single NAT gateway (cost optimization)"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
```

#### Step 5: Outputs

```hcl
# environments/dev/outputs.tf
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "database_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.db_instance_endpoint
  sensitive   = true
}

output "database_name" {
  description = "Database name"
  value       = module.rds.db_instance_name
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.app_data.id
}

output "nat_gateway_ips" {
  description = "NAT Gateway public IPs"
  value       = module.vpc.nat_gateway_public_ips
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}
```

#### Step 6: Deployment Scripts

```bash
# scripts/deploy.sh
#!/bin/bash
set -euo pipefail

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./deploy.sh <environment>"
    echo "Environments: dev, staging, prod"
    exit 1
fi

if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo "Invalid environment. Must be: dev, staging, or prod"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_DIR="$PROJECT_ROOT/environments/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
    echo "Environment directory not found: $ENV_DIR"
    exit 1
fi

cd "$ENV_DIR"

echo "========================================="
echo "Deploying to: $ENVIRONMENT"
echo "Directory: $ENV_DIR"
echo "========================================="

# Initialize
echo ""
echo "Step 1: Initializing Terraform..."
terraform init

# Validate
echo ""
echo "Step 2: Validating configuration..."
terraform validate

# Format check
echo ""
echo "Step 3: Checking code format..."
terraform fmt -check -recursive || {
    echo "Code not formatted. Run 'terraform fmt -recursive' to fix."
    exit 1
}

# Plan
echo ""
echo "Step 4: Creating execution plan..."
terraform plan -out=tfplan

# Show plan summary
echo ""
echo "Plan summary:"
terraform show -json tfplan | jq -r '.resource_changes[] | "\(.change.actions[0]) \(.type).\(.name)"'

# Confirm apply
echo ""
if [ "$ENVIRONMENT" == "prod" ]; then
    echo "⚠️  WARNING: You are about to deploy to PRODUCTION!"
    echo ""
fi

read -p "Do you want to apply these changes? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Deployment cancelled"
    rm -f tfplan
    exit 1
fi

# Apply
echo ""
echo "Step 5: Applying changes..."
terraform apply tfplan

# Cleanup
rm -f tfplan

# Show outputs
echo ""
echo "========================================="
echo "Deployment Complete!"
echo "========================================="
echo ""
terraform output

echo ""
echo "✅ Successfully deployed to $ENVIRONMENT"
```

```bash
# scripts/destroy.sh
#!/bin/bash
set -euo pipefail

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./destroy.sh <environment>"
    exit 1
fi

# Prevent accidental production destruction
if [ "$ENVIRONMENT" == "prod" ]; then
    echo "❌ Cannot destroy production environment with this script!"
    echo "If you really need to destroy prod, do it manually with proper approvals."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_DIR="$PROJECT_ROOT/environments/$ENVIRONMENT"

cd "$ENV_DIR"

echo "========================================="
echo "⚠️  WARNING: Destroying $ENVIRONMENT"
echo "========================================="
echo ""
echo "This will DELETE ALL RESOURCES in $ENVIRONMENT environment!"
echo ""
read -p "Type 'destroy-$ENVIRONMENT' to confirm: " confirm

if [ "$confirm" != "destroy-$ENVIRONMENT" ]; then
    echo "Destruction cancelled"
    exit 1
fi

echo ""
echo "Destroying infrastructure..."
terraform destroy -auto-approve

echo ""
echo "✅ Environment $ENVIRONMENT has been destroyed"
```

```bash
# scripts/compare-environments.sh
#!/bin/bash
set -euo pipefail

ENV1=${1:-dev}
ENV2=${2:-prod}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Comparing $ENV1 vs $ENV2"
echo "========================================="

echo ""
echo "Configuration differences:"
diff -u "$PROJECT_ROOT/environments/$ENV1/terraform.tfvars" \
        "$PROJECT_ROOT/environments/$ENV2/terraform.tfvars" || true

echo ""
echo "Resource count comparison:"
echo "  $ENV1: $(cd "$PROJECT_ROOT/environments/$ENV1" && terraform state list 2>/dev/null | wc -l) resources"
echo "  $ENV2: $(cd "$PROJECT_ROOT/environments/$ENV2" && terraform state list 2>/dev/null | wc -l) resources"
```

Make all scripts executable:
```bash
chmod +x scripts/*.sh
```

#### Step 7: CI/CD Integration Example

```yaml
# .github/workflows/terraform.yml
name: Terraform CI/CD

on:
  push:
    branches: [main, develop]
    paths:
      - 'terraform-infra/**'
  pull_request:
    branches: [main]
    paths:
      - 'terraform-infra/**'

env:
  TF_VERSION: '1.6.0'

jobs:
  plan-dev:
    name: Plan Dev Environment
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: ${{ env.TF_VERSION }}

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Terraform Init
        working-directory: ./terraform-infra/environments/dev
        run: terraform init

      - name: Terraform Plan
        working-directory: ./terraform-infra/environments/dev
        run: terraform plan -no-color
        continue-on-error: true

  deploy-prod:
    name: Deploy to Production
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: ${{ env.TF_VERSION }}

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Terraform Init
        working-directory: ./terraform-infra/environments/prod
        run: terraform init

      - name: Terraform Plan
        working-directory: ./terraform-infra/environments/prod
        run: terraform plan -out=tfplan

      - name: Terraform Apply
        working-directory: ./terraform-infra/environments/prod
        run: terraform apply -auto-approve tfplan
```

### Verification Steps

```bash
# 1. Deploy to dev
./scripts/deploy.sh dev

# 2. Verify dev deployment
cd environments/dev
terraform output

# 3. Deploy to staging
cd ../..
./scripts/deploy.sh staging

# 4. Compare configurations
./scripts/compare-environments.sh dev prod

# 5. Verify resource isolation
aws ec2 describe-vpcs \
  --filters "Name=tag:Environment,Values=dev,staging,prod" \
  --query 'Vpcs[*].[Tags[?Key==`Environment`].Value|[0],CidrBlock,VpcId]' \
  --output table

# 6. Test environment-specific features
# Dev should have 1 NAT, prod should have 3
aws ec2 describe-nat-gateways \
  --filter "Name=tag:Environment,Values=dev" \
  --query 'NatGateways[*].[NatGatewayId]' | jq length

aws ec2 describe-nat-gateways \
  --filter "Name=tag:Environment,Values=prod" \
  --query 'NatGateways[*].[NatGatewayId]' | jq length
```

### Best Practices Implemented

1. **Environment Isolation**: Separate state files and VPC CIDRs
2. **Configuration Management**: Environment-specific tfvars files
3. **Cost Optimization**: Different resource sizes per environment
4. **High Availability**: Multi-AZ for production only
5. **Automation**: Deployment scripts with safety checks
6. **Security**: Production protection in destroy script
7. **Consistency**: Shared main.tf structure across environments
8. **Feature Flags**: Enable/disable features per environment
9. **Tag Strategy**: Comprehensive tagging for cost allocation
10. **Documentation**: Clear README and usage examples

