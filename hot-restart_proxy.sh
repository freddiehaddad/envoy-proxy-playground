#!/bin/zsh

SIGNAL="SIGHUP"
PID=1

echo "getting docker container name ..."
DOCKER_CONTAINER_SUFFIX="proxy"
DOCKER_CONTAINER_NAME="$(basename $PWD)_$DOCKER_CONTAINER_SUFFIX"
echo "docker container name $DOCKER_CONTAINER_NAME"

echo "getting docker id for $DOCKER_CONTAINER_NAME ..."
DOCKER_CONTAINER_ID=$(docker ps | grep $DOCKER_CONTAINER_NAME | awk '{ print $1 }')
echo "docker id $DOCKER_CONTAINER_ID"

echo "sending $SIGNAL to pid $PID on $DOCKER_CONTAINER_NAME:$DOCKER_CONTAINER_ID ..."
docker exec $DOCKER_CONTAINER_ID kill -s $SIGNAL $PID
