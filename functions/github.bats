#!/usr/bin/env bats

load $(pwd)/functions/github.sh

@test "Test is-github-repo() should pass - if repo exists" {
    local ORGANIZATION="magento"
    local REPO="magento2"
    run is-github-repo $ORGANIZATION $REPO
    [ $status = 0 ]
}

@test "Test is-github-repo() should fail - if repo doesn't exist" {
    local ORGANIZATION="pivulic"
    local REPO="ikea222"
    run is-github-repo $ORGANIZATION $REPO
    [ $status = 1 ]
}