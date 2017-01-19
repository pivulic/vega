#!/bin/sh

function to-lower-case() {
    local STRING="$1"
    echo "$STRING" | awk '{print tolower($0)}'
}

function is-string-in-variable() {
    local SEARCH_STRING="$1"
    local VARIABLE_STRING="$2"

    if echo "$VARIABLE_STRING" | grep -q "$SEARCH_STRING"; then
        return 0
    else
        return 1
    fi
}

function has-variable-prefix() {
    local VARIABLE="$1"
    local PREFIX="$2"

    if [[ "$VARIABLE" = "$PREFIX"* ]]; then
        return 0
    else
        return 1
    fi
}