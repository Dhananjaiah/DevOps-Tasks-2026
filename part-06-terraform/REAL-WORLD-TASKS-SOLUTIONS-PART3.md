# Terraform Infrastructure as Code Real-World Tasks - Complete Solutions (Part 3)

> **📚 Navigation:** [Part 1](./REAL-WORLD-TASKS-SOLUTIONS.md) | [Part 2](./REAL-WORLD-TASKS-SOLUTIONS-PART2.md) | [Tasks](./REAL-WORLD-TASKS.md) | [README](./README.md)

This document continues the production-ready solutions for Terraform Infrastructure as Code real-world tasks (Tasks 6.9-6.18).

---

## Task 6.9: Import Existing AWS Resources into Terraform

> **📖 [Back to Task](./REAL-WORLD-TASKS.md#task-69-import-existing-aws-resources-into-terraform)**

### Solution Overview

This solution demonstrates how to import existing AWS infrastructure into Terraform management without disrupting services.

### Complete Solution

#### Step 1: Identify Resources to Import

```bash
# List existing VPCs
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,Tags[?Key==`Name`].Value|[0],CidrBlock]' --output table

# List existing subnets
aws ec2 describe-subnets --query 'Subnets[*].[SubnetId,VpcId,CidrBlock,AvailabilityZone]' --output table

# List existing security groups
aws ec2 describe-security-groups --query 'SecurityGroups[*].[GroupId,GroupName,VpcId]' --output table

# List existing EC2 instances
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,Tags[?Key==`Name`].Value|[0]]' --output table

# List existing RDS instances
aws rds describe-db-instances --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,DBInstanceStatus]' --output table

# List existing S3 buckets
aws s3api list-buckets --query 'Buckets[*].[Name,CreationDate]' --output table

# List existing IAM roles
aws iam list-roles --query 'Roles[*].[RoleName,Arn]' --output table
```

#### Step 2: Create Terraform Configuration for Existing Resources

```hcl
# import-vpc.tf
# First, create the resource block WITHOUT any attributes

resource "aws_vpc" "existing" {
  # Leave empty initially - will be populated after import
}

resource "aws_subnet" "public_1a" {
  # Leave empty initially
}

resource "aws_subnet" "public_1b" {
  # Leave empty initially
}

resource "aws_subnet" "private_1a" {
  # Leave empty initially
}

resource "aws_subnet" "private_1b" {
  # Leave empty initially
}

resource "aws_security_group" "web" {
  # Leave empty initially
}

resource "aws_security_group" "database" {
  # Leave empty initially
}

resource "aws_instance" "web_server" {
  # Leave empty initially
}

resource "aws_db_instance" "main" {
  # Leave empty initially
}

resource "aws_s3_bucket" "app_data" {
  # Leave empty initially
}
```

#### Step 3: Import Resources Using terraform import

```bash
# Import VPC
terraform import aws_vpc.existing vpc-0123456789abcdef0

# Import Subnets
terraform import aws_subnet.public_1a subnet-0123456789abcdef0
terraform import aws_subnet.public_1b subnet-0123456789abcdef1
terraform import aws_subnet.private_1a subnet-0123456789abcdef2
terraform import aws_subnet.private_1b subnet-0123456789abcdef3

# Import Security Groups
terraform import aws_security_group.web sg-0123456789abcdef0
terraform import aws_security_group.database sg-0123456789abcdef1

# Import EC2 Instance
terraform import aws_instance.web_server i-0123456789abcdef0

# Import RDS Instance
terraform import aws_db_instance.main mydb-instance

# Import S3 Bucket
terraform import aws_s3_bucket.app_data my-app-data-bucket
```

#### Step 4: Generate Configuration from State

```bash
# After importing, show the state to see what was imported
terraform state show aws_vpc.existing
terraform state show aws_subnet.public_1a
terraform state show aws_security_group.web

# Use terraform show to generate configuration
terraform show -no-color > imported-resources.tf.txt

# Or use terraform-docs or similar tools to generate config
```

#### Step 5: Complete Resource Configurations

```hcl
# vpc.tf - Complete configuration based on imported state
resource "aws_vpc" "existing" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "production-vpc"
    Environment = "prod"
    ManagedBy   = "Terraform"
    ImportedOn  = "2024-01-15"
  }
}

# Subnets
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.existing.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1a"
    Type = "public"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.existing.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1b"
    Type = "public"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.existing.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1a"
    Type = "private"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id            = aws_vpc.existing.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-1b"
    Type = "private"
  }
}

# Security Groups
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.existing.id

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

  tags = {
    Name = "web-security-group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "database" {
  name        = "database-sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.existing.id

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

  tags = {
    Name = "database-security-group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.medium"
  
  subnet_id              = aws_subnet.public_1a.id
  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "web-server"
  }

  lifecycle {
    ignore_changes = [ami]  # Prevent recreation on AMI updates
  }
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier     = "mydb-instance"
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.medium"

  allocated_storage     = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = "appdb"
  username = "dbadmin"
  # Password should be retrieved from Secrets Manager, not hardcoded
  password = data.aws_secretsmanager_secret_version.db_password.secret_string

  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 30
  skip_final_snapshot     = false
  final_snapshot_identifier = "mydb-final-snapshot"

  lifecycle {
    ignore_changes = [password]  # Don't try to change password on every apply
  }

  tags = {
    Name = "production-database"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "app_data" {
  bucket = "my-app-data-bucket"

  tags = {
    Name = "app-data-bucket"
  }

  lifecycle {
    prevent_destroy = true  # Protect from accidental deletion
  }
}
```

#### Step 6: Import Script for Bulk Operations

```bash
#!/bin/bash
# import-resources.sh - Automated import script

set -e

echo "Starting resource import process..."

# Function to import with error handling
import_resource() {
    local resource_type=$1
    local resource_name=$2
    local resource_id=$3

    echo "Importing $resource_type.$resource_name (ID: $resource_id)..."
    
    if terraform import "$resource_type.$resource_name" "$resource_id"; then
        echo "✅ Successfully imported $resource_type.$resource_name"
    else
        echo "❌ Failed to import $resource_type.$resource_name"
        return 1
    fi
}

# Import VPC
import_resource "aws_vpc" "existing" "vpc-0123456789abcdef0"

# Import Subnets
SUBNETS=(
    "public_1a:subnet-0123456789abcdef0"
    "public_1b:subnet-0123456789abcdef1"
    "private_1a:subnet-0123456789abcdef2"
    "private_1b:subnet-0123456789abcdef3"
)

for subnet in "${SUBNETS[@]}"; do
    name="${subnet%%:*}"
    id="${subnet##*:}"
    import_resource "aws_subnet" "$name" "$id"
done

# Import Security Groups
import_resource "aws_security_group" "web" "sg-0123456789abcdef0"
import_resource "aws_security_group" "database" "sg-0123456789abcdef1"

# Import EC2 Instances
import_resource "aws_instance" "web_server" "i-0123456789abcdef0"

# Import RDS Instances
import_resource "aws_db_instance" "main" "mydb-instance"

# Import S3 Buckets
import_resource "aws_s3_bucket" "app_data" "my-app-data-bucket"

echo "✅ Import process completed!"

# Run terraform plan to verify
echo ""
echo "Running terraform plan to verify import..."
terraform plan

echo ""
echo "⚠️  Review the plan carefully before applying!"
echo "⚠️  Make sure no resources will be destroyed or recreated!"
```

#### Step 7: Using import Blocks (Terraform 1.5+)

```hcl
# import.tf - Modern approach using import blocks
import {
  to = aws_vpc.existing
  id = "vpc-0123456789abcdef0"
}

import {
  to = aws_subnet.public_1a
  id = "subnet-0123456789abcdef0"
}

import {
  to = aws_subnet.public_1b
  id = "subnet-0123456789abcdef1"
}

import {
  to = aws_subnet.private_1a
  id = "subnet-0123456789abcdef2"
}

import {
  to = aws_subnet.private_1b
  id = "subnet-0123456789abcdef3"
}

import {
  to = aws_security_group.web
  id = "sg-0123456789abcdef0"
}

import {
  to = aws_security_group.database
  id = "sg-0123456789abcdef1"
}

import {
  to = aws_instance.web_server
  id = "i-0123456789abcdef0"
}

import {
  to = aws_db_instance.main
  id = "mydb-instance"
}

import {
  to = aws_s3_bucket.app_data
  id = "my-app-data-bucket"
}
```

With import blocks, you can now run:
```bash
terraform plan -generate-config-out=generated.tf
```

This will automatically generate the configuration for imported resources!

#### Step 8: Complex Import Scenarios

```hcl
# Importing resources with complex configurations

# Import NAT Gateway
import {
  to = aws_nat_gateway.main
  id = "nat-0123456789abcdef0"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "main-nat-gateway"
  }
}

# Import EIP associated with NAT Gateway
import {
  to = aws_eip.nat
  id = "eipalloc-0123456789abcdef0"
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# Import Route Table
import {
  to = aws_route_table.public
  id = "rtb-0123456789abcdef0"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.existing.id

  tags = {
    Name = "public-route-table"
  }
}

# Import Route Table Association
import {
  to = aws_route_table_association.public_1a
  id = "subnet-0123456789abcdef0/rtb-0123456789abcdef0"
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

# Import Internet Gateway
import {
  to = aws_internet_gateway.main
  id = "igw-0123456789abcdef0"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.existing.id

  tags = {
    Name = "main-igw"
  }
}

# Import ALB
import {
  to = aws_lb.main
  id = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/my-alb/1234567890abcdef"
}

resource "aws_lb" "main" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]

  tags = {
    Name = "main-alb"
  }
}

# Import Target Group
import {
  to = aws_lb_target_group.main
  id = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-tg/1234567890abcdef"
}

resource "aws_lb_target_group" "main" {
  name     = "my-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.existing.id

  health_check {
    enabled = true
    path    = "/health"
  }

  tags = {
    Name = "main-target-group"
  }
}

# Import Auto Scaling Group
import {
  to = aws_autoscaling_group.main
  id = "my-asg"
}

resource "aws_autoscaling_group" "main" {
  name                = "my-asg"
  vpc_zone_identifier = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
  target_group_arns   = [aws_lb_target_group.main.arn]

  min_size         = 2
  max_size         = 10
  desired_capacity = 4

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity]  # Let ASG manage this
  }
}

# Import IAM Role
import {
  to = aws_iam_role.ec2_role
  id = "MyEC2Role"
}

resource "aws_iam_role" "ec2_role" {
  name = "MyEC2Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "EC2 Instance Role"
  }
}

# Import IAM Policy Attachment
import {
  to = aws_iam_role_policy_attachment.ec2_s3_access
  id = "MyEC2Role/arn:aws:iam::123456789012:policy/MyS3AccessPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::123456789012:policy/MyS3AccessPolicy"
}
```

### Verification Steps

```bash
# 1. Verify all resources are imported
terraform state list

# 2. Check that plan shows no changes
terraform plan

# Expected output: "No changes. Your infrastructure matches the configuration."

# 3. Verify specific resources
terraform state show aws_vpc.existing
terraform state show aws_instance.web_server

# 4. Generate dependency graph
terraform graph | dot -Tpng > graph.png

# 5. Validate configuration
terraform validate

# 6. Test with a minor change (add a tag)
# Modify one resource to add a tag, then:
terraform plan
# Should show only the tag addition, nothing else

terraform apply
# Apply the change to verify Terraform has full control

# 7. Check for drift
terraform plan -refresh-only

# 8. Export current state for backup
terraform state pull > terraform.tfstate.backup
```

### Best Practices for Importing

1. **Start Small**: Import one resource at a time initially
2. **Backup State**: Always backup state before importing
3. **Use Import Blocks**: Use Terraform 1.5+ import blocks with `-generate-config-out`
4. **Document IDs**: Keep a mapping of resource names to AWS IDs
5. **Test First**: Test imports in a separate workspace first
6. **Verify Plan**: Always run `terraform plan` after import
7. **Lifecycle Rules**: Use `ignore_changes` for managed attributes
8. **Protect Resources**: Use `prevent_destroy` for critical resources
9. **Tag Everything**: Add tags to identify imported resources
10. **Gradual Migration**: Import incrementally, not everything at once

### Common Import Challenges

**Challenge 1: Circular Dependencies**
```hcl
# Solution: Import in correct order
# 1. VPC
# 2. Subnets
# 3. Security Groups (without rules initially)
# 4. Add security group rules referencing other groups
```

**Challenge 2: Missing Attributes**
```hcl
# Solution: Use lifecycle ignore_changes
lifecycle {
  ignore_changes = [
    ami,           # Let AWS manage AMI updates
    user_data,     # User data may be modified externally
    password,      # Don't manage passwords in Terraform
  ]
}
```

**Challenge 3: Complex Resources**
```bash
# Solution: Use terraform show to see exact configuration
terraform import aws_instance.web i-1234567890abcdef0
terraform show aws_instance.web

# Copy output and format as HCL
```

---

## Task 6.10: Implement Lifecycle Rules and Dependencies

> **📖 [Back to Task](./REAL-WORLD-TASKS.md#task-610-implement-lifecycle-rules-and-dependencies)**

### Solution Overview

This solution demonstrates proper use of lifecycle meta-arguments and explicit dependencies to manage resource creation, updates, and deletion order.

### Complete Solution

#### Step 1: create_before_destroy

```hcl
# lifecycle-cbd.tf - Create Before Destroy Examples

# Security Group with create_before_destroy
resource "aws_security_group" "web" {
  name_prefix = "${var.environment}-web-"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-web-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Launch Template with create_before_destroy
resource "aws_launch_template" "app" {
  name_prefix   = "${var.environment}-app-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    environment = var.environment
  }))

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp3"
      encrypted   = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-app-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group using Launch Template
resource "aws_autoscaling_group" "app" {
  name_prefix         = "${var.environment}-app-asg-"
  vpc_zone_identifier = var.private_subnet_ids

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app.arn]

  tag {
    key                 = "Name"
    value               = "${var.environment}-app-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]  # Let auto-scaling manage this
  }

  # Ensure new ASG is healthy before destroying old one
  wait_for_capacity_timeout = "10m"
}

# Blue-Green Deployment Pattern
resource "aws_lb_target_group" "blue" {
  name_prefix = "blue-"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled = true
    path    = "/health"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "green" {
  name_prefix = "green-"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled = true
    path    = "/health"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Certificate with create_before_destroy
resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.domain_name
  }
}
```

#### Step 2: prevent_destroy

```hcl
# lifecycle-prevent-destroy.tf

# Production Database - Protect from accidental deletion
resource "aws_db_instance" "production" {
  identifier     = "prod-database"
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_encrypted = true

  db_name  = "proddb"
  username = "dbadmin"
  password = random_password.db_password.result

  backup_retention_period = 30
  skip_final_snapshot     = false

  deletion_protection = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "production-database"
    Critical    = "true"
    Environment = "prod"
  }
}

# Critical S3 Bucket - Prevent accidental deletion
resource "aws_s3_bucket" "critical_data" {
  bucket = "company-critical-data-${var.account_id}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name     = "critical-data-bucket"
    Critical = "true"
    DataClassification = "confidential"
  }
}

# KMS Key for encryption - Protect from deletion
resource "aws_kms_key" "master" {
  description             = "Master encryption key"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "master-kms-key"
    Critical = "true"
  }
}

# DynamoDB Table with critical data
resource "aws_dynamodb_table" "user_data" {
  name           = "user-data"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "user-data-table"
    Critical = "true"
  }
}

# State Lock Table - Never delete
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "terraform-locks"
    Purpose = "terraform-state-locking"
  }
}

# Production Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = var.domain_name
    Critical = "true"
  }
}
```

#### Step 3: ignore_changes

```hcl
# lifecycle-ignore-changes.tf

# EC2 Instance - Ignore specific attributes
resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  # These might be modified by auto-scaling or external tools
  lifecycle {
    ignore_changes = [
      ami,          # Don't recreate on AMI updates
      user_data,    # User data might be updated externally
      tags["LastModified"],  # Ignore timestamp tags
    ]
  }

  tags = {
    Name         = "app-server"
    LastModified = timestamp()
  }
}

# Auto Scaling Group - Ignore capacity changes
resource "aws_autoscaling_group" "app" {
  name                = "app-asg"
  vpc_zone_identifier = var.subnet_ids

  min_size         = 2
  max_size         = 10
  desired_capacity = 4

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [
      desired_capacity,  # Let ASG policies manage this
      target_group_arns, # Might be managed by deployment tools
    ]
  }
}

# Lambda Function - Ignore code changes if deployed externally
resource "aws_lambda_function" "api" {
  filename      = "function.zip"
  function_name = "api-function"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  lifecycle {
    ignore_changes = [
      filename,         # Code deployed via CI/CD
      source_code_hash, # Don't track code changes in Terraform
      last_modified,
    ]
  }
}

# ECS Service - Ignore task definition changes
resource "aws_ecs_service" "app" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 3

  lifecycle {
    ignore_changes = [
      task_definition,  # Deployed via CI/CD
      desired_count,    # Managed by auto-scaling
    ]
  }
}

# Security Group - Ignore externally managed rules
resource "aws_security_group" "managed_externally" {
  name        = "externally-managed-sg"
  description = "Security group managed by external tools"
  vpc_id      = aws_vpc.main.id

  # Only manage the base configuration
  # Rules might be added/removed externally

  lifecycle {
    ignore_changes = [
      ingress,
      egress,
    ]
  }

  tags = {
    Name = "externally-managed-sg"
    ManagedBy = "External-Tool"
  }
}

# RDS Instance - Ignore maintenance window changes
resource "aws_db_instance" "app" {
  identifier     = "app-db"
  engine         = "postgres"
  instance_class = "db.t3.medium"

  allocated_storage = 100

  username = "dbadmin"
  password = random_password.db_password.result

  lifecycle {
    ignore_changes = [
      latest_restorable_time,  # Constantly changing
      password,                # Managed in Secrets Manager
      maintenance_window,      # Might be adjusted by AWS
    ]
  }
}

# EKS Node Group - Ignore scaling changes
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "main-node-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 3
    max_size     = 10
    min_size     = 1
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size,  # Managed by cluster autoscaler
    ]
  }
}
```

#### Step 4: replace_triggered_by

```hcl
# lifecycle-replace-triggered-by.tf (Terraform 1.2+)

# Replace instances when launch template changes
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  user_data = templatefile("${path.module}/user-data.sh", {
    config_version = var.config_version
  })

  lifecycle {
    replace_triggered_by = [
      aws_launch_template.app.id,
      null_resource.config_change.id
    ]
  }
}

# Config change trigger
resource "null_resource" "config_change" {
  triggers = {
    config_hash = filemd5("${path.module}/config/app.conf")
  }
}

# Replace Lambda when code changes
resource "aws_lambda_function" "api" {
  filename      = "function.zip"
  function_name = "api-function"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  source_code_hash = filebase64sha256("function.zip")

  lifecycle {
    replace_triggered_by = [
      null_resource.deploy_trigger.id
    ]
  }
}

resource "null_resource" "deploy_trigger" {
  triggers = {
    code_hash = filebase64sha256("function.zip")
  }
}

# Replace ECS tasks when task definition changes
resource "aws_ecs_service" "app" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 3

  lifecycle {
    replace_triggered_by = [
      aws_ecs_task_definition.app.id
    ]
  }
}
```

#### Step 5: Explicit Dependencies with depends_on

```hcl
# dependencies.tf

# IAM Role must exist before Instance Profile
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name

  # Explicit dependency to ensure role exists first
  depends_on = [
    aws_iam_role_policy_attachment.ec2_s3_access
  ]
}

# Attach policies before using the role
resource "aws_iam_role_policy_attachment" "ec2_s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# EC2 Instance depends on IAM profile
resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.medium"
  
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Ensure IAM profile is ready before creating instance
  depends_on = [
    aws_iam_instance_profile.ec2_profile
  ]
}

# RDS depends on KMS key and subnet group
resource "aws_db_instance" "main" {
  identifier     = "main-db"
  engine         = "postgres"
  instance_class = "db.t3.medium"

  kms_key_id           = aws_kms_key.rds.arn
  db_subnet_group_name = aws_db_subnet_group.main.name

  # Explicit dependencies
  depends_on = [
    aws_kms_key.rds,
    aws_db_subnet_group.main,
    aws_security_group.database
  ]
}

# VPC Endpoint depends on route table
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = [
    aws_route_table.private.id
  ]

  depends_on = [
    aws_route_table.private,
    aws_route_table_association.private
  ]
}

# Lambda needs IAM role and VPC configuration
resource "aws_lambda_function" "processor" {
  filename      = "function.zip"
  function_name = "processor"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }

  # Ensure all prerequisites are ready
  depends_on = [
    aws_iam_role_policy_attachment.lambda_vpc_access,
    aws_cloudwatch_log_group.lambda
  ]
}

# CloudWatch log group should exist before Lambda
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/processor"
  retention_in_days = 14
}

# ALB Listener depends on certificate validation
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  # Wait for certificate validation
  depends_on = [
    aws_acm_certificate_validation.main
  ]
}

# Route53 record for certificate validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  depends_on = [
    aws_route53_record.cert_validation
  ]
}

# EKS Cluster Add-ons depend on cluster
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"

  # CoreDNS needs nodes to be ready
  depends_on = [
    aws_eks_node_group.main
  ]
}

# API Gateway deployment depends on all resources
resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  # Ensure all API resources are created
  depends_on = [
    aws_api_gateway_integration.get_users,
    aws_api_gateway_integration.post_users,
    aws_api_gateway_integration_response.get_users,
    aws_api_gateway_integration_response.post_users
  ]

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.users.id,
      aws_api_gateway_method.get_users.id,
      aws_api_gateway_method.post_users.id,
      aws_api_gateway_integration.get_users.id,
      aws_api_gateway_integration.post_users.id,
    ]))
  }
}
```

#### Step 6: Complex Dependency Chain Example

```hcl
# complex-dependencies.tf

# 1. VPC must exist first
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# 2. Subnets depend on VPC
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

# 3. Internet Gateway depends on VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# 4. EIP depends on IGW (implicit through domain = "vpc")
resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"

  depends_on = [aws_internet_gateway.main]
}

# 5. NAT Gateway depends on EIP and public subnet
resource "aws_nat_gateway" "main" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [aws_internet_gateway.main]
}

# 6. Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.main.id
}

# 7. Routes depend on gateways
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route" "private_nat" {
  count                  = 2
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

# 8. Route table associations depend on routes
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route.public_internet]
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id

  depends_on = [aws_route.private_nat]
}

# 9. Security groups
resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "app" {
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "database" {
  vpc_id = aws_vpc.main.id
}

# 10. Security group rules with inter-dependencies
resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "app_from_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.app.id

  depends_on = [aws_security_group.alb]
}

resource "aws_security_group_rule" "database_from_app" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
  security_group_id        = aws_security_group.database.id

  depends_on = [aws_security_group.app]
}

# 11. ALB depends on public subnets and security group
resource "aws_lb" "main" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  depends_on = [
    aws_internet_gateway.main,
    aws_route_table_association.public
  ]
}

# 12. Target group
resource "aws_lb_target_group" "app" {
  name     = "app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/health"
  }
}

# 13. ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  depends_on = [
    aws_lb.main,
    aws_lb_target_group.app
  ]
}

# 14. Database subnet group
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet"
  subnet_ids = aws_subnet.private[*].id

  depends_on = [aws_route_table_association.private]
}

# 15. RDS depends on subnet group and security group
resource "aws_db_instance" "main" {
  identifier     = "main-db"
  engine         = "postgres"
  instance_class = "db.t3.medium"

  allocated_storage = 20

  username = "dbadmin"
  password = random_password.db.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]

  skip_final_snapshot = true

  depends_on = [
    aws_db_subnet_group.main,
    aws_security_group_rule.database_from_app
  ]

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [password]
  }
}

# 16. Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "app-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.medium"

  vpc_security_group_ids = [aws_security_group.app.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.app.name
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_iam_instance_profile.app
  ]
}

# 17. Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name                = "app-asg"
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns   = [aws_lb_target_group.app.arn]

  min_size         = 2
  max_size         = 10
  desired_capacity = 4

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }

  depends_on = [
    aws_nat_gateway.main,
    aws_route_table_association.private,
    aws_db_instance.main,  # Wait for database to be ready
    aws_lb_listener.http   # Wait for ALB to be ready
  ]
}

resource "random_password" "db" {
  length  = 32
  special = true
}

resource "aws_iam_instance_profile" "app" {
  name = "app-profile"
  role = aws_iam_role.app.name
}

resource "aws_iam_role" "app" {
  name = "app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
```

### Verification Steps

```bash
# 1. Create dependency graph
terraform graph | dot -Tpng > dependencies.png

# 2. Validate lifecycles
terraform validate

# 3. Test create_before_destroy
# Make a change to security group name
terraform apply
# Verify new resource created before old one destroyed

# 4. Test prevent_destroy
# Try to destroy protected resource
terraform destroy -target=aws_db_instance.production
# Should fail with prevent_destroy error

# 5. Test ignore_changes
# Manually modify ignored attribute
aws ec2 modify-instance-attribute --instance-id i-xxx --user-data "new data"
terraform plan
# Should show no changes

# 6. Test depends_on
# Check creation order in logs
terraform apply -json | jq -r '.["@message"]'

# 7. Verify dependency chain
terraform state list | sort
```

### Best Practices Implemented

1. **create_before_destroy**: For resources that can't have downtime
2. **prevent_destroy**: For critical resources
3. **ignore_changes**: For externally managed attributes
4. **replace_triggered_by**: For forced replacements
5. **depends_on**: For explicit ordering
6. **Dependency Graph**: Visualize dependencies
7. **Lifecycle Combinations**: Use multiple lifecycle rules together
8. **Security**: Protect production resources
9. **Blue-Green**: Enable zero-downtime deployments
10. **Explicit Dependencies**: Clear dependency chains

---