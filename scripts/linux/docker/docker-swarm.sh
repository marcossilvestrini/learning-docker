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
HOST_MANAGER1="debian-server01"
HOST_MANAGER2="debian-server02"
MANAGER_IP="192.168.0.140"
MACHINE_NAME=$(hostname)
#MACHINE_IP=$(hostname -i)
#MACHINE_IP=$(host $(hostname) | grep "has address" | awk '{print $4}')

# Check if distribution is Debian
if [[ "$DISTRO" == *"Debian"* ]]; then
    echo "Distribution is Debian...Congratulations!!!"
else
    echo "This script is available only Debian distributions!!!";exit 1;
fi

# leave at swap
docker swarm leave --force

case $MACHINE_NAME in
    "$HOST_MANAGER1")            
        echo "INIT docker swarm in $HOST_MANAGER1 as MANAGER"        
        docker swarm init --advertise-addr "$MANAGER_IP:2377"
        
        # grab the ipaddress:port of the manager
        # MANAGER_ADDRESS=$(docker swarm join-token worker | tail -n 2 |  tr -d '[[:space:]]')
        JOIN_MANAGER=$(docker swarm join-token manager | tail -n 2 |  tr -d '\n')
        echo "$JOIN_MANAGER" > configs/docker/swarm/join_manager

        # grab the ipaddress:port of the worker
        JOIN_WORKER=$(docker swarm join-token worker | tail -n 2 |  tr -d '\n')
        echo "$JOIN_WORKER" > configs/docker/swarm/join_worker

        # grab the manager and worker token
        # MANAGER_TOKEN=$(docker swarm join-token manager -q)
        # WORKER_TOKEN=$(docker swarm join-token worker -q)
    ;;
    "$HOST_MANAGER2")
        echo "JOIN server $HOST_MANAGER2 in docker swarm as MANAGER"
        JOIN_MANAGER=$(cat configs/docker/swarm/join_manager)
        $JOIN_MANAGER
    ;;
    *)
        echo "JOIN server $MACHINE_NAME in docker swarm as WORKER"
        JOIN_WORKER=$(cat configs/docker/swarm/join_worker)
        $JOIN_WORKER
    ;;
esac
