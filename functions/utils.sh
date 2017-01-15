#!/bin/sh

function error-exit() {
    echo "$1" 1>&2
    kill -INT $$
}

function to-lower-case() {
    local STRING="$1"
    echo "$STRING" | awk '{print tolower($0)}'
}