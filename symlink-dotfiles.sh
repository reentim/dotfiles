#!/bin/bash

bold=`tput bold`
normal=`tput sgr0`

# vim files
if [ -d "$HOME/Dropbox/.dotfiles/.vim" ]
then
	if [ -f "$HOME/Dropbox/.dotfiles/.vimrc" ]
	then
		echo -e "${bold}Found vim dotfiles on Dropbox...${normal}"
		echo -e "---------------------------------------"
		echo -e "Moving any existing vim dotfiles to ~/Dropbox/.dotfiles/stock-dotfiles/"
		mv -v ~/.vimrc ~/Dropbox/.dotfiles/stock-dotfiles/.vimrc-`date +%Y-%m-%d`-$USER-$HOSTNAME
		mv -v ~/.vim ~/Dropbox/.dotfiles/stock-dotfiles/.vim-`date +%Y-%m-%d`-$USER-$HOSTNAME
		echo -e "Linking vim dotfiles from Dropbox..."
		ln -s ~/Dropbox/.dotfiles/.vim ~/.vim
		ln -s ~/Dropbox/.dotfiles/.vimrc ~/.vimrc
		echo -e "${bold}Done!${normal}\n"
	fi
fi

# bash files
if [ -f "$HOME/Dropbox/.dotfiles/.bash_history" -a  -f "$HOME/Dropbox/.dotfiles/.bash_logout" -a  -f "$HOME/Dropbox/.dotfiles/.bashrc" -a -f "$HOME/Dropbox/.dotfiles/.bash_profile" ]
then
	echo -e "${bold}Found bash dotfiles on Dropbox...${normal}"
	echo -e "----------------------------------------"
	echo -e "Moving any existing bash dotfiles to ~/Dropbox/.dotfiles/stock-dotfiles/"
	# Let's be sensible and not sync everything:
	# mv -v ~/.bash_history ~/Dropbox/.dotfiles/stock-dotfiles/.bash_history-`date +%Y-%m-%d`-$USER-$HOSTNAME
	# ln -s ~/Dropbox/.dotfiles/.bash_history ~/.bash_history
	# mv -v ~/.bash_logout ~/Dropbox/.dotfiles/stock-dotfiles/.bash_logout-`date +%Y-%m-%d`-$USER-$HOSTNAME
	# ln -s ~/Dropbox/.dotfiles/.bash_logout ~/.bash_logout
	mv -v ~/.bashrc ~/Dropbox/.dotfiles/stock-dotfiles/.bashrc-`date +%Y-%m-%d`-$USER-$HOSTNAME
	mv -v ~/.bash_profile ~/Dropbox/.dotfiles/stock-dotfiles/.bash_profile-`date +%Y-%m-%d`-$USER-$HOSTNAME
	echo -e "Linking bash dotfiles from Dropbox..."
	ln -s ~/Dropbox/.dotfiles/.bashrc ~/.bashrc
	ln -s ~/Dropbox/.dotfiles/.bash_profile ~/.bash_profile
	echo -e "${bold}Done!${normal}\n"
fi

if [ -f "$HOME/Dropbox/.dotfiles/.gitconfig" -a  -f "$HOME/Dropbox/.dotfiles/.githelpers" ]
then
	echo -e "${bold}Found git dotfiles on Dropbox...${normal}"
	echo -e "---------------------------------------"
	echo -e "Moving any existing git dotfiles to ~/Dropbox/.dotfiles/stock-dotfiles/"
	mv -v ~/.gitconfig ~/Dropbox/.dotfiles/stock-dotfiles/.gitconfig-`date +%Y-%m-%d`-$USER-$HOSTNAME
	mv -v ~/.githelpers ~/Dropbox/.dotfiles/stock-dotfiles/.githelpers-`date +%Y-%m-%d`-$USER-$HOSTNAME
	mv -v ~/.gitignore-global ~/Dropbox/.dotfiles/stock-dotfiles/.gitignore-global-`date +Y-%m-%d`-$USER-$HOSTNAME
	echo -e "Linking git dotfiles from Dropbox..."
	ln -s ~/Dropbox/.dotfiles/.gitconfig ~/.gitconfig
	ln -s ~/Dropbox/.dotfiles/.githelpers ~/.githelpers
	ln -s ~/Dropbox/.dotfiles/.gitignore-global ~/.gitignore-global
	echo -e "${bold}Done!${normal}\n"
fi
