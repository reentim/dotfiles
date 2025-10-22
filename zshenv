typeset -U PATH path

export DEFAULT_BRANCH="main"
export EDITOR="nvim"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target --preview 'tree -C {}'"
export FZF_CTRL_R_OPTS="--no-sort --exact --height=15"
export FZF_DEFAULT_OPTS="--style default --layout reverse --height=~100%"
export HISTFILE="$HOME/.history"
export HISTSIZE=100000
export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
export LC_COLLATE=C
export LESS="MRi --mouse"
export MANPAGER='nvim +Man!'
export PNPM_HOME="$HOME/.local/share/pnpm"
export SAVEHIST=$HISTSIZE
export TERM_PROFILE="${TERM_PROFILE:=TokyoNight}"
export TIMEFMT="=> [%*Es real, %*Us user, %*Ss system. %P CPU. %M KB max RSS]"
export WORDCHARS='*?[]~&;!$%^<>-'

[[ -d "$HOME/.asdf" ]] && export ASDF_DATA_PATH="$HOME/.asdf"
[[ -d "$HOME/.cargo/bin" ]] && path=("$HOME/.cargo/bin" $path)
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d $PNPM_HOME ]] && path=("$PNPM_HOME" $path)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -f "$HOME/.secrets.env" ]] && source "$HOME/.secrets.env"

path=("/opt/podman/bin" $path)
path=("/opt/homebrew/bin" $path)
path=("/opt/homebrew/sbin" $path)
path=("$HOME/.asdf/shims" $path)
path=("./node_modules/.bin" $path)
path=("$HOME/bin" $path)
path=("./bin" $path)

if [[ $ZSH_BENCH_ENABLED == true ]]; then
  printf "[%.3f] ~/.zshenv\n" "(( $EPOCHREALTIME - $ZSHENV_EPOCH ))"
fi

fpath[1,0]="/opt/homebrew/share/zsh/site-functions";

[[ -z "${MANPATH-}" ]] || export MANPATH=":${MANPATH#:}";
