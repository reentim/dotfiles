start=$($HOME/bin/monotonic-clock)

auto_sources=(`for f in ~/.zsh/*.zsh; do basename $f .zsh; done`)

for source in $auto_sources; do
  source ~/.zsh/$source.zsh
done

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

export LC_ALL="en_AU.UTF-8"

finish=$(monotonic-clock)
let local "dt = ($finish - $start) * 1000"
printf "⏱  %dms\n" $dt
