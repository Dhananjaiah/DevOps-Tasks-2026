# Red Hat Developer Hub (RHDH) - Complete Documentation Index

Welcome to the complete Red Hat Developer Hub setup and custom scaffolder action documentation!

## 📚 Documentation Structure

This documentation is organized into several files for easy navigation:

### 1. Getting Started

#### [RHDH Quick Start Guide](./RHDH-QUICK-START.md) 🚀
**Time: ~15 minutes**

Perfect for getting RHDH running quickly on your local machine.

- Prerequisites checklist
- Step-by-step setup (5 steps)
- Quick verification
- Basic troubleshooting

**Start here if:** You want to get RHDH running as fast as possible.

---

#### [RHDH Setup Guide](./RHDH-SETUP-GUIDE.md) 📖
**Time: ~1-2 hours**

Comprehensive guide covering everything from installation to advanced usage.

**Contents:**
1. Prerequisites and system requirements
2. Installing RHDH with Podman
3. Basic configuration
4. Creating custom scaffolder actions
5. Template-triggering action implementation
6. Registration and usage
7. Comprehensive troubleshooting
8. Best practices
9. Additional resources

**Start here if:** You want to understand RHDH deeply and build custom solutions.

---

### 2. Understanding the Workflow

#### [RHDH Workflow Diagram](./RHDH-WORKFLOW-DIAGRAM.md) 📊
**Visual guide with diagrams**

Explains how templates trigger other templates using the custom action.

**Contents:**
- Architecture overview (with ASCII diagrams)
- Detailed execution flow
- API endpoints documentation
- File structure explanation
- Key concepts
- Use cases and examples
- Monitoring and debugging

**Start here if:** You want to understand how the template-triggering mechanism works.

---

### 3. Ready-to-Use Examples

#### [Examples Directory](./rhdh-examples/) 💡
**Complete working code**

Everything you need to get started with templates and custom actions.

**Contents:**
```
rhdh-examples/
├── README.md                    # Examples overview
├── custom-action/               # Complete custom action code
│   └── trigger-template-action/
│       ├── package.json
│       ├── tsconfig.json
│       └── src/
│           ├── index.ts         # Main exports
│           ├── module.ts        # Backend module
│           └── triggerTemplate.ts  # Action implementation
├── templates/                   # Example templates
│   ├── template1/              # Main application template
│   │   ├── template.yaml
│   │   └── skeleton/
│   └── template2/              # Database setup template
│       ├── template.yaml
│       └── skeleton/
├── config/                     # Configuration examples
│   ├── app-config.example.yaml
│   └── app-config.production.yaml
└── scripts/                    # Helper scripts
    ├── start-rhdh.sh
    ├── stop-rhdh.sh
    └── rebuild-action.sh
```

**Start here if:** You want working code to copy and customize.

---

## 🎯 Learning Paths

### Path 1: Quick Start (Beginner)
**Goal**: Get RHDH running locally

1. Read [Quick Start Guide](./RHDH-QUICK-START.md)
2. Follow the 5 steps to install RHDH
3. Access the frontend at http://localhost:3000
4. Explore the default interface

**Time**: 15-30 minutes

---

### Path 2: Template Development (Intermediate)
**Goal**: Create and use templates

1. Complete Quick Start
2. Read [Setup Guide - Templates Section](./RHDH-SETUP-GUIDE.md#registration-and-usage)
3. Copy example templates from [rhdh-examples/templates/](./rhdh-examples/templates/)
4. Customize Template 1 for your needs
5. Test template execution

**Time**: 2-3 hours

---

### Path 3: Custom Action Development (Advanced)
**Goal**: Build custom scaffolder actions

1. Complete Template Development path
2. Read [Setup Guide - Custom Actions](./RHDH-SETUP-GUIDE.md#creating-custom-scaffolder-actions)
3. Study [Workflow Diagram](./RHDH-WORKFLOW-DIAGRAM.md)
4. Copy [custom-action code](./rhdh-examples/custom-action/)
5. Build and register the action
6. Test Template 1 → Template 2 triggering

**Time**: 3-4 hours

---

### Path 4: Production Deployment (Expert)
**Goal**: Deploy RHDH to production

1. Complete Custom Action Development path
2. Read [Setup Guide - Best Practices](./RHDH-SETUP-GUIDE.md#best-practices)
3. Review [Production Config](./rhdh-examples/config/app-config.production.yaml)
4. Set up PostgreSQL database
5. Configure authentication (GitHub OAuth)
6. Deploy to Kubernetes/OpenShift
7. Set up monitoring and logging

**Time**: 1-2 days

---

## 🔍 Quick Reference

### Common Tasks

| Task | File | Section |
|------|------|---------|
| Install RHDH | [Quick Start](./RHDH-QUICK-START.md) | Steps 1-4 |
| Configure RHDH | [Setup Guide](./RHDH-SETUP-GUIDE.md) | Basic Configuration |
| Create a template | [Examples](./rhdh-examples/templates/) | template1/ or template2/ |
| Build custom action | [Setup Guide](./RHDH-SETUP-GUIDE.md) | Custom Scaffolder Actions |
| Troubleshoot issues | [Setup Guide](./RHDH-SETUP-GUIDE.md) | Troubleshooting |
| Understand workflow | [Workflow Diagram](./RHDH-WORKFLOW-DIAGRAM.md) | Architecture Overview |

### Key Concepts

| Concept | Explanation | Reference |
|---------|-------------|-----------|
| Scaffolder | Template execution engine | [Backstage Docs](https://backstage.io/docs/features/software-templates) |
| Template | Blueprint for creating resources | [Examples](./rhdh-examples/templates/) |
| Action | Reusable template step | [Setup Guide](./RHDH-SETUP-GUIDE.md#creating-custom-scaffolder-actions) |
| Catalog | Registry of components/resources | [Setup Guide](./RHDH-SETUP-GUIDE.md#basic-configuration) |
| Entity | Item in the catalog | [Backstage Docs](https://backstage.io/docs/features/software-catalog) |

### Useful Commands

```bash
# Start RHDH
cd ~/rhdh-local && ./start-rhdh.sh

# Stop RHDH
podman stop rhdh-local

# View logs
podman logs -f rhdh-local

# Rebuild custom action
cd ~/rhdh-local/custom-actions/trigger-template-action
npm run clean && npm run build

# Check backend API
curl http://localhost:7007/api/catalog/entities

# Access frontend
open http://localhost:3000
```

---

## 📦 What's Included

### Documentation Files (4 files)
- ✅ **RHDH-QUICK-START.md** - Fast setup guide (15 min)
- ✅ **RHDH-SETUP-GUIDE.md** - Comprehensive guide (36,000+ characters)
- ✅ **RHDH-WORKFLOW-DIAGRAM.md** - Visual workflow explanation
- ✅ **RHDH-INDEX.md** - This file (navigation guide)

### Example Code (21 files)
- ✅ Custom scaffolder action (TypeScript)
- ✅ Two complete template examples
- ✅ Configuration files (dev & prod)
- ✅ Helper scripts (start, stop, rebuild)
- ✅ Template skeletons with real content

### Total Lines of Code/Documentation
- **~2,000+ lines** of documentation
- **~500+ lines** of working code
- **100% production-ready** examples

---

## 🎓 Prerequisites

Before starting, ensure you have:

- ✅ **Podman** installed and working
- ✅ **Node.js 18+** with npm
- ✅ **Git** for version control
- ✅ **8GB RAM** available
- ✅ **Ports 3000 & 7007** free
- ✅ **Basic knowledge** of containers and YAML

---

## 🆘 Getting Help

### In This Documentation

1. **Quick issue?** → Check [Troubleshooting](./RHDH-SETUP-GUIDE.md#troubleshooting)
2. **Need examples?** → Browse [rhdh-examples/](./rhdh-examples/)
3. **Understand workflow?** → Read [Workflow Diagram](./RHDH-WORKFLOW-DIAGRAM.md)
4. **Deep dive?** → Study [Setup Guide](./RHDH-SETUP-GUIDE.md)

### External Resources

- [RHDH Official Docs](https://developers.redhat.com/rhdh)
- [Backstage Documentation](https://backstage.io/docs)
- [Backstage Discord](https://discord.gg/backstage)
- [GitHub Discussions](https://github.com/backstage/backstage/discussions)

---

## 🚀 Quick Start Command

Get up and running with a single command sequence:

```bash
# Create project directory
mkdir -p ~/rhdh-local && cd ~/rhdh-local

# Clone examples (adjust path as needed)
cp -r /path/to/rhdh-examples/* .

# Start RHDH
./scripts/start-rhdh.sh

# Open browser
open http://localhost:3000
```

---

## ✨ Key Features Covered

- ✅ Local RHDH installation with Podman
- ✅ Step-by-step configuration
- ✅ Custom scaffolder action development
- ✅ Template-to-template triggering
- ✅ GitHub integration
- ✅ Production-ready examples
- ✅ Comprehensive troubleshooting
- ✅ Best practices and patterns
- ✅ Security considerations
- ✅ Monitoring and debugging

---

## 📝 Contributing

Found an issue or want to improve the documentation?

1. Check existing issues/PRs
2. Create a detailed issue or PR
3. Follow the existing structure and style
4. Test all code examples
5. Update this index if adding new files

---

## 📄 License

This documentation is provided as-is for educational purposes. RHDH and Backstage have their own licenses.

---

## 🎉 What's Next?

After completing this guide, you'll be able to:

- ✅ Run RHDH locally for development
- ✅ Create custom templates
- ✅ Build custom scaffolder actions
- ✅ Trigger templates from other templates
- ✅ Deploy to production (with additional setup)
- ✅ Troubleshoot common issues
- ✅ Customize RHDH for your organization

**Start with the [Quick Start Guide](./RHDH-QUICK-START.md) now!** 🚀

---

*Last updated: 2024-11-13*
*Documentation version: 1.0.0*
