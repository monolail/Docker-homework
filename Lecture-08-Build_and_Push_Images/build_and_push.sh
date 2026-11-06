#!/bin/bash
# ==============================================================================
# SWCON221 Lecture 08 - Build, Run Web Server and Push to Docker Hub
# ==============================================================================

IMAGE_NAME="monolail/mywebserver:1.0"

echo "=== 1. Building Web Server Image ==="
docker build -t $IMAGE_NAME .

echo -e "\n=== 2. Running Web Server Container in Background ==="
docker run -d --name webserver -p 9000:9000 $IMAGE_NAME

echo -e "\n=== 3. Checking Container Status ==="
docker container ls --filter "name=webserver"

echo -e "\n=== 4. Testing HTTP Connection ==="
sleep 2
curl -i http://localhost:9000

echo -e "\n=== 5. Stopping and Removing Container ==="
docker container stop webserver
docker container rm webserver

echo -e "\n=== 6. Pushing Image to Docker Hub ==="
docker push $IMAGE_NAME
