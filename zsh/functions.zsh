function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer "$port"
}

function prof() {
  if [ -z "$1" ]; then
    profile=`enumerate-profiles | selecta`
  else
    profile="$*"
  fi

  export ITERM_PROFILE=$profile
  set-profile $profile
}
