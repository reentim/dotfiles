source ~/.profile

# Set custom prompt
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
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

setopt rmstarsilent # don't warn on 'rm *'

export WORDCHARS='*?[]~&;!$%^<>'

# Fixing delete key in OSX
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char
