#!/bin/sh

function error-exit() {
    echo "$1" 1>&2
    kill -INT $$
}

function return-false() {
    return 1
}

function to-lower-case() {
    local STRING="$1"
    echo "$STRING" | awk '{print tolower($0)}'
}