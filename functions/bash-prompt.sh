#!/bin/sh

GREEN="\[\033[38;5;10m\]"
BLUE="\[\033[38;5;33m\]"
YELLOW="\[\033[0;33m\]"
NO_COLOR="\033[0m"

function get-git-branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
function get-hg-branch() {
    hg branch 2> /dev/null | sed -e "s/\(.*\)/ (\1)/"
}

export PS1="${GREEN}\u@\h${NO_COLOR}:${BLUE}\w${YELLOW}\$(get-git-branch)\$(get-hg-branch)${NO_COLOR}\\$ "