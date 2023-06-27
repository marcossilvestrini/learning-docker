#!/bin/bash
<<'SCRIPT-FUNCTION'
    Description: Script for check Docker Image App
    Author: Marcos Silvestrini
    Date: 18/05/2023
SCRIPT-FUNCTION

#Set localizations for prevent bugs in operations
LANG=C

# Set workdir
WORKDIR="/home/vagrant"
cd $WORKDIR || exit

#Variables
DOCKER_APP_NAME="app-silvestrini"
DOCKER_IMAGE="silvestrini/$DOCKER_APP_NAME"
URL_DOCKER_APP="http://debian-server01:8080"

# File for outputs testing
FILE_TEST=test/docker/check-docker-app.txt
LINE="------------------------------------------------------"

echo $LINE >$FILE_TEST
echo "Check Docker App for This Lab" >>$FILE_TEST
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Date: $DATE" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

# Check Docker Image
echo $LINE >>$FILE_TEST
echo "Check Docker Build Image $DOCKER_APP_NAME..." >>$FILE_TEST
docker images | grep "$DOCKER_IMAGE" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

# Check Docker Container
echo $LINE >>$FILE_TEST
echo "Check Status Docker Service App $DOCKER_APP_NAME..." >>$FILE_TEST
docker ps | grep $DOCKER_APP_NAME >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

# Check Docker App Status
echo -e "Check Docker Service App Status...\n" >>$FILE_TEST
echo -e "Site: $URL_DOCKER_APP...\n" >>$FILE_TEST
curl -LI $URL_DOCKER_APP -o /dev/null -w '%{http_code}\n' -s >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST
