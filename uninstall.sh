#!/bin/bash

bold=`tput bold`
normal=`tput sgr0`

echo -e "Removing linked dotfiles..."
rm -rf ~/.vimswap
rm -rf ~/.vimtmp
rm -rf ~/.vimundo
# vim
	rm ~/.vim
	rm ~/.vimrc
	rm ~/.gvimrc
# bash
	rm ~/.bash_aliases
	rm ~/.bash_custom
	rm ~/.bash_colors
	rm ~/.bash_profile
	rm ~/.screenrc
	rm ~/.ackrc
# git 
	rm ~/.gitconfig
	rm ~/.githelpers
	rm ~/.gitignore-global
echo -e "Restoring backed-up vim dotfiles..."
	cp ~/.backup-dotfiles/* ~/
	rmdir ~/.backup-dotfiles

echo -e "${bold}Uninstallation complete: original setup restored!${normal}\n"
