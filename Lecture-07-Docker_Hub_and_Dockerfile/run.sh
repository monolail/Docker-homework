#!/bin/bash
# ==============================================================================
# SWCON221 Lecture 07 - Docker Hub and Dockerfile Test-Drive
# ==============================================================================

echo "=== Building Docker image 'myapp' ==="
docker build -t myapp .

echo -e "\n=== Checking Built Image ==="
docker image ls myapp

echo -e "\n=== Running 'py3' Container from 'myapp' ==="
docker run -it --rm --name py3 myapp
