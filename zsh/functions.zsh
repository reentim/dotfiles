server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer "$port"
}

proj() {
  local cache="$HOME/.tmp/proj_list"
  if ! [ -f "$cache" ]; then
    >&2 echo "Building cache..."
    _proj_build_cache
    pushd $(cat $cache | selecta)
  else
    $(_proj_build_cache &>/dev/null &)
    pushd $(cat $cache | selecta)
  fi
}

_proj_build_cache() {
  ls -dt $(find ~/dev/ ~/proj/ -depth 1 -type d) > "$HOME/.tmp/proj_list"
}

on_path() {
  echo $PATH | grep --fixed-strings "$1" &>/dev/null
}

prepend_path() {
  export PATH="$1:$(_path_without $1)"
}

append_path() {
  export PATH="$(_path_without $1):$1"
}

staging-deploy() {
  git push && git push staging staging:master
}

production-deploy() {
  git push uat master && heroku pipelines:promote -a adboxapp
}

zz() {
  arg=$*
  if [ $args ]; then
    cd $(
      z -l $args | tac | awk '{ print $2 }' | selecta
    )
  else
    cd $(
      cat ~/.z \
        | awk -F '|' '{ print $2,$3,$1 }' \
        | sort -nr \
        | awk '{ print $3 }' \
        | selecta
    )
  fi
}

git-rm-submodule() {
  path_to_submodule=$1
  git submodule deinit $path_to_submodule
  git rm $path_to_submodule
  rm -rf .git/modules/${path_to_submodule}
}

killpid() {
  ps axww -o pid,user,%cpu,%mem,start,time,command \
    | selecta \
    | sed 's/^ *//' \
    | cut -f1 -d' ' \
    | xargs kill -s SIGTERM
}

findpid() {
  ps axww -o pid,user,%cpu,%mem,start,time,command \
    | selecta \
    | sed 's/^ *//' \
    | cut -f1 -d' ' \
    | tee >(pbcopy)
}

fresh-internet() {
  if [ -f latest.dump ]; then
    mv latest.dump* /tmp
  fi
  git_db_remote="$(git remote -v | grep prod | head -1 | sed -E "s|prod.*https://git.heroku.com/||g" | sed -E "s|\.git.*||g")"
  if [ "$git_db_remote" ]; then
    heroku pg:backups:download -a "$git_db_remote"
    pg_restore --verbose --clean --no-acl --no-owner -h localhost -d $(finddb $(pwd)) latest.dump
  fi
}

_path_without() {
  arg=$(echo $1 | sed -e 's/[]\/$*.^[]/\\&/g')
  echo $PATH | sed "s|${arg}||g" | sed "s/::/:/g" | sed "s/:$//" | sed "s/^://g"
}

uncd() {
  cd $OLDPWD
}
