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

