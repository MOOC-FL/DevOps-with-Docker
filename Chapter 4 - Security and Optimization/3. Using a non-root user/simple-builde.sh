#!/bin/bash
# simple-builder.sh

set -e

# Get GitHub repo from argument
GITHUB_REPO="$1"

# Get Docker Hub username
DOCKER_USER=$(docker system info 2>/dev/null | grep "Username" | cut -d: -f2 | tr -d ' ')
if [ -z "$DOCKER_USER" ]; then
    echo "ERROR: Not logged in to Docker Hub. Run: docker login"
    exit 1
fi

# Use repo name as image name
REPO_NAME=$(basename "$GITHUB_REPO")
DOCKER_IMAGE="$DOCKER_USER/$REPO_NAME"

echo "GitHub: $GITHUB_REPO"
echo "Docker Hub: $DOCKER_IMAGE"
echo ""

# Create temp dir
TEMP_DIR="/tmp/build-$$"
mkdir -p "$TEMP_DIR"

# Clone
echo "Cloning repository..."
git clone --depth 1 "https://github.com/$GITHUB_REPO.git" "$TEMP_DIR"

# Build
echo "Building Docker image..."
cd "$TEMP_DIR"
TIMESTAMP=$(date +%s)
docker build -t "$DOCKER_IMAGE:$TIMESTAMP" -t "$DOCKER_IMAGE:latest" .

# Create repository on Docker Hub if needed
echo "Creating repository on Docker Hub if needed..."
echo "Note: If this fails, manually create at: https://hub.docker.com/repository/create"
echo ""

# Push
echo "Pushing to Docker Hub..."
docker push "$DOCKER_IMAGE:$TIMESTAMP"
docker push "$DOCKER_IMAGE:latest"

echo ""
echo "✅ SUCCESS!"
echo "Image: $DOCKER_IMAGE"
echo "Tags: latest, $TIMESTAMP"

# Cleanup
rm -rf "$TEMP_DIR"
