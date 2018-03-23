#!/bin/bash
echo Installing *ix Setup


# Install some essentials
sh install/ix.sh

# Detect the platform.
case "$OSTYPE" in
  darwin*) # Mac (OSX)
	sh install/darwin.sh
	ln -s -f ~/.dot-ix/configs/code/* ~/Library/Application\ Support/Code/User/
	;;
esac

for file in $(ls -a)
do
    if [ $file != ".git" ] && [ $file != "install*" ] && [ $file != "." ] && [ $file != ".." ]
	then
		echo Linking ~/$file
		ln -s -f $PWD/$file ~
	fi
done

# Install Prezto
if [ ! -e ~/.zprezto ]; then
	echo Installing zprezto
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
else
	echo zprezto already installed
fi

if [ ! -e ~/.vim_runtime ]; then
	echo Installing Awesome Vim Setup
	git clone https://github.com/amix/vimrc.git ~/.vim_runtime
	sh ~/.vim_runtime/install_awesome_vimrc.sh
else
	echo Awesome Vim Setup already installed
fi

# Switch to ZSh
if [ $SHELL != /bin/zsh ]; then
	sudo chsh -s /bin/zsh `whoami`
else
	echo ZSH is already the default shell
fi
