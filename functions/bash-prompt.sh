#!/bin/sh

GREEN="\[\033[38;5;10m\]"
BLUE="\[\033[38;5;33m\]"
RED="\[\033[38;5;9m\]"
YELLOW="\[\033[0;33m\]"
NO_COLOR="\[\033[0m\]"

function is-k8s-prod() {
    CONTEXT=$(kubectl config current-context)
    if [[ "$CONTEXT" == *"stocksholm_us"* ]]; then
      echo "(k8s-legacy)"
    fi
    if [[ "$CONTEXT" == *"k8s-prod"* ]]; then
      echo "(k8s-prod)"
    fi
}

function is-k8s-dev() {
    CONTEXT=$(kubectl config current-context)
    if [[ "$CONTEXT" == *"k8s-dev"* ]]; then
      echo "(k8s-dev)"
    fi
}

function has-svc-changes() {
    if [[ $(hg status 2> /dev/null) ]] || [[ $(git status -s 2> /dev/null) ]] ; then
        echo "!"
    fi
}
function get-git-branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="${GREEN}\u\$(is-k8s-dev)${RED}\$(is-k8s-prod)${NO_COLOR}:${BLUE}\w${RED}\$(has-svc-changes)${YELLOW}\$(get-git-branch)${NO_COLOR} $ "