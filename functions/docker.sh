#!/bin/sh

function remove-container() {
    local CONTAINER_NAME="$1"
    if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
        docker rm --force --volumes $CONTAINER_NAME &>/dev/null
    fi
}
