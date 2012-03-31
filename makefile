# Install script for Coornail's dotfiles

all: zsh git nethack osx screen tmux vim shellscript

zsh:
	cp .zshrc ~/

git:
	cp .gitconfig ~/

nethack:
	cp .nethackrc ~/

osx:
	sh .osx

screen:
	cp .screenrc ~/

tmux:
	cp .tmux.conf ~/

vim:
	cp .vimrc ~/
	cp -r .vim ~/

shellscript:
	cp -r shellscript ~/

