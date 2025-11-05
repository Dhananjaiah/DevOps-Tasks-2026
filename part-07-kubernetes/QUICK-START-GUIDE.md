# Kubernetes Deployment & Operations Real-World Tasks - Quick Start Guide

This guide helps you quickly find the right resource for your needs.

## 📖 How to Use These Resources

### For Learning and Practice

1. **Start with:** [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)
   - Read the scenario and requirements
   - Understand what needs to be accomplished
   - Review the validation checklist
   - Try to implement the solution yourself

2. **When you need help:** [REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)
   - Find the same task number
   - Follow the step-by-step commands
   - Use the provided Kubernetes manifests
   - Verify your implementation

3. **For deeper understanding:** [README.md](README.md)
   - Explore additional examples
   - Learn the "why" behind each step
   - Understand best practices
   - Review interview questions and answers

## 🎯 Quick Task Lookup

| Task | Scenario | Solution Link | Time | Difficulty |
|------|----------|---------------|------|------------|
| 7.1 | Microservices Application Deployment | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-71-deploy-microservices-application-with-deployments) | 4-5 hrs | Medium |
| 7.2 | Ingress with TLS Configuration | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-72-configure-ingress-with-tls-for-external-access) | 3-4 hrs | Easy |
| 7.3 | ConfigMaps and Secrets Management | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-73-implement-configmaps-and-secrets-management) | 3-4 hrs | Easy |
| 7.4 | Horizontal Pod Autoscaler Setup | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-74-set-up-horizontal-pod-autoscaler-hpa) | 3-4 hrs | Easy |
| 7.5 | StatefulSet for Database | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-75-implement-statefulset-for-database) | 4-5 hrs | Medium |
| 7.6 | RBAC and Network Policies | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-76-configure-rbac-and-network-policies) | 3-4 hrs | Easy |

## 🔍 Find Tasks by Category

### Application Deployment
- **Task 7.1**: Microservices Application Deployment (Medium, 4-5 hrs)
  - Create Deployment manifests
  - Configure Service resources
  - Implement health checks
  - Set up resource limits
  - Configure rolling updates

### Ingress & External Access
- **Task 7.2**: Ingress with TLS Configuration (Easy, 3-4 hrs)
  - Install Ingress Controller
  - Configure Ingress resources
  - Set up TLS certificates
  - Implement path-based routing
  - Configure SSL/TLS termination

### Configuration Management
- **Task 7.3**: ConfigMaps and Secrets Management (Easy, 3-4 hrs)
  - Create ConfigMaps for app config
  - Implement Secrets for sensitive data
  - Mount configs as volumes
  - Use environment variables
  - Implement config updates

### Auto-Scaling
- **Task 7.4**: Horizontal Pod Autoscaler Setup (Easy, 3-4 hrs)
  - Install metrics server
  - Configure HPA resources
  - Set up CPU-based scaling
  - Implement custom metrics
  - Test autoscaling behavior

### Stateful Applications
- **Task 7.5**: StatefulSet for Database (Medium, 4-5 hrs)
  - Create StatefulSet manifest
  - Configure PersistentVolumeClaims
  - Implement headless Service
  - Set up init containers
  - Configure backup procedures

### Security & Network Policies
- **Task 7.6**: RBAC and Network Policies (Easy, 3-4 hrs)
  - Configure ServiceAccounts
  - Create Roles and RoleBindings
  - Implement ClusterRoles
  - Set up Network Policies
  - Test access controls

## 📊 Task Difficulty & Time Estimates

### Easy Tasks (0.5 Story Points)
Perfect for beginners or when time is limited:
- Task 7.2: Ingress with TLS Configuration (3-4 hrs)
- Task 7.3: ConfigMaps and Secrets Management (3-4 hrs)
- Task 7.4: Horizontal Pod Autoscaler Setup (3-4 hrs)
- Task 7.6: RBAC and Network Policies (3-4 hrs)

### Medium Tasks (1.0 Story Points)
For intermediate learners looking for challenges:
- Task 7.1: Microservices Application Deployment (4-5 hrs)
- Task 7.5: StatefulSet for Database (4-5 hrs)

## 🎓 Suggested Learning Paths

### Path 1: Beginner's Journey (Start Here!)
1. **Task 7.3**: ConfigMaps and Secrets Management
   - Learn configuration basics
   - Understand config injection
   - Master secrets handling

2. **Task 7.1**: Microservices Application Deployment
   - Deploy applications
   - Configure services
   - Implement health checks

3. **Task 7.2**: Ingress with TLS Configuration
   - Expose applications externally
   - Configure load balancing
   - Implement TLS

### Path 2: Production Deployment Focus
1. **Task 7.1**: Microservices Application Deployment
   - Deploy complete applications
   
2. **Task 7.4**: Horizontal Pod Autoscaler Setup
   - Implement auto-scaling
   
3. **Task 7.6**: RBAC and Network Policies
   - Secure your cluster
   
4. **Task 7.2**: Ingress with TLS Configuration
   - Expose services securely

### Path 3: Complete Kubernetes Mastery
Complete all tasks in order:
1. Task 7.3 (Configuration)
2. Task 7.1 (Deployment)
3. Task 7.4 (Scaling)
4. Task 7.2 (Ingress)
5. Task 7.6 (Security)
6. Task 7.5 (Stateful Apps)

## ⚡ Quick Start Steps

### 1. Prerequisites Check
Before starting any task, ensure you have:
- [ ] Kubernetes cluster (minikube, kind, or cloud)
- [ ] kubectl installed (1.24+)
- [ ] Basic understanding of YAML
- [ ] Docker basics knowledge
- [ ] Git for version control
- [ ] Text editor (VS Code with Kubernetes extension recommended)

### 2. Environment Setup
```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify installation
kubectl version --client

# Set up local cluster (using minikube)
minikube start --driver=docker

# Verify cluster
kubectl cluster-info
kubectl get nodes

# Clone repository
git clone https://github.com/Dhananjaiah/DevOps-Tasks-2026.git
cd DevOps-Tasks-2026/part-07-kubernetes

# Create working directory
mkdir -p ~/k8s-practice
cd ~/k8s-practice
```

### 3. Pick Your First Task
- Review the task categories above
- Choose based on your skill level
- Note the time estimate
- Open [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)

### 4. Implementation Workflow
```
Read Task → Design Manifests → Apply → Test → Debug → Verify → Compare with Solution
```

## 🛠️ Common Tools & Commands

### Essential kubectl Commands
```bash
# Get resources
kubectl get pods
kubectl get deployments
kubectl get services
kubectl get ingress

# Describe resources
kubectl describe pod <pod-name>
kubectl describe deployment <deployment-name>

# Create/Apply resources
kubectl apply -f manifest.yaml
kubectl apply -f directory/

# Delete resources
kubectl delete -f manifest.yaml
kubectl delete pod <pod-name>

# Logs and debugging
kubectl logs <pod-name>
kubectl logs -f <pod-name>  # Follow logs
kubectl exec -it <pod-name> -- /bin/sh

# Port forwarding
kubectl port-forward pod/<pod-name> 8080:80

# Get YAML/JSON
kubectl get deployment <name> -o yaml
kubectl get pod <name> -o json
```

### Testing & Validation
```bash
# Dry run
kubectl apply -f manifest.yaml --dry-run=client

# Validate manifests
kubectl apply -f manifest.yaml --dry-run=server

# Check resource status
kubectl rollout status deployment/<deployment-name>

# View events
kubectl get events --sort-by=.metadata.creationTimestamp

# Top resources
kubectl top nodes
kubectl top pods
```

## 📋 Task Completion Checklist

For each task you complete, verify:
- [ ] Meets all requirements from task description
- [ ] Follows Kubernetes best practices
- [ ] Implements proper labels and selectors
- [ ] Has health checks (liveness/readiness probes)
- [ ] Resource requests and limits defined
- [ ] Uses appropriate workload type
- [ ] Manifests properly structured
- [ ] Documentation included
- [ ] Tested successfully
- [ ] Security considerations addressed
- [ ] Compared with provided solution

## 💡 Pro Tips

### Best Practices
1. **Always use namespaces**: Organize resources logically
2. **Set resource limits**: Prevent resource exhaustion
3. **Implement health checks**: Ensure application reliability
4. **Use labels effectively**: Organize and select resources
5. **Version your manifests**: Use Git for tracking changes
6. **Document your work**: Add comments and README files

### Troubleshooting
1. **Check pod status**: `kubectl get pods` first
2. **View logs**: Use `kubectl logs` for debugging
3. **Describe resources**: Get detailed information
4. **Check events**: Review cluster events
5. **Validate YAML**: Use online validators or kubectl

### Time-Saving Tricks
1. **Use kubectl aliases**: Set up shell aliases
2. **Use dry-run**: Test before applying
3. **Use generators**: Generate boilerplate YAML
4. **Use kustomize**: Manage variations
5. **Use helm**: Package applications

## 🔗 Quick Links

### Documentation
- [Main README](../README.md) - Repository overview
- [Kubernetes Docs](https://kubernetes.io/docs/) - Official documentation
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

### Within This Section
- [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md) - Task descriptions
- [REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md) - Complete solutions
- [README.md](README.md) - Detailed Kubernetes guide

## 📈 Track Your Progress

| Task | Status | Date Completed | Notes |
|------|--------|----------------|-------|
| 7.1  | ⬜     |                |       |
| 7.2  | ⬜     |                |       |
| 7.3  | ⬜     |                |       |
| 7.4  | ⬜     |                |       |
| 7.5  | ⬜     |                |       |
| 7.6  | ⬜     |                |       |

Status Legend: ⬜ Not Started | 🔄 In Progress | ✅ Completed

---

**Ready to begin?** Choose your first task from [REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md) and start building! 🚀
