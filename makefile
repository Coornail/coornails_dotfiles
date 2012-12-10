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

general_modules = checkout_git_submodules zsh git nethack screen tmux vim shellscript
# My desktop is currently osx
desktop_modules = osx
drupal = drush

# Main make target, installs everything
all: $(general_modules) $(desktop_modules) $(drupal)

# @Todo: fix chsh
zsh:
	$(TITLE) "Installing zsh"
	$(Q)cp .zshrc ${INSTALL_DIR}
	$(Q)cp -r .zsh ${INSTALL_DIR}
	$(Q)touch ${INSTALL_DIR}/.z_cache
	$(Q)chsh -s `which zsh` || echo 'Failed to set zsh as default shell, install it and make zsh'

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

vim:
	$(TITLE) "Installing vim config"
	$(Q)cp .vimrc ${INSTALL_DIR}
	$(Q)cp -r .vim ${INSTALL_DIR}

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

drush: checkout_git_submodules
	$(TITLE) "Installing drush"
	$(Q)cp -rf shellscript/drush/ ${INSTALL_DIR}/shellscript/drush

# @todo: Solve if VERBOSE=true
clean:
	$(TITLE)Deleting temporary files
	$(Q)for i in `git submodule | cut -d ' ' -f 3`; do rm -rf $i; done

todo.txt: checkout_git_submodules
	$(TITLE) "Installing todo.txt"
	$(Q)cp todo.txt-cli/todo.sh ${INSTALL_DIR}/shellscript/
	$(Q)mkdir ${INSTALL_DIR}/.todo
	$(Q)cp todo.cfg ${INSTALL_DIR}/.todo
