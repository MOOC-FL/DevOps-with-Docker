#!/bin/bash
# builder.sh - Clone, build, push to Docker Hub as abdelwahabayman
set -e

# Validate args
[ $# -ge 1 ] || { echo "Usage: $0 <github-repo> [image-name]"; exit 1; }

# Setup
GITHUB_REPO="$1"
IMAGE_NAME="${2:-$(basename "$GITHUB_REPO")}"
DOCKER_REPO="abdelwahabayman/$IMAGE_NAME"
TEMP_DIR="/tmp/build-$$"

# Login check
docker system info | grep -q "abdelwahabayman" || docker login -u abdelwahabayman

# Clone and build
git clone --depth 1 "https://github.com/$GITHUB_REPO.git" "$TEMP_DIR"
cd "$TEMP_DIR"
[ -f Dockerfile ] || { echo "No Dockerfile"; exit 1; }

TIMESTAMP=$(date +%s)
docker build -t "$DOCKER_REPO:$TIMESTAMP" -t "$DOCKER_REPO:latest" .

# Push
echo "Ensure repo exists at: https://hub.docker.com/r/$DOCKER_REPO"
read -p "Press Enter after creating..."
docker push "$DOCKER_REPO:$TIMESTAMP"
docker push "$DOCKER_REPO:latest"

# Cleanup and show results
rm -rf "$TEMP_DIR"
echo "✅ Pushed to $DOCKER_REPO"
echo "Tags: latest, $TIMESTAMP"
