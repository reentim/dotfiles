fpath=($fpath $HOME/.zsh/func)
typeset -U fpath

[[ -f "$HOME/.zsh/functions.zsh" ]] && source "$HOME/.zsh/functions.zsh"
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f /tmp/PROMPT_TIME ]] && export PROMPT_TIME=1

setopt prompt_subst
setopt hist_ignore_all_dups
setopt inc_append_history
setopt interactivecomments
setopt rmstarsilent
setopt share_history

autoload -U promptinit
autoload -Uz compinit
autoload -U colors
autoload -U edit-command-line
autoload -Uz compinit menu-select

promptinit

zstyle ':completion:*' complete-options true

compinit
zmodload zsh/complist

prompt grb

zle -N toggle-prompt-time
zle -N edit-command-line

bindkey -e

bindkey "" kill-line
bindkey "" backward-kill-line
bindkey "^[3;5~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[3~" delete-char
bindkey "^[[4~" end-of-line
bindkey "^[[F" end-of-line
bindkey "^[[H" beginning-of-line
bindkey '' edit-command-line
bindkey '' toggle-prompt-time

stty -ixon # Free up C-s for fwd-i-search

eval "$(zoxide init zsh)"
source <(fzf --zsh)

if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
  if [[ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
  fi
fi

if [[ -n $ZSHENV_EPOCH ]]; then
  printf "[%.3f] ~/.zshrc\n" "(( $EPOCHREALTIME - $ZSHENV_EPOCH ))"
fi

if [[ $TMUX_AUTOATTACH && -z $TMUX ]]; then
  exec tmux-attach-or-new
fi
