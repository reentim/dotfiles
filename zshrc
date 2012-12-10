autoload -U colors && colors

# History settings
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit
compinit

setopt rmstarsilent # don't warn on 'rm *'

export GREP_OPTIONS="--color"

source ~/.profile

# load remaining sources automatically
auto_sources=(`for f in ~/.zsh/*.zsh; do basename $f .zsh; done`)

for source in $auto_sources; do
  source ~/.zsh/$source.zsh
done

local git_prompt='%{$(git_super_status)%}'

PROMPT="${HOST_COLOR}%m%{$reset_color%}:${DIR_COLOR}%c%{$reset_color%}% ${git_prompt}%# "

# Fixing delete key in OSX
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char
