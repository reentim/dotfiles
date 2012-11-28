HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

zstyle :compinstall filename '/home/tim/.zshrc'

autoload -Uz compinit
compinit

setopt rmstarsilent
export GREP_OPTIONS="--color"

source ~/.profile
source ~/.zsh/zshrc.sh

# PROMPT='%B%m%~%b$(git_super_status) %# '
PROMPT='%{$fg_bold[magenta]%}%c%{$reset_color%}% $(git_super_status)$ '
