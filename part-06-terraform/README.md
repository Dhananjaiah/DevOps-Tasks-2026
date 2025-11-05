# Part 6: Terraform Infrastructure as Code

## Overview

This section covers comprehensive Terraform skills required for DevOps engineers managing production infrastructure. All tasks are built around provisioning and managing AWS infrastructure for our 3-tier web application (Frontend, Backend API, PostgreSQL) using Infrastructure as Code principles.

## 📚 Available Resources

### Real-World Tasks (Recommended Starting Point)
- **[REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)** - 📝 18 practical, executable Terraform tasks with scenarios, requirements, and validation checklists
- **[REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)** - ✅ Complete, production-ready solutions with step-by-step implementations and code
- **[NAVIGATION-GUIDE.md](NAVIGATION-GUIDE.md)** - 📚 Learn how to navigate between tasks and solutions efficiently

### Quick Start & Additional Resources
- **[QUICK-START-GUIDE.md](QUICK-START-GUIDE.md)** - �� Quick reference with task lookup table and learning paths
- **[TASKS-6.4-6.18.md](TASKS-6.4-6.18.md)** - Additional task implementations and examples

> **💡 New to Terraform and Infrastructure as Code?** Check out the [Navigation Guide](NAVIGATION-GUIDE.md) to understand how tasks and solutions are organized!

---

## Task 6.1: Set Up Terraform Project Structure and Best Practices

### Goal / Why It's Important

A well-structured Terraform project is the **foundation for maintainable infrastructure**. In production environments, poor project structure leads to:
- Difficult collaboration among team members
- Increased risk of errors and misconfigurations
- Challenges in managing multiple environments
- Hard-to-maintain codebases as infrastructure grows

This task establishes best practices that are critical for any production Terraform deployment and is a common interview topic.

### Prerequisites

- AWS account with appropriate permissions
- Terraform installed (version 1.0+)
- Basic understanding of Infrastructure as Code concepts
- AWS CLI configured

### Step-by-Step Implementation

#### Step 1: Install and Verify Terraform

```bash
# Download Terraform (Linux)
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Verify installation
terraform version

# For macOS
brew install terraform

# Verify
terraform -v
```

#### Step 2: Create Standard Project Structure

```bash
# Create project directory structure
mkdir -p terraform-infrastructure/{environments,modules,scripts}
cd terraform-infrastructure

# Create environment-specific directories
mkdir -p environments/{dev,staging,prod}

# Create module directories
mkdir -p modules/{vpc,ec2,rds,s3,iam}

# Create each module structure
for module in vpc ec2 rds s3 iam; do
    mkdir -p modules/$module
    touch modules/$module/{main.tf,variables.tf,outputs.tf,README.md}
done

# Create common files
touch {main.tf,variables.tf,outputs.tf,versions.tf,backend.tf,terraform.tfvars.example,.gitignore}
```

Recommended structure:
```
terraform-infrastructure/
├── README.md
├── .gitignore
├── versions.tf              # Terraform and provider versions
├── backend.tf               # Remote state configuration
├── main.tf                  # Root module
├── variables.tf             # Input variables
├── outputs.tf               # Output values
├── terraform.tfvars.example # Example variables file
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   │   └── ...
│   └── prod/
│       └── ...
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── ec2/
│   ├── rds/
│   ├── s3/
│   └── iam/
└── scripts/
    ├── init.sh
    ├── plan.sh
    └── apply.sh
```

#### Step 3: Configure versions.tf

```hcl
# versions.tf
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = var.project_name
      Owner       = var.owner
    }
  }
}
```

#### Step 4: Create .gitignore

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

# Ignore override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Ignore CLI configuration files
.terraformrc
terraform.rc

# Ignore Mac .DS_Store files
.DS_Store

# Ignore plan files
*.tfplan

# Ignore lock files (optional - some teams commit this)
# .terraform.lock.hcl
```

#### Step 5: Create Variables File

```hcl
# variables.tf
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
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
  description = "Project name for resource naming"
  type        = string
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
```

#### Step 6: Create terraform.tfvars.example

```hcl
# terraform.tfvars.example
aws_region   = "us-east-1"
environment  = "dev"
project_name = "myapp"
owner        = "devops-team"

common_tags = {
  Department = "Engineering"
  CostCenter = "CC-12345"
}
```

#### Step 7: Create Helper Scripts

```bash
# scripts/init.sh
#!/bin/bash
set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./init.sh <environment>"
    echo "Example: ./init.sh dev"
    exit 1
fi

cd "environments/$ENVIRONMENT"

echo "Initializing Terraform for $ENVIRONMENT environment..."
terraform init

echo "Validating configuration..."
terraform validate

echo "Formatting code..."
terraform fmt -recursive

echo "Initialization complete!"
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

cd "environments/$ENVIRONMENT"

echo "Planning changes for $ENVIRONMENT environment..."
terraform plan -out=tfplan

echo "Plan saved to tfplan"
echo "Review the plan and run apply.sh to execute"
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

cd "environments/$ENVIRONMENT"

if [ ! -f "tfplan" ]; then
    echo "No plan file found. Run plan.sh first."
    exit 1
fi

echo "Applying changes for $ENVIRONMENT environment..."
terraform apply tfplan

rm -f tfplan
echo "Apply complete!"
```

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

#### Step 8: Create README.md Template

```markdown
# Terraform Infrastructure

## Overview
This repository contains Terraform code for managing [Project Name] infrastructure on AWS.

## Prerequisites
- Terraform >= 1.0.0
- AWS CLI configured
- Appropriate AWS permissions

## Project Structure
See directory structure above

## Usage

### Initialize
\`\`\`bash
./scripts/init.sh dev
\`\`\`

### Plan Changes
\`\`\`bash
./scripts/plan.sh dev
\`\`\`

### Apply Changes
\`\`\`bash
./scripts/apply.sh dev
\`\`\`

### Destroy Resources
\`\`\`bash
cd environments/dev
terraform destroy
\`\`\`

## Environments
- **dev**: Development environment
- **staging**: Staging environment
- **prod**: Production environment

## Modules
- **vpc**: VPC and networking resources
- **ec2**: EC2 instances and related resources
- **rds**: RDS database instances
- **s3**: S3 buckets
- **iam**: IAM roles and policies

## Best Practices
1. Always run `terraform plan` before `apply`
2. Never commit `.tfvars` files with sensitive data
3. Use remote state for team collaboration
4. Tag all resources appropriately
5. Use modules for reusable components

## Contributing
[Add your contribution guidelines]
```

### Key Commands Summary

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Plan changes
terraform plan
terraform plan -out=tfplan

# Apply changes
terraform apply
terraform apply tfplan

# Show current state
terraform show

# List resources in state
terraform state list

# Destroy resources
terraform destroy

# Import existing resources
terraform import <resource_type>.<name> <id>

# Refresh state
terraform refresh

# Output values
terraform output
terraform output -json

# Workspace management
terraform workspace list
terraform workspace new dev
terraform workspace select dev
```

### Verification

#### 1. Test Project Structure
```bash
# Verify directory structure
tree terraform-infrastructure

# Should show proper hierarchy
```

#### 2. Validate Terraform Configuration
```bash
cd terraform-infrastructure

# Initialize
terraform init

# Validate
terraform validate

# Expected: Success! The configuration is valid.
```

#### 3. Check Formatting
```bash
# Format all files
terraform fmt -recursive

# Check if files need formatting
terraform fmt -check -recursive
```

#### 4. Test Scripts
```bash
# Test init script
./scripts/init.sh dev

# Should initialize successfully
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Not Using Version Constraints

**Problem**: Terraform or provider versions change unexpectedly

**Solution**:
```hcl
# Always specify version constraints in versions.tf
terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Allows 5.x, but not 6.0
    }
  }
}
```

#### Mistake 2: Committing Sensitive Data

**Problem**: Accidentally committing .tfvars files with secrets

**Solution**:
```bash
# Add to .gitignore
*.tfvars
!terraform.tfvars.example

# Check before committing
git status

# If already committed
git rm --cached terraform.tfvars
git commit -m "Remove sensitive file"
```

#### Mistake 3: Poor Module Organization

**Problem**: Mixing environments in the same directory

**Solution**:
- Separate environments in different directories
- Use workspaces for simple setups
- Use separate state files per environment

#### Mistake 4: Not Using Remote State

**Problem**: State file conflicts in team environments

**Solution**:
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

#### Troubleshooting: Initialization Fails

```bash
# Problem: terraform init fails
# Solution: Check provider configuration

# Clean .terraform directory
rm -rf .terraform

# Re-initialize
terraform init

# If provider issues
terraform init -upgrade
```

### Interview Questions with Answers

#### Q1: What is Terraform and why use it over other IaC tools?

**Answer**:
Terraform is an **Infrastructure as Code (IaC)** tool that allows you to define and provision infrastructure using declarative configuration files.

**Advantages over other tools**:
- **Cloud-agnostic**: Works with AWS, Azure, GCP, and 300+ providers
- **Declarative**: Describe desired state, not steps to achieve it
- **State management**: Tracks infrastructure state
- **Plan before apply**: Preview changes before execution
- **Resource graph**: Understands dependencies and parallelizes operations
- **Module ecosystem**: Reusable, shareable infrastructure components

**vs CloudFormation**: Multi-cloud support, better syntax (HCL), larger community
**vs Ansible**: Declarative vs procedural, better state management
**vs Pulumi**: Uses HCL instead of general-purpose languages (simpler for infrastructure)

#### Q2: Explain the Terraform workflow.

**Answer**:
The standard Terraform workflow consists of:

1. **Write**: Define infrastructure in `.tf` files
   ```hcl
   resource "aws_instance" "web" {
     ami           = "ami-12345678"
     instance_type = "t3.micro"
   }
   ```

2. **Initialize**: Download providers and modules
   ```bash
   terraform init
   ```

3. **Plan**: Preview changes
   ```bash
   terraform plan
   ```
   - Compares desired state (code) with actual state (state file)
   - Shows resources to create, update, or destroy

4. **Apply**: Execute changes
   ```bash
   terraform apply
   ```
   - Applies changes to reach desired state
   - Updates state file

5. **Destroy** (when needed): Remove infrastructure
   ```bash
   terraform destroy
   ```

**Best Practice**: Always run `plan` before `apply` in production!

#### Q3: What is Terraform state and why is it important?

**Answer**:
**Terraform state** is a file (`terraform.tfstate`) that maps real-world resources to your configuration and tracks metadata.

**Why it's important**:
1. **Performance**: Caches resource attributes to avoid constant API calls
2. **Dependency mapping**: Tracks relationships between resources
3. **Metadata storage**: Stores resource metadata not exposed by APIs
4. **Collaboration**: Enables team to work on same infrastructure
5. **Drift detection**: Compares actual vs desired state

**State file contents**:
- Resource IDs and attributes
- Resource dependencies
- Provider configuration
- Outputs

**Best Practices**:
- Store remotely (S3, Terraform Cloud)
- Enable state locking (DynamoDB)
- Never edit state files manually
- Use `terraform state` commands for modifications
- Encrypt state files (contains sensitive data)
- Version control state files (for remote backends)

#### Q4: What's the difference between a Terraform module and a resource?

**Answer**:

**Resource**: A single infrastructure component
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```
- Smallest building block
- Directly managed by provider
- Example: EC2 instance, S3 bucket, IAM role

**Module**: A collection of resources grouped together
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  cidr_block = "10.0.0.0/16"
  environment = "prod"
}
```
- Reusable package of resources
- Can contain multiple resources
- Promotes DRY (Don't Repeat Yourself)
- Example: VPC module with subnets, route tables, NAT gateways

**When to use modules**:
- Reusing infrastructure patterns
- Organizing complex infrastructure
- Sharing code across teams
- Enforcing standards and best practices

#### Q5: How do you manage secrets in Terraform?

**Answer**:
**Never store secrets in Terraform code!** Several approaches:

**1. AWS Secrets Manager / Parameter Store**:
```hcl
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}

resource "aws_db_instance" "main" {
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
}
```

**2. Environment Variables**:
```bash
export TF_VAR_db_password="secret123"
terraform apply
```

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

**3. Terraform Cloud/Enterprise**:
- Stores sensitive variables encrypted
- Not exposed in state file or logs

**4. Vault Provider**:
```hcl
data "vault_generic_secret" "db" {
  path = "secret/database"
}

resource "aws_db_instance" "main" {
  password = data.vault_generic_secret.db.data["password"]
}
```

**Best Practices**:
- Mark variables as `sensitive = true`
- Use separate secret management systems
- Rotate secrets regularly
- Never commit secrets to version control
- Use least privilege for Terraform execution

#### Q6: Explain Terraform's resource lifecycle meta-arguments.

**Answer**:
Lifecycle meta-arguments control how Terraform manages resources:

**1. create_before_destroy**:
```hcl
resource "aws_instance" "web" {
  # ...
  lifecycle {
    create_before_destroy = true
  }
}
```
- Creates replacement before destroying original
- Prevents downtime
- Useful for resources that can't have duplicates

**2. prevent_destroy**:
```hcl
resource "aws_s3_bucket" "important" {
  # ...
  lifecycle {
    prevent_destroy = true
  }
}
```
- Prevents accidental deletion
- Terraform will error if you try to destroy
- Use for production databases, S3 buckets with critical data

**3. ignore_changes**:
```hcl
resource "aws_instance" "web" {
  # ...
  lifecycle {
    ignore_changes = [
      tags["LastModified"],
      user_data
    ]
  }
}
```
- Ignores changes to specified attributes
- Useful when external systems modify resources
- Prevents Terraform from reverting manual changes

**4. replace_triggered_by**:
```hcl
resource "aws_instance" "web" {
  # ...
  lifecycle {
    replace_triggered_by = [
      aws_security_group.web.id
    ]
  }
}
```
- Replaces resource when another resource changes
- Available in Terraform 1.2+

#### Q7: What are data sources in Terraform?

**Answer**:
**Data sources** allow Terraform to fetch information from existing infrastructure or external sources.

**Purpose**:
- Query existing resources not managed by Terraform
- Fetch dynamic values at runtime
- Get information from providers

**Example**:
```hcl
# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use in resource
resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux.id
  # ...
}

# Get existing VPC
data "aws_vpc" "existing" {
  id = "vpc-12345678"
}

# Get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Use availability zones
resource "aws_subnet" "public" {
  count             = length(data.aws_availability_zones.available.names)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  # ...
}
```

**Resources vs Data Sources**:
- **Resources**: Create, update, delete infrastructure (managed by Terraform)
- **Data Sources**: Read-only, query existing infrastructure (not managed)

#### Q8: How do you handle Terraform state in a team environment?

**Answer**:
**Problem**: Local state files cause conflicts when multiple team members work on infrastructure.

**Solution**: **Remote state with locking**

**1. S3 Backend with DynamoDB Locking**:
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "company-terraform-state"
    key            = "prod/infrastructure.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
    
    # Optional: versioning for state history
    versioning     = true
  }
}
```

**Setup Steps**:
```bash
# 1. Create S3 bucket (with versioning enabled)
aws s3api create-bucket \
  --bucket company-terraform-state \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket company-terraform-state \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket company-terraform-state \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# 2. Create DynamoDB table for locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1

# 3. Initialize with remote backend
terraform init
```

**Benefits**:
- ✅ Centralized state storage
- ✅ State locking prevents concurrent modifications
- ✅ Encryption at rest
- ✅ State versioning for rollback
- ✅ Access control via IAM

**2. Terraform Cloud**:
```hcl
terraform {
  cloud {
    organization = "my-company"
    
    workspaces {
      name = "prod-infrastructure"
    }
  }
}
```

**Benefits**:
- Built-in state management and locking
- Web UI for viewing state and runs
- Variable management
- Cost estimation
- Policy as code
- Run history

#### Q9: Explain terraform plan vs apply vs destroy.

**Answer**:

**terraform plan**:
- **Preview** changes without modifying infrastructure
- Shows resources to create (+), update (~), or destroy (-)
- Generates execution plan
- Safe to run anytime

```bash
terraform plan
terraform plan -out=tfplan  # Save plan to file

# Example output:
# + create
# ~ update in-place
# - destroy
# -/+ destroy and re-create
```

**terraform apply**:
- **Executes** changes to reach desired state
- Updates state file
- Can apply saved plan or current configuration

```bash
terraform apply              # Interactive (asks for confirmation)
terraform apply -auto-approve # Automatic (no confirmation)
terraform apply tfplan       # Apply saved plan
```

**terraform destroy**:
- **Removes** all resources managed by Terraform
- Equivalent to deleting everything
- Updates state file

```bash
terraform destroy
terraform destroy -auto-approve
terraform destroy -target=aws_instance.web  # Destroy specific resource
```

**Best Practices**:
1. Always run `plan` before `apply`
2. Review plan output carefully
3. Use `apply tfplan` to ensure planned changes are applied
4. Never run `destroy` in production without backup
5. Use `-target` for selective operations cautiously

**Workflow**:
```bash
# 1. Make changes to .tf files
# 2. Plan
terraform plan -out=tfplan

# 3. Review plan output
# 4. Apply (only if plan looks good)
terraform apply tfplan

# 5. For cleanup
terraform destroy
```

#### Q10: What are Terraform workspaces and when should you use them?

**Answer**:
**Terraform workspaces** allow managing multiple instances of infrastructure with the same configuration.

**Concept**:
- Each workspace has its own state file
- Same code, different state
- Similar to git branches

**Commands**:
```bash
# List workspaces
terraform workspace list

# Create workspace
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Switch workspace
terraform workspace select dev

# Show current workspace
terraform workspace show

# Delete workspace
terraform workspace delete dev
```

**Usage in Configuration**:
```hcl
# Use workspace name in resources
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"

  tags = {
    Name        = "web-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# Conditional configuration
locals {
  instance_count = {
    dev     = 1
    staging = 2
    prod    = 5
  }
  
  count = local.instance_count[terraform.workspace]
}

resource "aws_instance" "web" {
  count = local.count
  # ...
}
```

**When to Use Workspaces**:
✅ **Good for**:
- Same infrastructure with different sizes
- Quick testing of infrastructure changes
- Simple environment separation (dev/staging/prod)

❌ **Not good for**:
- Different AWS accounts per environment
- Significantly different infrastructure between environments
- Different VPC/networking per environment
- Team collaboration on different environments

**Alternative: Separate Directories**:
```
environments/
├── dev/
│   ├── main.tf
│   ├── terraform.tfvars
│   └── backend.tf
├── staging/
│   └── ...
└── prod/
    └── ...
```

**Better for**:
- Different AWS accounts per environment
- Different state backends per environment
- Clear separation of concerns
- Different access controls per environment

**Recommendation**: Use workspaces for simple cases, separate directories for production-grade setups.

---

## Task 6.2: Configure Remote State with S3 and DynamoDB Locking

### Goal / Why It's Important

Remote state management is **critical for team collaboration** and infrastructure safety. Without proper state management:
- Team members overwrite each other's changes
- No locking mechanism causes race conditions
- State files get corrupted
- No audit trail of infrastructure changes
- Security risks from local state files with sensitive data

This is a fundamental requirement for any production Terraform deployment.

### Prerequisites

- AWS account with appropriate permissions
- Terraform installed
- AWS CLI configured
- Understanding of Terraform state concepts

### Step-by-Step Implementation

#### Step 1: Create S3 Bucket for State Storage

```bash
# Set variables
BUCKET_NAME="my-company-terraform-state"
REGION="us-east-1"
DYNAMODB_TABLE="terraform-state-locks"

# Create S3 bucket
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION

# Enable versioning (important for state history)
aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket $BUCKET_NAME \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      },
      "BucketKeyEnabled": true
    }]
  }'

# Block public access
aws s3api put-public-access-block \
  --bucket $BUCKET_NAME \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

# Enable lifecycle policy for old versions
cat > lifecycle-policy.json << 'EOF'
{
  "Rules": [
    {
      "Id": "DeleteOldVersions",
      "Status": "Enabled",
      "NoncurrentVersionExpiration": {
        "NoncurrentDays": 90
      }
    }
  ]
}
EOF

aws s3api put-bucket-lifecycle-configuration \
  --bucket $BUCKET_NAME \
  --lifecycle-configuration file://lifecycle-policy.json
```

#### Step 2: Create DynamoDB Table for State Locking

```bash
# Create DynamoDB table
aws dynamodb create-table \
  --table-name $DYNAMODB_TABLE \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region $REGION \
  --tags Key=Purpose,Value=TerraformStateLocking \
        Key=ManagedBy,Value=Terraform

# Verify table creation
aws dynamodb describe-table \
  --table-name $DYNAMODB_TABLE \
  --region $REGION
```

Or using Terraform (bootstrap approach):
```hcl
# bootstrap/main.tf
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-company-terraform-state"

  tags = {
    Name      = "Terraform State Bucket"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-state-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = "Terraform State Lock Table"
    ManagedBy = "Terraform"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
```

#### Step 3: Configure Backend in Terraform

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-company-terraform-state"
    key            = "prod/infrastructure.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
    
    # Optional: Use KMS for encryption
    # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
}
```

For multi-environment setup:
```hcl
# environments/dev/backend.tf
terraform {
  backend "s3" {
    bucket         = "my-company-terraform-state"
    key            = "dev/infrastructure.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}

# environments/staging/backend.tf
terraform {
  backend "s3" {
    bucket         = "my-company-terraform-state"
    key            = "staging/infrastructure.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}

# environments/prod/backend.tf
terraform {
  backend "s3" {
    bucket         = "my-company-terraform-state"
    key            = "prod/infrastructure.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}
```

#### Step 4: Migrate Local State to Remote Backend

```bash
# If you already have local state

# 1. Add backend configuration to backend.tf (as shown above)

# 2. Initialize with backend migration
terraform init -migrate-state

# Terraform will ask: "Do you want to copy existing state to the new backend?"
# Answer: yes

# 3. Verify state is in S3
aws s3 ls s3://my-company-terraform-state/prod/

# 4. Remove local state files (after verification)
rm terraform.tfstate terraform.tfstate.backup

# 5. Test by running plan
terraform plan
```

#### Step 5: Set Up IAM Policies for State Access

```hcl
# iam.tf
# Policy for Terraform execution role
resource "aws_iam_policy" "terraform_state_access" {
  name        = "TerraformStateAccess"
  description = "Allow Terraform to access state bucket and lock table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::my-company-terraform-state",
          "arn:aws:s3:::my-company-terraform-state/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:*:table/terraform-state-locks"
      }
    ]
  })
}

# Attach to Terraform execution role
resource "aws_iam_role_policy_attachment" "terraform_state_access" {
  role       = aws_iam_role.terraform_execution.name
  policy_arn = aws_iam_policy.terraform_state_access.arn
}
```

#### Step 6: Configure State Locking

State locking happens automatically with DynamoDB backend. Test it:

```bash
# Terminal 1: Start a long-running operation
terraform apply

# Terminal 2: Try to run another operation (should wait/fail)
terraform plan
# Error: Error acquiring the state lock
# Lock Info:
#   ID: 12345678-1234-1234-1234-123456789012
#   Path: my-company-terraform-state/prod/infrastructure.tfstate
#   Operation: OperationTypeApply
#   Who: user@hostname
#   Version: 1.6.0
#   Created: 2024-01-15 10:30:00.000000 UTC
#   Info:

# To force unlock (use with caution!)
terraform force-unlock 12345678-1234-1234-1234-123456789012
```

#### Step 7: Implement State Backup Strategy

```bash
# Script to backup state files
#!/bin/bash
# scripts/backup-state.sh

BUCKET="my-company-terraform-state"
BACKUP_BUCKET="my-company-terraform-state-backup"
DATE=$(date +%Y%m%d-%H%M%S)

# Copy current state to backup bucket
aws s3 sync s3://$BUCKET/ s3://$BACKUP_BUCKET/backup-$DATE/ \
  --exclude "*" --include "*.tfstate"

echo "State backed up to s3://$BACKUP_BUCKET/backup-$DATE/"

# Keep only last 30 days of backups
aws s3 ls s3://$BACKUP_BUCKET/ | while read -r line; do
  createDate=$(echo $line | awk {'print $1" "$2'})
  createDate=$(date -d "$createDate" +%s)
  olderThan=$(date -d "30 days ago" +%s)
  
  if [[ $createDate -lt $olderThan ]]; then
    dirName=$(echo $line | awk {'print $4'})
    aws s3 rm s3://$BACKUP_BUCKET/$dirName --recursive
    echo "Deleted old backup: $dirName"
  fi
done
```

Make it executable and run:
```bash
chmod +x scripts/backup-state.sh
./scripts/backup-state.sh
```

### Key Commands Summary

```bash
# Initialize with remote backend
terraform init

# Migrate local state to remote
terraform init -migrate-state

# Reconfigure backend
terraform init -reconfigure

# View state
terraform state list
terraform state show aws_instance.web

# Download state locally (read-only)
terraform state pull > state.json

# Push local state to remote (dangerous!)
terraform state push terraform.tfstate

# Force unlock state
terraform force-unlock <lock-id>

# View backend configuration
terraform init -backend-config="bucket=my-bucket"
```

### Verification

#### 1. Verify S3 Bucket Configuration
```bash
# Check versioning
aws s3api get-bucket-versioning --bucket my-company-terraform-state

# Check encryption
aws s3api get-bucket-encryption --bucket my-company-terraform-state

# Check public access block
aws s3api get-public-access-block --bucket my-company-terraform-state

# List state files
aws s3 ls s3://my-company-terraform-state/ --recursive
```

#### 2. Verify DynamoDB Table
```bash
# Describe table
aws dynamodb describe-table --table-name terraform-state-locks

# Check for active locks
aws dynamodb scan --table-name terraform-state-locks
```

#### 3. Test State Locking
```bash
# Terminal 1: Run apply (don't confirm yet)
terraform apply

# Terminal 2: Try to run plan (should be locked)
terraform plan
# Should see: Error acquiring the state lock
```

#### 4. Verify State in S3
```bash
# After running terraform apply
aws s3 ls s3://my-company-terraform-state/prod/infrastructure.tfstate

# Download and view state
aws s3 cp s3://my-company-terraform-state/prod/infrastructure.tfstate - | jq .
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Incorrect DynamoDB Table Schema

**Problem**: State locking doesn't work

**Symptom**:
```
Error: Error acquiring the state lock
Error message: ValidationException: The provided key element does not match the schema
```

**Solution**:
```bash
# DynamoDB table MUST have:
# - Primary Key: LockID (String)
# - No other attributes required

# Verify table schema
aws dynamodb describe-table --table-name terraform-state-locks --query 'Table.KeySchema'

# Should show:
# [
#   {
#     "AttributeName": "LockID",
#     "KeyType": "HASH"
#   }
# ]
```

#### Mistake 2: S3 Bucket Not Versioned

**Problem**: Can't recover from state corruption

**Solution**:
```bash
# Enable versioning
aws s3api put-bucket-versioning \
  --bucket my-company-terraform-state \
  --versioning-configuration Status=Enabled

# Verify
aws s3api get-bucket-versioning --bucket my-company-terraform-state
```

#### Mistake 3: State File Locked Forever

**Problem**: Operation killed, lock not released

**Symptom**:
```
Error: Error acquiring the state lock
Lock Info:
  ID: 12345678-1234-1234-1234-123456789012
  ...
```

**Solution**:
```bash
# Check if operation is really not running
ps aux | grep terraform

# If confirmed safe, force unlock
terraform force-unlock 12345678-1234-1234-1234-123456789012

# Or delete lock from DynamoDB
aws dynamodb delete-item \
  --table-name terraform-state-locks \
  --key '{"LockID": {"S": "my-company-terraform-state/prod/infrastructure.tfstate-md5"}}'
```

#### Mistake 4: Wrong IAM Permissions

**Problem**: Cannot access state or lock table

**Solution**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::my-company-terraform-state"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::my-company-terraform-state/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:*:*:table/terraform-state-locks"
    }
  ]
}
```

#### Troubleshooting: Corrupted State

```bash
# 1. List state versions in S3
aws s3api list-object-versions \
  --bucket my-company-terraform-state \
  --prefix prod/infrastructure.tfstate

# 2. Download previous version
aws s3api get-object \
  --bucket my-company-terraform-state \
  --key prod/infrastructure.tfstate \
  --version-id <version-id> \
  terraform.tfstate.backup

# 3. Verify state
terraform state list -state=terraform.tfstate.backup

# 4. Push good state (be careful!)
terraform state push terraform.tfstate.backup
```

### Interview Questions with Answers

#### Q1: Why is remote state important for teams?

**Answer**:
Remote state is critical for team collaboration because:

1. **Centralized storage**: All team members access the same state
2. **State locking**: Prevents concurrent modifications that could corrupt state
3. **Version history**: S3 versioning allows rollback to previous states
4. **Security**: State can be encrypted and access-controlled
5. **Audit trail**: Track who made changes and when
6. **No local copies**: Reduces risk of losing state files

**Without remote state**:
- Team members overwrite each other's changes
- State divergence between team members
- No protection against concurrent operations
- State files stored on individual machines (security risk)
- No audit trail

#### Q2: What happens if state lock table is deleted?

**Answer**:
If DynamoDB lock table is deleted:

**Immediate Impact**:
- Terraform can still read/write state from S3
- **Loss of state locking** - most critical issue
- Multiple users can modify infrastructure simultaneously
- High risk of state corruption
- No protection against race conditions

**What Terraform does**:
- Continues to work (degraded mode)
- Shows warning about missing lock table
- No error on init/plan/apply
- But multiple applies can run concurrently ❌

**Recovery**:
```bash
# 1. Recreate lock table
aws dynamodb create-table \
  --table-name terraform-state-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

# 2. Locking resumes automatically
terraform init
```

**Prevention**:
- Add lifecycle prevent_destroy to lock table
- Use IAM policies to prevent deletion
- Monitor lock table existence

#### Q3: How do you migrate state between backends?

**Answer**:
Migration process:

**Scenario 1: Local to S3**:
```bash
# 1. Configure new backend
# backend.tf
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}

# 2. Initialize with migration
terraform init -migrate-state

# 3. Verify migration
aws s3 ls s3://my-terraform-state/prod/

# 4. Remove local state
rm terraform.tfstate terraform.tfstate.backup
```

**Scenario 2: S3 to Terraform Cloud**:
```bash
# 1. Update backend configuration
terraform {
  cloud {
    organization = "my-org"
    workspaces {
      name = "prod"
    }
  }
}

# 2. Login to Terraform Cloud
terraform login

# 3. Initialize with migration
terraform init -migrate-state

# 4. Verify in Terraform Cloud UI
```

**Scenario 3: Change S3 bucket**:
```bash
# 1. Copy state to new bucket
aws s3 cp s3://old-bucket/terraform.tfstate s3://new-bucket/terraform.tfstate

# 2. Update backend configuration
terraform {
  backend "s3" {
    bucket = "new-bucket"  # Changed
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# 3. Reinitialize
terraform init -reconfigure
```

**Important**:
- Always backup state before migration
- Test with non-prod environments first
- Verify resource count after migration: `terraform state list`
- Don't delete old state immediately

#### Q4: How do you handle state in a multi-account AWS setup?

**Answer**:
**Challenge**: Different AWS accounts for dev/staging/prod

**Solution Approaches**:

**1. Separate State Files per Account** (Recommended):
```
terraform-infrastructure/
├── environments/
│   ├── dev/
│   │   ├── backend.tf    # Points to dev account S3
│   │   └── main.tf
│   ├── staging/
│   │   ├── backend.tf    # Points to staging account S3
│   │   └── main.tf
│   └── prod/
│       ├── backend.tf    # Points to prod account S3
│       └── main.tf
```

```hcl
# environments/dev/backend.tf
terraform {
  backend "s3" {
    bucket         = "dev-terraform-state"
    key            = "infrastructure.tfstate"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::111111111111:role/TerraformRole"
    dynamodb_table = "dev-terraform-locks"
  }
}

# environments/prod/backend.tf
terraform {
  backend "s3" {
    bucket         = "prod-terraform-state"
    key            = "infrastructure.tfstate"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::999999999999:role/TerraformRole"
    dynamodb_table = "prod-terraform-locks"
  }
}
```

**2. Centralized State Account**:
```hcl
# Single "management" account stores all state
terraform {
  backend "s3" {
    bucket         = "central-terraform-state"
    key            = "accounts/dev/infrastructure.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}

# But apply Terraform to different account
provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/TerraformRole"
  }
}
```

**Benefits**:
- Centralized state management
- Easier to audit
- Single set of IAM permissions for state access

**3. Terraform Cloud Workspaces**:
```hcl
terraform {
  cloud {
    organization = "my-company"
    
    workspaces {
      name = "prod-infrastructure"  # Separate workspace per account
    }
  }
}
```

**Best Practice**:
- Use separate state buckets per AWS account
- Implement cross-account assume role for execution
- Use different IAM roles per environment
- Tag state files with account ID

#### Q5: What's stored in Terraform state and why is it sensitive?

**Answer**:
**Terraform state contains**:

1. **Resource attributes**:
   - Resource IDs
   - IP addresses
   - DNS names
   - Configuration details

2. **Sensitive data** (potential):
   - Database passwords (if specified)
   - API keys
   - Private keys
   - Secrets (if referenced)

3. **Metadata**:
   - Resource dependencies
   - Provider configuration
   - Module outputs

**Example state snippet**:
```json
{
  "version": 4,
  "terraform_version": "1.6.0",
  "resources": [
    {
      "type": "aws_db_instance",
      "name": "main",
      "instances": [
        {
          "attributes": {
            "address": "mydb.abc123.us-east-1.rds.amazonaws.com",
            "username": "admin",
            "password": "SuperSecretPassword123!",  // ⚠️ Sensitive!
            "endpoint": "mydb.abc123.us-east-1.rds.amazonaws.com:5432"
          }
        }
      ]
    }
  ]
}
```

**Security Measures**:

1. **Encryption at rest**:
```hcl
terraform {
  backend "s3" {
    bucket  = "terraform-state"
    key     = "state.tfstate"
    encrypt = true  // Enable encryption
    kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345"  // Use KMS
  }
}
```

2. **Access control**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:role/TerraformRole"
      },
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::terraform-state",
        "arn:aws:s3:::terraform-state/*"
      ]
    },
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::terraform-state",
        "arn:aws:s3:::terraform-state/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
```

3. **Mark variables as sensitive**:
```hcl
variable "db_password" {
  type      = string
  sensitive = true  // Won't show in logs
}

output "db_password" {
  value     = aws_db_instance.main.password
  sensitive = true  // Won't show in output
}
```

4. **Use secret management**:
```hcl
# Don't store secrets in Terraform
# Use AWS Secrets Manager or Parameter Store
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}

resource "aws_db_instance" "main" {
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
}
```

**Best Practices**:
- Never commit state files to version control
- Use encryption for state storage
- Implement least privilege access
- Regularly rotate credentials
- Use separate secret management systems
- Audit state file access

---

## Task 6.3: Create Modular VPC Infrastructure

### Goal / Why It's Important

A well-designed **modular VPC** is the networking foundation for all AWS infrastructure. Creating reusable VPC modules:
- Ensures consistent networking across environments
- Simplifies multi-environment deployments
- Reduces errors through standardization
- Enables network isolation and security
- Facilitates disaster recovery and multi-region deployments

This is fundamental for any AWS infrastructure and a common DevOps interview topic.

### Prerequisites

- AWS account with VPC creation permissions
- Terraform installed and configured
- Understanding of AWS networking concepts
- Knowledge of CIDR blocks and subnetting

### Step-by-Step Implementation

#### Step 1: Create VPC Module Structure

```bash
# Create module directory structure
mkdir -p modules/vpc
cd modules/vpc

# Create module files
touch main.tf variables.tf outputs.tf README.md
```

#### Step 2: Define VPC Module Variables

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
  description = "Availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "database_subnets" {
  description = "Database subnet CIDR blocks"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway for all private subnets"
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
```

#### Step 3: Implement VPC Module

```hcl
# modules/vpc/main.tf
locals {
  max_subnet_length = max(
    length(var.private_subnets),
    length(var.public_subnets),
    length(var.database_subnets)
  )
  
  nat_gateway_count = var.single_nat_gateway ? 1 : (
    var.enable_nat_gateway ? local.max_subnet_length : 0
  )
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
    }
  )
}

# Database Subnet Group
resource "aws_db_subnet_group" "database" {
  count = length(var.database_subnets) > 0 ? 1 : 0

  name       = "${var.vpc_name}-database"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-database"
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
      Name = "${var.vpc_name}-nat-${count.index + 1}"
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
      Name = "${var.vpc_name}-nat-${count.index + 1}"
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
      Name = "${var.vpc_name}-public"
    }
  )
}

# Public Route to Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Public Route Table Association
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
      Name = "${var.vpc_name}-private-${count.index + 1}"
    }
  )
}

# Private Routes to NAT Gateway
resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? local.max_subnet_length : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
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
      Name = "${var.vpc_name}-vpn-gw"
    }
  )
}

# VPC Flow Logs
resource "aws_flow_log" "this" {
  vpc_id          = aws_vpc.this.id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.flow_logs.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-flow-logs"
    }
  )
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/aws/vpc/${var.vpc_name}"
  retention_in_days = 30

  tags = var.tags
}

resource "aws_iam_role" "flow_logs" {
  name = "${var.vpc_name}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "flow_logs" {
  name = "${var.vpc_name}-flow-logs-policy"
  role = aws_iam_role.flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
```

#### Step 4: Define Module Outputs

```hcl
# modules/vpc/outputs.tf
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "database_subnets" {
  description = "List of database subnet IDs"
  value       = aws_subnet.database[*].id
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
  description = "List of NAT Gateway public IPs"
  value       = aws_eip.nat[*].public_ip
}

output "internet_gateway_id" {
  description = "ID of Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "ID of public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = aws_route_table.private[*].id
}
```

#### Step 5: Use the VPC Module

```hcl
# environments/dev/main.tf
module "vpc" {
  source = "../../modules/vpc"

  vpc_name = "dev-vpc"
  vpc_cidr = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false  # One NAT per AZ

  tags = {
    Environment = "dev"
    Project     = "myapp"
    ManagedBy   = "Terraform"
  }
}

# Output VPC details
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

### Key Commands Summary

```bash
# Initialize and plan
terraform init
terraform plan

# Apply with auto-approve
terraform apply -auto-approve

# Show outputs
terraform output
terraform output -json

# Destroy specific resource
terraform destroy -target=module.vpc.aws_nat_gateway.this

# Import existing VPC
terraform import module.vpc.aws_vpc.this vpc-12345678

# Show state
terraform state list
terraform state show module.vpc.aws_vpc.this

# Refresh outputs
terraform refresh
```

### Verification

#### 1. Verify VPC Creation
```bash
# Get VPC ID
VPC_ID=$(terraform output -raw vpc_id)

# Describe VPC
aws ec2 describe-vpcs --vpc-ids $VPC_ID

# Check DNS settings
aws ec2 describe-vpc-attribute --vpc-id $VPC_ID --attribute enableDnsHostnames
aws ec2 describe-vpc-attribute --vpc-id $VPC_ID --attribute enableDnsSupport
```

#### 2. Verify Subnets
```bash
# List all subnets in VPC
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[*].[SubnetId,CidrBlock,AvailabilityZone,Tags[?Key==`Name`].Value|[0]]' \
  --output table

# Verify public subnets have public IPs enabled
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Type,Values=public" \
  --query 'Subnets[*].[SubnetId,MapPublicIpOnLaunch]' \
  --output table
```

#### 3. Verify NAT Gateways
```bash
# List NAT Gateways
aws ec2 describe-nat-gateways \
  --filter "Name=vpc-id,Values=$VPC_ID" \
  --query 'NatGateways[*].[NatGatewayId,State,SubnetId,NatGatewayAddresses[0].PublicIp]' \
  --output table
```

#### 4. Verify Route Tables
```bash
# List route tables
aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'RouteTables[*].[RouteTableId,Tags[?Key==`Name`].Value|[0],Associations[0].SubnetId]' \
  --output table

# Check public routes
aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=*public*" \
  --query 'RouteTables[*].Routes' \
  --output table
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Overlapping CIDR Blocks

**Problem**: Subnets overlap or exceed VPC CIDR

**Solution**:
```hcl
# Use cidrsubnet function for automatic calculation
locals {
  vpc_cidr = "10.0.0.0/16"
}

# Automatically calculate subnet CIDRs
public_subnets = [
  cidrsubnet(local.vpc_cidr, 8, 1),  # 10.0.1.0/24
  cidrsubnet(local.vpc_cidr, 8, 2),  # 10.0.2.0/24
  cidrsubnet(local.vpc_cidr, 8, 3),  # 10.0.3.0/24
]

private_subnets = [
  cidrsubnet(local.vpc_cidr, 8, 11), # 10.0.11.0/24
  cidrsubnet(local.vpc_cidr, 8, 12), # 10.0.12.0/24
  cidrsubnet(local.vpc_cidr, 8, 13), # 10.0.13.0/24
]
```

#### Mistake 2: Too Many NAT Gateways (Cost)

**Problem**: NAT Gateway costs add up ($0.045/hour per NAT * 3 AZs = $100/month)

**Solution**:
```hcl
# For dev/staging, use single NAT Gateway
module "vpc" {
  source = "../../modules/vpc"
  
  enable_nat_gateway = true
  single_nat_gateway = true  # Only one NAT for all AZs
  
  # For prod, use one NAT per AZ for HA
  # single_nat_gateway = false
}
```

#### Mistake 3: Insufficient IP Addresses

**Problem**: Running out of IPs in subnets

**Solution**:
```hcl
# Plan ahead for IP growth
# /24 = 251 usable IPs (5 reserved by AWS)
# /23 = 507 usable IPs
# /22 = 1019 usable IPs

# Example: EKS needs many IPs for pods
private_subnets = [
  "10.0.0.0/19",   # 8187 IPs per subnet
  "10.0.32.0/19",
  "10.0.64.0/19",
]
```

### Interview Questions with Answers

#### Q1: Why do we need both public and private subnets?

**Answer**:
**Public Subnets**:
- Have route to Internet Gateway (0.0.0.0/0 → IGW)
- Resources get public IPs
- Direct internet access (inbound and outbound)
- Use for: Load balancers, bastion hosts, NAT gateways

**Private Subnets**:
- Route to NAT Gateway for outbound traffic
- No public IPs
- No direct inbound internet access
- Use for: Application servers, databases, backend services

**Security Benefits**:
- Defense in depth: Reduced attack surface
- Private resources not directly accessible from internet
- Controlled outbound access through NAT
- Compliance requirements (PCI-DSS, HIPAA)

**Example Architecture**:
```
Internet
   ↓
Internet Gateway
   ↓
Public Subnet (ALB)
   ↓
Private Subnet (EC2 App Servers)
   ↓
Private Subnet (RDS Database)
```

#### Q2: What is a NAT Gateway and why do we need it?

**Answer**:
**NAT Gateway** (Network Address Translation) allows resources in private subnets to access the internet while remaining private.

**Purpose**:
- Outbound internet access from private subnets
- Download patches and updates
- Access external APIs
- Pull container images
- Install packages

**Without NAT Gateway**:
- Private subnet resources cannot access internet
- Cannot download updates
- Cannot access AWS services via public endpoints (unless using VPC endpoints)

**NAT Gateway vs NAT Instance**:
| Feature | NAT Gateway | NAT Instance |
|---------|-------------|--------------|
| Managed | Fully managed by AWS | Self-managed EC2 |
| Availability | HA within AZ | Single point of failure |
| Bandwidth | Up to 100 Gbps | Depends on instance type |
| Maintenance | None required | You manage |
| Cost | $0.045/hour + data | EC2 cost + data |
| Best for | Production | Cost optimization (dev) |

**High Availability**:
```hcl
# One NAT Gateway per AZ for HA
resource "aws_nat_gateway" "this" {
  count = length(var.public_subnets)  # One per AZ
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}
```

#### Q3: Explain VPC CIDR planning best practices.

**Answer**:
**CIDR Planning Principles**:

1. **Start with large enough CIDR**:
```
/16 = 65,536 IPs (recommended for production)
/17 = 32,768 IPs
/18 = 16,384 IPs
/20 = 4,096 IPs (minimum for large deployments)
```

2. **Avoid overlap with**:
- Other VPCs (if peering planned)
- On-premises networks (if VPN/Direct Connect)
- Common ranges (192.168.0.0/16, 172.16.0.0/12)

3. **Reserve space for growth**:
```hcl
# Bad: Using entire /16
vpc_cidr = "10.0.0.0/16"
public_subnets = ["10.0.0.0/20", "10.0.16.0/20", ...]  # No room to grow

# Good: Using only part of /16
vpc_cidr = "10.0.0.0/16"
public_subnets = ["10.0.0.0/24", "10.0.1.0/24", ...]  # Lots of room
```

4. **Subnet sizing by purpose**:
```hcl
# Small subnets for infrastructure
public_subnets  = ["10.0.1.0/24", ...]   # ~250 IPs for ALB, NAT

# Large subnets for workloads
private_subnets = ["10.0.32.0/19", ...]  # ~8000 IPs for EKS pods

# Small subnets for databases
database_subnets = ["10.0.21.0/24", ...] # ~250 IPs sufficient
```

5. **AWS IP Reservations**:
AWS reserves 5 IPs per subnet:
- .0: Network address
- .1: VPC router
- .2: DNS server
- .3: Reserved for future use
- .255: Broadcast (not used in VPC but reserved)

So /24 has 256 - 5 = 251 usable IPs

**Planning Tool**:
```bash
# Calculate subnet details
aws ec2 describe-subnets --subnet-ids subnet-12345 \
  --query 'Subnets[0].[CidrBlock,AvailableIpAddressCount]'
```

---

## Task 6.4: Provision Multi-Environment Infrastructure

### Goal / Why It's Important

Managing **multiple environments** (dev, staging, prod) efficiently is crucial for:
- Consistent infrastructure across environments
- Safe testing before production deployments
- Cost optimization (smaller dev/staging environments)
- Disaster recovery and blue/green deployments
- Compliance and security isolation

Proper environment management prevents configuration drift and reduces errors.

### Prerequisites

- Understanding of Terraform modules
- AWS account with multi-environment strategy
- Terraform workspaces or directory-based organization
- CI/CD knowledge for automation

### Step-by-Step Implementation

#### Step 1: Choose Environment Strategy

**Option A: Directory-Based** (Recommended for production):
```
terraform/
├── modules/
│   ├── vpc/
│   ├── eks/
│   └── rds/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   │   └── ...
│   └── prod/
│       └── ...
└── shared/
    └── ...
```

**Option B: Workspace-Based** (For simpler setups):
```
terraform/
├── main.tf
├── variables.tf
└── terraform.tfvars
# Use: terraform workspace select dev/staging/prod
```

#### Step 2: Create Environment-Specific Configurations

```hcl
# environments/dev/terraform.tfvars
environment = "dev"
aws_region  = "us-east-1"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"

# EKS Configuration
eks_cluster_version = "1.28"
eks_node_groups = {
  general = {
    desired_size = 2
    min_size     = 1
    max_size     = 3
    instance_types = ["t3.medium"]
  }
}

# RDS Configuration
rds_instance_class    = "db.t3.micro"
rds_allocated_storage = 20

# Tags
common_tags = {
  Environment = "dev"
  Project     = "myapp"
  ManagedBy   = "Terraform"
  CostCenter  = "engineering"
}
```

```hcl
# environments/prod/terraform.tfvars
environment = "prod"
aws_region  = "us-east-1"

# VPC Configuration
vpc_cidr = "10.100.0.0/16"

# EKS Configuration
eks_cluster_version = "1.28"
eks_node_groups = {
  general = {
    desired_size = 6
    min_size     = 3
    max_size     = 10
    instance_types = ["m5.xlarge"]
  }
  spot = {
    desired_size = 3
    min_size     = 0
    max_size     = 10
    instance_types = ["m5.large", "m5a.large"]
    capacity_type  = "SPOT"
  }
}

# RDS Configuration
rds_instance_class    = "db.r5.xlarge"
rds_allocated_storage = 500
rds_multi_az          = true
rds_backup_retention  = 30

# Tags
common_tags = {
  Environment = "prod"
  Project     = "myapp"
  ManagedBy   = "Terraform"
  CostCenter  = "engineering"
}
```

#### Step 3: Create Main Configuration

```hcl
# environments/dev/main.tf
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "mycompany-terraform-state"
    key            = "dev/infrastructure.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = var.common_tags
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"
  
  vpc_name = "${var.environment}-vpc"
  vpc_cidr = var.vpc_cidr
  
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  
  public_subnets   = [for k, v in slice(data.aws_availability_zones.available.names, 0, 3) : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets  = [for k, v in slice(data.aws_availability_zones.available.names, 0, 3) : cidrsubnet(var.vpc_cidr, 8, k + 10)]
  database_subnets = [for k, v in slice(data.aws_availability_zones.available.names, 0, 3) : cidrsubnet(var.vpc_cidr, 8, k + 20)]
  
  enable_nat_gateway = true
  single_nat_gateway = var.environment != "prod"
  
  tags = var.common_tags
}

# EKS Module
module "eks" {
  source = "../../modules/eks"
  
  cluster_name    = "${var.environment}-eks-cluster"
  cluster_version = var.eks_cluster_version
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  node_groups = var.eks_node_groups
  
  tags = var.common_tags
}

# RDS Module
module "rds" {
  source = "../../modules/rds"
  
  identifier     = "${var.environment}-postgres"
  engine         = "postgres"
  engine_version = "15.3"
  
  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  multi_az          = var.environment == "prod"
  
  db_name  = "myapp"
  username = "dbadmin"
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.database_subnets
  
  backup_retention_period = var.environment == "prod" ? 30 : 7
  
  tags = var.common_tags
}

# Secrets
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "${var.environment}/db/password"
}
```

#### Step 4: Create Variables File

```hcl
# environments/dev/variables.tf
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "eks_cluster_version" {
  description = "EKS cluster version"
  type        = string
}

variable "eks_node_groups" {
  description = "EKS node group configurations"
  type        = any
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
```

#### Step 5: Create Deployment Scripts

```bash
# scripts/deploy.sh
#!/bin/bash
set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./deploy.sh <environment>"
    echo "Example: ./deploy.sh dev"
    exit 1
fi

if [ ! -d "environments/$ENVIRONMENT" ]; then
    echo "Environment $ENVIRONMENT not found"
    exit 1
fi

cd "environments/$ENVIRONMENT"

echo "Deploying to $ENVIRONMENT environment..."

# Initialize
terraform init

# Validate
terraform validate

# Plan
terraform plan -out=tfplan

# Review and confirm
echo ""
echo "Please review the plan above."
read -p "Do you want to apply these changes? (yes/no): " confirm

if [ "$confirm" == "yes" ]; then
    terraform apply tfplan
    rm -f tfplan
    echo "Deployment to $ENVIRONMENT complete!"
else
    echo "Deployment cancelled"
    rm -f tfplan
    exit 1
fi
```

```bash
# scripts/destroy.sh
#!/bin/bash
set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./destroy.sh <environment>"
    exit 1
fi

if [ "$ENVIRONMENT" == "prod" ]; then
    echo "Cannot destroy production environment using this script!"
    echo "If you really want to destroy prod, do it manually with proper approvals."
    exit 1
fi

cd "environments/$ENVIRONMENT"

echo "WARNING: This will destroy all resources in $ENVIRONMENT!"
read -p "Type 'destroy-$ENVIRONMENT' to confirm: " confirm

if [ "$confirm" == "destroy-$ENVIRONMENT" ]; then
    terraform destroy -auto-approve
    echo "Environment $ENVIRONMENT destroyed"
else
    echo "Destruction cancelled"
    exit 1
fi
```

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

#### Step 6: Environment Promotion Workflow

```bash
# scripts/promote.sh
#!/bin/bash
set -e

SOURCE_ENV=$1
TARGET_ENV=$2

if [ -z "$SOURCE_ENV" ] || [ -z "$TARGET_ENV" ]; then
    echo "Usage: ./promote.sh <source-env> <target-env>"
    echo "Example: ./promote.sh dev staging"
    exit 1
fi

echo "Promoting configuration from $SOURCE_ENV to $TARGET_ENV"

# Compare configurations
echo "Differences between environments:"
diff -u "environments/$SOURCE_ENV/main.tf" "environments/$TARGET_ENV/main.tf" || true

# Update target environment
read -p "Do you want to update $TARGET_ENV with $SOURCE_ENV configuration? (yes/no): " confirm

if [ "$confirm" == "yes" ]; then
    # Copy main.tf (keeping environment-specific tfvars)
    cp "environments/$SOURCE_ENV/main.tf" "environments/$TARGET_ENV/main.tf"
    
    echo "Configuration promoted. Please review and update terraform.tfvars for $TARGET_ENV"
    echo "Then run: ./deploy.sh $TARGET_ENV"
else
    echo "Promotion cancelled"
fi
```

### Key Commands Summary

```bash
# Deploy to specific environment
./scripts/deploy.sh dev
./scripts/deploy.sh staging
./scripts/deploy.sh prod

# Compare environments
diff -u environments/dev/terraform.tfvars environments/prod/terraform.tfvars

# Check what would change in prod
cd environments/prod
terraform plan

# Promote configuration
./scripts/promote.sh dev staging

# Destroy non-prod environment
./scripts/destroy.sh dev

# View state of specific environment
cd environments/dev
terraform state list
terraform output

# Compare states between environments
terraform state pull > /tmp/dev-state.json  # In dev
terraform state pull > /tmp/prod-state.json # In prod
diff /tmp/dev-state.json /tmp/prod-state.json
```

### Verification

#### 1. Verify Environment Isolation
```bash
# Check VPC CIDRs don't overlap
aws ec2 describe-vpcs \
  --filters "Name=tag:Environment,Values=dev,staging,prod" \
  --query 'Vpcs[*].[Tags[?Key==`Environment`].Value|[0],CidrBlock]' \
  --output table
```

#### 2. Compare Resource Counts
```bash
# Count resources per environment
for env in dev staging prod; do
  echo "Environment: $env"
  cd environments/$env
  terraform state list | wc -l
  cd ../..
done
```

#### 3. Verify Tags
```bash
# Check all resources have environment tags
aws resourcegroupstaggingapi get-resources \
  --tag-filters Key=Environment,Values=dev \
  --query 'ResourceTagMappingList[*].[ResourceARN]' \
  --output table
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Shared State Between Environments

**Problem**: All environments using same state file

**Solution**:
```hcl
# Each environment MUST have separate state file
# environments/dev/backend.tf
terraform {
  backend "s3" {
    key = "dev/infrastructure.tfstate"  # Different key!
  }
}

# environments/prod/backend.tf
terraform {
  backend "s3" {
    key = "prod/infrastructure.tfstate"  # Different key!
  }
}
```

#### Mistake 2: Hardcoded Values

**Problem**: Environment-specific values hardcoded in modules

**Solution**:
```hcl
# Bad
resource "aws_instance" "web" {
  instance_type = "t3.large"  # Same for all environments
}

# Good
resource "aws_instance" "web" {
  instance_type = var.instance_type  # Configured per environment
}
```

### Interview Questions with Answers

#### Q1: What's the best way to manage multiple environments in Terraform?

**Answer**:
**Three main approaches**:

1. **Separate Directories** (Best for production):
```
terraform/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
```

**Pros**:
- Complete isolation
- Different backends per environment
- Clear separation
- Can have different module versions
- Easy access control

**Cons**:
- Code duplication
- More files to maintain

2. **Workspaces** (Good for simple setups):
```bash
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev
```

**Pros**:
- Single codebase
- Easy to switch
- Less code duplication

**Cons**:
- Same backend (higher risk)
- Harder access control
- Easy to apply to wrong workspace
- Not recommended for production

3. **Terragrunt** (Advanced):
```
terragrunt/
├── dev/
│   └── terragrunt.hcl
├── prod/
│   └── terragrunt.hcl
└── modules/
```

**Pros**:
- DRY (Don't Repeat Yourself)
- Centralized configuration
- Dependency management

**Cons**:
- Additional tool
- Learning curve
- More complexity

**Recommendation**: Use separate directories for production environments.

