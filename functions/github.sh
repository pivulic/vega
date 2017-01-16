#!/bin/sh

BASE=$(dirname $BASH_SOURCE[0])
source ${BASE}/utils.sh

function validate-magento-version() {
    local VERSION="$1"

    VERSION="$(to-lower-case $VERSION)"
    case $VERSION in
        ce|community-edition)
            echo 'community-edition'
            ;;
        ee|enterprise-edition)
            echo 'enterprise-edition'
            ;;
        *)
            return-false
            ;;
    esac
}

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

function create-github-repository() {
    local GITHUB_USERNAME="$1"
    local GITHUB_TOKEN="$2"
    local PROJECT="$3"
    curl --user "$GITHUB_USERNAME:$GITHUB_TOKEN" https://api.github.com/user/repos -d '{"name":"'$PROJECT'", "private":"true"}' &>/dev/null
}

function m2-create-project() {
    local PROJECT="$1"
    local VERSION="$2"
    local RELEASE="$3"

    echo "Creating a new M2 project...  "
    if [ -z "$PROJECT" ]; then
        error-exit "  ==> Failed, missing 1st argument (project name)"
    fi

    echo -n "  ==> Validating GitHub credentials... "
    GITHUB_USERNAME=$(get-github-username) || error-exit "Failed, run 'git config --global github.user <username>'"
    GITHUB_TOKEN=$(get-github-token) || error-exit "Failed, run 'git config --global github.token <token>'"
    validate-github-credentials $GITHUB_USERNAME $GITHUB_TOKEN || error-exit "Failed, incorrect credentials"
    echo "OK"

    echo -n "  ==> Validating that GitHub repository doesn't exist... "
    ORGANIZATION="pivulic"
    is-github-repo $ORGANIZATION $PROJECT && error-exit "Failed, https://github.com/$ORGANIZATION/$PROJECT already exist"
    echo "OK"

    echo -n "  ==> Validating Magento version... "
    validate-magento-version $VERSION || error-exit "Failed, please specify 'community-edition' or 'enterprise-edition'"

    echo -n "  ==> Creating Github repository... "
    create-github-repository $GITHUB_USERNAME $GITHUB_TOKEN $PROJECT || error-exit "Failed, could not create repo'"
    echo "OK"

    REPOSITORY_URL='https://repo.magento.com/'
    d-composer create-project --ignore-platform-reqs --no-scripts --repository-url=$REPOSITORY_URL magento/project-$VERSION=$RELEASE
}