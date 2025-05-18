echo '~/.zshrc'

[ -f "$HOME/.zsh/functions.zsh" ] && source "$HOME/.zsh/functions.zsh"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f /tmp/PROMPT_TIME ] && export PROMPT_TIME=1

setopt PROMPT_SUBST
setopt hist_ignore_all_dups
setopt inc_append_history
setopt interactivecomments
setopt rmstarsilent
setopt share_history

(which direnv > /dev/null) && DIRENV_INSTALLED=1
(which yarn > /dev/null) && YARN_INSTALLED=1
[ -d "$HOME/.asdf" ] && ASDF_INSTALLED=1
[ -d /usr/local/Homebrew ] && HOMEBREW_INSTALLED=1

mkdir -p /tmp/vimtemp /tmp/vimswap /tmp/vimundo \
  /tmp/nvim_temp /tmp/nvim_swap /tmp/nvim_undo

[ $ASDF_INSTALLED ] && export ASDF_DATA_PATH="$HOME/.asdf"


autoload -U promptinit
autoload -Uz compinit
autoload -U colors
autoload -U edit-command-line
# autoload -Uz compinit menu-select


promptinit

# zstyle ':completion:*' complete-options true

compinit
# zmodload zsh/complist

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

# TODO: this is the SYSTEM_ZSHENV_EPOCH
if [[ -n $ZSH_BENCH_EPOCH ]]; then
  printf "[%.3f] ~/.zshrc\n" "(( $EPOCHREALTIME - $ZSH_BENCH_EPOCH ))"
fi
