#!/bin/sh

BASE=$(dirname $BASH_SOURCE[0])
source ${BASE}/docker.sh
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
    VERSION=$(validate-magento-version $VERSION) || error-exit "Failed, specify 'community-edition' or 'enterprise-edition'"
    echo "OK"

    echo -n "  ==> Creating M2/Composer project... "
    CONTAINER_NAME='composer'
    REPOSITORY_URL='https://repo.magento.com/'
    d-composer create-project --ignore-platform-reqs --no-scripts --repository-url=$REPOSITORY_URL magento/project-$VERSION=$RELEASE || error-exit "Failed, could not install composer"
    echo "OK"

    echo -n "  ==> Copying composer.* files from container... "
    docker cp $CONTAINER_NAME:/app/project-$VERSION/composer.json . || error-exit "Failed, could not copy composer.json to host'"
    docker cp $CONTAINER_NAME:/app/project-$VERSION/composer.lock . || error-exit "Failed, could not copy composer.lock to host'"
    remove-container $CONTAINER_NAME || error-exit "Failed, could not remove composer container"
    echo "OK"

    echo -n "  ==> Creating GitHub repository... "
    create-github-repository $GITHUB_USERNAME $GITHUB_TOKEN $PROJECT || error-exit "Failed, could not create repo'"
    echo "OK"

    echo -n "  ==> Adding files to GitHub repository... "
    git init &>/dev/null || error-exit "Failed, could not initialize git"
    git add . &>/dev/null || error-exit "Failed, could not add files to git"
    git commit -m 'Initial commit' &>/dev/null || error-exit "Failed, could not commit to git"
    git remote add origin git@github.com:$ORGANIZATION/$PROJECT.git &>/dev/null || error-exit "Failed, could not set repository origin"
    git push -u origin master &>/dev/null || error-exit "Failed, could not push to repository"
    echo "OK"
}