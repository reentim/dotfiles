# color codes
# ------------------------------------------------------------------------------ #
DULL=0
BRIGHT=1

FG_BLACK=30
FG_RED=31
FG_GREEN=32
FG_YELLOW=33
FG_BLUE=34
FG_VIOLET=35
FG_CYAN=36
FG_WHITE=37

FG_NULL=00

BG_BLACK=40
BG_RED=41
BG_GREEN=42
BG_YELLOW=43
BG_BLUE=44
BG_VIOLET=45
BG_CYAN=46
BG_WHITE=47

BG_NULL=00

# ANSI Escape Commands
ESC="\e"
NORMAL="$ESC[m"
RESET="$ESC[${DULL};${FG_WHITE};${BG_NULL}m"

BLACK="$ESC[${DULL};${FG_BLACK}m"
RED="$ESC[${DULL};${FG_RED}m"
GREEN="$ESC[${DULL};${FG_GREEN}m"
YELLOW="$ESC[${DULL};${FG_YELLOW}m"
BLUE="$ESC[${DULL};${FG_BLUE}m"
VIOLET="$ESC[${DULL};${FG_VIOLET}m"
CYAN="$ESC[${DULL};${FG_CYAN}m"
WHITE="$ESC[${DULL};${FG_WHITE}m"

# BRIGHT TEXT
BRIGHT_BLACK="$ESC[${BRIGHT};${FG_BLACK}m"
BRIGHT_RED="$ESC[${BRIGHT};${FG_RED}m"
BRIGHT_GREEN="$ESC[${BRIGHT};${FG_GREEN}m"
BRIGHT_YELLOW="$ESC[${BRIGHT};${FG_YELLOW}m"
BRIGHT_BLUE="$ESC[${BRIGHT};${FG_BLUE}m"
BRIGHT_VIOLET="$ESC[${BRIGHT};${FG_VIOLET}m"
BRIGHT_CYAN="$ESC[${BRIGHT};${FG_CYAN}m"
BRIGHT_WHITE="$ESC[${BRIGHT};${FG_WHITE}m"
# ------------------------------------------------------------------------------ #

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias vi='vim'
alias cdw='cd ~/Dropbox/webdev/'
alias sr='screen -r'
alias cds='cd ~/Dropbox/sitepoint/'
alias gri='grep -ri'
alias ssr='source ~/.bashrc'
alias ssp='source ~/.bash_profile'
alias ff='find $PWD | grep '
alias tree='tree -FC'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Stolen from Gary Bernhardt: https://bitbucket.org/garybernhardt/dotfiles/src/4bdc724e5c4e/.bashrc
# with my small addition of hours and days at the git prompt
# -------------------------------------------------------------------------------------------------

function minutes_since_last_commit {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1`
    seconds_since_last_commit=$((now-last_commit))
    minutes_since_last_commit=$((seconds_since_last_commit/60))
    echo $minutes_since_last_commit
}

grb_git_prompt() {
    local g="$(__gitdir)"
    if [ -n "$g" ]; then
        local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
		local HOURS_SINCE_LAST_COMMIT=$(($MINUTES_SINCE_LAST_COMMIT/60))
		local DAYS_SINCE_LAST_COMMIT=$(($HOURS_SINCE_LAST_COMMIT/24))

# Color codes passed into PS1 by a function seem to goof up escape codes and
# mess with terminal length, so have been removed --

       # if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
       #     local COLOR=${BRIGHT_RED}
       # elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
       #     local COLOR=${YELLOW}
       # else
       #     local COLOR=${GREEN}
       # fi

		if [ "$HOURS_SINCE_LAST_COMMIT" -gt 72 ]; then
		local SINCE_LAST_COMMIT="${COLOR}${DAYS_SINCE_LAST_COMMIT}d"
		elif [ "$HOURS_SINCE_LAST_COMMIT" -gt 2 ]; then
			local SINCE_LAST_COMMIT="${COLOR}${HOURS_SINCE_LAST_COMMIT}h"
		else
			local SINCE_LAST_COMMIT="${COLOR}$(minutes_since_last_commit)m"
		fi

		function parse_git_dirty {
			[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
		}

        # The __git_ps1 function inserts the current git branch where %s is
		local GIT_PROMPT=`__git_ps1 "(%s|${SINCE_LAST_COMMIT}$(parse_git_dirty))"`
        echo ${GIT_PROMPT}
    fi
}

if [ -f "$HOME/.gitconfig" ]
then
	PS1="\[${BRIGHT_CYAN}\]\h\[${NORMAL}\]:\[${BRIGHT_VIOLET}\]\W\[${NORMAL}\]\$(grb_git_prompt) \[${BRIGHT_YELLOW}\]\u\[${NORMAL}\]\$ "
else
	PS1="\[${BRIGHT_CYAN}\]\h\[${NORMAL}\]:\[${BRIGHT_VIOLET}\]\W\[${NORMAL}\] \[${BRIGHT_YELLOW}\]\u\[${NORMAL}\]\$ "
fi
# -------------------------------------------------------------------------------------------------

# If we're in a screen session, make it clear, and don't do git PS1 stuff that doesn't (seem to) work
if [ $STY ]
then
	PS1="\[${BRIGHT_RED}\]\${STY}\[${NORMAL}\]:\[${BRIGHT_VIOLET}\]\w\[${NORMAL}\] \[${BRIGHT_YELLOW}\]\u\[${NORMAL}\]\$ "
fi

# Homebrew stuff
if [ -f `brew --prefix`/etc/bash_completion ]; then
	. `brew --prefix`/etc/bash_completion
fi

[ -d /usr/local/bin ] && export PATH=$(echo /usr/local/bin:$PATH | sed -e 's;:/usr/local/bin;;')
# end Homebrew stuff
