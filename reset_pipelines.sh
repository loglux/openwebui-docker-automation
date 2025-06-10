#!/bin/sh

# -----------------------------
# CONFIGURATION
# -----------------------------

# Docker container and image names
CONTAINER_NAME="pipelines"
IMAGE_NAME="ghcr.io/open-webui/pipelines:main"

# Port configuration
HOST_PORT=9099
CONTAINER_PORT=9099

# Volume for pipelines
PIPELINES_VOLUME="pipelines"

# Optional: Custom pipelines URL (leave empty if not needed)
#CUSTOM_PIPELINES_URL="https://github.com/open-webui/pipelines/blob/main/examples/filters/detoxify_filter_pipeline.py"
CUSTOM_PIPELINES_URL=""

# Environment variables
DB_PORT="5432"
PIPELINES_REQUIREMENTS_PATH="/app/pipelines/requirements.txt"

# -----------------------------
# CLEANUP PHASE
# -----------------------------

echo "🚀 Stopping and removing the existing container..."
docker stop "$CONTAINER_NAME" 2>/dev/null
docker rm "$CONTAINER_NAME" 2>/dev/null

echo "🔥 Removing the existing Docker image..."
docker rmi "$IMAGE_NAME" 2>/dev/null

echo "🗑️ Removing the old volume..."
docker volume rm "$PIPELINES_VOLUME" 2>/dev/null

# -----------------------------
# INSTALLATION PHASE
# -----------------------------

echo "🔄 Pulling the latest Docker image..."
docker pull "$IMAGE_NAME"

# -----------------------------
# RUNNING NEW CONTAINER
# -----------------------------

echo "🚀 Running the new container..."

docker run -d \
  -p "$HOST_PORT":"$CONTAINER_PORT" \
  --add-host=host.docker.internal:host-gateway \
  -v "$PIPELINES_VOLUME":/app/pipelines \
  -e DB_PORT="$DB_PORT" \
  -e PIPELINES_REQUIREMENTS_PATH="$PIPELINES_REQUIREMENTS_PATH" \
  ${CUSTOM_PIPELINES_URL:+-e PIPELINES_URLS="$CUSTOM_PIPELINES_URL"} \
  --name "$CONTAINER_NAME" \
  --restart always \
  "$IMAGE_NAME"

# -----------------------------
# POST-INSTALLATION CHECK
# -----------------------------

echo "✅ Container is up and running:"
docker ps | grep "$CONTAINER_NAME"

echo "🌐 Access your pipelines at: http://localhost:$HOST_PORT"

