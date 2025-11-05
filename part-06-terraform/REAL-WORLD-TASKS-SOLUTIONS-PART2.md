# Terraform Infrastructure as Code Real-World Tasks - Complete Solutions (Part 2)

> **📚 Navigation:** [Part 1 Solutions](./REAL-WORLD-TASKS-SOLUTIONS.md) | [Tasks](./REAL-WORLD-TASKS.md) | [README](./README.md)

This document continues the production-ready solutions for Terraform Infrastructure as Code real-world tasks (Tasks 6.5-6.18).

---

## Task 6.5: Implement Terraform Variables and Locals

> **📖 [Back to Task](./REAL-WORLD-TASKS.md#task-65-implement-terraform-variables-and-locals)**

### Solution Overview

This solution demonstrates proper use of variables, locals, validation, and input handling to create flexible and maintainable Terraform configurations.

### Complete Solution

#### Step 1: Variable Types and Validation

```hcl
# variables.tf
variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d{1}$", var.aws_region))
    error_message = "AWS region must be in valid format (e.g., us-east-1)."
  }
}

variable "vpc_config" {
  description = "VPC configuration object"
  type = object({
    cidr_block           = string
    enable_dns_hostnames = bool
    enable_dns_support   = bool
    enable_nat_gateway   = bool
  })

  validation {
    condition     = can(cidrhost(var.vpc_config.cidr_block, 0))
    error_message = "VPC CIDR block must be valid IPv4 CIDR."
  }
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least 2 availability zones required for high availability."
  }
}

variable "instance_configs" {
  description = "Map of instance configurations by environment"
  type = map(object({
    instance_type = string
    min_size      = number
    max_size      = number
    desired_size  = number
  }))

  validation {
    condition = alltrue([
      for k, v in var.instance_configs :
      v.min_size <= v.desired_size && v.desired_size <= v.max_size
    ])
    error_message = "Instance configuration must satisfy: min_size <= desired_size <= max_size."
  }

  default = {
    dev = {
      instance_type = "t3.small"
      min_size      = 1
      max_size      = 3
      desired_size  = 2
    }
    prod = {
      instance_type = "m5.large"
      min_size      = 3
      max_size      = 10
      desired_size  = 5
    }
  }
}

variable "enable_features" {
  description = "Feature flags"
  type = object({
    monitoring     = bool
    auto_scaling   = bool
    backup         = bool
    multi_az       = bool
  })

  default = {
    monitoring   = false
    auto_scaling = false
    backup       = true
    multi_az     = false
  }
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)

  validation {
    condition = alltrue([
      for k, v in var.tags :
      can(regex("^[a-zA-Z0-9+-=._:/@ ]{1,256}$", k)) &&
      can(regex("^[a-zA-Z0-9+-=._:/@ ]{0,256}$", v))
    ])
    error_message = "Tags must comply with AWS tag naming rules."
  }

  default = {}
}

variable "database_config" {
  description = "Database configuration"
  type = object({
    engine               = string
    engine_version       = string
    instance_class       = string
    allocated_storage    = number
    max_allocated_storage = number
    storage_encrypted    = bool
    backup_retention_days = number
    multi_az             = bool
  })

  validation {
    condition     = contains(["postgres", "mysql", "mariadb"], var.database_config.engine)
    error_message = "Database engine must be postgres, mysql, or mariadb."
  }

  validation {
    condition     = var.database_config.allocated_storage >= 20 && var.database_config.allocated_storage <= 65536
    error_message = "Allocated storage must be between 20 and 65536 GB."
  }

  validation {
    condition     = var.database_config.backup_retention_days >= 0 && var.database_config.backup_retention_days <= 35
    error_message = "Backup retention must be between 0 and 35 days."
  }

  sensitive = true
}

variable "cidr_blocks" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)

  validation {
    condition = alltrue([
      for cidr in var.cidr_blocks :
      can(cidrhost(cidr, 0))
    ])
    error_message = "All CIDR blocks must be valid IPv4 CIDR notation."
  }
}

variable "allowed_ips" {
  description = "List of allowed IP addresses for access"
  type        = set(string)

  validation {
    condition = alltrue([
      for ip in var.allowed_ips :
      can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}(/\\d{1,2})?$", ip))
    ])
    error_message = "All IPs must be in valid IPv4 format."
  }

  default = []
}

variable "application_config" {
  description = "Application configuration with sensitive data"
  type = object({
    name    = string
    port    = number
    version = string
  })

  validation {
    condition     = var.application_config.port >= 1024 && var.application_config.port <= 65535
    error_message = "Port must be between 1024 and 65535."
  }
}

variable "optional_string" {
  description = "Optional string variable with null support"
  type        = string
  default     = null
}

variable "optional_number" {
  description = "Optional number variable"
  type        = number
  default     = null
}
```

#### Step 2: Locals for Complex Logic

```hcl
# locals.tf
locals {
  # Environment-specific settings
  is_production = var.environment == "prod"
  is_development = var.environment == "dev"

  # Instance configuration for current environment
  instance_config = var.instance_configs[var.environment]

  # Naming convention
  name_prefix = "${var.application_config.name}-${var.environment}"
  name_suffix = "${data.aws_region.current.name}"

  # Resource names
  resource_names = {
    vpc              = "${local.name_prefix}-vpc"
    subnet_public    = "${local.name_prefix}-public-subnet"
    subnet_private   = "${local.name_prefix}-private-subnet"
    subnet_database  = "${local.name_prefix}-database-subnet"
    security_group   = "${local.name_prefix}-sg"
    load_balancer    = "${local.name_prefix}-alb"
    database         = "${local.name_prefix}-db"
    s3_bucket        = "${local.name_prefix}-bucket-${random_id.bucket_suffix.hex}"
  }

  # Subnet CIDR calculation
  subnet_count = length(var.availability_zones)

  public_subnets = [
    for i in range(local.subnet_count) :
    cidrsubnet(var.vpc_config.cidr_block, 8, i)
  ]

  private_subnets = [
    for i in range(local.subnet_count) :
    cidrsubnet(var.vpc_config.cidr_block, 8, i + 10)
  ]

  database_subnets = [
    for i in range(local.subnet_count) :
    cidrsubnet(var.vpc_config.cidr_block, 8, i + 20)
  ]

  # Feature flags with environment overrides
  features = merge(var.enable_features, {
    monitoring   = var.enable_features.monitoring || local.is_production
    auto_scaling = var.enable_features.auto_scaling || local.is_production
    multi_az     = var.enable_features.multi_az || local.is_production
    backup       = var.enable_features.backup || !local.is_development
  })

  # Merged tags with defaults and computed values
  common_tags = merge(
    var.tags,
    {
      Environment  = var.environment
      ManagedBy    = "Terraform"
      Region       = data.aws_region.current.name
      Project      = var.application_config.name
      Timestamp    = timestamp()
      TerraformVersion = "Terraform ${terraform.version}"
    }
  )

  # Database configuration with environment-specific overrides
  database_final_config = merge(var.database_config, {
    multi_az             = local.is_production ? true : var.database_config.multi_az
    backup_retention_days = local.is_production ? max(var.database_config.backup_retention_days, 30) : var.database_config.backup_retention_days
    storage_encrypted    = true  # Always encrypt
  })

  # Security group rules as objects
  web_ingress_rules = {
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP from anywhere"
    }
    https = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS from anywhere"
    }
    app = {
      from_port   = var.application_config.port
      to_port     = var.application_config.port
      protocol    = "tcp"
      cidr_blocks = [var.vpc_config.cidr_block]
      description = "Application port from VPC"
    }
  }

  # Conditional resource creation flags
  create_nat_gateway = var.vpc_config.enable_nat_gateway && length(local.private_subnets) > 0
  create_database = local.is_production || var.environment == "staging"
  create_monitoring = local.features.monitoring

  # Cost estimation
  monthly_cost_estimate = local.is_production ? {
    instances = local.instance_config.desired_size * 730 * 0.083  # t3.large hourly cost * hours
    nat       = length(var.availability_zones) * 0.045 * 730       # NAT Gateway cost
    rds       = 1 * 0.034 * 730                                     # db.t3.micro hourly cost
    total     = (local.instance_config.desired_size * 730 * 0.083) + (length(var.availability_zones) * 0.045 * 730) + (1 * 0.034 * 730)
  } : {}

  # Flatten nested structures
  all_subnet_ids = concat(
    aws_subnet.public[*].id,
    aws_subnet.private[*].id,
    aws_subnet.database[*].id
  )

  # Map transformations
  subnet_az_map = {
    for idx, az in var.availability_zones :
    az => {
      public   = aws_subnet.public[idx].id
      private  = aws_subnet.private[idx].id
      database = aws_subnet.database[idx].id
    }
  }

  # Conditional expressions
  instance_type = local.is_production ? "m5.large" : (
    local.is_development ? "t3.small" : "t3.medium"
  )

  # String manipulation
  environment_upper = upper(var.environment)
  environment_title = title(var.environment)

  # Lookup with default
  log_retention_days = lookup({
    dev     = 7
    staging = 14
    prod    = 90
  }, var.environment, 30)

  # Complex conditionals
  backup_config = local.is_production ? {
    enabled          = true
    retention_days   = 30
    backup_window    = "03:00-04:00"
    maintenance_window = "mon:04:00-mon:05:00"
  } : {
    enabled          = false
    retention_days   = 7
    backup_window    = "03:00-04:00"
    maintenance_window = "sun:04:00-sun:05:00"
  }
}

# Data sources
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
```

#### Step 3: Example Implementation

```hcl
# main.tf
# VPC using locals
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_config.cidr_block
  enable_dns_hostnames = var.vpc_config.enable_dns_hostnames
  enable_dns_support   = var.vpc_config.enable_dns_support

  tags = merge(local.common_tags, {
    Name = local.resource_names.vpc
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(local.public_subnets)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.resource_names.subnet_public}-${count.index + 1}"
    Type = "public"
    AZ   = var.availability_zones[count.index]
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(local.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.common_tags, {
    Name = "${local.resource_names.subnet_private}-${count.index + 1}"
    Type = "private"
    AZ   = var.availability_zones[count.index]
  })
}

# Database Subnets
resource "aws_subnet" "database" {
  count = length(local.database_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = local.database_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.common_tags, {
    Name = "${local.resource_names.subnet_database}-${count.index + 1}"
    Type = "database"
    AZ   = var.availability_zones[count.index]
  })
}

# Security Group with dynamic rules
resource "aws_security_group" "web" {
  name_prefix = "${local.resource_names.security_group}-"
  description = "Security group for ${var.application_config.name}"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.web_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(local.common_tags, {
    Name = local.resource_names.security_group
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Conditional RDS instance
resource "aws_db_instance" "main" {
  count = local.create_database ? 1 : 0

  identifier     = local.resource_names.database
  engine         = local.database_final_config.engine
  engine_version = local.database_final_config.engine_version
  instance_class = local.database_final_config.instance_class

  allocated_storage     = local.database_final_config.allocated_storage
  max_allocated_storage = local.database_final_config.max_allocated_storage
  storage_encrypted     = local.database_final_config.storage_encrypted

  db_name  = replace(var.application_config.name, "-", "_")
  username = "admin"
  password = random_password.db_password[0].result

  multi_az               = local.database_final_config.multi_az
  backup_retention_period = local.database_final_config.backup_retention_days
  backup_window          = local.backup_config.backup_window
  maintenance_window     = local.backup_config.maintenance_window

  enabled_cloudwatch_logs_exports = local.create_monitoring ? ["postgresql", "upgrade"] : []

  vpc_security_group_ids = [aws_security_group.web.id]
  db_subnet_group_name   = aws_db_subnet_group.database[0].name

  skip_final_snapshot = !local.is_production

  tags = local.common_tags
}

resource "aws_db_subnet_group" "database" {
  count = local.create_database ? 1 : 0

  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = local.common_tags
}

resource "random_password" "db_password" {
  count = local.create_database ? 1 : 0

  length  = 32
  special = true
}

# CloudWatch Log Group with variable retention
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/${var.application_config.name}/${var.environment}"
  retention_in_days = local.log_retention_days

  tags = local.common_tags
}
```

#### Step 4: Example terraform.tfvars

```hcl
# terraform.tfvars
environment = "prod"
aws_region  = "us-east-1"

vpc_config = {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
}

availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

instance_configs = {
  dev = {
    instance_type = "t3.small"
    min_size      = 1
    max_size      = 3
    desired_size  = 2
  }
  staging = {
    instance_type = "t3.medium"
    min_size      = 2
    max_size      = 5
    desired_size  = 3
  }
  prod = {
    instance_type = "m5.large"
    min_size      = 3
    max_size      = 10
    desired_size  = 5
  }
}

enable_features = {
  monitoring   = true
  auto_scaling = true
  backup       = true
  multi_az     = true
}

database_config = {
  engine                 = "postgres"
  engine_version         = "15.3"
  instance_class         = "db.r5.large"
  allocated_storage      = 100
  max_allocated_storage  = 500
  storage_encrypted      = true
  backup_retention_days  = 30
  multi_az              = true
}

application_config = {
  name    = "myapp"
  port    = 8080
  version = "1.0.0"
}

cidr_blocks = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

allowed_ips = [
  "203.0.113.0/24",
  "198.51.100.0/24"
]

tags = {
  Project     = "MyApplication"
  CostCenter  = "Engineering"
  Owner       = "DevOps Team"
  Compliance  = "HIPAA"
}
```

#### Step 5: Outputs with Locals

```hcl
# outputs.tf
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "environment_info" {
  description = "Environment information"
  value = {
    name         = var.environment
    is_production = local.is_production
    region       = data.aws_region.current.name
    account_id   = data.aws_caller_identity.current.account_id
  }
}

output "subnet_mapping" {
  description = "Subnet IDs mapped by AZ"
  value       = local.subnet_az_map
}

output "resource_names" {
  description = "Generated resource names"
  value       = local.resource_names
}

output "feature_flags" {
  description = "Enabled features"
  value       = local.features
}

output "database_endpoint" {
  description = "Database endpoint"
  value       = local.create_database ? aws_db_instance.main[0].endpoint : "Not created"
  sensitive   = true
}

output "estimated_monthly_cost" {
  description = "Estimated monthly cost (USD)"
  value       = local.is_production ? local.monthly_cost_estimate : "N/A for non-production"
}

output "backup_configuration" {
  description = "Backup configuration applied"
  value       = local.backup_config
}
```

### Verification Steps

```bash
# Validate variable inputs
terraform validate

# Check variable values
terraform console
> var.environment
> var.vpc_config
> local.is_production
> local.resource_names

# Test validation
terraform plan -var="environment=invalid"  # Should fail

# Test with valid values
terraform plan -var="environment=prod"

# Output all computed values
terraform apply -auto-approve
terraform output -json

# Test different environments
terraform plan -var-file="environments/dev.tfvars"
terraform plan -var-file="environments/prod.tfvars"
```

### Best Practices Demonstrated

1. **Input Validation**: Comprehensive validation rules
2. **Type Safety**: Strong typing with objects and lists
3. **DRY Principle**: Locals for computed values
4. **Naming Conventions**: Consistent naming patterns
5. **Environment-Specific**: Logic adapts to environment
6. **Cost Awareness**: Cost estimation in locals
7. **Security**: Sensitive variable marking
8. **Flexibility**: Feature flags and conditionals
9. **Documentation**: Clear descriptions for all variables
10. **Defaults**: Sensible defaults where appropriate

---

## Task 6.6: Use Data Sources and Dynamic Blocks

> **📖 [Back to Task](./REAL-WORLD-TASKS.md#task-66-use-data-sources-and-dynamic-blocks)**

### Solution Overview

This solution demonstrates effective use of Terraform data sources to query existing resources and dynamic blocks to handle repeating configuration blocks efficiently.

### Complete Solution

#### Step 1: Data Sources for Existing Resources

```hcl
# data-sources.tf

# Get current AWS account information
data "aws_caller_identity" "current" {}

# Get current region
data "aws_region" "current" {}

# Get available availability zones
data "aws_availability_zones" "available" {
  state = "available"
  
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Get the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get existing VPC by tag
data "aws_vpc" "existing" {
  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Get existing subnets in VPC
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }

  tags = {
    Type = "private"
  }
}

# Get subnet details
data "aws_subnet" "private_details" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

# Get existing security group
data "aws_security_group" "existing" {
  vpc_id = data.aws_vpc.existing.id

  filter {
    name   = "group-name"
    values = ["${var.environment}-web-sg"]
  }
}

# Get RDS engine versions
data "aws_rds_engine_version" "postgresql" {
  engine  = "postgres"
  version = "15.3"
}

# Get S3 bucket by name
data "aws_s3_bucket" "existing" {
  bucket = "${var.environment}-app-data"
}

# Get IAM policy document for assume role
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Get IAM policy document for S3 access
data "aws_iam_policy_document" "s3_access" {
  statement {
    sid    = "AllowS3ListBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      data.aws_s3_bucket.existing.arn
    ]
  }

  statement {
    sid    = "AllowS3ObjectAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${data.aws_s3_bucket.existing.arn}/*"
    ]
  }
}

# Get Secrets Manager secret
data "aws_secretsmanager_secret" "db_password" {
  name = "${var.environment}/database/password"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

# Get SSM Parameter
data "aws_ssm_parameter" "db_username" {
  name = "/${var.environment}/database/username"
}

# Get Route53 zone
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

# Get ACM certificate
data "aws_acm_certificate" "main" {
  domain   = "*.${var.domain_name}"
  statuses = ["ISSUED"]
}

# Get EKS cluster
data "aws_eks_cluster" "main" {
  name = "${var.environment}-eks-cluster"
}

data "aws_eks_cluster_auth" "main" {
  name = data.aws_eks_cluster.main.name
}

# Get ElastiCache subnet group
data "aws_elasticache_subnet_group" "main" {
  name = "${var.environment}-cache-subnet-group"
}

# Query CloudWatch log groups
data "aws_cloudwatch_log_groups" "app_logs" {
  log_group_name_prefix = "/aws/${var.application_name}"
}
```

#### Step 2: Dynamic Blocks for Security Groups

```hcl
# security-groups.tf

locals {
  # Define ingress rules as a map
  ingress_rules = {
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP from anywhere"
    }
    https = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS from anywhere"
    }
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidrs
      description = "SSH from allowed IPs"
    }
    app = {
      from_port   = var.application_port
      to_port     = var.application_port
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.existing.cidr_block]
      description = "Application port from VPC"
    }
  }

  # Define egress rules
  egress_rules = {
    all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  }

  # Conditional ingress rules based on environment
  conditional_ingress_rules = merge(
    local.ingress_rules,
    var.environment == "prod" ? {} : {
      debug = {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = [data.aws_vpc.existing.cidr_block]
        description = "Debug port (non-prod only)"
      }
    }
  )
}

resource "aws_security_group" "web" {
  name_prefix = "${var.environment}-web-"
  description = "Security group for web servers"
  vpc_id      = data.aws_vpc.existing.id

  # Dynamic ingress rules
  dynamic "ingress" {
    for_each = local.conditional_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  # Dynamic egress rules
  dynamic "egress" {
    for_each = local.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-web-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Database security group with source security group
resource "aws_security_group" "database" {
  name_prefix = "${var.environment}-database-"
  description = "Security group for database"
  vpc_id      = data.aws_vpc.existing.id

  dynamic "ingress" {
    for_each = var.database_access_security_groups
    content {
      from_port       = var.database_port
      to_port         = var.database_port
      protocol        = "tcp"
      security_groups = [ingress.value]
      description     = "Database access from ${ingress.key}"
    }
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
```

#### Step 3: Dynamic Blocks for IAM Policies

```hcl
# iam.tf

locals {
  # S3 buckets that need access
  s3_buckets = [
    "app-data",
    "app-logs",
    "app-backups"
  ]

  # DynamoDB tables that need access
  dynamodb_tables = [
    "sessions",
    "user-data",
    "application-state"
  ]

  # CloudWatch log groups
  log_groups = [
    "/aws/${var.application_name}/app",
    "/aws/${var.application_name}/access",
    "/aws/${var.application_name}/error"
  ]
}

resource "aws_iam_role" "app" {
  name               = "${var.environment}-app-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = var.tags
}

resource "aws_iam_policy" "app" {
  name        = "${var.environment}-app-policy"
  description = "Policy for application instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      # S3 bucket policies
      [for bucket in local.s3_buckets : {
        Sid    = "S3Access${replace(title(bucket), "-", "")}"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${var.environment}-${bucket}/*"
      }],
      
      # DynamoDB table policies
      [for table in local.dynamodb_tables : {
        Sid    = "DynamoDBAccess${replace(title(table), "-", "")}"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.environment}-${table}"
      }],
      
      # CloudWatch logs policies
      [for log_group in local.log_groups : {
        Sid    = "CloudWatchLogsAccess${md5(log_group)}"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${log_group}:*"
      }]
    )
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "app" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.app.arn
}
```

#### Step 4: Dynamic Blocks for Load Balancer

```hcl
# load-balancer.tf

locals {
  # Target groups configuration
  target_groups = {
    main = {
      port              = 80
      protocol          = "HTTP"
      health_check_path = "/health"
      priority          = 1
    }
    api = {
      port              = 8080
      protocol          = "HTTP"
      health_check_path = "/api/health"
      priority          = 2
    }
  }

  # Listener rules based on environment
  listener_rules = var.environment == "prod" ? {
    root = {
      priority = 100
      host_headers = ["www.example.com", "example.com"]
      target_group_key = "main"
    }
    api = {
      priority = 200
      path_patterns = ["/api/*"]
      target_group_key = "api"
    }
  } : {
    default = {
      priority = 100
      host_headers = ["${var.environment}.example.com"]
      target_group_key = "main"
    }
  }
}

resource "aws_lb" "main" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = data.aws_subnets.public.ids

  enable_deletion_protection = var.environment == "prod"
  enable_http2              = true
  enable_cross_zone_load_balancing = true

  dynamic "access_logs" {
    for_each = var.enable_alb_logs ? [1] : []
    content {
      bucket  = aws_s3_bucket.alb_logs[0].id
      enabled = true
      prefix  = "alb"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-alb"
  })
}

# Dynamic target groups
resource "aws_lb_target_group" "app" {
  for_each = local.target_groups

  name_prefix = "${substr(var.environment, 0, 3)}-${substr(each.key, 0, 3)}-"
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = data.aws_vpc.existing.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = each.value.health_check_path
    protocol            = each.value.protocol
    matcher             = "200"
  }

  deregistration_delay = var.environment == "prod" ? 300 : 30

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-${each.key}-tg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app["main"].arn
  }
}

# HTTP Listener (redirect to HTTPS)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Dynamic listener rules
resource "aws_lb_listener_rule" "app" {
  for_each = local.listener_rules

  listener_arn = aws_lb_listener.https.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[each.value.target_group_key].arn
  }

  dynamic "condition" {
    for_each = lookup(each.value, "host_headers", null) != null ? [1] : []
    content {
      host_header {
        values = each.value.host_headers
      }
    }
  }

  dynamic "condition" {
    for_each = lookup(each.value, "path_patterns", null) != null ? [1] : []
    content {
      path_pattern {
        values = each.value.path_patterns
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-rule-${each.key}"
  })
}
```

#### Step 5: Dynamic Blocks for Auto Scaling

```hcl
# autoscaling.tf

locals {
  # Auto scaling policies configuration
  scaling_policies = var.enable_auto_scaling ? {
    scale_up = {
      adjustment_type        = "ChangeInCapacity"
      scaling_adjustment     = 2
      cooldown              = 300
      metric_name           = "CPUUtilization"
      comparison_operator   = "GreaterThanThreshold"
      threshold             = 75
      evaluation_periods    = 2
      period                = 300
      statistic             = "Average"
    }
    scale_down = {
      adjustment_type        = "ChangeInCapacity"
      scaling_adjustment     = -1
      cooldown              = 300
      metric_name           = "CPUUtilization"
      comparison_operator   = "LessThanThreshold"
      threshold             = 25
      evaluation_periods    = 2
      period                = 300
      statistic             = "Average"
    }
  } : {}

  # Lifecycle hooks
  lifecycle_hooks = var.enable_lifecycle_hooks ? {
    launching = {
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      default_result      = "CONTINUE"
      heartbeat_timeout   = 300
    }
    terminating = {
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      default_result      = "CONTINUE"
      heartbeat_timeout   = 300
    }
  } : {}
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.environment}-app-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.app.name
  }

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = base64encode(templatefile("${path.module}/templates/user-data.sh", {
    environment = var.environment
    region      = data.aws_region.current.name
  }))

  dynamic "block_device_mappings" {
    for_each = var.additional_volumes
    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
        delete_on_termination = block_device_mappings.value.delete_on_termination
        encrypted             = true
      }
    }
  }

  dynamic "tag_specifications" {
    for_each = ["instance", "volume"]
    content {
      resource_type = tag_specifications.value
      tags = merge(var.tags, {
        Name = "${var.environment}-app"
      })
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  # IMDSv2
    http_put_response_hop_limit = 1
  }

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_autoscaling_group" "app" {
  name_prefix         = "${var.environment}-app-asg-"
  vpc_zone_identifier = data.aws_subnets.private.ids
  target_group_arns   = values(aws_lb_target_group.app)[*].arn

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  health_check_type         = "ELB"
  health_check_grace_period = 300
  default_cooldown          = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-app-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }

  enabled_metrics = var.enable_detailed_monitoring ? [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ] : []
}

# Dynamic auto scaling policies
resource "aws_autoscaling_policy" "app" {
  for_each = local.scaling_policies

  name                   = "${var.environment}-${each.key}"
  autoscaling_group_name = aws_autoscaling_group.app.name
  adjustment_type        = each.value.adjustment_type
  scaling_adjustment     = each.value.scaling_adjustment
  cooldown               = each.value.cooldown
}

# CloudWatch alarms for auto scaling
resource "aws_cloudwatch_metric_alarm" "app" {
  for_each = local.scaling_policies

  alarm_name          = "${var.environment}-${each.key}"
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = "AWS/EC2"
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_actions = [aws_autoscaling_policy.app[each.key].arn]

  tags = var.tags
}

# Dynamic lifecycle hooks
resource "aws_autoscaling_lifecycle_hook" "app" {
  for_each = local.lifecycle_hooks

  name                   = "${var.environment}-${each.key}"
  autoscaling_group_name = aws_autoscaling_group.app.name
  lifecycle_transition   = each.value.lifecycle_transition
  default_result         = each.value.default_result
  heartbeat_timeout      = each.value.heartbeat_timeout
}

resource "aws_iam_instance_profile" "app" {
  name_prefix = "${var.environment}-app-"
  role        = aws_iam_role.app.name

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
```

#### Step 6: Variables for Data Sources and Dynamic Blocks

```hcl
# variables.tf
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "application_name" {
  description = "Application name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "application_port" {
  description = "Application port number"
  type        = number
  default     = 8080
}

variable "database_port" {
  description = "Database port number"
  type        = number
  default     = 5432
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = []
}

variable "database_access_security_groups" {
  description = "Security groups that can access the database"
  type        = map(string)
  default     = {}
}

variable "enable_alb_logs" {
  description = "Enable ALB access logs"
  type        = bool
  default     = true
}

variable "enable_auto_scaling" {
  description = "Enable auto scaling"
  type        = bool
  default     = true
}

variable "enable_lifecycle_hooks" {
  description = "Enable ASG lifecycle hooks"
  type        = bool
  default     = false
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "asg_min_size" {
  description = "ASG minimum size"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "ASG maximum size"
  type        = number
  default     = 10
}

variable "asg_desired_capacity" {
  description = "ASG desired capacity"
  type        = number
  default     = 2
}

variable "additional_volumes" {
  description = "Additional EBS volumes"
  type = list(object({
    device_name           = string
    volume_size           = number
    volume_type           = string
    delete_on_termination = bool
  }))
  default = []
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
```

### Verification Steps

```bash
# Verify data sources
terraform console
> data.aws_ami.amazon_linux_2.id
> data.aws_vpc.existing.id
> data.aws_availability_zones.available.names
> data.aws_caller_identity.current.account_id

# Plan to see dynamic blocks in action
terraform plan

# Apply
terraform apply

# Verify security group rules
aws ec2 describe-security-groups \
  --group-ids $(terraform output -raw web_sg_id) \
  --query 'SecurityGroups[0].IpPermissions' \
  --output json | jq

# Verify target groups
aws elbv2 describe-target-groups \
  --names $(terraform output -json target_group_names | jq -r '.[]') \
  --output table

# Verify auto scaling policies
aws autoscaling describe-policies \
  --auto-scaling-group-name $(terraform output -raw asg_name) \
  --output table

# Test with different environments
terraform plan -var="environment=prod"
terraform plan -var="environment=dev"
```

### Best Practices Demonstrated

1. **Data Sources**: Query existing resources efficiently
2. **Dynamic Blocks**: Handle repeating configuration blocks
3. **Conditional Logic**: Environment-specific configurations
4. **for_each**: Create multiple similar resources
5. **locals**: Organize complex logic
6. **IAM Policies**: Dynamic policy generation
7. **Security Groups**: Flexible rule management
8. **Load Balancers**: Dynamic target groups and rules
9. **Auto Scaling**: Dynamic policies and alarms
10. **DRY Principle**: Avoid repetition with dynamic blocks

---