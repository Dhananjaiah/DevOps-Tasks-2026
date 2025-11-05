# DevOps Tasks 2026 - Comprehensive Guide for Job Aspirants

## 🎯 Overview

This repository contains a **comprehensive, practical, and exhaustive** set of DevOps tasks with full solutions designed for job aspirants preparing for real-world DevOps/SRE roles and technical interviews.

### Application Context

All tasks are built around a **production-grade 3-tier web application**:
- **Frontend**: Simple web UI
- **Backend**: Containerized REST API
- **Database**: PostgreSQL

**Infrastructure Stack**:
- **Cloud Provider**: AWS
- **Orchestration**: Kubernetes (EKS)
- **CI/CD**: Jenkins & GitHub Actions
- **Monitoring**: Prometheus + Grafana
- **IaC**: Terraform
- **Configuration Management**: Ansible
- **Version Control**: GitHub

---

## 📚 Table of Contents

### [Part 1: Linux Server Administration](./part-01-linux/README.md)
Comprehensive coverage of Linux skills for DevOps engineers.

1.  **Task 1.1**: Harden an EC2 Linux Instance for Production
2.  **Task 1.2**: Configure SSH Key-Based Authentication and SSH Hardening
3.  **Task 1.3**: User and Group Management with Sudoers Configuration
4.  **Task 1.4**: Filesystem Management, Permissions, and ACLs
5.  **Task 1.5**: Create and Manage Systemd Service for Backend API
6.  **Task 1.6**: Configure Firewall Rules (firewalld/iptables/ufw)
7.  **Task 1.7**: Log Analysis and Management (journalctl, /var/log)
8.  **Task 1.8**: Process Management and Performance Monitoring
9.  **Task 1.9**: Package Management and Repository Configuration
10. **Task 1.10**: Automated PostgreSQL Backup with Cron
11. **Task 1.11**: Configure Log Rotation with logrotate
12. **Task 1.12**: Disk Usage Monitoring and Management
13. **Task 1.13**: Network Troubleshooting and Diagnostics
14. **Task 1.14**: Systemd Timers for Scheduled Tasks
15. **Task 1.15**: Security Hardening and File Integrity Monitoring
16. **Task 1.16**: DNS Configuration and Troubleshooting
17. **Task 1.17**: Advanced Process Management (nice/renice, Background Jobs)
18. **Task 1.18**: Troubleshooting High CPU and Memory Usage

### [Part 2: Bash Scripting & Automation](./part-02-bash/README.md)
Real-world Bash scripting for automation and operations.

1.  **Task 2.1**: Robust Bash Script Template with Error Handling
2.  **Task 2.2**: Log Analysis Script for API 5xx Errors
3.  **Task 2.3**: Docker Build and Push Automation Script
4.  **Task 2.4**: Multi-Environment Deployment Script
5.  **Task 2.5**: Health Check Script for Microservices
6.  **Task 2.6**: Log Rotation and Compression Script
7.  **Task 2.7**: JSON and YAML Processing with jq and yq
8.  **Task 2.8**: Automated Backup Script with Retention Policy
9.  **Task 2.9**: Kubernetes Manifest Validation Script
10. **Task 2.10**: Environment Variable and Secret Management
11. **Task 2.11**: Resource Cleanup and Housekeeping Script
12. **Task 2.12**: Parallel Processing and Job Control
13. **Task 2.13**: Script Locking to Prevent Concurrent Runs
14. **Task 2.14**: Report Generation from System Metrics

### [Part 3: GitHub Repository & Workflows](./part-03-github/README.md)
Professional Git workflows and GitHub best practices.

1.  **Task 3.1**: Design Monorepo vs Polyrepo Structure
2.  **Task 3.2**: Implement Git Branching Strategy (GitFlow)
3.  **Task 3.3**: Configure Branch Protection and Required Reviews
4.  **Task 3.4**: Pull Request Workflow and Templates
5.  **Task 3.5**: Issue Templates and Project Management
6.  **Task 3.6**: Release Process with Tags and Changelogs
7.  **Task 3.7**: CODEOWNERS and Required Reviewers
8.  **Task 3.8**: Semantic Versioning Implementation
9.  **Task 3.9**: GitHub Security Features (Dependabot, Code Scanning)
10. **Task 3.10**: GitHub Environments for Deployment Control

### [Part 4: Ansible Configuration Management](./part-04-ansible/README.md)
End-to-end server configuration and deployment automation.

1.  **Task 4.1**: Ansible Directory Structure and Best Practices
2.  **Task 4.2**: Inventory Management for Multi-Environment Setup
3.  **Task 4.3**: Create Ansible Role for Backend API Service
4.  **Task 4.4**: Configure Nginx Reverse Proxy with TLS
5.  **Task 4.5**: Ansible Vault for Secrets Management
6.  **Task 4.6**: PostgreSQL Installation and Configuration
7.  **Task 4.7**: Application Deployment Playbook
8.  **Task 4.8**: Zero-Downtime Rolling Updates
9.  **Task 4.9**: Dynamic Inventory for AWS EC2
10. **Task 4.10**: Ansible Templates with Jinja2
11. **Task 4.11**: Handlers and Service Management
12. **Task 4.12**: Conditional Execution and Loops
13. **Task 4.13**: Error Handling and Retries
14. **Task 4.14**: Ansible Tags for Selective Execution

### [Part 5: AWS Cloud Foundation](./part-05-aws/README.md)
Production-ready AWS infrastructure setup.

1.  **Task 5.1**: VPC Design with Public and Private Subnets
2.  **Task 5.2**: IAM Roles and Policies (Least Privilege)
3.  **Task 5.3**: Security Groups and NACLs Configuration
4.  **Task 5.4**: EC2 Instance Setup (Bastion, Jenkins)
5.  **Task 5.5**: RDS PostgreSQL Database Setup
6.  **Task 5.6**: S3 Buckets for Artifacts and Backups
7.  **Task 5.7**: ECR Repository for Container Images
8.  **Task 5.8**: CloudWatch Logs and Metrics
9.  **Task 5.9**: CloudWatch Alarms and Notifications
10. **Task 5.10**: Route Tables and NAT Gateway Configuration
11. **Task 5.11**: IAM Roles for EKS and CI/CD
12. **Task 5.12**: AWS Systems Manager Parameter Store
13. **Task 5.13**: AWS Secrets Manager Integration
14. **Task 5.14**: VPC Peering and Transit Gateway Basics
15. **Task 5.15**: S3 Bucket Policies and Encryption
16. **Task 5.16**: CloudTrail for Audit Logging

### [Part 6: Terraform Infrastructure as Code](./part-06-terraform/README.md)
Complete infrastructure provisioning with Terraform.

1.  **Task 6.1**: Terraform Project Structure and Best Practices
2.  **Task 6.2**: Remote State with S3 and DynamoDB Locking
3.  **Task 6.3**: VPC Module Creation and Usage
4.  **Task 6.4**: EKS Cluster Provisioning with Terraform
5.  **Task 6.5**: Multi-Environment Setup (Dev/Stage/Prod)
6.  **Task 6.6**: Terraform Variables and Locals
7.  **Task 6.7**: Data Sources and Dynamic Blocks
8.  **Task 6.8**: RDS Module with Terraform
9.  **Task 6.9**: S3 and IAM Resource Management
10. **Task 6.10**: Terraform Workspaces
11. **Task 6.11**: Resource Tagging Strategy
12. **Task 6.12**: Terraform Import for Existing Resources
13. **Task 6.13**: Lifecycle Rules and Dependencies
14. **Task 6.14**: Secrets Management in Terraform

### [Part 7: Kubernetes Deployment & Operations](./part-07-kubernetes/README.md)
Day-to-day Kubernetes operations and advanced features.

1.  **Task 7.1**: Namespace Organization (Dev/Staging/Prod)
2.  **Task 7.2**: Deploy Backend API with Deployment
3.  **Task 7.3**: Service Types (ClusterIP, LoadBalancer)
4.  **Task 7.4**: ConfigMaps for Application Configuration
5.  **Task 7.5**: Secrets Management in Kubernetes
6.  **Task 7.6**: Liveness and Readiness Probes
7.  **Task 7.7**: Ingress Controller and Ingress Resources
8.  **Task 7.8**: HorizontalPodAutoscaler (HPA) Setup
9.  **Task 7.9**: RBAC Configuration (ServiceAccount, Roles)
10. **Task 7.10**: StatefulSet for PostgreSQL
11. **Task 7.11**: PersistentVolumes and PersistentVolumeClaims
12. **Task 7.12**: CronJobs for Scheduled Tasks
13. **Task 7.13**: Resource Requests and Limits
14. **Task 7.14**: PodDisruptionBudget for High Availability
15. **Task 7.15**: Rolling Updates and Rollbacks
16. **Task 7.16**: Network Policies for Security
17. **Task 7.17**: Troubleshooting Pods and Deployments
18. **Task 7.18**: Jobs for One-Time Tasks
19. **Task 7.19**: DaemonSets for Node-Level Services
20. **Task 7.20**: Advanced Kubectl Techniques

### [Part 8: Jenkins CI/CD Pipeline](./part-08-jenkins/README.md)
Enterprise-grade Jenkins pipelines.

1.  **Task 8.1**: Jenkins Installation and Initial Configuration
2.  **Task 8.2**: Configure Jenkins Agents and Nodes
3.  **Task 8.3**: Multibranch Pipeline Setup
4.  **Task 8.4**: Declarative Jenkinsfile for CI/CD
5.  **Task 8.5**: Docker Build and Push to ECR
6.  **Task 8.6**: Kubernetes Deployment from Jenkins
7.  **Task 8.7**: Jenkins Credentials Management
8.  **Task 8.8**: GitHub Webhook Integration
9.  **Task 8.9**: Manual Approval for Production Deploys
10. **Task 8.10**: Parallel Stages and Matrix Builds
11. **Task 8.11**: Jenkins Shared Libraries
12. **Task 8.12**: Build Artifacts and Test Reports

### [Part 9: GitHub Actions CI/CD](./part-09-github-actions/README.md)
Modern CI/CD with GitHub Actions.

1.  **Task 9.1**: GitHub Actions Workflow Basics
2.  **Task 9.2**: CI Pipeline for Pull Requests
3.  **Task 9.3**: Docker Build and Push to ECR
4.  **Task 9.4**: Kubernetes Deployment with GitHub Actions
5.  **Task 9.5**: Environment Protection and Approvals
6.  **Task 9.6**: Reusable Workflows
7.  **Task 9.7**: Matrix Strategy for Multi-Version Testing
8.  **Task 9.8**: Caching Dependencies for Faster Builds
9.  **Task 9.9**: Scheduled Workflows for Maintenance
10. **Task 9.10**: Custom Actions and Composite Actions
11. **Task 9.11**: Secrets Management and Environment Variables
12. **Task 9.12**: Status Badges and Notifications

### [Part 10: Prometheus Monitoring & Alerting](./part-10-prometheus/README.md)
Production observability with Prometheus.

1.  **Task 10.1**: Prometheus Architecture and Installation
2.  **Task 10.2**: Node Exporter for System Metrics
3.  **Task 10.3**: Application Metrics Instrumentation
4.  **Task 10.4**: Service Discovery in Kubernetes
5.  **Task 10.5**: PromQL Fundamentals and Queries
6.  **Task 10.6**: Recording Rules for Performance
7.  **Task 10.7**: Alerting Rules Configuration
8.  **Task 10.8**: Alertmanager Setup and Configuration
9.  **Task 10.9**: SLO-Based Alerting
10. **Task 10.10**: Alert Routing and Grouping
11. **Task 10.11**: Integration with Slack/Email
12. **Task 10.12**: Grafana Dashboard Design (Conceptual)

---

## 🎓 Learning Path

### Beginner Track
Start with: **Part 1 (Linux)** → **Part 2 (Bash)** → **Part 3 (GitHub)**

### Intermediate Track
Continue with: **Part 4 (Ansible)** → **Part 5 (AWS)** → **Part 6 (Terraform)**

### Advanced Track
Master: **Part 7 (Kubernetes)** → **Part 8 or 9 (CI/CD)** → **Part 10 (Prometheus)**

---

## 📋 Task Structure

Each task follows this consistent format:

1. **Title**: Clear, descriptive task name
2. **Goal / Why It's Important**: Real-world context and value
3. **Prerequisites**: Required tools, knowledge, and setup
4. **Step-by-Step Implementation**: Detailed guide with commands
5. **Key Commands/Configs**: Essential snippets and configurations
6. **Verification**: How to test and validate the solution
7. **Common Mistakes & Troubleshooting**: Practical tips to avoid issues
8. **Interview Questions**: 5-10 relevant questions with model answers

---

## 🛠️ Prerequisites

### Required Tools
- **Linux**: Ubuntu 20.04+ or Amazon Linux 2
- **Git**: Version 2.30+
- **Docker**: Version 20.10+
- **kubectl**: Version 1.24+
- **AWS CLI**: Version 2.x
- **Terraform**: Version 1.3+
- **Ansible**: Version 2.12+
- **jq**: Latest version
- **yq**: Latest version (v4)

### Required Accounts
- AWS Account with appropriate permissions
- GitHub Account
- Docker Hub or AWS ECR access

### Basic Knowledge
- Linux command line fundamentals
- Basic networking concepts
- Git basics
- Basic scripting knowledge
- YAML and JSON syntax

---

## 🚀 How to Use This Repository

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Dhananjaiah/DevOps-Tasks-2026.git
   cd DevOps-Tasks-2026
   ```

2. **Navigate to a specific part**:
   ```bash
   cd part-01-linux
   ```

3. **Follow the tasks sequentially** or pick specific topics based on your needs

4. **Practice in a safe environment**: Use AWS free tier, local VMs, or minikube for practice

5. **Review interview questions** after completing each task

---

## 💡 Tips for Success

- **Hands-On Practice**: Don't just read—actually implement each task
- **Understand Why**: Focus on understanding the reasoning behind each solution
- **Experiment**: Try variations and break things to learn troubleshooting
- **Document**: Keep notes on challenges and solutions you discover
- **Review Regularly**: Revisit completed tasks to reinforce learning
- **Ask Questions**: Research anything unclear using official documentation

---

## 🤝 Contributing

This repository is designed as a learning resource. If you find errors or have suggestions for improvements, please open an issue or submit a pull request.

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 📞 Support

For questions or clarifications about specific tasks, please open an issue in the repository.

---

## 🎯 Interview Preparation Strategy

1. **Master the fundamentals** (Parts 1-3)
2. **Build practical experience** (Parts 4-7)
3. **Understand CI/CD deeply** (Parts 8-9)
4. **Learn observability** (Part 10)
5. **Practice troubleshooting scenarios** from each part
6. **Review interview questions** regularly
7. **Build a portfolio project** using these skills

---

**Good luck with your DevOps journey! 🚀**
