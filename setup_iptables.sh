#!/bin/zsh

HTTP_PORT=10000

echo "getting docker container names ..."
DOCKER_CONTAINER_PROXY_SUFFIX="proxy"
DOCKER_CONTAINER_PROXY_NAME="$(basename $PWD)_$DOCKER_CONTAINER_PROXY_SUFFIX"
echo "docker container name $DOCKER_CONTAINER_PROXY_NAME"
DOCKER_CONTAINER_CLIENT_SUFFIX="client"
DOCKER_CONTAINER_CLIENT_NAME="$(basename $PWD)_$DOCKER_CONTAINER_CLIENT_SUFFIX"
echo "docker container name $DOCKER_CONTAINER_CLIENT_NAME"

echo "getting docker id for $DOCKER_CONTAINER_PROXY_NAME ..."
DOCKER_CONTAINER_PROXY_ID=$(docker ps | grep $DOCKER_CONTAINER_PROXY_NAME | awk '{ print $1 }')
echo "docker id $DOCKER_CONTAINER_PROXY_ID"
echo "getting docker id for $DOCKER_CONTAINER_CLIENT_NAME ..."
DOCKER_CONTAINER_CLIENT_ID=$(docker ps | grep $DOCKER_CONTAINER_CLIENT_NAME | awk '{ print $1 }')
echo "docker id $DOCKER_CONTAINER_CLIENT_ID"

echo "getting ip address for $DOCKER_CONTAINER_PROXY_NAME ..."
DOCKER_CONTAINER_PROXY_IP=$(docker inspect $DOCKER_CONTAINER_PROXY_ID | grep -e "\"IPAddress\": \"\d\{1,3\}\.\d\{1,3\}\d\{1,3\}\.\d\{1,3\}" | awk '{print $2}' | tr -d "\"" | tr -d ",")
echo "container ip: $DOCKER_CONTAINER_PROXY_IP"

echo "creating iptables rules on $DOCKER_CONTAINER_CLIENT_NAME ..."
echo "iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination $DOCKER_CONTAINER_PROXY_IP:$HTTP_PORT"
docker exec -it --privileged $DOCKER_CONTAINER_CLIENT_ID iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination $DOCKER_CONTAINER_PROXY_IP:$HTTP_PORT

echo "printing iptables nat rules on $DOCKER_CONTAINER_CLIENT_NAME ..."
docker exec -it --privileged $DOCKER_CONTAINER_CLIENT_ID iptables -L -t nat
