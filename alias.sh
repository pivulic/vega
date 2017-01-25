#!/bin/sh

BASE=$(dirname $BASH_SOURCE[0])
source ${BASE}/functions/github.sh

alias bash-reload='source ~/.bash_profile'
alias d-composer='remove-container composer && docker run --interactive --tty --name composer --volume ~/.composer:/composer composer'
alias dangling-images='docker images -qf dangling=true'
alias dinghy-env='eval $(dinghy env)'
alias docker-rm-all=docker-rm-all-containers
alias m2-web-install='docker-compose run --rm web-install'
alias m2-web-up='docker-compose up -d web'
alias q='cd /var/www'
alias rm-dangling-images='dangling-images | xargs docker rmi -f'
alias vega-update='cd ~/vega && git pull -u && bash-reload'
