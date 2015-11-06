if [ -f ~/.profile ]; then
  source ~/.profile
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# docker-osx-dev
export DOCKER_HOST=tcp://localhost:2375

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
