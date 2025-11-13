#!/bin/bash
set -e

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

CONTAINER_NAME="rhdh-local"

echo -e "${YELLOW}🛑 Stopping RHDH...${NC}"

if podman ps -a | grep -q $CONTAINER_NAME; then
    podman stop $CONTAINER_NAME
    podman rm $CONTAINER_NAME
    echo -e "${GREEN}✅ RHDH stopped and removed${NC}"
else
    echo -e "${YELLOW}ℹ Container $CONTAINER_NAME not found${NC}"
fi

echo ""
echo -e "${GREEN}To start RHDH again, run:${NC}"
echo "   ./start-rhdh.sh"
echo ""
