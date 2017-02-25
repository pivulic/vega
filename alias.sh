#!/bin/sh

BASE=$(dirname $BASH_SOURCE[0])
source ${BASE}/functions/magento2.sh

alias bash-reload='source ~/.bash_profile'
alias d-composer='remove-container composer && docker run --interactive --tty --name composer --volume ~/.composer:/composer composer'
alias dangling-images='docker images -qf dangling=true'
alias dangling-volumes='docker volume ls -qf dangling=true'
alias dinghy-env='eval $(dinghy env)'
alias m2='docker-compose exec web ./bin/magento'
alias m2-install='docker-compose run --rm web-install'
alias m2-install-sampledata='docker-compose run --rm web /usr/local/bin/sample-data'
alias m2-up='docker-compose up -d web'
alias q='mkdir -p ~/projects && cd ~/projects'
alias rm-all-containers=docker-rm-all-containers
alias rm-dangling-images='dangling-images | xargs docker rmi -f'
alias rm-dangling-volumes='docker volume rm $(dangling-volumes)'
alias vega-update='cd ~/vega && git pull && bash-reload'
