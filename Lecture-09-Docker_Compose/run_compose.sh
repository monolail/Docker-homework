#!/bin/bash
# ==============================================================================
# SWCON221 Lecture 09 - Docker Compose Test-Drive
# ==============================================================================

echo "=== 1. Validating Compose Configuration ==="
docker compose config

echo -e "\n=== 2. Starting Multi-Container Services ==="
docker compose up -d

echo -e "\n=== 3. Checking Service Status ==="
docker compose ps

echo -e "\n=== 4. Testing Worker1 (Port 8001) ==="
curl -I http://localhost:8001

echo -e "\n=== 5. Testing Worker2 (Port 8002) ==="
curl -I http://localhost:8002

echo -e "\n=== 6. Stopping and Removing Services ==="
docker compose down
