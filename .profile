#!/bin/bash
#
# Saimon Moore <http://saimonmoore.net> (with help from the internets).

# the basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# complete hostnames from this file
: ${HOSTFILE=~/.ssh/known_hosts}

# readline config
: ${INPUTRC=~/.inputrc}

# ----------------------------------------------------------------------
#  SHELL OPTIONS
# ----------------------------------------------------------------------

# bring in system bashrc
test -r /etc/bashrc &&
      . /etc/bashrc

# notify of bg job completion immediately
set -o notify

# http://www.catonmat.net/download/bash-vi-editing-mode-cheat-sheet.pdf
# vi mode
set -o vi

# shell opts. see bash(1) for details
# shopt -s autocd >/dev/null 2>&1
shopt -s cdspell >/dev/null 2>&1
shopt -s checkjobs >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1
#bash4
shopt -s globstar >/dev/null 2>&1

# fuck that you have new mail shit
unset MAILCHECK

# disable core dumps
ulimit -S -c 0

# default umask
umask 0022

# ----------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------

# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# put ~/bin on PATH if you have it
test -d "$HOME/bin" &&
PATH="$HOME/bin:$PATH"

# put ~/Development/bin on PATH if you have it
test -d "$HOME/Development/bin" &&
PATH="$HOME/Development/bin:$PATH"

# put vmware fusion bin on PATH if you have it
test -d "/Library/Application Support/VMware Fusion/" &&
PATH="/Library/Application Support/VMware Fusion/:$PATH"

# put android tools bin on PATH if you have it
test -d "~/Development/OpenSource/android-sdk-mac_x86/tools" &&
PATH="~/Development/OpenSource/android-sdk-mac_x86/tools:$PATH"

test -d "~/Development/OpenSource/github/phonegap/android/bin" &&
PATH="~/Development/OpenSource/github/phonegap/android/bin:$PATH"

test -d "~/local/bin" &&
PATH="~/local/bin:$PATH"

test -d "/usr/local/lib/node_modules" &&
PATH="/usr/local/lib/node_modules:$PATH"

test -d "~/node_modules/.bin" &&
PATH="~/node_modules/.bin:$PATH"

test -d "/usr/local/Cellar/python/2.7/bin" &&
PATH="/usr/local/Cellar/python/2.7/bin:$PATH"

# put ~/.bundle/bin on PATH if you have it
# test -d "$HOME/.bundle/ruby/1.8/bin" &&
# PATH="$HOME/.bundle/ruby/1.8/bin:$PATH"

# ----------------------------------------------------------------------
# ENVIRONMENT CONFIGURATION
# ----------------------------------------------------------------------

# detect interactive shell
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
    -*) LOGIN=yes ;;
    *)  unset LOGIN ;;
esac

# enable en_US locale w/ utf-8 encodings if not already configured
export LANG="en_US.UTF-8"
export LANGUAGE="en"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# always use PASSIVE mode ftp
: ${FTP_PASSIVE:=1}
export FTP_PASSIVE

# ignore backups, CVS directories, python bytecode, vim swap files
FIGNORE="~:CVS:#:.pyc:.swp:.swa:apache-solr-*"
# Bash History Settings
# HISTCONTROL=erasedups
HISTCONTROL=ignoreboth
HISTSIZE=10000
# HISTIGNORE="&:ls:[ \t]*:[bf]g:exit:stealth"
HISTIGNORE="&:ls:[bf]g:exit:stealth:fg*"
# bind '"\C-f": "fg %-\n"'
# bind '"\\C-o": "open "$(pbpaste)""'
# bind '"\\C-g": "open http://google.com/search?q=$(pbpaste)"'

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

LD_LIBRARY_PATH=/usr/local/lib/:/opt/local/lib:/opt/usr/lib

MANPATH=`/usr/bin/manpath`:~/local/share/man:/usr/local/share/man

#https://wincent.com/issues/1558
TERM=xterm-color

SSH_ENV=$HOME/.ssh/environment

#For X11
# DISPLAY=:0.0

# rubygems
# export RUBYOPT="rubygems"

test -r ~/.amazon_keys &&
      . ~/.amazon_keys

export RESTCLIENT_LOG=stdout
export HACKER_GEMS_HOST=hackergems.net
# ----------------------------------------------------------------------
# PAGER / EDITOR
# ----------------------------------------------------------------------

# See what we have to work with ...
HAVE_VIM=$(command -v vim)
HAVE_GVIM=$(command -v gvim)

# EDITOR
test -n "$HAVE_VIM" &&
EDITOR="vim -f" ||
EDITOR=vi
export EDITOR

SVN_EDITOR=$EDITOR
GIT_EDITOR=$EDITOR
TEXEDIT='$EDITOR +%d %s'
LESSEDIT='$EDITOR ?lm+%lm. %f'
export LESS='-R'

# PAGER
if test -n "$(command -v less)" ; then
    PAGER="less -FirSwX"
    MANPAGER="less -FiRswX"
else
    PAGER=more
    MANPAGER="$PAGER"
fi
export PAGER MANPAGER

# Ack
ACK_PAGER="$PAGER"

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

RED="\[\033[0;31m\]"
BROWN="\[\033[0;33m\]"
GREY="\[\033[0;97m\]"
BLUE="\[\033[0;34m\]"
PS_CLEAR="\[\033[0m\]"
SCREEN_ESC="\[\033k\033\134\]"

if [ "$LOGNAME" = "root" ]; then
    COLOR1="${RED}"
    COLOR2="${BROWN}"
    P="#"
elif hostname | grep -q 'teambox\.com'; then
    TEAMBOX=yep
    COLOR1="\[\e[0;94m\]"
    COLOR2="\[\e[0;92m\]"
    P="\$"
else
    COLOR1="${BLUE}"
    COLOR2="${BROWN}"
    P="\$"
fi

prompt_simple() {
    unset PROMPT_COMMAND
    PS1="[\u@\h:\w]\$ "
    PS2="> "
}

prompt_compact() {
    unset PROMPT_COMMAND
    PS1="${COLOR1}${P}${PS_CLEAR} "
    PS2="> "
}

prompt_color() {
    PS1="${GREY}[${COLOR1}\u${GREY}@${COLOR2}\h${GREY}:${COLOR1}\W${GREY}]${COLOR2}$P${PS_CLEAR} "
    PS2="\[[33;1m\]continue \[[0m[1m\]> "
}

#prompt
# activate once git has installed
# export PS1='\u@\h \W$(__git_ps1 " (%s)")\$ '
#includes current ruby and git branch

prompt_git() {
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
    # PS1='[\h \W$(__git_ps1 " (%s)")]\$ ';
    # PS1="\u@\h \W$(__git_ps1 '(%s)') $ "
    PS1='\u@\h \W$(__git_ps1 " (%s)")\$ '
  fi
}

# ----------------------------------------------------------------------
# MACOS X / DARWIN SPECIFIC
# ----------------------------------------------------------------------

if [ "$UNAME" = Darwin ]; then
    # put ports on the paths if /opt/local exists
    test -x /opt/local -a ! -L /opt/local && {
        PORTS=/opt/local

        # setup the PATH and MANPATH
        PATH="$PATH:$PORTS/bin:$PORTS/sbin"
        MANPATH="$MANPATH:$PORTS/share/man"

        # nice little port alias
        alias port="sudo nice -n +18 $PORTS/bin/port"
    }

    test -x /usr/pkg -a ! -L /usr/pkg && {
        PATH=":$PATH:/usr/pkg/sbin:/usr/pkg/bin"
        MANPATH="$MANPATH:/usr/pkg/share/man"
    }

    # setup java environment. puke.
    JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
    export JAVA_HOME

    alias portscan="/Applications/Utilities/Network\ Utility.app/Contents/Resources/stroke"

fi

# ----------------------------------------------------------------------
# ALIASES / FUNCTIONS
# ----------------------------------------------------------------------

#tmux
# alias tmux="TERM=screen-256color-bce tmux"

#clear
alias cl=clear
#Navigation
alias u='cd ..'
alias h='cd ~'
alias pop='popd'

# changing directory to code project
function c { cd ~/Development/Clients/Teambox/$1; }
function cps { cd ~/Development/Projects/$1; }
function cgh { cd ~/Development/OpenSource/github/$1; }
function cfk { cd ~/Development/OpenSource/forks/$1; }

#bash
# disk usage with human sizes and minimal depth
alias du1='du -h --max-depth=1'
alias duf='du -kd 1 | sort -nr | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'
alias fn='find . -name'
alias p="ps axww | grep "
alias px="ps -ax -m -o pid,%cpu,rss,command | grep "
alias k="kill -9"
alias r="history | grep"
alias eb="$EDITOR ~/.profile"
alias ab="source ~/.profile"
alias eh="sudo $EDITOR /etc/hosts"
alias ah="sudo dscacheutil -flushcache" #leopard
alias clr='clear'
alias grep='GREP_COLOR="1;37;41" LANG=C grep --color=auto'
alias g='grep'
alias l='less'
alias ec='e ~/Documents/commands.txt'
alias sz="du -sk ./* | sort -n | awk 'BEGIN{ pref[1]=\"K\"; pref[2]=\"M\"; pref[3]=\"G\";} { total = total + \$1; x = \$1; y = 1; while( x > 1024 ) { x = (x + 1023)/1024; y++; } printf(\"%g%s\t%s\n\",int(x*10)/10,pref[y],\$2); } END { y = 1; while( total > 1024 ) { total = (total + 1023)/1024; y++; } printf(\"Total: %g%s\n\",int(total*10)/10,pref[y]); }'"
alias time='gtime -f "%e %U %S %P" '
alias bi='bundle install'
#for tests
alias bit='bundle install --standalone'

#Grwol notifications
function growl() { echo -e $'\e]9;'${*}'\007' ; return ; }

#editors
alias tm=mate
alias tmw="tm -w "
alias :e="vim"

# osx
alias ql="qlmanage -p 2>/dev/null"
alias preview='open -a Preview -f'

#projects
alias pr="cd ~/Development/Projects"
alias fr="cd ~/Development/Clients"
alias os="cd ~/Development/OpenSource"
alias ghb="cd ~/Development/OpenSource/github"
alias gfk="cd ~/Development/OpenSource/forks"

#ruby
alias irb="irb --prompt simple"
alias bspec="bundle exec spec"
alias brspec="bundle exec rspec --format Fuubar --color "
alias bcucumber="bundle exec cucumber"
alias brake="bundle exec rake"
alias birb="bundle exec irb"
alias be="bundle exec"
alias rsh='git remote update && git rebase hosted/hosted && bundle && cleardb && rails s'
alias rsd='git remote update && git rebase orign/dev && bundle && cleardb && rails s'
alias z=zeus

function cleardb {
  DEVDB="`ruby -e "require 'yaml'; puts YAML.load(File.open('config/database.yml'))['development']['database']"`" 
  if [[ $DEVDB =~ "production" ]]; then
      echo 'WATCHOUT! cleardb running against production dump';
  else
    bundle exec rake db:drop db:create db:schema:load db:seed && bundle exec rake db:test:clone;
  fi
}

#bash
alias logclear='for l in $(ls log/*.log); do > $l; done'
alias slogclear="echo 'for l in \$(ls log/*.log); do > $l; done' | sudo sh"

function bo {
  if [ -z "$1" ]; then
      bundle open $(git log -n 1 -p -- Gemfile | egrep "^\+ " | awk '{print $3}' | sed "s/'//g" | sed "s/,//g") &> /dev/null &
  else
    bundle open $1 &> /dev/null &
  fi
}

function loopc {
  args=("$@")

  if [ $1 -ge 0 2>/dev/null ]
  then
    LIMIT=$1
    unset args[0]
  else
    LIMIT=5
  fi

  for i in $(eval echo "{1..$LIMIT}"); do
    $(eval echo "${args[@]}");
  done
}

#ssh
alias pssh="ssh -p 8888 "
alias pscp="scp -P 8888 "
alias tunnel='ssh -D 8888 -f -C -q -N'

# Subversion
alias sup='svn update'
alias sst='svn status'
alias sco='svn commit'
alias sd='svn diff | gedit'
alias slog='svn log | less'
alias sex='svn export'
alias signore='svn propedit svn:ignore'
alias sexternal='svn propedit svn:externals'

# Rails
alias ss='./script/server'
alias sc='./script/console'
alias sg='./script/generate'
alias sp='./script/plugin'
alias migrate='rm -f db/*sqlite3 && rake db:migrate db:test:clone'

function irp {
  if [ -z "$1" ]; then
    pry -r ./config/environment RAILS_ENV=development
  else
    pry -r ./config/environment RAILS_ENV=$1
  fi
}

# Git
if test -n "$(command -v hub)" ; then
  alias git='hub'
fi
alias gplr='git pull --rebase'
alias gpl='git pull'
alias gp='git push'
alias gd='git diff'
alias gdc='git diff --cached'
alias gde='gd | $EDITOR'
alias gdce='gdc | $EDITOR'
alias gc='git commit -v'
alias gcp='git cherry-pick'
alias gca='git commit -va'
alias gb='git branch -v'
alias gss='git status -sb'
alias grm="git status | grep deleted | awk '{print $3}' | xargs git rm"
alias gscore='git log --numstat | awk -f /Users/saimon/bin/git_score.awk'
alias ga='git add'
alias gs='git status'
alias gps='git push'
alias gsh='git show'
alias gchtb4='git checkout master && git remote update && git rebase origin/master'

function gch {
  if [ -z "$1" ]; then
    git checkout master
  else
    git checkout $1
  fi
}

alias gm='git merge'
alias gl='git log'
alias gld='git log --oneline --decorate'
alias gri="git rebase --interactive --autosquash"
alias grm='git rebase master'
alias gnp='git-notpushed'
alias gh='git log --pretty=format:"%ai %s [%an]" > HISTORY'
alias fcm='git rev-list master |tail -n 1'
alias lcm='git rev-parse HEAD'
alias gfm="git status | grep modified | awk '{print \$3}' | head -n"
alias rmcachedassets="gs | grep public | awk '{print \$2}' | xargs rm"

function git_id { 
  printf 'blob %s\0' "$(ls -l "$1" | awk '{print $5;}')" | cat - "$1" | sha1sum | awk '{print $1}'; 
}

#redis
alias start_redis='launchctl load -w ~/Library/LaunchAgents/io.redis.redis-server.plist'
alias stop_redis='launchctl unload -w ~/Library/LaunchAgents/io.redis.redis-server.plist'
alias restart_redis='launchctl unload -w ~/Library/LaunchAgents/io.redis.redis-server.plist; sudo launchctl load -w ~/Library/LaunchAgents/io.redis.redis-server.plist'

#memcached
alias start_memcached='launchctl load -w ~/Library/LaunchAgents/com.danga.memcached.plist'
alias stop_memcached='launchctl unload -w ~/Library/LaunchAgents/com.danga.memcached.plist'
alias restart_memcached='launchctl unload -w ~/Library/LaunchAgents/com.danga.memcached.plist; launchctl load -w ~/Library/LaunchAgents/com.danga.memcached.plist'

#nginx
alias start_nginx='sudo launchctl load -w ~/Library/LaunchAgents/org.nginx.plist'
alias stop_nginx='sudo launchctl unload -w ~/Library/LaunchAgents/org.nginx.plist'
alias restart_nginx='sudo launchctl unload -w ~/Library/LaunchAgents/org.nginx.plist; sudo launchctl load -w ~/Library/LaunchAgents/org.nginx.plist'

#elasticsearch
alias start_elastic='launchctl load -wF ~/Library/LaunchAgents/org.elasticsearch.plist'
alias stop_elastic='launchctl unload -wF ~/Library/LaunchAgents/org.elasticsearch.plist'
alias restart_elastic='stop_elastic;start_elastic'

#mysql
source ~/.mysql_aliases

#rhino
alias js="java org.mozilla.javascript.tools.shell.Main"
alias jsbeautify="java org.mozilla.javascript.tools.shell.Main /Users/saimon/Development/bin/js-beautify/beautify-cl.js"

#node
#TODO: Use /usr/local/bin
alias noderb="rlwrap ~/local/bin/node-repl"

#Virtual Machines
#vmware
alias vmfairup="vmrun -T fusion start ~/Documents/Virtual\ Machines.localized/officialfmvm.vmwarevm/generaldev.vmx nogui"
alias vmfairdown="vmrun -T fusion suspend ~/Documents/Virtual\ Machines.localized/officialfmvm.vmwarevm/generaldev.vmx nogui"
alias vmfairstatus="vmrun -T fusion list ~/Documents/Virtual\ Machines.localized/officialfmvm.vmwarevm/generaldev.vmx nogui"
alias vmfairssh="ssh vagrant@fairvm"

alias vmofmup="vmrun -T fusion start ~/Documents/Virtual\ Machines.localized/officialfmvm64.vmwarevm/Ubuntu\ 10.04\ server\ 64-bit.vmx nogui"
alias vmofmdown="vmrun -T fusion suspend ~/Documents/Virtual\ Machines.localized/officialfmvm64.vmwarevm/Ubuntu\ 10.04\ server\ 64-bit.vmx nogui"
alias vmofmstatus="vmrun -T fusion list ~/Documents/Virtual\ Machines.localized/officialfmvm64.vmwarevm/Ubuntu\ 10.04\ server\ 64-bit.vmx nogui"
alias vmofmssh="ssh vagrant@ofmvm"


alias vmbootstripup="vmrun -T fusion start ~/Documents/Virtual\ Machines.localized/bootstripdev.vmwarevm/generaldev.vmx nogui"
alias vmbootstripdown="vmrun -T fusion suspend ~/Documents/Virtual\ Machines.localized/bootstripdev.vmwarevm/generaldev.vmx nogui"
alias vmbootstripstatus="vmrun -T fusion list ~/Documents/Virtual\ Machines.localized/bootstripdev.vmwarevm/generaldev.vmx nogui"
alias vmbootstripssh="ssh vagrant@bootstripvm"

alias vmdevup="vmrun -T fusion start ~/Documents/Virtual\ Machines.localized/generaldev.vmwarevm/generaldev.vmx nogui"
alias vmdevdown="vmrun -T fusion suspend ~/Documents/Virtual\ Machines.localized/generaldev.vmwarevm/generaldev.vmx nogui"
alias vmdevstatus="vmrun -T fusion list ~/Documents/Virtual\ Machines.localized/generaldev.vmwarevm/generaldev.vmx nogui"
alias vmdevssh="ssh vagrant@devvm"

#virtualbox
alias vbfairup="pushd ~/Development/Clients/fairtilizer/fair2; bundle exec vagrant resume; popd"
alias vbfairdown="pushd ~/Development/Clients/fairtilizer/fair2; bundle exec vagrant suspend; popd"
alias vbfairssh="pushd ~/Development/Clients/fairtilizer/fair2; bundle exec vagrant ssh; popd"
alias vbbootstripup="pushd ~/Development/Projects/bootstrip/src; bundle exec vagrant resume; popd"
alias vbbootstripdown="pushd ~/Development/Projects/bootstrip/src; bundle exec vagrant suspend; popd"
alias vbbootstripssh="pushd ~/Development/Projects/bootstrip/src; bundle exec vagrant ssh; popd"

#teambox
alias diffprod='git diff $(ey ssh "cat /data/Teambox2/current/REVISION" -e hosted)..'
function checkhosted { 
  export HOSTED=$(ey ssh "cat /data/Teambox2/current/REVISION" -e hosted); echo $HOSTED;
}

function exechosted {
  ey ssh "cd /data/Teambox2/current; RAILS_ENV=production bundle exec rails runner '$1'" -e hosted
}

alias tb4_console="ssh -t $($1|echo 'tb4-utility') 'cd /data/teambox/current; make console'"
alias infojobs_console="ssh -t $($1|echo 'infojobs1') 'cd /data/teambox/current; bundle exec rails c'"

# Functions

# usage:
#   $ superblame Mislav [<from>..<to>]
function superblame {
  git log --format=%h --author=$1 $2 | \
    xargs -L1 -ISHA git diff --shortstat 'SHA^..SHA' app config/environment* config/initializers/ public/stylesheets/ | \
    ruby -e 'n=Hash.new(0); while gets; i=0; puts $_.gsub(/\d+/){ n[i+=1] += $&.to_i }; end' | tail -n1
}

#Commented as now using osx keychain: http://www.dribin.org/dave/blog/archives/2007/11/28/ssh_agent_leopard/
# function start_agent {
#      echo "Initializing new SSH agent..."
#      /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
#      echo succeeded
#      chmod 600 ${SSH_ENV}
#      . ${SSH_ENV} > /dev/null
#      /usr/bin/ssh-add;
# }

# # Source SSH settings, if applicable
# if [ -f "${SSH_ENV}" ]; then
#      . ${SSH_ENV} > /dev/null
#      ps -x | grep "^ *${SSH_AGENT_PID}" | grep ssh-agent$ > /dev/null || {
#          start_agent;
#      }
# else
#      start_agent;
# fi

#rvm
function rvmd() {
	rvm use $1 --default
}

#crypt
function encryptaes()
{
  openssl enc -e -aes128 -base64 -in $2 -pass "pass:$1"
}

function decryptaes()
{
  openssl enc -d -aes128 -base64 -in $2 -pass "pass:$1"
}

function stealth() { "$@"; }

# Lists all files modified in current branch since it forked from master
# search for changes only within file changed in this branch
# Usage: rak 'query' `git-changeset`
function git-changeset {
  git log --name-only --pretty=format:''  master..`__git_ps1 "%s"` | tr -s '\n' | uniq | sort -u
}

function gchm() {
  sh -c "rake git:branch:checkout_with_migrations[$1]"
}

function rjson() {
  wget $1 -O - --quiet | ruby -rubygems -e 'require "json"; puts JSON.parse($stdin.gets).to_yaml'
}

function s() {
  cd ~/Development/$1
  screen -Uc ~/.screenrc -S dev@artemis
}

# Usage: rename_ext php html
rename_ext() {
   local filename
   for filename in *."$1"; do
     mv "$filename" "${filename%.*}"."$2"
   done
}

mvf() {
if  mv "$@"; then
  shift $(($#-1))
  if [ -d $1 ]; then
    cd ${1}
  else
    cd `dirname ${1}`
  fi
fi
}

###   Handy Extract Program
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1        ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xvf $1        ;;
            *.tbz2)      tar xvjf $1      ;;
            *.tgz)       tar xvzf $1       ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1    ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Get the current revision of a repository
srev()
{
  svn info $@ | awk '/^Revision:/ {print $2}'
}

# Does an svn up and then displays the changelog between your previous
# version and what you just updated to.
sup_log()
{
  local old_revision=`srev $@`
  local first_update=$((${old_revision} + 1))
  svn up -q $@
  if [ $(srev $@) -gt ${old_revision} ]; then
    svn log -v -rHEAD:${first_update} $@
  else
    echo "No changes."
  fi
}


# push SSH public key to another box
push_ssh_cert() {
    local _host
    test -f ~/.ssh/id_dsa.pub || ssh-keygen -t dsa
    for _host in "$@";
    do
        echo $_host
        ssh $_host 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_dsa.pub
    done
}



# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------

test -z "$BASH_COMPLETION" && {
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    test -n "$PS1" && test $bmajor -gt 1 && {
        # search for a bash_completion file to source
        for f in /usr/local/etc/bash_completion \
                 /usr/pkg/etc/bash_completion \
                 /opt/local/etc/bash_completion \
                 /etc/bash_completion
        do
            test -f $f && {
                . $f
                break
            }
        done
    }
    unset bash bmajor bminor
}

# override and disable tilde expansion
_expand() {
    return 0
}

# tab completion for ssh hosts
# http://drawohara.tumblr.com/post/6584031
SSH_COMPLETE=( $(cat ~/.ssh/known_hosts | \
                 cut -f 1 -d ' ' | \
                 sed -e s/,.*//g | \
                 sed -e s/[]:8\[]*//g | \
                 sed s/:\d+//g | \
                 uniq | egrep -v [01234456789]) )

complete -o default -W "${SSH_COMPLETE[*]}" ssh
complete -o default -W "${SSH_COMPLETE[*]}" pssh

_complete_git() {
  if [ -d .git ]; then
    branches=`git branch -a | cut -c 3-`
    tags=`git tag`
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${branches} ${tags}" -- ${cur}) )
  fi
}

complete -F _complete_git gch

source ~/dotfiles/completion_scripts/git_completion
complete -C ~/dotfiles/completion_scripts/rake_completion -o default rake
complete -C ~/dotfiles/completion_scripts/client_completion -o default c
complete -C ~/dotfiles/completion_scripts/project_completion -o default cps
complete -C ~/dotfiles/completion_scripts/github_completion -o default cgh
complete -C ~/dotfiles/completion_scripts/forks_completion -o default cfk
complete -C ~/dotfiles/completion_scripts/capistrano_completion -o default cap


_hackergemscomplete() {
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    languages="`hacker_gems gems:languages | xargs`"
    tags="`hacker_gems gems:tags | xargs`"

    if [ "${prev}" = "hacker_gems" ]; then
      COMPREPLY=($(compgen -W "${languages}" -- ${cur}))  
      return 0
    else
	  COMPREPLY=( $(compgen -W "${tags}" -- ${cur}) )
      return 0
    fi
}
complete -o default -o nospace -F _hackergemscomplete hacker_gems

# ----------------------------------------------------------------------
# LS AND DIRCOLORS
# ----------------------------------------------------------------------

# we always pass these to ls(1)
LS_COMMON="-hBG"

# if the dircolors utility is available, set that up to
dircolors="$(type -P gdircolors dircolors | head -1)"
test -n "$dircolors" && {
    COLORS=/etc/DIR_COLORS
    test -e "/etc/DIR_COLORS.$TERM"   && COLORS="/etc/DIR_COLORS.$TERM"
    test -e "$HOME/.dircolors"        && COLORS="$HOME/.dircolors"
    test ! -e "$COLORS"               && COLORS=
    eval `$dircolors --sh $COLORS`
}
unset dircolors

# setup the main ls alias if we've established common args
test -n "$LS_COMMON" &&
alias ls="command ls $LS_COMMON"

# these use the ls aliases above
alias ll='ls -lhG'
alias l.="ls -d .*"
# alias ls='ls -FG'
alias la='ls -A'
alias lx='ls -X'
alias ssu='bundle exec unicorn -c ~/.unicorn_dev.rb -E development -l 3000 -D'
alias ssud='bundle exec unicorn -d -c ~/.unicorn_dev.rb -E development -l 3000 -D'



# -------------------------------------------------------------------
# USER SHELL ENVIRONMENT
# -------------------------------------------------------------------

# Use the color prompt by default when interactive
test -n "$PS1" &&
prompt_git

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export RBENV_VERSION='1.9.3-p327-perf'
# vim: ts=4 sts=4 shiftwidth=4 expandtab
