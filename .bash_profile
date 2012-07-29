# Include human readable colour shortcuts
if [ -f ~/.bash_colors ]; then . ~/.bash_colors; fi

SYSTEM_TYPE=$(uname)

# If unspecified, set default prompt colours
if [ -z $HOST_COLOR ]; then
	HOST_COLOR=${BRIGHT_CYAN}
	DIR_COLOR=${BRIGHT_VIOLET}
	USER_COLOR=${BRIGHT_YELLOW}
fi

if [[ $SYSTEM_TYPE == 'Linux' ]]; then
	HOST_COLOR=${BRIGHT_GREEN}
	DIR_COLOR=${BRIGHT_VIOLET}
	USER_COLOR=${BRIGHT_BLUE}
fi

if [ -d ~/.rvm ]; then
	RVM_INSTALLED=1
fi

if [ -d /usr/local/Library/Homebrew ]; then
	HOMEBREW_INSTALLED=1
fi

if [ -f ~/.bashrc ]; then source ~/.bashrc; fi
source ~/.bashrc
export PATH=/usr/local/bin:$PATH
