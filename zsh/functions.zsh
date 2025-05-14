server() {
  local port="${1:-8000}"
  local url="http://localhost:${port}/"
  if command -v open >/dev/null 2>&1; then
    open "$url"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url"
  fi
  python3 -m http.server "$port"
}

git-rm-submodule() {
  path_to_submodule="$1"
  git submodule deinit "$path_to_submodule"
  git rm "$path_to_submodule"
  rm -rf ".git/modules/${path_to_submodule}"
}

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

tmux-refresh-env() {
  eval "$(tmux show-environment -g | grep -E '^(SSH_AUTH_SOCK|SSH_AGENT_PID|TERM_APP|TERM_PROGRAM|TERM_PROFILE)=')"
}

append-path () {
  case ":$PATH:" in
    *:"$1":*)
      ;;
    *)
      PATH="${PATH:+$PATH:}$1"
  esac
}

alias-ls-time() {
  alias ls='ls -CFtr --color=always --group-directories-first'
}

alias-ls-name() {
  alias ls='ls -CF --color=always --group-directories-first'
}

zoxide-scan() {
  find "$PWD" -type d \
    -regex '.*/\(\..*\|node_modules\|cache\|tmp\|public\|vendor\)' \
    -prune -o -type d \
    -print \
    | xargs -r zoxide add
}

uz() {
  local dir="${1%.zip}"
  unzip -d "$dir" "$1" && cd "$dir" || return
  setopt localoptions nullglob
  local subdirs=(*(/))
  [[ ${#subdirs[@]} -eq 1 ]] && cd "$subdirs[1]" && pwd
}
