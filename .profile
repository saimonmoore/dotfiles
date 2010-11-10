#
#stty erase

# Setting the path for MacPorts.
# Using homebrew
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
# export PATH=/opt/local/bin:/opt/local/sbin:/opt/usr/bin:$PATH
# export PATH=/opt/local/lib/postgresql82/bin:/opt/local/lib/mysql5/bin:/WebKit/WebKitTools/Scripts:$PATH
export PATH=~/Development/bin:$PATH
export PATH=$PATH:"/Library/Application Support/VMware Fusion/"
# export PATH=$PATH:"/opt/android-sdk-mac_x86-1.5_r2/tools"
export PATH=$PATH:"/opt/PalmSDK/Current/bin"

export PATH=$PATH:~/.gem/ruby/1.8/bin

export PATH=$PATH:~/Development/OpenSource/android-sdk-mac_x86/tools
export PATH=$PATH:~/Development/OpenSource/github/phonegap/android/bin
export PATH=$HOME/local/bin:$PATH
export NODE_PATH="~/local/lib/node"

# rubygems
# export RUBYOPT="rubygems"

source ~/.amazon_keys

# tcl
# export TCLLIBPATH=/opt/local/lib/tcl8.5

#Macports doesn't setup manpath correctly
export MANPATH=`/usr/bin/manpath`:~/local/share/man

#Setting the lib path for compiled packages
#Using homebrew
# export LD_LIBRARY_PATH=/opt/local/lib:/opt/usr/lib

#Setting to UTF8
# export LC_ALL=es_ES.UTF-8
# export LC_CTYPE=es_ES.UTF-8

#https://wincent.com/issues/1558
export TERM=xterm-color


#from: http://smartic.us/2010/10/27/tune-your-ruby-enterprise-edition-garbage-collection-settings-to-run-tests-faster/
#needs ree
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000

#For X11
# # export DISPLAY=:0.0

# Bash History Settings
export HISTCONTROL=erasedups
export HISTSIZE=10000
# export HISTIGNORE="&:ls:[ \t]*:[bf]g:exit:stealth"
export HISTIGNORE="&:ls:[bf]g:exit:stealth:fg*"
bind '"\C-f": "fg %-\n"'
# bind '"\\C-o": "open "$(pbpaste)""'
# bind '"\\C-g": "open http://google.com/search?q=$(pbpaste)"'

shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

#prompt
# activate once git has installed
# export PS1='\u@\h \W$(__git_ps1 " (%s)")\$ '
#includes current ruby and git branch
export PS1="\u@\h \W\$(~/.rvm/bin/rvm-prompt)\$(__git_ps1 '(%s)') $ "


# Lists all files modified in current branch since it forked from master
# search for changes only within file changed in this branch
# Usage: rak 'query' `git-changeset`
function git-changeset {
  git log --name-only --pretty=format:''  master..`__git_ps1 "%s"` | tr -s '\n' | uniq | sort -u
}

#Generic editor
# export EDITOR='mate -w'
export EDITOR='vim'
# export SVN_EDITOR='mate -w'
export SVN_EDITOR='vim'
# export GIT_EDITOR='mate -wl1'
export GIT_EDITOR='vim'
# export TEXEDIT='mate -w -l %d "%s"'
export TEXEDIT='vim +%d %s'
# export LESSEDIT='mate -l %lm %f'
export LESSEDIT='vim ?lm+%lm. %f'


SSH_ENV=$HOME/.ssh/environment

function start_agent {
     echo "Initializing new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
     echo succeeded
     chmod 600 ${SSH_ENV}
     . ${SSH_ENV} > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
     . ${SSH_ENV} > /dev/null
     ps -x | grep "^ *${SSH_AGENT_PID}" | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi

#Aliases
#ls
alias ls='ls -FG'
alias ll='ls -lhG'
alias la='ls -A'
alias lsd='ls -d */'
alias lx='ls -X'

#Navigation
alias u='cd ..'
alias h='cd ~'

#projects
alias pr="cd ~/Development/Projects"
alias fr="cd ~/Development/Clients"
alias os="cd ~/Development/OpenSource"
alias ghb="cd ~/Development/OpenSource/github"
alias gfk="cd ~/Development/OpenSource/forks"

alias rbmine="/Applications/RubyMine\ 2.0.app/Contents/MacOS/rubymine > /dev/null 2> /dev/null &"

#ruby
alias rb="ruby"
alias irb="irb --prompt simple"
alias tm=mate
alias tmw="tm -w "
# alias e=mate
alias e='vim'

# nginx/passenger/rvm
# wrappers around rvm to copy current ruby path location to ~/.rvm_ruby_binary
# This file is used inside ruby wrapper to report the current ruby interpreter to use for phusion passenger.
alias enginxportfile="mate -w /opt/local/var/macports/sources/rsync.macports.org/release/ports/www/nginx/Portfile"

alias start_nginx='launchctl load -w ~/Library/LaunchAgents/org.nginx.plist'
alias stop_nginx='launchctl unload -w ~/Library/LaunchAgents/org.nginx.plist'
alias restart_nginx='launchctl unload -w ~/Library/LaunchAgents/org.nginx.plist; launchctl load -w ~/Library/LaunchAgents/org.nginx.plist'

alias start_nginx19='sudo launchctl load -w /Library/LaunchDaemons/net.nginx-ruby-1.9.plist'
alias stop_nginx19='sudo launchctl unload -w /Library/LaunchDaemons/net.nginx-ruby-1.9.plist'
alias restart_nginx19='sudo launchctl unload -w /Library/LaunchDaemons/net.nginx-ruby-1.9.plist; sudo launchctl load -w /Library/LaunchDaemons/net.nginx-ruby-1.9.plist'

alias start_nginx192='sudo launchctl load -w /Library/LaunchDaemons/net.nginx-ruby-1.9.2.plist'
alias stop_nginx192='sudo launchctl unload -w /Library/LaunchDaemons/net.nginx-ruby-1.9.2.plist'
alias restart_nginx192='sudo launchctl unload -w /Library/LaunchDaemons/net.nginx-ruby-1.9.2.plist; sudo launchctl load -w /Library/LaunchDaemons/net.nginx-ruby-1.9.2.plist'

alias start_redis='sudo launchctl load -w /Library/LaunchDaemons/antirez.redis.plist'
alias stop_redis='sudo launchctl unload -w /Library/LaunchDaemons/antirez.redis.plist'
alias restart_redis='sudo launchctl unload -w /Library/LaunchDaemons/antirez.redis.plist; sudo launchctl load -w /Library/LaunchDaemons/antirez.redis.plist'

#any other rubies, follow this pattern
#alias passenger-fair2-ruby="source ~/.profile ; rvm 1.9.1%fair2 ; echo \$rvm_ruby_binary > ~/.rvm_ruby_binary; echo '$(gem env gemdir)' > ~/.rvm_gem_dir; nginx-set-passenger-gem-dir; restart_nginx"
#alias passenger-bootstrip-ruby="source ~/.profile ; rvm ree-1.8.7%bootstrip ; echo \$rvm_ruby_binary > ~/.rvm_ruby_binary; echo '$(gem env gemdir)' > ~/.rvm_gem_dir; nginx-set-passenger-gem-dir; restart_nginx"
#only system ruby
#alias passenger-system-ruby="source ~/.profile ; rvm system ; echo '$(which ruby)' > ~/.rvm_ruby_binary; echo '$(gem env gemdir)' > ~/.rvm_gem_dir; GEM_PATH=$(gem env gemdir); nginx-set-passenger-gem-dir; restart_nginx"
#alias nginx-set-passenger-gem-dir='sudo sed "s:passenger_root.*;:passenger_root $GEM_PATH\/gems\/passenger-2.2.5;:g" /opt/local/etc/nginx/nginx.conf > /tmp/nginx_sed.conf && sudo mv /tmp/nginx_sed.conf /opt/local/etc/nginx/nginx.conf'

#mysql
source ~/.mysql_aliases

alias start_mysql='sudo launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist'
alias stop_mysql='sudo launchctl unload -w /Library/LaunchDaemons/org.macports.mysql5.plist'
alias restart_mysql='sudo launchctl unload -w /Library/LaunchDaemons/org.macports.mysql5.plist; sudo launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist'

#dotime
source ~/.dotime_aliases

#rhino
alias js="java org.mozilla.javascript.tools.shell.Main"
alias jsbeautify="java org.mozilla.javascript.tools.shell.Main /Users/saimon/Development/bin/js-beautify/beautify-cl.js"
alias noderb="rlwrap /opt/usr/bin/node-repl"

#bash
alias p="ps axww | grep "
alias px="ps -ax -m -o pid,%cpu,rss,command | grep "
alias k="kill -9 "
alias r="history | grep "
alias eb="e ~/.profile"
alias ab="source ~/.profile"
alias eh="sudo vim /etc/hosts"
alias ah="sudo dscacheutil -flushcache" #leopard
alias clr='clear'
alias grep='GREP_COLOR="1;37;41" LANG=C grep --color=auto'
alias g='grep'
alias l='less'
alias ec='e ~/Documents/commands.txt'
alias sz="du -sk ./* | sort -n | awk 'BEGIN{ pref[1]=\"K\"; pref[2]=\"M\"; pref[3]=\"G\";} { total = total + \$1; x = \$1; y = 1; while( x > 1024 ) { x = (x + 1023)/1024; y++; } printf(\"%g%s\t%s\n\",int(x*10)/10,pref[y],\$2); } END { y = 1; while( total > 1024 ) { total = (total + 1023)/1024; y++; } printf(\"Total: %g%s\n\",int(total*10)/10,pref[y]); }'"

#Misc
alias clog="clarity /var/log --include '*/**'"

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

# quicklook
alias ql="qlmanage -p 2>/dev/null"

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

#ssh
alias pssh="ssh -p 8888 "
alias pscp="scp -P 8888 "

# Autotest
alias att='autotest'

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

# Gems
alias cap1="`which cap` _1.4.2_"
alias sake="rake -g"

# Git
alias git='hub'
alias gscore='git log --numstat | awk -f /Users/saimon/bin/git_score.awk'
alias ga='git add'
alias gs='git status'
alias gca='git commit -a'
alias gc='git commit'
alias gb='git branch -a'
alias gps='git push'
alias gpl='git pull'
alias gch='git checkout'
alias gm='git merge'
alias gd='git diff'
alias gl='git log'
alias grm='git rebase master'
alias gnp='git-notpushed'
alias gh='git log --pretty=format:"%ai %s [%an]" > HISTORY'
alias fcm='git rev-list master |tail -n 1'
alias lcm='git rev-parse HEAD'
alias gfm="git status | grep modified | awk '{print \$3}' | head -n"
alias rmcachedassets="gs | grep public | awk '{print \$2}' | xargs rm"
alias gcps="gca && gps"
alias hns="hack && ship"
alias fixup='git commit -m \"fixup! $(git log -1 --format='\\''%s'\\'' $@)\"'
alias squash='git commit -m \"squash! $(git log -1 --format='\\''%s'\\'' $@)\"'
alias gri="git rebase --interactive --autosquash"

# Functions

function gchm() {
  sh -c "rake git:branch:checkout_with_migrations[$1]"
}

function rjson() {
  wget $1 -O - --quiet | ruby -rubygems -e 'require "json"; puts JSON.parse($stdin.gets).to_yaml'
}

function s() {
  cd ~/dev/$1
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

#completion

# activate once installed

#rake
# complete -C /opt/local/bin/rake-completion.rb -o default rake

#bash
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

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

# _mategem()
# {
#     local curw
#     COMPREPLY=()
#     curw=${COMP_WORDS[COMP_CWORD]}
#     local gems="$(gem environment gemdir)/gems"
#     COMPREPLY=($(compgen -W '$(ls $gems)' -- $curw));
#     return 0
# }
# complete -F _mategem -o dirnames mategem


# _complete_git() {
#   if [ -d .git ]; then
#     branches=`git branch -a | cut -c 3-`
#     tags=`git tag`
#     cur="${COMP_WORDS[COMP_CWORD]}"
#     COMPREPLY=( $(compgen -W "${branches} ${tags}" -- ${cur}) )
#   fi
# }
# complete -F _complete_git git checkout
# complete -F _complete_git gch
# complete -F _complete_git gchm
#
# source ~/.git-completion.sh

#********************** BASH 4 only ***********************
#shopt -s globstar autocd
# rvm-install added line:
#set -x
if [[ -s /Users/saimon/.rvm/scripts/rvm ]] ; then source /Users/saimon/.rvm/scripts/rvm ; fi
#set +x
