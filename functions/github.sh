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
            return 1
            ;;
    esac
}

function m2-create-project() {
    local PROJECT="$1"
    local VERSION="$2"
    local RELEASE="$3"

    echo "Creating a new M2 project...  "
    echo -n "  ==> Validating Magento version... "
    validate-magento-version $VERSION || error-exit "Failed, please specify 'community-edition' or 'enterprise-edition'"
}