# AWS Cloud Foundation Real-World Tasks for DevOps Engineers

> **📚 Navigation:** [Solutions →](./REAL-WORLD-TASKS-SOLUTIONS.md) | [Part 5 README](./README.md) | [Navigation Guide](./NAVIGATION-GUIDE.md) | [Quick Start](./QUICK-START-GUIDE.md)

## 🎯 Overview

This document provides **real-world, executable AWS tasks** that you can assign to DevOps engineers. Each task includes:
- **Clear scenario and context**
- **Time estimate for completion**
- **Step-by-step assignment instructions**
- **Validation checklist**
- **Expected deliverables**

These tasks are designed to be practical assignments that simulate actual production work on AWS.

> **💡 Looking for solutions?** Complete solutions with step-by-step AWS CLI commands and best practices are available in [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)

---

## How to Use This Guide

### For Managers/Team Leads:
1. Select a task based on the engineer's skill level
2. Provide the task description and time limit
3. Use the validation checklist to verify completion
4. Review the deliverables

### For DevOps Engineers:
1. Read the scenario carefully
2. Note the time estimate (plan accordingly)
3. Complete all steps in the task
4. Verify your work using the checklist
5. Submit the required deliverables

---

## 📑 Task Index

Quick navigation to tasks and their solutions:

| # | Task Name | Difficulty | Time | Solution Link |
|---|-----------|------------|------|---------------|
| 5.1 | [Production VPC Design](#task-51-production-vpc-design-with-multi-az) | Medium | 4-5h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-51-production-vpc-design-with-multi-az) |
| 5.2 | [IAM Roles and Policies](#task-52-iam-roles-and-policies-least-privilege) | Medium | 3-4h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-52-iam-roles-and-policies-least-privilege) |
| 5.3 | [Security Groups and NACLs](#task-53-security-groups-and-nacls-configuration) | Medium | 3-4h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-53-security-groups-and-nacls-configuration) |
| 5.4 | [EC2 Instance Setup](#task-54-ec2-instance-setup-bastion-and-application-servers) | Medium | 3-4h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-54-ec2-instance-setup-bastion-and-application-servers) |
| 5.5 | [RDS PostgreSQL Multi-AZ](#task-55-rds-postgresql-with-multi-az-and-read-replicas) | Medium | 4-5h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-55-rds-postgresql-with-multi-az-and-read-replicas) |
| 5.6 | [S3 Buckets and Lifecycle](#task-56-s3-buckets-for-artifacts-with-lifecycle-policies) | Easy | 2-3h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-56-s3-buckets-for-artifacts-with-lifecycle-policies) |
| 5.7 | [ECR Container Registry](#task-57-ecr-repository-for-container-images) | Medium | 3-4h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-57-ecr-repository-for-container-images) |
| 5.8 | [CloudWatch Logs and Metrics](#task-58-cloudwatch-logs-and-custom-metrics) | Medium | 3-4h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-58-cloudwatch-logs-and-custom-metrics) |
| 5.9 | [CloudWatch Alarms](#task-59-cloudwatch-alarms-and-sns-notifications) | Easy | 2-3h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-59-cloudwatch-alarms-and-sns-notifications) |
| 5.10 | [Lambda Automation](#task-510-lambda-functions-for-automation-tasks) | Hard | 4-6h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-510-lambda-functions-for-automation-tasks) |
| 5.11 | [EKS IAM Roles](#task-511-eks-iam-roles-and-oidc-provider) | Hard | 4-5h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-511-eks-iam-roles-and-oidc-provider) |
| 5.12 | [Parameter Store](#task-512-aws-systems-manager-parameter-store-setup) | Easy | 1-2h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-512-aws-systems-manager-parameter-store-setup) |
| 5.13 | [Secrets Manager](#task-513-aws-secrets-manager-integration) | Easy | 2-3h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-513-aws-secrets-manager-integration) |
| 5.14 | [VPC Peering / Transit Gateway](#task-514-vpc-peering-and-transit-gateway-setup) | Hard | 5-6h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-514-vpc-peering-and-transit-gateway-setup) |
| 5.15 | [S3 Security and Encryption](#task-515-s3-bucket-policies-and-encryption) | Medium | 3-4h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-515-s3-bucket-policies-and-encryption) |
| 5.16 | [CloudTrail Audit Logging](#task-516-cloudtrail-for-compliance-and-audit-logging) | Medium | 3-4h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-516-cloudtrail-for-compliance-and-audit-logging) |
| 5.17 | [CloudFormation IaC](#task-517-cloudformation-infrastructure-as-code) | Hard | 5-6h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-517-cloudformation-infrastructure-as-code) |
| 5.18 | [Cost Optimization](#task-518-cost-optimization-and-tagging-strategy) | Hard | 4-5h | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-518-cost-optimization-and-tagging-strategy) |

---

## Task 5.1: Production VPC Design with Multi-AZ

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-51-production-vpc-design-with-multi-az)**

### 🎬 Real-World Scenario
Your company is migrating its core application to AWS. You've been assigned to design and implement a production-grade VPC that will host a 3-tier web application (Frontend, Backend API, PostgreSQL Database). The infrastructure must be highly available, secure, and follow AWS best practices.

The CTO wants to ensure the design can scale and has asked for proper network segmentation between tiers with multi-AZ deployment for fault tolerance.

### ⏱️ Time to Complete: 4-5 hours

### 📋 Assignment Instructions

**Your Mission:**
Design and implement a production-ready VPC with proper network architecture for a 3-tier application across multiple availability zones.

**Requirements:**
1. Create VPC with appropriate CIDR block (/16 recommended)
2. Design and create subnets across 3 Availability Zones:
   - Public subnets for load balancers and bastion hosts
   - Private subnets for application servers
   - Private subnets for database servers
3. Set up Internet Gateway for public subnet internet access
4. Deploy NAT Gateways in each AZ for high availability
5. Configure route tables for public and private subnets
6. Enable VPC Flow Logs for network monitoring
7. Implement proper tagging strategy
8. Document the IP addressing scheme

**Architecture to Implement:**
```
VPC (10.0.0.0/16)
├── AZ-A (us-east-1a)
│   ├── Public Subnet (10.0.1.0/24) - ALB, Bastion
│   ├── Private App Subnet (10.0.10.0/24) - Application Servers
│   └── Private DB Subnet (10.0.20.0/24) - Database
├── AZ-B (us-east-1b)
│   ├── Public Subnet (10.0.2.0/24) - ALB, Bastion
│   ├── Private App Subnet (10.0.11.0/24) - Application Servers
│   └── Private DB Subnet (10.0.21.0/24) - Database
└── AZ-C (us-east-1c)
    ├── Public Subnet (10.0.3.0/24) - ALB, Bastion
    ├── Private App Subnet (10.0.12.0/24) - Application Servers
    └── Private DB Subnet (10.0.22.0/24) - Database
```

**Environment:**
- AWS Account with administrative access
- AWS CLI configured
- Region: us-east-1 (or your preferred region)
- Budget: Consider NAT Gateway costs (~$32/month per NAT Gateway)

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **VPC Configuration**
  - [ ] VPC created with /16 CIDR block
  - [ ] DNS hostnames enabled
  - [ ] DNS resolution enabled
  - [ ] VPC tagged with Name and Environment

- [ ] **Subnet Design**
  - [ ] 3 public subnets created (one per AZ)
  - [ ] 3 private app subnets created (one per AZ)
  - [ ] 3 private DB subnets created (one per AZ)
  - [ ] Subnets properly tagged by tier and AZ
  - [ ] Public subnets have auto-assign public IP enabled
  - [ ] Private subnets do NOT auto-assign public IPs

- [ ] **Internet Connectivity**
  - [ ] Internet Gateway created and attached
  - [ ] 3 NAT Gateways created (one per AZ)
  - [ ] Elastic IPs allocated for NAT Gateways
  - [ ] All components properly tagged

- [ ] **Routing Configuration**
  - [ ] Public route table created with IGW route (0.0.0.0/0)
  - [ ] Public subnets associated with public route table
  - [ ] 3 private route tables created (one per AZ)
  - [ ] Each private route table has NAT Gateway route
  - [ ] Private subnets properly associated

- [ ] **VPC Flow Logs**
  - [ ] Flow Logs enabled for VPC
  - [ ] Log group created in CloudWatch
  - [ ] IAM role for Flow Logs configured
  - [ ] Logging to CloudWatch Logs working

- [ ] **Documentation**
  - [ ] IP addressing scheme documented
  - [ ] Subnet allocation table created
  - [ ] Network diagram created
  - [ ] Tagging strategy documented

### 📦 Required Deliverables

1. **VPC Configuration Document**
   ```
   # Production VPC Configuration
   Date: [completion date]
   Region: [AWS region]
   
   VPC Details:
   - VPC ID: vpc-xxxxx
   - CIDR Block: 10.0.0.0/16
   - DNS Hostnames: Enabled
   - DNS Resolution: Enabled
   
   Subnets Created: [count]
   NAT Gateways: [count]
   Route Tables: [count]
   ```

2. **IP Addressing Scheme**
   Create a table showing all subnets:
   ```
   | Subnet Name        | CIDR          | AZ | Type    | Route Table |
   |--------------------|---------------|-----|---------|-------------|
   | public-subnet-1a   | 10.0.1.0/24   | 1a  | Public  | public-rt   |
   | private-app-1a     | 10.0.10.0/24  | 1a  | Private | private-rt-1a |
   | private-db-1a      | 10.0.20.0/24  | 1a  | Private | private-rt-1a |
   [... complete for all subnets]
   ```

3. **AWS CLI Commands Used**
   Document all AWS CLI commands used to create the infrastructure:
   ```bash
   # VPC Creation
   aws ec2 create-vpc --cidr-block 10.0.0.0/16 ...
   
   # Subnet Creation
   aws ec2 create-subnet ...
   
   # [Complete list of commands]
   ```

4. **Network Diagram**
   - Visual diagram showing VPC architecture
   - Include: VPC, subnets, route tables, IGW, NAT GWs
   - Show traffic flow patterns
   - Can use draw.io, Lucidchart, or ASCII art

5. **Verification Test Results**
   ```bash
   # VPC Verification
   aws ec2 describe-vpcs --vpc-ids vpc-xxxxx
   [output]
   
   # Subnet Verification
   aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-xxxxx"
   [output]
   
   # Route Tables Verification
   aws ec2 describe-route-tables --filters "Name=vpc-id,Values=vpc-xxxxx"
   [output]
   
   # NAT Gateway Status
   aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=vpc-xxxxx"
   [output]
   
   # Flow Logs Status
   aws ec2 describe-flow-logs --filter "Name=resource-id,Values=vpc-xxxxx"
   [output]
   ```

6. **Cost Estimation**
   ```
   # Monthly Cost Estimate
   
   NAT Gateways: 3 x $32.40 = $97.20/month
   Data Processing: ~$0.045/GB (variable)
   VPC Flow Logs: ~$0.50/GB ingested
   
   Total Estimated: $100-150/month
   
   Cost Optimization Notes:
   - Consider single NAT Gateway for dev/test
   - Use VPC endpoints to reduce data transfer
   ```

7. **Troubleshooting Runbook**
   Document common issues and solutions:
   ```
   Issue: Private instances can't reach internet
   Solution: 
   1. Verify NAT Gateway is available
   2. Check route table has 0.0.0.0/0 -> NAT Gateway
   3. Verify subnet association
   
   [Add more scenarios]
   ```

### 🎯 Success Criteria

Your VPC implementation is successful if:
- ✅ All validation checklist items are complete
- ✅ Instances in private subnets can reach internet via NAT Gateway
- ✅ Instances in public subnets have internet connectivity via IGW
- ✅ Network is fault-tolerant (survives single AZ failure)
- ✅ VPC Flow Logs are capturing traffic
- ✅ Infrastructure follows AWS best practices
- ✅ Documentation is complete and clear
- ✅ Can demonstrate the network architecture to stakeholders
- ✅ Tagging strategy is consistent across all resources

---

## Task 5.2: IAM Roles and Policies (Least Privilege)

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-52-iam-roles-and-policies-least-privilege)**

### 🎬 Real-World Scenario
Your security team has flagged that many resources are using overly permissive IAM policies. They've requested a complete overhaul following the principle of least privilege. You need to create proper IAM roles and policies for EC2 instances, ECS tasks, Lambda functions, and CI/CD pipelines.

The CTO emphasized: "No AWS resource should have more permissions than it absolutely needs. Every permission must be justified."

### ⏱️ Time to Complete: 3-4 hours

### 📋 Assignment Instructions

**Your Mission:**
Implement comprehensive IAM roles and policies following the least privilege principle for various AWS services and use cases.

**Requirements:**
1. Create IAM role for EC2 instances (application servers)
   - Access to specific S3 buckets only
   - Ability to write CloudWatch logs
   - Ability to read from Parameter Store
   
2. Create IAM role for ECS tasks
   - Pull images from ECR
   - Write to specific CloudWatch log groups
   - Access to application secrets in Secrets Manager
   
3. Create IAM role for Lambda functions
   - Execute Lambda functions
   - Write logs to CloudWatch
   - Access DynamoDB tables (read-only or read-write as needed)
   
4. Create IAM role for CI/CD pipeline (Jenkins/GitHub Actions)
   - Deploy to specific ECS services
   - Push to specific ECR repositories
   - Update specific S3 buckets
   
5. Implement IAM password policy
   - Minimum password length: 14 characters
   - Require uppercase, lowercase, numbers, symbols
   - Password expiration: 90 days
   - Prevent password reuse (last 5 passwords)
   
6. Enable MFA for all human users
7. Document all roles and their justifications

**Environment:**
- AWS Account with IAM full access
- Existing resources: EC2, ECS, Lambda, S3, ECR
- CI/CD tool configured (Jenkins or GitHub Actions)

### ✅ Validation Checklist

- [ ] **EC2 Instance Role**
  - [ ] Role created with trust policy for EC2
  - [ ] Inline or managed policy with S3 access (specific buckets)
  - [ ] CloudWatch Logs write permission
  - [ ] Parameter Store read permission (specific parameters)
  - [ ] NO admin or wildcard permissions
  - [ ] Instance profile created and tested

- [ ] **ECS Task Role**
  - [ ] Role created with trust policy for ECS tasks
  - [ ] ECR pull permissions (specific repositories)
  - [ ] CloudWatch Logs write permissions
  - [ ] Secrets Manager read permissions (specific secrets)
  - [ ] Role tested with sample ECS task

- [ ] **Lambda Function Role**
  - [ ] Role created with trust policy for Lambda
  - [ ] Basic execution role attached
  - [ ] DynamoDB permissions (specific tables, specific actions)
  - [ ] CloudWatch Logs implicit permissions
  - [ ] Tested with sample Lambda function

- [ ] **CI/CD Pipeline Role**
  - [ ] Role created (appropriate trust policy)
  - [ ] ECS deployment permissions
  - [ ] ECR push permissions
  - [ ] S3 upload permissions (specific buckets/prefixes)
  - [ ] NO permissions to delete production resources
  - [ ] Tested with pipeline

- [ ] **IAM Password Policy**
  - [ ] Minimum length 14 characters
  - [ ] Requires uppercase
  - [ ] Requires lowercase
  - [ ] Requires numbers
  - [ ] Requires symbols
  - [ ] Password expiration enabled (90 days)
  - [ ] Password reuse prevention (5 passwords)

- [ ] **MFA Enforcement**
  - [ ] MFA enabled for root account
  - [ ] MFA policy created for IAM users
  - [ ] Test users have MFA enabled
  - [ ] MFA required for sensitive operations

- [ ] **Documentation**
  - [ ] Each role's purpose documented
  - [ ] Permissions justified
  - [ ] Policy JSON saved
  - [ ] Access patterns documented

### 📦 Required Deliverables

1. **IAM Roles Summary Document**
   ```
   # IAM Roles Configuration
   Date: [date]
   Account: [AWS Account ID]
   
   ## Roles Created
   
   ### 1. EC2-Application-Role
   Purpose: Allow EC2 application servers to access required AWS resources
   ARN: arn:aws:iam::123456789012:role/EC2-Application-Role
   Trust Policy: ec2.amazonaws.com
   Permissions:
   - S3: Read/Write to s3://myapp-artifacts/*
   - CloudWatch Logs: Write to log group /aws/ec2/application
   - SSM Parameter Store: Read from /myapp/production/*
   
   Justification: Application needs to download deployment artifacts from S3,
   send logs to CloudWatch, and read configuration from Parameter Store.
   
   [Continue for all roles]
   ```

2. **Policy JSON Files**
   Save all custom policies:
   ```json
   // ec2-app-policy.json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "S3ArtifactAccess",
         "Effect": "Allow",
         "Action": [
           "s3:GetObject",
           "s3:PutObject"
         ],
         "Resource": "arn:aws:s3:::myapp-artifacts/*"
       },
       // [Complete policy]
     ]
   }
   ```

3. **IAM Password Policy Configuration**
   ```bash
   # Current Password Policy
   aws iam get-account-password-policy
   [output showing all requirements met]
   ```

4. **Permission Testing Results**
   ```
   # Test 1: EC2 Role S3 Access
   $ aws s3 ls s3://myapp-artifacts/ --profile ec2-role
   [should succeed]
   
   $ aws s3 ls s3://other-bucket/ --profile ec2-role
   [should fail with Access Denied]
   
   # Test 2: Lambda Role DynamoDB Access
   $ aws dynamodb scan --table-name MyTable --profile lambda-role
   [should succeed]
   
   $ aws dynamodb delete-table --table-name MyTable --profile lambda-role
   [should fail - no delete permission]
   
   # Test 3: CI/CD Role ECR Push
   $ aws ecr get-login-password | docker login ...
   $ docker push [repository]
   [should succeed]
   
   [Complete all test scenarios]
   ```

5. **Security Audit Report**
   ```
   # IAM Security Audit
   
   ## Findings
   
   ✅ All roles follow least privilege principle
   ✅ No wildcard (*) permissions except where required
   ✅ All policies have specific resource ARNs
   ✅ Password policy meets security requirements
   ✅ MFA enabled for all human users
   
   ## Recommendations
   - Review permissions quarterly
   - Implement IAM Access Analyzer
   - Use AWS IAM Policy Simulator for testing
   - Enable CloudTrail for IAM API calls
   ```

6. **Role Assumption Test Scripts**
   ```bash
   #!/bin/bash
   # test-role-permissions.sh
   # Tests IAM role permissions
   
   ROLE_ARN="arn:aws:iam::123456789012:role/EC2-Application-Role"
   
   # Assume role
   CREDENTIALS=$(aws sts assume-role \
     --role-arn $ROLE_ARN \
     --role-session-name test-session \
     --query 'Credentials' \
     --output json)
   
   # Export credentials
   export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | jq -r '.AccessKeyId')
   export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | jq -r '.SecretAccessKey')
   export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | jq -r '.SessionToken')
   
   # Test permissions
   echo "Testing S3 access..."
   aws s3 ls s3://myapp-artifacts/
   
   echo "Testing CloudWatch Logs..."
   aws logs describe-log-groups --log-group-name-prefix /aws/ec2/
   
   # [Add more tests]
   ```

7. **IAM Best Practices Checklist**
   ```
   - [ ] No hard-coded credentials in code
   - [ ] Root account MFA enabled
   - [ ] Root account not used for daily operations
   - [ ] All roles use specific resource ARNs (no *)
   - [ ] Regular access reviews scheduled
   - [ ] Unused roles/users removed
   - [ ] CloudTrail enabled for audit logging
   - [ ] IAM Access Analyzer enabled
   - [ ] Service Control Policies (SCPs) considered
   - [ ] Cross-account access uses roles, not users
   ```

### 🎯 Success Criteria

- ✅ All IAM roles created and working
- ✅ Each role has minimum required permissions
- ✅ No overly permissive policies (wildcards minimized)
- ✅ IAM password policy enforced
- ✅ MFA configured for all users
- ✅ All roles tested and verified
- ✅ Permission boundaries where appropriate
- ✅ Documentation complete with justifications
- ✅ Security audit shows no critical findings
- ✅ Team understands how to use each role

---

## Task 5.3: Security Groups and NACLs Configuration

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-53-security-groups-and-nacls-configuration)**

### 🎬 Real-World Scenario
The security team has identified that your current infrastructure has overly permissive security groups with "allow from 0.0.0.0/0" on multiple ports. They require immediate implementation of defense-in-depth using both Security Groups and Network ACLs for the 3-tier application.

A recent security audit showed: "The database security group allows access from 0.0.0.0/0 on port 5432 - this is a critical finding that must be remediated immediately."

### ⏱️ Time to Complete: 3-4 hours

### 📋 Assignment Instructions

**Your Mission:**
Implement proper network security using Security Groups and NACLs for a 3-tier application following the principle of least privilege.

**Architecture:**
```
Internet → Load Balancer (SG) → Web/App Tier (SG) → Database Tier (SG)
          └─ Public Subnet (NACL)    Private App (NACL)  Private DB (NACL)
```

**Requirements:**

1. **Create Security Groups:**
   - ALB Security Group: Allow 80/443 from 0.0.0.0/0
   - Bastion Security Group: Allow 22 from company IP range only
   - Application Security Group: Allow traffic only from ALB SG
   - Database Security Group: Allow 5432 only from Application SG
   
2. **Configure Network ACLs:**
   - Public Subnet NACL: Allow HTTP/HTTPS inbound, ephemeral outbound
   - Private App Subnet NACL: Allow from public subnets, deny all others
   - Private DB Subnet NACL: Allow from app subnets only
   
3. **Implement Security Group Chaining:**
   - Use security group IDs as sources (not CIDRs where possible)
   - Demonstrate principle of least privilege
   
4. **Document all rules with justifications**

5. **Test connectivity and restrictions**

**Environment:**
- VPC with public and private subnets (from Task 5.1)
- 3-tier application (ALB, EC2 app servers, RDS database)
- Company IP range: 203.0.113.0/24 (example)

### ✅ Validation Checklist

- [ ] **Load Balancer Security Group**
  - [ ] Allows HTTP (80) from 0.0.0.0/0
  - [ ] Allows HTTPS (443) from 0.0.0.0/0
  - [ ] Outbound allows to Application SG on app port
  - [ ] Properly tagged

- [ ] **Bastion Security Group**
  - [ ] Allows SSH (22) from company IP range ONLY
  - [ ] NO access from 0.0.0.0/0
  - [ ] Outbound allows SSH to application SG
  - [ ] Properly tagged

- [ ] **Application Security Group**
  - [ ] Allows app port (e.g., 8080) from ALB SG only
  - [ ] Allows SSH (22) from Bastion SG only
  - [ ] Outbound allows PostgreSQL to DB SG
  - [ ] Properly tagged

- [ ] **Database Security Group**
  - [ ] Allows PostgreSQL (5432) from Application SG ONLY
  - [ ] NO direct access from internet or public subnets
  - [ ] Optionally allows from Bastion SG for admin
  - [ ] Properly tagged

- [ ] **Network ACLs - Public Subnets**
  - [ ] Inbound: Allow HTTP/HTTPS from anywhere
  - [ ] Inbound: Allow return traffic (ephemeral ports)
  - [ ] Inbound: Allow SSH from company IP range
  - [ ] Outbound: Allow to internet
  - [ ] Rule numbers logical and organized

- [ ] **Network ACLs - Private App Subnets**
  - [ ] Inbound: Allow from public subnet CIDRs
  - [ ] Inbound: Allow return traffic
  - [ ] Outbound: Allow to database subnets
  - [ ] Outbound: Allow to internet (via NAT)
  - [ ] Deny all other traffic

- [ ] **Network ACLs - Private DB Subnets**
  - [ ] Inbound: Allow PostgreSQL from app subnet CIDRs
  - [ ] Inbound: Allow return traffic
  - [ ] Outbound: Allow return traffic to app subnets
  - [ ] Deny all other traffic
  - [ ] NO direct internet access

- [ ] **Testing & Validation**
  - [ ] Can access ALB from internet
  - [ ] Cannot access app servers directly from internet
  - [ ] Cannot access database directly from internet
  - [ ] App servers can reach database
  - [ ] Bastion can SSH to app servers
  - [ ] All denied access attempts logged

### 📦 Required Deliverables

1. **Security Group Configuration Document**
   ```
   # Security Groups Configuration
   
   ## ALB Security Group (alb-sg)
   ID: sg-xxxxx
   VPC: vpc-xxxxx
   
   Inbound Rules:
   | Type  | Protocol | Port | Source        | Purpose           |
   |-------|----------|------|---------------|-------------------|
   | HTTP  | TCP      | 80   | 0.0.0.0/0     | Public web access |
   | HTTPS | TCP      | 443  | 0.0.0.0/0     | Public web access |
   
   Outbound Rules:
   | Type   | Protocol | Port | Destination        | Purpose        |
   |--------|----------|------|--------------------|----------------|
   | Custom | TCP      | 8080 | sg-app-xxxxx       | To app servers |
   
   Justification: ALB needs to accept HTTP/HTTPS from internet and 
   forward to application servers on port 8080.
   
   [Continue for all security groups]
   ```

2. **Network ACL Configuration**
   ```
   # Network ACLs Configuration
   
   ## Public Subnet NACL
   NACL ID: acl-xxxxx
   Associated Subnets: subnet-pub-1a, subnet-pub-1b, subnet-pub-1c
   
   Inbound Rules:
   | Rule # | Type  | Protocol | Port Range   | Source      | Allow/Deny |
   |--------|-------|----------|--------------|-------------|------------|
   | 100    | HTTP  | TCP      | 80           | 0.0.0.0/0   | ALLOW      |
   | 110    | HTTPS | TCP      | 443          | 0.0.0.0/0   | ALLOW      |
   | 120    | SSH   | TCP      | 22           | 203.0.113.0/24 | ALLOW   |
   | 130    | Custom| TCP      | 1024-65535   | 0.0.0.0/0   | ALLOW      |
   | *      | All   | All      | All          | 0.0.0.0/0   | DENY       |
   
   Outbound Rules:
   | Rule # | Type  | Protocol | Port Range   | Destination | Allow/Deny |
   |--------|-------|----------|--------------|-------------|------------|
   | 100    | Custom| TCP      | 8080         | 10.0.0.0/16 | ALLOW      |
   | 110    | HTTP  | TCP      | 80           | 0.0.0.0/0   | ALLOW      |
   | 120    | HTTPS | TCP      | 443          | 0.0.0.0/0   | ALLOW      |
   | 130    | Custom| TCP      | 1024-65535   | 0.0.0.0/0   | ALLOW      |
   | *      | All   | All      | All          | 0.0.0.0/0   | DENY       |
   
   [Continue for other NACLs]
   ```

3. **Security Architecture Diagram**
   ```
   [Create a diagram showing:]
   - All security groups
   - All NACLs
   - Traffic flow between tiers
   - Allowed and blocked connections
   ```

4. **AWS CLI Commands Used**
   ```bash
   # Security Group Creation
   aws ec2 create-security-group \
     --group-name alb-sg \
     --description "Security group for Application Load Balancer" \
     --vpc-id vpc-xxxxx
   
   # Add ingress rules
   aws ec2 authorize-security-group-ingress \
     --group-id sg-alb-xxxxx \
     --protocol tcp \
     --port 80 \
     --cidr 0.0.0.0/0
   
   # [Complete list of all commands]
   ```

5. **Security Testing Results**
   ```
   # Test 1: Internet to ALB (Should ALLOW)
   $ curl http://alb-dns-name.us-east-1.elb.amazonaws.com
   [HTTP 200 - Success]
   
   # Test 2: Internet to App Server (Should DENY)
   $ curl http://10.0.10.50:8080
   [Timeout - Blocked by security group]
   
   # Test 3: Internet to Database (Should DENY)
   $ psql -h db-endpoint -U admin -d mydb
   [Connection timeout - Blocked]
   
   # Test 4: App to Database (Should ALLOW)
   $ ssh bastion-host
   $ ssh app-server
   $ psql -h db-endpoint -U admin -d mydb
   [Connection successful]
   
   # Test 5: SSH from unauthorized IP (Should DENY)
   $ ssh -i key.pem ubuntu@bastion-ip
   [From IP: 198.51.100.50]
   [Connection timeout - Not in allowed IP range]
   
   # Test 6: SSH from company IP (Should ALLOW)
   $ ssh -i key.pem ubuntu@bastion-ip
   [From IP: 203.0.113.100]
   [Connection successful]
   
   [Document all test cases]
   ```

6. **Security Group vs NACL Comparison Table**
   ```
   | Feature              | Security Groups      | Network ACLs           |
   |----------------------|----------------------|------------------------|
   | Layer                | Instance level       | Subnet level           |
   | State                | Stateful             | Stateless              |
   | Rules                | Allow only           | Allow and Deny         |
   | Rule evaluation      | All rules evaluated  | Rules in order         |
   | Applies to           | EC2 instances        | All resources in subnet|
   | Return traffic       | Automatic            | Must be explicitly allowed |
   | Default              | Deny all inbound     | Allow all              |
   | Use Case             | Fine-grained control | Broad subnet protection|
   ```

7. **Troubleshooting Guide**
   ```
   # Common Issues and Solutions
   
   Issue: Can't connect to application
   Checks:
   1. Verify security group allows required port
      aws ec2 describe-security-groups --group-ids sg-xxxxx
   2. Verify NACL allows traffic
      aws ec2 describe-network-acls --network-acl-ids acl-xxxxx
   3. Verify route table has correct routes
   4. Check if instance is running
   5. Verify ephemeral ports are allowed in NACL outbound
   
   Issue: Database connections timing out
   Checks:
   1. Verify DB security group allows from app SG
   2. Verify DB subnet NACL allows from app subnet CIDR
   3. Verify DB is in private subnet with no public IP
   4. Check DB security group outbound rules
   5. Verify app subnet NACL allows return traffic
   
   [Add more scenarios]
   ```

### 🎯 Success Criteria

- ✅ All security groups configured with least privilege
- ✅ Security group chaining implemented (using SG IDs as sources)
- ✅ NACLs provide subnet-level protection
- ✅ No critical security findings (database accessible from internet)
- ✅ Application works end-to-end
- ✅ Unauthorized access is blocked
- ✅ All rules documented with justifications
- ✅ Testing proves security is working
- ✅ Can troubleshoot connectivity issues
- ✅ Defense-in-depth implemented (SG + NACL)

---


## Task 5.4: EC2 Instance Setup (Bastion and Application Servers)

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-54-ec2-instance-setup-bastion-and-application-servers)**

### 🎬 Real-World Scenario
Your team needs to set up EC2 instances for the production environment. You need to create a bastion host for secure SSH access and application servers that will run the backend API. The instances must be properly configured with IAM roles, monitoring, and follow security best practices.

**Critical Requirements from CTO:**
- "No SSH keys should be stored on local machines - use AWS Systems Manager Session Manager"
- "All instances must send logs to CloudWatch"
- "User data scripts must be idempotent and version controlled"

### ⏱️ Time to Complete: 3-4 hours

### 📋 Assignment Instructions

**Your Mission:**
Set up production-grade EC2 instances including bastion host and application servers with proper security, monitoring, and automation.

**Requirements:**
1. Launch bastion host in public subnet
   - t3.micro instance type
   - Amazon Linux 2 or Ubuntu 20.04
   - SSH access from company IP range only
   - Systems Manager agent installed
   - CloudWatch agent for metrics
   
2. Launch application servers in private subnets
   - t3.medium instance type
   - Amazon Linux 2 or Ubuntu 20.04
   - No direct SSH from internet
   - IAM role with required permissions
   - User data script to install application dependencies
   - CloudWatch agent configured
   
3. Configure Systems Manager Session Manager
   - Enable session logging to CloudWatch
   - Enable session recording to S3
   - Test access without SSH keys
   
4. Implement proper tagging strategy
5. Set up CloudWatch alarms for instance health
6. Create AMI from configured application server

**Environment:**
- VPC from Task 5.1
- Security Groups from Task 5.3
- IAM roles from Task 5.2

### ✅ Validation Checklist

- [ ] **Bastion Host**
  - [ ] Instance launched in public subnet
  - [ ] Security group allows SSH from company IP only
  - [ ] Systems Manager agent installed and running
  - [ ] CloudWatch agent installed
  - [ ] Can SSH to instance
  - [ ] Can access via Session Manager
  - [ ] Properly tagged

- [ ] **Application Servers**
  - [ ] 2 instances launched across different AZs
  - [ ] Instances in private subnets
  - [ ] IAM instance profile attached
  - [ ] User data script executed successfully
  - [ ] CloudWatch agent sending metrics
  - [ ] Application dependencies installed
  - [ ] Can SSH from bastion host
  - [ ] Cannot SSH directly from internet

- [ ] **Systems Manager**
  - [ ] Session Manager access working
  - [ ] Session logging enabled
  - [ ] Can start session without SSH keys
  - [ ] Session history visible in console

- [ ] **Monitoring**
  - [ ] CloudWatch agent running on all instances
  - [ ] Custom metrics being sent
  - [ ] Log groups created
  - [ ] Alarms configured
  - [ ] Dashboard created

- [ ] **AMI Creation**
  - [ ] AMI created from application server
  - [ ] AMI includes all configurations
  - [ ] AMI tagged properly
  - [ ] Test launch from AMI successful

### 📦 Required Deliverables

1. **EC2 Configuration Document**
2. **User Data Scripts** (for application servers)
3. **CloudWatch Agent Configuration**
4. **Systems Manager Session Configuration**
5. **Testing Results** (SSH, Session Manager, Application)
6. **AMI Details and Launch Template**
7. **Monitoring Dashboard** screenshot

### 🎯 Success Criteria

- ✅ All instances running and healthy
- ✅ Can access via Session Manager without SSH keys
- ✅ Application servers accessible only from bastion
- ✅ CloudWatch metrics and logs flowing
- ✅ User data scripts are idempotent
- ✅ AMI created and tested
- ✅ All resources properly tagged
- ✅ Security best practices followed

---

## Task 5.5: RDS PostgreSQL with Multi-AZ and Read Replicas

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-55-rds-postgresql-with-multi-az-and-read-replicas)**

### 🎬 Real-World Scenario
The database team needs a production PostgreSQL database that can handle 10,000 transactions per minute with less than 1 hour RPO (Recovery Point Objective) and 4 hours RTO (Recovery Time Objective). The application also has heavy read traffic that's impacting write performance.

**Requirements from Database Team:**
- "We need Multi-AZ for high availability"
- "Create a read replica to offload read traffic"
- "Implement automated backups with 7-day retention"
- "Enable encryption at rest and in transit"
- "We need point-in-time recovery capability"

### ⏱️ Time to Complete: 4-5 hours

### 📋 Assignment Instructions

**Your Mission:**
Deploy and configure a production-grade RDS PostgreSQL database with high availability, read replicas, automated backups, and proper security.

**Requirements:**
1. Create RDS PostgreSQL instance
   - Engine: PostgreSQL 14.x
   - Instance class: db.t3.medium (adjustable)
   - Multi-AZ deployment
   - Storage: 100GB gp3
   - Encryption at rest enabled
   
2. Create DB subnet group spanning 3 AZs
3. Configure security group (port 5432 from app tier only)
4. Create read replica in different AZ
5. Configure automated backups
   - Retention: 7 days
   - Backup window: 03:00-04:00 UTC
   - Maintenance window: Sun 04:00-05:00 UTC
   
6. Create custom parameter group
   - Tune for application workload
   - Enable query logging
   - Configure connection limits
   
7. Enable Enhanced Monitoring
8. Set up CloudWatch alarms
9. Test failover scenario
10. Document connection strings and procedures

**Environment:**
- VPC with private DB subnets
- Security group from Task 5.3
- Application servers from Task 5.4

### ✅ Validation Checklist

- [ ] **RDS Instance Configuration**
  - [ ] PostgreSQL 14.x engine
  - [ ] Multi-AZ enabled
  - [ ] Storage encrypted
  - [ ] In private subnets
  - [ ] Proper security group attached
  - [ ] Enhanced monitoring enabled
  - [ ] Deletion protection enabled

- [ ] **DB Subnet Group**
  - [ ] Spans 3 availability zones
  - [ ] Uses private DB subnets only
  - [ ] Properly tagged

- [ ] **Backups**
  - [ ] Automated backups enabled
  - [ ] 7-day retention configured
  - [ ] Backup window set
  - [ ] Manual snapshot created and tested
  - [ ] Point-in-time recovery verified

- [ ] **Read Replica**
  - [ ] Created in different AZ
  - [ ] Replication lag monitored
  - [ ] Can query replica
  - [ ] Separate endpoint documented

- [ ] **Parameter Group**
  - [ ] Custom parameter group created
  - [ ] Parameters tuned for workload
  - [ ] Query logging enabled
  - [ ] Applied to instance

- [ ] **Monitoring & Alarms**
  - [ ] Enhanced monitoring active
  - [ ] CloudWatch alarms for CPU, storage, connections
  - [ ] Replication lag alarm for read replica
  - [ ] SNS topic for notifications

- [ ] **Security**
  - [ ] Encryption at rest enabled
  - [ ] SSL/TLS for connections enforced
  - [ ] Master password in Secrets Manager
  - [ ] Security group allows only app tier

- [ ] **Testing**
  - [ ] Can connect from application server
  - [ ] Cannot connect from internet
  - [ ] Failover tested
  - [ ] Read replica tested
  - [ ] Restore from backup tested

### 📦 Required Deliverables

1. **RDS Configuration Document** - Complete details of all settings
2. **Connection Details** - Primary and replica endpoints, connection strings
3. **Parameter Group Settings** - Custom parameters and justifications
4. **Backup Strategy Document** - Backup schedule, retention, recovery procedures
5. **Failover Test Results** - Documentation of failover test with timing
6. **Monitoring Dashboard** - CloudWatch dashboard for RDS metrics
7. **Disaster Recovery Runbook** - Step-by-step recovery procedures
8. **Cost Estimation** - Monthly cost breakdown

### 🎯 Success Criteria

- ✅ Database highly available (Multi-AZ)
- ✅ Read replica functioning and reducing primary load
- ✅ Automated backups working
- ✅ Can restore from backup
- ✅ Failover works with minimal downtime
- ✅ Monitoring and alerts configured
- ✅ Security best practices implemented
- ✅ Performance meets requirements
- ✅ Disaster recovery procedures documented

---

## Task 5.6: S3 Buckets for Artifacts with Lifecycle Policies

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-56-s3-buckets-for-artifacts-with-lifecycle-policies)**

### 🎬 Real-World Scenario
Your CI/CD pipeline generates build artifacts, application logs, and database backups that are filling up S3 buckets rapidly. The finance team is concerned about storage costs. You need to implement S3 lifecycle policies to automatically transition objects to cheaper storage classes and delete old objects.

**Requirements from Finance:**
- "We're spending $500/month on S3 storage - optimize this"
- "Keep backups for 90 days, then delete"
- "Move old artifacts to cheaper storage after 30 days"

### ⏱️ Time to Complete: 2-3 hours

### 📋 Assignment Instructions

**Your Mission:**
Create S3 buckets with proper lifecycle policies, versioning, and security configurations to optimize storage costs while maintaining data integrity.

**Requirements:**
1. Create S3 buckets:
   - Artifacts bucket (myapp-artifacts-[account-id])
   - Logs bucket (myapp-logs-[account-id])
   - Backups bucket (myapp-backups-[account-id])
   
2. Enable versioning on artifacts and backups buckets
3. Configure lifecycle policies:
   - Artifacts: Transition to IA after 30 days, Glacier after 90 days, delete after 365 days
   - Logs: Delete after 90 days
   - Backups: Transition to Glacier after 30 days, delete after 90 days
   
4. Enable server-side encryption (SSE-S3)
5. Configure bucket policies for least privilege access
6. Enable S3 access logging
7. Set up S3 metrics and CloudWatch alarms
8. Block all public access
9. Create cost projection report

**Environment:**
- AWS Account with S3 full access
- IAM roles from Task 5.2 (EC2, Lambda roles need S3 access)

### ✅ Validation Checklist

- [ ] **Bucket Creation**
  - [ ] 3 buckets created with unique names
  - [ ] All buckets in same region as application
  - [ ] Proper tagging applied
  - [ ] Block public access enabled

- [ ] **Versioning**
  - [ ] Enabled on artifacts bucket
  - [ ] Enabled on backups bucket
  - [ ] Not enabled on logs bucket (justified)

- [ ] **Lifecycle Policies**
  - [ ] Artifacts bucket: 3 transition rules
  - [ ] Logs bucket: deletion rule
  - [ ] Backups bucket: transition + deletion
  - [ ] Policies tested with test objects

- [ ] **Encryption**
  - [ ] SSE-S3 enabled on all buckets
  - [ ] Encryption enforced via bucket policy
  - [ ] SSL/TLS enforced for uploads

- [ ] **Access Control**
  - [ ] Bucket policies configured
  - [ ] IAM roles have appropriate access
  - [ ] Public access blocked
  - [ ] Access logging enabled

- [ ] **Monitoring**
  - [ ] S3 metrics enabled
  - [ ] CloudWatch alarms for bucket size
  - [ ] Access logs being generated
  - [ ] Cost anomaly detection configured

- [ ] **Cost Optimization**
  - [ ] Lifecycle policies will reduce costs
  - [ ] Intelligent-Tiering considered
  - [ ] S3 analytics enabled
  - [ ] Cost projection documented

### 📦 Required Deliverables

1. **Bucket Configuration Document** - All bucket settings
2. **Lifecycle Policy JSON** - All policies with explanations
3. **Bucket Policy JSON** - Security policies
4. **Cost Analysis Report** - Before/after cost projection
5. **Access Patterns Documentation** - Who/what accesses each bucket
6. **Testing Results** - Upload, download, lifecycle transitions
7. **Monitoring Dashboard** - CloudWatch metrics for S3

### 🎯 Success Criteria

- ✅ All buckets created and configured
- ✅ Lifecycle policies will reduce costs by 40-60%
- ✅ Versioning protects against accidental deletion
- ✅ All data encrypted at rest
- ✅ Access properly controlled
- ✅ Monitoring in place
- ✅ Public access blocked
- ✅ Cost projections meet finance requirements

---

## Task 5.7: ECR Repository for Container Images

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-57-ecr-repository-for-container-images)**

### 🎬 Real-World Scenario
Your team is containerizing applications and needs a private Docker registry. You've been asked to set up Amazon ECR (Elastic Container Registry) with proper security, image scanning, and lifecycle policies to manage storage costs.

### ⏱️ Time to Complete: 3-4 hours

### 📋 Assignment Instructions

**Your Mission:**
Set up Amazon ECR repositories with security scanning, lifecycle policies, and proper access control for containerized applications.

**Requirements:**
1. Create ECR repositories for:
   - Frontend application
   - Backend API
   - Worker service
   
2. Enable image scanning on push
3. Configure lifecycle policies (keep last 10 images)
4. Set up repository policies for cross-account access (if needed)
5. Configure encryption
6. Test push/pull images
7. Integrate with CI/CD pipeline
8. Document usage procedures

### ✅ Validation Checklist

- [ ] **Repositories Created**
- [ ] **Image Scanning Enabled**
- [ ] **Lifecycle Policies Configured**
- [ ] **Encryption Enabled**
- [ ] **Access Policies Configured**
- [ ] **CI/CD Integration Working**
- [ ] **Images Pushed Successfully**
- [ ] **Vulnerability Scanning Working**

### 📦 Required Deliverables

1. Repository configuration document
2. Lifecycle policy JSON
3. Docker push/pull commands
4. CI/CD integration guide
5. Vulnerability scan results
6. Cost projection

### 🎯 Success Criteria

- ✅ Repositories functional
- ✅ Image scanning working
- ✅ Lifecycle policies managing storage
- ✅ CI/CD can push/pull images
- ✅ Access properly controlled

---

## Task 5.8: CloudWatch Logs and Custom Metrics

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-58-cloudwatch-logs-and-custom-metrics)**

### 🎬 Real-World Scenario
Your application logs are scattered across multiple EC2 instances making troubleshooting difficult. You need to centralize all logs in CloudWatch Logs and create custom metrics to track application-specific events like order completions, user registrations, and API errors.

### ⏱️ Time to Complete: 3-4 hours

### 📋 Assignment Instructions

**Your Mission:**
Implement centralized logging with CloudWatch Logs and create custom metrics for application monitoring.

**Requirements:**
1. Configure CloudWatch Logs agent on EC2 instances
2. Create log groups for each application component
3. Set up log retention policies
4. Create metric filters for important events
5. Set up custom metrics from application code
6. Create CloudWatch Insights queries
7. Document log analysis procedures

### ✅ Validation Checklist

- [ ] **Log Groups Created**
- [ ] **Logs Flowing from All Sources**
- [ ] **Metric Filters Working**
- [ ] **Custom Metrics Being Sent**
- [ ] **Retention Policies Set**
- [ ] **Insights Queries Created**
- [ ] **Dashboard Created**

### 📦 Required Deliverables

1. CloudWatch agent configuration
2. Log group structure
3. Metric filter definitions
4. Custom metrics code examples
5. Insights query library
6. Logging best practices guide

### 🎯 Success Criteria

- ✅ All logs centralized
- ✅ Can search across all instances
- ✅ Custom metrics tracking business events
- ✅ Metric filters creating useful metrics
- ✅ Insights queries provide value

---

## Task 5.9: CloudWatch Alarms and SNS Notifications

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-59-cloudwatch-alarms-and-sns-notifications)**

### 🎬 Real-World Scenario
Your team needs to be alerted when infrastructure or application issues occur. Set up CloudWatch Alarms for critical metrics and integrate with SNS to send notifications to Slack, email, and PagerDuty.

### ⏱️ Time to Complete: 2-3 hours

### 📋 Assignment Instructions

**Your Mission:**
Create comprehensive monitoring and alerting system using CloudWatch Alarms and SNS.

**Requirements:**
1. Create SNS topics for different alert severities (Critical, Warning, Info)
2. Configure CloudWatch Alarms for:
   - EC2: CPU > 80%, Memory > 85%, Disk > 90%
   - RDS: CPU > 70%, Storage < 10GB, Connections > 80%
   - ALB: 5XX errors > 10/min, Target health < 2
   - Application: API error rate > 1%, Response time > 2s
3. Set up email subscriptions
4. Configure SNS to Slack integration
5. Test all alarms
6. Create alarm response runbook

### ✅ Validation Checklist

- [ ] **SNS Topics Created**
- [ ] **Alarms Configured**
- [ ] **Subscriptions Working**
- [ ] **Slack Integration Working**
- [ ] **Alarms Tested**
- [ ] **Runbook Created**

### 📦 Required Deliverables

1. SNS topic configuration
2. Complete alarm list
3. Subscription details
4. Slack integration guide
5. Test results
6. Incident response runbook

### 🎯 Success Criteria

- ✅ Alarms fire when thresholds breached
- ✅ Notifications reach appropriate channels
- ✅ Team can respond to alerts
- ✅ False positive rate < 5%

---

## Task 5.10: Lambda Functions for Automation Tasks

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-510-lambda-functions-for-automation-tasks)**

### 🎬 Real-World Scenario
Your operations team spends hours on repetitive tasks like stopping/starting non-production instances, cleaning up old snapshots, and generating daily reports. Automate these tasks using AWS Lambda functions.

### ⏱️ Time to Complete: 4-6 hours

### 📋 Assignment Instructions

**Your Mission:**
Create Lambda functions to automate common operational tasks with proper error handling, logging, and scheduling.

**Requirements:**
1. Create Lambda functions for:
   - Auto-stop dev/test EC2 instances after hours
   - Delete EBS snapshots older than 30 days
   - Generate daily cost report
   - Clean up unused Elastic IPs
   - Alert on untagged resources
   
2. Configure IAM roles with least privilege
3. Set up EventBridge rules for scheduling
4. Implement error handling and logging
5. Create CloudWatch dashboards for Lambda metrics
6. Write unit tests for Lambda functions
7. Document each function

### ✅ Validation Checklist

- [ ] **Functions Created**
- [ ] **IAM Roles Configured**
- [ ] **EventBridge Schedules Set**
- [ ] **Error Handling Implemented**
- [ ] **CloudWatch Logging Working**
- [ ] **Functions Tested**
- [ ] **Documentation Complete**

### 📦 Required Deliverables

1. Lambda function code (all functions)
2. IAM role policies
3. EventBridge rule configurations
4. Test results
5. CloudWatch dashboard
6. Function documentation
7. Cost savings report

### 🎯 Success Criteria

- ✅ All functions working automatically
- ✅ Error handling robust
- ✅ Logs provide good debugging info
- ✅ Saves operational time
- ✅ Reduces AWS costs

---

## Task 5.11: EKS IAM Roles and OIDC Provider

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-511-eks-iam-roles-and-oidc-provider)**

### 🎬 Real-World Scenario
Your team is deploying applications on Amazon EKS and needs to give pods access to AWS services securely without using static credentials. Implement IAM Roles for Service Accounts (IRSA) using OIDC provider.

### ⏱️ Time to Complete: 4-5 hours

### 📋 Assignment Instructions

**Your Mission:**
Configure IAM Roles for Service Accounts in EKS to provide pods with AWS permissions without static credentials.

**Requirements:**
1. Set up OIDC provider for EKS cluster
2. Create IAM role for pods to access S3
3. Create IAM role for pods to access DynamoDB
4. Create IAM role for ALB Ingress Controller
5. Configure Kubernetes service accounts
6. Test pod access to AWS services
7. Document the setup process

### ✅ Validation Checklist

- [ ] **OIDC Provider Created**
- [ ] **IAM Roles Created**
- [ ] **Service Accounts Configured**
- [ ] **Trust Policies Correct**
- [ ] **Pods Can Assume Roles**
- [ ] **AWS Access Working**
- [ ] **No Static Credentials Used**

### 📦 Required Deliverables

1. OIDC configuration
2. IAM role policies
3. Kubernetes service account manifests
4. Test pod configurations
5. Access test results
6. Setup documentation

### 🎯 Success Criteria

- ✅ Pods can access AWS services securely
- ✅ No static credentials in pods
- ✅ Least privilege implemented
- ✅ Trust relationships working
- ✅ Team understands IRSA

---

## Task 5.12: AWS Systems Manager Parameter Store Setup

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-512-aws-systems-manager-parameter-store-setup)**

### 🎬 Real-World Scenario
Your application configuration values are hard-coded in various places making updates difficult. Centralize all configuration in Parameter Store for easy management and version control.

### ⏱️ Time to Complete: 1-2 hours

### 📋 Assignment Instructions

**Your Mission:**
Set up Parameter Store to manage application configuration with proper organization, encryption, and access control.

**Requirements:**
1. Create parameter hierarchy:
   - /myapp/production/*
   - /myapp/staging/*
   - /myapp/development/*
2. Store configuration parameters (DB hosts, API keys, feature flags)
3. Use SecureString for sensitive data
4. Configure parameter policies (expiration, notifications)
5. Implement versioning
6. Set up access control
7. Integrate with application code

### ✅ Validation Checklist

- [ ] **Parameters Created**
- [ ] **Hierarchy Organized**
- [ ] **Sensitive Data Encrypted**
- [ ] **Access Control Configured**
- [ ] **Application Integration Working**
- [ ] **Versioning Enabled**

### 📦 Required Deliverables

1. Parameter hierarchy document
2. AWS CLI commands
3. Application integration code
4. Access policy
5. Usage guide

### 🎯 Success Criteria

- ✅ Configuration centralized
- ✅ Sensitive data encrypted
- ✅ Easy to update parameters
- ✅ Application retrieves values correctly
- ✅ Access properly controlled

---

## Task 5.13: AWS Secrets Manager Integration

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-513-aws-secrets-manager-integration)**

### 🎬 Real-World Scenario
Database passwords and API keys are stored in various locations posing a security risk. Migrate all secrets to Secrets Manager with automatic rotation.

### ⏱️ Time to Complete: 2-3 hours

### 📋 Assignment Instructions

**Your Mission:**
Migrate secrets to Secrets Manager and implement automatic rotation for database credentials.

**Requirements:**
1. Create secrets for:
   - RDS database credentials
   - Third-party API keys
   - OAuth client secrets
2. Enable automatic rotation for RDS passwords
3. Configure rotation Lambda function
4. Update applications to retrieve secrets
5. Set up secret access audit logging
6. Implement secret version management

### ✅ Validation Checklist

- [ ] **Secrets Created**
- [ ] **Automatic Rotation Configured**
- [ ] **Rotation Lambda Working**
- [ ] **Applications Using Secrets Manager**
- [ ] **Audit Logging Enabled**
- [ ] **Version Management Working**

### 📦 Required Deliverables

1. Secrets inventory
2. Rotation configuration
3. Application integration code
4. Rotation test results
5. Access audit report

### 🎯 Success Criteria

- ✅ All secrets in Secrets Manager
- ✅ RDS password rotates automatically
- ✅ Applications work with rotated secrets
- ✅ Access audited via CloudTrail
- ✅ No secrets in code or config files

---

## Task 5.14: VPC Peering and Transit Gateway Setup

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-514-vpc-peering-and-transit-gateway-setup)**

### 🎬 Real-World Scenario
Your company has multiple VPCs for different environments and needs secure communication between them. Implement VPC peering for simple connections and Transit Gateway for complex hub-and-spoke architecture.

### ⏱️ Time to Complete: 5-6 hours

### 📋 Assignment Instructions

**Your Mission:**
Connect multiple VPCs using VPC Peering and Transit Gateway for complex network topology.

**Requirements:**
1. Set up VPC peering between Production and Management VPCs
2. Deploy Transit Gateway for hub-and-spoke architecture
3. Attach VPCs to Transit Gateway
4. Configure Transit Gateway route tables
5. Update VPC route tables
6. Test connectivity between VPCs
7. Document network architecture

### ✅ Validation Checklist

- [ ] **VPC Peering Established**
- [ ] **Transit Gateway Created**
- [ ] **VPCs Attached to TGW**
- [ ] **Route Tables Configured**
- [ ] **Connectivity Tests Passed**
- [ ] **Network Diagram Created**

### 📦 Required Deliverables

1. Network architecture diagram
2. Peering configuration
3. Transit Gateway configuration
4. Route table configurations
5. Connectivity test results
6. Cost analysis

### 🎯 Success Criteria

- ✅ VPCs can communicate securely
- ✅ Network topology scalable
- ✅ Routing working correctly
- ✅ No public internet traversal
- ✅ Documentation complete

---

## Task 5.15: S3 Bucket Policies and Encryption

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-515-s3-bucket-policies-and-encryption)**

### 🎬 Real-World Scenario
Security audit found S3 buckets with weak encryption and overly permissive policies. Implement strong encryption and least-privilege bucket policies.

### ⏱️ Time to Complete: 3-4 hours

### 📋 Assignment Instructions

**Your Mission:**
Secure S3 buckets with strong encryption and properly scoped bucket policies.

**Requirements:**
1. Enable SSE-KMS encryption on all buckets
2. Create KMS keys for different data classifications
3. Configure bucket policies enforcing encryption
4. Implement bucket policies for least privilege access
5. Enable S3 Block Public Access
6. Set up MFA Delete
7. Configure CORS if needed
8. Audit existing bucket security

### ✅ Validation Checklist

- [ ] **KMS Keys Created**
- [ ] **SSE-KMS Enabled**
- [ ] **Bucket Policies Enforce Encryption**
- [ ] **Access Properly Restricted**
- [ ] **Public Access Blocked**
- [ ] **MFA Delete Enabled**
- [ ] **Audit Complete**

### 📦 Required Deliverables

1. KMS key policies
2. Bucket policies
3. Encryption configuration
4. Security audit report
5. Remediation documentation

### 🎯 Success Criteria

- ✅ All data encrypted at rest
- ✅ Encryption enforced by policy
- ✅ Access properly controlled
- ✅ No public access
- ✅ MFA required for deletion

---

## Task 5.16: CloudTrail for Compliance and Audit Logging

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-516-cloudtrail-for-compliance-and-audit-logging)**

### �� Real-World Scenario
For compliance (SOC 2, HIPAA, PCI), you need comprehensive audit logging of all AWS API calls. Set up CloudTrail with log file validation and integration with CloudWatch for real-time monitoring.

### ⏱️ Time to Complete: 3-4 hours

### 📋 Assignment Instructions

**Your Mission:**
Implement comprehensive audit logging using CloudTrail with log validation and monitoring.

**Requirements:**
1. Create organization-wide CloudTrail
2. Enable log file validation
3. Configure S3 bucket for trail logs
4. Set up CloudWatch Logs integration
5. Create metric filters for security events
6. Set up alarms for suspicious activity
7. Implement log retention and archival
8. Query logs using Athena

### ✅ Validation Checklist

- [ ] **Trail Created**
- [ ] **Multi-Region Enabled**
- [ ] **Log Validation Enabled**
- [ ] **S3 Bucket Secured**
- [ ] **CloudWatch Integration Working**
- [ ] **Metric Filters Created**
- [ ] **Alarms Configured**
- [ ] **Athena Queries Working**

### 📦 Required Deliverables

1. Trail configuration
2. S3 bucket policy
3. CloudWatch integration setup
4. Metric filter definitions
5. Athena query examples
6. Compliance documentation

### 🎯 Success Criteria

- ✅ All API calls logged
- ✅ Logs tamper-proof
- ✅ Real-time alerts for security events
- ✅ Can query historical data
- ✅ Meets compliance requirements

---

## Task 5.17: CloudFormation Infrastructure as Code

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-517-cloudformation-infrastructure-as-code)**

### 🎬 Real-World Scenario
Your infrastructure is manually created making it difficult to replicate environments and track changes. Convert infrastructure to CloudFormation templates for version control and repeatability.

### ⏱️ Time to Complete: 5-6 hours

### 📋 Assignment Instructions

**Your Mission:**
Create CloudFormation templates to deploy entire application infrastructure as code.

**Requirements:**
1. Create modular CloudFormation templates:
   - Network stack (VPC, subnets, route tables)
   - Security stack (Security groups, NACLs)
   - Compute stack (EC2, ALB, Auto Scaling)
   - Database stack (RDS)
   - Storage stack (S3, EFS)
   
2. Use parameters for flexibility
3. Implement cross-stack references
4. Use CloudFormation change sets
5. Set up stack policies
6. Create nested stacks
7. Test full deployment and rollback

### ✅ Validation Checklist

- [ ] **Templates Created**
- [ ] **Parameters Configured**
- [ ] **Cross-Stack References Working**
- [ ] **Change Sets Tested**
- [ ] **Stack Policies Defined**
- [ ] **Deployment Tested**
- [ ] **Rollback Working**

### 📦 Required Deliverables

1. All CloudFormation templates
2. Parameters file
3. Deployment guide
4. Change set examples
5. Rollback procedures
6. Template documentation

### 🎯 Success Criteria

- ✅ Can deploy entire infrastructure from code
- ✅ Templates are modular and reusable
- ✅ Parameters make it flexible
- ✅ Change sets preview changes safely
- ✅ Rollback works reliably

---

## Task 5.18: Cost Optimization and Tagging Strategy

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-518-cost-optimization-and-tagging-strategy)**

### 🎬 Real-World Scenario
AWS costs have increased 40% in 6 months with no clear visibility into where money is being spent. Implement comprehensive tagging strategy and identify cost optimization opportunities.

### ⏱️ Time to Complete: 4-5 hours

### 📋 Assignment Instructions

**Your Mission:**
Implement cost optimization strategies and comprehensive tagging for cost allocation and tracking.

**Requirements:**
1. Define and implement tagging strategy:
   - Environment (production, staging, development)
   - Project/Application
   - Owner/Team
   - Cost Center
   - Expiration date (for temporary resources)
   
2. Tag all existing resources
3. Set up AWS Cost Explorer custom views
4. Create AWS Budgets with alerts
5. Identify cost optimization opportunities:
   - Right-size over-provisioned instances
   - Identify idle resources
   - Recommend Reserved Instances/Savings Plans
   - Find unattached EBS volumes
   - Identify old snapshots
   
6. Implement cost allocation tags
7. Create cost optimization dashboard
8. Generate monthly cost report

### ✅ Validation Checklist

- [ ] **Tagging Strategy Defined**
- [ ] **All Resources Tagged**
- [ ] **Cost Explorer Configured**
- [ ] **Budgets Set Up**
- [ ] **Optimization Opportunities Identified**
- [ ] **Cost Allocation Tags Enabled**
- [ ] **Dashboard Created**
- [ ] **Reports Automated**

### 📦 Required Deliverables

1. Tagging strategy document
2. Tagging compliance report (% of resources tagged)
3. Cost Explorer custom views
4. Budget configurations
5. Cost optimization recommendations with projected savings
6. Reserved Instance/Savings Plan analysis
7. Monthly cost report template
8. Cost optimization dashboard

### 🎯 Success Criteria

- ✅ 100% of resources properly tagged
- ✅ Can track costs by environment/project/team
- ✅ Budget alerts prevent overspending
- ✅ Cost optimization recommendations total 20-30% savings
- ✅ Monthly cost reporting automated
- ✅ Team has cost visibility
- ✅ Cost accountability established

---

## All Real-World Tasks Complete! 🎉

You now have **18 comprehensive, executable AWS tasks** for DevOps engineers, each with:
- Clear real-world scenarios
- Time estimates
- Detailed requirements
- Validation checklists
- Expected deliverables
- Success criteria

These tasks cover the complete AWS foundation needed for real DevOps work and interview preparation!

---

## 📊 Time Estimates Summary

| Task | Difficulty | Time | AWS Services |
|------|-----------|------|--------------|
| 5.1 | Medium | 4-5h | VPC, IGW, NAT |
| 5.2 | Medium | 3-4h | IAM |
| 5.3 | Medium | 3-4h | Security Groups, NACLs |
| 5.4 | Medium | 3-4h | EC2, Systems Manager |
| 5.5 | Medium | 4-5h | RDS |
| 5.6 | Easy | 2-3h | S3, Lifecycle |
| 5.7 | Medium | 3-4h | ECR |
| 5.8 | Medium | 3-4h | CloudWatch Logs |
| 5.9 | Easy | 2-3h | CloudWatch, SNS |
| 5.10 | Hard | 4-6h | Lambda, EventBridge |
| 5.11 | Hard | 4-5h | EKS, IAM OIDC |
| 5.12 | Easy | 1-2h | Parameter Store |
| 5.13 | Easy | 2-3h | Secrets Manager |
| 5.14 | Hard | 5-6h | VPC Peering, TGW |
| 5.15 | Medium | 3-4h | S3, KMS |
| 5.16 | Medium | 3-4h | CloudTrail |
| 5.17 | Hard | 5-6h | CloudFormation |
| 5.18 | Hard | 4-5h | Cost Explorer, Tags |

**Total: 18 Tasks | Total Time: ~60-75 hours**

---

## Tips for Success

### For Beginners
✅ Start with easier tasks (5.6, 5.12, 5.13, 5.9)
✅ Use AWS Free Tier to practice
✅ Focus on understanding concepts
✅ Build progressively on previous tasks

### For Interview Preparation
✅ Focus on high-frequency topics (VPC, IAM, S3, RDS)
✅ Practice explaining architectures
✅ Understand trade-offs
✅ Know cost implications

### For Production
✅ Always consider security first
✅ Implement proper monitoring
✅ Document everything
✅ Plan for disaster recovery
✅ Consider costs

---

**Ready to start? Pick a task and dive in! For complete solutions, see [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)**

**Document Version**: 1.0  
**Last Updated**: November 2025  
**Author**: DevOps Tasks 2026 Team
