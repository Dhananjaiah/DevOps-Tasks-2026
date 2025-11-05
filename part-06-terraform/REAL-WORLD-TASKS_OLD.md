# Terraform Infrastructure as Code Real-World Tasks for DevOps Engineers

## 🎯 Overview

This document provides **real-world, executable Terraform Infrastructure as Code tasks** designed as sprint assignments. Each task simulates actual production scenarios that DevOps engineers handle daily.

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

## Task 6.1: Build Modular VPC Infrastructure with Terraform

### 🎬 Real-World Scenario
Create reusable Terraform modules for VPC infrastructure that can be used across dev, staging, and prod environments with different configurations.

### ⏱️ Time to Complete: 4-5 hours (Sprint: 1 story points)

### 📋 Assignment Instructions

**Your Mission:**
Build Modular VPC Infrastructure with Terraform

**Requirements:**
1. Create VPC module with inputs and outputs
2. Implement subnet module for public/private subnets
3. Create NAT Gateway and Internet Gateway modules
4. Set up route table configurations
5. Implement proper tagging strategy
6. Create examples for each environment

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Create VPC module with inputs and outputs
- [ ] Implement subnet module for public/private subnets
- [ ] Create NAT Gateway and Internet Gateway modules

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code/configs follow best practices
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

## Task 6.2: Implement Remote State with S3 and DynamoDB Locking

### 🎬 Real-World Scenario
Multiple team members are working on infrastructure causing state conflicts. Implement remote state backend with locking to prevent conflicts.

### ⏱️ Time to Complete: 2-3 hours (Sprint: 0.5 story points)

### 📋 Assignment Instructions

**Your Mission:**
Implement Remote State with S3 and DynamoDB Locking

**Requirements:**
1. Create S3 bucket for state storage
2. Enable versioning and encryption
3. Create DynamoDB table for state locking
4. Configure backend in Terraform
5. Implement state backup strategy
6. Document state management procedures

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Create S3 bucket for state storage
- [ ] Enable versioning and encryption
- [ ] Create DynamoDB table for state locking

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code/configs follow best practices
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

## Task 6.3: Provision EKS Cluster with Terraform

### 🎬 Real-World Scenario
Automate the provisioning of a production-ready EKS cluster with node groups, IRSA, and cluster addons using Terraform.

### ⏱️ Time to Complete: 5-6 hours (Sprint: 1 story points)

### 📋 Assignment Instructions

**Your Mission:**
Provision EKS Cluster with Terraform

**Requirements:**
1. Create EKS cluster module
2. Configure managed node groups
3. Set up IAM roles for service accounts (IRSA)
4. Install cluster addons (VPC CNI, CoreDNS)
5. Configure cluster logging
6. Implement node auto-scaling

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Create EKS cluster module
- [ ] Configure managed node groups
- [ ] Set up IAM roles for service accounts (IRSA)

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code/configs follow best practices
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

## Task 6.4: Create Multi-Environment Infrastructure Setup

### 🎬 Real-World Scenario
Manage infrastructure for dev, staging, and prod using Terraform workspaces or separate state files with environment-specific variables.

### ⏱️ Time to Complete: 4-5 hours (Sprint: 1 story points)

### 📋 Assignment Instructions

**Your Mission:**
Create Multi-Environment Infrastructure Setup

**Requirements:**
1. Design multi-environment strategy
2. Create environment-specific variable files
3. Implement workspace or directory structure
4. Set up environment isolation
5. Configure environment-specific resources
6. Document deployment procedures

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Design multi-environment strategy
- [ ] Create environment-specific variable files
- [ ] Implement workspace or directory structure

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code/configs follow best practices
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

## Task 6.5: Implement Terraform CI/CD Pipeline

### 🎬 Real-World Scenario
Automate Terraform workflows with CI/CD pipeline for plan, validate, and apply operations with proper approval gates.

### ⏱️ Time to Complete: 4-5 hours (Sprint: 1 story points)

### 📋 Assignment Instructions

**Your Mission:**
Implement Terraform CI/CD Pipeline

**Requirements:**
1. Create CI/CD pipeline for Terraform
2. Implement terraform fmt, validate, and plan
3. Set up approval gates for apply
4. Configure drift detection
5. Implement cost estimation
6. Set up notifications for changes

**Environment:**
- Production-like infrastructure
- Access to necessary tools and credentials
- Support from team for blockers

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

**Core Implementation:**
- [ ] Create CI/CD pipeline for Terraform
- [ ] Implement terraform fmt, validate, and plan
- [ ] Set up approval gates for apply

**Testing & Validation:**
- [ ] All components tested individually
- [ ] Integration testing completed
- [ ] Performance validated
- [ ] Security review passed
- [ ] Documentation completed

**Quality Checks:**
- [ ] Code/configs follow best practices
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
- Tasks: 6.2
- Good for new team members
- Can be completed in 1-2 sprint days

**Medium (1 story point):**
- Tasks: 6.1, 6.3, 6.4, 6.5
- Requires solid terraform experience
- May need 2-3 sprint days

### Recommended Sprint Assignment

**Sprint Week 1:**
- Days 1-2: Task 6.1
- Days 3-4: Task 6.2

**Sprint Week 2:**
- Days 1-2: Task 6.3
- Days 3-4: Task 6.4

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
- Industry standards and guidelines
- Official tool documentation
- Community best practices

### Learning Resources
- Official documentation
- Tutorials and guides
- Video courses and workshops
- Community forums

---

**Ready to start? Pick a task and dive in! For complete solutions, see [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)**
