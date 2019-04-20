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

  if (which chruby-exec > /dev/null); then
    CHRUBY_INSTALLED=1
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
  export LESS=-Ri

  # vim temp files go in /tmp/ directories
  mkdir -p /tmp/vimtemp
  mkdir -p /tmp/vimswap
  mkdir -p /tmp/vimundo

  # Alias definitions
  if [ -f ~/.aliases ]; then
    source ~/.aliases
  fi

  # Add the default private key to the ssh agent, if there are none already
  # added
  if ! (ssh-add -l > /dev/null); then
    ssh-add -K
  fi

# Do conditional stuff
# ------------------------------------------------------------------------------
  if [ -d $HOME/bin ]; then
    export PATH="$HOME/bin:$PATH"
  fi

  # Include the working directory's bin dir in PATH
  if ! (echo $PATH | grep ^\./bin); then
    export PATH="./bin:$PATH"
  fi

  if [ $RBENV_INSTALLED ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init - zsh)"
  fi

  if [ $CHRUBY_INSTALLED ]; then
    source /usr/local/opt/chruby/share/chruby/chruby.sh
    source /usr/local/opt/chruby/share/chruby/auto.sh

    chruby 'ruby-2.6.2'
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
