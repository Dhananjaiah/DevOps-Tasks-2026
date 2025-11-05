# Part 5: AWS Cloud Foundation

## Overview
Production-ready AWS infrastructure setup for cloud-native applications.

## Tasks Overview
1. **Task 5.1**: VPC Design with Public and Private Subnets
2. **Task 5.2**: IAM Roles and Policies (Least Privilege)
3. **Task 5.3**: Security Groups and NACLs Configuration
4. **Task 5.4**: EC2 Instance Setup (Bastion, Jenkins)
5. **Task 5.5**: RDS PostgreSQL Database Setup
6. **Task 5.6**: S3 Buckets for Artifacts and Backups
7. **Task 5.7**: ECR Repository for Container Images
8. **Task 5.8**: CloudWatch Logs and Metrics
9. **Task 5.9**: CloudWatch Alarms and Notifications
10. **Task 5.10**: Route Tables and NAT Gateway Configuration
11. **Task 5.11**: IAM Roles for EKS and CI/CD
12. **Task 5.12**: AWS Systems Manager Parameter Store
13. **Task 5.13**: AWS Secrets Manager Integration
14. **Task 5.14**: VPC Peering and Transit Gateway Basics
15. **Task 5.15**: S3 Bucket Policies and Encryption
16. **Task 5.16**: CloudTrail for Audit Logging

For detailed implementations, see [COMPREHENSIVE_GUIDE.md](../COMPREHENSIVE_GUIDE.md#part-5-aws-cloud-foundation)

## Quick Start
```bash
# Configure AWS CLI
aws configure

# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```

Continue to [Part 6: Terraform](../part-06-terraform/README.md)
