# Install script for Coornail's dotfiles

INSTALL_DIR=${HOME}
OS=`uname -s`

all: zsh git nethack screen tmux vim shellscript osx

zsh:
	cp .zshrc ${INSTALL_DIR}
	chsh -s `which zsh` || echo 'Failed to set zsh as default shell, install it and make zsh'

git:
	cp .gitconfig ${INSTALL_DIR}

nethack:
	cp .nethackrc ${INSTALL_DIR}

osx:
ifeq (${OS},Darwin)
	sh .osx
else
endif

screen:
	cp .screenrc ${INSTALL_DIR}

tmux:
	cp .tmux.conf ${INSTALL_DIR}

vim:
	cp .vimrc ${INSTALL_DIR}
	cp -r .vim ${INSTALL_DIR}

shellscript:
	cp -r shellscript ${INSTALL_DIR}

