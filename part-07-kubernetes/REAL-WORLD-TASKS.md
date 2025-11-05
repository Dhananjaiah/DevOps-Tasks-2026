# Kubernetes Deployment & Operations - Real-World Tasks

## 🎯 Overview

This document contains **20 comprehensive, production-ready Kubernetes tasks** designed for DevOps engineers managing containerized applications in production. Each task represents real scenarios you'll encounter when operating Kubernetes clusters.

**What Makes These Tasks Valuable:**
- ✅ **Production-focused**: Based on actual production challenges
- ✅ **Interview-ready**: Cover common Kubernetes interview topics
- ✅ **Hands-on practice**: Executable tasks with validation steps
- ✅ **Comprehensive**: From basics to advanced cluster operations
- ✅ **Best practices**: Follow Kubernetes community standards

---

## 📚 Available Resources

### Task Files
- **[REAL-WORLD-TASKS.md](REAL-WORLD-TASKS.md)** (this file) - 📝 Task descriptions and requirements
- **[REAL-WORLD-TASKS-SOLUTIONS.md](REAL-WORLD-TASKS-SOLUTIONS.md)** - ✅ Complete solutions with manifests
- **[NAVIGATION-GUIDE.md](NAVIGATION-GUIDE.md)** - 📚 How to navigate between tasks and solutions
- **[QUICK-START-GUIDE.md](QUICK-START-GUIDE.md)** - 🚀 Quick reference and task categories

> **💡 New to these tasks?** Check out the [Navigation Guide](NAVIGATION-GUIDE.md) first!

---

## Task Index

| # | Task Name | Difficulty | Time | Solution |
|---|-----------|------------|------|----------|
| 7.1 | [Namespace Organization](#task-71-namespace-organization-and-resource-quotas) | Easy | 45 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-71-namespace-organization-and-resource-quotas) |
| 7.2 | [Deploy Backend API](#task-72-deploy-backend-api-with-deployment) | Medium | 60 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-72-deploy-backend-api-with-deployment) |
| 7.3 | [Service Types](#task-73-service-types-and-networking) | Medium | 60 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-73-service-types-and-networking) |
| 7.4 | [ConfigMaps](#task-74-configmaps-for-application-configuration) | Easy | 45 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-74-configmaps-for-application-configuration) |
| 7.5 | [Secrets Management](#task-75-secrets-management-in-kubernetes) | Medium | 60 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-75-secrets-management-in-kubernetes) |
| 7.6 | [Health Probes](#task-76-liveness-and-readiness-probes) | Medium | 60 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-76-liveness-and-readiness-probes) |
| 7.7 | [Ingress Controller](#task-77-ingress-controller-and-ingress-resources) | Medium | 75 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-77-ingress-controller-and-ingress-resources) |
| 7.8 | [HorizontalPodAutoscaler](#task-78-horizontalpodautoscaler-hpa-setup) | Medium | 75 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-78-horizontalpodautoscaler-hpa-setup) |
| 7.9 | [RBAC Configuration](#task-79-rbac-configuration-serviceaccount-roles) | Hard | 90 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-79-rbac-configuration-serviceaccount-roles) |
| 7.10 | [StatefulSet for PostgreSQL](#task-710-statefulset-for-postgresql) | Hard | 90 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-710-statefulset-for-postgresql) |
| 7.11 | [PersistentVolumes](#task-711-persistentvolumes-and-persistentvolumeclaims) | Medium | 75 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-711-persistentvolumes-and-persistentvolumeclaims) |
| 7.12 | [CronJobs](#task-712-cronjobs-for-scheduled-tasks) | Easy | 45 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-712-cronjobs-for-scheduled-tasks) |
| 7.13 | [Resource Limits](#task-713-resource-requests-and-limits) | Medium | 60 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-713-resource-requests-and-limits) |
| 7.14 | [PodDisruptionBudget](#task-714-poddisruptionbudget-for-high-availability) | Medium | 60 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-714-poddisruptionbudget-for-high-availability) |
| 7.15 | [Rolling Updates](#task-715-rolling-updates-and-rollbacks) | Medium | 75 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-715-rolling-updates-and-rollbacks) |
| 7.16 | [Network Policies](#task-716-network-policies-for-security) | Hard | 90 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-716-network-policies-for-security) |
| 7.17 | [Troubleshooting](#task-717-troubleshooting-pods-and-deployments) | Medium | 75 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-717-troubleshooting-pods-and-deployments) |
| 7.18 | [Jobs](#task-718-jobs-for-one-time-tasks) | Easy | 45 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-718-jobs-for-one-time-tasks) |
| 7.19 | [DaemonSets](#task-719-daemonsets-for-node-level-services) | Medium | 60 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-719-daemonsets-for-node-level-services) |
| 7.20 | [Advanced Kubectl](#task-720-advanced-kubectl-techniques) | Medium | 60 min | [Solution](REAL-WORLD-TASKS-SOLUTIONS.md#task-720-advanced-kubectl-techniques) |

---

## Task 7.1: Namespace Organization and Resource Quotas

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-71-namespace-organization-and-resource-quotas)

### 🎬 Real-World Scenario

Your company is running a Kubernetes cluster that hosts multiple teams' applications (development, staging, and production). Teams are complaining about:
- Applications interfering with each other
- One team consuming all cluster resources
- Difficulty isolating environments
- No clear boundaries between teams

You need to implement proper namespace organization with resource quotas and limit ranges to ensure fair resource distribution and environment isolation.

### 📋 Requirements

**Core Implementation:**
1. Create separate namespaces for dev, staging, and production
2. Set up ResourceQuotas for each namespace
3. Configure LimitRanges to set default resource limits
4. Implement RBAC to restrict namespace access
5. Label namespaces for easy identification
6. Create documentation for teams

**Validation Criteria:**
- [ ] Three namespaces created (dev, staging, prod)
- [ ] Resource quotas enforced on each namespace
- [ ] Limit ranges prevent resource-hungry pods
- [ ] Teams can only access their designated namespaces
- [ ] Pods respect resource constraints
- [ ] Documentation provided to teams

### 🎯 Success Criteria

- Pods cannot exceed namespace resource quotas
- Default resource limits applied automatically
- Teams isolated from each other
- Clear visibility into resource usage per namespace
- No single namespace can starve others

### 💡 Hints

- Use `kubectl create namespace` or YAML manifests
- ResourceQuota limits: CPU, memory, pods, services
- LimitRange sets defaults and maximums
- Use labels like `environment: prod` for organization
- Consider using NetworkPolicy for network isolation

---

## Task 7.2: Deploy Backend API with Deployment

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-72-deploy-backend-api-with-deployment)

### 🎬 Real-World Scenario

Your team has containerized a Node.js backend API and needs to deploy it to Kubernetes production. The application:
- Runs on port 8080
- Requires environment variables for database connection
- Needs 3 replicas for high availability
- Should use rolling updates for zero-downtime deployments
- Must be monitored for health

You need to create a production-ready Deployment with proper configurations.

### 📋 Requirements

**Core Implementation:**
1. Create a Deployment manifest for the backend API
2. Configure 3 replicas for high availability
3. Set resource requests and limits
4. Add environment variables for configuration
5. Implement pod anti-affinity for distribution
6. Add labels and selectors
7. Configure update strategy

**Validation Criteria:**
- [ ] Deployment creates 3 pods successfully
- [ ] Pods are distributed across nodes
- [ ] Environment variables injected correctly
- [ ] Resource limits enforced
- [ ] Rolling updates work without downtime
- [ ] Pods restart automatically if they crash

### 🎯 Success Criteria

- All 3 replicas running and healthy
- API responds to requests on port 8080
- Pods distributed across different nodes
- Rolling updates complete successfully
- Resource usage within defined limits

### 💡 Hints

- Use `apiVersion: apps/v1` for Deployment
- Set `strategy: RollingUpdate` with maxSurge and maxUnavailable
- Use pod anti-affinity to spread pods across nodes
- Resource requests help scheduler make decisions
- Labels are crucial for service discovery

---

## Task 7.3: Service Types and Networking

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-73-service-types-and-networking)

### 🎬 Real-World Scenario

Your application architecture has:
- Frontend (needs external access)
- Backend API (internal only)
- PostgreSQL database (internal only)

You need to set up appropriate Service objects to enable:
- External users accessing the frontend
- Frontend communicating with backend
- Backend communicating with database
- No external access to backend or database

### 📋 Requirements

**Core Implementation:**
1. Create a LoadBalancer Service for frontend
2. Create a ClusterIP Service for backend API
3. Create a ClusterIP Service for PostgreSQL
4. Configure proper port mappings
5. Use service discovery (DNS names)
6. Test connectivity between services

**Validation Criteria:**
- [ ] Frontend accessible from external IP
- [ ] Backend accessible from frontend pods
- [ ] Database accessible from backend pods
- [ ] Backend NOT accessible from outside cluster
- [ ] Database NOT accessible from outside cluster
- [ ] Service DNS names resolve correctly

### 🎯 Success Criteria

- External users can access frontend
- Inter-service communication works
- Internal services not exposed externally
- DNS-based service discovery functional
- Port mappings correct

### 💡 Hints

- LoadBalancer gets external IP (cloud provider)
- ClusterIP is cluster-internal only
- Service name becomes DNS name: `service-name.namespace.svc.cluster.local`
- Selectors must match pod labels
- Test with `kubectl exec` to verify connectivity

---

## Task 7.4: ConfigMaps for Application Configuration

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-74-configmaps-for-application-configuration)

### 🎬 Real-World Scenario

Your application currently has hardcoded configuration values in the Docker image:
- API URLs
- Feature flags
- Application settings
- Environment-specific values

This makes it difficult to:
- Change configuration without rebuilding images
- Use the same image across environments
- Manage configuration centrally

You need to externalize configuration using ConfigMaps.

### 📋 Requirements

**Core Implementation:**
1. Create ConfigMaps with application settings
2. Inject ConfigMap as environment variables
3. Mount ConfigMap as volume for config files
4. Create environment-specific ConfigMaps
5. Update Deployment to use ConfigMaps
6. Test configuration changes without rebuilding

**Validation Criteria:**
- [ ] ConfigMaps created for each environment
- [ ] Pods receive configuration as environment variables
- [ ] Config files mounted in pods
- [ ] Application reads configuration correctly
- [ ] Config changes trigger pod restart
- [ ] Same image works in all environments

### 🎯 Success Criteria

- Configuration externalized from image
- Easy to update without image rebuild
- Environment-specific configs work
- Application behaves correctly per environment
- Clear separation of config and code

### 💡 Hints

- Use `kubectl create configmap` or YAML
- ConfigMap can be env vars or files
- Use `envFrom` to inject all keys as env vars
- Mount as volume for configuration files
- Consider using Kustomize for environment variations

---

## Task 7.5: Secrets Management in Kubernetes

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-75-secrets-management-in-kubernetes)

### 🎬 Real-World Scenario

Your application needs access to sensitive information:
- Database passwords
- API keys
- TLS certificates
- OAuth tokens

Currently, these are in plain text ConfigMaps or hardcoded, which is a security risk. You need to implement proper secrets management.

### 📋 Requirements

**Core Implementation:**
1. Create Secrets for sensitive data
2. Encode secrets properly (base64)
3. Inject secrets as environment variables
4. Mount secrets as files
5. Set up RBAC to restrict secret access
6. Implement secret rotation strategy
7. Consider external secret management (optional)

**Validation Criteria:**
- [ ] Secrets created and encoded
- [ ] Pods access secrets securely
- [ ] Secrets not visible in pod definitions
- [ ] RBAC restricts unauthorized access
- [ ] TLS certificates mounted correctly
- [ ] Secret rotation process documented

### 🎯 Success Criteria

- Sensitive data stored in Secrets, not ConfigMaps
- Applications access secrets securely
- Secrets not exposed in logs or environment
- Access controls prevent unauthorized viewing
- Rotation process in place

### 💡 Hints

- Use `kubectl create secret generic`
- Base64 encode secret values
- Use `secretKeyRef` for environment variables
- Mount as volume for files like certificates
- Consider using sealed-secrets or external-secrets operators
- Never commit secrets to Git

---

## Task 7.6: Liveness and Readiness Probes

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-76-liveness-and-readiness-probes)

### 🎬 Real-World Scenario

Your application is experiencing issues:
- Pods hang and stop responding
- Traffic sent to pods that aren't ready
- Deadlocked containers not restarted
- Application crashes silently

Kubernetes keeps these pods running and sends traffic to them, causing user-facing errors. You need to implement proper health checks.

### 📋 Requirements

**Core Implementation:**
1. Add liveness probe to detect hung containers
2. Add readiness probe to control traffic flow
3. Add startup probe for slow-starting apps
4. Configure appropriate timeouts and thresholds
5. Implement health check endpoints in application
6. Test probe behavior

**Validation Criteria:**
- [ ] Liveness probe restarts unhealthy pods
- [ ] Readiness probe prevents traffic to unready pods
- [ ] Startup probe handles slow startup
- [ ] Probes don't cause false positives
- [ ] Application implements health endpoints
- [ ] Probes configured with proper thresholds

### 🎯 Success Criteria

- Dead pods automatically restart
- Traffic only to ready pods
- No false positive restarts
- Graceful handling of slow startups
- Improved application reliability

### 💡 Hints

- Liveness: Restart container if unhealthy
- Readiness: Remove from service if not ready
- Startup: Give time for slow-starting apps
- Use HTTP GET, TCP, or exec probes
- Set appropriate `initialDelaySeconds`
- Consider `failureThreshold` and `periodSeconds`

---

## Task 7.7: Ingress Controller and Ingress Resources

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-77-ingress-controller-and-ingress-resources)

### 🎬 Real-World Scenario

Your company runs multiple services that need external access:
- `api.example.com` -> Backend API
- `www.example.com` -> Frontend
- `admin.example.com` -> Admin panel

Currently using separate LoadBalancers (expensive). You need to consolidate using an Ingress controller with:
- Single load balancer
- Path-based and host-based routing
- TLS termination
- HTTPS redirect

### 📋 Requirements

**Core Implementation:**
1. Install Nginx Ingress Controller
2. Create Ingress resources for each service
3. Configure host-based routing
4. Configure path-based routing
5. Set up TLS certificates
6. Configure HTTPS redirect
7. Add ingress annotations for customization

**Validation Criteria:**
- [ ] Ingress controller installed and running
- [ ] All services accessible via hostnames
- [ ] HTTPS working with valid certificates
- [ ] HTTP automatically redirects to HTTPS
- [ ] Path-based routing works correctly
- [ ] Single load balancer serves all services

### 🎯 Success Criteria

- Cost reduction (single load balancer)
- All services accessible via proper domains
- TLS encryption working
- Clean URL routing
- Centralized traffic management

### 💡 Hints

- Use Helm to install nginx-ingress
- cert-manager automates TLS certificates
- Use `host` field for domain routing
- Use `path` field for URL path routing
- Annotations customize behavior
- Test with `/etc/hosts` locally first

---

## Task 7.8: HorizontalPodAutoscaler (HPA) Setup

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-78-horizontalpodautoscaler-hpa-setup)

### 🎬 Real-World Scenario

Your application experiences variable load:
- Morning: Low traffic (2 pods sufficient)
- Afternoon: High traffic (needs 10 pods)
- Night: Very low traffic (1 pod enough)

Manual scaling is inefficient. You need automatic scaling based on metrics to:
- Handle traffic spikes automatically
- Reduce costs during low traffic
- Maintain performance under load

### 📋 Requirements

**Core Implementation:**
1. Install metrics-server
2. Configure resource requests (required for HPA)
3. Create HorizontalPodAutoscaler
4. Set min and max replica counts
5. Configure CPU-based scaling
6. Configure memory-based scaling (optional)
7. Test autoscaling behavior

**Validation Criteria:**
- [ ] Metrics-server collecting metrics
- [ ] HPA monitoring deployment
- [ ] Pods scale up under load
- [ ] Pods scale down when idle
- [ ] Scaling respects min/max bounds
- [ ] Scaling behavior is predictable

### 🎯 Success Criteria

- Automatic scaling based on CPU usage
- Handles traffic spikes gracefully
- Scales down during low traffic
- Maintains performance SLAs
- Cost optimization

### 💡 Hints

- Metrics-server required for HPA
- Resource requests must be set
- Default target: 80% CPU utilization
- Use `kubectl top pods` to view metrics
- Load test to trigger scaling
- Consider custom metrics for advanced use

---

## Task 7.9: RBAC Configuration (ServiceAccount, Roles)

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-79-rbac-configuration-serviceaccount-roles)

### 🎬 Real-World Scenario

Your Kubernetes cluster has multiple teams and applications:
- Developers need limited access to dev namespace
- CI/CD pipelines need deployment permissions
- Monitoring tools need read-only access
- Applications need to access Kubernetes API

Currently everyone has admin access (security risk). You need to implement least-privilege RBAC.

### 📋 Requirements

**Core Implementation:**
1. Create ServiceAccounts for applications
2. Create Roles for namespace-specific permissions
3. Create ClusterRoles for cluster-wide permissions
4. Create RoleBindings to grant permissions
5. Create ClusterRoleBindings where needed
6. Test access controls
7. Document permission model

**Validation Criteria:**
- [ ] ServiceAccounts created for each use case
- [ ] Roles define minimum necessary permissions
- [ ] RoleBindings associate users/SAs with roles
- [ ] Unauthorized actions are denied
- [ ] Applications work with limited permissions
- [ ] Audit logging enabled

### 🎯 Success Criteria

- Least privilege principle enforced
- Teams can only access their namespaces
- CI/CD has deployment permissions only
- Applications have minimal API access
- Security improved significantly

### 💡 Hints

- ServiceAccount for pods to access API
- Role for namespace-level permissions
- ClusterRole for cluster-level permissions
- RoleBinding binds Role to subjects
- Use `kubectl auth can-i` to test
- Start restrictive, add permissions as needed

---

## Task 7.10: StatefulSet for PostgreSQL

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-710-statefulset-for-postgresql)

### 🎬 Real-World Scenario

Your application needs a PostgreSQL database in Kubernetes. Requirements:
- Persistent storage (data survives pod restarts)
- Stable network identity
- Ordered deployment and scaling
- StatefulSet instead of Deployment

You need to deploy PostgreSQL as a StatefulSet with proper storage configuration.

### 📋 Requirements

**Core Implementation:**
1. Create StatefulSet for PostgreSQL
2. Configure volumeClaimTemplates for storage
3. Set up headless Service
4. Configure PostgreSQL settings
5. Set up initialization scripts
6. Implement backup strategy
7. Test data persistence

**Validation Criteria:**
- [ ] StatefulSet running with 1+ replicas
- [ ] Each pod has persistent storage
- [ ] Data persists across pod restarts
- [ ] Stable network identities maintained
- [ ] PostgreSQL accessible via service
- [ ] Backup and restore tested

### 🎯 Success Criteria

- Database data persists across restarts
- Stable pod identities maintained
- Ordered startup and shutdown
- Production-ready database setup
- Backup and recovery process works

### 💡 Hints

- StatefulSets provide stable identities
- volumeClaimTemplates create PVCs per pod
- Headless service for stable DNS
- Pod names: `postgresql-0`, `postgresql-1`, etc.
- Consider using Postgres operator for production
- Test failover scenarios

---

## Task 7.11: PersistentVolumes and PersistentVolumeClaims

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-711-persistentvolumes-and-persistentvolumeclaims)

### 🎬 Real-World Scenario

Your application needs persistent storage for:
- User uploaded files
- Application logs
- Database data
- Shared configuration

You need to set up persistent storage that survives pod restarts and can be shared across pods if needed.

### �� Requirements

**Core Implementation:**
1. Create PersistentVolume (PV) with appropriate storage class
2. Create PersistentVolumeClaim (PVC) to request storage
3. Mount PVC in pod
4. Configure access modes (ReadWriteOnce, ReadWriteMany)
5. Set up dynamic provisioning
6. Test data persistence
7. Implement backup strategy

**Validation Criteria:**
- [ ] PV created with correct capacity
- [ ] PVC bound to PV
- [ ] Pod successfully mounts PVC
- [ ] Data persists across pod restarts
- [ ] Dynamic provisioning works
- [ ] Access modes enforced

### 🎯 Success Criteria

- Storage persists independently of pods
- Claims automatically provisioned
- Appropriate access modes configured
- Data safe from pod failures
- Backup strategy in place

### 💡 Hints

- Cloud providers offer StorageClasses
- Dynamic provisioning creates PVs automatically
- RWO: Single node, RWX: Multiple nodes
- Reclaim policy: Retain, Delete, Recycle
- Use StatefulSet for replicated PVCs
- Consider using CSI drivers

---

## Task 7.12: CronJobs for Scheduled Tasks

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-712-cronjobs-for-scheduled-tasks)

### 🎬 Real-World Scenario

Your application needs periodic tasks:
- Daily database backups at 2 AM
- Hourly data synchronization
- Weekly report generation
- Monthly cleanup of old data

You need to schedule these tasks in Kubernetes using CronJobs.

### 📋 Requirements

**Core Implementation:**
1. Create CronJob for database backup
2. Set appropriate schedule (cron format)
3. Configure job settings (concurrency, history)
4. Set up resource limits
5. Implement success/failure notifications
6. Configure timezone (if needed)
7. Test job execution

**Validation Criteria:**
- [ ] CronJobs created with correct schedules
- [ ] Jobs execute at scheduled times
- [ ] Successful jobs stored in history
- [ ] Failed jobs retained for debugging
- [ ] Resource limits prevent runaway jobs
- [ ] Notifications work for failures

### 🎯 Success Criteria

- Tasks execute on schedule automatically
- Failed jobs don't block new executions
- Job history maintained appropriately
- Resource usage controlled
- Monitoring and alerting configured

### 💡 Hints

- Use cron syntax: `* * * * *`
- `concurrencyPolicy`: Allow, Forbid, Replace
- `successfulJobsHistoryLimit` controls history
- Set `activeDeadlineSeconds` to prevent runaway
- Use volume mounts for persistence
- Consider using external cron for better control

---

## Task 7.13: Resource Requests and Limits

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-713-resource-requests-and-limits)

### 🎬 Real-World Scenario

Your cluster is experiencing issues:
- Some pods consuming excessive resources
- Other pods starved and performing poorly
- Nodes becoming overcommitted
- OOMKilled pods frequently

You need to implement proper resource requests and limits to ensure fair resource distribution.

### 📋 Requirements

**Core Implementation:**
1. Analyze application resource usage
2. Set appropriate resource requests
3. Set appropriate resource limits
4. Configure LimitRanges for defaults
5. Set up ResourceQuotas for namespaces
6. Monitor resource usage
7. Tune based on actual usage

**Validation Criteria:**
- [ ] All pods have resource requests
- [ ] All pods have resource limits
- [ ] Scheduler makes informed decisions
- [ ] No resource starvation
- [ ] OOMKilled events reduced
- [ ] Cluster utilization optimized

### 🎯 Success Criteria

- Fair resource allocation across pods
- Predictable scheduling behavior
- Reduced OOMKilled incidents
- Improved cluster stability
- Cost optimization

### 💡 Hints

- Requests: Guaranteed resources
- Limits: Maximum resources
- CPU: Compressible resource
- Memory: Non-compressible (OOMKill if exceeded)
- Use `kubectl top` to monitor
- Start conservative, adjust based on metrics

---

## Task 7.14: PodDisruptionBudget for High Availability

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-714-poddisruptionbudget-for-high-availability)

### 🎬 Real-World Scenario

During cluster maintenance (node upgrades), all pods of your application are evicted simultaneously, causing:
- Complete service outage
- Lost transactions
- Angry users
- Failed SLAs

You need to implement PodDisruptionBudgets to ensure minimum availability during disruptions.

### 📋 Requirements

**Core Implementation:**
1. Analyze application availability requirements
2. Create PodDisruptionBudget for critical apps
3. Set minAvailable or maxUnavailable
4. Test with node drain operations
5. Document maintenance procedures
6. Set up monitoring for PDB violations

**Validation Criteria:**
- [ ] PDBs created for critical applications
- [ ] Minimum availability maintained during drains
- [ ] Node drains complete successfully
- [ ] No service outages during maintenance
- [ ] PDB status monitored
- [ ] Procedures documented

### 🎯 Success Criteria

- Service available during maintenance
- Controlled disruption of pods
- Node maintenance without outages
- SLA compliance maintained
- Operational confidence improved

### 💡 Hints

- minAvailable: Minimum pods that must be up
- maxUnavailable: Maximum pods that can be down
- Works only for voluntary disruptions
- Requires multiple replicas
- Test with `kubectl drain`
- Consider for critical workloads only

---

## Task 7.15: Rolling Updates and Rollbacks

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-715-rolling-updates-and-rollbacks)

### 🎬 Real-World Scenario

You need to deploy a new version of your application:
- Zero downtime required
- Gradual rollout to detect issues early
- Ability to rollback if problems occur
- Automated health checks during rollout

You need to configure and execute rolling updates with proper rollback procedures.

### 📋 Requirements

**Core Implementation:**
1. Configure deployment strategy (RollingUpdate)
2. Set maxSurge and maxUnavailable
3. Update deployment with new image version
4. Monitor rollout progress
5. Implement automated rollout pause on errors
6. Execute rollback when needed
7. Document rollout procedures

**Validation Criteria:**
- [ ] Rolling update completes successfully
- [ ] Zero downtime during update
- [ ] Health checks validate new pods
- [ ] Rollback works correctly
- [ ] Rollout history maintained
- [ ] Procedures documented

### 🎯 Success Criteria

- Deployments complete without downtime
- Quick rollback capability
- Automated error detection
- Predictable update process
- User experience unaffected

### 💡 Hints

- maxSurge: Extra pods during update
- maxUnavailable: Pods that can be down
- Use `kubectl rollout status`
- Rollback with `kubectl rollout undo`
- Readiness probes pause rollout on failure
- Consider using Flagger for advanced canary

---

## Task 7.16: Network Policies for Security

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-716-network-policies-for-security)

### 🎬 Real-World Scenario

Your cluster has a security concern:
- All pods can communicate with all other pods
- Database accessible from any pod
- No network segmentation
- Compliance requirements not met

You need to implement NetworkPolicies to:
- Restrict traffic to only what's necessary
- Isolate databases from untrusted pods
- Implement zero-trust networking
- Meet compliance requirements

### 📋 Requirements

**Core Implementation:**
1. Identify required communication paths
2. Create default deny NetworkPolicy
3. Create allow NetworkPolicies for specific traffic
4. Restrict database access to backend only
5. Allow egress to external APIs
6. Test network policies thoroughly
7. Document network security model

**Validation Criteria:**
- [ ] Default deny policy blocks all traffic
- [ ] Explicit allow policies enable required traffic
- [ ] Database only accessible from backend
- [ ] Frontend can reach backend
- [ ] Unauthorized connections blocked
- [ ] Network policies tested

### 🎯 Success Criteria

- Zero-trust network security
- Only necessary communication allowed
- Database isolated from untrusted pods
- Compliance requirements met
- Security posture improved

### 💡 Hints

- Requires CNI plugin support (Calico, Cilium)
- Default deny policy as baseline
- Use podSelector and namespaceSelector
- Ingress and egress rules
- Labels critical for policy matching
- Test with `kubectl exec` and curl

---

## Task 7.17: Troubleshooting Pods and Deployments

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-717-troubleshooting-pods-and-deployments)

### 🎬 Real-World Scenario

You're facing multiple production issues:
- Pods stuck in ImagePullBackOff
- Pods in CrashLoopBackOff
- Pods running but not in service
- Deployments not rolling out
- Container logs showing errors

You need to systematically troubleshoot and resolve these issues.

### 📋 Requirements

**Core Implementation:**
1. Identify common pod failure modes
2. Check pod status and events
3. Examine container logs
4. Debug running containers
5. Verify resource constraints
6. Check network connectivity
7. Document troubleshooting procedures

**Validation Criteria:**
- [ ] ImagePullBackOff resolved
- [ ] CrashLoopBackOff fixed
- [ ] Pods running and ready
- [ ] Deployments progressing
- [ ] Root causes identified
- [ ] Troubleshooting guide created

### 🎯 Success Criteria

- All pods running successfully
- Issues diagnosed and resolved
- Troubleshooting process documented
- Team capable of debugging issues
- Reduced MTTR (Mean Time To Resolve)

### 💡 Hints

- Start with `kubectl get pods`
- Check events: `kubectl describe pod`
- View logs: `kubectl logs`
- Exec into pod: `kubectl exec -it`
- Check resources: `kubectl top`
- Use `kubectl debug` for debugging

---

## Task 7.18: Jobs for One-Time Tasks

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-718-jobs-for-one-time-tasks)

### 🎬 Real-World Scenario

You need to run one-time tasks in Kubernetes:
- Database migration before deployment
- Data import from external source
- One-time data processing
- Initialization tasks

These tasks need to:
- Run to completion
- Retry on failure
- Report success/failure
- Clean up after completion

### 📋 Requirements

**Core Implementation:**
1. Create Job for database migration
2. Configure completions and parallelism
3. Set backoff limit for retries
4. Configure activeDeadlineSeconds
5. Set up success/failure notifications
6. Implement cleanup policy
7. Test job execution

**Validation Criteria:**
- [ ] Job runs to completion
- [ ] Retries on failure (up to limit)
- [ ] Resources cleaned up after success
- [ ] Failure notifications sent
- [ ] Job history maintained
- [ ] Parallelism works correctly

### 🎯 Success Criteria

- Tasks complete successfully
- Failures handled gracefully
- Appropriate retry behavior
- Clean resource management
- Reliable task execution

### 💡 Hints

- Job runs pods until completion
- `completions`: Total successful completions needed
- `parallelism`: Concurrent pods
- `backoffLimit`: Max retries
- Use `restartPolicy: OnFailure` or `Never`
- Consider init containers for prerequisites

---

## Task 7.19: DaemonSets for Node-Level Services

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-719-daemonsets-for-node-level-services)

### 🎬 Real-World Scenario

You need to run specific pods on every node in your cluster:
- Log collection agent on each node
- Monitoring agent on each node
- Storage daemon on each node
- Network proxy on each node

DaemonSet ensures exactly one pod per node (or selected nodes).

### 📋 Requirements

**Core Implementation:**
1. Create DaemonSet for log collection
2. Configure node selector (if needed)
3. Set up volume mounts for host paths
4. Configure privileges (if needed)
5. Implement update strategy
6. Test on multiple nodes
7. Monitor DaemonSet status

**Validation Criteria:**
- [ ] DaemonSet pod on each node
- [ ] Pods have access to node resources
- [ ] Updates roll out to all nodes
- [ ] Node selector working (if used)
- [ ] Logs collected from all nodes
- [ ] DaemonSet status healthy

### 🎯 Success Criteria

- One pod per node automatically
- Node-level services running
- Updates managed automatically
- Node failures handled gracefully
- Comprehensive node coverage

### 💡 Hints

- DaemonSet ensures one pod per node
- Use hostPath volumes for node access
- May need privileged: true
- Update strategy: OnDelete or RollingUpdate
- NodeSelector to target specific nodes
- Common use: logging, monitoring, storage

---

## Task 7.20: Advanced Kubectl Techniques

> 📖 [View Complete Solution](./REAL-WORLD-TASKS-SOLUTIONS.md#task-720-advanced-kubectl-techniques)

### 🎬 Real-World Scenario

You work with Kubernetes daily and need to be more efficient:
- Repeatedly typing long commands
- Waiting for resources to be ready
- Debugging complex issues
- Managing multiple contexts
- Bulk operations on resources

You need to master advanced kubectl techniques to improve productivity.

### 📋 Requirements

**Core Implementation:**
1. Set up kubectl aliases and shortcuts
2. Use custom columns with get command
3. Implement JSONPath queries
4. Use kubectl plugins
5. Work with multiple contexts efficiently
6. Perform bulk operations
7. Create cheat sheet for common tasks

**Validation Criteria:**
- [ ] Aliases configured and working
- [ ] Custom output formats created
- [ ] JSONPath queries mastered
- [ ] Context switching efficient
- [ ] Bulk operations successful
- [ ] Productivity improved measurably

### 🎯 Success Criteria

- Significant time savings
- Fewer typing errors
- Faster troubleshooting
- Better command recall
- Improved daily workflow

### 💡 Hints

- Use `kubectl completion` for bash/zsh
- Set aliases: `alias k=kubectl`
- JSONPath for complex queries
- `kubectl wait` for automation
- `kubectl top` for metrics
- Install krew for plugin management
- Use `stern` for multi-pod logs

---

## 📚 Additional Resources

### Official Documentation
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)

### Tools
- [k9s](https://k9scli.io/) - Terminal UI for Kubernetes
- [Lens](https://k8slens.dev/) - Desktop GUI for Kubernetes
- [stern](https://github.com/stern/stern) - Multi-pod log tailing
- [kubectx/kubens](https://github.com/ahmetb/kubectx) - Context/namespace switching

### Learning Platforms
- [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
- [Play with Kubernetes](https://labs.play-with-k8s.com/)
- [KodeKloud](https://kodekloud.com/courses/kubernetes-for-the-absolute-beginners/)

---

**Note:** For complete step-by-step solutions with YAML manifests and detailed explanations, see [REAL-WORLD-TASKS-SOLUTIONS.md](./REAL-WORLD-TASKS-SOLUTIONS.md).

**Pro Tip:** Start with easier tasks (7.1, 7.4, 7.12, 7.18) and progress to harder ones. Set up a local Kubernetes cluster (Minikube, Kind) for practice.
