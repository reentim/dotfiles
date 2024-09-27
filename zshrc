start=$($HOME/bin/monotonic-clock)

export TERM_PROFILE="${TERM_PROFILE:=TokyoNight}"
[ $TMUX ] && export "$(tmux show-environment TERM_PROGRAM)"

source ~/.zsh/functions.zsh

(which chruby-exec > /dev/null) && CHRUBY_INSTALLED=1
(which direnv > /dev/null) && DIRENV_INSTALLED=1
(which yarn > /dev/null) && YARN_INSTALLED=1
[ -d "$HOME/.asdf" ] && ASDF_INSTALLED=1
[ -d "$HOME/.nvm" ] && NVM_INSTALLED=1
[ -d $HOME/.rbenv ] && RBENV_INSTALLED=1
[ -d /usr/local/Homebrew ] && HOMEBREW_INSTALLED=1
[ -f "$HOME/lib/z/z.sh" ] && Z_INSTALLED=1
[ -f /usr/local/share/gem_home/gem_home.sh ] && GEM_HOME_INSTALLED=1

[ -f ~/.aliases ] && source ~/.aliases

# Add private keys to the ssh agent, if there are none already added
if ! (ssh-add -l &> /dev/null); then
  find ~/.ssh -type f \
    -exec bash -c '[[ "$(file "$1")" == *"private key"* ]]' bash {} ';' \
    -print | xargs ssh-add -K
fi

setopt PROMPT_SUBST
setopt hist_ignore_all_dups
setopt inc_append_history
setopt interactivecomments
setopt rmstarsilent
setopt share_history

export DEFAULT_BRANCH="main"
export HISTFILE="$HOME/.history"
export HISTSIZE=100000
export HOMEBREW_AUTO_UPDATE_SECS=86400
export LC_ALL="en_AU.UTF-8"
export LESS=Ri
export NVM_DIR="$HOME/.nvm"
export SAVEHIST=$HISTSIZE
export TIMEFMT="=> [%*E seconds at %P cpu]"
export WORDCHARS='*?[]~&;!$%^<>-'

[ -f /tmp/PROMPT_TIME ] && export PROMPT_TIME=1

mkdir -p /tmp/vimtemp /tmp/vimswap /tmp/vimundo
mkdir -p /tmp/nvim_temp /tmp/nvim_swap /tmp/nvim_undo

[ $ASDF_INSTALLED ] && source "$HOME/.asdf/asdf.sh"
[ $HOMEBREW_INSTALLED ] && prepend_path "/usr/local/bin"
[ $Z_INSTALLED ] && source "$HOME/lib/z/z.sh"
[ -d $HOME/bin ] && prepend_path "$HOME/bin"

prepend_path "./node_modules/.bin"
prepend_path "./bin"

if [ $NVM_INSTALLED ]; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

if [ $RBENV_INSTALLED ]; then
  prepend_path "$HOME/.rbenv/bin"
  prepend_path "$HOME/.rbenv/shims"

  if ! (on_path "$HOME/.rbenv/shims"); then
    [ $BASH_VERSION ] && eval "$(rbenv init - bash)"
    [ $ZSH_VERSION ] && eval "$(rbenv init - zsh)"
  fi
fi

if [ $CHRUBY_INSTALLED ]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh

  chruby ruby
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

stty -ixon # Free up C-s for fwd-i-search

toggle-prompt-time() {
  if [ $PROMPT_TIME ]; then
    unset PROMPT_TIME
    rm -f /tmp/PROMPT_TIME
  else
    export PROMPT_TIME="1"
    touch /tmp/PROMPT_TIME
  fi
  promptinit
  prompt grb
}

autoload -U promptinit
promptinit
prompt grb
autoload -Uz compinit
compinit
autoload -U colors && colors
autoload -U edit-command-line
zle -N toggle-prompt-time toggle-prompt-time
zle -N edit-command-line

# Fixing delete key in OSX
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "" backward-kill-line
bindkey "" kill-line
bindkey '' edit-command-line
bindkey '' toggle-prompt-time

finish=$($HOME/bin/monotonic-clock)
printf "=> [zshrc: %.3f seconds]\n" "($finish - $start)"
