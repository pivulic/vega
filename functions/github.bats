#!/usr/bin/env bats

load $(pwd)/functions/github.sh

@test "Test validate-magento-version() should return 'community-edition' - if version is 'ce'" {
    local VERSION="ce"
    run validate-magento-version $VERSION
    [ "$output" == "community-edition" ]
}

@test "Test validate-magento-version() should return 'community-edition' - if version is 'CE'" {
    local VERSION="CE"
    run validate-magento-version $VERSION
    [ "$output" == "community-edition" ]
}

@test "Test validate-magento-version() should return 'community-edition' - if version is 'community-edition'" {
    local VERSION="community-edition"
    run validate-magento-version $VERSION
    [ "$output" == "community-edition" ]
}

@test "Test validate-magento-version() should return 'enterprise-edition' - if version is 'ee'" {
    local VERSION="ee"
    run validate-magento-version $VERSION
    [ "$output" == "enterprise-edition" ]
}

@test "Test validate-magento-version() should return 'enterprise-edition' - if version is 'enterprise-edition'" {
    local VERSION="enterprise-edition"
    run validate-magento-version $VERSION
    [ "$output" == "enterprise-edition" ]
}

@test "Test validate-magento-version() should fail - if version is 'non-existing'" {
    local VERSION="non-existing"
    run validate-magento-version $VERSION
    [ $status = 1 ]
}

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