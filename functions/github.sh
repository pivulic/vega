#!/bin/sh

BASE=$(dirname $BASH_SOURCE[0])
source ${BASE}/docker.sh
source ${BASE}/utils/files.sh
source ${BASE}/utils/returns.sh
source ${BASE}/utils/strings.sh

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

function get-github-file() {
    local GITHUB_TOKEN="$1"
    local ORGANIZATION="$2"
    local REPO="$3"
    local BRANCH="$4"
    local FILE_PATH="$5"

    FILE_NAME=$(get-file-name-from-path $FILE_PATH)
    curl -H "Authorization: token $GITHUB_TOKEN" -o $FILE_NAME https://raw.githubusercontent.com/$ORGANIZATION/$REPO/$BRANCH/$FILE_PATH &>/dev/null
}

function create-github-repository() {
    local GITHUB_USERNAME="$1"
    local GITHUB_TOKEN="$2"
    local REPO_NAME="$3"
    curl --user "$GITHUB_USERNAME:$GITHUB_TOKEN" https://api.github.com/user/repos -d '{"name":"'$REPO_NAME'", "private":"true"}' &>/dev/null
}

function m2-create-project() {
    local PROJECT="$1"
    local VERSION="$2"
    local RELEASE="$3"
    local M2_CLEAN="m2-clean"
    local M2_CLEAN_WEB="m2-clean-web"

    echo "Creating a new M2 project...  "
    if [ -z "$PROJECT" ]; then
        error-exit "  ==> Failed, missing 1st argument (project name)"
    fi

    echo -n "  ==> Validating the project name... "
    PREFIX="m2-"
    if ! has-variable-prefix $PROJECT $PREFIX; then
        PROJECT="${PREFIX}${PROJECT}"
        echo "project name changed to: $PROJECT"
    else
        echo "OK"
    fi

    echo -n "  ==> Validating current directory... "
    [ "$PWD" == "/var/www" ] || error-exit "Failed, please change directory: cd /var/www/"
    echo "OK"

    echo -n "  ==> Validating that local directories don't exist... "
    WEB_REPO="$PROJECT-web"
    PROJECT_PATH="$PWD/$PROJECT"
    WEB_REPO_PATH="$PWD/$WEB_REPO"
    [ -d $PROJECT_PATH ] && error-exit "Failed, $PROJECT_PATH exists"
    [ -d $WEB_REPO_PATH ] && error-exit "Failed, $WEB_REPO_PATH exists"
    echo "OK"

    echo -n "  ==> Validating GitHub credentials... "
    GITHUB_USERNAME=$(get-github-username) || error-exit "Failed, run 'git config --global github.user <username>'"
    GITHUB_TOKEN=$(get-github-token) || error-exit "Failed, run 'git config --global github.token <token>'"
    validate-github-credentials $GITHUB_USERNAME $GITHUB_TOKEN || error-exit "Failed, incorrect credentials"
    echo "OK"

    echo -n "  ==> Validating that GitHub repositories don't exist... "
    ORGANIZATION="pivulic"
    is-github-repo $ORGANIZATION $PROJECT && error-exit "Failed, https://github.com/$ORGANIZATION/$PROJECT already exist"
    is-github-repo $ORGANIZATION $WEB_REPO && error-exit "Failed, https://github.com/$ORGANIZATION/$WEB_REPO already exist"
    echo "OK"

    echo -n "  ==> Validating Magento version... "
    VERSION=$(validate-magento-version $VERSION) || error-exit "Failed, please specify 'community-edition' or 'enterprise-edition'"
    echo "OK"

    echo -n "  ==> Cloning https://github.com/$ORGANIZATION/$M2_CLEAN_WEB to https://github.com/$ORGANIZATION/$WEB_REPO... "
    git clone "git@github.com:$ORGANIZATION/$M2_CLEAN_WEB.git" $WEB_REPO &>/dev/null || error-exit "Failed, could not clone"
    cd $WEB_REPO_PATH &>/dev/null || error-exit "Failed, could not change directory to $WEB_REPO_PATH"
    rm -rf .git || error-exit "Failed, could not remove $WEB_REPO_PATH/.git"
    git init &>/dev/null || error-exit "Failed, could not initialize git"
    git add . &>/dev/null || error-exit "Failed, could not add files to git"
    git commit -m 'Initial commit' &>/dev/null || error-exit "Failed, could not commit to git"
    create-github-repository $GITHUB_USERNAME $GITHUB_TOKEN $WEB_REPO || error-exit "Failed, could not create https://github.com/$ORGANIZATION/$WEB_REPO"
    git remote add origin git@github.com:$ORGANIZATION/$WEB_REPO.git &>/dev/null || error-exit "Failed, could not set repository origin"
    git push -u origin master &>/dev/null || error-exit "Failed, could not push to https://github.com/$ORGANIZATION/$WEB_REPO"
    echo "OK"

    echo -n "  ==> Creating and changing directory to $PROJECT_PATH... "
    mkdir $PROJECT_PATH &>/dev/null || error-exit "Failed, could not create $PROJECT_PATH"
    cd $PROJECT_PATH &>/dev/null || error-exit "Failed, could not change directory"
    echo "OK"

    echo -n "  ==> Cloning $M2_CLEAN/docker* files from GitHub... "
    M2_CLEAN_FILES=( "docker-compose.yml" "docker-cloud.yml" ".env" )
    for FILE in "${M2_CLEAN_FILES[@]}"; do
        get-github-file $GITHUB_TOKEN $ORGANIZATION "$M2_CLEAN" "master" $FILE || error-exit "Failed, could not fetch remote $FILE"
        replace-string-in-file $FILE "$M2_CLEAN" $PROJECT || error-exit "Failed, could not replace \"$M2_CLEAN\" with \"$PROJECT\" in $FILE"
    done
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
    create-github-repository $GITHUB_USERNAME $GITHUB_TOKEN $PROJECT || error-exit "Failed, could not create https://github.com/$ORGANIZATION/$PROJECT"
    echo "OK"

    echo -n "  ==> Adding files to GitHub repository... "
    git init &>/dev/null || error-exit "Failed, could not initialize git"
    git add . &>/dev/null || error-exit "Failed, could not add files to git"
    git commit -m 'Initial commit' &>/dev/null || error-exit "Failed, could not commit to git"
    git remote add origin git@github.com:$ORGANIZATION/$PROJECT.git &>/dev/null || error-exit "Failed, could not set repository origin"
    git push -u origin master &>/dev/null || error-exit "Failed, could not push to repository"
    echo "OK"

    echo "The new repositories are:"
    echo "  ==> https://github.com/$ORGANIZATION/$PROJECT"
    echo "  ==> https://github.com/$ORGANIZATION/$WEB_REPO"
    echo "DONE"
}