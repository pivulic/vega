#!/bin/bash

BASE=$(dirname ${BASH_SOURCE[0]})

alias bash-reload='source ~/.bash_profile'
alias dangling-images='docker images -qf dangling=true'
alias dangling-volumes='docker volume ls -qf dangling=true'
alias ll='ls -la'
alias q='mkdir -p ~/projects && cd ~/projects'
alias rm-all-containers=docker-rm-all-containers
alias rm-all-images='docker rmi $(docker images -q)'
alias rm-dangling-images='dangling-images | xargs docker rmi -f'
alias rm-dangling-volumes='docker volume rm $(dangling-volumes)'
alias ssh-key-copy='cat ~/.ssh/id_rsa.pub | pbcopy'
alias vega-update='cd ~/vega && git pull && bash-reload'
