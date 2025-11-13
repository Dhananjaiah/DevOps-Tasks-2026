# RHDH Examples Directory

This directory contains example files and templates for Red Hat Developer Hub.

## Contents

1. **custom-action/** - Custom scaffolder action example (trigger-template)
2. **templates/** - Example templates (Template 1 and Template 2)
3. **config/** - Configuration file examples
4. **scripts/** - Helper scripts

## Quick Links

- [Main RHDH Setup Guide](../RHDH-SETUP-GUIDE.md)
- [Quick Start Guide](../RHDH-QUICK-START.md)

## How to Use These Examples

### 1. Custom Action

Copy the custom action to your RHDH instance:

```bash
cp -r custom-action ~/rhdh-local/custom-actions/trigger-template-action
cd ~/rhdh-local/custom-actions/trigger-template-action
npm install
npm run build
```

### 2. Templates

Copy templates to your RHDH templates directory:

```bash
cp -r templates/* ~/rhdh-local/templates/
```

### 3. Configuration

Use configuration examples as reference:

```bash
# View examples
cat config/app-config.example.yaml

# Customize for your needs
cp config/app-config.example.yaml ~/rhdh-local/config/app-config.yaml
# Edit the file to suit your environment
```

### 4. Scripts

Use helper scripts to manage your RHDH instance:

```bash
# Copy scripts
cp scripts/* ~/rhdh-local/

# Make executable
chmod +x ~/rhdh-local/*.sh

# Use them
~/rhdh-local/start-rhdh.sh
```

## Example Workflow

1. Set up RHDH following the Quick Start guide
2. Copy custom action and build it
3. Copy templates to RHDH
4. Access RHDH at http://localhost:3000
5. Create a component using Template 1
6. Watch as it automatically triggers Template 2

## File Structure

```
rhdh-examples/
├── README.md (this file)
├── custom-action/
│   └── trigger-template-action/
│       ├── package.json
│       ├── tsconfig.json
│       └── src/
│           ├── index.ts
│           ├── module.ts
│           └── triggerTemplate.ts
├── templates/
│   ├── template1/
│   │   ├── template.yaml
│   │   └── skeleton/
│   │       ├── catalog-info.yaml
│   │       └── README.md
│   └── template2/
│       ├── template.yaml
│       └── skeleton/
│           ├── catalog-info.yaml
│           ├── README.md
│           └── docker-compose.yml
├── config/
│   ├── app-config.example.yaml
│   └── app-config.production.yaml
└── scripts/
    ├── start-rhdh.sh
    ├── stop-rhdh.sh
    └── rebuild-action.sh
```

## Testing

After setting up, test the workflow:

```bash
# 1. Verify RHDH is running
curl http://localhost:7007/api/catalog/entities

# 2. Check templates are loaded
curl http://localhost:7007/api/catalog/entities?filter=kind=template

# 3. Access the UI
open http://localhost:3000
```

## Customization

Feel free to customize these examples for your needs:

- **Custom Action**: Modify `triggerTemplate.ts` to add additional logic
- **Templates**: Add your own template parameters and steps
- **Configuration**: Adjust settings in app-config files
- **Scripts**: Enhance scripts with additional functionality

## Support

For issues or questions:
1. Check the [Troubleshooting section](../RHDH-SETUP-GUIDE.md#troubleshooting)
2. Review [Backstage documentation](https://backstage.io/docs)
3. Visit [RHDH community](https://developers.redhat.com/rhdh)
