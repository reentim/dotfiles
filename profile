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
  # CHRUBY_INSTALLED=1
fi

if [ -f "/usr/local/share/gem_home/gem_home.sh" ]; then
  # GEM_HOME_INSTALLED=1
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

# vim temp files go in /tmp/ directories
mkdir -p /tmp/vimtemp
mkdir -p /tmp/vimswap
mkdir -p /tmp/vimundo

# Alias definitions
if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

if [ -n "$ITERM_PROFILE" ]; then
  echo $ITERM_PROFILE > /tmp/$ITERM_SESSION_ID-iterm_profile
fi

# Add private keys to the ssh agent, if there are none already added
if ! (ssh-add -l > /dev/null); then
  find ~/.ssh -type f \
    -exec bash -c '[[ "$(file "$1")" == *"private key"* ]]' bash {} ';' \
    -print | xargs ssh-add -K
fi

# Assumed branch fork point. Should be set appropriately in projects that
# branch from e.g. development
export DEFAULT_BRANCH="master"

export LESS=Ri

function prepend_path() {
  if ! (echo $PATH | grep $1 >/dev/null 2>&1); then
    export PATH="$1:$PATH"
  else
    return 1
  fi
}

function append_path() {
  if ! (echo $PATH | grep $1 >/dev/null 2>&1); then
    export PATH="$PATH:$1"
  else
    return 1
  fi
}

if [ $RBENV_INSTALLED ]; then
  prepend_path "$HOME/.rbenv/bin"
  if [ $BASH_VERSION ]; then
    eval "$(rbenv init - bash)"
  fi
  if [ $ZSH_VERSION ]; then
    eval "$(rbenv init - zsh)"
  fi
fi

if [ $CHRUBY_INSTALLED ]; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/opt/chruby/share/chruby/auto.sh

  chruby ruby
fi

if [ $GEM_HOME_INSTALLED ]; then
  source /usr/local/share/gem_home/gem_home.sh

  function gem_home_auto() {
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

if [ -d $HOME/bin ]; then
  prepend_path "$HOME/bin"
fi

if ! (echo $PATH | grep ^\./bin > /dev/null); then
  export PATH="./bin:$PATH"
fi

if [ $VSCODE_INSTALLED ]; then
  append_path "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

# z - a fuzzy finder for directory changing installed under Homebrew on MacOS,
# otherwise available in dotfiles
if [ $HOMEBREW_INSTALLED ]; then
  if [ -f `brew --prefix`/etc/profile.d/z.sh ]; then
    source `brew --prefix`/etc/profile.d/z.sh
  fi
else
  if [ -f ~/.dotfiles/lib/z/z.sh ]; then
    source ~/.dotfiles/lib/z/z.sh
  fi
fi

if [ $DIRENV_INSTALLED ]; then
  if [ $BASH_VERSION ]; then
    eval "$(direnv hook bash)"
  fi
  if [ $ZSH_VERSION ]; then
    eval "$(direnv hook zsh)"
  fi
fi
