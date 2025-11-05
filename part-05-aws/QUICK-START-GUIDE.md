# AWS Quick Start Guide

> **🚀 Fast access to AWS tasks, commands, and resources**

## 📋 Quick Task Lookup Table

| # | Task Name | Difficulty | Time | AWS Services | Page |
|---|-----------|------------|------|--------------|------|
| 5.1 | VPC Design with Public/Private Subnets | Medium | 4-6h | VPC, IGW, NAT | [README](README.md#task-51-vpc-design-with-public-and-private-subnets) |
| 5.2 | IAM Roles and Policies (Least Privilege) | Medium | 3-4h | IAM | [README](README.md#task-52-iam-roles-and-policies-least-privilege) |
| 5.3 | Security Groups and NACLs | Medium | 3-4h | EC2 (SG), VPC (NACL) | [README](README.md#task-53-security-groups-and-nacls-configuration) |
| 5.4 | EC2 Instance Setup (Bastion, Application) | Medium | 3-4h | EC2, Systems Manager | [README](README.md#task-54-ec2-instance-setup-bastion-jenkins) |
| 5.5 | RDS PostgreSQL Database Setup | Medium | 4-5h | RDS, Parameter Groups | [README](README.md#task-55-rds-postgresql-database-setup) |
| 5.6 | S3 Buckets for Artifacts and Backups | Easy | 2-3h | S3, Lifecycle Policies | [README](README.md#task-56-s3-buckets-for-artifacts-and-backups) |
| 5.7 | ECR Repository for Container Images | Medium | 3-4h | ECR, Docker | [README](README.md#task-57-ecr-repository-for-container-images) |
| 5.8 | CloudWatch Logs and Metrics | Medium | 3-4h | CloudWatch Logs | [README](README.md#task-58-cloudwatch-logs-and-metrics) |
| 5.9 | CloudWatch Alarms and Notifications | Easy | 2-3h | CloudWatch, SNS | [README](README.md#task-59-cloudwatch-alarms-and-notifications) |
| 5.10 | Lambda Functions for Automation | Hard | 4-6h | Lambda, EventBridge | [README](README.md#task-510-lambda-functions-for-automation) |
| 5.11 | IAM Roles for EKS and CI/CD | Hard | 4-5h | IAM, EKS, OIDC | [README](README.md#task-511-iam-roles-for-eks-and-cicd) |
| 5.12 | AWS Systems Manager Parameter Store | Easy | 1-2h | Systems Manager | [README](README.md#task-512-aws-systems-manager-parameter-store) |
| 5.13 | AWS Secrets Manager Integration | Easy | 2-3h | Secrets Manager | [README](README.md#task-513-aws-secrets-manager-integration) |
| 5.14 | VPC Peering and Transit Gateway | Hard | 5-6h | VPC, Transit Gateway | [README](README.md#task-514-vpc-peering-and-transit-gateway-basics) |
| 5.15 | S3 Bucket Policies and Encryption | Medium | 3-4h | S3, KMS | [README](README.md#task-515-s3-bucket-policies-and-encryption) |
| 5.16 | CloudTrail for Audit Logging | Medium | 3-4h | CloudTrail, S3 | [README](README.md#task-516-cloudtrail-for-audit-logging) |
| 5.17 | CloudFormation / Infrastructure as Code | Hard | 5-6h | CloudFormation | [README](README.md#task-517-cloudformation-infrastructure-as-code) |
| 5.18 | Cost Optimization and Tagging Strategy | Hard | 4-5h | Cost Explorer, Budgets | [README](README.md#task-518-cost-optimization-and-tagging-strategy) |

**Total: 18 Tasks | Total Time: ~60-75 hours**

---

## 🎯 Learning Paths by Role

### Path 1: Junior DevOps Engineer (Start Here)
**Focus: Foundation → Storage → Monitoring**

```
Week 1-2: Foundation (Easy → Medium)
  Day 1-2:  Task 5.6  - S3 Buckets (Easy)
  Day 3-4:  Task 5.12 - Parameter Store (Easy)
  Day 5-7:  Task 5.1  - VPC Design (Medium)
  Day 8-9:  Task 5.2  - IAM Basics (Medium)
  Day 10:   Task 5.9  - CloudWatch Alarms (Easy)

Week 3: Practice & Consolidation
  ├── Review all tasks
  ├── Build end-to-end solution
  └── Document learnings
```

### Path 2: Mid-Level DevOps Engineer
**Focus: Production-Ready Infrastructure**

```
Week 1: Networking & Security
  Task 5.1  - VPC Design
  Task 5.2  - IAM Roles and Policies
  Task 5.3  - Security Groups and NACLs
  Task 5.4  - EC2 Setup

Week 2: Data & Containers
  Task 5.5  - RDS PostgreSQL
  Task 5.6  - S3 Buckets
  Task 5.7  - ECR Repository

Week 3: Monitoring & Advanced
  Task 5.8  - CloudWatch Logs
  Task 5.9  - CloudWatch Alarms
  Task 5.10 - Lambda Functions
  Task 5.13 - Secrets Manager

Week 4: Architecture & Optimization
  Task 5.14 - VPC Peering/TGW
  Task 5.17 - CloudFormation
  Task 5.18 - Cost Optimization
```

### Path 3: Senior DevOps Engineer
**Focus: Architecture & Best Practices**

```
Week 1: Advanced Architecture
  ├── Task 5.14 - VPC Peering/Transit Gateway
  ├── Task 5.11 - EKS IAM Roles
  └── Task 5.17 - Infrastructure as Code

Week 2: Security & Compliance
  ├── Task 5.15 - S3 Security
  ├── Task 5.16 - CloudTrail
  └── Task 5.2  - Advanced IAM

Week 3: Optimization & Automation
  ├── Task 5.10 - Lambda Automation
  ├── Task 5.18 - Cost Optimization
  └── Integration project
```

### Path 4: Interview Preparation (2 Weeks Intensive)
**Focus: Common interview topics**

```
Week 1: Core Services (Most Asked)
  Day 1:    Task 5.1  - VPC (High frequency)
  Day 2:    Task 5.2  - IAM (Critical)
  Day 3:    Task 5.3  - Security Groups
  Day 4:    Task 5.5  - RDS (High frequency)
  Day 5:    Task 5.6  - S3 (Very common)

Week 2: Advanced Topics
  Day 6:    Task 5.8  - CloudWatch
  Day 7:    Task 5.10 - Lambda
  Day 8:    Task 5.11 - EKS IAM
  Day 9:    Task 5.17 - IaC
  Day 10:   Task 5.18 - Cost Optimization
  
Practice: Mock interviews & system design
```

---

## ⚡ Quick Command Reference

### AWS CLI Setup
```bash
# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure credentials
aws configure
# Enter: Access Key ID, Secret Access Key, Region, Output format

# Test configuration
aws sts get-caller-identity

# Use profiles
aws configure --profile dev
aws s3 ls --profile dev
```

### Common AWS Commands by Service

#### VPC
```bash
# List VPCs
aws ec2 describe-vpcs

# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create subnet
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.1.0/24

# Describe subnets
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-xxx"
```

#### EC2
```bash
# List instances
aws ec2 describe-instances

# Launch instance
aws ec2 run-instances --image-id ami-xxx --instance-type t3.micro

# Stop/Start instance
aws ec2 stop-instances --instance-ids i-xxx
aws ec2 start-instances --instance-ids i-xxx

# Connect via SSM
aws ssm start-session --target i-xxx
```

#### S3
```bash
# List buckets
aws s3 ls

# Create bucket
aws s3 mb s3://my-bucket

# Upload file
aws s3 cp file.txt s3://my-bucket/

# Sync directory
aws s3 sync ./local-dir s3://my-bucket/prefix/

# Download file
aws s3 cp s3://my-bucket/file.txt ./
```

#### IAM
```bash
# List users
aws iam list-users

# Create user
aws iam create-user --user-name john

# Create role
aws iam create-role --role-name MyRole --assume-role-policy-document file://trust-policy.json

# Attach policy
aws iam attach-role-policy --role-name MyRole --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess
```

#### RDS
```bash
# List databases
aws rds describe-db-instances

# Create database
aws rds create-db-instance \
  --db-instance-identifier mydb \
  --db-instance-class db.t3.micro \
  --engine postgres

# Create snapshot
aws rds create-db-snapshot --db-snapshot-identifier mydb-snapshot --db-instance-identifier mydb
```

#### CloudWatch
```bash
# List log groups
aws logs describe-log-groups

# Create log group
aws logs create-log-group --log-group-name /aws/application/myapp

# Query logs
aws logs filter-log-events --log-group-name /aws/application/myapp --filter-pattern "ERROR"

# Put metric data
aws cloudwatch put-metric-data --namespace MyApp --metric-name ResponseTime --value 100
```

#### Lambda
```bash
# List functions
aws lambda list-functions

# Create function
aws lambda create-function \
  --function-name my-function \
  --runtime python3.9 \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://function.zip \
  --role arn:aws:iam::123456789012:role/lambda-role

# Invoke function
aws lambda invoke --function-name my-function output.txt
```

---

## 📊 Task Difficulty & Prerequisites Matrix

| Task | Difficulty | Prerequisites | AWS Knowledge Required |
|------|-----------|---------------|------------------------|
| 5.1 | ⭐⭐⭐ | Networking basics | VPC, Subnets, Routing |
| 5.2 | ⭐⭐⭐ | Security concepts | IAM, Policies, JSON |
| 5.3 | ⭐⭐ | Networking, Firewalls | Security Groups, NACLs |
| 5.4 | ⭐⭐⭐ | Linux, SSH | EC2, AMI, User Data |
| 5.5 | ⭐⭐⭐ | Databases, SQL | RDS, Parameter Groups |
| 5.6 | ⭐ | File storage | S3, Lifecycle Policies |
| 5.7 | ⭐⭐ | Docker basics | ECR, Docker |
| 5.8 | ⭐⭐⭐ | Logging concepts | CloudWatch Logs |
| 5.9 | ⭐⭐ | Monitoring basics | CloudWatch Alarms, SNS |
| 5.10 | ⭐⭐⭐⭐ | Python/Node.js | Lambda, EventBridge |
| 5.11 | ⭐⭐⭐⭐ | Kubernetes, OIDC | EKS, IRSA |
| 5.12 | ⭐ | Configuration mgmt | Systems Manager |
| 5.13 | ⭐⭐ | Secrets management | Secrets Manager |
| 5.14 | ⭐⭐⭐⭐ | Advanced networking | VPC Peering, TGW |
| 5.15 | ⭐⭐⭐ | Encryption, Security | S3, KMS, Bucket Policies |
| 5.16 | ⭐⭐⭐ | Compliance, Auditing | CloudTrail, Athena |
| 5.17 | ⭐⭐⭐⭐ | IaC, YAML/JSON | CloudFormation |
| 5.18 | ⭐⭐⭐⭐ | Cost management | Cost Explorer, Tags |

**Legend:**
- ⭐ = Beginner (1-2 hours)
- ⭐⭐ = Easy (2-3 hours)
- ⭐⭐⭐ = Medium (3-5 hours)
- ⭐⭐⭐⭐ = Advanced (5-6 hours)

---

## 🔥 Most Frequently Asked in Interviews

### Top 10 AWS Interview Topics (Based on frequency)

1. **VPC Design** (Task 5.1) - ⭐⭐⭐⭐⭐ Very High
   - Subnets, routing, NAT Gateway vs NAT Instance
   - Multi-AZ architecture
   - CIDR planning

2. **IAM** (Task 5.2) - ⭐⭐⭐⭐⭐ Very High
   - Roles vs Users vs Groups
   - Least privilege principle
   - Cross-account access

3. **S3** (Task 5.6, 5.15) - ⭐⭐⭐⭐⭐ Very High
   - Bucket policies vs IAM policies
   - Encryption options
   - Versioning and lifecycle

4. **Security Groups** (Task 5.3) - ⭐⭐⭐⭐ High
   - Stateful vs stateless
   - Security Groups vs NACLs
   - Best practices

5. **RDS** (Task 5.5) - ⭐⭐⭐⭐ High
   - Multi-AZ vs Read Replicas
   - Backup strategies
   - Parameter groups

6. **CloudWatch** (Task 5.8, 5.9) - ⭐⭐⭐⭐ High
   - Metrics and alarms
   - Log aggregation
   - Custom metrics

7. **Lambda** (Task 5.10) - ⭐⭐⭐ Medium
   - Event-driven architecture
   - Cold starts
   - Best practices

8. **EC2** (Task 5.4) - ⭐⭐⭐ Medium
   - Instance types
   - Auto Scaling
   - Placement groups

9. **Cost Optimization** (Task 5.18) - ⭐⭐⭐ Medium
   - Reserved instances vs Spot
   - Cost allocation tags
   - Right-sizing

10. **CloudFormation** (Task 5.17) - ⭐⭐⭐ Medium
    - IaC best practices
    - Stack management
    - Change sets

---

## 🎓 Study Tips

### For Beginners
✅ Start with foundational tasks (5.6, 5.12, 5.9)
✅ Use AWS Free Tier for hands-on practice
✅ Focus on understanding concepts, not memorizing
✅ Build a simple 3-tier application end-to-end
✅ Document everything you learn

### For Interview Prep
✅ Focus on Top 10 interview topics above
✅ Practice explaining architectures verbally
✅ Understand "why" not just "how"
✅ Learn trade-offs between different approaches
✅ Practice whiteboard diagramming

### For Production Readiness
✅ Always consider security first
✅ Plan for high availability
✅ Implement proper monitoring
✅ Consider cost implications
✅ Document disaster recovery procedures

---

## 📚 Resource Links

### AWS Documentation
- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [AWS Best Practices](https://aws.amazon.com/architecture/best-practices/)

### Learning Resources
- [AWS Free Tier](https://aws.amazon.com/free/)
- [AWS Training and Certification](https://aws.amazon.com/training/)
- [AWS Workshops](https://workshops.aws/)
- [AWS Solutions Library](https://aws.amazon.com/solutions/)

### Tools
- [AWS CLI](https://aws.amazon.com/cli/)
- [AWS SDK](https://aws.amazon.com/tools/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [CloudFormation](https://aws.amazon.com/cloudformation/)

---

## 🚦 Getting Started Checklist

### Before You Begin
- [ ] AWS account created
- [ ] AWS CLI installed and configured
- [ ] Basic understanding of cloud concepts
- [ ] Chosen a learning path above
- [ ] Decided on hands-on vs reading first

### Setup Your Environment
- [ ] Install AWS CLI v2
- [ ] Configure default profile
- [ ] Set up MFA for account
- [ ] Create IAM user for practice (not root)
- [ ] Understand AWS Free Tier limits

### As You Learn
- [ ] Take notes on each task
- [ ] Create your own cheat sheets
- [ ] Build a sample project
- [ ] Practice explaining concepts
- [ ] Join AWS community forums

---

## 💰 Cost Awareness

### Free Tier Eligible Services
✅ EC2: 750 hours/month t2.micro (12 months)
✅ RDS: 750 hours/month (12 months)
✅ S3: 5GB storage (12 months)
✅ Lambda: 1M requests/month (always free)
✅ CloudWatch: 10 metrics (always free)

### Watch Out For Costs
⚠️ NAT Gateway: ~$0.045/hour + data transfer
⚠️ RDS Multi-AZ: Double the cost
⚠️ Data transfer out: Can add up quickly
⚠️ EBS volumes: Charged even when stopped
⚠️ Elastic IPs: Charged when not attached

### Cost-Saving Tips
💡 Use AWS Budget alerts
💡 Tag all resources for cost tracking
💡 Delete unused resources immediately
💡 Use spot instances for dev/test
💡 Stop (don't just pause) instances when not in use

---

## 🎯 Next Steps

### Just Starting?
1. Read [NAVIGATION-GUIDE.md](NAVIGATION-GUIDE.md) to understand structure
2. Pick your learning path above
3. Start with Task 5.6 (S3 - easiest)
4. Progress to Task 5.1 (VPC - foundation)

### Ready to Practice?
1. Go to [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)
2. Choose a task matching your level
3. Set a timer for the estimated duration
4. Try to complete it without checking solutions
5. Compare your solution with [REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)

### Want Deep Understanding?
1. Go to [README.md](README.md)
2. Study each task in detail
3. Practice the interview questions
4. Try the troubleshooting scenarios
5. Build variations of the examples

---

## 🏆 Mastery Checklist

You've mastered AWS when you can:

### Core Skills
- [ ] Design a production VPC from scratch
- [ ] Implement least-privilege IAM policies
- [ ] Configure multi-tier application security
- [ ] Set up high-availability database
- [ ] Implement comprehensive monitoring

### Advanced Skills
- [ ] Design multi-region architecture
- [ ] Implement disaster recovery
- [ ] Automate infrastructure with IaC
- [ ] Optimize costs across accounts
- [ ] Pass AWS Solutions Architect Associate exam

### Production Skills
- [ ] Lead infrastructure design discussions
- [ ] Troubleshoot production issues independently
- [ ] Mentor junior team members
- [ ] Implement security best practices
- [ ] Handle on-call incidents

---

**Happy Learning! 🚀**

*This quick start guide is your launchpad to AWS mastery.*

---

**Document Version**: 1.0  
**Last Updated**: November 2025  
**Maintained by**: DevOps Tasks 2026 Team
