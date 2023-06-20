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
DOCKER_APP_NAME="app-http"
DOCKER_APP_DIR="/usr/share/nginx/html"
DOCKER_VOLUME="/docker-volumes/$DOCKER_APP_NAME"
TAG="v1.0.0"
# {{username}}/{{imagename}}:{{version\tag}}
DOCKER_IMAGE="mrsilvestrini/$DOCKER_APP_NAME:$TAG" 
DOCKERFILE="configs/docker/images/$DOCKER_APP_NAME"


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

## Get docker credentials
JSON="$WORKDIR/security/.docker-secrets"
DOCKERHUB_USERNAME=$(jq -r .username $JSON)
DOCKERHUB_PASSWORD=$(jq -r .password $JSON)    

## Login dockerhub account
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin docker.io > /dev/null 2>&1

## Push image to docker hub
docker push -q "$DOCKER_IMAGE"

# pull image from docker
docker pull $DOCKER_IMAGE

# Create a container with custom image for testing purposes

## Create container with docker volume
DOCKER_VOLUME="$DOCKER_APP_NAME"
DOCKER_VOLUME_FOLDER="/var/lib/docker/volumes/$DOCKER_VOLUME/_data/"
PERSISTENT_FILE="$DOCKER_VOLUME_FOLDER/persistent-file.txt"
docker run -d --name $DOCKER_APP_NAME \
    --mount source=$DOCKER_VOLUME,target=$DOCKER_APP_DIR \
    -p 8080:80 $DOCKER_IMAGE

## Create persistent file for test volume
if [ ! -f "$PERSISTENT_FILE" ]; then
    date=$(date '+%Y-%m-%d %H:%M:%S')
    echo "Date: $date" > "$PERSISTENT_FILE"
    echo "Test persistet file in docker volume!!!" >> $PERSISTENT_FILE    
fi

# Logout dockerhub according
docker logout
