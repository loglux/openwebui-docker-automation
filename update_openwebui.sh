#!/bin/sh

# Container and image details
CONTAINER_NAME="open-webui"
IMAGE_NAME="ghcr.io/open-webui/open-webui:main"
HOST_PORT=3000
CONTAINER_PORT=8080
OLLAMA_BASE_URL="http://192.168.1.10:11434"
VOLUME_NAME="open-webui:/app/backend/data"

# Log file for tracking script execution
LOG_FILE="update_open_webui.log"

# Logging function
log() {
  echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Step 1: Update the image
log "Starting image update: $IMAGE_NAME"
if docker pull "$IMAGE_NAME"; then
  log "Image updated successfully."
else
  log "Image update failed!"
  exit 1
fi

# Step 2: Stop the container
log "Stopping container: $CONTAINER_NAME"
if docker stop "$CONTAINER_NAME"; then
  log "Container stopped successfully."
else
  log "Container was not running or stopping failed."
fi

# Step 3: Remove the container
log "Removing container: $CONTAINER_NAME"
if docker rm "$CONTAINER_NAME"; then
  log "Container removed successfully."
else
  log "Container not found or removal failed."
fi

# Step 4: Run a new container
log "Starting a new container with name: $CONTAINER_NAME"
if docker run -d -p "$HOST_PORT:$CONTAINER_PORT" -e OLLAMA_BASE_URL="$OLLAMA_BASE_URL" \
  -v "$VOLUME_NAME" --name "$CONTAINER_NAME" --restart always "$IMAGE_NAME"; then
  log "Container started successfully."
else
  log "Failed to start the container!"
  exit 1
fi

# Step 5: Check the health of the new container
log "Checking container health..."

# Maximum wait time for health check (in seconds)
MAX_WAIT=60
WAIT_INTERVAL=5
TIME_WAITED=0

while [[ $TIME_WAITED -lt $MAX_WAIT ]]; do
  if curl -s "http://localhost:$HOST_PORT/health" | grep -q '"status":true'; then
    log "Container is running and healthy."
    break
  else
    log "Container is not healthy yet. Retrying in $WAIT_INTERVAL seconds..."
    sleep $WAIT_INTERVAL
    TIME_WAITED=$((TIME_WAITED + WAIT_INTERVAL))
  fi
done

if [[ $TIME_WAITED -ge $MAX_WAIT ]]; then
  log "Container health check failed after $MAX_WAIT seconds. Please check the logs!"
  exit 1
fi
