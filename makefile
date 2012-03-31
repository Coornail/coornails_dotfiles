# Install script for Coornail's dotfiles

INSTALL_DIR=${HOME}

all: zsh git nethack osx screen tmux vim shellscript

zsh:
	cp .zshrc ${INSTALL_DIR}
	chsh -s `which zsh` || echo 'Failed to set zsh as default shell, install it and make zsh'

git:
	cp .gitconfig ${INSTALL_DIR}

nethack:
	cp .nethackrc ${INSTALL_DIR}

osx:
	if [ `uname -s` = "Darwin" ]; then sh .osx; fi

screen:
	cp .screenrc ${INSTALL_DIR}

tmux:
	cp .tmux.conf ${INSTALL_DIR}

vim:
	cp .vimrc ${INSTALL_DIR}
	cp -r .vim ${INSTALL_DIR}

shellscript:
	cp -r shellscript ${INSTALL_DIR}

