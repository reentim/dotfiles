#!/bin/bash

bold=`tput bold`
normal=`tput sgr0`

mkdir ~/.backup-dotfiles
mkdir ~/.vimswap
mkdir ~/.vimtmp
mkdir ~/.vimundo

# vim files
	echo -e "Moving any existing vim dotfiles to ~/.backup-dotfiles/"
	mv -v ~/.vim ~/.backup-dotfiles/ 
	mv -v ~/.vimrc ~/.backup-dotfiles/
	mv -v ~/.gvimrc ~/.backup-dotfiles/
	echo -e "Linking vim dotfiles..."
	ln -s $PWD/.vim ~/.vim
	ln -s $PWD/.vimrc ~/.vimrc
	ln -s $PWD/.gvimrc ~/.gvimrc
	echo -e "${bold}Done${normal}\n"

# bash files
	echo -e "Moving any existing bash dotfiles to ~/.backup-dotfiles/"
	mv -v ~/.bash_aliases ~/.backup-dotfiles/
	mv -v ~/.bash_custom ~/.backup-dotfiles/
	mv -v ~/.bash_colors ~/.backup-dotfiles/
	mv -v ~/.bash_profile ~/.backup-dotfiles/
	echo -e "Linking bash dotfiles..."
	ln -s $PWD/.bash_aliases ~/.bash_aliases
	ln -s $PWD/.bash_custom ~/.bash_custom
	ln -s $PWD/.bash_colors ~/.bash_colors
	ln -s $PWD/.bash_profile ~/.bash_profile
	echo -e "${bold}Done${normal}\n"

# git files
	echo -e "Moving any existing git dotfiles to ~/Dropbox/.dotfiles/stock-dotfiles/"
	mv -v ~/.gitconfig ~/.backup-dotfiles
	mv -v ~/.githelpers ~/.backup-dotfiles
	mv -v ~/.gitignore-global ~/.backup-dotfiles
	echo -e "Linking git dotfiles..."
	ln -s $PWD/.gitconfig ~/.gitconfig
	ln -s $PWD/.githelpers ~/.githelpers
	ln -s $PWD/.gitignore-global ~/.gitignore-global
	echo -e "${bold}Done${normal}\n"

echo -e "${bold}Setup complete!${normal}\n"
