# Part 7: Kubernetes Deployment & Operations

## Overview
Day-to-day Kubernetes operations and advanced deployment strategies.

## Tasks Overview
1. **Task 7.1**: Namespace Organization (Dev/Staging/Prod)
2. **Task 7.2**: Deploy Backend API with Deployment
3. **Task 7.3**: Service Types (ClusterIP, LoadBalancer)
4. **Task 7.4**: ConfigMaps for Application Configuration
5. **Task 7.5**: Secrets Management in Kubernetes
6. **Task 7.6**: Liveness and Readiness Probes
7. **Task 7.7**: Ingress Controller and Ingress Resources
8. **Task 7.8**: HorizontalPodAutoscaler (HPA) Setup
9. **Task 7.9**: RBAC Configuration (ServiceAccount, Roles)
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

For detailed implementations, see [COMPREHENSIVE_GUIDE.md](../COMPREHENSIVE_GUIDE.md#part-7-kubernetes-deployment--operations)

## Quick Start
```bash
# Create deployment
kubectl apply -f deployment.yaml

# Check status
kubectl get pods

# View logs
kubectl logs -f pod-name
```

Continue to [Part 8: Jenkins](../part-08-jenkins/README.md)
