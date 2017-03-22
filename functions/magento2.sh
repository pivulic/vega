#!/bin/bash

BASE=$(dirname ${BASH_SOURCE[0]})
# shellcheck source=${BASE}/docker.sh
source ${BASE}/docker.sh
# shellcheck source=${BASE}/github.sh
source ${BASE}/github.sh
# shellcheck source=${BASE}/utils/files.sh
source ${BASE}/utils/files.sh
# shellcheck source=${BASE}/utils/returns.sh
source ${BASE}/utils/returns.sh
# shellcheck source=${BASE}/utils/strings.sh
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
        green-ok
    fi

    echo -n "  ==> Validating that local directories don't exist... "
    WEB_REPO="$PROJECT-web"
    PROJECT_PATH="$PWD/$PROJECT"
    WEB_REPO_PATH="$PWD/$WEB_REPO"
    [ -d $PROJECT_PATH ] && error-exit "Failed, $PROJECT_PATH already exists"
    [ -d $WEB_REPO_PATH ] && error-exit "Failed, $WEB_REPO_PATH already exists"
    green-ok

    echo -n "  ==> Validating GitHub credentials... "
    GITHUB_USERNAME=$(get-github-username) || error-exit "Failed, run 'git config --global github.user <username>'"
    GITHUB_TOKEN=$(get-github-token) || error-exit "Failed, run 'git config --global github.token <token>'"
    validate-github-credentials $GITHUB_USERNAME $GITHUB_TOKEN || error-exit "Failed, incorrect credentials"
    green-ok

    echo -n "  ==> Validating that GitHub repositories don't exist... "
    ORGANIZATION="pivulic"
    PROJECT_REPO_URL="https://github.com/$ORGANIZATION/$PROJECT"
    WEB_REPO_URL="https://github.com/$ORGANIZATION/$WEB_REPO"
    is-github-repo $ORGANIZATION $PROJECT && error-exit "Failed, $PROJECT_REPO_URL already exist"
    is-github-repo $ORGANIZATION $WEB_REPO && error-exit "Failed, $WEB_REPO_URL already exist"
    green-ok

    echo -n "  ==> Validating Magento version... "
    VERSION=$(validate-magento-version $VERSION) || error-exit "Failed, please specify 'community-edition' or 'enterprise-edition'"
    green-ok

    echo -n "  ==> Cloning https://github.com/$ORGANIZATION/$M2_CLEAN_WEB to $WEB_REPO_URL... "
    git clone "git@github.com:$ORGANIZATION/$M2_CLEAN_WEB.git" $WEB_REPO &>/dev/null || error-exit "Failed, could not clone"
    cd $WEB_REPO_PATH &>/dev/null || error-exit "Failed, could not change directory to $WEB_REPO_PATH"
    rm -rf .git || error-exit "Failed, could not remove $WEB_REPO_PATH/.git"
    for FILE in $(find $WEB_REPO_PATH -type f); do
        replace-string-in-file $FILE $M2_CLEAN_WEB $WEB_REPO || error-exit "Failed, could not replace \"$M2_CLEAN_WEB\" with \"$WEB_REPO\" in $FILE"
        replace-string-in-file $FILE $M2_CLEAN $PROJECT || error-exit "Failed, could not replace \"$M2_CLEAN\" with \"$PROJECT\" in $FILE"
    done
    git init &>/dev/null || error-exit "Failed, could not initialize git"
    git add . &>/dev/null || error-exit "Failed, could not add files to git"
    git commit -m 'Initial commit' &>/dev/null || error-exit "Failed, could not commit to git"
    create-github-repository $GITHUB_USERNAME $GITHUB_TOKEN $WEB_REPO || error-exit "Failed, could not create $WEB_REPO_URL"
    git remote add origin git@github.com:$ORGANIZATION/$WEB_REPO.git &>/dev/null || error-exit "Failed, could not set repository origin"
    git push -u origin master &>/dev/null || error-exit "Failed, could not push to $WEB_REPO_URL"
    green-ok

    echo -n "  ==> Creating and changing directory to $PROJECT_PATH... "
    mkdir $PROJECT_PATH &>/dev/null || error-exit "Failed, could not create $PROJECT_PATH"
    cd $PROJECT_PATH &>/dev/null || error-exit "Failed, could not change directory"
    green-ok

    echo -n "  ==> Cloning $M2_CLEAN/docker* files from GitHub... "
    M2_CLEAN_FILES=( "docker-compose.yml" "docker-sync.yml" ".env" ".gitignore" "kubernetes/database.yaml" "kubernetes/volumes.yaml" "kubernetes/web-install.yaml" "kubernetes/web.yaml" )
    mkdir "kubernetes" &>/dev/null || error-exit "Failed, could not create kubernetes/"
    for FILE in "${M2_CLEAN_FILES[@]}"; do
        get-github-file $GITHUB_TOKEN $ORGANIZATION $M2_CLEAN "master" $FILE || error-exit "Failed, could not fetch remote $FILE"
        replace-string-in-file $FILE $M2_CLEAN $PROJECT || error-exit "Failed, could not replace \"$M2_CLEAN\" with \"$PROJECT\" in $FILE"
    done
    green-ok

    echo -n "  ==> Creating M2/Composer project... "
    CONTAINER_NAME='composer'
    REPOSITORY_URL='https://repo.magento.com/'
    d-composer create-project --ignore-platform-reqs --no-scripts --repository-url=$REPOSITORY_URL magento/project-$VERSION=$RELEASE || error-exit "Failed, could not install composer"
    green-ok

    echo -n "  ==> Copying composer.* files from container... "
    docker cp $CONTAINER_NAME:/app/project-$VERSION/composer.json . || error-exit "Failed, could not copy composer.json to host'"
    docker cp $CONTAINER_NAME:/app/project-$VERSION/composer.lock . || error-exit "Failed, could not copy composer.lock to host'"
    remove-container $CONTAINER_NAME || error-exit "Failed, could not remove composer container"
    green-ok

    echo -n "  ==> Creating GitHub repository... "
    create-github-repository $GITHUB_USERNAME $GITHUB_TOKEN $PROJECT || error-exit "Failed, could not create $PROJECT_REPO_URL"
    green-ok

    echo -n "  ==> Adding files to GitHub repository... "
    git init &>/dev/null || error-exit "Failed, could not initialize git"
    git add . &>/dev/null || error-exit "Failed, could not add files to git"
    git commit -m 'Initial commit' &>/dev/null || error-exit "Failed, could not commit to git"
    git remote add origin git@github.com:$ORGANIZATION/$PROJECT.git &>/dev/null || error-exit "Failed, could not set repository origin"
    git push -u origin master &>/dev/null || error-exit "Failed, could not push to $PROJECT_REPO_URL"
    green-ok

    echo "The new repositories are:"
    echo "  ==> $PROJECT_REPO_URL"
    echo "  ==> $WEB_REPO_URL"
    green-ok "DONE"
}

function m2-build-artifact() {
    local HOSTNAME="$1"
    local PROJECT_ID="$2"
    local REPO="$3"

    if [ -z "$HOSTNAME" ]; then
        error-exit "Failed, missing 1st argument (Google Cloud hostname)"
    fi

    if [ -z "$PROJECT_ID" ]; then
        error-exit "Failed, missing 2nd argument (Google Cloud project ID)"
    fi

    if [ -z "$REPO" ]; then
        error-exit "Failed, missing 3rd argument (Google Cloud repo name)"
    fi

    docker run -it -v ~/.composer/:/var/www/.composer -v ~/.gitconfig:/var/www/.gitconfig --name $REPO $HOSTNAME/$PROJECT_ID/$REPO:default /bin/bash /usr/local/bin/build-magento

    echo -n "  ==> Copying build-artifact.tar.gz to local directory... "
    docker cp $REPO:/var/www/html/build-artifact.tar.gz ./ || error-exit "Failed, could not copy build-artifact.tar.gz"
    green-ok

    docker rm --force --volumes $REPO &>/dev/null
}