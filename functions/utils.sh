#!/bin/sh

function error-exit() {
    echo "$1" 1>&2
    kill -INT $$
}

function return-false() {
    return 1
}

function return-true() {
    return 0
}

function to-lower-case() {
    local STRING="$1"
    echo "$STRING" | awk '{print tolower($0)}'
}

function is-string-in-variable() {
    local SEARCH_STRING="$1"
    local VARIABLE_STRING="$2"

    if echo "$VARIABLE_STRING" | grep -q "$SEARCH_STRING"; then
        return-true
    else
        return-false
    fi
}