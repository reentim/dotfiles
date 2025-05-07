fpath=($fpath $HOME/.zsh/func)
typeset -U fpath

export DEFAULT_BRANCH="main"
export EDITOR="nvim"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target --preview 'tree -C {}'"
export FZF_CTRL_R_OPTS="--no-sort --exact --height=15"
export FZF_DEFAULT_OPTS="--style full --layout reverse --height=~100%"
export HISTFILE="$HOME/.history"
export HISTSIZE=100000
export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_NO_ENV_HINTS=1
export LC_ALL="en_AU.UTF-8"
export LESS="MRi --mouse"
export NVM_DIR="$HOME/.nvm"
export PNPM_HOME="/home/tim/.local/share/pnpm"
export SAVEHIST=$HISTSIZE
export TERM_PROFILE="${TERM_PROFILE:=TokyoNight}"
export TIMEFMT="=> [%*Es real, %*Us user, %*Ss system. %P CPU. %M KB max RSS]"
export VISUAL="nvim"
export WORDCHARS='*?[]~&;!$%^<>-'

# TODO: does this do anything?
# https://nolanlawson.com/2024/10/20/why-im-skeptical-of-rewriting-javascript-tools-in-faster-languages/
export NODE_COMPILE_CACHE=~/.cache/nodejs-compile-cache

path=("$HOME/.asdf/shims" $path)
path=("$HOME/bin" $path)
path=("./node_modules/.bin" $path)
path=("./bin" $path)

[ -d $HOME/.cargo/bin ] && path=("$HOME/.cargo/bin" $path)
[ -d $HOME/.local/bin ] && path=("$HOME/.local/bin" $path)
[ -x "$ASDF_DATA_PATH/shims/pnpm" ] && path=("$PNPM_HOME" $path)
