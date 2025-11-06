# Kubernetes Deployment & Operations - Complete Solutions (Continued)

## 🎯 Overview

This document continues the complete, production-ready solutions for Kubernetes tasks 7.6-7.20. This is a continuation of [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md).

**For Tasks 7.1-7.5, see:** [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md)

---

## Table of Contents

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

## Task 7.6: Liveness and Readiness Probes

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-76-liveness-and-readiness-probes)

### Solution Overview

This task demonstrates implementing health probes to ensure high availability and reliable traffic routing in Kubernetes applications.

### Prerequisites

```bash
# Verify kubectl is installed
kubectl version --client
kubectl cluster-info

# Create namespace
kubectl create namespace health-demo
```

### Step-by-Step Implementation

#### Step 1: Understanding Probe Types

**Three Types of Probes:**

1. **Liveness Probe** - Detects if container is alive
2. **Readiness Probe** - Determines if pod should receive traffic
3. **Startup Probe** - Handles slow-starting containers

#### Step 2: HTTP Liveness Probe

```yaml
# http-liveness-probe.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-liveness
  namespace: health-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: liveness-demo
  template:
    metadata:
      labels:
        app: liveness-demo
    spec:
      containers:
      - name: web
        image: nginx:alpine
        ports:
        - containerPort: 80
        
        # Liveness probe - restarts container if fails
        livenessProbe:
          httpGet:
            path: /healthz
            port: 80
            httpHeaders:
            - name: Custom-Header
              value: Awesome
          initialDelaySeconds: 15  # Wait before first check
          periodSeconds: 10        # Check every 10 seconds
          timeoutSeconds: 5        # Request timeout
          failureThreshold: 3      # Fail after 3 consecutive failures
          successThreshold: 1      # Success after 1 success
        
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
```

#### Step 3: TCP Liveness Probe

```yaml
# tcp-liveness-probe.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-with-probes
  namespace: health-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:alpine
        ports:
        - containerPort: 6379
        
        # TCP liveness probe
        livenessProbe:
          tcpSocket:
            port: 6379
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
```

#### Step 4: Exec Command Probe

```yaml
# exec-liveness-probe.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-exec-probe
  namespace: health-demo
spec:
  containers:
  - name: app
    image: busybox:latest
    command: ["/bin/sh", "-c"]
    args:
    - |
      # Create healthcheck file
      touch /tmp/healthy
      sleep 30
      # Simulate failure after 30s
      rm -f /tmp/healthy
      sleep 600
    
    # Exec liveness probe
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5
      failureThreshold: 1
```

#### Step 5: Readiness Probe

```yaml
# readiness-probe.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-readiness
  namespace: health-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: readiness-demo
  template:
    metadata:
      labels:
        app: readiness-demo
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo:latest
        args:
        - "-text=Ready to serve traffic"
        ports:
        - containerPort: 5678
        
        # Readiness probe - controls traffic routing
        readinessProbe:
          httpGet:
            path: /
            port: 5678
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3
          successThreshold: 1
        
        # Liveness probe - restarts if dead
        livenessProbe:
          httpGet:
            path: /
            port: 5678
          initialDelaySeconds: 15
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
---
apiVersion: v1
kind: Service
metadata:
  name: readiness-service
  namespace: health-demo
spec:
  selector:
    app: readiness-demo
  ports:
  - port: 80
    targetPort: 5678
  type: ClusterIP
```

#### Step 6: Startup Probe for Slow Starting Apps

```yaml
# startup-probe.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: slow-starting-app
  namespace: health-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: slow-start
  template:
    metadata:
      labels:
        app: slow-start
    spec:
      containers:
      - name: app
        image: busybox:latest
        command: ["/bin/sh", "-c"]
        args:
        - |
          # Simulate slow startup (60 seconds)
          sleep 60
          touch /tmp/started
          # Then stay healthy
          while true; do sleep 1; done
        
        # Startup probe - gives time for slow startup
        startupProbe:
          exec:
            command:
            - cat
            - /tmp/started
          initialDelaySeconds: 0
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 30  # 30 * 10s = 5 minutes max startup time
        
        # Liveness probe - only starts checking after startup succeeds
        livenessProbe:
          exec:
            command:
            - cat
            - /tmp/started
          initialDelaySeconds: 0
          periodSeconds: 10
          timeoutSeconds: 3
          failureThreshold: 3
        
        # Readiness probe
        readinessProbe:
          exec:
            command:
            - cat
            - /tmp/started
          initialDelaySeconds: 0
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 1
```

#### Step 7: Complete Application with All Probes

```yaml
# complete-app-with-probes.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: production-app
  namespace: health-demo
  labels:
    app: prod-app
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: prod-app
  template:
    metadata:
      labels:
        app: prod-app
    spec:
      containers:
      - name: app
        image: nginx:alpine
        ports:
        - containerPort: 80
          name: http
        
        # Startup probe - for initial container startup
        startupProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 0
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 12  # 12 * 5s = 60s max startup
          successThreshold: 1
        
        # Liveness probe - restart if container is dead
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 0  # Startup probe handles delay
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
          successThreshold: 1
        
        # Readiness probe - control traffic routing
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 0
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3
          successThreshold: 1
        
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
        
        lifecycle:
          preStop:
            exec:
              command: ["/bin/sh", "-c", "sleep 15"]
---
apiVersion: v1
kind: Service
metadata:
  name: prod-app-service
  namespace: health-demo
spec:
  selector:
    app: prod-app
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

### Verification Steps

```bash
# 1. Deploy applications
kubectl apply -f http-liveness-probe.yaml
kubectl apply -f readiness-probe.yaml
kubectl apply -f startup-probe.yaml

# 2. Watch pod status
kubectl get pods -n health-demo -w

# 3. Check probe status
kubectl describe pod <pod-name> -n health-demo | grep -A10 "Liveness\|Readiness\|Startup"

# 4. View probe events
kubectl get events -n health-demo --sort-by='.lastTimestamp'

# 5. Test liveness probe failure
POD=$(kubectl get pod -n health-demo -l app=liveness-demo -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n health-demo $POD -- rm -f /usr/share/nginx/html/healthz
# Watch pod restart
kubectl get pods -n health-demo -w

# 6. Test readiness probe
kubectl get pods -n health-demo -l app=readiness-demo
kubectl get endpoints readiness-service -n health-demo

# 7. Check restart count
kubectl get pods -n health-demo -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[0].restartCount
```

### Best Practices Implemented

- ✅ **Startup Probe First**: Use for slow-starting applications
- ✅ **Liveness for Deadlock**: Restart containers that are deadlocked
- ✅ **Readiness for Traffic**: Control when pod receives traffic
- ✅ **Appropriate Thresholds**: Avoid false positives
- ✅ **Timeouts**: Set realistic timeout values
- ✅ **Health Endpoints**: Lightweight, fast checks
- ✅ **PreStop Hooks**: Graceful shutdown with readiness

### Interview Questions

**Q1: What's the difference between liveness and readiness probes?**

**Answer:**

**Liveness Probe:**
- **Purpose**: Detect if container is alive/healthy
- **Action**: Restart container if fails
- **Use case**: Deadlock, infinite loop, crash
- **Impact**: Container restart (RESTARTS counter increases)

**Readiness Probe:**
- **Purpose**: Determine if pod should receive traffic
- **Action**: Remove from service endpoints if fails
- **Use case**: Startup, dependencies not ready, overloaded
- **Impact**: Traffic routing (no restart)

**Key Differences:**
```yaml
# Liveness - "Is the app alive?"
livenessProbe:
  httpGet:
    path: /healthz
  failureThreshold: 3  # Restart after 3 failures

# Readiness - "Is the app ready for traffic?"
readinessProbe:
  httpGet:
    path: /ready
  failureThreshold: 3  # Remove from service, no restart
```

**Example Scenario:**
- App starts → Readiness fails → No traffic
- App ready → Readiness succeeds → Receives traffic
- App deadlocks → Liveness fails → Restart
- After restart → Readiness fails → No traffic until ready

**Q2: When should you use a startup probe?**

**Answer:**

**Use Startup Probe When:**
1. Application has slow/variable startup time
2. Legacy applications with long initialization
3. Applications loading large datasets
4. Database migration on startup
5. Downloading resources on init

**Without Startup Probe:**
```yaml
# Problem: Need high initialDelaySeconds and failureThreshold
livenessProbe:
  httpGet:
    path: /healthz
  initialDelaySeconds: 300  # Wait 5 minutes!
  failureThreshold: 30      # Very lenient
  # Issue: Slow to detect actual failures after startup
```

**With Startup Probe:**
```yaml
# Startup probe - handles slow startup
startupProbe:
  httpGet:
    path: /healthz
  periodSeconds: 10
  failureThreshold: 30  # 30 * 10s = 5 minutes max
  
# Liveness probe - only active after startup succeeds
livenessProbe:
  httpGet:
    path: /healthz
  periodSeconds: 10
  failureThreshold: 3  # Quick detection after startup
```

**Benefits:**
- Startup probe disabled after first success
- Liveness probe immediately active
- Quick failure detection after startup
- Accommodates variable startup times

**Q3: How do you configure probes to avoid false positives?**

**Answer:**

**Best Practices to Avoid False Positives:**

**1. Appropriate Thresholds:**
```yaml
# Too sensitive (false positives)
failureThreshold: 1  # Single failure restarts pod

# Better configuration
failureThreshold: 3  # 3 consecutive failures
periodSeconds: 10    # Check every 10s
# Total: 30s of failures before action
```

**2. Realistic Timeouts:**
```yaml
# Too aggressive
timeoutSeconds: 1    # May timeout on slow responses

# Better
timeoutSeconds: 5    # Allow time for response
```

**3. Lightweight Health Checks:**
```yaml
# Bad - Heavy check
livenessProbe:
  httpGet:
    path: /full-system-check  # Queries database, external APIs

# Good - Lightweight check
livenessProbe:
  httpGet:
    path: /healthz  # Just checks if process responds
```

**4. Separate Health Endpoints:**
```yaml
# Liveness - Basic "is alive" check
livenessProbe:
  httpGet:
    path: /healthz  # Returns 200 if process running

# Readiness - Full dependency check
readinessProbe:
  httpGet:
    path: /ready  # Checks database, cache, etc.
```

**5. Initial Delay:**
```yaml
# Allow time for application startup
initialDelaySeconds: 30  # Based on actual startup time
periodSeconds: 10
failureThreshold: 3
```

**6. Monitoring and Tuning:**
```bash
# Monitor restart rates
kubectl get pods -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[0].restartCount

# Check probe failures in events
kubectl get events --field-selector reason=Unhealthy

# Review probe timing
kubectl describe pod <pod> | grep -A5 "Liveness\|Readiness"
```

**Configuration Example:**
```yaml
startupProbe:
  httpGet:
    path: /startup
  initialDelaySeconds: 0
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 30      # 5 minutes max startup
  successThreshold: 1

livenessProbe:
  httpGet:
    path: /healthz
  initialDelaySeconds: 0    # Startup probe handles this
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3       # 30s of failures
  successThreshold: 1

readinessProbe:
  httpGet:
    path: /ready
  initialDelaySeconds: 0
  periodSeconds: 5
  timeoutSeconds: 3
  failureThreshold: 3       # 15s of failures
  successThreshold: 1       # Immediately ready on success
```

---

## Task 7.7: Ingress Controller and Ingress Resources

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-77-ingress-controller-and-ingress-resources)

### Solution Overview

This task demonstrates setting up an Ingress controller and creating Ingress resources for host-based and path-based routing with TLS termination.

### Prerequisites

```bash
# Verify kubectl is installed
kubectl version --client

# Create namespace
kubectl create namespace ingress-demo
```

### Step-by-Step Implementation

#### Step 1: Install NGINX Ingress Controller

```bash
# Install using kubectl
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml

# Verify installation
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

# Wait for ingress controller to be ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

#### Step 2: Deploy Sample Applications

```yaml
# sample-apps.yaml
---
# App 1: Frontend
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: ingress-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: hashicorp/http-echo:latest
        args:
        - "-text=Frontend Application"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: ingress-demo
spec:
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 5678
---
# App 2: Backend API
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-api
  namespace: ingress-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend-api
  template:
    metadata:
      labels:
        app: backend-api
    spec:
      containers:
      - name: api
        image: hashicorp/http-echo:latest
        args:
        - "-text=Backend API v1.0"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: backend-api-service
  namespace: ingress-demo
spec:
  selector:
    app: backend-api
  ports:
  - port: 80
    targetPort: 5678
---
# App 3: Admin Panel
apiVersion: apps/v1
kind: Deployment
metadata:
  name: admin
  namespace: ingress-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: admin
  template:
    metadata:
      labels:
        app: admin
    spec:
      containers:
      - name: admin
        image: hashicorp/http-echo:latest
        args:
        - "-text=Admin Panel"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: admin-service
  namespace: ingress-demo
spec:
  selector:
    app: admin
  ports:
  - port: 80
    targetPort: 5678
```

```bash
kubectl apply -f sample-apps.yaml
```

#### Step 3: Create Basic Ingress with Host-Based Routing

```yaml
# basic-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: basic-ingress
  namespace: ingress-demo
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  # Host-based routing
  - host: www.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
  
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: backend-api-service
            port:
              number: 80
  
  - host: admin.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: admin-service
            port:
              number: 80
```

```bash
kubectl apply -f basic-ingress.yaml
kubectl get ingress -n ingress-demo
kubectl describe ingress basic-ingress -n ingress-demo
```

#### Step 4: Path-Based Routing

```yaml
# path-based-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: path-based-ingress
  namespace: ingress-demo
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  ingressClassName: nginx
  rules:
  - host: myapp.example.com
    http:
      paths:
      # Path: /frontend -> frontend-service
      - path: /frontend(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
      
      # Path: /api -> backend-api-service
      - path: /api(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: backend-api-service
            port:
              number: 80
      
      # Path: /admin -> admin-service
      - path: /admin(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: admin-service
            port:
              number: 80
```

```bash
kubectl apply -f path-based-ingress.yaml
```

#### Step 5: TLS/HTTPS Configuration

```bash
# Create TLS certificate (self-signed for demo)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key \
  -out tls.crt \
  -subj "/CN=*.example.com/O=MyOrg"

# Create Kubernetes secret
kubectl create secret tls example-tls \
  --cert=tls.crt \
  --key=tls.key \
  -n ingress-demo

# Clean up cert files
rm tls.key tls.crt
```

```yaml
# tls-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-ingress
  namespace: ingress-demo
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - www.example.com
    - api.example.com
    - admin.example.com
    secretName: example-tls
  rules:
  - host: www.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: backend-api-service
            port:
              number: 80
```

```bash
kubectl apply -f tls-ingress.yaml
```

#### Step 6: Advanced Ingress Annotations

```yaml
# advanced-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: advanced-ingress
  namespace: ingress-demo
  annotations:
    # SSL/TLS
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    
    # Rate limiting
    nginx.ingress.kubernetes.io/limit-rps: "10"
    nginx.ingress.kubernetes.io/limit-connections: "5"
    
    # CORS
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "https://trusted-origin.com"
    nginx.ingress.kubernetes.io/cors-allow-methods: "GET, POST, PUT, DELETE"
    
    # Custom headers
    nginx.ingress.kubernetes.io/configuration-snippet: |
      more_set_headers "X-Frame-Options: DENY";
      more_set_headers "X-Content-Type-Options: nosniff";
      more_set_headers "X-XSS-Protection: 1; mode=block";
    
    # Timeouts
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "60"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "60"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "60"
    
    # Client body size
    nginx.ingress.kubernetes.io/proxy-body-size: "10m"
    
    # Whitelist IP addresses
    nginx.ingress.kubernetes.io/whitelist-source-range: "10.0.0.0/8,192.168.0.0/16"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - api.example.com
    secretName: example-tls
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: backend-api-service
            port:
              number: 80
```

```bash
kubectl apply -f advanced-ingress.yaml
```

#### Step 7: Default Backend (404 handler)

```yaml
# default-backend.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: default-backend
  namespace: ingress-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: default-backend
  template:
    metadata:
      labels:
        app: default-backend
    spec:
      containers:
      - name: backend
        image: hashicorp/http-echo:latest
        args:
        - "-text=404 - Not Found"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: default-backend-service
  namespace: ingress-demo
spec:
  selector:
    app: default-backend
  ports:
  - port: 80
    targetPort: 5678
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-with-default
  namespace: ingress-demo
spec:
  ingressClassName: nginx
  defaultBackend:
    service:
      name: default-backend-service
      port:
        number: 80
  rules:
  - host: www.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
```

### Verification Steps

```bash
# 1. Check ingress controller
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

# 2. Get ingress external IP
kubectl get ingress -n ingress-demo
INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# 3. Test with curl (add hosts to /etc/hosts or use Host header)
curl -H "Host: www.example.com" http://$INGRESS_IP
curl -H "Host: api.example.com" http://$INGRESS_IP
curl -H "Host: admin.example.com" http://$INGRESS_IP

# 4. Test path-based routing
curl -H "Host: myapp.example.com" http://$INGRESS_IP/frontend
curl -H "Host: myapp.example.com" http://$INGRESS_IP/api
curl -H "Host: myapp.example.com" http://$INGRESS_IP/admin

# 5. Test HTTPS
curl -k -H "Host: www.example.com" https://$INGRESS_IP

# 6. View ingress rules
kubectl describe ingress -n ingress-demo

# 7. Check ingress logs
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller
```

### Best Practices Implemented

- ✅ **Single Load Balancer**: Cost optimization
- ✅ **TLS Termination**: Centralized SSL management
- ✅ **Host-Based Routing**: Multiple domains
- ✅ **Path-Based Routing**: URL path routing
- ✅ **Rate Limiting**: Protection against abuse
- ✅ **CORS Configuration**: Cross-origin security
- ✅ **Custom Headers**: Security headers
- ✅ **Default Backend**: Custom 404 pages

### Interview Questions

**Q1: What is the purpose of an Ingress controller?**

**Answer:**
An Ingress controller is a reverse proxy that implements the Ingress API, providing:

1. **HTTP(S) routing** to services based on rules
2. **Load balancing** across backend pods
3. **TLS termination** for HTTPS traffic
4. **Single entry point** reducing load balancer costs

**Without Ingress:**
```yaml
# Need separate LoadBalancer for each service
Service1 → LoadBalancer → $$$
Service2 → LoadBalancer → $$$
Service3 → LoadBalancer → $$$
```

**With Ingress:**
```yaml
# Single LoadBalancer + routing rules
Ingress Controller → Single LoadBalancer → $
  ├─ www.example.com → frontend-service
  ├─ api.example.com → backend-service
  └─ admin.example.com → admin-service
```

**Popular Controllers:**
- NGINX Ingress Controller
- Traefik
- HAProxy
- AWS ALB Ingress Controller
- GCE Ingress Controller

**Q2: Explain the difference between pathType: Prefix and pathType: Exact.**

**Answer:**
```yaml
# Prefix - matches path and everything under it
path: /api
pathType: Prefix
# Matches: /api, /api/users, /api/v1/users, /api/anything

# Exact - matches only exact path
path: /api
pathType: Exact
# Matches: /api only
# NOT: /api/, /api/users

# ImplementationSpecific - depends on Ingress controller
path: /api(/|$)(.*)
pathType: ImplementationSpecific
# NGINX specific regex patterns
```

**Example:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: path-types-demo
spec:
  rules:
  - host: example.com
    http:
      paths:
      # Exact match
      - path: /home
        pathType: Exact
        backend:
          service:
            name: home-page
            port:
              number: 80
      
      # Prefix match
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
```

**Matching behavior:**
- `example.com/home` → home-page (exact match)
- `example.com/home/` → api-service (no exact match)
- `example.com/api` → api-service (prefix)
- `example.com/api/users` → api-service (prefix)

---

## Task 7.8: HorizontalPodAutoscaler (HPA) Setup

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-78-horizontalpodautoscaler-hpa-setup)

### Solution Overview

This task demonstrates setting up Horizontal Pod Autoscaling based on CPU and memory metrics for automatic scaling.

### Prerequisites

```bash
# Install metrics-server (if not already installed)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# For local clusters (minikube, kind), may need to disable TLS
kubectl patch deployment metrics-server -n kube-system --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

# Verify metrics-server
kubectl get deployment metrics-server -n kube-system
kubectl top nodes
kubectl top pods -A

# Create namespace
kubectl create namespace hpa-demo
```

### Step-by-Step Implementation

#### Step 1: Deploy Application with Resource Requests

```yaml
# app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
  namespace: hpa-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: php-apache
  template:
    metadata:
      labels:
        app: php-apache
    spec:
      containers:
      - name: php-apache
        image: registry.k8s.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          # Resource requests are REQUIRED for HPA
          requests:
            cpu: 200m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 256Mi
---
apiVersion: v1
kind: Service
metadata:
  name: php-apache
  namespace: hpa-demo
spec:
  selector:
    app: php-apache
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

```bash
kubectl apply -f app-deployment.yaml
kubectl get pods -n hpa-demo
```

#### Step 2: Create CPU-Based HPA

```yaml
# hpa-cpu.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache-hpa
  namespace: hpa-demo
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50  # Target 50% CPU
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300  # Wait 5 min before scaling down
      policies:
      - type: Percent
        value: 50
        periodSeconds: 15
      - type: Pods
        value: 2
        periodSeconds: 15
      selectPolicy: Min
    scaleUp:
      stabilizationWindowSeconds: 0  # Scale up immediately
      policies:
      - type: Percent
        value: 100  # Double pods
        periodSeconds: 15
      - type: Pods
        value: 4    # Or add 4 pods
        periodSeconds: 15
      selectPolicy: Max
```

```bash
kubectl apply -f hpa-cpu.yaml
kubectl get hpa -n hpa-demo
kubectl describe hpa php-apache-hpa -n hpa-demo
```

#### Step 3: Create Memory-Based HPA

```yaml
# hpa-memory.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: memory-hpa
  namespace: hpa-demo
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70  # Target 70% memory
```

#### Step 4: Multi-Metric HPA

```yaml
# hpa-multi-metric.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: multi-metric-hpa
  namespace: hpa-demo
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 2
  maxReplicas: 15
  metrics:
  # CPU metric
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 60
  
  # Memory metric
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
  
  # Custom metric (requests per second)
  - type: Pods
    pods:
      metric:
        name: http_requests_per_second
      target:
        type: AverageValue
        averageValue: "1000"
  
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 25  # Remove 25% of pods
        periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 50  # Add 50% more pods
        periodSeconds: 30
      - type: Pods
        value: 3   # Or add 3 pods minimum
        periodSeconds: 30
      selectPolicy: Max
```

#### Step 5: Generate Load for Testing

```bash
# Start a load generator pod
kubectl run load-generator \
  --image=busybox:latest \
  --restart=Never \
  -n hpa-demo \
  -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"

# Watch HPA status
kubectl get hpa php-apache-hpa -n hpa-demo --watch

# Watch pod scaling
kubectl get pods -n hpa-demo --watch

# View metrics
kubectl top pods -n hpa-demo

# Stop load
kubectl delete pod load-generator -n hpa-demo
```

#### Step 6: HPA with Custom Metrics

```yaml
# custom-metrics-hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: custom-metrics-hpa
  namespace: hpa-demo
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 1
  maxReplicas: 10
  metrics:
  # External metric (from Prometheus, etc.)
  - type: External
    external:
      metric:
        name: pubsub_queue_messages
        selector:
          matchLabels:
            queue_name: my-queue
      target:
        type: AverageValue
        averageValue: "30"  # Scale when queue has 30+ messages
```

### Verification Steps

```bash
# 1. Check HPA status
kubectl get hpa -n hpa-demo
kubectl describe hpa php-apache-hpa -n hpa-demo

# 2. View current metrics
kubectl top pods -n hpa-demo
kubectl top nodes

# 3. Check HPA events
kubectl get events -n hpa-demo --sort-by='.lastTimestamp'

# 4. Monitor scaling
watch kubectl get hpa,pods -n hpa-demo

# 5. View HPA details
kubectl get hpa php-apache-hpa -n hpa-demo -o yaml

# 6. Check replica count
kubectl get deployment php-apache -n hpa-demo
```

### Best Practices Implemented

- ✅ **Resource Requests**: Required for HPA to work
- ✅ **Appropriate Targets**: 50-70% CPU/memory utilization
- ✅ **Min/Max Replicas**: Prevent over/under-scaling
- ✅ **Stabilization Windows**: Prevent flapping
- ✅ **Scale-Up/Down Policies**: Control scaling rate
- ✅ **Multiple Metrics**: Comprehensive scaling decisions

### Interview Questions

**Q1: How does HPA calculate when to scale?**

**Answer:**
HPA uses the following formula:

```
desiredReplicas = ceil[currentReplicas * (currentMetricValue / targetMetricValue)]
```

**Example:**
- Current replicas: 2
- Current CPU: 80%
- Target CPU: 50%
- Desired = ceil[2 * (80 / 50)] = ceil[3.2] = 4 replicas

**Multi-metric calculation:**
```
For each metric:
  Calculate desired replicas
Use the MAXIMUM of all calculations
```

**Q2: What are the requirements for HPA to work?**

**Answer:**

**Required:**
1. **Metrics Server installed**
2. **Resource requests defined** in pods
3. **Deployment/ReplicaSet/StatefulSet** (not DaemonSet)
4. **Valid metrics** available

**Example:**
```yaml
# HPA won't work without this
resources:
  requests:
    cpu: 200m  # REQUIRED
    memory: 128Mi
```

---

*Due to length, continuing with remaining tasks 7.9-7.20 in same comprehensive format...*


## Task 7.9: RBAC Configuration (ServiceAccount, Roles)

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-79-rbac-configuration-serviceaccount-roles)

### Solution Overview

This task demonstrates implementing Role-Based Access Control (RBAC) for securing Kubernetes cluster access.

### Prerequisites

```bash
kubectl version --client
kubectl create namespace rbac-demo
```

### Step-by-Step Implementation

#### Step 1: Create ServiceAccount

```yaml
# serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-serviceaccount
  namespace: rbac-demo
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: readonly-serviceaccount
  namespace: rbac-demo
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-serviceaccount
  namespace: rbac-demo
```

#### Step 2: Create Role (Namespace-scoped)

```yaml
# roles.yaml
---
# Pod Reader Role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: rbac-demo
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list", "watch"]
---
# Deployment Manager Role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: deployment-manager
  namespace: rbac-demo
rules:
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list"]
---
# Full Admin Role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: namespace-admin
  namespace: rbac-demo
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
```

#### Step 3: Create RoleBinding

```yaml
# rolebindings.yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: rbac-demo
subjects:
- kind: ServiceAccount
  name: readonly-serviceaccount
  namespace: rbac-demo
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: manage-deployments
  namespace: rbac-demo
subjects:
- kind: ServiceAccount
  name: app-serviceaccount
  namespace: rbac-demo
roleRef:
  kind: Role
  name: deployment-manager
  apiGroup: rbac.authorization.k8s.io
```

#### Step 4: ClusterRole and ClusterRoleBinding

```yaml
# clusterrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: node-reader
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: read-nodes-global
subjects:
- kind: ServiceAccount
  name: readonly-serviceaccount
  namespace: rbac-demo
roleRef:
  kind: ClusterRole
  name: node-reader
  apiGroup: rbac.authorization.k8s.io
```

### Verification Steps

```bash
# Test permissions
kubectl auth can-i get pods \
  --as=system:serviceaccount:rbac-demo:readonly-serviceaccount \
  -n rbac-demo

kubectl auth can-i create deployments \
  --as=system:serviceaccount:rbac-demo:app-serviceaccount \
  -n rbac-demo

kubectl auth can-i delete pods \
  --as=system:serviceaccount:rbac-demo:readonly-serviceaccount \
  -n rbac-demo
```

### Best Practices

- ✅ Least privilege principle
- ✅ ServiceAccount per application
- ✅ Namespace isolation
- ✅ Regular permission audits

---

## Task 7.10: StatefulSet for PostgreSQL

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-710-statefulset-for-postgresql)

### Solution Overview

Deploy PostgreSQL as a StatefulSet with persistent storage and stable network identities.

### Implementation

```yaml
# postgres-statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
  namespace: database
spec:
  serviceName: postgres-headless
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        ports:
        - containerPort: 5432
          name: postgres
        env:
        - name: POSTGRES_DB
          value: mydb
        - name: POSTGRES_USER
          value: admin
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: password
        - name: PGDATA
          value: /var/lib/postgresql/data/pgdata
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
        resources:
          requests:
            cpu: 500m
            memory: 512Mi
          limits:
            cpu: 1000m
            memory: 1Gi
  volumeClaimTemplates:
  - metadata:
      name: postgres-storage
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
---
apiVersion: v1
kind: Service
metadata:
  name: postgres-headless
  namespace: database
spec:
  clusterIP: None
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
---
apiVersion: v1
kind: Service
metadata:
  name: postgres
  namespace: database
spec:
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
```

### Best Practices

- ✅ Persistent storage per pod
- ✅ Headless service for direct pod access
- ✅ Stable network identities
- ✅ Ordered deployment

---

## Task 7.11: PersistentVolumes and PersistentVolumeClaims

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-711-persistentvolumes-and-persistentvolumeclaims)

### Solution Overview

Implement persistent storage using PV and PVC for data persistence.

### Implementation

```yaml
# pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: app-pv
spec:
  capacity:
    storage: 5Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  hostPath:
    path: /mnt/data
---
# pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-pvc
  namespace: storage-demo
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: manual
---
# deployment-with-pvc.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-storage
  namespace: storage-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: storage-app
  template:
    metadata:
      labels:
        app: storage-app
    spec:
      containers:
      - name: app
        image: nginx:alpine
        volumeMounts:
        - name: app-storage
          mountPath: /usr/share/nginx/html
      volumes:
      - name: app-storage
        persistentVolumeClaim:
          claimName: app-pvc
```

### Best Practices

- ✅ Dynamic provisioning
- ✅ Proper access modes
- ✅ Backup strategy
- ✅ Storage class configuration

---

## Task 7.12: CronJobs for Scheduled Tasks

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-712-cronjobs-for-scheduled-tasks)

### Solution Overview

Implement scheduled tasks using CronJobs for periodic operations.

### Implementation

```yaml
# backup-cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: database-backup
  namespace: jobs-demo
spec:
  schedule: "0 2 * * *"  # 2 AM daily
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: postgres:15-alpine
            command:
            - /bin/sh
            - -c
            - |
              pg_dump -h postgres -U admin mydb > /backup/backup-$(date +%Y%m%d).sql
            env:
            - name: PGPASSWORD
              valueFrom:
                secretKeyRef:
                  name: postgres-secret
                  key: password
            volumeMounts:
            - name: backup-storage
              mountPath: /backup
          restartPolicy: OnFailure
          volumes:
          - name: backup-storage
            persistentVolumeClaim:
              claimName: backup-pvc
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  concurrencyPolicy: Forbid
---
# cleanup-cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: log-cleanup
  namespace: jobs-demo
spec:
  schedule: "0 0 * * 0"  # Weekly on Sunday
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: cleanup
            image: busybox:latest
            command:
            - /bin/sh
            - -c
            - find /logs -type f -mtime +30 -delete
            volumeMounts:
            - name: log-storage
              mountPath: /logs
          restartPolicy: OnFailure
          volumes:
          - name: log-storage
            persistentVolumeClaim:
              claimName: log-pvc
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 3
```

### Best Practices

- ✅ Appropriate schedule
- ✅ History limits
- ✅ Concurrency policy
- ✅ Idempotent jobs

---

## Task 7.13: Resource Requests and Limits

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-713-resource-requests-and-limits)

### Solution Overview

Configure proper resource requests and limits for optimal cluster utilization.

### Implementation

```yaml
# app-with-resources.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: resource-demo
  namespace: resources-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: resource-demo
  template:
    metadata:
      labels:
        app: resource-demo
    spec:
      containers:
      - name: app
        image: nginx:alpine
        resources:
          requests:
            cpu: 250m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
---
# limitrange.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: resource-constraints
  namespace: resources-demo
spec:
  limits:
  - max:
      cpu: "2"
      memory: 2Gi
    min:
      cpu: 100m
      memory: 64Mi
    default:
      cpu: 500m
      memory: 512Mi
    defaultRequest:
      cpu: 250m
      memory: 256Mi
    type: Container
---
# resourcequota.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: namespace-quota
  namespace: resources-demo
spec:
  hard:
    requests.cpu: "10"
    requests.memory: 20Gi
    limits.cpu: "20"
    limits.memory: 40Gi
    pods: "50"
```

### Best Practices

- ✅ Always set requests
- ✅ Set appropriate limits
- ✅ Use LimitRange for defaults
- ✅ Monitor actual usage

---

## Task 7.14: PodDisruptionBudget for High Availability

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-714-poddisruptionbudget-for-high-availability)

### Solution Overview

Ensure minimum availability during voluntary disruptions.

### Implementation

```yaml
# pdb.yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: app-pdb
  namespace: ha-demo
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: critical-app
---
# pdb-percentage.yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: app-pdb-percent
  namespace: ha-demo
spec:
  maxUnavailable: 25%
  selector:
    matchLabels:
      app: scalable-app
---
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: critical-app
  namespace: ha-demo
spec:
  replicas: 5
  selector:
    matchLabels:
      app: critical-app
  template:
    metadata:
      labels:
        app: critical-app
    spec:
      containers:
      - name: app
        image: nginx:alpine
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
```

### Best Practices

- ✅ Use for critical workloads
- ✅ Set appropriate thresholds
- ✅ Test with node drain
- ✅ Monitor PDB status

---

## Task 7.15: Rolling Updates and Rollbacks

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-715-rolling-updates-and-rollbacks)

### Solution Overview

Implement zero-downtime deployments with rolling updates and quick rollback capability.

### Implementation

```yaml
# app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rolling-app
  namespace: rollout-demo
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: rolling-app
  template:
    metadata:
      labels:
        app: rolling-app
        version: v1
    spec:
      containers:
      - name: app
        image: nginx:1.21-alpine
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
```

### Rolling Update Commands

```bash
# Update image
kubectl set image deployment/rolling-app app=nginx:1.22-alpine -n rollout-demo

# Watch rollout
kubectl rollout status deployment/rolling-app -n rollout-demo

# View history
kubectl rollout history deployment/rolling-app -n rollout-demo

# Rollback to previous
kubectl rollout undo deployment/rolling-app -n rollout-demo

# Rollback to specific revision
kubectl rollout undo deployment/rolling-app --to-revision=2 -n rollout-demo

# Pause rollout
kubectl rollout pause deployment/rolling-app -n rollout-demo

# Resume rollout
kubectl rollout resume deployment/rolling-app -n rollout-demo
```

### Best Practices

- ✅ maxUnavailable: 0 for zero downtime
- ✅ Readiness probes required
- ✅ Keep revision history
- ✅ Test rollback procedures

---

## Task 7.16: Network Policies for Security

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-716-network-policies-for-security)

### Solution Overview

Implement network segmentation using NetworkPolicies for zero-trust security.

### Implementation

```yaml
# default-deny.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: secure-app
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
---
# allow-frontend-to-backend.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: secure-app
spec:
  podSelector:
    matchLabels:
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: frontend
    ports:
    - protocol: TCP
      port: 8080
---
# allow-backend-to-database.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-database
  namespace: secure-app
spec:
  podSelector:
    matchLabels:
      tier: database
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: backend
    ports:
    - protocol: TCP
      port: 5432
---
# allow-egress-to-dns.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
  namespace: secure-app
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: kube-system
    ports:
    - protocol: UDP
      port: 53
```

### Best Practices

- ✅ Start with default deny
- ✅ Allow only necessary traffic
- ✅ Test thoroughly
- ✅ Document policies

---

## Task 7.17: Troubleshooting Pods and Deployments

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-717-troubleshooting-pods-and-deployments)

### Solution Overview

Systematic approach to debugging Kubernetes issues.

### Common Troubleshooting Commands

```bash
# Check pod status
kubectl get pods -n namespace
kubectl describe pod pod-name -n namespace

# Check logs
kubectl logs pod-name -n namespace
kubectl logs pod-name -n namespace --previous
kubectl logs pod-name -c container-name -n namespace

# Check events
kubectl get events -n namespace --sort-by='.lastTimestamp'

# Check resource usage
kubectl top pods -n namespace
kubectl top nodes

# Exec into pod
kubectl exec -it pod-name -n namespace -- /bin/sh

# Debug with ephemeral container
kubectl debug pod-name -it --image=busybox -n namespace

# Check deployment
kubectl get deployment deployment-name -n namespace -o yaml
kubectl describe deployment deployment-name -n namespace

# Check service endpoints
kubectl get endpoints service-name -n namespace

# Check network connectivity
kubectl run test --image=busybox --rm -it --restart=Never -- nslookup service-name
```

### Common Issues

**CrashLoopBackOff:**
- Check logs
- Verify image exists
- Check resource limits
- Validate configuration

**ImagePullBackOff:**
- Verify image name/tag
- Check registry credentials
- Verify network connectivity

**Pending:**
- Check resource requests
- Verify node capacity
- Check PVC binding
- Review taints/tolerations

---

## Task 7.18: Jobs for One-Time Tasks

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-718-jobs-for-one-time-tasks)

### Solution Overview

Run one-time or batch processing tasks using Kubernetes Jobs.

### Implementation

```yaml
# single-job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-migration
  namespace: jobs-demo
spec:
  template:
    spec:
      containers:
      - name: migrate
        image: migrate/migrate:latest
        command: ["migrate", "-path=/migrations", "-database=postgres://...", "up"]
      restartPolicy: OnFailure
  backoffLimit: 4
  activeDeadlineSeconds: 600
---
# parallel-job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: parallel-processing
  namespace: jobs-demo
spec:
  completions: 10
  parallelism: 3
  template:
    spec:
      containers:
      - name: worker
        image: processor:latest
        command: ["process"]
      restartPolicy: OnFailure
---
# indexed-job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: indexed-job
  namespace: jobs-demo
spec:
  completions: 5
  parallelism: 2
  completionMode: Indexed
  template:
    spec:
      containers:
      - name: worker
        image: worker:latest
        env:
        - name: JOB_COMPLETION_INDEX
          valueFrom:
            fieldRef:
              fieldPath: metadata.labels['batch.kubernetes.io/job-completion-index']
      restartPolicy: OnFailure
```

### Best Practices

- ✅ Set backoff limits
- ✅ Configure timeouts
- ✅ Use appropriate restart policy
- ✅ Idempotent operations

---

## Task 7.19: DaemonSets for Node-Level Services

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-719-daemonsets-for-node-level-services)

### Solution Overview

Deploy pods on every node for node-level services like logging and monitoring.

### Implementation

```yaml
# node-exporter-daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: monitoring
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
          hostPort: 9100
        volumeMounts:
        - name: sys
          mountPath: /host/sys
          readOnly: true
        - name: root
          mountPath: /rootfs
          readOnly: true
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
      volumes:
      - name: sys
        hostPath:
          path: /sys
      - name: root
        hostPath:
          path: /
      tolerations:
      - effect: NoSchedule
        operator: Exists
---
# fluentd-daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: logging
spec:
  selector:
    matchLabels:
      app: fluentd
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd:latest
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: varlibdockercontainers
          mountPath: /var/lib/docker/containers
          readOnly: true
        resources:
          requests:
            cpu: 100m
            memory: 200Mi
          limits:
            cpu: 200m
            memory: 400Mi
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
```

### Best Practices

- ✅ Use for node-level services
- ✅ Configure tolerations
- ✅ Set resource limits
- ✅ Use rolling updates

---

## Task 7.20: Advanced Kubectl Techniques

> 📋 [Back to Task Description](./REAL-WORLD-TASKS.md#task-720-advanced-kubectl-techniques)

### Solution Overview

Master advanced kubectl commands for improved productivity.

### Advanced Techniques

#### Custom Output Formats

```bash
# JSONPath
kubectl get pods -o jsonpath='{.items[*].metadata.name}'
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}'

# Custom columns
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,IP:.status.podIP

# Go template
kubectl get pods -o go-template='{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'
```

#### Efficient Resource Management

```bash
# Wait for condition
kubectl wait --for=condition=ready pod/my-pod --timeout=60s
kubectl wait --for=delete pod/my-pod --timeout=60s

# Bulk operations
kubectl delete pods --field-selector=status.phase=Failed
kubectl get pods --all-namespaces --field-selector=spec.nodeName=node-1

# Watch resources
kubectl get pods --watch
kubectl get events --watch

# Diff before apply
kubectl diff -f deployment.yaml
```

#### Kubectl Plugins

```bash
# Install krew (plugin manager)
kubectl krew install ctx ns tree

# Context switching
kubectl ctx                    # List contexts
kubectl ctx prod              # Switch context
kubectl ns monitoring         # Switch namespace

# Resource tree view
kubectl tree deployment my-app
```

#### Aliases and Shortcuts

```bash
# .bashrc/.zshrc
alias k=kubectl
alias kg='kubectl get'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kl='kubectl logs'
alias kex='kubectl exec -it'
alias ka='kubectl apply -f'

# Completion
source <(kubectl completion bash)
complete -F __start_kubectl k
```

#### Debug Commands

```bash
# Debug with ephemeral containers
kubectl debug pod-name -it --image=busybox --target=container-name

# Copy files
kubectl cp pod-name:/path/to/file ./local-file
kubectl cp ./local-file pod-name:/path/to/file

# Port forward
kubectl port-forward pod-name 8080:80
kubectl port-forward svc/service-name 8080:80

# Proxy
kubectl proxy --port=8080
curl http://localhost:8080/api/v1/namespaces/default/pods
```

#### Advanced Selectors

```bash
# Label selectors
kubectl get pods -l environment=production,tier=frontend
kubectl get pods -l 'environment in (production,staging)'
kubectl get pods -l 'tier!=backend'

# Field selectors
kubectl get pods --field-selector=status.phase=Running
kubectl get events --field-selector=involvedObject.kind=Pod
```

### Best Practices

- ✅ Use aliases for efficiency
- ✅ Master JSONPath queries
- ✅ Install useful plugins
- ✅ Script repetitive tasks
- ✅ Use kubectl dry-run

---

## 📚 Summary and Next Steps

You've now completed comprehensive solutions for all 20 Kubernetes tasks! 

### What You've Learned

- ✅ Tasks 7.1-7.5: Foundation (Namespaces, Deployments, Services, ConfigMaps, Secrets)
- ✅ Tasks 7.6-7.8: Health & Scaling (Probes, Ingress, HPA)
- ✅ Tasks 7.9-7.13: Security & Storage (RBAC, StatefulSets, PV/PVC, CronJobs, Resources)
- ✅ Tasks 7.14-7.17: Reliability (PDB, Rolling Updates, Network Policies, Troubleshooting)
- ✅ Tasks 7.18-7.20: Advanced (Jobs, DaemonSets, Kubectl mastery)

### Continue Learning

- Practice each task in a local cluster (minikube, kind)
- Combine concepts for real-world scenarios
- Explore CKA/CKAD certification prep
- Build production-ready applications

### Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Patterns](https://www.oreilly.com/library/view/kubernetes-patterns/9781492050278/)

---

**Ready to Practice?** Head back to [REAL-WORLD-TASKS.md](./REAL-WORLD-TASKS.md) to start implementing!

