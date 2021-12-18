#!/bin/zsh

FILENAME="envoy.yaml"
PROXY_PATH="/usr/local/bin/envoy"
DOCKER_SOURCE="./proxy/$FILENAME"
DOCKER_DESTINATION="/etc/envoy/$FILENAME"

echo "getting docker container name ..."
DOCKER_CONTAINER_SUFFIX="proxy"
DOCKER_CONTAINER_NAME="$(basename $PWD)_$DOCKER_CONTAINER_SUFFIX"
echo "docker container name $DOCKER_CONTAINER_NAME"

echo "getting docker id for $DOCKER_CONTAINER_NAME ..."
DOCKER_CONTAINER_ID=$(docker ps | grep $DOCKER_CONTAINER_NAME | awk '{ print $1 }')
echo "docker id $DOCKER_CONTAINER_ID"

echo "copying $DOCKER_SOURCE to $DOCKER_CONTAINER_NAME:$DOCKER_DESTINATION ..."
docker cp $DOCKER_SOURCE $DOCKER_CONTAINER_ID:$DOCKER_DESTINATION

echo "validating $DOCKER_CONTAINER_NAME:$DOCKER_DESTINATION ..."
docker exec $DOCKER_CONTAINER_ID $PROXY_PATH --mode validate -c $DOCKER_DESTINATION
