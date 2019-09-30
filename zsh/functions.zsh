server() {
  local port="${1:-8000}"
  python -m SimpleHTTPServer "$port"
  open "http://localhost:${port}/"
}

prof() {
  if [ -z "$1" ]; then
    profile=`enumerate-profiles | selecta`
  else
    profile="$*"
  fi

  export ITERM_PROFILE=$profile
  set-profile $profile
}


proj() {
  cd "$(find-repos | selecta)"
}

path_without() {
  arg=$(echo $1 | sed -e 's/[]\/$*.^[]/\\&/g')
  echo $PATH | sed "s|${arg}||g" | sed "s/::/:/g" | sed "s/:$//" | sed "s/^://g"
}

prepend_path() {
  export PATH="$1:$(path_without $1)"
}

append_path() {
  export PATH="$(path_without $1):$1"
}

delete-local-merged-branches() {
  git branch --merged |
    grep -v "*" |
    grep -v master |
    grep -v staging |
    xargs -n 1 git branch --delete
}

delete-remote-merged-branches() {
  git branch -a --merged origin/$DEFAULT_BRANCH |
    grep --color=never remotes |
    grep -v HEAD |
    grep -v staging |
    grep -v developement |
    grep -v master |
    sed "s:remotes/origin/::g" |
    xargs -L 1 git push origin --delete
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
  heroku pg:backups:download -a $(basename $(pwd))
  pg_restore --verbose --clean --no-acl --no-owner -h localhost -d $(finddb $(pwd)) latest.dump
}
