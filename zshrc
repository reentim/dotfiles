start=$($HOME/bin/monotonic-clock)

source ~/.profile

setopt PROMPT_SUBST
autoload -U promptinit
promptinit
prompt grb

autoload -Uz compinit
compinit
autoload -U colors && colors

# History settings
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt interactivecomments
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# do not warn on 'rm *'
setopt rmstarsilent

export WORDCHARS='*?[]~&;!$%^<>-'

# Fixing delete key in OSX
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

bindkey "" backward-kill-line
bindkey "" kill-line

stty -ixon # Free up C-s for fwd-i-search

toggle-prompt-time() {
  if [ $PROMPT_TIME ]; then
    unset PROMPT_TIME
    rm -f /tmp/PROMPT_TIME
  else
    export PROMPT_TIME="1"
    touch /tmp/PROMPT_TIME
  fi
  promptinit
  prompt grb
}

zle -N toggle-prompt-time toggle-prompt-time

autoload -U edit-command-line
zle -N edit-command-line
bindkey '' edit-command-line
bindkey '' toggle-prompt-time

export LC_ALL="en_AU.UTF-8"

finish=$($HOME/bin/monotonic-clock)
let local "dt = ($finish - $start)"
printf "=> [zshrc: %.3f seconds]\n" $dt
