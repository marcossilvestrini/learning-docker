#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for install and configure Docker for labs.
    Author: Marcos Silvestrini
    Date: 17/05/2023
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

# Set workdir
WORKDIR="/home/vagrant"
cd $WORKDIR || exit

# Variables
DISTRO=$(cat /etc/*release | grep -ws NAME=)

# Check if distribution is Debian
if [[ "$DISTRO" == *"Debian"* ]]; then    
    echo "Distribution is Debian...Congratulations!!!"
else    
    echo "This script is available only Debian distributions!!!";exit 1;
fi

# Install docker

# Uninstall old versions
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done

## Install Docker Engine
#curl -fsSL https://get.docker.com/ | sh

## Update the apt package index and install packages to allow apt to use a repository over HTTPS:
apt-get install -y ca-certificates curl gnupg

## Add Docker’s official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg -f --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

## Use the following command to set up the repository:
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null

## Update the apt package index:
apt-get update -y

## Install Docker Engine, containerd, and Docker Compose.
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin

## set permissions
usermod -aG docker vagrant

## Start Docker
systemctl enable docker
systemctl restart docker

## Check installation
docker --version
