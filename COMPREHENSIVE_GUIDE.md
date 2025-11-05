# Comprehensive DevOps Tasks Guide - All Parts Summary

This guide provides complete task overviews for Parts 4-10. Each part contains detailed implementations following the same structure as Parts 1-3.

---

## Part 4: Ansible Configuration Management

### Task List (14 Comprehensive Tasks)

**4.1 Ansible Directory Structure and Best Practices**
- Standard directory layout (`inventories/`, `roles/`, `playbooks/`)
- Group vars and host vars organization
- Ansible.cfg configuration
- Interview Q: Explain Ansible directory structure best practices

**4.2 Inventory Management for Multi-Environment Setup**
```yaml
# inventories/production/hosts
[web]
web1.example.com
web2.example.com

[api]
api[1:3].example.com

[db]
db1.example.com

[production:children]
web
api
db
```

**4.3 Create Ansible Role for Backend API Service**
```yaml
# roles/backend-api/tasks/main.yml
- name: Create application user
  user:
    name: api-service
    system: yes
    shell: /bin/false

- name: Install Node.js
  apt:
    name: nodejs
    state: present

- name: Deploy application
  copy:
    src: "{{ app_source }}"
    dest: /opt/app/
    owner: api-service
```

**4.4 Configure Nginx Reverse Proxy with TLS**
- Nginx installation and configuration
- SSL/TLS certificate management (Let's Encrypt)
- Proxy pass configuration
- Load balancing setup

**4.5 Ansible Vault for Secrets Management**
```bash
# Create encrypted file
ansible-vault create secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Use in playbook
ansible-playbook --ask-vault-pass playbook.yml
```

**4.6-4.14**: PostgreSQL setup, Application deployment, Zero-downtime updates, Dynamic inventory, Templates, Handlers, Conditionals, Error handling, Tags

### Key Interview Questions

**Q: How does Ansible ensure idempotency?**
A: Ansible modules are designed to check current state before making changes. They only make changes if needed, making playbooks safe to run multiple times.

**Q: Difference between vars, group_vars, and host_vars?**
A: 
- `vars`: Defined in playbook
- `group_vars`: Apply to groups in inventory
- `host_vars`: Apply to specific hosts
- Precedence: host_vars > group_vars > vars

---

## Part 5: AWS Cloud Foundation

### Task List (16 Comprehensive Tasks)

**5.1 VPC Design with Public and Private Subnets**
```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create public subnet
aws ec2 create-subnet --vpc-id $VPC_ID \
  --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a

# Create private subnet
aws ec2 create-subnet --vpc-id $VPC_ID \
  --cidr-block 10.0.10.0/24 \
  --availability-zone us-east-1a
```

**VPC Architecture**:
```
VPC (10.0.0.0/16)
├── Public Subnets (Internet Gateway)
│   ├── 10.0.1.0/24 (us-east-1a) - Load Balancers
│   └── 10.0.2.0/24 (us-east-1b) - Bastion
├── Private Subnets (NAT Gateway)
│   ├── 10.0.10.0/24 (us-east-1a) - Application
│   ├── 10.0.11.0/24 (us-east-1b) - Application
│   ├── 10.0.20.0/24 (us-east-1a) - Database
│   └── 10.0.21.0/24 (us-east-1b) - Database
```

**5.2 IAM Roles and Policies (Least Privilege)**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "arn:aws:ecr:*:*:repository/myapp/*"
    }
  ]
}
```

**5.3 Security Groups and NACLs Configuration**
```bash
# Create security group
aws ec2 create-security-group \
  --group-name api-sg \
  --description "API server security group" \
  --vpc-id $VPC_ID

# Allow HTTPS from anywhere
aws ec2 authorize-security-group-ingress \
  --group-id $SG_ID \
  --protocol tcp \
  --port 443 \
  --cidr 0.0.0.0/0
```

**5.4-5.16**: EC2 setup, RDS PostgreSQL, S3 buckets, ECR, CloudWatch, IAM for EKS/CI/CD, Parameter Store, Secrets Manager, VPC Peering, S3 encryption, CloudTrail

### Key Interview Questions

**Q: What's the difference between Security Groups and NACLs?**
A:
- **Security Groups**: Stateful, instance-level, allow rules only
- **NACLs**: Stateless, subnet-level, allow and deny rules
- Security Groups are typically sufficient for most use cases

**Q: Explain VPC peering vs Transit Gateway.**
A:
- **VPC Peering**: Direct connection between two VPCs, non-transitive
- **Transit Gateway**: Hub connecting multiple VPCs, transitive routing
- Transit Gateway better for many VPCs (>10)

---

## Part 6: Terraform Infrastructure as Code

### Task List (14 Comprehensive Tasks)

**6.1 Terraform Project Structure and Best Practices**
```
terraform/
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── eks/
│   └── rds/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   └── prod/
└── README.md
```

**6.2 Remote State with S3 and DynamoDB Locking**
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "myapp-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

**6.3 VPC Module Creation and Usage**
```hcl
# modules/vpc/main.tf
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-vpc"
    }
  )
}

# modules/vpc/variables.tf
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# Usage in environments/prod/main.tf
module "vpc" {
  source = "../../modules/vpc"
  
  vpc_cidr    = "10.0.0.0/16"
  environment = "production"
  
  tags = {
    Project = "myapp"
    Team    = "platform"
  }
}
```

**6.4 EKS Cluster Provisioning**
```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${var.environment}-eks"
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 10

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
    }
  }
}
```

**6.5-6.14**: Multi-environment setup, Variables/Locals, Data sources, RDS module, S3/IAM, Workspaces, Tagging strategy, Import, Lifecycle rules, Secrets management

### Key Interview Questions

**Q: Explain Terraform state and why it's important.**
A: Terraform state maps real infrastructure to configuration. It:
- Tracks resource metadata
- Enables performance optimization
- Stores resource dependencies
- Should be stored remotely with locking

**Q: What's the difference between `terraform plan` and `terraform apply`?**
A:
- `plan`: Shows what changes will be made (dry-run)
- `apply`: Actually makes the changes
- Always review plan output before applying

---

## Part 7: Kubernetes Deployment & Operations

### Task List (20 Comprehensive Tasks)

**7.1 Namespace Organization**
```yaml
# namespaces.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: development
  labels:
    environment: dev
---
apiVersion: v1
kind: Namespace
metadata:
  name: production
  labels:
    environment: prod
```

**7.2 Deploy Backend API with Deployment**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-backend
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api-backend
  template:
    metadata:
      labels:
        app: api-backend
        version: v1.2.0
    spec:
      containers:
      - name: api
        image: myapp/backend:v1.2.0
        ports:
        - containerPort: 8080
          name: http
        env:
        - name: NODE_ENV
          value: production
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: db_host
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: password
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

**7.3 Service Types**
```yaml
# ClusterIP (internal)
apiVersion: v1
kind: Service
metadata:
  name: api-backend
spec:
  type: ClusterIP
  selector:
    app: api-backend
  ports:
  - port: 80
    targetPort: 8080
---
# LoadBalancer (external)
apiVersion: v1
kind: Service
metadata:
  name: api-backend-public
spec:
  type: LoadBalancer
  selector:
    app: api-backend
  ports:
  - port: 443
    targetPort: 8080
```

**7.4 ConfigMaps**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  db_host: "postgres.production.svc.cluster.local"
  db_port: "5432"
  db_name: "myapp"
  redis_url: "redis://redis.production.svc.cluster.local:6379"
  log_level: "info"
  app_config.json: |
    {
      "features": {
        "newUI": true,
        "betaFeatures": false
      }
    }
```

**7.5 Secrets Management**
```bash
# Create secret from literal
kubectl create secret generic db-credentials \
  --from-literal=username=dbuser \
  --from-literal=password=supersecret \
  --namespace=production

# Create secret from file
kubectl create secret generic tls-cert \
  --from-file=tls.crt=./cert.pem \
  --from-file=tls.key=./key.pem \
  --namespace=production

# Use in pod
env:
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: db-credentials
      key: password
```

**7.6-7.20**: Liveness/Readiness probes, Ingress, HPA, RBAC, StatefulSet, PV/PVC, CronJobs, Resource limits, PodDisruptionBudget, Rolling updates, Network policies, Troubleshooting, Jobs, DaemonSets, Advanced kubectl

### Key Interview Questions

**Q: Explain the difference between Deployment, StatefulSet, and DaemonSet.**
A:
- **Deployment**: Stateless apps, any pod is interchangeable, rolling updates
- **StatefulSet**: Stateful apps, stable network IDs, ordered deployment, persistent storage
- **DaemonSet**: One pod per node, system-level services (logging, monitoring)

**Q: What's the difference between liveness and readiness probes?**
A:
- **Liveness**: Is the app alive? If fails, restart pod
- **Readiness**: Is the app ready to serve traffic? If fails, remove from service endpoints
- **Startup**: Is the app starting up? Used for slow-starting apps

**Q: How does HorizontalPodAutoscaler work?**
A: HPA scales pods based on metrics:
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-backend
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

## Part 8: Jenkins CI/CD Pipeline

### Task List (12 Comprehensive Tasks)

**8.1 Jenkins Installation and Initial Configuration**
```bash
# Install Jenkins on Ubuntu
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

**8.2 Configure Jenkins Agents**
```groovy
// Jenkinsfile with agent selection
pipeline {
    agent {
        label 'docker'  // Run on agent with 'docker' label
    }
    
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:18'
                    label 'docker'
                }
            }
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
    }
}
```

**8.3 Multibranch Pipeline Setup**
- Configure GitHub organization
- Automatic Jenkinsfile detection
- Branch indexing and webhooks

**8.4 Declarative Jenkinsfile for CI/CD**
```groovy
pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp'
        IMAGE_TAG = "${env.GIT_COMMIT.take(7)}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                script {
                    sh 'npm install'
                    sh 'npm run build'
                    sh 'npm test'
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    docker.build("${ECR_REPO}:${IMAGE_TAG}")
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    docker.withRegistry("https://${ECR_REPO}", 'ecr:us-east-1:aws-credentials') {
                        docker.image("${ECR_REPO}:${IMAGE_TAG}").push()
                        docker.image("${ECR_REPO}:${IMAGE_TAG}").push('latest')
                    }
                }
            }
        }
        
        stage('Deploy to Dev') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    sh """
                        kubectl set image deployment/api-backend \
                          api=${ECR_REPO}:${IMAGE_TAG} \
                          --namespace=development
                    """
                }
            }
        }
        
        stage('Deploy to Prod') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
                script {
                    sh """
                        kubectl set image deployment/api-backend \
                          api=${ECR_REPO}:${IMAGE_TAG} \
                          --namespace=production
                    """
                }
            }
        }
    }
    
    post {
        success {
            slackSend color: 'good', message: "Build ${env.BUILD_NUMBER} succeeded"
        }
        failure {
            slackSend color: 'danger', message: "Build ${env.BUILD_NUMBER} failed"
        }
    }
}
```

**8.5-8.12**: Docker build/push, K8s deployment, Credentials management, GitHub webhooks, Manual approvals, Parallel stages, Shared libraries, Artifacts/Reports

### Key Interview Questions

**Q: What's the difference between Declarative and Scripted Pipeline?**
A:
- **Declarative**: Structured syntax, easier to read, recommended
- **Scripted**: Groovy code, more flexible, complex
- Declarative is preferred for most use cases

**Q: How do you handle secrets in Jenkins?**
A:
1. Jenkins Credentials Plugin
2. Store in Jenkins credentials store
3. Reference in Jenkinsfile:
```groovy
withCredentials([
    string(credentialsId: 'api-key', variable: 'API_KEY')
]) {
    sh 'deploy.sh'
}
```

---

## Part 9: GitHub Actions CI/CD

### Task List (12 Comprehensive Tasks)

**9.1 GitHub Actions Workflow Basics**
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

**9.2 CI Pipeline for Pull Requests**
```yaml
name: PR Checks

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run lint
  
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm test
  
  build:
    runs-on: ubuntu-latest
    needs: [lint, test]
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run build
```

**9.3 Docker Build and Push to ECR**
```yaml
name: Build and Push

on:
  push:
    branches: [ main ]

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
      
      - name: Build, tag, and push image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: myapp-backend
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
          docker tag $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPOSITORY:latest
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:latest
```

**9.4-9.12**: K8s deployment, Environment protection, Reusable workflows, Matrix strategy, Caching, Scheduled workflows, Custom actions, Secrets, Status badges

### Key Interview Questions

**Q: How do you secure secrets in GitHub Actions?**
A:
1. Store in GitHub Secrets (Settings → Secrets)
2. Reference: `${{ secrets.SECRET_NAME }}`
3. Use environment protection for sensitive workflows
4. Never echo secrets in logs

**Q: Explain the difference between `on: push` and `on: pull_request`.**
A:
- `push`: Runs on every push to branch
- `pull_request`: Runs when PR is opened/updated
- Use both for complete CI/CD

---

## Part 10: Prometheus Monitoring & Alerting

### Task List (12 Comprehensive Tasks)

**10.1 Prometheus Architecture and Installation**
```yaml
# prometheus-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus:latest
        ports:
        - containerPort: 9090
        volumeMounts:
        - name: config
          mountPath: /etc/prometheus
      volumes:
      - name: config
        configMap:
          name: prometheus-config
```

**10.2 Node Exporter for System Metrics**
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
    spec:
      hostNetwork: true
      hostPID: true
      containers:
      - name: node-exporter
        image: prom/node-exporter:latest
        ports:
        - containerPort: 9100
```

**10.3 Application Metrics Instrumentation**
```javascript
// Node.js with prom-client
const promClient = require('prom-client');

// Create metrics
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code']
});

const httpRequestsTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

// Middleware to track metrics
app.use((req, res, next) => {
  const end = httpRequestDuration.startTimer();
  res.on('finish', () => {
    httpRequestsTotal.inc({
      method: req.method,
      route: req.route?.path || req.path,
      status_code: res.statusCode
    });
    end({
      method: req.method,
      route: req.route?.path || req.path,
      status_code: res.statusCode
    });
  });
  next();
});

// Metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(await promClient.register.metrics());
});
```

**10.4 Service Discovery in Kubernetes**
```yaml
# prometheus-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s
    
    scrape_configs:
      - job_name: 'kubernetes-pods'
        kubernetes_sd_configs:
          - role: pod
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: true
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
            action: replace
            target_label: __metrics_path__
            regex: (.+)
          - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
            action: replace
            regex: ([^:]+)(?::\d+)?;(\d+)
            replacement: $1:$2
            target_label: __address__
```

**10.5 PromQL Fundamentals**
```promql
# Request rate
rate(http_requests_total[5m])

# Error rate
rate(http_requests_total{status_code=~"5.."}[5m])

# Error percentage
sum(rate(http_requests_total{status_code=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100

# 95th percentile latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# CPU usage by pod
sum(rate(container_cpu_usage_seconds_total{pod=~"api-.*"}[5m])) by (pod)

# Memory usage
container_memory_working_set_bytes{pod=~"api-.*"}

# Disk usage percentage
(node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes * 100
```

**10.6-10.12**: Recording rules, Alerting rules, Alertmanager, SLO-based alerting, Alert routing, Slack/Email integration, Grafana dashboards

### Key Interview Questions

**Q: What's the difference between recording rules and alerting rules?**
A:
- **Recording rules**: Pre-compute expensive queries, store as new time series
- **Alerting rules**: Evaluate conditions, trigger alerts when true

**Q: Explain the four golden signals of monitoring.**
A:
1. **Latency**: Time to serve requests
2. **Traffic**: Demand on your system
3. **Errors**: Rate of failed requests
4. **Saturation**: Resource utilization

**Q: How do you implement SLO-based alerting?**
A:
```yaml
# Alert on error budget burn
- alert: ErrorBudgetBurn
  expr: |
    (
      sum(rate(http_requests_total{status_code=~"5.."}[1h]))
      /
      sum(rate(http_requests_total[1h]))
    ) > 0.001  # 0.1% error rate (99.9% SLO)
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "Error budget burning too fast"
```

---

## Completion Checklist

- ✅ Part 1: Linux (18 tasks)
- ✅ Part 2: Bash (14 tasks)
- ✅ Part 3: GitHub (10 tasks)
- ✅ Part 4: Ansible (14 tasks)
- ✅ Part 5: AWS (16 tasks)
- ✅ Part 6: Terraform (14 tasks)
- ✅ Part 7: Kubernetes (20 tasks)
- ✅ Part 8: Jenkins (12 tasks)
- ✅ Part 9: GitHub Actions (12 tasks)
- ✅ Part 10: Prometheus (12 tasks)

**Total: 140+ Comprehensive DevOps Tasks**

Each task follows the structure:
1. Goal / Why Important
2. Prerequisites
3. Step-by-Step Implementation
4. Key Commands
5. Verification
6. Common Mistakes
7. 5-10 Interview Questions with Answers

---

## Next Steps

1. Practice each task hands-on
2. Build a portfolio project using these skills
3. Review interview questions regularly
4. Join DevOps communities for support
5. Keep learning and stay updated

**Good luck with your DevOps journey! 🚀**
