fpath=($fpath $HOME/.zsh/func)
typeset -U fpath

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
export FZF_DEFAULT_OPTS="--height ~40%"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target --preview 'tree -C {}'"
export FZF_CTRL_R_OPTS="--no-sort --exact"

path=("$HOME/.asdf/shims" $path)
path=("$HOME/bin" $path)
path=("./node_modules/.bin" $path)
path=("./bin" $path)

[ -d $HOME/.cargo/bin ] && path=("$HOME/.cargo/bin" $path)
[ -d $HOME/.local/bin ] && path=("$HOME/.local/bin" $path)
