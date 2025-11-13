#!/bin/bash
set -e

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

CONTAINER_NAME="rhdh-local"
IMAGE_NAME="quay.io/backstage/backstage:latest"

echo -e "${YELLOW}🛑 Stopping existing container...${NC}"
podman stop $CONTAINER_NAME 2>/dev/null || true
podman rm $CONTAINER_NAME 2>/dev/null || true

echo -e "${GREEN}🚀 Starting RHDH...${NC}"
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

echo -e "${YELLOW}⏳ Waiting for RHDH to start...${NC}"
echo "This may take up to 60 seconds..."

# Wait for backend to be ready
TIMEOUT=60
COUNTER=0
until curl -s http://localhost:7007/api/catalog/entities > /dev/null 2>&1; do
  if [ $COUNTER -eq $TIMEOUT ]; then
    echo -e "${RED}✗ Timeout waiting for RHDH to start${NC}"
    echo "Check logs with: podman logs $CONTAINER_NAME"
    exit 1
  fi
  echo -n "."
  sleep 2
  COUNTER=$((COUNTER+2))
done

echo ""
echo -e "${GREEN}✅ RHDH is running!${NC}"
echo ""
echo -e "📍 ${GREEN}Access Points:${NC}"
echo -e "   Frontend: ${GREEN}http://localhost:3000${NC}"
echo -e "   Backend:  ${GREEN}http://localhost:7007${NC}"
echo ""
echo -e "📋 ${GREEN}Useful Commands:${NC}"
echo "   View logs:      podman logs -f $CONTAINER_NAME"
echo "   Stop RHDH:      podman stop $CONTAINER_NAME"
echo "   Restart RHDH:   podman restart $CONTAINER_NAME"
echo "   Shell access:   podman exec -it $CONTAINER_NAME /bin/bash"
echo "   Check status:   podman ps | grep $CONTAINER_NAME"
echo ""
echo -e "🎯 ${GREEN}Next Steps:${NC}"
echo "   1. Open http://localhost:3000 in your browser"
echo "   2. Click 'Create' to see available templates"
echo "   3. Try creating a component with Template 1"
echo ""
