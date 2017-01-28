#!/bin/sh

function remove-container() {
    local CONTAINER_NAME="$1"
    if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
        docker rm --force --volumes $CONTAINER_NAME &>/dev/null
    fi
}

function docker-rm-all-containers() {
    local CONTAINER_NAME="$1"
    docker rm --force $(docker ps -a | grep -v "$CONTAINER_NAME" | cut -d ' ' -f1)
}