fpath=($fpath $HOME/.zsh/func)
typeset -U fpath

[ -f "$HOME/.zsh/func/path_manip" ] && source "$HOME/.zsh/func/path_manip"

export DEFAULT_BRANCH="main"
export EDITOR="$VISUAL"
export HISTFILE="$HOME/.history"
export HISTSIZE=100000
export HOMEBREW_AUTO_UPDATE_SECS=86400
export LC_ALL="en_AU.UTF-8"
export LESS=Ri
export NVM_DIR="$HOME/.nvm"
export SAVEHIST=$HISTSIZE
export TERM_PROFILE="${TERM_PROFILE:=TokyoNight}"
export TIMEFMT="=> [%*E seconds at %P cpu]"
export VISUAL="nvim"
export WORDCHARS='*?[]~&;!$%^<>-'

path=("$HOME/.asdf/shims" $path)
path=("$HOME/bin" $path)
path=("./node_modules/.bin" $path)
path=("./bin" $path)

[ -d $HOME/.cargo/bin ] && path=("$HOME/.cargo/bin" $path)
[ -d $HOME/.local/bin ] && path=("$HOME/.local/bin" $path)

