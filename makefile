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

# Fail when a vendored source no longer matches its SOURCES.lock row
verify:
	$(TITLE) "Verifying vendored sources"
	$(Q)sh scripts/verify.sh

zsh:
	$(TITLE) "Installing zsh"
	$(Q)cp .zshrc ${INSTALL_DIR}
	$(Q)cp .zshenv ${INSTALL_DIR}
	$(Q)mkdir -p ${INSTALL_DIR}/bin
	$(Q)mkdir -p ${INSTALL_DIR}/.config && cp ./starship/starship.toml ${INSTALL_DIR}/.config/starship.toml
	$(Q)touch ${INSTALL_DIR}/.z
# zinit is vendored at sources/zinit (pinned in SOURCES.lock) and installed to
# the exact path .zshrc sources it from, so no shell ever clones it. The copy
# carries no history: zinit takes BIN_DIR from wherever zinit.zsh is sourced, so
# a checkout with a remote would let `zinit self-update` move the code under you
# (and pull a dotfiles checkout, if you sourced it in place). The empty
# repository created here is what makes self-update a no-op: zinit checks
# `git rev-parse --is-inside-work-tree` and, with no upstream branch to pull,
# stops -- without any .git at all it falls through into `git pull` and prints a
# fatal error every time. Only this directory is replaced -- zinit's plugins and
# snippets live next to it, in the parent dir.
	$(Q)zinit_home="$${XDG_DATA_HOME:-${INSTALL_DIR}/.local/share}/zinit/zinit.git"; \
	  rm -rf "$$zinit_home"; \
	  mkdir -p "$$zinit_home"; \
	  cp -R sources/zinit/. "$$zinit_home/"; \
	  git -C "$$zinit_home" init -q
# Best effort: zsh-patina is optional (the shell falls back to no highlighting),
# so a fetch failure must not abort the rest of the install. `make downloads`
# runs the same script strictly.
	$(Q)-sh scripts/fetch-downloads.sh
	[ -x "${INSTALL_DIR}/bin/zsh-patina" ] || echo '    zsh-patina not installed - using an unhighlighted shell (run "make downloads" for details)'
	command -v starship >/dev/null || [ -x "${INSTALL_DIR}/bin/starship" ] || echo '    starship not installed - using a plain prompt (apt: Ubuntu 25.04+/Debian 13+; brew: macOS)'

# Fetch the checksum-verified release binaries listed in DOWNLOADS.lock
# without reinstalling the config files.
downloads:
	$(TITLE) "Fetching downloads"
	$(Q)sh scripts/fetch-downloads.sh

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
