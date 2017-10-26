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

general_modules = ack checkout_git_submodules zsh git nethack screen tmux vim shellscript inst_bin
# My desktop is currently osx
desktop_modules = osx
drupal = drush composer

# Main make target, installs everything
all: $(general_modules) $(desktop_modules)

ack:
	$(TITLE) "Installing .ackrc"
	$(Q)cp .ackrc ${INSTALL_DIR}/.ackrc

composer: inst_bin
	$(TITLE) "Installing Composer"
	$(Q)curl -sS https://getcomposer.org/installer | php -- --install-dir=${INSTALL_DIR}/bin
	$(Q)mv ${INSTALL_DIR}/bin/composer.phar ${INSTALL_DIR}/bin/composer

zsh:
	$(TITLE) "Installing zsh"
	$(Q)cp .zshrc ${INSTALL_DIR}
	$(Q)cp .zshenv ${INSTALL_DIR}
	$(Q)cp ./dircolors-solarized/dircolors.ansi-dark ${INSTALL_DIR}
	$(Q)mkdir -p ${INSTALL_DIR}/.zplug
	$(Q)curl https://raw.githubusercontent.com/b4b4r07/zplug/master/zplug > ${INSTALL_DIR}/.zplug/zplug
	$(Q)touch ${INSTALL_DIR}/.z_cache

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

inst_bin: shellscript
	$(TITLE) "Installing bin"
	$(Q)cp -r bin ${INSTALL_DIR}
	$(Q)ln -s ${INSTALL_DIR}/shellscript/drush/drush ${INSTALL_DIR}/bin/drush || true
	$(Q)ln -s ${INSTALL_DIR}/shellscript/ievms/ievms.sh ${INSTALL_DIR}/bin/ievms || true
	$(Q)ln -s ${INSTALL_DIR}/shellscript/hr/hr ${INSTALL_DIR}/bin/hr || true
	$(Q)ln -s ${INSTALL_DIR}/shellscript/catimg/catimg ${INSTALL_DIR}/bin/catimg || true
	$(Q)ln -s ${INSTALL_DIR}/shellscript/catimg/colors.png ${INSTALL_DIR}/bin/colors.png || true
	$(Q)ln -s ${INSTALL_DIR}/shellscript/spark/spark ${INSTALL_DIR}/bin/spark || true

checkout_git_submodules:
	$(TITLE) "Checking out git submodules"
# Todo fix me:
	$(Q)git submodule init || true
	$(Q)git submodule update || true
# Remove .git directories from submodules as we don't want to copy those
	$(Q)for i in `git submodule | cut -d ' ' -f 3`; do rm -rf $i/.git; done

drush: checkout_git_submodules shellscript
	$(TITLE) "Installing drush"
	$(Q)rm -rf ${INSTALL_DIR}/shellscript/drush
	$(Q)cp -rf shellscript/drush ${INSTALL_DIR}/shellscript/drush
	$(Q)cp -r .drush ${INSTALL_DIR}
# Clear cache, to make sure new commands are picked up right away
	$(Q)rm -rf ${INSTALL_DIR}/.drush/cache

# @todo: Solve if VERBOSE=true
clean:
	$(TITLE)Deleting temporary files
	$(Q)for i in `git submodule | cut -d ' ' -f 3`; do rm -rf $i; done

ssh:
	$(TITLE)Adding ssh public keys
	$(Q)mkdir ${INSTALL_DIR}/.ssh || true
	$(Q)curl https://github.com/coornail.keys >> ${INSTALL_DIR}/.ssh/authorized_keys

