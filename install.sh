#!/usr/bin/env bash

set -e

mkdir /tmp/dotfiles
mkdir ~/.vimswap
mkdir ~/.vimtmp
mkdir ~/.vimundo

here="$(dirname "$0")"
here="$(cd "$here"; pwd)"

for file in "$here"/*; do
  name="$(basename "$file" .md)"
  [[ $name = bin ]] && dotname="$name" || dotname=".${name}"

  if [[ !( "install readme" =~ $name || -e ~/$dotname || -d $file/.git ) ]]; then
    mv ${file} /tmp/
    ln -sfv ${file#$HOME/} "${HOME}/${dotname}"
  fi
done
