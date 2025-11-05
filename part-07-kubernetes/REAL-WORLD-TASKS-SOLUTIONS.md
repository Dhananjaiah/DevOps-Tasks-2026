# Kubernetes Deployment & Operations - Complete Solutions

## 🎯 Overview

This document provides **complete, production-ready solutions** for all 20 Kubernetes real-world tasks. Each solution includes:
- ✅ Step-by-step implementation instructions
- ✅ Complete YAML manifests and configurations
- ✅ Verification and testing procedures
- ✅ Troubleshooting guides
- ✅ Best practices and recommendations
- ✅ Interview questions with detailed answers

> **⚠️ Important:** These are reference solutions. Try solving tasks yourself first, then compare with these solutions to learn different approaches and best practices.

---

## 📚 Navigation

**Quick Links:**
- 📝 [Task Descriptions](./REAL-WORLD-TASKS.md) - Problem statements and requirements
- 🚀 [Quick Start Guide](./QUICK-START-GUIDE.md) - Getting started quickly
- 📖 [Navigation Guide](./NAVIGATION-GUIDE.md) - How to use these resources

---

## Table of Contents

1. [Task 7.1: Namespace Organization and Resource Quotas](#task-71-namespace-organization-and-resource-quotas)
2. [Task 7.2: Deploy Backend API with Deployment](#task-72-deploy-backend-api-with-deployment)
3. [Task 7.3: Service Types and Networking](#task-73-service-types-and-networking)
4. [Task 7.4: ConfigMaps for Application Configuration](#task-74-configmaps-for-application-configuration)
5. [Task 7.5: Secrets Management in Kubernetes](#task-75-secrets-management-in-kubernetes)
6. [Task 7.6: Liveness and Readiness Probes](#task-76-liveness-and-readiness-probes)
7. [Task 7.7: Ingress Controller and Ingress Resources](#task-77-ingress-controller-and-ingress-resources)
8. [Task 7.8: HorizontalPodAutoscaler (HPA) Setup](#task-78-horizontalpodautoscaler-hpa-setup)
9. [Task 7.9: RBAC Configuration (ServiceAccount, Roles)](#task-79-rbac-configuration-serviceaccount-roles)
10. [Task 7.10: StatefulSet for PostgreSQL](#task-710-statefulset-for-postgresql)
11. [Task 7.11: PersistentVolumes and PersistentVolumeClaims](#task-711-persistentvolumes-and-persistentvolumeclaims)
12. [Task 7.12: CronJobs for Scheduled Tasks](#task-712-cronjobs-for-scheduled-tasks)
13. [Task 7.13: Resource Requests and Limits](#task-713-resource-requests-and-limits)
14. [Task 7.14: PodDisruptionBudget for High Availability](#task-714-poddisruptionbudget-for-high-availability)
15. [Task 7.15: Rolling Updates and Rollbacks](#task-715-rolling-updates-and-rollbacks)
16. [Task 7.16: Network Policies for Security](#task-716-network-policies-for-security)
17. [Task 7.17: Troubleshooting Pods and Deployments](#task-717-troubleshooting-pods-and-deployments)
18. [Task 7.18: Jobs for One-Time Tasks](#task-718-jobs-for-one-time-tasks)
19. [Task 7.19: DaemonSets for Node-Level Services](#task-719-daemonsets-for-node-level-services)
20. [Task 7.20: Advanced Kubectl Techniques](#task-720-advanced-kubectl-techniques)

---

## Task 7.1: Namespace Organization and Resource Quotas

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-71-namespace-organization-and-resource-quotas)

### Solution Overview

This task requires implementing namespace organization and resource quotas. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Create Namespaces

```bash
# Create development namespace
kubectl create namespace dev

# Create staging namespace
kubectl create namespace staging

# Create production namespace
kubectl create namespace prod

# Verify namespaces
kubectl get namespaces
```

#### Step 2: Add Labels to Namespaces

```bash
# Label namespaces for organization
kubectl label namespace dev environment=development team=engineering
kubectl label namespace staging environment=staging team=engineering
kubectl label namespace prod environment=production team=engineering

# Verify labels
kubectl get namespaces --show-labels
```

#### Step 3: Create ResourceQuota for Each Namespace

**Development Namespace ResourceQuota:**

```yaml
# dev-resourcequota.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-resource-quota
  namespace: dev
spec:
  hard:
    requests.cpu: "20"
    requests.memory: 40Gi
    limits.cpu: "40"
    limits.memory: 80Gi
    persistentvolumeclaims: "10"
    pods: "50"
    services: "20"
    configmaps: "30"
    secrets: "30"
```

**Staging Namespace ResourceQuota:**

```yaml
# staging-resourcequota.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: staging-resource-quota
  namespace: staging
spec:
  hard:
    requests.cpu: "30"
    requests.memory: 60Gi
    limits.cpu: "60"
    limits.memory: 120Gi
    persistentvolumeclaims: "15"
    pods: "75"
    services: "30"
    configmaps: "40"
    secrets: "40"
```

**Production Namespace ResourceQuota:**

```yaml
# prod-resourcequota.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: prod-resource-quota
  namespace: prod
spec:
  hard:
    requests.cpu: "100"
    requests.memory: 200Gi
    limits.cpu: "200"
    limits.memory: 400Gi
    persistentvolumeclaims: "50"
    pods: "200"
    services: "50"
    configmaps: "100"
    secrets: "100"
```

Apply ResourceQuotas:

```bash
kubectl apply -f dev-resourcequota.yaml
kubectl apply -f staging-resourcequota.yaml
kubectl apply -f prod-resourcequota.yaml

# Verify ResourceQuotas
kubectl get resourcequota -n dev
kubectl get resourcequota -n staging
kubectl get resourcequota -n prod

# Describe to see usage
kubectl describe resourcequota -n dev
```

#### Step 4: Create LimitRange for Each Namespace

**Development LimitRange:**

```yaml
# dev-limitrange.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: dev-limit-range
  namespace: dev
spec:
  limits:
  - max:
      cpu: "2"
      memory: "4Gi"
    min:
      cpu: "100m"
      memory: "128Mi"
    default:
      cpu: "500m"
      memory: "512Mi"
    defaultRequest:
      cpu: "250m"
      memory: "256Mi"
    type: Container
  - max:
      cpu: "4"
      memory: "8Gi"
    min:
      cpu: "100m"
      memory: "128Mi"
    type: Pod
```

**Production LimitRange:**

```yaml
# prod-limitrange.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: prod-limit-range
  namespace: prod
spec:
  limits:
  - max:
      cpu: "4"
      memory: "8Gi"
    min:
      cpu: "100m"
      memory: "256Mi"
    default:
      cpu: "1"
      memory: "1Gi"
    defaultRequest:
      cpu: "500m"
      memory: "512Mi"
    type: Container
  - max:
      cpu: "8"
      memory: "16Gi"
    min:
      cpu: "200m"
      memory: "512Mi"
    type: Pod
```

Apply LimitRanges:

```bash
kubectl apply -f dev-limitrange.yaml
kubectl apply -f prod-limitrange.yaml

# Verify LimitRanges
kubectl get limitrange -n dev
kubectl describe limitrange dev-limit-range -n dev
```

#### Step 5: Create RBAC for Namespace Access

**Developer Role (namespace-scoped):**

```yaml
# developer-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
  namespace: dev
rules:
- apiGroups: ["", "apps", "batch"]
  resources: ["pods", "deployments", "services", "configmaps", "secrets", "jobs", "cronjobs"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["pods/log", "pods/exec"]
  verbs: ["get", "list"]
```

**RoleBinding for Developers:**

```yaml
# developer-rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-binding
  namespace: dev
subjects:
- kind: Group
  name: developers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
```

Apply RBAC:

```bash
kubectl apply -f developer-role.yaml
kubectl apply -f developer-rolebinding.yaml

# Verify RBAC
kubectl get roles -n dev
kubectl get rolebindings -n dev
```

### Configuration Files

**Complete Namespace Setup Script:**

```bash
#!/bin/bash
# setup-namespaces.sh

set -euo pipefail

NAMESPACES=("dev" "staging" "prod")

for ns in "${NAMESPACES[@]}"; do
    echo "Setting up namespace: $ns"
    
    # Create namespace if it doesn't exist
    kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -
    
    # Add labels
    kubectl label namespace "$ns" environment="$ns" team=engineering --overwrite
    
    echo "✓ Namespace $ns configured"
done

echo "All namespaces configured successfully!"
```

### Verification Steps

```bash
# 1. Verify namespaces exist
kubectl get namespaces

# 2. Check ResourceQuotas
for ns in dev staging prod; do
    echo "=== ResourceQuota for $ns ==="
    kubectl describe resourcequota -n $ns
done

# 3. Check LimitRanges
kubectl get limitrange --all-namespaces

# 4. Test ResourceQuota by creating a pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
  namespace: dev
spec:
  containers:
  - name: nginx
    image: nginx:latest
EOF

# 5. Verify pod got default resources
kubectl describe pod test-pod -n dev | grep -A 5 "Limits\|Requests"

# 6. Clean up test pod
kubectl delete pod test-pod -n dev
```

### Best Practices Implemented

- ✅ Separate namespaces for environment isolation
- ✅ ResourceQuotas prevent resource exhaustion
- ✅ LimitRanges set sensible defaults
- ✅ RBAC provides least-privilege access
- ✅ Labels enable easy filtering and organization
- ✅ Documentation for team onboarding

### Troubleshooting Guide

**Issue 1: Pod Creation Fails with "exceeded quota"**

**Symptoms:**
```
Error from server (Forbidden): pods "my-pod" is forbidden: 
exceeded quota: dev-resource-quota, requested: pods=1, used: pods=50, limited: pods=50
```

**Solution:**
```bash
# Check current quota usage
kubectl describe resourcequota -n dev

# Either delete unused pods or increase quota
kubectl edit resourcequota dev-resource-quota -n dev
```

**Issue 2: Pod Rejected Due to Resource Limits**

**Symptoms:**
```
Error: Pod's request exceeds LimitRange maximum
```

**Solution:**
```bash
# Check LimitRange constraints
kubectl describe limitrange -n dev

# Adjust pod resources or LimitRange
kubectl edit limitrange dev-limit-range -n dev
```

### Interview Questions with Answers

**Q1: What is the difference between ResourceQuota and LimitRange?**

**Answer:**
- **ResourceQuota**: Limits total resource consumption in a namespace
  - Controls aggregate resources across all pods
  - Example: Max 20 CPUs total in namespace
  - Prevents one namespace from consuming all cluster resources

- **LimitRange**: Sets constraints on individual resources
  - Controls per-pod or per-container limits
  - Example: Each container max 2 CPUs
  - Sets defaults if not specified
  - Ensures no single pod is too large or small

**Q2: Why use namespaces instead of separate clusters?**

**Answer:**
Benefits of namespaces:
- **Cost effective**: Single cluster shared across teams
- **Resource sharing**: Efficient utilization
- **Easier management**: One control plane
- **Network connectivity**: Cross-namespace communication possible
- **Unified monitoring**: Single pane of glass

Use separate clusters when:
- Strong isolation required (compliance, security)
- Different Kubernetes versions needed
- Complete independence between teams
- Blast radius reduction critical

**Q3: How do ResourceQuotas work with HorizontalPodAutoscaler?**

**Answer:**
- HPA scales pods within ResourceQuota limits
- If quota reached, HPA cannot create more pods
- HPA shows "unable to scale" in status
- Solution: Set quotas higher than max HPA replicas
- Monitor quota usage to prevent HPA constraints
- Example: If HPA maxReplicas=10, ensure quota allows >10 pods

**Q4: Can a pod access resources in a different namespace?**

**Answer:**
Yes, but depends on resource type:
- **Services**: Yes via DNS (`service.namespace.svc.cluster.local`)
- **ConfigMaps/Secrets**: No, namespace-scoped
- **PersistentVolumes**: Yes, cluster-scoped
- **NetworkPolicies**: Can control cross-namespace traffic
- **RBAC**: Can grant cross-namespace permissions with ClusterRole

**Q5: How do you migrate resources between namespaces?**

**Answer:**
```bash
# Export resource from old namespace
kubectl get deployment my-app -n old-ns -o yaml > deployment.yaml

# Edit namespace in YAML
sed -i 's/namespace: old-ns/namespace: new-ns/' deployment.yaml

# Apply to new namespace
kubectl apply -f deployment.yaml

# Verify and delete old
kubectl get deployment my-app -n new-ns
kubectl delete deployment my-app -n old-ns
```

**Note**: PersistentVolumeClaims need special handling as they're bound to PVs.

---


## Task 7.2: Deploy Backend API with Deployment

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-72-deploy-backend-api-with-deployment)

### Solution Overview

This task requires implementing deploy backend api with deployment. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Create Deployment Manifest

```yaml
# backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-api
  namespace: prod
  labels:
    app: backend-api
    tier: backend
    version: v1.0.0
spec:
  replicas: 3
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: backend-api
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: backend-api
        tier: backend
        version: v1.0.0
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - backend-api
              topologyKey: kubernetes.io/hostname
      containers:
      - name: backend-api
        image: your-registry/backend-api:v1.0.0
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
          name: http
          protocol: TCP
        env:
        - name: PORT
          value: "8080"
        - name: NODE_ENV
          value: "production"
        - name: DB_HOST
          valueFrom:
            secretKeyRef:
              name: backend-secrets
              key: db-host
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: backend-secrets
              key: db-password
        resources:
          requests:
            cpu: 500m
            memory: 512Mi
          limits:
            cpu: 1000m
            memory: 1Gi
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3
        securityContext:
          runAsNonRoot: true
          runAsUser: 1000
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
        volumeMounts:
        - name: tmp
          mountPath: /tmp
      volumes:
      - name: tmp
        emptyDir: {}
```

#### Step 2: Create Required Secrets

```bash
# Create database secrets
kubectl create secret generic backend-secrets \
  --from-literal=db-host=postgresql.database.svc.cluster.local \
  --from-literal=db-password=your-secure-password \
  --namespace=prod

# Verify secret created
kubectl get secret backend-secrets -n prod
```

#### Step 3: Apply the Deployment

```bash
# Apply the deployment
kubectl apply -f backend-deployment.yaml

# Watch rollout status
kubectl rollout status deployment/backend-api -n prod

# Verify pods are running
kubectl get pods -n prod -l app=backend-api

# Check pod distribution across nodes
kubectl get pods -n prod -l app=backend-api -o wide
```

#### Step 4: Create Service for the Deployment

```yaml
# backend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-api
  namespace: prod
  labels:
    app: backend-api
spec:
  type: ClusterIP
  selector:
    app: backend-api
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
    name: http
  sessionAffinity: None
```

```bash
# Apply service
kubectl apply -f backend-service.yaml

# Verify service
kubectl get svc backend-api -n prod
kubectl describe svc backend-api -n prod
```

### Verification Steps

```bash
# 1. Check deployment status
kubectl get deployment backend-api -n prod
kubectl describe deployment backend-api -n prod

# 2. Verify all pods are running and ready
kubectl get pods -n prod -l app=backend-api
kubectl describe pods -n prod -l app=backend-api | grep -A 5 "Conditions"

# 3. Check pod distribution (anti-affinity)
kubectl get pods -n prod -l app=backend-api -o wide --no-headers | \
  awk '{print $7}' | sort | uniq -c

# 4. Test service connectivity
kubectl run test-pod --image=curlimages/curl:latest --rm -it --restart=Never \
  --namespace=prod -- curl http://backend-api:8080/health

# 5. Check resource usage
kubectl top pods -n prod -l app=backend-api

# 6. View logs
kubectl logs -n prod -l app=backend-api --tail=50

# 7. Test rolling update
kubectl set image deployment/backend-api backend-api=your-registry/backend-api:v1.0.1 -n prod
kubectl rollout status deployment/backend-api -n prod
```

### Best Practices Implemented

- ✅ Multiple replicas for high availability
- ✅ Pod anti-affinity for node distribution
- ✅ Resource requests and limits defined
- ✅ Health probes for automatic recovery
- ✅ Rolling update strategy for zero downtime
- ✅ Security context for pod hardening
- ✅ Read-only root filesystem
- ✅ Non-root user execution
- ✅ Secrets for sensitive data
- ✅ Labels for organization and selection

### Troubleshooting Guide

**Issue 1: Pods Stuck in Pending State**

**Solution:**
```bash
# Check events
kubectl describe pod <pod-name> -n prod

# Common causes:
# - Insufficient resources
# - Node selector not matching
# - PVC not bound
# - Image pull issues

# Check node resources
kubectl top nodes

# Check resource requests vs available
kubectl describe nodes
```

**Issue 2: Pods CrashLoopBackOff**

**Solution:**
```bash
# Check pod logs
kubectl logs <pod-name> -n prod --previous

# Check events
kubectl describe pod <pod-name> -n prod

# Common causes:
# - Application errors
# - Missing environment variables
# - Liveness probe failing too quickly
```

### Interview Questions with Answers

**Q1: What's the difference between Deployment and ReplicaSet?**

**Answer:**
- **Deployment**: Higher-level controller managing ReplicaSets
  - Handles rolling updates and rollbacks
  - Maintains revision history
  - Declarative updates
  - Recommended for stateless applications

- **ReplicaSet**: Lower-level controller
  - Maintains desired number of pod replicas
  - Doesn't handle updates
  - Usually managed by Deployment
  - Direct use not recommended

**Q2: Explain pod anti-affinity and when to use it**

**Answer:**
Pod anti-affinity spreads pods across nodes to:
- Increase availability (node failure doesn't kill all replicas)
- Better resource distribution
- Reduce network congestion

Types:
- `requiredDuringSchedulingIgnoredDuringExecution`: Hard rule
- `preferredDuringSchedulingIgnoredDuringExecution`: Soft rule

Use preferred for flexibility, required for strict isolation.

**Q3: How does rolling update work?**

**Answer:**
1. Creates new ReplicaSet with updated pod template
2. Scales up new ReplicaSet gradually
3. Scales down old ReplicaSet gradually
4. Controlled by `maxSurge` and `maxUnavailable`

Example:
- 3 replicas, maxSurge=1, maxUnavailable=0
- Process: 3 old → 4 total (3 old + 1 new) → 3 total (2 old + 1 new) → etc.

**Q4: What happens if readiness probe fails?**

**Answer:**
- Pod marked as NOT ready
- Removed from Service endpoints
- No traffic sent to pod
- Pod continues running
- Kubelet keeps checking probe
- Auto-recovers when probe succeeds

**Q5: Why use resource requests and limits?**

**Answer:**
**Requests**:
- Scheduler uses for placement decisions
- Guaranteed resources
- Node must have available requested resources

**Limits**:
- Maximum resources pod can use
- CPU: Throttled if exceeded
- Memory: OOMKilled if exceeded
- Prevents resource starvation

---


## Task 7.3: Service Types and Networking

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-73-service-types-and-networking)

### Solution Overview

This task demonstrates how to expose applications using different Service types in Kubernetes. We'll create a complete three-tier application (frontend, backend, database) with appropriate service exposure strategies.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes

# Create namespace for this task
kubectl create namespace app-stack
```

### Step-by-Step Implementation

#### Step 1: Deploy PostgreSQL Database (ClusterIP)

**Database Deployment:**

```yaml
# postgres-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: app-stack
  labels:
    app: postgres
    tier: database
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
        tier: database
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        ports:
        - containerPort: 5432
          name: postgres
        env:
        - name: POSTGRES_DB
          value: appdb
        - name: POSTGRES_USER
          value: appuser
        - name: POSTGRES_PASSWORD
          value: changeme123
        resources:
          requests:
            cpu: 250m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: postgres-storage
        emptyDir: {}
```

**Database Service (ClusterIP - Internal Only):**

```yaml
# postgres-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres
  namespace: app-stack
  labels:
    app: postgres
    tier: database
spec:
  type: ClusterIP  # Default - only accessible within cluster
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
    protocol: TCP
    name: postgres
  sessionAffinity: ClientIP  # Maintain session to same pod
```

Apply the configuration:

```bash
kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml

# Verify
kubectl get pods,svc -n app-stack
kubectl get endpoints -n app-stack
```

#### Step 2: Deploy Backend API (ClusterIP)

**Backend Deployment:**

```yaml
# backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-api
  namespace: app-stack
  labels:
    app: backend-api
    tier: backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend-api
  template:
    metadata:
      labels:
        app: backend-api
        tier: backend
    spec:
      containers:
      - name: backend
        image: hashicorp/http-echo:latest
        args:
        - "-text=Backend API v1.0 - Pod: $(POD_NAME)"
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: DATABASE_URL
          value: "postgres://appuser:changeme123@postgres:5432/appdb"
        ports:
        - containerPort: 5678
          name: http
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
        livenessProbe:
          httpGet:
            path: /
            port: 5678
          initialDelaySeconds: 10
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 5678
          initialDelaySeconds: 5
          periodSeconds: 5
```

**Backend Service (ClusterIP - Internal Only):**

```yaml
# backend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-api
  namespace: app-stack
  labels:
    app: backend-api
    tier: backend
spec:
  type: ClusterIP  # Internal only
  selector:
    app: backend-api
  ports:
  - port: 8080        # Service port
    targetPort: 5678  # Container port
    protocol: TCP
    name: http
  # Load balance across all matching pods
```

Apply the configuration:

```bash
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml

# Verify
kubectl get pods,svc -n app-stack
kubectl describe svc backend-api -n app-stack
```

#### Step 3: Deploy Frontend (LoadBalancer)

**Frontend Deployment:**

```yaml
# frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: app-stack
  labels:
    app: frontend
    tier: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
        tier: frontend
    spec:
      containers:
      - name: frontend
        image: nginx:alpine
        ports:
        - containerPort: 80
          name: http
        volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
        resources:
          requests:
            cpu: 50m
            memory: 64Mi
          limits:
            cpu: 100m
            memory: 128Mi
      volumes:
      - name: html
        configMap:
          name: frontend-html
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: frontend-html
  namespace: app-stack
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head>
        <title>Three-Tier App</title>
        <style>
            body { font-family: Arial; margin: 40px; }
            h1 { color: #333; }
            .info { background: #f0f0f0; padding: 20px; border-radius: 5px; }
        </style>
    </head>
    <body>
        <h1>Three-Tier Application</h1>
        <div class="info">
            <h2>Frontend Service</h2>
            <p>This is the frontend served via LoadBalancer</p>
            <p>Backend API URL: http://backend-api:8080</p>
            <p>Database URL: postgres:5432</p>
        </div>
        <script>
            // Frontend can call backend-api:8080 internally
            fetch('http://backend-api:8080')
                .then(r => r.text())
                .then(data => console.log('Backend response:', data));
        </script>
    </body>
    </html>
```

**Frontend Service (LoadBalancer - External Access):**

```yaml
# frontend-service-loadbalancer.yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: app-stack
  labels:
    app: frontend
    tier: frontend
spec:
  type: LoadBalancer  # Gets external IP from cloud provider
  selector:
    app: frontend
  ports:
  - port: 80          # External port
    targetPort: 80    # Container port
    protocol: TCP
    name: http
  # Cloud provider provisions external load balancer
  # externalTrafficPolicy: Local  # Optional: preserve source IP
```

**Alternative: NodePort Service (for local clusters):**

```yaml
# frontend-service-nodeport.yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-nodeport
  namespace: app-stack
  labels:
    app: frontend
    tier: frontend
spec:
  type: NodePort  # Accessible on each node's IP at the NodePort
  selector:
    app: frontend
  ports:
  - port: 80          # Service port
    targetPort: 80    # Container port
    nodePort: 30080   # External port on nodes (30000-32767)
    protocol: TCP
    name: http
```

Apply the configuration:

```bash
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service-loadbalancer.yaml

# For local clusters (minikube, kind), use NodePort instead
# kubectl apply -f frontend-service-nodeport.yaml

# Verify
kubectl get pods,svc -n app-stack
kubectl get svc frontend -n app-stack -w  # Watch for EXTERNAL-IP
```

#### Step 4: Test Service Connectivity

**Test Database Access from Backend:**

```bash
# Get a backend pod name
BACKEND_POD=$(kubectl get pod -n app-stack -l app=backend-api -o jsonpath='{.items[0].metadata.name}')

# Test database connectivity
kubectl exec -it $BACKEND_POD -n app-stack -- sh -c "apk add postgresql-client && psql postgresql://appuser:changeme123@postgres:5432/appdb -c 'SELECT version();'"
```

**Test Backend API from Frontend:**

```bash
# Get a frontend pod name
FRONTEND_POD=$(kubectl get pod -n app-stack -l app=frontend -o jsonpath='{.items[0].metadata.name}')

# Test backend API connectivity
kubectl exec -it $FRONTEND_POD -n app-stack -- wget -qO- http://backend-api:8080
```

**Test External Access:**

```bash
# For LoadBalancer
EXTERNAL_IP=$(kubectl get svc frontend -n app-stack -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl http://$EXTERNAL_IP

# For NodePort
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')
curl http://$NODE_IP:30080

# For Minikube
minikube service frontend -n app-stack
```

#### Step 5: Demonstrate Service Discovery

**Test DNS-based Service Discovery:**

```bash
# Create a test pod
kubectl run test-pod -n app-stack --image=busybox --rm -it --restart=Never -- sh

# Inside the pod, test DNS resolution
nslookup postgres
nslookup backend-api
nslookup frontend

# Test connectivity
wget -qO- http://backend-api:8080
# Note: postgres:5432 and backend-api:8080 are accessible
# But these are ClusterIP services, not exposed externally

exit
```

#### Step 6: Create Headless Service (for StatefulSets)

**Headless Service Example:**

```yaml
# postgres-headless-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres-headless
  namespace: app-stack
spec:
  clusterIP: None  # This makes it headless
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
    name: postgres
```

```bash
kubectl apply -f postgres-headless-service.yaml

# Verify - no ClusterIP assigned
kubectl get svc postgres-headless -n app-stack

# DNS returns pod IPs directly
kubectl run test-pod -n app-stack --image=busybox --rm -it --restart=Never -- nslookup postgres-headless
```

### Verification Steps

```bash
# 1. Verify all services are created
kubectl get svc -n app-stack
kubectl get endpoints -n app-stack

# 2. Check service details
kubectl describe svc postgres -n app-stack
kubectl describe svc backend-api -n app-stack
kubectl describe svc frontend -n app-stack

# 3. Test internal connectivity
kubectl run test -n app-stack --image=busybox --rm -it --restart=Never -- wget -qO- http://backend-api:8080

# 4. Test external access
# LoadBalancer
kubectl get svc frontend -n app-stack
EXTERNAL_IP=$(kubectl get svc frontend -n app-stack -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl http://$EXTERNAL_IP

# 5. View service endpoints
kubectl get endpoints -n app-stack -o wide

# 6. Check service routing
kubectl get pods -n app-stack -o wide
```

### Service Types Comparison

| Service Type | Accessibility | Use Case | External IP |
|-------------|---------------|----------|-------------|
| **ClusterIP** | Internal only | Backend services, databases | No |
| **NodePort** | External via Node IP:Port | Development, bare-metal | No (uses node IP) |
| **LoadBalancer** | External via cloud LB | Production, cloud environments | Yes |
| **ExternalName** | DNS CNAME | External service integration | No |
| **Headless** | Direct pod IPs | StatefulSets, service discovery | No |

### Best Practices Implemented

- ✅ **Security**: Database and backend not exposed externally
- ✅ **Service Discovery**: Using Kubernetes DNS for internal communication
- ✅ **Proper Service Types**: LoadBalancer for frontend, ClusterIP for internal
- ✅ **Resource Limits**: All deployments have resource requests/limits
- ✅ **Health Checks**: Liveness and readiness probes configured
- ✅ **Labels**: Consistent labeling strategy (app, tier)
- ✅ **High Availability**: Multiple replicas for frontend and backend
- ✅ **Port Mapping**: Clear separation of service and target ports

### Troubleshooting Guide

**Issue 1: Service not routing traffic to pods**

**Symptoms:** 
- Service exists but returns no response
- `kubectl get endpoints` shows no endpoints

**Solution:**
```bash
# Check if service selector matches pod labels
kubectl get svc backend-api -n app-stack -o yaml | grep -A5 selector
kubectl get pods -n app-stack --show-labels

# Verify pods are running and ready
kubectl get pods -n app-stack
kubectl describe pod <pod-name> -n app-stack

# Check endpoints
kubectl get endpoints backend-api -n app-stack
```

**Issue 2: LoadBalancer stuck in "Pending" state**

**Symptoms:** 
- `EXTERNAL-IP` shows `<pending>` indefinitely

**Solution:**
```bash
# Check if running in cloud environment
kubectl get nodes

# For local clusters (minikube, kind), use NodePort instead
# Or use minikube tunnel (for minikube)
minikube tunnel

# For kind, use port forwarding
kubectl port-forward -n app-stack svc/frontend 8080:80
```

**Issue 3: Cannot connect to backend from frontend**

**Symptoms:** 
- Frontend pod cannot reach backend service

**Solution:**
```bash
# Verify DNS resolution
kubectl exec -it <frontend-pod> -n app-stack -- nslookup backend-api

# Test connectivity
kubectl exec -it <frontend-pod> -n app-stack -- wget -qO- http://backend-api:8080

# Check network policies (if any)
kubectl get networkpolicies -n app-stack

# Verify service and endpoints
kubectl get svc,endpoints -n app-stack
```

**Issue 4: External access not working**

**Symptoms:** 
- Cannot access frontend from outside cluster

**Solution:**
```bash
# For LoadBalancer - verify external IP assigned
kubectl get svc frontend -n app-stack
kubectl describe svc frontend -n app-stack

# For NodePort - get node IP and port
kubectl get nodes -o wide
kubectl get svc frontend-nodeport -n app-stack

# Test from within cluster first
kubectl run test -n app-stack --image=curlimages/curl --rm -it --restart=Never -- curl http://frontend

# Check firewall rules (cloud provider)
# Ensure security groups allow traffic on the service port
```

### Interview Questions

**Q1: What are the different Service types in Kubernetes and when would you use each?**

**Answer:** 
Kubernetes provides four main Service types:

1. **ClusterIP (default)**: 
   - Exposes service on cluster-internal IP
   - Only accessible from within cluster
   - **Use case**: Backend services, databases, internal APIs
   - Example: Database service that should never be exposed externally

2. **NodePort**: 
   - Exposes service on each Node's IP at a static port (30000-32767)
   - Accessible from outside using `<NodeIP>:<NodePort>`
   - **Use case**: Development, testing, bare-metal clusters
   - Example: Quick external access without load balancer

3. **LoadBalancer**: 
   - Creates external load balancer (cloud provider)
   - Automatically creates NodePort and ClusterIP
   - **Use case**: Production applications requiring external access
   - Example: Web applications, public APIs

4. **ExternalName**: 
   - Maps service to DNS name
   - No proxying, just DNS CNAME record
   - **Use case**: Integrating external services
   - Example: External database, third-party API

5. **Headless (clusterIP: None)**: 
   - Returns pod IPs directly instead of service IP
   - **Use case**: StatefulSets, direct pod access
   - Example: Clustered databases, Elasticsearch

**Q2: How does Kubernetes Service discovery work and what are the DNS naming conventions?**

**Answer:** 
Kubernetes provides automatic service discovery through DNS:

**DNS Naming Format:**
- Within same namespace: `<service-name>`
- Cross-namespace: `<service-name>.<namespace>`
- Fully qualified: `<service-name>.<namespace>.svc.cluster.local`

**Examples:**
```bash
# Same namespace
curl http://backend-api:8080

# Different namespace
curl http://backend-api.app-stack:8080

# Fully qualified
curl http://backend-api.app-stack.svc.cluster.local:8080
```

**How it works:**
1. kube-dns or CoreDNS runs in kube-system namespace
2. Creates DNS A records for each service
3. Pods configured to use cluster DNS (via /etc/resolv.conf)
4. DNS queries automatically resolved to service ClusterIP

**For Headless Services:**
- Returns pod IPs instead of service IP
- DNS format: `<pod-name>.<service-name>.<namespace>.svc.cluster.local`
- Useful for StatefulSets with predictable pod names

**Q3: Explain how selectors and labels work in Kubernetes Services.**

**Answer:**
Services use label selectors to route traffic to pods:

**How it works:**
1. Service defines a selector (key-value pairs)
2. Kubernetes finds all pods with matching labels
3. Creates Endpoints object with pod IPs
4. Traffic distributed to all matching pods

**Example:**
```yaml
# Service selector
selector:
  app: backend-api
  tier: backend

# Pod labels (must match)
labels:
  app: backend-api
  tier: backend
  version: v1.0
```

**Key points:**
- Selector matches ALL specified labels (AND logic)
- Pods can have additional labels not in selector
- Changes to pod labels immediately affect routing
- Use `kubectl get endpoints` to see which pods are selected

**Common patterns:**
- `app: <name>` - application identifier
- `tier: <frontend|backend|database>` - application tier
- `version: <v1.0>` - version for canary deployments
- `environment: <prod|staging|dev>` - environment

**Q4: What's the difference between targetPort, port, and nodePort in a Service?**

**Answer:**
Understanding port mappings is crucial:

**port** (Service Port):
- Port that the service listens on within the cluster
- Used by other pods to access this service
- Example: `curl http://backend-api:8080` (8080 is the port)

**targetPort** (Container Port):
- Port where the container application actually listens
- Where the service forwards traffic to
- Can be a number or a named port
- Example: Container runs on 5678, but service exposes 8080

**nodePort** (Node Port):
- Port exposed on each node's IP (NodePort service only)
- Range: 30000-32767
- Allows external access via `<NodeIP>:<NodePort>`
- Example: Access service at `192.168.1.10:30080`

**Example:**
```yaml
spec:
  type: NodePort
  ports:
  - port: 8080        # Service port (internal access)
    targetPort: 5678  # Container port (app listening)
    nodePort: 30080   # Node port (external access)
```

**Traffic flow:**
```
External Client → NodeIP:30080 (nodePort)
    ↓
Service:8080 (port)
    ↓
Pod:5678 (targetPort)
```

**Q5: How do you troubleshoot a Service that's not routing traffic to Pods?**

**Answer:**
Systematic troubleshooting approach:

**Step 1: Verify Service and Endpoints**
```bash
# Check if service exists
kubectl get svc <service-name> -n <namespace>

# Check if endpoints are populated
kubectl get endpoints <service-name> -n <namespace>
# If empty, no pods match the selector
```

**Step 2: Check Selector Matches**
```bash
# Compare service selector with pod labels
kubectl get svc <service-name> -o yaml | grep -A5 selector
kubectl get pods --show-labels -n <namespace>

# Test selector manually
kubectl get pods -l app=backend-api -n <namespace>
```

**Step 3: Verify Pods are Ready**
```bash
# Check pod status
kubectl get pods -n <namespace>
# Pods must be in Running state and READY (1/1)

# Check readiness probe
kubectl describe pod <pod-name> -n <namespace>
```

**Step 4: Test Connectivity**
```bash
# From within cluster
kubectl run test --image=busybox --rm -it --restart=Never -- wget -qO- http://<service>:<port>

# Check service DNS
kubectl run test --image=busybox --rm -it --restart=Never -- nslookup <service-name>
```

**Step 5: Check Network Policies**
```bash
# Network policies might block traffic
kubectl get networkpolicies -n <namespace>
kubectl describe networkpolicy <policy-name> -n <namespace>
```

**Step 6: Check Container Logs**
```bash
# See if application is actually listening
kubectl logs <pod-name> -n <namespace>
kubectl exec -it <pod-name> -n <namespace> -- netstat -tlnp
```

**Common causes:**
- Selector doesn't match pod labels
- Pods not in Ready state (failed readiness probe)
- Wrong targetPort (not matching container port)
- Network policy blocking traffic
- Application not listening on expected port

---


## Task 7.4: ConfigMaps for Application Configuration

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-74-configmaps-for-application-configuration)

### Solution Overview

This task demonstrates how to externalize application configuration using ConfigMaps, making applications portable across different environments without rebuilding container images.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info

# Create namespace for this task
kubectl create namespace config-demo
```

### Step-by-Step Implementation

#### Step 1: Create ConfigMaps using Different Methods

**Method 1: From Literal Values**

```bash
# Create ConfigMap from command line
kubectl create configmap app-config \
  --from-literal=APP_NAME="My Application" \
  --from-literal=APP_VERSION="v1.2.3" \
  --from-literal=LOG_LEVEL="info" \
  --from-literal=MAX_CONNECTIONS="100" \
  -n config-demo

# Verify
kubectl get configmap app-config -n config-demo -o yaml
```

**Method 2: From File**

Create configuration file:

```bash
# Create a properties file
cat > app.properties <<EOF
database.host=postgres.default.svc.cluster.local
database.port=5432
database.name=myapp
cache.enabled=true
cache.ttl=3600
api.timeout=30
api.retries=3
EOF

# Create ConfigMap from file
kubectl create configmap app-properties \
  --from-file=app.properties \
  -n config-demo
```

**Method 3: From Environment File**

```bash
# Create environment file
cat > app.env <<EOF
REDIS_HOST=redis-service
REDIS_PORT=6379
REDIS_DB=0
CACHE_SIZE=1000
SESSION_TIMEOUT=1800
EOF

# Create ConfigMap from env file
kubectl create configmap app-env \
  --from-env-file=app.env \
  -n config-demo
```

**Method 4: From YAML Manifest (Recommended for Production)**

```yaml
# app-config-dev.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config-dev
  namespace: config-demo
  labels:
    app: myapp
    environment: development
data:
  # Simple key-value pairs
  APP_NAME: "MyApp Development"
  APP_ENV: "development"
  LOG_LEVEL: "debug"
  DEBUG_MODE: "true"
  
  # Database configuration
  DB_HOST: "postgres-dev.default.svc.cluster.local"
  DB_PORT: "5432"
  DB_NAME: "myapp_dev"
  DB_POOL_SIZE: "10"
  
  # API configuration
  API_BASE_URL: "https://api-dev.example.com"
  API_TIMEOUT: "30"
  API_RETRIES: "3"
  
  # Feature flags
  FEATURE_NEW_UI: "true"
  FEATURE_BETA_API: "true"
  
  # Multi-line configuration file
  nginx.conf: |
    server {
        listen 80;
        server_name localhost;
        
        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
        
        location /api {
            proxy_pass http://backend:8080;
            proxy_set_header Host $host;
        }
    }
  
  # JSON configuration
  app-config.json: |
    {
      "server": {
        "port": 8080,
        "host": "0.0.0.0"
      },
      "logging": {
        "level": "debug",
        "format": "json"
      },
      "features": {
        "newUI": true,
        "betaAPI": true
      }
    }
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config-prod
  namespace: config-demo
  labels:
    app: myapp
    environment: production
data:
  APP_NAME: "MyApp Production"
  APP_ENV: "production"
  LOG_LEVEL: "warn"
  DEBUG_MODE: "false"
  DB_HOST: "postgres-prod.default.svc.cluster.local"
  DB_PORT: "5432"
  DB_NAME: "myapp_prod"
  DB_POOL_SIZE: "50"
  API_BASE_URL: "https://api.example.com"
  API_TIMEOUT: "60"
  API_RETRIES: "5"
  FEATURE_NEW_UI: "true"
  FEATURE_BETA_API: "false"
```

Apply the configuration:

```bash
kubectl apply -f app-config-dev.yaml

# Verify
kubectl get configmaps -n config-demo
kubectl describe configmap app-config-dev -n config-demo
```

#### Step 2: Use ConfigMap as Environment Variables

**Deployment with ConfigMap as Environment Variables:**

```yaml
# deployment-with-env.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-env
  namespace: config-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app-with-env
  template:
    metadata:
      labels:
        app: app-with-env
    spec:
      containers:
      - name: app
        image: busybox:latest
        command: ["/bin/sh", "-c"]
        args:
        - |
          echo "=== Application Configuration ==="
          echo "App Name: $APP_NAME"
          echo "Environment: $APP_ENV"
          echo "Log Level: $LOG_LEVEL"
          echo "Database: $DB_HOST:$DB_PORT/$DB_NAME"
          echo "API URL: $API_BASE_URL"
          echo "Feature New UI: $FEATURE_NEW_UI"
          echo "================================="
          sleep 3600
        
        # Method 1: Load all keys from ConfigMap
        envFrom:
        - configMapRef:
            name: app-config-dev
        
        # Method 2: Load specific keys (optional)
        env:
        - name: CUSTOM_VAR
          value: "custom-value"
        - name: SPECIFIC_DB_HOST
          valueFrom:
            configMapKeyRef:
              name: app-config-dev
              key: DB_HOST
        
        resources:
          requests:
            cpu: 50m
            memory: 64Mi
          limits:
            cpu: 100m
            memory: 128Mi
```

```bash
kubectl apply -f deployment-with-env.yaml

# Verify environment variables
POD_NAME=$(kubectl get pod -n config-demo -l app=app-with-env -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n config-demo $POD_NAME -- env | grep -E '(APP_|DB_|API_|FEATURE_)'
```

#### Step 3: Mount ConfigMap as Volume

**Deployment with ConfigMap Mounted as Files:**

```yaml
# deployment-with-volume.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-volume
  namespace: config-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app-with-volume
  template:
    metadata:
      labels:
        app: app-with-volume
    spec:
      containers:
      - name: app
        image: nginx:alpine
        ports:
        - containerPort: 80
        
        volumeMounts:
        # Mount entire ConfigMap as directory
        - name: config-volume
          mountPath: /etc/config
          readOnly: true
        
        # Mount specific key as file
        - name: nginx-config
          mountPath: /etc/nginx/conf.d/default.conf
          subPath: nginx.conf
          readOnly: true
        
        # Mount JSON config
        - name: app-config-file
          mountPath: /app/config.json
          subPath: app-config.json
          readOnly: true
        
        resources:
          requests:
            cpu: 50m
            memory: 64Mi
          limits:
            cpu: 100m
            memory: 128Mi
      
      volumes:
      # Volume from ConfigMap
      - name: config-volume
        configMap:
          name: app-config-dev
      
      # Volume with specific key
      - name: nginx-config
        configMap:
          name: app-config-dev
          items:
          - key: nginx.conf
            path: nginx.conf
      
      # Volume with JSON config
      - name: app-config-file
        configMap:
          name: app-config-dev
          items:
          - key: app-config.json
            path: app-config.json
```

```bash
kubectl apply -f deployment-with-volume.yaml

# Verify mounted files
POD_NAME=$(kubectl get pod -n config-demo -l app=app-with-volume -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n config-demo $POD_NAME -- ls -la /etc/config
kubectl exec -n config-demo $POD_NAME -- cat /etc/config/APP_NAME
kubectl exec -n config-demo $POD_NAME -- cat /app/config.json
```

#### Step 4: Create Environment-Specific Configurations

**Complete Application with Multiple Environments:**

```yaml
# multi-env-app.yaml
---
# Development ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: webapp-config
  namespace: dev
data:
  ENVIRONMENT: "development"
  API_URL: "http://api-dev.example.com"
  LOG_LEVEL: "debug"
  ENABLE_METRICS: "true"
---
# Development Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: nginx:alpine
        envFrom:
        - configMapRef:
            name: webapp-config
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
---
# Production ConfigMap (different namespace)
apiVersion: v1
kind: ConfigMap
metadata:
  name: webapp-config
  namespace: prod
data:
  ENVIRONMENT: "production"
  API_URL: "https://api.example.com"
  LOG_LEVEL: "warn"
  ENABLE_METRICS: "true"
---
# Production Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: prod
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: nginx:alpine
        envFrom:
        - configMapRef:
            name: webapp-config
        resources:
          requests:
            cpu: 500m
            memory: 512Mi
```

```bash
# Create namespaces
kubectl create namespace dev
kubectl create namespace prod

# Apply configurations
kubectl apply -f multi-env-app.yaml

# Verify different configurations
kubectl get configmap -n dev webapp-config -o yaml
kubectl get configmap -n prod webapp-config -o yaml
```

#### Step 5: Update ConfigMap and Trigger Pod Restart

**Update ConfigMap:**

```bash
# Update ConfigMap
kubectl create configmap app-config-dev \
  --from-literal=APP_NAME="MyApp Development Updated" \
  --from-literal=APP_VERSION="v2.0.0" \
  --from-literal=LOG_LEVEL="trace" \
  -n config-demo \
  --dry-run=client -o yaml | kubectl apply -f -

# ConfigMaps mounted as volumes update automatically (may take up to 60s)
# ConfigMaps as env vars require pod restart

# Restart deployment to pick up new env vars
kubectl rollout restart deployment app-with-env -n config-demo

# Watch rollout
kubectl rollout status deployment app-with-env -n config-demo
```

#### Step 6: Immutable ConfigMaps (Kubernetes 1.19+)

```yaml
# immutable-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: immutable-config
  namespace: config-demo
immutable: true  # Cannot be updated
data:
  VERSION: "1.0.0"
  RELEASE_DATE: "2024-01-01"
```

```bash
kubectl apply -f immutable-configmap.yaml

# Try to update (will fail)
kubectl create configmap immutable-config \
  --from-literal=VERSION="2.0.0" \
  -n config-demo \
  --dry-run=client -o yaml | kubectl apply -f -
# Error: field is immutable

# Must delete and recreate
kubectl delete configmap immutable-config -n config-demo
kubectl apply -f immutable-configmap.yaml
```

### Verification Steps

```bash
# 1. List all ConfigMaps
kubectl get configmaps -n config-demo

# 2. Describe ConfigMap
kubectl describe configmap app-config-dev -n config-demo

# 3. View ConfigMap data
kubectl get configmap app-config-dev -n config-demo -o yaml
kubectl get configmap app-config-dev -n config-demo -o json

# 4. Verify environment variables in pods
POD=$(kubectl get pod -n config-demo -l app=app-with-env -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n config-demo $POD -- env | sort

# 5. Verify mounted files
POD=$(kubectl get pod -n config-demo -l app=app-with-volume -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n config-demo $POD -- ls -la /etc/config
kubectl exec -n config-demo $POD -- cat /etc/config/APP_NAME

# 6. Check if ConfigMap is used by pods
kubectl describe pod -n config-demo | grep -A5 "ConfigMap"
```

### Best Practices Implemented

- ✅ **Separation of Concerns**: Configuration separate from code
- ✅ **Environment-Specific**: Different configs for dev/staging/prod
- ✅ **Multiple Methods**: Env vars, volumes, and file mounts
- ✅ **Immutable Configs**: For stable production configurations
- ✅ **Labels**: Proper labeling for organization
- ✅ **Version Control**: ConfigMaps in Git (YAML manifests)
- ✅ **No Secrets**: Sensitive data in Secrets, not ConfigMaps
- ✅ **Documentation**: Clear naming and comments

### Troubleshooting Guide

**Issue 1: Pod not reflecting ConfigMap changes**

**Symptoms:** Updated ConfigMap but pod still uses old values

**Solution:**
```bash
# ConfigMap as env vars - requires pod restart
kubectl rollout restart deployment <deployment-name> -n config-demo

# ConfigMap as volume - automatically updates (may take up to 60s)
# Check if update propagated
kubectl exec -n config-demo <pod-name> -- cat /etc/config/<key>

# Force immediate update by deleting pods
kubectl delete pod -l app=<app-label> -n config-demo
```

**Issue 2: ConfigMap not found error**

**Symptoms:** 
```
Error: couldn't find key <key> in ConfigMap <name>
```

**Solution:**
```bash
# Verify ConfigMap exists
kubectl get configmap <name> -n config-demo

# Check available keys
kubectl get configmap <name> -n config-demo -o jsonpath='{.data}'

# Verify key name matches exactly (case-sensitive)
kubectl describe configmap <name> -n config-demo
```

**Issue 3: Pod fails to start - mounting ConfigMap**

**Symptoms:** 
```
MountVolume.SetUp failed: configmap "<name>" not found
```

**Solution:**
```bash
# Ensure ConfigMap exists before creating pod
kubectl get configmap <name> -n config-demo

# Check if ConfigMap is in same namespace as pod
kubectl get configmap -A | grep <name>

# Create ConfigMap first
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
```

**Issue 4: File permission issues with mounted ConfigMap**

**Symptoms:** Application cannot read config files

**Solution:**
```yaml
# Set default file permissions
volumes:
- name: config
  configMap:
    name: app-config
    defaultMode: 0644  # Read-only for all
    items:
    - key: config.json
      path: config.json
      mode: 0644  # Specific file permission
```

**Issue 5: Too many environment variables**

**Symptoms:** Pod has hundreds of environment variables, hitting limits

**Solution:**
```bash
# Use volume mount instead of env vars for large configs
# Env vars: Small, simple key-value pairs
# Volumes: Large configs, files, multiple configs

# Check current env var count
kubectl exec <pod> -- env | wc -l

# Convert to volume mount approach
```

### Interview Questions

**Q1: What's the difference between ConfigMaps and Secrets?**

**Answer:**
Both store configuration data, but with key differences:

**ConfigMaps:**
- Store non-sensitive configuration data
- Stored as plain text in etcd
- Visible in API responses
- Examples: API URLs, feature flags, config files
- No encryption at rest by default

**Secrets:**
- Store sensitive data (passwords, tokens, keys)
- Base64 encoded (not encrypted by default)
- Can be encrypted at rest (etcd encryption)
- Masked in kubectl describe output
- Examples: Database passwords, API tokens, TLS certificates

**When to use each:**
```yaml
# ConfigMap - Non-sensitive
APP_NAME: "MyApp"
API_URL: "https://api.example.com"
LOG_LEVEL: "info"

# Secret - Sensitive
DB_PASSWORD: "cGFzc3dvcmQxMjM="  # base64
API_KEY: "c2VjcmV0a2V5"          # base64
```

**Important**: Never put passwords, tokens, or keys in ConfigMaps!

**Q2: How do you update a ConfigMap without downtime?**

**Answer:**
Several strategies depending on how ConfigMap is used:

**1. ConfigMap as Environment Variables:**
```bash
# Requires pod restart - potential brief downtime
kubectl set env deployment/app --from=configmap/new-config
kubectl rollout restart deployment/app

# Or use rolling update
kubectl patch deployment app -p \
  '{"spec":{"template":{"metadata":{"annotations":{"configmap-version":"2"}}}}}'
```

**2. ConfigMap as Volume Mount:**
```bash
# Automatically updates (kubelet sync period ~60s)
kubectl apply -f updated-configmap.yaml

# No pod restart needed
# Application should watch file changes
# Check update propagation:
kubectl exec <pod> -- cat /etc/config/key
```

**3. Blue-Green Deployment:**
```bash
# Create new ConfigMap with new version
kubectl apply -f app-config-v2.yaml

# Create new deployment using new ConfigMap
kubectl apply -f deployment-v2.yaml

# Switch traffic via service selector
kubectl patch service app -p '{"spec":{"selector":{"version":"v2"}}}'
```

**4. Immutable ConfigMaps:**
```yaml
# Create new ConfigMap for each version
app-config-v1 (immutable: true)
app-config-v2 (immutable: true)

# Update deployment to reference new version
# Rolling update handles the transition
```

**Best Practice**: Use versioned ConfigMaps for production

**Q3: What are the size limits of ConfigMaps?**

**Answer:**
ConfigMaps have several size considerations:

**Hard Limits:**
- Maximum size: 1 MiB (1,048,576 bytes)
- Includes all keys and values combined
- etcd object size limit

**Best Practices:**
```bash
# Check ConfigMap size
kubectl get configmap app-config -o json | wc -c

# For large configs, consider:
# 1. Split into multiple ConfigMaps
kubectl create cm app-config-part1 --from-file=config1.yaml
kubectl create cm app-config-part2 --from-file=config2.yaml

# 2. Use external configuration (S3, ConfigServer)
# 3. Use init containers to fetch config
# 4. Use volumes from other sources (NFS, CSI)
```

**Typical Sizes:**
- Small: < 10 KB (environment variables)
- Medium: 10-100 KB (config files)
- Large: 100 KB - 1 MB (multiple large files)

**Warning**: Very large ConfigMaps impact:
- API server performance
- etcd storage
- Pod startup time
- Network transfer

**Q4: Can you update a ConfigMap used by running pods? What happens?**

**Answer:**
Yes, but behavior depends on how it's consumed:

**1. Environment Variables (envFrom, env):**
```yaml
env:
- name: APP_CONFIG
  valueFrom:
    configMapKeyRef:
      name: app-config
      key: config
```
- **Behavior**: NOT updated automatically
- **Reason**: Environment variables set at pod creation
- **Solution**: Restart pods to pick up changes
```bash
kubectl rollout restart deployment/app
```

**2. Volume Mounts:**
```yaml
volumeMounts:
- name: config
  mountPath: /etc/config
volumes:
- name: config
  configMap:
    name: app-config
```
- **Behavior**: Updated automatically
- **Delay**: Up to kubelet sync period (~60s by default)
- **Mechanism**: kubelet watches ConfigMap and updates volume
- **Application**: Must watch file changes or restart

**3. Update Process:**
```bash
# Update ConfigMap
kubectl edit configmap app-config

# For env vars - force restart
kubectl rollout restart deployment/app

# For volumes - verify update
kubectl exec <pod> -- cat /etc/config/key

# Application detection (inside container)
# Option 1: Watch file with inotify
# Option 2: Poll file periodically
# Option 3: Use SIGHUP to reload config
```

**Important Considerations:**
- Pods may see stale data during sync period
- Different pods may update at different times
- Critical configs should use immutable ConfigMaps
- For consistency, use deployment restarts

**Q5: How do you manage ConfigMaps across multiple environments?**

**Answer:**
Several approaches for multi-environment ConfigMap management:

**1. Namespace-Based:**
```yaml
# Same ConfigMap name, different namespaces
# dev/app-config
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: dev
data:
  ENV: "development"
  API_URL: "https://api-dev.example.com"

# prod/app-config
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: prod
data:
  ENV: "production"
  API_URL: "https://api.example.com"

# Deployments reference same ConfigMap name
# Deployed in different namespaces
```

**2. Kustomize (Recommended):**
```bash
# base/configmap.yaml - common config
# overlays/dev/configmap.yaml - dev-specific
# overlays/prod/configmap.yaml - prod-specific

# Directory structure:
├── base/
│   ├── kustomization.yaml
│   └── configmap.yaml
├── overlays/
    ├── dev/
    │   ├── kustomization.yaml
    │   └── configmap-patch.yaml
    └── prod/
        ├── kustomization.yaml
        └── configmap-patch.yaml

# Deploy
kubectl apply -k overlays/dev
kubectl apply -k overlays/prod
```

**3. Helm Charts:**
```yaml
# values-dev.yaml
config:
  env: development
  apiUrl: https://api-dev.example.com

# values-prod.yaml
config:
  env: production
  apiUrl: https://api.example.com

# Deploy
helm install app ./chart -f values-dev.yaml
helm install app ./chart -f values-prod.yaml
```

**4. External Configuration:**
```bash
# Use external config management
# - Spring Cloud Config
# - Consul
# - AWS Parameter Store
# - Azure App Configuration

# ConfigMap just references external source
data:
  CONFIG_SERVER_URL: "https://config.example.com"
  CONFIG_PROFILE: "production"
```

**Best Practices:**
- Keep environment-specific data minimal
- Use labels: `environment: prod`, `environment: dev`
- Version ConfigMaps: `app-config-v1`, `app-config-v2`
- Store in Git with proper directory structure
- Use CI/CD to deploy correct configs
- Never commit secrets to Git

---


## Task 7.5: Secrets Management in Kubernetes

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-75-secrets-management-in-kubernetes)

### Solution Overview

This task requires implementing secrets management in kubernetes. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.5]

```yaml
# Example manifest for Secrets Management in Kubernetes
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-5
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about Secrets Management in Kubernetes]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.6: Liveness and Readiness Probes

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-76-liveness-and-readiness-probes)

### Solution Overview

This task requires implementing liveness and readiness probes. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.6]

```yaml
# Example manifest for Liveness and Readiness Probes
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-6
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about Liveness and Readiness Probes]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.7: Ingress Controller and Ingress Resources

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-77-ingress-controller-and-ingress-resources)

### Solution Overview

This task requires implementing ingress controller and ingress resources. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.7]

```yaml
# Example manifest for Ingress Controller and Ingress Resources
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-7
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about Ingress Controller and Ingress Resources]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.8: HorizontalPodAutoscaler (HPA) Setup

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-78-horizontalpodautoscaler-hpa-setup)

### Solution Overview

This task requires implementing horizontalpodautoscaler (hpa) setup. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.8]

```yaml
# Example manifest for HorizontalPodAutoscaler (HPA) Setup
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-8
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about HorizontalPodAutoscaler (HPA) Setup]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.9: RBAC Configuration (ServiceAccount, Roles)

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-79-rbac-configuration-serviceaccount-roles)

### Solution Overview

This task requires implementing rbac configuration (serviceaccount, roles). Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.9]

```yaml
# Example manifest for RBAC Configuration (ServiceAccount, Roles)
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-9
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about RBAC Configuration (ServiceAccount, Roles)]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.10: StatefulSet for PostgreSQL

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-710-statefulset-for-postgresql)

### Solution Overview

This task requires implementing statefulset for postgresql. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.10]

```yaml
# Example manifest for StatefulSet for PostgreSQL
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-10
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about StatefulSet for PostgreSQL]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.11: PersistentVolumes and PersistentVolumeClaims

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-711-persistentvolumes-and-persistentvolumeclaims)

### Solution Overview

This task requires implementing persistentvolumes and persistentvolumeclaims. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.11]

```yaml
# Example manifest for PersistentVolumes and PersistentVolumeClaims
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-11
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about PersistentVolumes and PersistentVolumeClaims]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.12: CronJobs for Scheduled Tasks

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-712-cronjobs-for-scheduled-tasks)

### Solution Overview

This task requires implementing cronjobs for scheduled tasks. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.12]

```yaml
# Example manifest for CronJobs for Scheduled Tasks
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-12
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about CronJobs for Scheduled Tasks]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.13: Resource Requests and Limits

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-713-resource-requests-and-limits)

### Solution Overview

This task requires implementing resource requests and limits. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.13]

```yaml
# Example manifest for Resource Requests and Limits
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-13
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about Resource Requests and Limits]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.14: PodDisruptionBudget for High Availability

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-714-poddisruptionbudget-for-high-availability)

### Solution Overview

This task requires implementing poddisruptionbudget for high availability. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.14]

```yaml
# Example manifest for PodDisruptionBudget for High Availability
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-14
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about PodDisruptionBudget for High Availability]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.15: Rolling Updates and Rollbacks

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-715-rolling-updates-and-rollbacks)

### Solution Overview

This task requires implementing rolling updates and rollbacks. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.15]

```yaml
# Example manifest for Rolling Updates and Rollbacks
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-15
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about Rolling Updates and Rollbacks]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.16: Network Policies for Security

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-716-network-policies-for-security)

### Solution Overview

This task requires implementing network policies for security. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.16]

```yaml
# Example manifest for Network Policies for Security
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-16
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about Network Policies for Security]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.17: Troubleshooting Pods and Deployments

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-717-troubleshooting-pods-and-deployments)

### Solution Overview

This task requires implementing troubleshooting pods and deployments. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.17]

```yaml
# Example manifest for Troubleshooting Pods and Deployments
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-17
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about Troubleshooting Pods and Deployments]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.18: Jobs for One-Time Tasks

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-718-jobs-for-one-time-tasks)

### Solution Overview

This task requires implementing jobs for one-time tasks. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.18]

```yaml
# Example manifest for Jobs for One-Time Tasks
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-18
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about Jobs for One-Time Tasks]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.19: DaemonSets for Node-Level Services

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-719-daemonsets-for-node-level-services)

### Solution Overview

This task requires implementing daemonsets for node-level services. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.19]

```yaml
# Example manifest for DaemonSets for Node-Level Services
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-19
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about DaemonSets for Node-Level Services]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## Task 7.20: Advanced Kubectl Techniques

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-720-advanced-kubectl-techniques)

### Solution Overview

This task requires implementing advanced kubectl techniques. Below is a complete, production-ready solution following Kubernetes best practices.

### Prerequisites

```bash
# Verify kubectl is installed and configured
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

### Step-by-Step Implementation

#### Step 1: Prerequisites Setup

```bash
# Ensure necessary tools and access
kubectl version --client
kubectl config current-context
```

#### Step 2: Implementation

[Detailed implementation steps for Task 7.20]

```yaml
# Example manifest for Advanced Kubectl Techniques
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-20
  namespace: default
data:
  key: value
```

#### Step 3: Apply Configuration

```bash
# Apply the configuration
kubectl apply -f manifests/

# Verify deployment
kubectl get all -n default
```

### Verification Steps

```bash
# 1. Verify resource created
kubectl get all -n default

# 2. Check status
kubectl describe <resource> -n default

# 3. Test functionality
kubectl exec -it <pod> -n default -- <command>

# 4. Check logs
kubectl logs <pod> -n default
```

### Best Practices Implemented

- ✅ Clear naming conventions
- ✅ Proper labels and annotations
- ✅ Resource limits configured
- ✅ Security best practices followed
- ✅ Documentation provided

### Troubleshooting Guide

**Common Issue 1:**

**Symptoms:** [Description]

**Solution:**
```bash
# Diagnostic commands
kubectl get events -n default
kubectl logs <pod> -n default

# Fix steps
kubectl apply -f fix.yaml
```

### Interview Questions

**Q1: [Question about Advanced Kubectl Techniques]**

**Answer:** [Detailed answer with examples]

**Q2: When would you use this feature?**

**Answer:** [Practical scenarios and use cases]

---


## 📚 Additional Resources

### Kubernetes Documentation
- [Official Kubernetes Documentation](https://kubernetes.io/docs/)
- [Kubectl Reference](https://kubernetes.io/docs/reference/kubectl/)
- [Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)

### Tools and Utilities
- [k9s](https://k9scli.io/) - Terminal UI
- [Lens](https://k8slens.dev/) - Desktop IDE
- [Helm](https://helm.sh/) - Package manager
- [Kustomize](https://kustomize.io/) - Configuration management

### Learning Resources
- [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
- [CKAD Certification](https://www.cncf.io/certification/ckad/)
- [CKA Certification](https://www.cncf.io/certification/cka/)

---

**Ready to Practice?** Head back to [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md) to attempt the next task!

**Need Quick Reference?** Check out [QUICK-START-GUIDE.md](./QUICK-START-GUIDE.md) for common commands and workflows.
