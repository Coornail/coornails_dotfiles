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

general_modules = checkout_git_submodules zsh git nethack screen tmux vim shellscript inst_bin
# My desktop is currently osx
desktop_modules = osx
drupal = drush

# Main make target, installs everything
all: $(general_modules) $(desktop_modules) $(drupal)

# @Todo: fix chsh
zsh:
	$(TITLE) "Installing zsh"
	$(Q)cp .zshrc ${INSTALL_DIR}
	$(Q)cp .zshenv ${INSTALL_DIR}
	$(Q)cp -r .zsh ${INSTALL_DIR}
	$(Q)cp -r .oh-my-zsh ${INSTALL_DIR}
	$(Q)touch ${INSTALL_DIR}/.z_cache
	$(Q)cp -r .oh-my-zsh-custom/* ${INSTALL_DIR}/.oh-my-zsh/custom/

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
endif

screen:
	$(TITLE) "Installing screen config"
	$(Q)cp .screenrc ${INSTALL_DIR}

tmux:
	$(TITLE) "Installing tmux config"
	$(Q)cp .tmux.conf ${INSTALL_DIR}

vim: checkout_git_submodules
	$(TITLE) "Installing vim config"
	$(Q)cp .vimrc ${INSTALL_DIR}
	$(Q)cp -r .vim ${INSTALL_DIR}
	$(TITLE) "Downloading pathogen"
	$(Q)mkdir -p ${INSTALL_DIR}/.vim/autoload/
	$(Q)curl -Sso ${INSTALL_DIR}/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
	$(TITLE) "Disabling NERDTree plugin (conflict)"
	$(Q)rm -rf ${INSTALL_DIR}/.vim/bundle/nerdtree

shellscript: checkout_git_submodules
	$(TITLE) "Installing shellscripts"
	$(Q)cp -r shellscript ${INSTALL_DIR}

inst_bin: shellscript
	$(TITLE) "Installing bin"
	$(Q)cp -r bin ${INSTALL_DIR}
	$(Q)ln -s ${INSTALL_DIR}/shellscript/drush/drush ${INSTALL_DIR}/bin/drush
	$(Q)ln -s ${INSTALL_DIR}/shellscript/ievms/ievms.sh ${INSTALL_DIR}/bin/ievms
	$(Q)ln -s ${INSTALL_DIR}/shellscript/hr/hr ${INSTALL_DIR}/bin/hr

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

