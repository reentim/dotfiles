#!/usr/bin/env bash

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.

source ~/.zsh/functions.zsh

(which chruby-exec > /dev/null) && CHRUBY_INSTALLED=1
(which direnv > /dev/null) && DIRENV_INSTALLED=1
(which yarn > /dev/null) && YARN_INSTALLED=1
[ -d "$HOME/Applications/Visual Studio Code.app" ] && VSCODE_INSTALLED=1
[ -d $HOME/.rbenv ] && RBENV_INSTALLED=1
[ -d /usr/local/Library/Homebrew ] && HOMEBREW_INSTALLED=1
[ -f /usr/local/share/gem_home/gem_home.sh ] && GEM_HOME_INSTALLED=1
[ -f ~/.dotfiles/lib/z/z.sh ] && Z_INSTALLED=1

[ -f ~/.aliases ] && source ~/.aliases

# Add private keys to the ssh agent, if there are none already added
if ! (ssh-add -l &> /dev/null); then
  find ~/.ssh -type f \
    -exec bash -c '[[ "$(file "$1")" == *"private key"* ]]' bash {} ';' \
    -print | xargs ssh-add -K
fi

# Assumed branch fork point. Should be set appropriately in projects that
# branch from e.g. development
export DEFAULT_BRANCH="master"
export HOMEBREW_AUTO_UPDATE_SECS=86400
export LESS=Ri
export TIMEFMT="=> [%*E seconds at %P cpu]"
[ -f /tmp/PROMPT_TIME ] && export PROMPT_TIME=1

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

[ $Z_INSTALLED ] && source "$HOME/lib/z/z.sh"
prepend_path "./node_modules/.bin"

[ -d $HOME/bin ] && prepend_path "$HOME/bin"

prepend_path "./bin"

[ $VSCODE_INSTALLED ] && append_path "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

if [ $DIRENV_INSTALLED ]; then
  [ $BASH_VERSION ] && eval "$(direnv hook bash)"
  [ $ZSH_VERSION ] && eval "$(direnv hook zsh)"
fi
