#!/bin/bash
set -e

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ACTION_DIR="./custom-actions/trigger-template-action"

if [ ! -d "$ACTION_DIR" ]; then
    echo -e "${RED}✗ Custom action directory not found: $ACTION_DIR${NC}"
    echo "Make sure you're running this from the rhdh-examples directory"
    exit 1
fi

echo -e "${GREEN}🔨 Rebuilding custom action...${NC}"

cd $ACTION_DIR

echo -e "${YELLOW}Cleaning previous build...${NC}"
npm run clean

echo -e "${YELLOW}Installing dependencies...${NC}"
npm install

echo -e "${YELLOW}Building TypeScript...${NC}"
npm run build

if [ -d "dist" ] && [ "$(ls -A dist)" ]; then
    echo -e "${GREEN}✅ Custom action built successfully!${NC}"
    echo ""
    echo "Build output:"
    ls -lh dist/
    echo ""
    echo -e "${GREEN}Next steps:${NC}"
    echo "   1. Copy the built action to your RHDH backend"
    echo "   2. Register it in your backend index.ts"
    echo "   3. Restart RHDH to load the new action"
else
    echo -e "${RED}✗ Build failed or produced no output${NC}"
    exit 1
fi
