#!/usr/bin/env bash

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.

# ------------------------------------------------------------------------------
# This should be the only file that gets automatically loaded at login.
# It is loaded in a variety of environments, so shouldn't assume anything.
# ------------------------------------------------------------------------------

# Check environment
# ------------------------------------------------------------------------------
  SYSTEM_TYPE=$(uname)

  if [ -d $HOME/.rbenv ]; then
    RBENV_INSTALLED=1
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

# Stuff we always want to do
# ------------------------------------------------------------------------------
  export PATH=/usr/local/bin:$PATH
  export LESS=-Ri

  # vim temp files go in /tmp/ directories
  mkdir -p /tmp/vimtemp
  mkdir -p /tmp/vimswap
  mkdir -p /tmp/vimundo

  # Alias definitions
  if [ -f ~/.aliases ]; then
    source ~/.aliases
  fi

  if [ -n "$ITERM_PROFILE" ]; then
    # $ITERM_PROFILE needs to be exported in order to send it over ssh
    export ITERM_PROFILE=$ITERM_PROFILE

    # Store $ITERM_PROFILE in a session-specific file, to be read in e.g. tmux
    # sessions with out-of-date environment variables
    echo $ITERM_PROFILE > /tmp/$ITERM_SESSION_ID-iterm_profile
  fi

  # Setting for some scripts designed to run inside a VM and talk to host
  export SCRIPTED_SSH_ENABLED=true

  # Add the default private key to the ssh agent, if there are none already
  # added
  if ! (ssh-add -l > /dev/null); then
    ssh-add -K
  fi

# Do conditional stuff
# ------------------------------------------------------------------------------
  if [ $YARN_INSTALLED ]; then
    export PATH="$PATH:`yarn global bin`"
  fi

  if [ -d $HOME/bin ]; then
    export PATH="$HOME/bin:$PATH"
  fi

  if [ $RBENV_INSTALLED ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init - zsh)"
  fi

  # z - a fuzzy finder for directory changing
  #    installed under Homebrew on MacOS, otherwise available in dotfiles
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
    eval "$(direnv hook zsh)"
  fi

  # Bash specific
  if [ -n "$BASH_VERSION" ]; then
    # Include human readable colour shortcuts
    if [ -f ~/.bash_colors ]; then
      source ~/.bash_colors
    fi

    if [ -f ~/.bash_colors ]; then
      source ~/.bash_custom
    fi

    if [ -f ~/.bashrc ]; then
      source ~/.bashrc
    fi

    # History stuff
    export HISTCONTROL=erasedups
    export HISTSIZE=10000
    shopt -s histappend

    if [ $HOMEBREW_INSTALLED ]; then
      if [ -f `brew --prefix`/etc/bash_completion ]; then
        source `brew --prefix`/etc/bash_completion
      fi
    else
      if [ -f /etc/bash_completion.d/git ]; then
        . /etc/bash_completion.d/git
      fi
    fi
  fi

  export GOPATH=/usr/local/go
  export PATH=$PATH:$GOPATH/bin

export NVM_DIR="$HOME/.nvm"
source "/usr/local/opt/nvm/nvm.sh"

export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
