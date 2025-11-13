# Red Hat Developer Hub (RHDH) Local Development Environment Setup

## 📋 Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Installing RHDH with Podman](#installing-rhdh-with-podman)
4. [Basic Configuration](#basic-configuration)
5. [Creating Custom Scaffolder Actions](#creating-custom-scaffolder-actions)
6. [Template-Triggering Action Implementation](#template-triggering-action-implementation)
7. [Registration and Usage](#registration-and-usage)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Additional Resources](#additional-resources)

---

## Overview

Red Hat Developer Hub (RHDH) is Red Hat's enterprise-ready distribution of Backstage, the open-source developer portal platform. This guide provides comprehensive instructions for setting up a local RHDH development environment using Podman and creating custom scaffolder actions to extend RHDH's capabilities.

### What You'll Learn

- Set up RHDH locally using Podman
- Configure RHDH for local development
- Create custom scaffolder actions
- Implement a template-triggering action
- Register and use custom actions in templates

---

## Prerequisites

### Required Software

Before starting, ensure you have the following installed:

1. **Podman** (already installed as per requirements)
   ```bash
   # Verify Podman installation
   podman --version
   # Should show version 4.0 or later
   ```

2. **Node.js and npm**
   ```bash
   # Install Node.js 18.x or later
   # For RHEL/Fedora:
   sudo dnf install nodejs npm -y
   
   # For Ubuntu/Debian:
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   
   # Verify installation
   node --version  # Should be v18.x or later
   npm --version   # Should be 9.x or later
   ```

3. **Git**
   ```bash
   # Install git if not present
   sudo dnf install git -y  # RHEL/Fedora
   # or
   sudo apt-get install git -y  # Ubuntu/Debian
   
   # Verify installation
   git --version
   ```

4. **Yarn (optional but recommended)**
   ```bash
   npm install -g yarn
   yarn --version
   ```

### System Requirements

- **OS**: Linux (RHEL 8+, Fedora 35+, Ubuntu 20.04+, or similar)
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: At least 10GB free space
- **CPU**: 2+ cores recommended
- **Network**: Internet connectivity for downloading container images

### Required Ports

Ensure the following ports are available:
- **7007**: RHDH backend API
- **3000**: RHDH frontend (development mode)

---

## Installing RHDH with Podman

### Step 1: Pull the RHDH Container Image

Red Hat provides official RHDH container images. You'll need access to Red Hat registries.

```bash
# Login to Red Hat Container Registry
# You'll need a Red Hat account with RHDH access
podman login registry.redhat.io

# Pull the latest RHDH image
podman pull registry.redhat.io/rhdh/rhdh-hub-rhel9:latest

# Verify the image
podman images | grep rhdh
```

**Note**: If you don't have access to Red Hat registries, you can use the upstream Backstage image for development:

```bash
# Alternative: Use upstream Backstage (for development/testing)
podman pull quay.io/backstage/backstage:latest
```

### Step 2: Create Required Directories

Set up the local directory structure for RHDH configuration and data:

```bash
# Create base directory for RHDH
mkdir -p ~/rhdh-local
cd ~/rhdh-local

# Create directory structure
mkdir -p {config,plugins,data,logs,custom-actions}

# Create initial configuration files
touch config/app-config.yaml
touch config/app-config.local.yaml
```

### Step 3: Create Basic Configuration

Create the basic `app-config.yaml` file:

```bash
cat > config/app-config.yaml << 'EOF'
app:
  title: Red Hat Developer Hub
  baseUrl: http://localhost:3000

organization:
  name: My Organization

backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
    host: 0.0.0.0
  
  # CORS configuration
  cors:
    origin: http://localhost:3000
    methods: [GET, HEAD, PATCH, POST, PUT, DELETE]
    credentials: true
  
  # Database configuration (SQLite for local development)
  database:
    client: better-sqlite3
    connection: ':memory:'

# Basic authentication (for local development)
auth:
  environment: development
  providers:
    guest:
      dangerouslyAllowOutsideDevelopment: true

# Catalog configuration
catalog:
  import:
    entityFilename: catalog-info.yaml
  rules:
    - allow: [Component, System, API, Resource, Location, Template]
  
  locations:
    # Local templates directory
    - type: file
      target: /templates/template-catalog.yaml
      rules:
        - allow: [Template]

# Scaffolder configuration
scaffolder:
  defaultAuthor:
    name: Developer Hub
    email: devhub@example.com
  defaultCommitMessage: 'Initial commit from Developer Hub'

# Tech Radar (optional)
techdocs:
  builder: 'local'
  generator:
    runIn: 'local'
  publisher:
    type: 'local'
EOF
```

### Step 4: Create Templates Directory

```bash
# Create templates directory structure
mkdir -p ~/rhdh-local/templates
cd ~/rhdh-local/templates

# Create a catalog file for templates
cat > template-catalog.yaml << 'EOF'
apiVersion: backstage.io/v1alpha1
kind: Location
metadata:
  name: local-templates
  description: Local template definitions
spec:
  type: file
  targets:
    - ./template1/template.yaml
    - ./template2/template.yaml
EOF
```

### Step 5: Run RHDH with Podman

Create a script to run RHDH easily:

```bash
cat > ~/rhdh-local/start-rhdh.sh << 'EOF'
#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Red Hat Developer Hub with Podman...${NC}"

# Set variables
CONTAINER_NAME="rhdh-local"
IMAGE_NAME="registry.redhat.io/rhdh/rhdh-hub-rhel9:latest"
# Alternative for development/testing:
# IMAGE_NAME="quay.io/backstage/backstage:latest"

# Stop and remove existing container if running
if podman ps -a | grep -q $CONTAINER_NAME; then
    echo -e "${YELLOW}Stopping existing container...${NC}"
    podman stop $CONTAINER_NAME
    podman rm $CONTAINER_NAME
fi

# Run RHDH container
echo -e "${GREEN}Starting RHDH container...${NC}"
podman run -d \
  --name $CONTAINER_NAME \
  -p 3000:3000 \
  -p 7007:7007 \
  -v $(pwd)/config:/opt/app-root/src/app-config:Z \
  -v $(pwd)/templates:/templates:Z \
  -v $(pwd)/custom-actions:/custom-actions:Z \
  -v $(pwd)/data:/data:Z \
  -v $(pwd)/logs:/logs:Z \
  -e APP_CONFIG_backend_database_connection_filename=/data/backstage.db \
  $IMAGE_NAME

# Wait for container to start
echo -e "${YELLOW}Waiting for RHDH to start...${NC}"
sleep 10

# Check if container is running
if podman ps | grep -q $CONTAINER_NAME; then
    echo -e "${GREEN}✓ RHDH is running!${NC}"
    echo ""
    echo -e "Access RHDH at: ${GREEN}http://localhost:3000${NC}"
    echo -e "Backend API at: ${GREEN}http://localhost:7007${NC}"
    echo ""
    echo "To view logs: podman logs -f $CONTAINER_NAME"
    echo "To stop: podman stop $CONTAINER_NAME"
else
    echo -e "${RED}✗ Failed to start RHDH${NC}"
    echo "Check logs with: podman logs $CONTAINER_NAME"
    exit 1
fi
EOF

chmod +x ~/rhdh-local/start-rhdh.sh
```

### Step 6: Start RHDH

```bash
cd ~/rhdh-local
./start-rhdh.sh
```

### Step 7: Verify Installation

```bash
# Check container status
podman ps | grep rhdh

# Check logs
podman logs rhdh-local

# Test backend API
curl http://localhost:7007/api/catalog/entities

# Open browser to frontend
# Navigate to http://localhost:3000
```

---

## Basic Configuration

### Configure GitHub Integration (Optional)

To enable GitHub integration for templates:

1. Create a GitHub Personal Access Token:
   - Go to GitHub → Settings → Developer settings → Personal access tokens
   - Generate new token with `repo` and `workflow` scopes

2. Update `app-config.yaml`:

```yaml
integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}
```

3. Set environment variable:

```bash
export GITHUB_TOKEN="your-github-token-here"
```

### Configure Authentication (Production)

For production, configure proper authentication:

```yaml
auth:
  environment: production
  providers:
    github:
      development:
        clientId: ${GITHUB_CLIENT_ID}
        clientSecret: ${GITHUB_CLIENT_SECRET}
```

---

## Creating Custom Scaffolder Actions

Custom scaffolder actions allow you to extend RHDH's template capabilities with custom logic, API calls, or integrations.

### Understanding Scaffolder Actions

Scaffolder actions are the building blocks of templates in RHDH/Backstage. They define operations that can be performed during template scaffolding, such as:
- Creating files
- Making API calls
- Triggering other processes
- Integrating with external systems

### Project Structure for Custom Actions

```bash
cd ~/rhdh-local/custom-actions
mkdir -p trigger-template-action
cd trigger-template-action

# Create package.json
cat > package.json << 'EOF'
{
  "name": "@internal/backstage-plugin-scaffolder-backend-module-trigger-template",
  "version": "1.0.0",
  "description": "Custom scaffolder action to trigger another template",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "license": "Apache-2.0",
  "private": true,
  "scripts": {
    "build": "tsc",
    "watch": "tsc --watch",
    "clean": "rm -rf dist"
  },
  "dependencies": {
    "@backstage/plugin-scaffolder-node": "^0.4.0",
    "@backstage/backend-plugin-api": "^0.6.0",
    "@backstage/catalog-client": "^1.6.0",
    "@backstage/catalog-model": "^1.4.0",
    "@backstage/errors": "^1.2.0",
    "node-fetch": "^2.7.0"
  },
  "devDependencies": {
    "@types/node": "^18.0.0",
    "typescript": "^5.0.0"
  }
}
EOF

# Create TypeScript configuration
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2021",
    "module": "commonjs",
    "lib": ["ES2021"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
```

---

## Template-Triggering Action Implementation

Now, let's create the custom action that allows triggering another template from within a running template.

### Step 1: Create the Action Implementation

```bash
mkdir -p src
cat > src/triggerTemplate.ts << 'EOF'
import { createTemplateAction } from '@backstage/plugin-scaffolder-node';
import { CatalogClient } from '@backstage/catalog-client';
import fetch from 'node-fetch';

/**
 * Custom scaffolder action to trigger another template
 * This allows Template 1 to trigger Template 2 during execution
 */
export const createTriggerTemplateAction = () => {
  return createTemplateAction<{
    templateRef: string;
    values: Record<string, any>;
    token?: string;
  }>({
    id: 'trigger:template',
    description: 'Triggers another Backstage template with provided values',
    schema: {
      input: {
        type: 'object',
        required: ['templateRef', 'values'],
        properties: {
          templateRef: {
            type: 'string',
            title: 'Template Reference',
            description: 'The entity reference of the template to trigger (e.g., template:default/my-template)',
          },
          values: {
            type: 'object',
            title: 'Template Values',
            description: 'Input values to pass to the triggered template',
          },
          token: {
            type: 'string',
            title: 'Authentication Token',
            description: 'Optional authentication token for API calls',
          },
        },
      },
      output: {
        type: 'object',
        properties: {
          taskId: {
            type: 'string',
            title: 'Task ID',
            description: 'The ID of the triggered scaffolder task',
          },
          taskUrl: {
            type: 'string',
            title: 'Task URL',
            description: 'URL to monitor the triggered task',
          },
        },
      },
    },
    
    async handler(ctx) {
      const { templateRef, values, token } = ctx.input;
      
      ctx.logger.info(`Triggering template: ${templateRef}`);
      ctx.logger.info(`Input values: ${JSON.stringify(values, null, 2)}`);
      
      try {
        // Get the backend URL from config
        const backendUrl = ctx.secrets?.backendUrl || 'http://localhost:7007';
        
        // Parse template reference
        const [kind, namespace, name] = templateRef.split(/[:/]/);
        
        // Construct the scaffolder API endpoint
        const scaffolderApiUrl = `${backendUrl}/api/scaffolder/v2/tasks`;
        
        // Prepare the request payload
        const payload = {
          templateRef: templateRef,
          values: values,
        };
        
        ctx.logger.info(`Calling scaffolder API: ${scaffolderApiUrl}`);
        
        // Make API call to trigger the template
        const headers: Record<string, string> = {
          'Content-Type': 'application/json',
        };
        
        if (token) {
          headers['Authorization'] = `Bearer ${token}`;
        }
        
        const response = await fetch(scaffolderApiUrl, {
          method: 'POST',
          headers: headers,
          body: JSON.stringify(payload),
        });
        
        if (!response.ok) {
          const errorText = await response.text();
          throw new Error(
            `Failed to trigger template: ${response.status} ${response.statusText} - ${errorText}`
          );
        }
        
        const result = await response.json();
        const taskId = result.id;
        const taskUrl = `${backendUrl}/api/scaffolder/v2/tasks/${taskId}`;
        
        ctx.logger.info(`Template triggered successfully! Task ID: ${taskId}`);
        ctx.logger.info(`Task URL: ${taskUrl}`);
        
        // Output the task information
        ctx.output('taskId', taskId);
        ctx.output('taskUrl', taskUrl);
        
        // Optionally wait for task completion
        // This is commented out to avoid blocking, but can be enabled if needed
        /*
        await waitForTaskCompletion(taskUrl, token, ctx.logger);
        */
        
      } catch (error) {
        ctx.logger.error(`Error triggering template: ${error}`);
        throw error;
      }
    },
  });
};

/**
 * Helper function to wait for task completion (optional)
 */
async function waitForTaskCompletion(
  taskUrl: string,
  token: string | undefined,
  logger: any,
  maxWaitTime: number = 300000, // 5 minutes
  pollInterval: number = 5000    // 5 seconds
): Promise<void> {
  const startTime = Date.now();
  
  while (Date.now() - startTime < maxWaitTime) {
    const headers: Record<string, string> = {};
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    
    const response = await fetch(taskUrl, { headers });
    
    if (!response.ok) {
      throw new Error(`Failed to check task status: ${response.statusText}`);
    }
    
    const taskData = await response.json();
    const status = taskData.status;
    
    logger.info(`Task status: ${status}`);
    
    if (status === 'completed') {
      logger.info('Task completed successfully!');
      return;
    } else if (status === 'failed') {
      throw new Error('Triggered task failed');
    }
    
    // Wait before next poll
    await new Promise(resolve => setTimeout(resolve, pollInterval));
  }
  
  throw new Error('Task did not complete within the maximum wait time');
}
EOF
```

### Step 2: Create Module Export

```bash
cat > src/module.ts << 'EOF'
import { createBackendModule } from '@backstage/backend-plugin-api';
import { scaffolderActionsExtensionPoint } from '@backstage/plugin-scaffolder-node';
import { createTriggerTemplateAction } from './triggerTemplate';

/**
 * Backend module for the custom trigger-template scaffolder action
 */
export const scaffolderModuleTriggerTemplate = createBackendModule({
  pluginId: 'scaffolder',
  moduleId: 'trigger-template',
  register(env) {
    env.registerInit({
      deps: {
        scaffolder: scaffolderActionsExtensionPoint,
      },
      async init({ scaffolder }) {
        // Register the custom action
        scaffolder.addActions(createTriggerTemplateAction());
      },
    });
  },
});
EOF
```

### Step 3: Create Index Export

```bash
cat > src/index.ts << 'EOF'
/**
 * Custom scaffolder action for triggering templates
 * @packageDocumentation
 */

export { scaffolderModuleTriggerTemplate } from './module';
export { createTriggerTemplateAction } from './triggerTemplate';
EOF
```

### Step 4: Build the Custom Action

```bash
cd ~/rhdh-local/custom-actions/trigger-template-action

# Install dependencies
npm install

# Build the TypeScript code
npm run build
```

---

## Registration and Usage

### Step 1: Register the Custom Action in RHDH

To use the custom action, you need to register it in your RHDH backend.

Create a backend plugin integration:

```bash
cd ~/rhdh-local/custom-actions
cat > plugin-integration.ts << 'EOF'
/**
 * This file shows how to integrate the custom action into your RHDH backend
 */

import { createBackend } from '@backstage/backend-defaults';
import { scaffolderModuleTriggerTemplate } from './trigger-template-action/src/module';

const backend = createBackend();

// Add existing plugins
backend.add(import('@backstage/plugin-app-backend/alpha'));
backend.add(import('@backstage/plugin-catalog-backend/alpha'));
backend.add(import('@backstage/plugin-scaffolder-backend/alpha'));

// Add the custom trigger-template action module
backend.add(scaffolderModuleTriggerTemplate);

backend.start();
EOF
```

**For existing RHDH installations**, add to your `packages/backend/src/index.ts`:

```typescript
import { scaffolderModuleTriggerTemplate } from '@internal/backstage-plugin-scaffolder-backend-module-trigger-template';

// ... existing code ...

backend.add(scaffolderModuleTriggerTemplate);
```

### Step 2: Create Template 1 (Triggers Template 2)

```bash
cd ~/rhdh-local/templates
mkdir -p template1
cat > template1/template.yaml << 'EOF'
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: template1
  title: Main Application Template
  description: A template that creates an application and triggers additional setup
  tags:
    - nodejs
    - react
spec:
  owner: group:development
  type: service
  
  parameters:
    - title: Application Information
      required:
        - name
        - description
      properties:
        name:
          title: Name
          type: string
          description: Unique name for the application
          ui:autofocus: true
          ui:options:
            rows: 1
        description:
          title: Description
          type: string
          description: A short description of the application
        enableDatabase:
          title: Enable Database Setup
          type: boolean
          description: Trigger database setup template
          default: true
        owner:
          title: Owner
          type: string
          description: Owner of the component
          ui:field: OwnerPicker
          ui:options:
            catalogFilter:
              kind: [Group, User]
  
  steps:
    - id: log-start
      name: Log Start
      action: debug:log
      input:
        message: 'Starting template execution for: ${{ parameters.name }}'
    
    - id: fetch-base
      name: Fetch Base Template
      action: fetch:template
      input:
        url: ./skeleton
        values:
          name: ${{ parameters.name }}
          description: ${{ parameters.description }}
          owner: ${{ parameters.owner }}
    
    - id: create-repo
      name: Create Repository
      action: publish:github
      input:
        allowedHosts: ['github.com']
        description: ${{ parameters.description }}
        repoUrl: github.com?owner=your-org&repo=${{ parameters.name }}
        repoVisibility: private
    
    # Custom action: Trigger Template 2 if database is enabled
    - id: trigger-database-setup
      name: Trigger Database Setup Template
      if: ${{ parameters.enableDatabase }}
      action: trigger:template
      input:
        templateRef: 'template:default/template2'
        values:
          applicationName: ${{ parameters.name }}
          databaseType: postgresql
          owner: ${{ parameters.owner }}
    
    - id: register
      name: Register Component
      action: catalog:register
      input:
        repoContentsUrl: ${{ steps['create-repo'].output.repoContentsUrl }}
        catalogInfoPath: '/catalog-info.yaml'
  
  output:
    links:
      - title: Repository
        url: ${{ steps['create-repo'].output.remoteUrl }}
      - title: Open in catalog
        icon: catalog
        entityRef: ${{ steps['register'].output.entityRef }}
      - title: Database Setup Task
        url: ${{ steps['trigger-database-setup'].output.taskUrl }}
        icon: dashboard
EOF

# Create skeleton directory
mkdir -p template1/skeleton
cat > template1/skeleton/catalog-info.yaml << 'EOF'
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: ${{ values.name }}
  description: ${{ values.description }}
  annotations:
    github.com/project-slug: your-org/${{ values.name }}
spec:
  type: service
  lifecycle: production
  owner: ${{ values.owner }}
EOF

cat > template1/skeleton/README.md << 'EOF'
# ${{ values.name }}

${{ values.description }}

## Owner
${{ values.owner }}
EOF
```

### Step 3: Create Template 2 (Database Setup)

```bash
mkdir -p template2
cat > template2/template.yaml << 'EOF'
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: template2
  title: Database Setup Template
  description: Sets up database infrastructure for an application
  tags:
    - database
    - infrastructure
spec:
  owner: group:infrastructure
  type: infrastructure
  
  parameters:
    - title: Database Configuration
      required:
        - applicationName
        - databaseType
      properties:
        applicationName:
          title: Application Name
          type: string
          description: Name of the application this database supports
        databaseType:
          title: Database Type
          type: string
          description: Type of database to provision
          enum:
            - postgresql
            - mysql
            - mongodb
          default: postgresql
        owner:
          title: Owner
          type: string
          description: Owner of the database resource
          ui:field: OwnerPicker
          ui:options:
            catalogFilter:
              kind: [Group, User]
  
  steps:
    - id: log-start
      name: Log Database Setup Start
      action: debug:log
      input:
        message: 'Setting up ${{ parameters.databaseType }} database for: ${{ parameters.applicationName }}'
    
    - id: fetch-base
      name: Fetch Database Template
      action: fetch:template
      input:
        url: ./skeleton
        values:
          applicationName: ${{ parameters.applicationName }}
          databaseType: ${{ parameters.databaseType }}
          owner: ${{ parameters.owner }}
    
    - id: create-db-repo
      name: Create Database Configuration Repository
      action: publish:github
      input:
        allowedHosts: ['github.com']
        description: 'Database configuration for ${{ parameters.applicationName }}'
        repoUrl: github.com?owner=your-org&repo=${{ parameters.applicationName }}-db
        repoVisibility: private
    
    - id: register-resource
      name: Register Database Resource
      action: catalog:register
      input:
        repoContentsUrl: ${{ steps['create-db-repo'].output.repoContentsUrl }}
        catalogInfoPath: '/catalog-info.yaml'
    
    - id: log-complete
      name: Log Completion
      action: debug:log
      input:
        message: 'Database setup completed for: ${{ parameters.applicationName }}'
  
  output:
    links:
      - title: Database Repository
        url: ${{ steps['create-db-repo'].output.remoteUrl }}
      - title: Open in catalog
        icon: catalog
        entityRef: ${{ steps['register-resource'].output.entityRef }}
EOF

mkdir -p template2/skeleton
cat > template2/skeleton/catalog-info.yaml << 'EOF'
apiVersion: backstage.io/v1alpha1
kind: Resource
metadata:
  name: ${{ values.applicationName }}-db
  description: ${{ values.databaseType }} database for ${{ values.applicationName }}
spec:
  type: database
  owner: ${{ values.owner }}
  system: ${{ values.applicationName }}
  lifecycle: production
EOF

cat > template2/skeleton/README.md << 'EOF'
# Database Configuration for ${{ values.applicationName }}

## Database Type
${{ values.databaseType }}

## Configuration Files
- `docker-compose.yml`: Local development setup
- `kubernetes/`: Kubernetes manifests for production

## Owner
${{ values.owner }}
EOF

cat > template2/skeleton/docker-compose.yml << 'EOF'
version: '3.8'

services:
  database:
    image: {%- if values.databaseType == 'postgresql' %}postgres:15{% elif values.databaseType == 'mysql' %}mysql:8.0{% else %}mongo:6.0{% endif %}
    container_name: ${{ values.applicationName }}-db
    environment:
      {%- if values.databaseType == 'postgresql' %}
      POSTGRES_DB: ${{ values.applicationName }}
      POSTGRES_USER: dbuser
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      {%- elif values.databaseType == 'mysql' %}
      MYSQL_DATABASE: ${{ values.applicationName }}
      MYSQL_USER: dbuser
      MYSQL_PASSWORD: ${DB_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      {%- else %}
      MONGO_INITDB_ROOT_USERNAME: dbuser
      MONGO_INITDB_ROOT_PASSWORD: ${DB_PASSWORD}
      MONGO_INITDB_DATABASE: ${{ values.applicationName }}
      {%- endif %}
    ports:
      - "{%- if values.databaseType == 'postgresql' %}5432:5432{% elif values.databaseType == 'mysql' %}3306:3306{% else %}27017:27017{% endif %}"
    volumes:
      - db-data:/var/lib/{%- if values.databaseType == 'mongodb' %}mongodb{% else %}{{ values.databaseType }}{% endif %}/data
    networks:
      - app-network

volumes:
  db-data:

networks:
  app-network:
    driver: bridge
EOF
```

### Step 4: Using the Templates

1. **Access RHDH Frontend**:
   ```
   http://localhost:3000
   ```

2. **Navigate to Create Component**:
   - Click on "Create" in the sidebar
   - You should see "Main Application Template" (Template 1)

3. **Fill in Template 1 Form**:
   - Name: `my-awesome-app`
   - Description: `My awesome application`
   - Enable Database Setup: `true` (checked)
   - Owner: Select an owner

4. **Execute Template**:
   - Click "Review"
   - Click "Create"
   - Watch as Template 1 executes and triggers Template 2

5. **Monitor Execution**:
   - Template 1 will create the main application repository
   - The custom action `trigger:template` will be executed
   - Template 2 will be triggered automatically
   - You'll see a link to the Database Setup Task in the output

---

## Troubleshooting

### Common Issues and Solutions

#### 1. Container Won't Start

**Problem**: RHDH container fails to start or exits immediately.

**Solution**:
```bash
# Check container logs
podman logs rhdh-local

# Check for port conflicts
sudo netstat -tulpn | grep -E ':(3000|7007)'

# If ports are in use, stop conflicting services or change RHDH ports
```

#### 2. Cannot Access Frontend

**Problem**: Cannot access http://localhost:3000

**Solution**:
```bash
# Verify container is running
podman ps | grep rhdh

# Check if port is mapped correctly
podman port rhdh-local

# Try accessing backend directly
curl http://localhost:7007/api/catalog/entities

# Check firewall rules
sudo firewall-cmd --list-ports
sudo firewall-cmd --add-port=3000/tcp --permanent
sudo firewall-cmd --add-port=7007/tcp --permanent
sudo firewall-cmd --reload
```

#### 3. Custom Action Not Recognized

**Problem**: Custom action `trigger:template` is not found.

**Solution**:
```bash
# Verify the action is built
cd ~/rhdh-local/custom-actions/trigger-template-action
ls -la dist/

# Rebuild if necessary
npm run clean && npm run build

# Check RHDH logs for registration errors
podman logs rhdh-local | grep -i "trigger"

# Verify the module is registered in backend
```

#### 4. Template 2 Not Triggering

**Problem**: Template 2 doesn't get triggered from Template 1.

**Solution**:
```bash
# Check the template reference is correct
# It should match the template name in catalog: template:default/template2

# Verify Template 2 is registered in catalog
curl http://localhost:7007/api/catalog/entities/by-name/template/default/template2

# Check scaffolder task logs
podman logs rhdh-local | grep -i "trigger"

# Verify backend API is accessible
curl -X POST http://localhost:7007/api/scaffolder/v2/tasks \
  -H "Content-Type: application/json" \
  -d '{"templateRef":"template:default/template2","values":{"applicationName":"test"}}'
```

#### 5. Authentication Issues

**Problem**: GitHub authentication fails or tokens not working.

**Solution**:
```bash
# Verify GitHub token is set
echo $GITHUB_TOKEN

# Test token validity
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

# Update token in config if needed
# Edit config/app-config.yaml and restart container
```

#### 6. Database Connection Issues

**Problem**: SQLite database errors or data not persisting.

**Solution**:
```bash
# Check data directory permissions
ls -la ~/rhdh-local/data/

# Ensure volume is mounted correctly
podman inspect rhdh-local | grep -A 10 Mounts

# Use PostgreSQL for production instead of SQLite
# Update app-config.yaml with PostgreSQL connection details
```

#### 7. Volume Permission Issues

**Problem**: Permission denied errors when accessing mounted volumes.

**Solution**:
```bash
# SELinux context issues - add :Z flag to volumes
# This is already in the start-rhdh.sh script

# If still having issues, try:
sudo chcon -Rt svirt_sandbox_file_t ~/rhdh-local/

# Or run with --privileged flag (not recommended for production)
podman run --privileged ...
```

### Debugging Tips

1. **Enable Debug Logging**:
   ```yaml
   # Add to app-config.yaml
   backend:
     baseUrl: http://localhost:7007
     database:
       client: better-sqlite3
       connection: ':memory:'
     
   # Enable debug logging
   app:
     baseUrl: http://localhost:3000
   
   # Add logging configuration
   backend:
     listen:
       port: 7007
     
   # Set log level
   logger:
     level: debug
   ```

2. **Inspect Running Container**:
   ```bash
   # Execute commands inside container
   podman exec -it rhdh-local /bin/bash
   
   # Check internal processes
   podman exec rhdh-local ps aux
   
   # View internal logs
   podman exec rhdh-local cat /logs/backstage.log
   ```

3. **Test Custom Action Independently**:
   ```typescript
   // Create a test script
   import { createTriggerTemplateAction } from './triggerTemplate';
   
   const action = createTriggerTemplateAction();
   console.log('Action ID:', action.id);
   console.log('Action Schema:', JSON.stringify(action.schema, null, 2));
   ```

4. **Monitor Network Traffic**:
   ```bash
   # Monitor API calls
   podman exec rhdh-local tcpdump -i any port 7007 -n
   ```

---

## Best Practices

### 1. Configuration Management

- **Use Environment Variables**: Store sensitive data in environment variables
  ```yaml
  integrations:
    github:
      - host: github.com
        token: ${GITHUB_TOKEN}
  ```

- **Separate Configurations**: Use different config files for different environments
  ```bash
  app-config.yaml           # Base configuration
  app-config.local.yaml     # Local overrides
  app-config.production.yaml # Production settings
  ```

### 2. Template Design

- **Keep Templates Modular**: Create small, focused templates that do one thing well
- **Use Parameters Wisely**: Provide sensible defaults and clear descriptions
- **Validate Inputs**: Add validation rules to template parameters
  ```yaml
  parameters:
    - title: Configuration
      properties:
        name:
          type: string
          pattern: '^[a-z0-9-]+$'
          minLength: 3
          maxLength: 63
  ```

### 3. Custom Actions

- **Error Handling**: Always handle errors gracefully
  ```typescript
  try {
    // Action logic
  } catch (error) {
    ctx.logger.error(`Error: ${error.message}`);
    throw new Error(`Action failed: ${error.message}`);
  }
  ```

- **Logging**: Use structured logging
  ```typescript
  ctx.logger.info('Starting action', { templateRef, values });
  ```

- **Output**: Always provide useful output
  ```typescript
  ctx.output('taskId', taskId);
  ctx.output('taskUrl', taskUrl);
  ```

### 4. Security

- **Token Management**: Never hardcode tokens
- **Least Privilege**: Use minimal required permissions
- **Input Validation**: Validate all user inputs
- **Audit Logging**: Log all template executions

### 5. Performance

- **Async Operations**: Use async/await properly
- **Connection Pooling**: Reuse HTTP connections
- **Caching**: Cache frequently accessed data
- **Resource Limits**: Set appropriate container resource limits

### 6. Maintenance

- **Version Control**: Keep templates in Git
- **Documentation**: Document all custom actions
- **Testing**: Test templates before deploying
- **Monitoring**: Monitor template execution metrics

---

## Additional Resources

### Official Documentation

- [Red Hat Developer Hub Documentation](https://developers.redhat.com/rhdh)
- [Backstage Official Docs](https://backstage.io/docs)
- [Scaffolder Documentation](https://backstage.io/docs/features/software-templates)
- [Creating Custom Actions](https://backstage.io/docs/features/software-templates/writing-custom-actions)

### Example Repositories

- [Backstage GitHub Repository](https://github.com/backstage/backstage)
- [Backstage Community Plugins](https://github.com/backstage/community-plugins)
- [Template Examples](https://github.com/backstage/software-templates)

### Community Resources

- [Backstage Discord Community](https://discord.gg/backstage)
- [RHDH Community](https://developers.redhat.com/rhdh/community)
- [Backstage Community Hub](https://backstage.io/community)

### Learning Materials

- [Backstage Getting Started Guide](https://backstage.io/docs/getting-started)
- [Software Templates Tutorial](https://backstage.io/docs/features/software-templates/tutorial)
- [Plugin Development](https://backstage.io/docs/plugins)

### Tools and Utilities

- **Podman Documentation**: https://docs.podman.io/
- **TypeScript Documentation**: https://www.typescriptlang.org/docs/
- **Node.js Documentation**: https://nodejs.org/docs/

### Advanced Topics

1. **Custom Plugins Development**
   - Creating custom frontend plugins
   - Backend plugin architecture
   - Plugin communication patterns

2. **Integration Patterns**
   - GitHub Apps integration
   - GitLab integration
   - Azure DevOps integration
   - Jenkins integration

3. **Production Deployment**
   - Kubernetes deployment
   - High availability setup
   - Disaster recovery
   - Monitoring and alerting

4. **Authentication & Authorization**
   - OAuth integration
   - RBAC implementation
   - Permission policies
   - External identity providers

---

## Summary

You now have a complete local Red Hat Developer Hub development environment with:

✅ RHDH running in Podman
✅ Basic configuration for local development  
✅ Custom scaffolder action for triggering templates
✅ Template 1 that can trigger Template 2
✅ Complete file structure and code examples
✅ Troubleshooting guide
✅ Best practices and resources

### Next Steps

1. **Explore Templates**: Create more templates for your specific needs
2. **Develop Custom Actions**: Build actions for your organization's workflows
3. **Integrate Services**: Connect to GitHub, GitLab, Jenkins, etc.
4. **Deploy to Production**: Move to a production-ready setup
5. **Customize UI**: Brand RHDH with your organization's theme
6. **Add Plugins**: Extend functionality with community plugins

### Quick Reference Commands

```bash
# Start RHDH
cd ~/rhdh-local && ./start-rhdh.sh

# Stop RHDH
podman stop rhdh-local

# View logs
podman logs -f rhdh-local

# Restart RHDH
podman restart rhdh-local

# Access container
podman exec -it rhdh-local /bin/bash

# Rebuild custom action
cd ~/rhdh-local/custom-actions/trigger-template-action
npm run clean && npm run build

# Check catalog entities
curl http://localhost:7007/api/catalog/entities
```

---

**Happy Building! 🚀**

For questions or issues, refer to the official documentation or community resources listed above.
