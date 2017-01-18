#!/bin/sh

BASE=$(dirname $BASH_SOURCE[0])
source ${BASE}/functions/github.sh

alias bash-reload='source ~/.bash_profile'
alias d-composer='remove-container composer && docker run --interactive --tty --name composer --volume ~/.composer:/composer composer'
alias dinghy-env='eval $(dinghy env)'
alias q='cd /var/www'
alias vega-update='cd ~/vega && git pull -u && bash-reload'
