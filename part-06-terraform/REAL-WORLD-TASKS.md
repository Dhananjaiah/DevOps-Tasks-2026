# Part 6: Terraform Real-World Tasks for DevOps Engineers

> **📚 Navigation:** [Solutions →](./REAL-WORLD-TASKS-SOLUTIONS.md) | [Part 6 README](./README.md) | [Main README](../README.md)

## 🎯 Overview

This document provides **real-world, executable Terraform tasks** that you can assign to DevOps engineers. Each task includes:
- **Clear scenario and context**
- **Time estimate for completion**
- **Step-by-step assignment instructions**
- **Validation checklist**
- **Expected deliverables**

These tasks are designed to be practical assignments that simulate actual production work with Infrastructure as Code.

> **💡 Looking for solutions?** Complete solutions with step-by-step implementations are available in [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)

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
| 6.1 | [Terraform Project Setup](#task-61-terraform-project-setup-and-best-practices) | Easy | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-61-terraform-project-setup-and-best-practices) |
| 6.2 | [Remote State Configuration](#task-62-configure-remote-state-with-s3-and-dynamodb-locking) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-62-configure-remote-state-with-s3-and-dynamodb-locking) |
| 6.3 | [VPC Module Creation](#task-63-create-modular-vpc-infrastructure) | Medium | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-63-create-modular-vpc-infrastructure) |
| 6.4 | [Multi-Environment Setup](#task-64-provision-multi-environment-infrastructure) | Medium | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-64-provision-multi-environment-infrastructure) |
| 6.5 | [Variables and Locals](#task-65-implement-terraform-variables-and-locals) | Easy | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-65-implement-terraform-variables-and-locals) |
| 6.6 | [Data Sources and Dynamic Blocks](#task-66-use-data-sources-and-dynamic-blocks) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-66-use-data-sources-and-dynamic-blocks) |
| 6.7 | [RDS Database Setup](#task-67-provision-rds-database-with-terraform) | Medium | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-67-provision-rds-database-with-terraform) |
| 6.8 | [S3 and IAM Management](#task-68-manage-s3-buckets-and-iam-policies) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-68-manage-s3-buckets-and-iam-policies) |
| 6.9 | [Resource Import](#task-69-import-existing-aws-resources-into-terraform) | Hard | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-69-import-existing-aws-resources-into-terraform) |
| 6.10 | [Lifecycle Management](#task-610-implement-lifecycle-rules-and-dependencies) | Medium | 75 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-610-implement-lifecycle-rules-and-dependencies) |
| 6.11 | [Secrets Management](#task-611-implement-secrets-management-in-terraform) | Hard | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-611-implement-secrets-management-in-terraform) |
| 6.12 | [Module Registry](#task-612-use-terraform-modules-from-registry) | Easy | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-612-use-terraform-modules-from-registry) |
| 6.13 | [CI/CD Integration](#task-613-integrate-terraform-with-cicd-pipeline) | Hard | 120 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-613-integrate-terraform-with-cicd-pipeline) |
| 6.14 | [EKS Cluster Provisioning](#task-614-provision-eks-cluster-with-terraform) | Hard | 120 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-614-provision-eks-cluster-with-terraform) |
| 6.15 | [Resource Tagging Strategy](#task-615-implement-comprehensive-resource-tagging) | Easy | 60 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-615-implement-comprehensive-resource-tagging) |
| 6.16 | [Testing and Validation](#task-616-implement-terraform-testing-and-validation) | Medium | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-616-implement-terraform-testing-and-validation) |
| 6.17 | [State Migration](#task-617-perform-terraform-state-migration) | Hard | 90 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-617-perform-terraform-state-migration) |
| 6.18 | [Advanced Patterns](#task-618-implement-advanced-terraform-patterns) | Hard | 120 min | [View Solution →](./REAL-WORLD-TASKS-SOLUTIONS.md#task-618-implement-advanced-terraform-patterns) |

---

## Task 6.1: Terraform Project Setup and Best Practices

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-61-terraform-project-setup-and-best-practices)**

### 🎬 Real-World Scenario
Your company is starting a new cloud infrastructure project. You've been assigned to set up a Terraform project structure that follows industry best practices and can scale as the infrastructure grows. The project will manage infrastructure across multiple environments (dev, staging, prod).

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create a well-structured Terraform project with proper organization, version control, and documentation.

**Requirements:**
1. Create a standard directory structure for Terraform projects
2. Set up version constraints for Terraform and providers
3. Create .gitignore file for Terraform
4. Implement helper scripts for common operations
5. Create README documentation
6. Set up pre-commit hooks for terraform fmt
7. Create example terraform.tfvars file
8. Establish naming conventions and standards

**Environment:**
- Local development machine
- Git repository for version control
- AWS account (or other cloud provider)

### ✅ Validation Checklist

Complete this checklist and submit as proof of completion:

- [ ] **Project Structure**
  - [ ] Directory structure follows best practices
  - [ ] Modules directory exists with proper organization
  - [ ] Environment-specific directories created
  - [ ] Shared/common code separated

- [ ] **Version Control**
  - [ ] .gitignore properly configured
  - [ ] terraform.tfvars excluded from git
  - [ ] .terraform directory excluded
  - [ ] State files excluded

- [ ] **Configuration**
  - [ ] versions.tf with provider constraints
  - [ ] backend.tf configured (commented for initial setup)
  - [ ] variables.tf with proper descriptions
  - [ ] outputs.tf defined

- [ ] **Documentation**
  - [ ] README.md with setup instructions
  - [ ] Module README files created
  - [ ] Contributing guidelines documented
  - [ ] Architecture documented

- [ ] **Helper Scripts**
  - [ ] init.sh script created
  - [ ] plan.sh script created
  - [ ] apply.sh script created
  - [ ] Scripts are executable

- [ ] **Code Quality**
  - [ ] terraform fmt applied to all files
  - [ ] terraform validate passes
  - [ ] No hardcoded values in code
  - [ ] Consistent naming conventions used

### 📦 Deliverables

1. **Project Structure**: Complete directory tree
2. **Configuration Files**: All .tf files properly organized
3. **Documentation**: README and guide documents
4. **Scripts**: Helper scripts for common operations
5. **Git Repository**: Initialized with proper .gitignore

### 🎯 Success Criteria

- Project structure is clear and intuitive
- All team members can understand the organization
- Scripts work correctly for common operations
- Documentation is comprehensive and up-to-date
- Code follows Terraform best practices
- Ready for team collaboration

---

## Task 6.2: Configure Remote State with S3 and DynamoDB Locking

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-62-configure-remote-state-with-s3-and-dynamodb-locking)**

### 🎬 Real-World Scenario
Your team is growing and multiple engineers need to work on the same infrastructure. Currently, Terraform state is stored locally, causing conflicts and preventing collaboration. You need to implement remote state storage with locking to enable safe team collaboration.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Set up remote state backend using S3 and DynamoDB for state locking.

**Requirements:**
1. Create S3 bucket for state storage
2. Enable versioning on S3 bucket
3. Enable encryption for state files
4. Create DynamoDB table for state locking
5. Configure Terraform backend
6. Migrate existing local state to remote backend
7. Implement IAM policies for state access
8. Create state backup strategy
9. Document state management procedures

**Environment:**
- AWS account with admin permissions
- Existing Terraform project
- Local state file to migrate

### ✅ Validation Checklist

- [ ] **S3 Bucket Setup**
  - [ ] S3 bucket created with unique name
  - [ ] Versioning enabled
  - [ ] Encryption enabled (AES-256 or KMS)
  - [ ] Public access blocked
  - [ ] Lifecycle policy configured
  - [ ] Bucket policy restricts access

- [ ] **DynamoDB Table**
  - [ ] Table created with correct schema
  - [ ] Primary key is "LockID" (String)
  - [ ] On-demand billing mode configured
  - [ ] Tags applied appropriately

- [ ] **Backend Configuration**
  - [ ] backend.tf file created
  - [ ] S3 bucket name configured
  - [ ] DynamoDB table name configured
  - [ ] Encryption enabled in backend config
  - [ ] Region specified correctly

- [ ] **State Migration**
  - [ ] Local state backed up
  - [ ] terraform init -migrate-state executed
  - [ ] State successfully migrated to S3
  - [ ] State verified in S3 bucket
  - [ ] Local state files removed

- [ ] **IAM Policies**
  - [ ] Policy created for state bucket access
  - [ ] Policy created for DynamoDB table access
  - [ ] Least privilege principles applied
  - [ ] Policies tested and working

- [ ] **Testing**
  - [ ] State locking works (tested with concurrent operations)
  - [ ] State versioning verified
  - [ ] Backup and restore tested
  - [ ] Access controls verified

### 📦 Deliverables

1. **S3 Bucket**: Configured with all security features
2. **DynamoDB Table**: Configured for state locking
3. **Backend Configuration**: backend.tf file
4. **IAM Policies**: JSON policy documents
5. **Migration Documentation**: Steps followed and verification
6. **Backup Strategy**: Documentation and scripts

### 🎯 Success Criteria

- Multiple team members can work concurrently
- State is stored securely with encryption
- State locking prevents conflicts
- Versioning allows rollback if needed
- Access is properly controlled via IAM
- Backup and recovery procedures documented

---

## Task 6.3: Create Modular VPC Infrastructure

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-63-create-modular-vpc-infrastructure)**

### 🎬 Real-World Scenario
Your company is deploying a new application that requires a secure and well-architected VPC. The infrastructure team needs a reusable VPC module that can be used across multiple environments with different configurations. The VPC must support public, private, and database subnets with proper routing.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create a reusable Terraform module for VPC infrastructure that follows AWS best practices.

**Requirements:**
1. Create VPC module with configurable CIDR block
2. Implement public subnets with Internet Gateway
3. Implement private subnets with NAT Gateway
4. Create database subnets for RDS
5. Set up route tables for each subnet type
6. Configure VPC Flow Logs
7. Implement proper resource tagging
8. Create module outputs for use by other modules
9. Support multiple availability zones
10. Make NAT Gateway configuration flexible (single vs multi-AZ)

**Environment:**
- AWS account with VPC creation permissions
- Terraform project structure already set up
- At least 2-3 availability zones available

### ✅ Validation Checklist

- [ ] **Module Structure**
  - [ ] Module directory created (modules/vpc/)
  - [ ] main.tf, variables.tf, outputs.tf files present
  - [ ] README.md documents module usage
  - [ ] examples/ directory with sample usage

- [ ] **VPC Resources**
  - [ ] VPC created with configurable CIDR
  - [ ] DNS hostnames enabled
  - [ ] DNS support enabled
  - [ ] VPC properly tagged

- [ ] **Public Subnets**
  - [ ] Public subnets in multiple AZs
  - [ ] Internet Gateway created and attached
  - [ ] Public route table configured
  - [ ] Routes to IGW configured
  - [ ] Auto-assign public IPs enabled

- [ ] **Private Subnets**
  - [ ] Private subnets in multiple AZs
  - [ ] NAT Gateway(s) created in public subnets
  - [ ] Elastic IPs allocated for NAT Gateways
  - [ ] Private route tables configured
  - [ ] Routes to NAT Gateway configured

- [ ] **Database Subnets**
  - [ ] Database subnets in multiple AZs
  - [ ] DB subnet group created
  - [ ] Isolated from public internet
  - [ ] Proper route tables configured

- [ ] **Advanced Features**
  - [ ] VPC Flow Logs configured
  - [ ] CloudWatch log group created
  - [ ] IAM role for flow logs created
  - [ ] Configurable single vs multi-AZ NAT

- [ ] **Module Outputs**
  - [ ] VPC ID output
  - [ ] Subnet IDs output (public, private, database)
  - [ ] Route table IDs output
  - [ ] NAT Gateway IDs output
  - [ ] Database subnet group name output

- [ ] **Testing**
  - [ ] Module used in dev environment
  - [ ] Resources created successfully
  - [ ] Connectivity verified
  - [ ] Terraform plan shows no changes on re-run

### 📦 Deliverables

1. **VPC Module**: Complete module code
2. **Module Documentation**: README with usage examples
3. **Example Usage**: Sample configuration using the module
4. **Test Results**: Evidence of successful deployment
5. **Network Diagram**: Visual representation of VPC architecture

### 🎯 Success Criteria

- VPC module is reusable across environments
- All networking best practices implemented
- Module is well-documented
- Resources are properly tagged
- Network isolation is achieved
- Module outputs allow easy integration with other resources

---

## Task 6.4: Provision Multi-Environment Infrastructure

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-64-provision-multi-environment-infrastructure)**

### 🎬 Real-World Scenario
Your company needs to maintain separate infrastructure for development, staging, and production environments. Each environment should have similar architecture but different sizes and configurations. You need to set up a multi-environment Terraform configuration that promotes consistency while allowing environment-specific customization.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Set up infrastructure for three environments (dev, staging, prod) with appropriate sizing and configurations.

**Requirements:**
1. Create directory structure for multiple environments
2. Implement environment-specific variable files
3. Configure different resource sizes per environment
4. Set up separate state files for each environment
5. Create deployment scripts for each environment
6. Implement environment-specific tagging
7. Document environment differences
8. Set up promotion workflow from dev to prod
9. Implement cost optimization for non-prod environments

**Environment:**
- AWS account with multi-environment strategy
- Existing Terraform modules (VPC, etc.)
- CI/CD pipeline (optional)

### ✅ Validation Checklist

- [ ] **Directory Structure**
  - [ ] environments/dev directory created
  - [ ] environments/staging directory created
  - [ ] environments/prod directory created
  - [ ] Each environment has main.tf, variables.tf, terraform.tfvars
  - [ ] Shared modules directory exists

- [ ] **Environment Configuration**
  - [ ] Dev uses smaller instance sizes
  - [ ] Staging mirrors prod architecture
  - [ ] Prod uses production-grade resources
  - [ ] Multi-AZ enabled for prod
  - [ ] Single-AZ for dev/staging (cost optimization)

- [ ] **State Management**
  - [ ] Separate S3 keys for each environment
  - [ ] Backend configured per environment
  - [ ] State isolation verified
  - [ ] No cross-environment dependencies

- [ ] **Resource Sizing**
  - [ ] EC2 instances sized appropriately
  - [ ] RDS instances scaled per environment
  - [ ] Auto-scaling configured differently
  - [ ] Storage sizes appropriate

- [ ] **Security Configuration**
  - [ ] Environment-specific security groups
  - [ ] IAM roles per environment
  - [ ] Secrets managed separately
  - [ ] Network isolation between environments

- [ ] **Tagging**
  - [ ] Environment tag applied to all resources
  - [ ] Cost center tags configured
  - [ ] Owner tags set
  - [ ] Project tags applied

- [ ] **Deployment Automation**
  - [ ] Deployment scripts created
  - [ ] Environment selection implemented
  - [ ] Plan review process in place
  - [ ] Approval workflow documented

- [ ] **Documentation**
  - [ ] Environment comparison documented
  - [ ] Promotion process documented
  - [ ] Rollback procedures defined
  - [ ] Troubleshooting guide created

### 📦 Deliverables

1. **Environment Configurations**: Complete config for dev, staging, prod
2. **Deployment Scripts**: Automated deployment scripts
3. **Environment Matrix**: Table comparing environment configurations
4. **Promotion Workflow**: Documentation and scripts
5. **Cost Analysis**: Cost comparison between environments

### 🎯 Success Criteria

- All three environments successfully deployed
- Environment-specific configurations working
- State properly isolated
- Resources appropriately sized
- Cost optimized for non-prod
- Promotion workflow tested
- Team can deploy to any environment

---

## Task 6.5: Implement Terraform Variables and Locals

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-65-implement-terraform-variables-and-locals)**

### 🎬 Real-World Scenario
Your Terraform code has many hardcoded values and duplicated logic. The team wants to make the infrastructure more flexible and maintainable by properly using variables, locals, and input validation. You need to refactor the existing code to use proper variable management.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement comprehensive variable management and use locals for computed values.

**Requirements:**
1. Extract hardcoded values into variables
2. Add variable validation rules
3. Use locals for computed values
4. Implement variable defaults appropriately
5. Create terraform.tfvars.example
6. Document all variables
7. Use variable type constraints
8. Implement complex variable types (maps, objects)
9. Use sensitive variable handling

**Environment:**
- Existing Terraform project with hardcoded values
- AWS infrastructure code

### ✅ Validation Checklist

- [ ] **Variable Definition**
  - [ ] All hardcoded values extracted
  - [ ] variables.tf file well-organized
  - [ ] Variable descriptions comprehensive
  - [ ] Type constraints applied

- [ ] **Variable Types**
  - [ ] String variables defined
  - [ ] Number variables defined
  - [ ] Bool variables defined
  - [ ] List variables defined
  - [ ] Map variables defined
  - [ ] Object variables for complex structures

- [ ] **Validation**
  - [ ] CIDR block validation implemented
  - [ ] Environment value validation
  - [ ] Instance type validation
  - [ ] Custom validation rules applied

- [ ] **Locals Usage**
  - [ ] Common tags in locals
  - [ ] Computed resource names in locals
  - [ ] Conditional logic in locals
  - [ ] DRY principle applied

- [ ] **Variable Files**
  - [ ] terraform.tfvars for sensitive values (not committed)
  - [ ] terraform.tfvars.example for template
  - [ ] Environment-specific .tfvars files
  - [ ] Variables documented in README

- [ ] **Sensitive Data**
  - [ ] Sensitive variables marked as sensitive
  - [ ] No secrets in variable defaults
  - [ ] Secrets sourced from external systems

- [ ] **Testing**
  - [ ] terraform validate passes
  - [ ] Variables override correctly
  - [ ] Default values work
  - [ ] Validation rules trigger appropriately

### 📦 Deliverables

1. **variables.tf**: Comprehensive variable definitions
2. **locals.tf**: Local value computations
3. **terraform.tfvars.example**: Template for users
4. **Variable Documentation**: README section on variables
5. **Validation Tests**: Evidence of validation working

### 🎯 Success Criteria

- No hardcoded values in resource definitions
- Variables properly typed and validated
- Locals reduce code duplication
- Documentation clear for all variables
- Sensitive data handled correctly
- Code is more maintainable and flexible

---

[Continue with remaining tasks 6.6 through 6.18...]


## Task 6.6: Use Data Sources and Dynamic Blocks

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-66-use-data-sources-and-dynamic-blocks)**

### 🎬 Real-World Scenario
Your infrastructure needs to integrate with existing AWS resources and handle variable numbers of configurations. You need to query existing resources using data sources and implement dynamic blocks to handle repeating configuration blocks efficiently.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement data sources to query existing AWS resources and use dynamic blocks for flexible configurations.

**Requirements:**
1. Use data sources to query existing VPC
2. Fetch latest AMI dynamically
3. Get availability zones programmatically
4. Implement dynamic security group rules
5. Use dynamic blocks for ingress/egress rules
6. Query existing IAM roles
7. Fetch SSM parameters
8. Implement conditional dynamic blocks

**Deliverables:**
- Data source configurations
- Dynamic block implementations
- Working example code
- Documentation

### ✅ Validation Checklist

- [ ] Data sources implemented for AMI, VPC, AZs
- [ ] Dynamic blocks for security groups
- [ ] Dynamic blocks handle variable input
- [ ] Code tested and working
- [ ] No hardcoded resource IDs

---

## Task 6.7: Provision RDS Database with Terraform

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-67-provision-rds-database-with-terraform)**

### 🎬 Real-World Scenario
Your application needs a production-grade PostgreSQL database. You need to provision an RDS instance with proper security, backup configuration, monitoring, and high availability.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create a production-ready RDS PostgreSQL database with all necessary configurations.

**Requirements:**
1. Create RDS PostgreSQL instance
2. Configure Multi-AZ for production
3. Set up automated backups
4. Implement encryption at rest
5. Create parameter group
6. Create option group
7. Set up security groups
8. Configure monitoring and alerts
9. Implement read replicas (optional for prod)
10. Document connection procedures

**Deliverables:**
- RDS Terraform configuration
- Security group rules
- Backup and retention policy
- Connection documentation
- Monitoring setup

### ✅ Validation Checklist

- [ ] RDS instance created successfully
- [ ] Multi-AZ enabled for production
- [ ] Backups configured with retention
- [ ] Encryption enabled
- [ ] Security groups restrict access
- [ ] Monitoring enabled
- [ ] Connection tested
- [ ] Documentation complete

---

## Task 6.8: Manage S3 Buckets and IAM Policies

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-68-manage-s3-buckets-and-iam-policies)**

### 🎬 Real-World Scenario
Your application needs secure S3 storage for user uploads, backups, and static content. You need to create S3 buckets with proper security controls, versioning, lifecycle policies, and IAM policies for access management.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create secure S3 buckets with appropriate IAM policies for different use cases.

**Requirements:**
1. Create S3 bucket for application uploads
2. Create S3 bucket for backup storage
3. Configure bucket versioning
4. Implement lifecycle policies
5. Set up server-side encryption
6. Block public access
7. Create IAM policies for bucket access
8. Implement bucket policies
9. Configure CORS rules
10. Set up logging

**Deliverables:**
- S3 bucket configurations
- IAM policies
- Lifecycle policies
- Security configuration
- Access patterns documented

### ✅ Validation Checklist

- [ ] S3 buckets created with unique names
- [ ] Versioning enabled where needed
- [ ] Encryption configured
- [ ] Public access blocked
- [ ] IAM policies implement least privilege
- [ ] Lifecycle policies configured
- [ ] CORS configured if needed
- [ ] Logging enabled

---

## Task 6.9: Import Existing AWS Resources into Terraform

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-69-import-existing-aws-resources-into-terraform)**

### 🎬 Real-World Scenario
Your company has existing AWS infrastructure created manually through the console. Management wants to bring this infrastructure under Terraform management without disrupting production services. You need to import existing resources into Terraform state.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Import existing AWS resources into Terraform management without causing downtime.

**Requirements:**
1. Identify resources to import
2. Write Terraform configurations matching existing resources
3. Import resources using terraform import
4. Verify state matches actual resources
5. Test plan shows no changes
6. Document import process
7. Create import scripts for repeatability
8. Handle resource dependencies

**Deliverables:**
- Import commands documentation
- Terraform configurations for imported resources
- Verification results
- Import scripts
- Lessons learned document

### ✅ Validation Checklist

- [ ] Resources identified and documented
- [ ] Terraform configs match existing resources
- [ ] Import commands successful
- [ ] terraform plan shows no changes
- [ ] Dependencies handled correctly
- [ ] No service disruption
- [ ] Process documented
- [ ] Team trained on import process

---

## Task 6.10: Implement Lifecycle Rules and Dependencies

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-610-implement-lifecycle-rules-and-dependencies)**

### 🎬 Real-World Scenario
Your infrastructure has resources that need careful management during updates. Some resources should be created before others are destroyed to prevent downtime. Some critical resources should be protected from accidental deletion. You need to implement proper lifecycle rules and dependency management.

### ⏱️ Time to Complete: 75 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement lifecycle rules and explicit dependencies to control resource management.

**Requirements:**
1. Implement create_before_destroy for critical resources
2. Add prevent_destroy for production databases
3. Use ignore_changes for externally modified attributes
4. Implement explicit dependencies with depends_on
5. Handle resource replacement scenarios
6. Document lifecycle behavior
7. Test lifecycle rules
8. Create runbook for emergency scenarios

**Deliverables:**
- Lifecycle rule implementations
- Dependency mappings
- Test results
- Emergency procedures
- Documentation

### ✅ Validation Checklist

- [ ] create_before_destroy configured correctly
- [ ] prevent_destroy protecting critical resources
- [ ] ignore_changes handling external modifications
- [ ] Dependencies explicit where needed
- [ ] Replacement scenarios tested
- [ ] Zero-downtime updates verified
- [ ] Emergency procedures documented

---

## Task 6.11: Implement Secrets Management in Terraform

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-611-implement-secrets-management-in-terraform)**

### 🎬 Real-World Scenario
Your Terraform code needs to handle sensitive data like database passwords, API keys, and certificates. Currently, these are being hardcoded or passed insecurely. You need to implement proper secrets management using AWS Secrets Manager and/or HashiCorp Vault.

### ⏱️ Time to Complete: 90 minutes

### �� Assignment Instructions

**Your Mission:**
Implement secure secrets management for all sensitive data in Terraform.

**Requirements:**
1. Set up AWS Secrets Manager for secrets
2. Store database passwords in Secrets Manager
3. Retrieve secrets in Terraform using data sources
4. Mark variables as sensitive
5. Implement secret rotation
6. Use AWS Systems Manager Parameter Store for configuration
7. Document secrets management policy
8. Create runbook for secret rotation
9. Implement least privilege access to secrets

**Deliverables:**
- Secrets Manager configuration
- Terraform data source implementations
- Secret rotation Lambda (if applicable)
- IAM policies for secret access
- Secrets management documentation

### ✅ Validation Checklist

- [ ] Secrets stored in AWS Secrets Manager
- [ ] No secrets in Terraform code
- [ ] No secrets in state file (verified)
- [ ] Sensitive variables marked as sensitive
- [ ] Data sources retrieving secrets correctly
- [ ] IAM policies implement least privilege
- [ ] Rotation configured where applicable
- [ ] Documentation complete

---

## Task 6.12: Use Terraform Modules from Registry

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-612-use-terraform-modules-from-registry)**

### 🎬 Real-World Scenario
Your team is spending time building infrastructure components that already exist as community modules. You need to evaluate and implement community modules from the Terraform Registry to speed up development while maintaining security and best practices.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Evaluate and implement community modules from Terraform Registry for common infrastructure patterns.

**Requirements:**
1. Identify suitable modules from Terraform Registry
2. Evaluate module quality and maintainability
3. Implement VPC module from registry
4. Implement EKS module from registry
5. Pin module versions
6. Customize modules with variables
7. Document module choices and rationale
8. Create wrapper modules if needed

**Deliverables:**
- Module evaluation criteria
- Module selection documentation
- Implementation using registry modules
- Version pinning strategy
- Customization documentation

### ✅ Validation Checklist

- [ ] Modules evaluated for quality
- [ ] Module versions pinned
- [ ] Modules implemented correctly
- [ ] Customization documented
- [ ] Security reviewed
- [ ] Module updates process defined
- [ ] Team trained on module usage

---

## Task 6.13: Integrate Terraform with CI/CD Pipeline

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-613-integrate-terraform-with-cicd-pipeline)**

### 🎬 Real-World Scenario
Your team is manually running Terraform commands, leading to inconsistency and human errors. You need to implement a CI/CD pipeline that automatically plans and applies Terraform changes with proper approvals and safety checks.

### ⏱️ Time to Complete: 120 minutes

### 📋 Assignment Instructions

**Your Mission:**
Create a fully automated CI/CD pipeline for Terraform deployments.

**Requirements:**
1. Set up GitHub Actions or GitLab CI for Terraform
2. Implement automated terraform plan on pull requests
3. Add approval gates for terraform apply
4. Implement automated validation and formatting checks
5. Set up security scanning for Terraform code
6. Implement drift detection
7. Configure notifications for failures
8. Create separate pipelines for each environment
9. Document CI/CD workflow

**Deliverables:**
- CI/CD pipeline configuration
- Workflow documentation
- Security scanning integration
- Approval process documentation
- Troubleshooting guide

### ✅ Validation Checklist

- [ ] Pipeline triggers on PR creation
- [ ] Automated plan runs successfully
- [ ] Approval required for apply
- [ ] terraform fmt check automated
- [ ] terraform validate automated
- [ ] Security scanning implemented
- [ ] Notifications configured
- [ ] Environment separation working
- [ ] Drift detection running

---

## Task 6.14: Provision EKS Cluster with Terraform

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-614-provision-eks-cluster-with-terraform)**

### 🎬 Real-World Scenario
Your company is adopting Kubernetes for container orchestration. You need to provision a production-ready EKS cluster with managed node groups, IRSA (IAM Roles for Service Accounts), cluster add-ons, and monitoring.

### ⏱️ Time to Complete: 120 minutes

### 📋 Assignment Instructions

**Your Mission:**
Provision a complete EKS cluster with all production requirements.

**Requirements:**
1. Create EKS cluster with proper version
2. Configure managed node groups with auto-scaling
3. Implement IRSA (IAM Roles for Service Accounts)
4. Install cluster add-ons (VPC CNI, CoreDNS, kube-proxy)
5. Configure cluster logging
6. Set up OIDC provider
7. Create IAM roles for common workloads
8. Configure security groups
9. Implement network policies
10. Set up kubectl access

**Deliverables:**
- EKS cluster Terraform code
- Node group configurations
- IRSA configurations
- Kubeconfig setup documentation
- Security configuration
- Operational runbook

### ✅ Validation Checklist

- [ ] EKS cluster created successfully
- [ ] Node groups operational
- [ ] IRSA configured correctly
- [ ] Add-ons installed and running
- [ ] Logging configured
- [ ] kubectl access working
- [ ] Security groups configured
- [ ] Auto-scaling configured
- [ ] Monitoring enabled
- [ ] Documentation complete

---

## Task 6.15: Implement Comprehensive Resource Tagging

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-615-implement-comprehensive-resource-tagging)**

### 🎬 Real-World Scenario
Your AWS account has hundreds of resources with inconsistent or missing tags, making cost allocation and resource management difficult. You need to implement a comprehensive tagging strategy across all Terraform-managed resources.

### ⏱️ Time to Complete: 60 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement a standardized tagging strategy for all AWS resources.

**Requirements:**
1. Define tagging standards and policy
2. Implement mandatory tags (Environment, Owner, Project, etc.)
3. Use default_tags in provider configuration
4. Implement resource-specific tags
5. Create tag validation rules
6. Document tagging policy
7. Generate cost allocation tags
8. Implement tag enforcement via policy

**Deliverables:**
- Tagging policy document
- Provider configuration with default tags
- Resource-specific tag examples
- Tag validation implementation
- Cost allocation report

### ✅ Validation Checklist

- [ ] Tagging policy documented
- [ ] Default tags configured in provider
- [ ] All resources tagged consistently
- [ ] Required tags enforced
- [ ] Cost allocation tags applied
- [ ] Tag validation implemented
- [ ] Documentation complete
- [ ] Team trained on tagging policy

---

## Task 6.16: Implement Terraform Testing and Validation

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-616-implement-terraform-testing-and-validation)**

### 🎬 Real-World Scenario
Your team wants to implement testing for Terraform code to catch errors before they reach production. You need to set up automated testing using tools like Terratest, terraform validate, and custom validation scripts.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement comprehensive testing strategy for Terraform code.

**Requirements:**
1. Set up Terratest for integration testing
2. Implement unit tests for modules
3. Create validation scripts
4. Implement compliance testing
5. Set up automated testing in CI/CD
6. Document testing procedures
7. Create test cases for critical modules
8. Implement security scanning

**Deliverables:**
- Terratest code
- Validation scripts
- CI/CD integration
- Test documentation
- Coverage reports

### ✅ Validation Checklist

- [ ] Terratest implemented
- [ ] Unit tests for modules created
- [ ] Integration tests working
- [ ] Validation scripts automated
- [ ] CI/CD integration complete
- [ ] Security scanning configured
- [ ] Test coverage adequate
- [ ] Documentation complete

---

## Task 6.17: Perform Terraform State Migration

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-617-perform-terraform-state-migration)**

### 🎬 Real-World Scenario
Your team needs to migrate Terraform state from one backend to another, or reorganize resources into different state files. You need to perform this migration safely without disrupting production infrastructure.

### ⏱️ Time to Complete: 90 minutes

### 📋 Assignment Instructions

**Your Mission:**
Migrate Terraform state between backends or reorganize state files safely.

**Requirements:**
1. Backup existing state files
2. Plan migration strategy
3. Migrate state to new backend
4. Verify state integrity
5. Test with terraform plan
6. Handle state locking during migration
7. Document migration process
8. Create rollback plan

**Deliverables:**
- Migration plan
- Backup of original state
- Migration scripts
- Verification results
- Rollback procedures
- Post-migration documentation

### ✅ Validation Checklist

- [ ] State backed up completely
- [ ] Migration plan documented
- [ ] State migrated successfully
- [ ] Terraform plan shows no changes
- [ ] State integrity verified
- [ ] No resources lost
- [ ] Rollback procedure tested
- [ ] Documentation complete

---

## Task 6.18: Implement Advanced Terraform Patterns

> **📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-618-implement-advanced-terraform-patterns)**

### 🎬 Real-World Scenario
Your infrastructure is becoming more complex and needs advanced Terraform patterns like for_each, conditional resources, count, and module composition. You need to implement these patterns to make the infrastructure more maintainable and flexible.

### ⏱️ Time to Complete: 120 minutes

### 📋 Assignment Instructions

**Your Mission:**
Implement advanced Terraform patterns for complex infrastructure scenarios.

**Requirements:**
1. Implement for_each for resource creation
2. Use count for conditional resources
3. Implement complex conditional logic
4. Create module composition patterns
5. Use terraform_data for triggers
6. Implement null_resource for custom provisioning
7. Use templatefile for dynamic configurations
8. Implement advanced variable validation

**Deliverables:**
- Advanced pattern implementations
- Module composition examples
- Conditional logic examples
- Documentation and best practices
- Performance considerations

### ✅ Validation Checklist

- [ ] for_each implemented correctly
- [ ] count used appropriately
- [ ] Conditional resources working
- [ ] Module composition functional
- [ ] Custom provisioning working
- [ ] Templates rendered correctly
- [ ] Performance optimized
- [ ] Documentation comprehensive

---

## Summary

This comprehensive set of 18 Terraform tasks covers:
- Project setup and organization
- State management and collaboration
- Networking and infrastructure
- Security and secrets management
- CI/CD integration
- Advanced patterns and testing

Each task is designed to build real-world skills and can be completed independently or as part of a learning path.

For complete solutions with step-by-step implementations, see [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md).

