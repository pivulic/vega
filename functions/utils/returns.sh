#!/bin/sh

function green-ok() {
    local MESSAGE="$1"
    if [ -z "$MESSAGE" ]; then
        MESSAGE="OK"
    fi
    GREEN='\033[0;32m'
    NO_COLOR='\033[0m'
    echo -e "${GREEN}${MESSAGE}${NO_COLOR}"
}

function error-exit() {
    RED='\033[0;41m'
    NO_COLOR='\033[0m'
    echo -e "${RED}${1}${NO_COLOR}"
    kill -INT $$
}

function return-true() {
    return 0
}

function return-false() {
    return 1
}