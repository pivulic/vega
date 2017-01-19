#!/bin/sh

function error-exit() {
    echo "$1" 1>&2
    kill -INT $$
}

function return-true() {
    return 0
}

function return-false() {
    return 1
}