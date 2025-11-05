# Part 7: Kubernetes Deployment & Operations

## Overview

This section covers comprehensive Kubernetes skills required for DevOps engineers managing containerized applications in production. All tasks are based on real-world scenarios from operating production Kubernetes clusters.

## 📚 Available Resources

### Real-World Tasks (Recommended Starting Point)
- **[REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)** - 📝 20 practical, executable tasks with scenarios, requirements, and validation checklists
- **[REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)** - ✅ Complete, production-ready solutions with step-by-step manifests and commands
- **[NAVIGATION-GUIDE.md](NAVIGATION-GUIDE.md)** - 📚 **NEW!** Learn how to navigate between tasks and solutions efficiently

### Quick Start & Additional Resources
- **[QUICK-START-GUIDE.md](QUICK-START-GUIDE.md)** - 🚀 Quick reference with task lookup table and learning paths

> **💡 New to real-world tasks?** Check out the [Navigation Guide](NAVIGATION-GUIDE.md) to understand how tasks and solutions are organized!

---

## Tasks Overview

### Core Kubernetes Concepts
1. **Task 7.1**: Namespace Organization and Resource Quotas - Isolate environments and control resources
2. **Task 7.2**: Deploy Backend API with Deployment - Create production-ready deployments
3. **Task 7.3**: Service Types and Networking - Expose applications with Services
4. **Task 7.4**: ConfigMaps for Application Configuration - Externalize configuration
5. **Task 7.5**: Secrets Management - Handle sensitive data securely

### Health and Reliability
6. **Task 7.6**: Liveness and Readiness Probes - Implement health checks
7. **Task 7.8**: HorizontalPodAutoscaler (HPA) - Auto-scale based on metrics
8. **Task 7.14**: PodDisruptionBudget - Ensure availability during maintenance
9. **Task 7.15**: Rolling Updates and Rollbacks - Deploy updates safely

### Networking and Ingress
7. **Task 7.7**: Ingress Controller and Ingress Resources - HTTP routing and load balancing
10. **Task 7.16**: Network Policies for Security - Control pod-to-pod communication

### Persistent Storage
11. **Task 7.10**: StatefulSet for PostgreSQL - Deploy stateful applications
12. **Task 7.11**: PersistentVolumes and PersistentVolumeClaims - Manage persistent storage

### Scheduling and Jobs
13. **Task 7.12**: CronJobs for Scheduled Tasks - Schedule periodic jobs
14. **Task 7.18**: Jobs for One-Time Tasks - Run batch processes
15. **Task 7.19**: DaemonSets for Node-Level Services - Deploy node agents

### Resource Management and Security
16. **Task 7.13**: Resource Requests and Limits - Control resource allocation
17. **Task 7.9**: RBAC Configuration - Implement access control

### Operations
18. **Task 7.17**: Troubleshooting Pods and Deployments - Debug production issues
19. **Task 7.20**: Advanced Kubectl Techniques - Master kubectl for efficiency

---

## Quick Start

### Prerequisites

```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify installation
kubectl version --client

# Set up a local cluster (choose one)
# Option 1: Minikube
minikube start

# Option 2: Kind
kind create cluster

# Option 3: Docker Desktop (enable Kubernetes in settings)

# Verify cluster access
kubectl cluster-info
kubectl get nodes
```

### Common Commands

```bash
# Create resources
kubectl apply -f deployment.yaml
kubectl create namespace dev

# View resources
kubectl get pods
kubectl get deployments
kubectl get services
kubectl get all -n namespace

# Describe resources
kubectl describe pod pod-name
kubectl describe deployment deployment-name

# View logs
kubectl logs pod-name
kubectl logs -f pod-name  # Follow logs
kubectl logs pod-name -c container-name  # Specific container

# Execute commands in pods
kubectl exec -it pod-name -- /bin/bash
kubectl exec pod-name -- ls /app

# Debug
kubectl get events
kubectl get pods -o wide
kubectl top nodes
kubectl top pods

# Update resources
kubectl set image deployment/app app=app:v2
kubectl scale deployment app --replicas=5
kubectl rollout status deployment/app
kubectl rollout undo deployment/app

# Delete resources
kubectl delete pod pod-name
kubectl delete -f deployment.yaml
```

### Learning Path

**Beginners** (Start here):
1. Task 7.1: Namespace Organization
2. Task 7.4: ConfigMaps
3. Task 7.12: CronJobs
4. Task 7.18: Jobs

**Intermediate**:
1. Task 7.2: Deploy Backend API
2. Task 7.3: Service Types
3. Task 7.6: Health Probes
4. Task 7.13: Resource Limits

**Advanced**:
1. Task 7.7: Ingress Controller
2. Task 7.8: HorizontalPodAutoscaler
3. Task 7.9: RBAC Configuration
4. Task 7.10: StatefulSets
5. Task 7.16: Network Policies

---

## Key Concepts

### Pods
- Smallest deployable unit in Kubernetes
- Contains one or more containers
- Share network and storage
- Ephemeral by design

### Deployments
- Manage ReplicaSets
- Handle rolling updates
- Enable rollbacks
- Declarative updates

### Services
- Stable network endpoint
- Load balance across pods
- Enable service discovery
- Types: ClusterIP, NodePort, LoadBalancer

### ConfigMaps & Secrets
- ConfigMaps: Non-sensitive configuration
- Secrets: Sensitive data (base64 encoded)
- Can be environment variables or files
- Decouple config from images

### Namespaces
- Virtual clusters
- Resource isolation
- Resource quotas
- RBAC boundaries

---

## Best Practices

### Security
- Use RBAC for access control
- Run containers as non-root
- Use Network Policies
- Scan images for vulnerabilities
- Use Secrets for sensitive data
- Implement Pod Security Standards

### Resource Management
- Always set resource requests and limits
- Use HorizontalPodAutoscaler for scaling
- Implement PodDisruptionBudgets
- Use LimitRanges and ResourceQuotas
- Monitor resource usage

### Reliability
- Use multiple replicas
- Implement health probes
- Configure pod anti-affinity
- Use rolling updates
- Test rollback procedures
- Implement proper logging

### Operations
- Use labels for organization
- Implement comprehensive monitoring
- Use namespaces for isolation
- Document runbooks
- Automate with CI/CD
- Regular cluster maintenance

---

## Troubleshooting

### Pod Issues

```bash
# Pod not starting
kubectl describe pod pod-name
kubectl get events --sort-by='.lastTimestamp'

# Common states
# - Pending: Scheduling issue (resources, node selector)
# - ImagePullBackOff: Can't pull image
# - CrashLoopBackOff: Container keeps crashing
# - Error: Container exited with error

# Check logs
kubectl logs pod-name
kubectl logs pod-name --previous  # Previous container

# Debug running pod
kubectl exec -it pod-name -- /bin/bash
```

### Networking Issues

```bash
# Test service connectivity
kubectl run test --image=curlimages/curl --rm -it -- curl service-name:port

# Check service endpoints
kubectl get endpoints service-name

# Verify DNS
kubectl run test --image=busybox --rm -it -- nslookup service-name

# Check Network Policies
kubectl get networkpolicies
```

### Resource Issues

```bash
# Check node resources
kubectl top nodes
kubectl describe nodes

# Check pod resources
kubectl top pods
kubectl describe pod pod-name | grep -A 5 "Limits\\|Requests"

# Check quota usage
kubectl describe resourcequota -n namespace
```

---

## Interview Preparation

Common Kubernetes interview topics covered in these tasks:

1. **Architecture**: Pods, Deployments, Services, Ingress
2. **Networking**: Service discovery, DNS, Network Policies
3. **Storage**: PVs, PVCs, StatefulSets
4. **Security**: RBAC, Secrets, Security Contexts
5. **Scaling**: HPA, resource limits, cluster autoscaler
6. **Operations**: Rolling updates, troubleshooting, kubectl commands
7. **Advanced**: Custom controllers, operators, service mesh

---

## Tools and Ecosystem

### Essential Tools
- **kubectl** - Command-line tool
- **Helm** - Package manager
- **Kustomize** - Configuration management
- **k9s** - Terminal UI
- **Lens** - Desktop IDE

### Monitoring & Observability
- **Prometheus** - Metrics collection
- **Grafana** - Visualization
- **ELK/EFK Stack** - Log aggregation
- **Jaeger/Zipkin** - Distributed tracing

### CI/CD Integration
- **ArgoCD** - GitOps continuous delivery
- **Flux** - GitOps operator
- **Tekton** - Cloud-native CI/CD
- **Jenkins X** - CI/CD for Kubernetes

---

## Additional Resources

### Official Documentation
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Kubectl Reference](https://kubernetes.io/docs/reference/kubectl/)
- [API Reference](https://kubernetes.io/docs/reference/)

### Certifications
- [CKAD](https://www.cncf.io/certification/ckad/) - Certified Kubernetes Application Developer
- [CKA](https://www.cncf.io/certification/cka/) - Certified Kubernetes Administrator
- [CKS](https://www.cncf.io/certification/cks/) - Certified Kubernetes Security Specialist

### Learning Resources
- [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
- [Play with Kubernetes](https://labs.play-with-k8s.com/)
- [KodeKloud](https://kodekloud.com/)

---

Continue to [Part 8: Jenkins](../part-08-jenkins/README.md)
