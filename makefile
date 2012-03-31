# Install script for Coornail's dotfiles

INSTALL_DIR=${HOME}
OS=`uname -s`

# Output formatting
TITLE = @echo '[+]'
ifndef VERBOSE
	Q = @
else
	Q = @echo '  '
endif


all: zsh git nethack screen tmux vim shellscript osx

zsh:
	$(TITLE) "Installing zsh"
	$(Q)cp .zshrc ${INSTALL_DIR}
	$(Q)chsh -s `which zsh` || echo 'Failed to set zsh as default shell, install it and make zsh'

git:
	$(TITLE) "Installing git config"
	$(Q)cp .gitconfig ${INSTALL_DIR}

nethack:
	$(TITLE) "Installing nethack config"
	$(Q)cp .nethackrc ${INSTALL_DIR}

osx:
ifeq (${OS},Darwin)
	$(TITLE) "Setting up osx variables"
	$(Q)sh .osx
endif

screen:
	$(TITLE) "Installing screen config"
	$(Q)cp .screenrc ${INSTALL_DIR}

tmux:
	$(TITLE) "Installing tmux config"
	$(Q)cp .tmux.conf ${INSTALL_DIR}

vim:
	$(TITLE) "Vim config"
	$(Q)cp .vimrc ${INSTALL_DIR}
	$(Q)cp -r .vim ${INSTALL_DIR}

shellscript:
	$(TITLE) "Installing shellscripts"
	$(Q)cp -r shellscript ${INSTALL_DIR}

