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

source ~/.bash_colors

# Check environment
# ------------------------------------------------------------------------------
	SYSTEM_TYPE=$(uname)

	if [ -d $HOME/.rvm ]; then
		RVM_INSTALLED=1
	fi

	if [ -d $HOME/.rbenv ]; then
		RBENV_INSTALLED=1
	fi

	if [ -d /usr/local/Library/Homebrew ]; then
		HOMEBREW_INSTALLED=1
	fi

# Stuff we always want to do
# ------------------------------------------------------------------------------
	export PATH=/usr/local/bin:$PATH

	# vim temp files go in /tmp/ directories
	mkdir -p /tmp/vimtemp
	mkdir -p /tmp/vimswap
	mkdir -p /tmp/vimundo

		# Alias definitions.
		if [ -f ~/.bash_aliases ]; then
			source ~/.bash_aliases
		fi

# Do conditional stuff
# ------------------------------------------------------------------------------
	if [ $RBENV_INSTALLED ]; then
		export PATH="$HOME/.rbenv/bin:$PATH"
		eval "$(rbenv init -)"
	fi

	if [ $RVM_INSTALLED ]; then
		PATH=$PATH:$HOME/.rvm/bin
		[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
	fi

	# Homebrew stuff
	if [ $HOMEBREW_INSTALLED ]; then
		[ -d /usr/local/bin ] && export PATH=$(echo /usr/local/bin:$PATH | sed -e 's;:/usr/local/bin;;')
	fi

	if [[ $SYSTEM_TYPE == 'Linux' ]]; then
		if [ $ZSH_VERSION ]; then
			HOST_COLOR="%{$fg_bold[green]%}"
			DIR_COLOR="%{$fg_bold[magenta]%}"
			USER_COLOR="%{$fg_bold[yellow]%}"
		else
			HOST_COLOR=${BRIGHT_GREEN}
			DIR_COLOR=${BRIGHT_VIOLET}
			USER_COLOR=${BRIGHT_BLUE}
		fi

	fi

	if [[ $SYSTEM_TYPE == 'Darwin' ]]; then
		HOST_COLOR=${BRIGHT_RED}
		DIR_COLOR=${BRIGHT_VIOLET}
		USER_COLOR=${BRIGHT_YELLOW}
	fi

	# If unspecified, set default prompt colours
	if [ -z $HOST_COLOR ]; then
		HOST_COLOR=${BRIGHT_YELLOW}
		DIR_COLOR=${BRIGHT_VIOLET}
		USER_COLOR=${BRIGHT_YELLOW}
	fi

	if [ -n "$BASH_VERSION" ]; then

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

