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

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# fuck that you have new mail shit
unset MAILCHECK

# disable core dumps
#ulimit -S -c 0

# large number of open files
# Now getting this on yosemite: http://www.openradar.appspot.com/15563096
# launchctl limit maxfiles 100000 100000

# Move to /etc/sysctl
#ulimit -S -n 100000

# default umask
umask 007

# ----------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------

# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# put ~/bin on PATH if you have it
test -d "$HOME/bin" &&
PATH="$HOME/bin:$PATH"

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

# Boot2Docker
#export DOCKER_HOST=tcp://192.168.59.103:2376
#export DOCKER_CERT_PATH=/Users/saimon/.boot2docker/certs/boot2docker-vm
#export DOCKER_TLS_VERIFY=1

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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

function parse_git_dirty {
  ([[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo -e "\033[01;31m") || echo -e "\033[01;32m"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ \1$(parse_git_dirty)/"
}

RED="$(tput bold)$(tput setaf 1)"
GREEN="$(tput bold)$(tput setaf 2)"
YELLOW="$(tput bold)$(tput setaf 3)"
NORMAL=$(tput sgr0)

function git_ps1 {

  git branch &>/dev/null

  if [ $? -eq 0 ]; then
    GIT_BRANCH=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ \1/")

    if [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]]; then
      GIT_COLOR="${RED}"
    else
      GIT_COLOR="${GREEN}"
    fi
  else
    GIT_BRANCH=""
    GIT_COLOR="${NORMAL}"
  fi

  PS1="\[\033[01;32m\]\u@\h\[\033[00m\] ${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]\[${YELLOW}\]${GIT_BRANCH}\[${GIT_COLOR}\] ▶\[${NORMAL}\] "
}

# PS1='\u@\h \[\033[1;33m\]\w\[\033[0m\]$(parse_git_branch)$ '

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]$(git branch &>/dev/null; if [ $? -eq 0 ]; then echo " \[\033[01;33m\]($(git branch | grep '^*' |sed s/\*\ //))$(parse_git_dirty)"; fi) ▶\[\033[00m\] '
    PROMPT_COMMAND=git_ps1
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
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
alias clr='clear'
alias grep='GREP_COLOR="1;37;41" LANG=C grep --color=auto'
alias g='grep'
alias l='less'
alias ec='e ~/Documents/commands.txt'
alias sz="du -sk ./* | sort -n | awk 'BEGIN{ pref[1]=\"K\"; pref[2]=\"M\"; pref[3]=\"G\";} { total = total + \$1; x = \$1; y = 1; while( x > 1024 ) { x = (x + 1023)/1024; y++; } printf(\"%g%s\t%s\n\",int(x*10)/10,pref[y],\$2); } END { y = 1; while( total > 1024 ) { total = (total + 1023)/1024; y++; } printf(\"Total: %g%s\n\",int(total*10)/10,pref[y]); }'"
alias time='gtime -f "%e %U %S %P" '

#editors
alias :e="vim"

#ruby
alias irb="irb --prompt simple"
alias be="bundle exec"

#mysql
source ~/.mysql_aliases

# Functions

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
function gitchangeset {
  git log --name-only --pretty=format:''  master..`__git_ps1 "%s"` | tr -s '\n' | uniq | sort -u
}

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

# -------------------------------------------------------------------
# USER SHELL ENVIRONMENT
# -------------------------------------------------------------------

# vim: ts=4 sts=4 shiftwidth=4 expandtab
