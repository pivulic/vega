#!/bin/sh

function get-file-name-from-path() {
    local FILE_PATH="$1"
    basename $FILE_PATH
}

function replace-string-in-file() {
    local FILE="$1"
    local ORIGINAL_STRING="$2"
    local NEW_STRING="$3"

    sed -i -e "s/$ORIGINAL_STRING/$NEW_STRING/g" $FILE
    rm -f "$FILE-e"
}

function get-current-directory-name() {
    DIRECTORY=${PWD##*/}
    echo $DIRECTORY
}