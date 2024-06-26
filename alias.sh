#!/bin/zsh

alias bash-reload='source ~/.zshrc'
alias dangling-images='docker images -qf dangling=true'
alias dangling-volumes='docker volume ls -qf dangling=true'
alias ll='ls -la'
alias q='mkdir -p ~/projects && cd ~/projects'
alias rm-all-containers=docker-rm-all-containers
alias rm-all-images='docker rmi $(docker images -q)'
alias rm-dangling-images='dangling-images | xargs docker rmi -f'
alias rm-dangling-volumes='docker volume rm $(dangling-volumes)'
alias ssh-key-copy='cat ~/.ssh/id_ed25519.pub | pbcopy'
alias vega-update='cd ~/vega && git pull && bash-reload'
