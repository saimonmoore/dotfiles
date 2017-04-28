#!/bin/bash

# CD
alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias cd...='cd ../..'

# LS
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alFh'

# GIT
alias ga='git add'
alias gap='git add -p'
alias gb='git branch'
alias gc='git checkout'
alias gcl='git clone'
alias gd='git diff'
alias gdc='git diff --cached'
alias gg='git grep -n -C2 --color=always'
alias gg0='git grep -n -C0 --color=always'
alias gitroot='cd $(git rev-parse --show-cdup)'
alias gitvim='vim `git status -s | grep "[^/]$" | sed s/^...// | xargs`'
alias gl='git log'
alias gm='git commit -m'
alias gma='git commit --amend --no-edit'
alias gp='git publish'
alias gpu='git pull'
alias gr='git rebase'
alias gra='git remote add'
alias grr='git remote rm'
alias gs='git status -s'
alias gsgp='git stash && git pull origin `git branch | grep ^* |sed s/\*\ //` && git stash pop'

# SCREEN
alias sc='screen -q'
alias sd='screen -d'
alias sl='screen -ls'
alias sr='screen -r'

# UTILS
alias be='bundle exec'
alias d='docker'
alias rl='rlwrap --multi-line -a --'
alias z='zeus'
alias zc='zeus console'
alias open='xdg-open > /dev/null 2>&1'