#!/bin/bash

BASE=$(dirname ${BASH_SOURCE[0]})
# shellcheck source=${BASE}/functions/magento2.sh
source ${BASE}/functions/magento2.sh

alias bash-reload='source ~/.bash_profile'
alias d-composer='remove-container composer && docker run --interactive --tty --name composer --volume ~/.composer:/composer composer'
alias dangling-images='docker images -qf dangling=true'
alias dangling-volumes='docker volume ls -qf dangling=true'
alias delete-evicted-pods-dev="kubectl get pods -n dev | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n dev"
alias delete-evicted-pods-prod="kubectl get pods -n default | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n default"
alias docker-env='eval $(docker-machine env default)'
alias ll='ls -la'
alias m2='docker-compose exec web /var/www/html/bin/magento'
alias m2-install-sampledata='docker-exec web sample-data'
alias web-composer='docker-compose exec web composer --working-dir=/var/www/html'
alias web-up='docker-compose up -d --build web'
alias q='mkdir -p ~/projects && cd ~/projects'
alias rm-all-containers=docker-rm-all-containers
alias rm-all-images='docker rmi $(docker images -q)'
alias rm-dangling-images='dangling-images | xargs docker rmi -f'
alias rm-dangling-volumes='docker volume rm $(dangling-volumes)'
alias ssh-docker=docker-exec
alias ssh-k8=kubectl-exec
alias ssh-key-copy='cat ~/.ssh/id_rsa.pub | pbcopy'
alias vega-update='cd ~/vega && git pull && bash-reload'
