# RHDH Custom Scaffolder Action - Template Triggering Workflow

This document explains the workflow of how Template 1 triggers Template 2 using the custom scaffolder action.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      RHDH Frontend (Port 3000)                   │
│                                                                   │
│  User fills form → Clicks "Create" → Review → Execute Template  │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     RHDH Backend (Port 7007)                     │
│                                                                   │
│  ┌────────────────────────────────────────────────────────┐    │
│  │           Template 1: Main Application                  │    │
│  │                                                          │    │
│  │  Step 1: debug:log - Log start                         │    │
│  │  Step 2: fetch:template - Fetch skeleton              │    │
│  │  Step 3: publish:github - Create repo                  │    │
│  │  Step 4: trigger:template ← Custom Action              │    │
│  │         ↓                                               │    │
│  │         └─ Calls Scaffolder API with Template 2 ref    │    │
│  │  Step 5: catalog:register - Register component         │    │
│  └────────────────────────────────────────────────────────┘    │
│                           │                                      │
│                           ▼                                      │
│  ┌────────────────────────────────────────────────────────┐    │
│  │    Custom Action: trigger:template                      │    │
│  │                                                          │    │
│  │  1. Parse template reference (template:default/...)    │    │
│  │  2. Prepare payload with input values                   │    │
│  │  3. Make HTTP POST to /api/scaffolder/v2/tasks         │    │
│  │  4. Return task ID and URL                              │    │
│  └────────────────────────────────────────────────────────┘    │
│                           │                                      │
│                           ▼                                      │
│  ┌────────────────────────────────────────────────────────┐    │
│  │        Template 2: Database Setup                       │    │
│  │                                                          │    │
│  │  Step 1: debug:log - Log database setup start          │    │
│  │  Step 2: fetch:template - Fetch DB skeleton            │    │
│  │  Step 3: publish:github - Create DB repo               │    │
│  │  Step 4: catalog:register - Register DB resource       │    │
│  │  Step 5: debug:log - Log completion                    │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

## Detailed Flow

### 1. User Interaction (Frontend)

```
User → Fills Template 1 Form
     ├─ Application Name: "my-awesome-app"
     ├─ Description: "My awesome application"
     ├─ Enable Database: ✓ (checked)
     └─ Owner: "user:default/developer"
```

### 2. Template 1 Execution (Backend)

```yaml
# Template 1 triggers custom action
- id: trigger-database-setup
  name: Trigger Database Setup Template
  if: ${{ parameters.enableDatabase }}
  action: trigger:template  # ← Custom action
  input:
    templateRef: 'template:default/template2'
    values:
      applicationName: ${{ parameters.name }}
      databaseType: postgresql
      owner: ${{ parameters.owner }}
```

### 3. Custom Action Processing

```typescript
// Custom action handler
async handler(ctx) {
  const { templateRef, values } = ctx.input;
  
  // 1. Construct API endpoint
  const scaffolderApiUrl = 'http://localhost:7007/api/scaffolder/v2/tasks';
  
  // 2. Prepare payload
  const payload = {
    templateRef: 'template:default/template2',
    values: {
      applicationName: 'my-awesome-app',
      databaseType: 'postgresql',
      owner: 'user:default/developer'
    }
  };
  
  // 3. Make API call
  const response = await fetch(scaffolderApiUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
  
  // 4. Return task information
  const result = await response.json();
  ctx.output('taskId', result.id);
  ctx.output('taskUrl', `${backendUrl}/api/scaffolder/v2/tasks/${result.id}`);
}
```

### 4. Template 2 Execution

Template 2 is now triggered asynchronously with the values passed from Template 1:

```yaml
parameters:
  - applicationName: "my-awesome-app"  # From Template 1
  - databaseType: "postgresql"         # From Template 1
  - owner: "user:default/developer"    # From Template 1
```

### 5. Output and Results

```
Template 1 Output:
├─ Repository: https://github.com/your-org/my-awesome-app
├─ Catalog Entity: component:default/my-awesome-app
└─ Database Setup Task: http://localhost:7007/api/scaffolder/v2/tasks/abc123

Template 2 Output (when complete):
├─ Repository: https://github.com/your-org/my-awesome-app-db
└─ Catalog Entity: resource:default/my-awesome-app-db
```

## API Endpoints Used

### Scaffolder Task Creation

```http
POST /api/scaffolder/v2/tasks
Content-Type: application/json

{
  "templateRef": "template:default/template2",
  "values": {
    "applicationName": "my-awesome-app",
    "databaseType": "postgresql",
    "owner": "user:default/developer"
  }
}

Response:
{
  "id": "abc123",
  "status": "processing",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### Task Status Check

```http
GET /api/scaffolder/v2/tasks/abc123

Response:
{
  "id": "abc123",
  "status": "completed",
  "steps": [...],
  "output": {...}
}
```

## File Structure

```
rhdh-local/
├── config/
│   └── app-config.yaml          # RHDH configuration
├── templates/
│   ├── template1/
│   │   ├── template.yaml        # Main application template
│   │   └── skeleton/            # Template files
│   └── template2/
│       ├── template.yaml        # Database setup template
│       └── skeleton/            # DB template files
└── custom-actions/
    └── trigger-template-action/
        └── src/
            ├── index.ts         # Exports
            ├── module.ts        # Backend module registration
            └── triggerTemplate.ts  # Custom action implementation
```

## Key Concepts

### 1. Custom Scaffolder Actions

- Actions are reusable steps in templates
- Defined with TypeScript using `createTemplateAction`
- Registered as backend modules
- Can perform any operation (API calls, file operations, etc.)

### 2. Template References

Format: `kind:namespace/name`
Examples:
- `template:default/template2`
- `component:default/my-app`
- `resource:default/my-database`

### 3. Action Input/Output

```typescript
schema: {
  input: {
    type: 'object',
    properties: {
      templateRef: { type: 'string' },
      values: { type: 'object' }
    }
  },
  output: {
    type: 'object',
    properties: {
      taskId: { type: 'string' },
      taskUrl: { type: 'string' }
    }
  }
}
```

### 4. Conditional Execution

Templates can conditionally trigger other templates:

```yaml
- id: trigger-database-setup
  if: ${{ parameters.enableDatabase }}  # Only run if checkbox is checked
  action: trigger:template
```

## Benefits of This Approach

1. **Modularity**: Separate templates for different concerns
2. **Reusability**: Database template can be used independently or triggered
3. **Flexibility**: Control which templates to trigger based on user input
4. **Traceability**: Each template execution has its own task ID
5. **Asynchronous**: Templates run independently without blocking

## Use Cases

### 1. Infrastructure Provisioning

```
Main App Template → Triggers:
  - Database Template
  - Cache Template
  - Message Queue Template
```

### 2. Multi-Repo Setup

```
Monorepo Template → Triggers:
  - Frontend Repo Template
  - Backend Repo Template
  - Shared Library Template
```

### 3. Environment Setup

```
Project Template → Triggers:
  - Dev Environment Template
  - Staging Environment Template
  - CI/CD Pipeline Template
```

### 4. Compliance and Security

```
Service Template → Triggers:
  - Security Scanning Template
  - Compliance Check Template
  - Documentation Template
```

## Monitoring and Debugging

### Check Task Status

```bash
# Get task details
curl http://localhost:7007/api/scaffolder/v2/tasks/abc123

# Get task events
curl http://localhost:7007/api/scaffolder/v2/tasks/abc123/events
```

### View Logs

```bash
# Container logs
podman logs -f rhdh-local

# Filter for specific template
podman logs rhdh-local | grep "template:default/template2"

# Filter for custom action
podman logs rhdh-local | grep "trigger:template"
```

### Frontend Task Viewer

Navigate to: `http://localhost:3000/create/tasks/<task-id>`

## Troubleshooting

### Common Issues

1. **Template not found**: Check template reference format
2. **API call fails**: Verify backend URL and network connectivity
3. **Values not passed**: Ensure parameter names match between templates
4. **Authentication error**: Add token if using authenticated endpoints

### Debug Mode

Enable debug logging in `app-config.yaml`:

```yaml
backend:
  # ... existing config ...
  
logger:
  level: debug
```

## Next Steps

1. Extend custom action to wait for task completion
2. Add error handling and retry logic
3. Implement parallel template triggering
4. Create template chaining for complex workflows
5. Add conditional logic based on template outputs

## References

- [Backstage Scaffolder Documentation](https://backstage.io/docs/features/software-templates)
- [Creating Custom Actions](https://backstage.io/docs/features/software-templates/writing-custom-actions)
- [RHDH Official Documentation](https://developers.redhat.com/rhdh)
