function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer "$port"
}

function export-iterm-profile {
  export ITERM_PROFILE=$1
  set_iterm_profile $1
}
