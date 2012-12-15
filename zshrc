autoload -U colors && colors

# History settings
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit
compinit

setopt rmstarsilent # don't warn on 'rm *'

source ~/.profile

# load remaining sources automatically
auto_sources=(`for f in ~/.zsh/*.zsh; do basename $f .zsh; done`)

for source in $auto_sources; do
  source ~/.zsh/$source.zsh
done

# local git_prompt='%{$(git_super_status)%}'
local git_prompt='%{$(git_super_status)%}'

if [[ $SYSTEM_TYPE == 'Linux' ]]; then
  PROMPT='%{$fg_bold[green]%}%m%{$reset_color%}:%{$fg_bold[magenta]%}%c%{$reset_color%}$(git_super_status)%# '
else
  PROMPT='%{$fg_bold[cyan]%}%m%{$reset_color%}:%{$fg_bold[magenta]%}%c%{$reset_color%}$(git_super_status)%# '
fi

# Fixing delete key in OSX
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char
