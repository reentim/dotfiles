function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer "$port"
}

function prof() {
  profile=`enumerate-profiles | selecta`

  export ITERM_PROFILE=$profile
  set-profile $profile
}
