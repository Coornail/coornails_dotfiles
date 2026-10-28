# Install script for Coornail's dotfiles

INSTALL_DIR=${HOME}

# Output formatting
TITLE = @echo '[+]'
ifndef VERBOSE
	Q = @
else
	Q = @echo '  '
endif

general_modules = zsh git tmux vim

# Main make target, installs everything
all: $(general_modules)

zsh:
	$(TITLE) "Installing zsh"
	$(Q)cp .zshrc ${INSTALL_DIR}
	$(Q)cp .zshenv ${INSTALL_DIR}
	$(Q)mkdir -p ${INSTALL_DIR}/bin
	$(Q)mkdir -p ${INSTALL_DIR}/.config && cp ./starship/starship.toml ${INSTALL_DIR}/.config/starship.toml
	$(Q)touch ${INSTALL_DIR}/.z
	command -v starship >/dev/null || [ -x "${INSTALL_DIR}/bin/starship" ] || echo '    starship not installed - using a plain prompt (apt: Ubuntu 25.04+/Debian 13+; brew: macOS)'

git:
	$(TITLE) "Installing git config"
	$(Q)cp .gitconfig ${INSTALL_DIR}
	$(Q)cp .gitignore_global ${INSTALL_DIR}
	$(Q)cp .gitattributes ${INSTALL_DIR}
	$(Q)mkdir -p ${INSTALL_DIR}/.config/gh
	$(Q)cp gh/config.yml ${INSTALL_DIR}/.config/gh

tmux:
	$(TITLE) "Installing tmux config"
	$(Q)cp .tmux.conf ${INSTALL_DIR}

vim:
	$(TITLE) "Installing vim config"
	$(Q)cp .vimrc ${INSTALL_DIR}
	$(Q)mkdir -p ${INSTALL_DIR}/.vim
	$(Q)cp -R .vim/. ${INSTALL_DIR}/.vim/
# plug.vim is vendored at .vim/autoload/plug.vim, pinned in SOURCES.lock and
# re-checked by `make verify`. The cp above installs it; nothing is downloaded.

ssh:
	$(TITLE) "Adding ssh public keys"
	$(Q)mkdir -p ${INSTALL_DIR}/.ssh && chmod 700 ${INSTALL_DIR}/.ssh
	$(Q)curl -fsSL https://github.com/coornail.keys | while read -r key; do grep -qxF "$$key" ${INSTALL_DIR}/.ssh/authorized_keys 2>/dev/null || echo "$$key" >> ${INSTALL_DIR}/.ssh/authorized_keys; done
