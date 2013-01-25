# Set custom prompt
setopt PROMPT_SUBST
autoload -U promptinit
promptinit
prompt grb

autoload -Uz compinit
compinit
autoload -U colors && colors

# History settings
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

setopt rmstarsilent # don't warn on 'rm *'

source ~/.profile

export WORDCHARS='*?[]~&;!$%^<>'

# Fixing delete key in OSX
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char
