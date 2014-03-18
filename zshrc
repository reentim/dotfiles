source ~/.profile

auto_sources=(`for f in ~/.zsh/*.zsh; do basename $f .zsh; done`)

for source in $auto_sources; do
  source ~/.zsh/$source.zsh
done

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
setopt interactivecomments
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

setopt rmstarsilent # don't warn on 'rm *'

export WORDCHARS='*?[]~&;!$%^<>-'

# Fixing delete key in OSX
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char

export LC_ALL="en_AU.UTF-8"
