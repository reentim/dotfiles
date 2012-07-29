# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Rvm stuff
if [ $RVM_INSTALLED ]; then
	PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
	[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
fi

# Homebrew stuff
if [ $HOMEBREW_INSTALLED ]; then
	if [ -f `brew --prefix`/etc/bash_completion ]; then
		. `brew --prefix`/etc/bash_completion
	fi

	[ -d /usr/local/bin ] && export PATH=$(echo /usr/local/bin:$PATH | sed -e 's;:/usr/local/bin;;')
fi

if [ -f /etc/bash_completion.d/git ]; then
	. /etc/bash_completion.d/git
fi

# Stolen from Gary Bernhardt
# https://bitbucket.org/garybernhardt/dotfiles/src/4bdc724e5c4e/.bashrc
# with my small addition of hours and days at the git prompt
# -----------------------------------------------------------------------------
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

PS1="\[${HOST_COLOR}\]\h\[${NORMAL}\]:\[${DIR_COLOR}\]\W\[${NORMAL}\]\$(grb_git_prompt) \[${USER_COLOR}\]\u\[${NORMAL}\]\$ "
# -------------------------------------------------------------------------------------------------

# If we're in a screen session, make it clear, and don't do git PS1 stuff that doesn't (seem to) work
if [ $STY ]
then
	PS1="\[${BRIGHT_RED}\]\${STY}\[${NORMAL}\]:\[${BRIGHT_VIOLET}\]\w\[${NORMAL}\] \[${BRIGHT_YELLOW}\]\u\[${NORMAL}\]\$ "
fi