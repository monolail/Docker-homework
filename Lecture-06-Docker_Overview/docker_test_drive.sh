#!/bin/bash
# ==============================================================================
# SWCON221 Lecture 06 - Docker Overview Test-Drive Practice Script
# ==============================================================================

echo "=== 1. Hello World Test ==="
docker run hello-world

echo -e "\n=== 2. Ubuntu Container Test-Drive ==="
docker image ls
docker container ls
docker pull ubuntu:latest
docker container run -it -d --rm --name ubuntuos ubuntu:latest
docker exec -it ubuntuos /bin/bash -c "uname -a; cat /etc/os-release | grep PRETTY_NAME; ls -la"
docker container ls
docker container stop ubuntuos

echo -e "\n=== 3. Alpine Container Test-Drive ==="
docker pull alpine:latest
docker container run -it -d --rm --name alpineos alpine:latest
docker exec -it alpineos /bin/ash -c "uname -a; cat /etc/os-release | grep PRETTY_NAME; ls -la"
docker container ls
docker container stop alpineos

echo -e "\n=== 4. Python Container Test-Drive ==="
docker pull python:latest
docker container run -it -d --rm --name py3 python:latest
docker exec -it py3 /bin/bash -c "python --version; python -c 'print(\"Python container is running successfully!\")'"
docker container ls
docker container stop py3

echo -e "\n=== 5. Cleanup Images ==="
docker image ls
