#!/usr/bin/env bash

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.

if [ -d $HOME/.rbenv ]; then
  RBENV_INSTALLED=1
fi

if (which chruby-exec > /dev/null); then
  CHRUBY_INSTALLED=1
fi

if [ -f /usr/local/share/gem_home/gem_home.sh ]; then
  GEM_HOME_INSTALLED=1
fi

if [ -d /usr/local/Library/Homebrew ]; then
  HOMEBREW_INSTALLED=1
fi

if (which yarn > /dev/null); then
  YARN_INSTALLED=1
fi

if (which direnv > /dev/null); then
  DIRENV_INSTALLED=1
fi

if [ -d "$HOME/Applications/Visual Studio Code.app" ]; then
  VSCODE_INSTALLED=1
fi

if [ -f ~/.dotfiles/lib/z/z.sh ]; then
  Z_INSTALLED=1
fi

# vim temp files go in /tmp/ directories
mkdir -p /tmp/vimtemp
mkdir -p /tmp/vimswap
mkdir -p /tmp/vimundo

# Alias definitions
[ -f ~/.aliases ] && source ~/.aliases

# Free up C-s for fwd-i-search
stty -ixon

if [ -n "$ITERM_PROFILE" ]; then
  echo $ITERM_PROFILE > /tmp/$ITERM_SESSION_ID-iterm_profile
fi

# Add private keys to the ssh agent, if there are none already added
if ! (ssh-add -l > /dev/null 2>&1); then
  find ~/.ssh -type f \
    -exec bash -c '[[ "$(file "$1")" == *"private key"* ]]' bash {} ';' \
    -print | xargs ssh-add -K
fi

# Assumed branch fork point. Should be set appropriately in projects that
# branch from e.g. development
export DEFAULT_BRANCH="master"
export TIMEFMT=$'=> ⏱  %mE, %P CPU, %M KB occupied'
export LESS=Ri

if [ $RBENV_INSTALLED ]; then
  prepend_path "$HOME/.rbenv/bin"
  prepend_path "$HOME/.rbenv/shims"

  if ! (on_path "$HOME/.rbenv/shims"); then
    [ $BASH_VERSION ] && eval "$(rbenv init - bash)"
    [ $ZSH_VERSION ] && eval "$(rbenv init - zsh)"
  fi
fi

if [ $CHRUBY_INSTALLED ]; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/opt/chruby/share/chruby/auto.sh

  chruby ruby
fi

if [ $GEM_HOME_INSTALLED ]; then
  source /usr/local/share/gem_home/gem_home.sh

  gem_home_auto() {
    if [ -f "Gemfile" ]; then
      gem_home -
      gem_home .
    fi
  }

  if [[ -n "$ZSH_VERSION"  ]]; then
    if [[ ! "$preexec_functions" == *gem_home_auto*  ]]; then
      preexec_functions+=("gem_home_auto")
    fi
  fi
fi

prepend_path "./node_modules/.bin"

if [ -d $HOME/bin ]; then
  prepend_path "$HOME/bin"
fi

if ! (echo $PATH | grep ^\./bin > /dev/null); then
  export PATH="./bin:$PATH"
fi

if [ $VSCODE_INSTALLED ]; then
  append_path "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

if [ $Z_INSTALLED ]; then
  source "$HOME/lib/z/z.sh"
fi

if [ $DIRENV_INSTALLED ]; then
  [ $BASH_VERSION ] && eval "$(direnv hook bash)"
  [ $ZSH_VERSION ] && eval "$(direnv hook zsh)"
fi
