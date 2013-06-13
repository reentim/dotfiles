# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

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

	if [ -d $HOME/.npm ]; then
		NPM_INSTALLED=1
	fi

# Stuff we always want to do
# ------------------------------------------------------------------------------
	export PATH=/usr/local/bin:$PATH
	export LESS=-Ri
	export GREP_OPTIONS="--color"

	# vim temp files go in /tmp/ directories
	mkdir -p /tmp/vimtemp
	mkdir -p /tmp/vimswap
	mkdir -p /tmp/vimundo

  # Alias definitions.
  if [ -f ~/.aliases ]; then
    source ~/.aliases
  fi

# Do conditional stuff
# ------------------------------------------------------------------------------
	if [ $NPM_INSTALLED ]; then
		export PATH="/usr/local/share/npm/bin:$PATH"
	fi

	if [ $RBENV_INSTALLED ]; then
		export PATH="$HOME/.rbenv/bin:$PATH"
		eval "$(rbenv init -)"
	fi

	# Homebrew stuff
	if [ $HOMEBREW_INSTALLED ]; then
		[ -d /usr/local/bin ] && export PATH=$(echo /usr/local/bin:$PATH | sed -e 's;:/usr/local/bin;;')
	fi

	if [ -n "$BASH_VERSION" ]; then

    source ~/.bash_colors

		HOST_COLOR=${BRIGHT_YELLOW}
		DIR_COLOR=${BRIGHT_VIOLET}
		USER_COLOR=${BRIGHT_YELLOW}

		# Include human readable colour shortcuts
		if [ -f ~/.bash_colors ]; then
			. ~/.bash_colors
		fi

		# History stuff
		# --------------------------------------------------------------------------
		export HISTCONTROL=erasedups
		export HISTSIZE=10000
		shopt -s histappend
		# --------------------------------------------------------------------------

		if [ -f ~/.bashrc ]; then source ~/.bashrc; fi

		source ~/.bash_custom

		if [ $HOMEBREW_INSTALLED ]; then
			if [ -f `brew --prefix`/etc/bash_completion ]; then
				source `brew --prefix`/etc/bash_completion
			fi
		fi
	fi

