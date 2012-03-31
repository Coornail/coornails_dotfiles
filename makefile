# Install script for Coornail's dotfiles

INSTALL_DIR=${HOME}

all: zsh git nethack osx screen tmux vim shellscript

zsh:
	cp .zshrc ${INSTALL_DIR}

git:
	cp .gitconfig ${INSTALL_DIR}

nethack:
	cp .nethackrc ${INSTALL_DIR}

osx:
	sh .osx

screen:
	cp .screenrc ${INSTALL_DIR}

tmux:
	cp .tmux.conf ${INSTALL_DIR}

vim:
	cp .vimrc ${INSTALL_DIR}
	cp -r .vim ${INSTALL_DIR}

shellscript:
	cp -r shellscript ${INSTALL_DIR}

