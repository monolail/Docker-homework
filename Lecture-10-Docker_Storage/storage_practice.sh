#!/bin/bash
# ==============================================================================
# SWCON221 Lecture 10 - Docker Storage and Volume Practice
# ==============================================================================

echo "=== Step 1: Create Docker Volume ==="
docker volume create myvol-1
docker volume ls

echo -e "\n=== Step 2: Inspect Created Volume ==="
docker volume inspect myvol-1

echo -e "\n=== Step 3 & 4: Pull Jenkins Image and Run with Volume ==="
docker pull jenkins/jenkins:lts
docker run -d --name jenkins-server \
  -p 8080:8080 -p 50000:50000 \
  -v myvol-1:/var/jenkins_home \
  jenkins/jenkins:lts

echo -e "\n=== Step 5: Check Running Container and Logs ==="
sleep 5
docker container ls --filter "name=jenkins-server"
docker logs jenkins-server 2>&1 | grep -A 2 -B 2 "initialAdminPassword" || true

echo -e "\n=== Step 10: Stop and Remove First Jenkins Container ==="
docker container stop jenkins-server
docker container rm jenkins-server

echo -e "\n=== Step 13: Run Another Container Using the Same Volume (Persistence Check) ==="
docker run -d --name jenkins-production-copy \
  -p 8081:8080 -p 50001:50000 \
  -v myvol-1:/var/jenkins_home \
  jenkins/jenkins:lts

docker container ls --filter "name=jenkins-production-copy"

echo -e "\n=== Step 14: Cleanup Containers and Volume ==="
docker container stop jenkins-production-copy
docker container rm jenkins-production-copy
docker volume rm myvol-1
docker volume ls
