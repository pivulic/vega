#!/bin/bash

BASE=$(dirname ${BASH_SOURCE[0]})
# shellcheck source=${BASE}/utils/files.sh
source ${BASE}/utils/files.sh
# shellcheck source=${BASE}/utils/returns.sh
source ${BASE}/utils/returns.sh
# shellcheck source=${BASE}/utils/strings.sh
source ${BASE}/utils/strings.sh

function get-github-username() {
    GITHUB_USERNAME=$(git config github.user)
    if [ -z "$GITHUB_USERNAME" ]; then
        return-false
    else
        echo $GITHUB_USERNAME
    fi
}

function get-github-token() {
    GITHUB_TOKEN=$(git config github.token)
    if [ -z "$GITHUB_TOKEN" ]; then
        return-false
    else
        echo $GITHUB_TOKEN
    fi
}

function validate-github-credentials() {
    local GITHUB_USERNAME="$1"
    local GITHUB_TOKEN="$2"

    RESPONSE="$(curl --silent --user $GITHUB_USERNAME:$GITHUB_TOKEN https://api.github.com/user)"
    is-string-in-variable "$GITHUB_USERNAME" "$RESPONSE" || return-false
}

function is-github-repo() {
    local ORGANIZATION="$1"
    local REPO="$2"
    git ls-remote git@github.com:$ORGANIZATION/$REPO.git &>/dev/null
    if [ $? -ne 0 ]; then
        return-false
    fi
}

function get-github-file() {
    local GITHUB_TOKEN="$1"
    local ORGANIZATION="$2"
    local REPO="$3"
    local BRANCH="$4"
    local FILE_PATH="$5"

    curl -H "Authorization: token $GITHUB_TOKEN" -o $FILE_PATH https://raw.githubusercontent.com/$ORGANIZATION/$REPO/$BRANCH/$FILE_PATH &>/dev/null
}

function create-github-repository() {
    local GITHUB_USERNAME="$1"
    local GITHUB_TOKEN="$2"
    local REPO_NAME="$3"
    curl --user "$GITHUB_USERNAME:$GITHUB_TOKEN" https://api.github.com/user/repos -d '{"name":"'$REPO_NAME'", "private":"true"}' &>/dev/null
}