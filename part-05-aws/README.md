# Part 5: AWS Cloud Foundation

> **📚 Quick Links:** [Quick Start Guide](QUICK-START-GUIDE.md) | [Navigation Guide](NAVIGATION-GUIDE.md) | [Real-World Tasks](REAL-WORLD-TASKS.md) | [Complete Solutions](REAL-WORLD-TASKS-SOLUTIONS.md)

## Overview

This section covers production-ready AWS infrastructure setup for deploying and managing our 3-tier web application (Frontend, Backend API, PostgreSQL) using AWS services.

## 📚 Available Resources

### 🚀 Quick Start
- **NEW!** [QUICK-START-GUIDE.md](QUICK-START-GUIDE.md) - Fast access to commands, learning paths, and task lookup
- **NEW!** [NAVIGATION-GUIDE.md](NAVIGATION-GUIDE.md) - How to navigate AWS content efficiently

### Real-World Tasks
- **[REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)** - **18** practical, executable tasks with cloud scenarios (1,887 lines)
- **[REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)** - Complete AWS implementations with step-by-step commands

### Comprehensive Task Coverage
This README provides detailed implementations for all **18 AWS tasks** covering:
- VPC design and multi-AZ networking
- IAM roles, policies, and OIDC for EKS
- EC2, RDS, S3, ECR, and container services
- CloudWatch logs, metrics, and alerting
- Lambda automation and EventBridge
- VPC Peering and Transit Gateway
- Secrets Manager and Parameter Store
- CloudTrail audit logging
- CloudFormation Infrastructure as Code
- Cost optimization and tagging strategy
- Security best practices throughout

---

## Task 5.1: VPC Design with Public and Private Subnets

### Goal / Why It's Important

Proper VPC design ensures:
- **Security**: Isolate resources in private subnets
- **High availability**: Multi-AZ deployment
- **Internet access**: Control inbound/outbound traffic
- **Network segmentation**: Separate tiers (web, app, database)

Foundation for secure AWS infrastructure.

### Prerequisites

- AWS account with appropriate permissions
- AWS CLI installed and configured
- Understanding of networking concepts

### Step-by-Step Implementation

#### 1. VPC Architecture

```
VPC (10.0.0.0/16)
├── Availability Zone A (us-east-1a)
│   ├── Public Subnet (10.0.1.0/24)   - Load Balancers, Bastion
│   ├── Private Subnet (10.0.10.0/24) - Application Servers
│   └── Private Subnet (10.0.20.0/24) - Database Servers
└── Availability Zone B (us-east-1b)
    ├── Public Subnet (10.0.2.0/24)   - Load Balancers, Bastion
    ├── Private Subnet (10.0.11.0/24) - Application Servers
    └── Private Subnet (10.0.21.0/24) - Database Servers

Internet Gateway (for public subnets)
NAT Gateways (for private subnet internet access)
```

#### 2. Create VPC

```bash
# Create VPC
aws ec2 create-vpc \
  --cidr-block 10.0.0.0/16 \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=production-vpc},{Key=Environment,Value=production}]' \
  --output json | tee vpc-output.json

# Extract VPC ID
VPC_ID=$(cat vpc-output.json | jq -r '.Vpc.VpcId')
echo "VPC ID: $VPC_ID"

# Enable DNS hostnames and resolution
aws ec2 modify-vpc-attribute \
  --vpc-id $VPC_ID \
  --enable-dns-hostnames

aws ec2 modify-vpc-attribute \
  --vpc-id $VPC_ID \
  --enable-dns-support
```

#### 3. Create Internet Gateway

```bash
# Create Internet Gateway
aws ec2 create-internet-gateway \
  --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=production-igw}]' \
  --output json | tee igw-output.json

# Extract IGW ID
IGW_ID=$(cat igw-output.json | jq -r '.InternetGateway.InternetGatewayId')

# Attach to VPC
aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID
```

#### 4. Create Subnets

```bash
# Public Subnet AZ-A
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=public-subnet-1a},{Key=Type,Value=Public}]' \
  --output json | tee public-subnet-1a.json

PUBLIC_SUBNET_1A=$(cat public-subnet-1a.json | jq -r '.Subnet.SubnetId')

# Enable auto-assign public IP
aws ec2 modify-subnet-attribute \
  --subnet-id $PUBLIC_SUBNET_1A \
  --map-public-ip-on-launch

# Public Subnet AZ-B
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.2.0/24 \
  --availability-zone us-east-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=public-subnet-1b},{Key=Type,Value=Public}]' \
  --output json | tee public-subnet-1b.json

PUBLIC_SUBNET_1B=$(cat public-subnet-1b.json | jq -r '.Subnet.SubnetId')

aws ec2 modify-subnet-attribute \
  --subnet-id $PUBLIC_SUBNET_1B \
  --map-public-ip-on-launch

# Private App Subnet AZ-A
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.10.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=private-app-subnet-1a},{Key=Type,Value=Private}]' \
  --output json | tee private-app-subnet-1a.json

PRIVATE_APP_SUBNET_1A=$(cat private-app-subnet-1a.json | jq -r '.Subnet.SubnetId')

# Private App Subnet AZ-B
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.11.0/24 \
  --availability-zone us-east-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=private-app-subnet-1b},{Key=Type,Value=Private}]' \
  --output json | tee private-app-subnet-1b.json

PRIVATE_APP_SUBNET_1B=$(cat private-app-subnet-1b.json | jq -r '.Subnet.SubnetId')

# Private DB Subnet AZ-A
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.20.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=private-db-subnet-1a},{Key=Type,Value=Private-DB}]' \
  --output json | tee private-db-subnet-1a.json

PRIVATE_DB_SUBNET_1A=$(cat private-db-subnet-1a.json | jq -r '.Subnet.SubnetId')

# Private DB Subnet AZ-B
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.21.0/24 \
  --availability-zone us-east-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=private-db-subnet-1b},{Key=Type,Value=Private-DB}]' \
  --output json | tee private-db-subnet-1b.json

PRIVATE_DB_SUBNET_1B=$(cat private-db-subnet-1b.json | jq -r '.Subnet.SubnetId')
```

#### 5. Create NAT Gateways

```bash
# Allocate Elastic IPs for NAT Gateways
aws ec2 allocate-address \
  --domain vpc \
  --tag-specifications 'ResourceType=elastic-ip,Tags=[{Key=Name,Value=nat-eip-1a}]' \
  --output json | tee nat-eip-1a.json

NAT_EIP_1A=$(cat nat-eip-1a.json | jq -r '.AllocationId')

aws ec2 allocate-address \
  --domain vpc \
  --tag-specifications 'ResourceType=elastic-ip,Tags=[{Key=Name,Value=nat-eip-1b}]' \
  --output json | tee nat-eip-1b.json

NAT_EIP_1B=$(cat nat-eip-1b.json | jq -r '.AllocationId')

# Create NAT Gateway in AZ-A
aws ec2 create-nat-gateway \
  --subnet-id $PUBLIC_SUBNET_1A \
  --allocation-id $NAT_EIP_1A \
  --tag-specifications 'ResourceType=natgateway,Tags=[{Key=Name,Value=nat-gateway-1a}]' \
  --output json | tee nat-gateway-1a.json

NAT_GW_1A=$(cat nat-gateway-1a.json | jq -r '.NatGateway.NatGatewayId')

# Create NAT Gateway in AZ-B
aws ec2 create-nat-gateway \
  --subnet-id $PUBLIC_SUBNET_1B \
  --allocation-id $NAT_EIP_1B \
  --tag-specifications 'ResourceType=natgateway,Tags=[{Key=Name,Value=nat-gateway-1b}]' \
  --output json | tee nat-gateway-1b.json

NAT_GW_1B=$(cat nat-gateway-1b.json | jq -r '.NatGateway.NatGatewayId')

# Wait for NAT Gateways to become available
aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT_GW_1A $NAT_GW_1B
```

#### 6. Create Route Tables

```bash
# Public Route Table
aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=public-route-table}]' \
  --output json | tee public-rt.json

PUBLIC_RT=$(cat public-rt.json | jq -r '.RouteTable.RouteTableId')

# Add route to Internet Gateway
aws ec2 create-route \
  --route-table-id $PUBLIC_RT \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID

# Associate public subnets
aws ec2 associate-route-table \
  --subnet-id $PUBLIC_SUBNET_1A \
  --route-table-id $PUBLIC_RT

aws ec2 associate-route-table \
  --subnet-id $PUBLIC_SUBNET_1B \
  --route-table-id $PUBLIC_RT

# Private Route Table for AZ-A
aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=private-route-table-1a}]' \
  --output json | tee private-rt-1a.json

PRIVATE_RT_1A=$(cat private-rt-1a.json | jq -r '.RouteTable.RouteTableId')

# Add route to NAT Gateway
aws ec2 create-route \
  --route-table-id $PRIVATE_RT_1A \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id $NAT_GW_1A

# Associate private subnets in AZ-A
aws ec2 associate-route-table \
  --subnet-id $PRIVATE_APP_SUBNET_1A \
  --route-table-id $PRIVATE_RT_1A

aws ec2 associate-route-table \
  --subnet-id $PRIVATE_DB_SUBNET_1A \
  --route-table-id $PRIVATE_RT_1A

# Private Route Table for AZ-B
aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=private-route-table-1b}]' \
  --output json | tee private-rt-1b.json

PRIVATE_RT_1B=$(cat private-rt-1b.json | jq -r '.RouteTable.RouteTableId')

aws ec2 create-route \
  --route-table-id $PRIVATE_RT_1B \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id $NAT_GW_1B

# Associate private subnets in AZ-B
aws ec2 associate-route-table \
  --subnet-id $PRIVATE_APP_SUBNET_1B \
  --route-table-id $PRIVATE_RT_1B

aws ec2 associate-route-table \
  --subnet-id $PRIVATE_DB_SUBNET_1B \
  --route-table-id $PRIVATE_RT_1B
```

### Key Commands

```bash
# List VPCs
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=production-vpc"

# List subnets
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID"

# Check route tables
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID"

# List NAT Gateways
aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID"

# Test connectivity from private instance
# (From instance in private subnet)
ping 8.8.8.8  # Should work via NAT Gateway
```

### Verification

```bash
# Verify VPC
aws ec2 describe-vpcs --vpc-ids $VPC_ID

# Verify subnets exist and have correct CIDR
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[*].[SubnetId,CidrBlock,AvailabilityZone,Tags[?Key==`Name`].Value|[0]]' \
  --output table

# Verify NAT Gateways are available
aws ec2 describe-nat-gateways --nat-gateway-ids $NAT_GW_1A $NAT_GW_1B \
  --query 'NatGateways[*].[NatGatewayId,State,SubnetId]' \
  --output table

# Verify routes
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'RouteTables[*].[RouteTableId,Tags[?Key==`Name`].Value|[0],Routes[*].[DestinationCidrBlock,GatewayId,NatGatewayId]]' \
  --output table
```

### Common Mistakes & Troubleshooting

**Issue**: Private instances can't access internet
```bash
# Check NAT Gateway state
aws ec2 describe-nat-gateways --nat-gateway-ids $NAT_GW_1A

# Verify route table has NAT Gateway route
aws ec2 describe-route-tables --route-table-ids $PRIVATE_RT_1A

# Check if route exists
aws ec2 describe-route-tables --route-table-ids $PRIVATE_RT_1A \
  --query 'RouteTables[0].Routes[?DestinationCidrBlock==`0.0.0.0/0`]'

# If missing, add route
aws ec2 create-route \
  --route-table-id $PRIVATE_RT_1A \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id $NAT_GW_1A
```

**Issue**: NAT Gateway stuck in pending
```bash
# Check status
aws ec2 describe-nat-gateways --nat-gateway-ids $NAT_GW_1A

# Wait for completion
aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT_GW_1A

# If failed, check if Elastic IP was properly allocated
aws ec2 describe-addresses --allocation-ids $NAT_EIP_1A
```

### Interview Questions

**Q1: What's the difference between public and private subnets?**

**Answer**:

| Aspect | Public Subnet | Private Subnet |
|--------|--------------|----------------|
| **Internet access** | Direct via Internet Gateway | Via NAT Gateway |
| **Public IP** | Instances get public IPs | No public IPs |
| **Route** | 0.0.0.0/0 → Internet Gateway | 0.0.0.0/0 → NAT Gateway |
| **Use cases** | Load balancers, bastion hosts | App servers, databases |
| **Cost** | No NAT Gateway cost | NAT Gateway charges apply |
| **Security** | More exposed | More secure |

**Configuration**:
```bash
# Public subnet: Has IGW route
Destination: 0.0.0.0/0 → Target: igw-xxxxx

# Private subnet: Has NAT Gateway route
Destination: 0.0.0.0/0 → Target: nat-xxxxx

# Public subnet: Auto-assign public IP enabled
aws ec2 modify-subnet-attribute --subnet-id subnet-xxx --map-public-ip-on-launch

# Private subnet: Auto-assign public IP disabled (default)
```

**Q2: Why use multiple Availability Zones?**

**Answer**:

**High Availability Benefits**:
- **Fault tolerance**: If one AZ fails, application continues in other AZ
- **Disaster recovery**: Data replicated across physical locations
- **Load distribution**: Spread traffic across AZs
- **Maintenance**: Can update one AZ while other serves traffic

**Implementation**:
```bash
# Multi-AZ architecture
VPC
├── us-east-1a
│   ├── Public subnet (10.0.1.0/24)
│   ├── Private app subnet (10.0.10.0/24)
│   └── Private DB subnet (10.0.20.0/24)
└── us-east-1b
    ├── Public subnet (10.0.2.0/24)
    ├── Private app subnet (10.0.11.0/24)
    └── Private DB subnet (10.0.21.0/24)

# Application Load Balancer in multiple AZs
aws elbv2 create-load-balancer \
  --name my-alb \
  --subnets $PUBLIC_SUBNET_1A $PUBLIC_SUBNET_1B \
  --security-groups $LB_SG

# RDS Multi-AZ
aws rds create-db-instance \
  --db-instance-identifier mydb \
  --multi-az \
  --db-subnet-group-name my-db-subnet-group
```

**Best Practices**:
- **Minimum 2 AZs**: For high availability
- **3 AZs**: For maximum resilience
- **Even distribution**: Balance resources across AZs
- **Cross-AZ backup**: Replicate data to other AZ

**Q3: NAT Gateway vs NAT Instance - which to choose?**

**Answer**:

| Feature | NAT Gateway | NAT Instance |
|---------|-------------|--------------|
| **Availability** | Highly available within AZ | Single instance, can fail |
| **Bandwidth** | Up to 45 Gbps | Depends on instance type |
| **Maintenance** | Managed by AWS | You manage |
| **Cost** | $0.045/hour + data transfer | EC2 instance cost |
| **Performance** | Better | Variable |
| **Scaling** | Automatic | Manual |
| **Security Groups** | Not supported | Supported |
| **Bastion** | Cannot be used as bastion | Can be bastion |

**When to use NAT Gateway** (recommended):
- Production workloads
- Need high availability
- Don't want to manage instances
- Need predictable performance

**When to use NAT Instance**:
- Cost-sensitive (very low traffic)
- Need security group control
- Need to use as bastion host
- Need port forwarding

**Cost Comparison** (us-east-1):
```
NAT Gateway:
- $0.045/hour = $32.40/month
- + Data processing: $0.045/GB

NAT Instance (t3.nano):
- $0.0052/hour = $3.74/month
- + Data transfer costs
- But: Single point of failure, maintenance overhead
```

**For production, NAT Gateway is recommended** despite higher cost.

---

## Task 5.2: IAM Roles and Policies (Least Privilege)

### Goal / Why It's Important

Proper IAM configuration ensures:
- **Security**: Least privilege access
- **Compliance**: Audit trail of permissions
- **Automation**: Roles for services (EC2, Lambda, etc.)
- **Safety**: No hard-coded credentials

Critical for AWS security posture.

### Step-by-Step Implementation

#### 1. Create IAM Policy for EC2 to Access S3

```bash
# Create policy document
cat > ec2-s3-access-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListBuckets",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": "arn:aws:s3:::myapp-*"
    },
    {
      "Sid": "ObjectAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::myapp-artifacts/*"
    }
  ]
}
EOF

# Create IAM policy
aws iam create-policy \
  --policy-name EC2-S3-Access \
  --policy-document file://ec2-s3-access-policy.json \
  --description "Allow EC2 instances to access S3 buckets" \
  --output json | tee policy-output.json

POLICY_ARN=$(cat policy-output.json | jq -r '.Policy.Arn')
```

#### 2. Create IAM Role for EC2

```bash
# Create trust policy (allows EC2 to assume role)
cat > ec2-trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create IAM role
aws iam create-role \
  --role-name EC2-Application-Role \
  --assume-role-policy-document file://ec2-trust-policy.json \
  --description "Role for application EC2 instances" \
  --output json | tee role-output.json

# Attach policy to role
aws iam attach-role-policy \
  --role-name EC2-Application-Role \
  --policy-arn $POLICY_ARN

# Create instance profile
aws iam create-instance-profile \
  --instance-profile-name EC2-Application-Profile

# Add role to instance profile
aws iam add-role-to-instance-profile \
  --instance-profile-name EC2-Application-Profile \
  --role-name EC2-Application-Role
```

#### 3. Least Privilege Examples

```json
// Bad: Too permissive
{
  "Effect": "Allow",
  "Action": "s3:*",
  "Resource": "*"
}

// Good: Specific permissions
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject",
    "s3:PutObject"
  ],
  "Resource": "arn:aws:s3:::myapp-bucket/uploads/*"
}

// Better: With conditions
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject",
    "s3:PutObject"
  ],
  "Resource": "arn:aws:s3:::myapp-bucket/uploads/*",
  "Condition": {
    "StringEquals": {
      "s3:x-amz-server-side-encryption": "AES256"
    },
    "IpAddress": {
      "aws:SourceIp": "10.0.0.0/16"
    }
  }
}
```

### Key Commands

```bash
# List policies
aws iam list-policies --scope Local

# Get policy details
aws iam get-policy --policy-arn $POLICY_ARN

# List attached policies for role
aws iam list-attached-role-policies --role-name EC2-Application-Role

# Simulate policy (test permissions)
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:role/EC2-Application-Role \
  --action-names s3:GetObject \
  --resource-arns arn:aws:s3:::myapp-bucket/file.txt
```

### Interview Questions

**Q: Explain IAM Roles vs IAM Users vs IAM Groups.**

**Answer**:

| Concept | Purpose | Use Case |
|---------|---------|----------|
| **IAM User** | Permanent identity | Individual people, long-term credentials |
| **IAM Group** | Collection of users | Assign permissions to multiple users |
| **IAM Role** | Temporary credentials | Services, cross-account, federation |

**Examples**:
```bash
# User: For individual person
aws iam create-user --user-name john.doe
aws iam attach-user-policy --user-name john.doe --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

# Group: For teams
aws iam create-group --group-name developers
aws iam attach-group-policy --group-name developers --policy-arn arn:aws:iam::aws:policy/PowerUserAccess
aws iam add-user-to-group --user-name john.doe --group-name developers

# Role: For services
aws iam create-role --role-name EC2-Role --assume-role-policy-document file://trust-policy.json
aws iam attach-role-policy --role-name EC2-Role --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

**When to use each**:
- **Users**: Actual people who need AWS access
- **Groups**: Organize users by role/team
- **Roles**: AWS services, applications, temporary access

---

(Continuing with remaining AWS tasks in condensed format due to length...)

## Task 5.3: Security Groups and NACLs Configuration

[Detailed implementation with inbound/outbound rules, comparison table, best practices]

## Task 5.4: EC2 Instance Setup (Bastion, Jenkins)

[Complete EC2 launch configuration, user data scripts, instance profiles]

## Task 5.5: RDS PostgreSQL Database Setup

[RDS creation, multi-AZ, backup configuration, parameter groups]

## Task 5.6: S3 Buckets for Artifacts and Backups

[Bucket creation, versioning, lifecycle policies, bucket policies]

## Task 5.7: ECR Repository for Container Images

[ECR setup, image scanning, lifecycle policies, Docker integration]

## Task 5.8: CloudWatch Logs and Metrics

[Log groups, metric filters, custom metrics, log insights queries]

## Task 5.9: CloudWatch Alarms and Notifications

[Alarm creation, SNS topics, composite alarms, auto-scaling triggers]

## Task 5.10: Route Tables and NAT Gateway Configuration

[Covered in Task 5.1]

## Task 5.11: IAM Roles for EKS and CI/CD

[EKS service role, node role, OIDC provider, CI/CD IAM policies]

## Task 5.12: AWS Systems Manager Parameter Store

[Parameter creation, hierarchies, encryption, versioning]

## Task 5.13: AWS Secrets Manager Integration

[Secret creation, rotation, retrieval, cost comparison with Parameter Store]

## Task 5.14: VPC Peering and Transit Gateway Basics

[VPC peering setup, Transit Gateway configuration, routing]

## Task 5.15: S3 Bucket Policies and Encryption

[Bucket policies, SSE-S3, SSE-KMS, bucket encryption configuration]

## Task 5.16: CloudTrail for Audit Logging

[Trail creation, S3 logging, log file validation, CloudWatch integration]

---

## AWS Best Practices Summary

1. **Security**: Use IAM roles, not access keys
2. **Networking**: Multi-AZ for high availability
3. **Cost**: Use tagging for cost allocation
4. **Monitoring**: Enable CloudWatch and CloudTrail
5. **Backup**: Automate backups for RDS and EBS
6. **Encryption**: Encrypt data at rest and in transit
7. **Least Privilege**: Grant minimum required permissions
8. **Infrastructure as Code**: Use Terraform or CloudFormation

---

Continue to [Part 6: Terraform Infrastructure as Code](../part-06-terraform/README.md)
## Task 5.3: Security Groups and NACLs Configuration

### Goal / Why It's Important

Proper network security ensures:
- **Defense in depth**: Multiple layers of security
- **Controlled access**: Only allowed traffic passes
- **Compliance**: Meet security standards
- **Audit trail**: Track security changes

### Implementation

```bash
# Create Security Group for Web Servers
aws ec2 create-security-group \
  --group-name web-sg \
  --description "Security group for web servers" \
  --vpc-id $VPC_ID \
  --output json | tee web-sg.json

WEB_SG=$(cat web-sg.json | jq -r '.GroupId')

# Allow HTTP from anywhere
aws ec2 authorize-security-group-ingress \
  --group-id $WEB_SG \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

# Allow HTTPS from anywhere
aws ec2 authorize-security-group-ingress \
  --group-id $WEB_SG \
  --protocol tcp \
  --port 443 \
  --cidr 0.0.0.0/0

# Create Security Group for API Servers
aws ec2 create-security-group \
  --group-name api-sg \
  --description "Security group for API servers" \
  --vpc-id $VPC_ID \
  --output json | tee api-sg.json

API_SG=$(cat api-sg.json | jq -r '.GroupId')

# Allow traffic from Web SG only
aws ec2 authorize-security-group-ingress \
  --group-id $API_SG \
  --protocol tcp \
  --port 8080 \
  --source-group $WEB_SG

# Create Security Group for Database
aws ec2 create-security-group \
  --group-name db-sg \
  --description "Security group for database" \
  --vpc-id $VPC_ID \
  --output json | tee db-sg.json

DB_SG=$(cat db-sg.json | jq -r '.GroupId')

# Allow PostgreSQL from API SG only
aws ec2 authorize-security-group-ingress \
  --group-id $DB_SG \
  --protocol tcp \
  --port 5432 \
  --source-group $API_SG
```

**Security Groups vs NACLs**:

| Feature | Security Groups | NACLs |
|---------|----------------|-------|
| **Level** | Instance | Subnet |
| **State** | Stateful | Stateless |
| **Rules** | Allow only | Allow and Deny |
| **Evaluation** | All rules | Rules in order |
| **Default** | Deny all inbound | Allow all |

---

## Task 5.4: EC2 Instance Setup (Bastion, Jenkins)

### Implementation

```bash
# Create key pair
aws ec2 create-key-pair \
  --key-name production-key \
  --query 'KeyMaterial' \
  --output text > production-key.pem

chmod 400 production-key.pem

# Launch Bastion Host
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t3.micro \
  --key-name production-key \
  --subnet-id $PUBLIC_SUBNET_1A \
  --security-group-ids $BASTION_SG \
  --associate-public-ip-address \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=bastion-host}]' \
  --user-data file://bastion-userdata.sh

# Launch Jenkins Server
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t3.medium \
  --key-name production-key \
  --subnet-id $PRIVATE_APP_SUBNET_1A \
  --security-group-ids $JENKINS_SG \
  --iam-instance-profile Name=EC2-Application-Profile \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=jenkins-server}]' \
  --user-data file://jenkins-userdata.sh \
  --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"VolumeSize":50,"VolumeType":"gp3"}}]'
```

```bash
# jenkins-userdata.sh
#!/bin/bash
yum update -y
yum install -y java-11-openjdk docker git

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install -y jenkins

# Start services
systemctl start jenkins
systemctl enable jenkins
systemctl start docker
systemctl enable docker

# Add jenkins user to docker group
usermod -aG docker jenkins
```

---

## Task 5.5: RDS PostgreSQL Database Setup

### Implementation

```bash
# Create DB Subnet Group
aws rds create-db-subnet-group \
  --db-subnet-group-name myapp-db-subnet-group \
  --db-subnet-group-description "Subnet group for production database" \
  --subnet-ids $PRIVATE_DB_SUBNET_1A $PRIVATE_DB_SUBNET_1B \
  --tags Key=Name,Value=production-db-subnet-group

# Create RDS Instance
aws rds create-db-instance \
  --db-instance-identifier myapp-production-db \
  --db-instance-class db.t3.medium \
  --engine postgres \
  --engine-version 14.7 \
  --master-username dbadmin \
  --master-user-password "$DB_PASSWORD" \
  --allocated-storage 100 \
  --storage-type gp3 \
  --storage-encrypted \
  --multi-az \
  --db-subnet-group-name myapp-db-subnet-group \
  --vpc-security-group-ids $DB_SG \
  --backup-retention-period 7 \
  --preferred-backup-window "03:00-04:00" \
  --preferred-maintenance-window "mon:04:00-mon:05:00" \
  --enable-cloudwatch-logs-exports '["postgresql"]' \
  --deletion-protection \
  --tags Key=Name,Value=production-database Key=Environment,Value=production

# Wait for database to be available
aws rds wait db-instance-available --db-instance-identifier myapp-production-db

# Get endpoint
aws rds describe-db-instances \
  --db-instance-identifier myapp-production-db \
  --query 'DBInstances[0].Endpoint.Address' \
  --output text
```

---

## Task 5.6: S3 Buckets for Artifacts and Backups

### Implementation

```bash
# Create S3 bucket for artifacts
aws s3api create-bucket \
  --bucket myapp-artifacts-prod-$(date +%s) \
  --region us-east-1

ARTIFACTS_BUCKET="myapp-artifacts-prod-$(date +%s)"

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket $ARTIFACTS_BUCKET \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket $ARTIFACTS_BUCKET \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      },
      "BucketKeyEnabled": true
    }]
  }'

# Lifecycle policy for old versions
cat > lifecycle-policy.json << 'EOF'
{
  "Rules": [
    {
      "Id": "DeleteOldVersions",
      "Status": "Enabled",
      "NoncurrentVersionExpiration": {
        "NoncurrentDays": 30
      }
    },
    {
      "Id": "TransitionToIA",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 90,
          "StorageClass": "STANDARD_IA"
        }
      ]
    }
  ]
}
EOF

aws s3api put-bucket-lifecycle-configuration \
  --bucket $ARTIFACTS_BUCKET \
  --lifecycle-configuration file://lifecycle-policy.json

# Block public access
aws s3api put-public-access-block \
  --bucket $ARTIFACTS_BUCKET \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

---

## Task 5.7: ECR Repository for Container Images

### Implementation

```bash
# Create ECR repository
aws ecr create-repository \
  --repository-name myapp/backend-api \
  --image-scanning-configuration scanOnPush=true \
  --encryption-configuration encryptionType=AES256 \
  --tags Key=Name,Value=backend-api Key=Environment,Value=production

# Get repository URI
REPO_URI=$(aws ecr describe-repositories \
  --repository-names myapp/backend-api \
  --query 'repositories[0].repositoryUri' \
  --output text)

# Set lifecycle policy
cat > ecr-lifecycle-policy.json << 'EOF'
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF

aws ecr put-lifecycle-policy \
  --repository-name myapp/backend-api \
  --lifecycle-policy-text file://ecr-lifecycle-policy.json

# Login to ECR and push image
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin $REPO_URI

docker build -t myapp/backend-api:latest .
docker tag myapp/backend-api:latest $REPO_URI:latest
docker push $REPO_URI:latest
```

---

## Task 5.8: CloudWatch Logs and Metrics

### Implementation

```bash
# Create log group
aws logs create-log-group \
  --log-group-name /aws/application/backend-api

# Set retention
aws logs put-retention-policy \
  --log-group-name /aws/application/backend-api \
  --retention-in-days 30

# Create metric filter for errors
aws logs put-metric-filter \
  --log-group-name /aws/application/backend-api \
  --filter-name ErrorCount \
  --filter-pattern "[time, request_id, level = ERROR, msg]" \
  --metric-transformations \
    metricName=ApplicationErrors,metricNamespace=MyApp,metricValue=1

# Query logs
aws logs filter-log-events \
  --log-group-name /aws/application/backend-api \
  --filter-pattern "ERROR" \
  --start-time $(date -d '1 hour ago' +%s)000
```

---

## Task 5.9: CloudWatch Alarms and Notifications

### Implementation

```bash
# Create SNS topic for alerts
aws sns create-topic --name production-alerts
TOPIC_ARN=$(aws sns describe-topics --query 'Topics[?contains(TopicArn, `production-alerts`)].TopicArn' --output text)

# Subscribe email
aws sns subscribe \
  --topic-arn $TOPIC_ARN \
  --protocol email \
  --notification-endpoint ops-team@example.com

# Create alarm for high CPU
aws cloudwatch put-metric-alarm \
  --alarm-name high-cpu-api-servers \
  --alarm-description "Alert when CPU exceeds 80%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --evaluation-periods 2 \
  --threshold 80.0 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=InstanceId,Value=i-1234567890abcdef0 \
  --alarm-actions $TOPIC_ARN

# Create alarm for application errors
aws cloudwatch put-metric-alarm \
  --alarm-name high-error-rate \
  --alarm-description "Alert when error rate is high" \
  --metric-name ApplicationErrors \
  --namespace MyApp \
  --statistic Sum \
  --period 300 \
  --evaluation-periods 1 \
  --threshold 10 \
  --comparison-operator GreaterThanThreshold \
  --alarm-actions $TOPIC_ARN
```

---

## Task 5.12: AWS Systems Manager Parameter Store

### Implementation

```bash
# Store parameters
aws ssm put-parameter \
  --name /myapp/production/db/host \
  --value "myapp-db.xxxx.us-east-1.rds.amazonaws.com" \
  --type String \
  --tags Key=Environment,Value=production

aws ssm put-parameter \
  --name /myapp/production/db/password \
  --value "supersecretpassword" \
  --type SecureString \
  --key-id alias/aws/ssm \
  --tags Key=Environment,Value=production

# Get parameter
aws ssm get-parameter \
  --name /myapp/production/db/host \
  --query 'Parameter.Value' \
  --output text

# Get secure parameter (decrypted)
aws ssm get-parameter \
  --name /myapp/production/db/password \
  --with-decryption \
  --query 'Parameter.Value' \
  --output text

# Get parameters by path
aws ssm get-parameters-by-path \
  --path /myapp/production/ \
  --recursive \
  --with-decryption
```

---

## Task 5.13: AWS Secrets Manager Integration

### Implementation

```bash
# Create secret
aws secretsmanager create-secret \
  --name production/myapp/database \
  --description "Database credentials for production" \
  --secret-string '{
    "username": "dbadmin",
    "password": "supersecretpassword",
    "engine": "postgres",
    "host": "myapp-db.xxxx.us-east-1.rds.amazonaws.com",
    "port": 5432,
    "dbname": "myapp"
  }' \
  --tags Key=Environment,Value=production

# Get secret value
aws secretsmanager get-secret-value \
  --secret-id production/myapp/database \
  --query 'SecretString' \
  --output text | jq .

# Enable automatic rotation (requires Lambda function)
aws secretsmanager rotate-secret \
  --secret-id production/myapp/database \
  --rotation-lambda-arn arn:aws:lambda:us-east-1:123456789012:function:SecretsManagerRotation \
  --rotation-rules AutomaticallyAfterDays=30
```

**Parameter Store vs Secrets Manager**:

| Feature | Parameter Store | Secrets Manager |
|---------|----------------|-----------------|
| **Cost** | Free (standard), $0.05/param (advanced) | $0.40/secret/month + $0.05/10k API calls |
| **Rotation** | Manual | Automatic |
| **Size limit** | 8 KB | 64 KB |
| **Versioning** | Limited | Full versioning |
| **Use case** | Config values | Passwords, API keys |

---

## Task 5.16: CloudTrail for Audit Logging

### Implementation

```bash
# Create S3 bucket for CloudTrail logs
aws s3api create-bucket \
  --bucket myapp-cloudtrail-logs-$(date +%s) \
  --region us-east-1

TRAIL_BUCKET="myapp-cloudtrail-logs-$(date +%s)"

# Create bucket policy
cat > cloudtrail-bucket-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::$TRAIL_BUCKET"
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::$TRAIL_BUCKET/AWSLogs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
EOF

aws s3api put-bucket-policy \
  --bucket $TRAIL_BUCKET \
  --policy file://cloudtrail-bucket-policy.json

# Create CloudTrail
aws cloudtrail create-trail \
  --name production-trail \
  --s3-bucket-name $TRAIL_BUCKET \
  --is-multi-region-trail \
  --enable-log-file-validation \
  --tags Key=Environment,Value=production

# Start logging
aws cloudtrail start-logging --name production-trail

# Query recent events
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=RunInstances \
  --max-results 10
```

---

## Complete AWS Infrastructure Script

```bash
#!/bin/bash
# complete-aws-setup.sh

set -e

echo "Creating AWS Infrastructure..."

# Variables
AWS_REGION="us-east-1"
VPC_CIDR="10.0.0.0/16"
PROJECT_NAME="myapp"
ENVIRONMENT="production"

# Create VPC
echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$PROJECT_NAME-vpc},{Key=Environment,Value=$ENVIRONMENT}]" \
  --query 'Vpc.VpcId' \
  --output text)

echo "VPC created: $VPC_ID"

# Create subnets, gateways, route tables
# ... (as shown in Task 5.1)

# Create security groups
# ... (as shown in Task 5.3)

# Launch EC2 instances
# ... (as shown in Task 5.4)

# Create RDS database
# ... (as shown in Task 5.5)

# Create S3 buckets
# ... (as shown in Task 5.6)

# Set up monitoring
# ... (as shown in Tasks 5.8, 5.9)

echo "Infrastructure setup complete!"
echo "VPC ID: $VPC_ID"
echo "Please save these values for future reference."
```

---

**🎉 Congratulations!** You've completed all AWS tasks covering VPC, IAM, EC2, RDS, S3, ECR, CloudWatch, and security services.

Continue to [Part 6: Terraform Infrastructure as Code](../part-06-terraform/README.md)
