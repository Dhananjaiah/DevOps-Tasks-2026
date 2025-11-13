# RHDH Quick Start Guide

## 🚀 Get Started in 15 Minutes

This is a condensed quick-start guide to get Red Hat Developer Hub running locally with Podman.

### Prerequisites Checklist

- [ ] Podman installed (`podman --version`)
- [ ] Node.js 18+ installed (`node --version`)
- [ ] Git installed (`git --version`)
- [ ] 8GB RAM available
- [ ] Ports 3000 and 7007 available

### Step 1: Create Project Directory (2 minutes)

```bash
# Create and navigate to project directory
mkdir -p ~/rhdh-local && cd ~/rhdh-local

# Create directory structure
mkdir -p {config,templates,custom-actions,data,logs}
```

### Step 2: Create Configuration (3 minutes)

```bash
# Create basic config file
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
  cors:
    origin: http://localhost:3000
    methods: [GET, HEAD, PATCH, POST, PUT, DELETE]
    credentials: true
  database:
    client: better-sqlite3
    connection: ':memory:'

auth:
  environment: development
  providers:
    guest:
      dangerouslyAllowOutsideDevelopment: true

catalog:
  import:
    entityFilename: catalog-info.yaml
  rules:
    - allow: [Component, System, API, Resource, Location, Template]

scaffolder:
  defaultAuthor:
    name: Developer Hub
    email: devhub@example.com
EOF
```

### Step 3: Create Start Script (2 minutes)

```bash
cat > start-rhdh.sh << 'EOF'
#!/bin/bash
set -e

CONTAINER_NAME="rhdh-local"
IMAGE_NAME="quay.io/backstage/backstage:latest"

echo "🛑 Stopping existing container..."
podman stop $CONTAINER_NAME 2>/dev/null || true
podman rm $CONTAINER_NAME 2>/dev/null || true

echo "🚀 Starting RHDH..."
podman run -d \
  --name $CONTAINER_NAME \
  -p 3000:3000 \
  -p 7007:7007 \
  -v $(pwd)/config:/opt/app-root/src/app-config:Z \
  -v $(pwd)/templates:/templates:Z \
  -v $(pwd)/data:/data:Z \
  $IMAGE_NAME

echo "⏳ Waiting for RHDH to start..."
sleep 15

echo "✅ RHDH is running!"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:7007"
echo ""
echo "📋 Useful commands:"
echo "   Logs:  podman logs -f $CONTAINER_NAME"
echo "   Stop:  podman stop $CONTAINER_NAME"
echo "   Shell: podman exec -it $CONTAINER_NAME /bin/bash"
EOF

chmod +x start-rhdh.sh
```

### Step 4: Start RHDH (5 minutes)

```bash
# Start RHDH
./start-rhdh.sh

# Wait for it to start, then open browser
# Navigate to: http://localhost:3000
```

### Step 5: Verify Installation (3 minutes)

```bash
# Check container status
podman ps | grep rhdh

# Test backend API
curl http://localhost:7007/api/catalog/entities

# View logs
podman logs rhdh-local
```

---

## 🎯 Next Steps

Now that RHDH is running, you can:

1. **Create Your First Template**: See example templates in the full guide
2. **Add Custom Actions**: Follow the custom scaffolder action guide
3. **Integrate with GitHub**: Add GitHub integration for template publishing
4. **Explore the Catalog**: Navigate the web UI at http://localhost:3000

---

## 🔧 Quick Troubleshooting

### Container won't start?
```bash
# Check logs
podman logs rhdh-local

# Check ports
sudo netstat -tulpn | grep -E ':(3000|7007)'
```

### Can't access frontend?
```bash
# Verify container is running
podman ps | grep rhdh

# Check firewall
sudo firewall-cmd --add-port=3000/tcp --permanent
sudo firewall-cmd --add-port=7007/tcp --permanent
sudo firewall-cmd --reload
```

### Need to restart?
```bash
podman restart rhdh-local
```

---

## 📚 Full Documentation

For complete documentation including custom scaffolder actions, see:
- [Full RHDH Setup Guide](./RHDH-SETUP-GUIDE.md)

---

## 🛑 Stop RHDH

```bash
podman stop rhdh-local
podman rm rhdh-local
```

---

**That's it! You now have a working RHDH instance. 🎉**
