start=$($HOME/bin/monotonic-clock)

source ~/.zsh/functions.zsh

(which chruby-exec > /dev/null) && CHRUBY_INSTALLED=1
(which direnv > /dev/null) && DIRENV_INSTALLED=1
(which yarn > /dev/null) && YARN_INSTALLED=1
[ -d $HOME/.rbenv ] && RBENV_INSTALLED=1
[ -d /usr/local/Homebrew ] && HOMEBREW_INSTALLED=1
[ -f /usr/local/share/gem_home/gem_home.sh ] && GEM_HOME_INSTALLED=1
[ -f "$HOME/lib/z/z.sh" ] && Z_INSTALLED=1
[ -d "$HOME/.asdf" ] && ASDF_INSTALLED=1

[ $HOMEBREW_INSTALLED ] && prepend_path "/usr/local/bin"

[ -f ~/.aliases ] && source ~/.aliases

# Add private keys to the ssh agent, if there are none already added
if ! (ssh-add -l &> /dev/null); then
  find ~/.ssh -type f \
    -exec bash -c '[[ "$(file "$1")" == *"private key"* ]]' bash {} ';' \
    -print | xargs ssh-add -K
fi

# Assumed branch fork point. Should be set appropriately in projects that
# branch from e.g. development
export DEFAULT_BRANCH="master"
export HOMEBREW_AUTO_UPDATE_SECS=86400
export LESS=Ri
export TIMEFMT="=> [%*E seconds at %P cpu]"

[ -f /tmp/PROMPT_TIME ] && export PROMPT_TIME=1

if [ $ASDF_INSTALLED ]; then
  source "$HOME/.asdf/asdf.sh"
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

[ $Z_INSTALLED ] && source "$HOME/lib/z/z.sh"

prepend_path "./node_modules/.bin"

[ -d $HOME/bin ] && prepend_path "$HOME/bin"

prepend_path "./bin"

if [ $DIRENV_INSTALLED ]; then
  [ $BASH_VERSION ] && eval "$(direnv hook bash)"
  [ $ZSH_VERSION ] && eval "$(direnv hook zsh)"
fi

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

zle -N toggle-prompt-time toggle-prompt-time

autoload -U edit-command-line
zle -N edit-command-line
bindkey '' edit-command-line
bindkey '' toggle-prompt-time

export LC_ALL="en_AU.UTF-8"

finish=$($HOME/bin/monotonic-clock)
let local "dt = ($finish - $start)"
printf "=> [zshrc: %.3f seconds]\n" $dt
