#!/bin/bash

function remove-container() {
    local CONTAINER_NAME="$1"
    if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
        docker rm --force --volumes $CONTAINER_NAME &>/dev/null
    fi
}

function docker-rm-all-containers() {
    local KEEP_CONTAINER="$1"
    CONTAINERS_TO_DELETE="$(docker ps -a | grep -v $KEEP_CONTAINER | cut -d ' ' -f1)"
    docker rm --force $CONTAINERS_TO_DELETE
}

function docker-exec() {
    local CONTAINER_NAME="$1"
    docker exec -it $CONTAINER_NAME bash
}

function kubectl-exec() {
    local CONTAINER_NAME="$1"
    kubectl exec -it $CONTAINER_NAME bash
}