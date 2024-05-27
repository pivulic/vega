#!/bin/zsh

GREEN="%F{10}"
BLUE="%F{33}"
RED="%F{9}"
YELLOW="%F{3}"
NO_COLOR="%f"

function is-k8s-prod() {
    CONTEXT=$(kubectl config current-context)
    if [[ "$CONTEXT" == *"production"* ]]; then
      echo "(k8s-prod)"
    fi
}

function is-k8s-dev() {
    CONTEXT=$(kubectl config current-context)
    if [[ "$CONTEXT" == *"development"* ]]; then
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

function get-venv-name() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "($(basename $VIRTUAL_ENV)) "
    fi
}

# Use $(...) syntax inside the prompt for Zsh
autoload -Uz vcs_info
precmd() {
    PS1="$(get-venv-name)${GREEN}%n$(is-k8s-dev)${RED}$(is-k8s-prod)${NO_COLOR}:${BLUE}%~${RED}$(has-svc-changes)${YELLOW}$(get-git-branch)${NO_COLOR} $ "
}
precmd
