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

  if (which npm > /dev/null); then
    NPM_INSTALLED=1
  fi

  if (which yarn > /dev/null); then
    YARN_INSTALLED=1
  fi

  if (which direnv > /dev/null); then
    eval "$(direnv hook zsh)"
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

# Do conditional stuff
# ------------------------------------------------------------------------------
  if [ $NPM_INSTALLED ]; then
    export PATH="/usr/local/share/npm/bin:$PATH"
    export NODE_PATH='/usr/local/lib/node_modules'
  fi

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

  # Homebrew stuff
  if [ $HOMEBREW_INSTALLED ]; then
    [ -d /usr/local/bin ] && export PATH=$(echo /usr/local/bin:$PATH | sed -e 's;:/usr/local/bin;;')
  fi

  # Bash specific
  if [ -n "$BASH_VERSION" ]; then
    source ~/.bash_colors

    HOST_COLOR=${BRIGHT_CYAN}
    DIR_COLOR=${BRIGHT_VIOLET}
    USER_COLOR=${BRIGHT_YELLOW}

    # Include human readable colour shortcuts
    if [ -f ~/.bash_colors ]; then
      . ~/.bash_colors
    fi

    # History stuff
    export HISTCONTROL=erasedups
    export HISTSIZE=10000
    shopt -s histappend

    if [ -f ~/.bashrc ]; then source ~/.bashrc; fi

    source ~/.bash_custom

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

  if [ $SYSTEM_TYPE = 'Linux' ]; then
    # Ensure MySQL is on the PATH, if necessary
    if [ -f /etc/profile.d/mysql.server.sh ]; then
      source /etc/profile.d/mysql.server.sh
    fi
  fi

  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
