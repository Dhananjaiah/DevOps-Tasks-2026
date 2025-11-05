# AWS Cloud Foundation Real-World Tasks for DevOps Engineers

## 🎯 Overview

This document provides **real-world, executable AWS Cloud Foundation tasks** designed as sprint assignments. Each task simulates actual production scenarios that DevOps engineers handle daily.

**What You'll Find:**
- Clear scenarios with business context
- Time estimates for sprint planning
- Step-by-step assignment instructions
- Validation checklists
- Expected deliverables
- Sprint-ready task format

---

## How to Use This Guide

### For Managers/Team Leads:
1. Assign tasks based on engineer skill level and sprint capacity
2. Use time estimates for sprint planning
3. Verify completion using validation checklists
4. Review deliverables for quality and completeness

### For DevOps Engineers:
1. Read the scenario and understand business requirements
2. Plan your approach within the time estimate
3. Implement the solution following best practices
4. Test thoroughly using validation criteria
5. Submit deliverables with documentation

---

## Task 5.1: Design and Implement Production VPC

### 🎬 Real-World Scenario
Design a production-ready VPC with public/private subnets across 3 AZs, NAT Gateways, and proper routing for a 3-tier application.

### ⏱️ Time to Complete: 4-5 hours (Sprint: 1 story points)

### 📋 Assignment Instructions

**Your Mission:**
Design and Implement Production VPC

**Requirements:**
1. Create VPC with /16 CIDR block
2. Create public and private subnets in 3 AZs
3. Set up Internet Gateway and NAT Gateways
4. Configure route tables
5. Implement VPC Flow Logs
6. Document IP addressing scheme

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Create VPC with /16 CIDR block
- [ ] Create public and private subnets in 3 AZs
- [ ] Set up Internet Gateway and NAT Gateways

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code follows best practices
- [ ] Error handling implemented
- [ ] Logging configured
- [ ] Monitoring set up
- [ ] Backup/rollback plan exists

### 📦 Deliverables

1. **Implementation**: Complete working solution
2. **Configuration**: All configuration files
3. **Documentation**: Setup and usage guide
4. **Tests**: Test results and validation logs
5. **Runbook**: Operations and troubleshooting guide

### 🎯 Success Criteria

- Solution works in production-like environment
- Meets all requirements
- Passes all validation checks
- Team can use/maintain the solution
- Documentation is clear and complete

---

## Task 5.2: Implement IAM Roles and Policies (Least Privilege)

### 🎬 Real-World Scenario
Create IAM roles and policies following least privilege principle for EC2, EKS, and CI/CD pipelines.

### ⏱️ Time to Complete: 3-4 hours (Sprint: 0.5 story points)

### 📋 Assignment Instructions

**Your Mission:**
Implement IAM Roles and Policies (Least Privilege)

**Requirements:**
1. Create IAM roles for EC2 instances
2. Create EKS service role and node role
3. Create CI/CD pipeline roles
4. Implement custom policies
5. Set up IAM password policy
6. Enable MFA for human users

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Create IAM roles for EC2 instances
- [ ] Create EKS service role and node role
- [ ] Create CI/CD pipeline roles

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code follows best practices
- [ ] Error handling implemented
- [ ] Logging configured
- [ ] Monitoring set up
- [ ] Backup/rollback plan exists

### 📦 Deliverables

1. **Implementation**: Complete working solution
2. **Configuration**: All configuration files
3. **Documentation**: Setup and usage guide
4. **Tests**: Test results and validation logs
5. **Runbook**: Operations and troubleshooting guide

### 🎯 Success Criteria

- Solution works in production-like environment
- Meets all requirements
- Passes all validation checks
- Team can use/maintain the solution
- Documentation is clear and complete

---

## Task 5.3: Configure Security Groups and NACLs

### 🎬 Real-World Scenario
Implement defense-in-depth network security using Security Groups and Network ACLs for the 3-tier application.

### ⏱️ Time to Complete: 3-4 hours (Sprint: 0.5 story points)

### 📋 Assignment Instructions

**Your Mission:**
Configure Security Groups and NACLs

**Requirements:**
1. Create Security Groups for each tier
2. Implement least privilege access rules
3. Configure NACLs for subnet-level control
4. Set up bastion host security
5. Document security group rules
6. Implement security group change tracking

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Create Security Groups for each tier
- [ ] Implement least privilege access rules
- [ ] Configure NACLs for subnet-level control

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code follows best practices
- [ ] Error handling implemented
- [ ] Logging configured
- [ ] Monitoring set up
- [ ] Backup/rollback plan exists

### 📦 Deliverables

1. **Implementation**: Complete working solution
2. **Configuration**: All configuration files
3. **Documentation**: Setup and usage guide
4. **Tests**: Test results and validation logs
5. **Runbook**: Operations and troubleshooting guide

### 🎯 Success Criteria

- Solution works in production-like environment
- Meets all requirements
- Passes all validation checks
- Team can use/maintain the solution
- Documentation is clear and complete

---

## Task 5.4: Set Up RDS PostgreSQL with Multi-AZ

### 🎬 Real-World Scenario
Deploy RDS PostgreSQL with high availability, automated backups, read replicas, and proper security configuration.

### ⏱️ Time to Complete: 3-4 hours (Sprint: 0.5 story points)

### 📋 Assignment Instructions

**Your Mission:**
Set Up RDS PostgreSQL with Multi-AZ

**Requirements:**
1. Create RDS PostgreSQL instance
2. Enable Multi-AZ deployment
3. Configure automated backups
4. Create read replica
5. Set up parameter groups
6. Implement encryption at rest

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Create RDS PostgreSQL instance
- [ ] Enable Multi-AZ deployment
- [ ] Configure automated backups

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code follows best practices
- [ ] Error handling implemented
- [ ] Logging configured
- [ ] Monitoring set up
- [ ] Backup/rollback plan exists

### 📦 Deliverables

1. **Implementation**: Complete working solution
2. **Configuration**: All configuration files
3. **Documentation**: Setup and usage guide
4. **Tests**: Test results and validation logs
5. **Runbook**: Operations and troubleshooting guide

### 🎯 Success Criteria

- Solution works in production-like environment
- Meets all requirements
- Passes all validation checks
- Team can use/maintain the solution
- Documentation is clear and complete

---

## Task 5.5: Implement CloudWatch Monitoring and Alerting

### 🎬 Real-World Scenario
Set up comprehensive monitoring and alerting for infrastructure and applications using CloudWatch.

### ⏱️ Time to Complete: 4-5 hours (Sprint: 1 story points)

### 📋 Assignment Instructions

**Your Mission:**
Implement CloudWatch Monitoring and Alerting

**Requirements:**
1. Configure CloudWatch agent on EC2
2. Create custom metrics
3. Set up CloudWatch Alarms
4. Create SNS topics for notifications
5. Configure log aggregation
6. Build CloudWatch dashboard

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Configure CloudWatch agent on EC2
- [ ] Create custom metrics
- [ ] Set up CloudWatch Alarms

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code follows best practices
- [ ] Error handling implemented
- [ ] Logging configured
- [ ] Monitoring set up
- [ ] Backup/rollback plan exists

### 📦 Deliverables

1. **Implementation**: Complete working solution
2. **Configuration**: All configuration files
3. **Documentation**: Setup and usage guide
4. **Tests**: Test results and validation logs
5. **Runbook**: Operations and troubleshooting guide

### 🎯 Success Criteria

- Solution works in production-like environment
- Meets all requirements
- Passes all validation checks
- Team can use/maintain the solution
- Documentation is clear and complete

---

## Task 5.6: Configure S3 and CloudFront for Static Assets

### 🎬 Real-World Scenario
Set up S3 bucket with CloudFront CDN for serving static assets with proper security and caching.

### ⏱️ Time to Complete: 3-4 hours (Sprint: 0.5 story points)

### 📋 Assignment Instructions

**Your Mission:**
Configure S3 and CloudFront for Static Assets

**Requirements:**
1. Create S3 bucket with versioning
2. Configure bucket policies
3. Set up CloudFront distribution
4. Implement cache behaviors
5. Configure SSL certificate
6. Set up origin access identity

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Create S3 bucket with versioning
- [ ] Configure bucket policies
- [ ] Set up CloudFront distribution

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code follows best practices
- [ ] Error handling implemented
- [ ] Logging configured
- [ ] Monitoring set up
- [ ] Backup/rollback plan exists

### 📦 Deliverables

1. **Implementation**: Complete working solution
2. **Configuration**: All configuration files
3. **Documentation**: Setup and usage guide
4. **Tests**: Test results and validation logs
5. **Runbook**: Operations and troubleshooting guide

### 🎯 Success Criteria

- Solution works in production-like environment
- Meets all requirements
- Passes all validation checks
- Team can use/maintain the solution
- Documentation is clear and complete

---


## Sprint Planning Guidelines

### Task Complexity Ratings

**Simple (0.5 story points):**
- Tasks: 5.2, 5.3, 5.4, 5.6
- Good for new team members
- Can be completed in 1-2 sprint days

**Medium (1 story point):**
- Tasks: 5.1, 5.5
- Requires solid aws cloud foundation experience
- May need 2-3 sprint days

### Recommended Sprint Assignment

**Sprint Week 1:**
- Days 1-2: Task 5.1
- Days 3-4: Task 5.2

**Sprint Week 2:**
- Days 1-2: Task 5.3
- Days 3-4: Task 5.4

### Skill Level Requirements

**Junior DevOps Engineer:**
- Start with: 0.5 point tasks
- Focus on learning and documentation

**Mid-Level DevOps Engineer:**
- Can handle: 0.5 to 1 point tasks
- Expected to complete independently

**Senior DevOps Engineer:**
- Can handle: 1+ point tasks
- May work on multiple tasks simultaneously
- Provides guidance to junior team members

---

## Additional Resources

### Best Practices
- [Industry standards and guidelines]
- [Tool documentation]
- [Community resources]

### Learning Resources
- [Official documentation]
- [Tutorials and guides]
- [Video courses]

---

**Ready to start? Pick a task and dive in! For complete solutions, see [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)**
