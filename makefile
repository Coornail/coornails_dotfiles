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

general_modules = ack checkout_git_submodules zsh git screen tmux vim shellscript
# My desktop is currently osx
desktop_modules = osx

# Main make target, installs everything
all: $(general_modules) $(desktop_modules)

ack:
	$(TITLE) "Installing .ackrc"
	$(Q)cp .ackrc ${INSTALL_DIR}/.ackrc

zsh: checkout_git_submodules
	$(TITLE) "Installing zsh"
	$(Q)cp .zshrc ${INSTALL_DIR}
	$(Q)cp .zshenv ${INSTALL_DIR}
	$(Q)cp dircolors-solarized/dircolors.ansi-dark ${INSTALL_DIR}
	$(Q)git clone --depth=1 https://github.com/zplug/zplug ${INSTALL_DIR}/.zplug
	$(Q)git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${INSTALL_DIR}/.powerlevel10k
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

shellscript: checkout_git_submodules
	$(TITLE) "Installing shellscripts"
	$(Q)cp -r shellscript ${INSTALL_DIR}

checkout_git_submodules:
	$(TITLE) "Checking out git submodules"
# Todo fix me:
	$(Q)git submodule init || true
	$(Q)git submodule update || true
# Remove .git directories from submodules as we don't want to copy those
	$(Q)for i in `git submodule | cut -d ' ' -f 3`; do rm -rf $i/.git; done

# @todo: Solve if VERBOSE=true
clean:
	$(TITLE)Deleting temporary files
	$(Q)for i in `git submodule | cut -d ' ' -f 3`; do rm -rf $i; done

ssh:
	$(TITLE)Adding ssh public keys
	$(Q)mkdir ${INSTALL_DIR}/.ssh || true
	$(Q)curl https://github.com/coornail.keys >> ${INSTALL_DIR}/.ssh/authorized_keys

emacs:
	$(Q)git clone https://github.com/syl20bnr/spacemacs ${INSTALL_DIR}/.emacs.d
	$(Q)cp .spacemacs ${INSTALL_DIR}/.spacemacs
