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

# Install Docker Engine
curl -fsSL https://get.docker.com/ | sh
systemctl restart docker

## Check installation
docker --version

## install docker compose
apt install -y docker-compose
apt autoremove -y

## set permissions
usermod -aG docker vagrant