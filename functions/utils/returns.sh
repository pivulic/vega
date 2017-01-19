#!/bin/sh

function green-ok() {
    GREEN='\033[0;32m'
    NO_COLOR='\033[0m'
    echo -e "${GREEN}OK${NO_COLOR}"
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