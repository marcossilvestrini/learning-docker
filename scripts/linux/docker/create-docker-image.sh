#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for create docker image
    Author: Marcos Silvestrini
    Date: 15/06/2023
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

# Set workdir
WORKDIR="/home/vagrant"
cd $WORKDIR || exit

# Variables
DISTRO=$(cat /etc/*release | grep -ws NAME=)
IP_MANAGER="192.168.0.140"
DOCKER_APP_NAME="app-silvestrini"
DOCKER_APP_DIR="/usr/share/nginx/html"
TAG="v1.0.0"
DOCKER_IMAGE="mrsilvestrini/$DOCKER_APP_NAME:$TAG" # {{username}}/{{imagename}}:{{version|tag}}
DOCKERFILE="configs/docker/apps/$DOCKER_APP_NAME"

# Get docker credentials
JSON="$WORKDIR/security/.docker-secrets"
DOCKERHUB_USERNAME=$(jq -r .username $JSON)
DOCKERHUB_PASSWORD=$(jq -r .password $JSON)   

# Check if distribution is Debian
if [[ "$DISTRO" == *"Debian"* ]]; then    
    echo "Distribution is Debian...Congratulations!!!"
else    
    echo "This script is available only Debian distributions!!!";exit 1;
fi

# clear all docker container 
docker container rm $(docker container ls -aq) --force > /dev/null 2>&1

# clear all docker images
docker rmi $(docker images -aq) --force > /dev/null 2>&1

# Create .dockerignore
if [ ! -f "$DOCKERFILE/.dockerignore" ]; then
    echo Dockerfile > "$DOCKERFILE/.dockerignore"    
fi

# Build my custom image
docker build -q -t "$DOCKER_IMAGE" --build-arg DOCKER_APP_DIR="$DOCKER_APP_DIR"  "$DOCKERFILE"

# Push image to docker hub

## Login dockerhub account
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin docker.io > /dev/null 2>&1

## Push image to docker hub
docker push -q "$DOCKER_IMAGE"

# pull image from docker
docker pull $DOCKER_IMAGE

# Create a container with custom image for testing purposes

## Version 1
# docker run -d --name $DOCKER_APP_NAME \
#     --mount source=$DOCKER_VOLUME,target=$DOCKER_APP_DIR \
#     -p 8080:80 $DOCKER_IMAGE

## Version 2
# docker-compose -f configs/docker/apps/app-silvestrini/docker-compose.yaml up -d

## Version 3
#docker stack deploy -c configs/docker/apps/app-silvestrini/docker-compose.yaml stack

## Version 4 -
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_MANAGER -l vagrant \
    docker stack deploy -c configs/docker/apps/app-silvestrini/docker-compose.yaml stack

# Logout dockerhub according
docker logout
