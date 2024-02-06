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

general_modules = ack zsh git screen tmux vim shellscript
# My desktop is currently osx
desktop_modules = osx

# Main make target, installs everything
all: $(general_modules) $(desktop_modules)

ack:
	$(TITLE) "Installing .ackrc"
	$(Q)cp .ackrc ${INSTALL_DIR}/.ackrc

zsh:
	$(TITLE) "Installing zsh"
	$(Q)cp .zshrc ${INSTALL_DIR}
	$(Q)cp .zshenv ${INSTALL_DIR}
	$(Q)cp dircolors-solarized/dircolors.ansi-dark ${INSTALL_DIR}
	$(Q)mkdir -p ~/bin
	$(Q)curl -sS https://starship.rs/install.sh >> /tmp/starship.sh && chmod +x /tmp/starship.sh && /tmp/starship.sh --yes --bin-dir ~/bin
	$(Q)mkdir -p ~/.config && cp ./starship/starship.toml ~/.config/starship.toml
	$(Q)touch ${INSTALL_DIR}/.z

git:
	$(TITLE) "Installing git config"
	$(Q)cp .gitconfig ${INSTALL_DIR}
	$(Q)cp .gitignore_global ${INSTALL_DIR}

nethack:
	$(TITLE) "Installing nethack config"
	$(Q)cp .nethackrc ${INSTALL_DIR}

osx:
ifeq (${OS},Darwin)
	$(TITLE) "Setting up osx variables"
	$(Q)sh .osx
	$(Q)/usr/bin/python ./osx/fix-macosx.py
endif

screen:
	$(TITLE) "Installing screen config"
	$(Q)cp .screenrc ${INSTALL_DIR}

tmux:
	$(TITLE) "Installing tmux config"
	$(Q)cp .tmux.conf ${INSTALL_DIR}

vim:
	$(TITLE) "Installing vim config"
	$(Q)cp .vimrc ${INSTALL_DIR}
	$(Q)cp -r .vim/ ${INSTALL_DIR}/.vim
	$(TITLE) "Downloading Vim-plug"
	$(Q)mkdir -p ${INSTALL_DIR}/.vim/autoload
	$(Q)curl -sfLo ${INSTALL_DIR}/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

emacs:
	$(TITLE) "Installing emacs config"
	$(Q)cp -r .emacs.d ${INSTALL_DIR}

shellscript:
	$(TITLE) "Installing shellscripts"
	$(Q)cp -r shellscript ${INSTALL_DIR}

ssh:
	$(TITLE)Adding ssh public keys
	$(Q)mkdir ${INSTALL_DIR}/.ssh || true
	$(Q)curl https://github.com/coornail.keys >> ${INSTALL_DIR}/.ssh/authorized_keys

emacs:
	$(Q)git clone https://github.com/syl20bnr/spacemacs ${INSTALL_DIR}/.emacs.d
	$(Q)cp .spacemacs ${INSTALL_DIR}/.spacemacs
