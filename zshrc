[ -x "$HOME/bin/monotonic-clock" ] && start=$($HOME/bin/monotonic-clock)

[ -f "$HOME/.zsh/func/misc" ] && source "$HOME/.zsh/func/misc"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f /tmp/PROMPT_TIME ] && export PROMPT_TIME=1

# if [ $TMUX ]; then
#   [ $(tmux show-environment TERM_PROGRAM) != "-TERM_PROGRAM" ] && export "$(tmux show-environment TERM_PROGRAM)"
# fi

if [ "$TERM" = "xterm-kitty" ] && ! infocmp xterm-kitty >/dev/null 2>&1; then
  export TERM=xterm-256color
fi

# setopt vi
setopt PROMPT_SUBST
setopt hist_ignore_all_dups
setopt inc_append_history
setopt interactivecomments
setopt rmstarsilent
setopt share_history

# unsetopt globcomplete
# unsetopt nomatch

(which direnv > /dev/null) && DIRENV_INSTALLED=1
(which yarn > /dev/null) && YARN_INSTALLED=1
[ -d "$HOME/.asdf" ] && ASDF_INSTALLED=1
[ -d "$HOME/.nvm" ] && NVM_INSTALLED=1
[ -d /usr/local/Homebrew ] && HOMEBREW_INSTALLED=1
[ -f "$HOME/lib/z/z.sh" ] && Z_INSTALLED=1
[ -f /usr/local/share/gem_home/gem_home.sh ] && GEM_HOME_INSTALLED=1

mkdir -p /tmp/vimtemp /tmp/vimswap /tmp/vimundo \
  /tmp/nvim_temp /tmp/nvim_swap /tmp/nvim_undo

[ $ASDF_INSTALLED ] && export ASDF_DATA_PATH="$HOME/.asdf"
[ $Z_INSTALLED ] && source "$HOME/lib/z/z.sh"

if [ -s "$HOME/.bun/_bun" ]; then
  source "$HOME/.bun/_bun"
  export BUN_INSTALL="$HOME/.bun"
  path=("$BUN_INSTALL/bin" $path)
fi

if [ $GEM_HOME_INSTALLED ]; then
  source /usr/local/share/gem_home/gem_home.sh

  gem_home_auto() {
    if [ -f "Gemfile" ]; then
      gem_home -
      gem_home .
    fi
  }

  if [[ -n "$ZSH_VERSION"  ]]; then
    if [[ ! "$preexec_functions" == *gem_home_auto*  ]]; then
      preexec_functions+=("gem_home_auto")
    fi
  fi
fi

if [ $DIRENV_INSTALLED ]; then
  [ $BASH_VERSION ] && eval "$(direnv hook bash)"
  [ $ZSH_VERSION ] && eval "$(direnv hook zsh)"
fi

autoload -U promptinit
promptinit
prompt grb
autoload -Uz compinit
compinit
autoload -U colors && colors
autoload -U edit-command-line
zle -N toggle-prompt-time
zle -N edit-command-line

# bindkey -M vicmd '^P' up-history
# bindkey -M vicmd '^N' down-history
# bindkey -M viins '^P' up-history
# bindkey -M viins '^N' down-history

bindkey -e

bindkey "" backward-kill-line
bindkey "" kill-line
bindkey '' edit-command-line
bindkey '' toggle-prompt-time

bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "^[[4~" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[H" beginning-of-line

stty -ixon # Free up C-s for fwd-i-search

source <(fzf --zsh)

# fzf for backwards search, but run the command immediately
# zle -N my-fzf-history-widget
# bindkey "" my-fzf-history-widget

if [ -x $HOME/bin/monotonic-clock ]; then
  finish=$($HOME/bin/monotonic-clock)
  printf "=> [zshrc: %.3f seconds]\n" "($finish - $start)"
fi
