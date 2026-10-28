#!/bin/sh
# Container probe for the vendored zsh setup.
#
# Run inside a throwaway Ubuntu container with the repo mounted read-only:
#   ddocker run --rm --ddocker-unsafe \
#     -v /opt/data/1-projects/coornails_dotfiles:/repo:ro \
#     --entrypoint "" ubuntu:26.04 sh /repo/scripts/shell-start-probe.sh
#
# Asserts: make verify green, `make zsh` installs the vendored sources, a second
# interactive shell writes nothing to stderr, the plugins are loaded, fzf owns
# ^R in vi insert mode, and no zinit tree or compiled files exist.
set -eu
export HOME=/root
export XDG_DATA_HOME="$HOME/.local/share"
export DEBIAN_FRONTEND=noninteractive
export TERM=xterm-256color
REPO=/repo

fail() { printf '[FAIL] %s\n' "$*" >&2; exit 1; }

echo '[+] installing dependencies'
apt-get update -q -o APT::Sandbox::User=root
apt-get install -y -q -o APT::Sandbox::User=root \
  zsh make git fzf ca-certificates curl util-linux >/dev/null

echo '[+] make verify'
cd "$REPO"
make verify

echo '[+] make zsh'
make INSTALL_DIR="$HOME" zsh

# `zsh -i -c` is not a PTY, so `fzf --zsh`'s zle calls fail with "can't change
# option: zle" even in a healthy shell. Drive a real PTY with `script(1)` so the
# assertion is about the rc file, not the harness.
echo '[+] second interactive shell: stderr must be empty'
err=$(mktemp)
script -qec 'zsh -i -c "exit"' /dev/null >/dev/null 2>"$err" || true
if [ -s "$err" ]; then
  printf '[FAIL] second shell wrote to stderr:\n' >&2
  cat "$err" >&2
  exit 1
fi
echo '[PASS] stderr empty'

echo '[+] vendored plugins are loaded'
script -qec 'zsh -i -c "rc=0; (( \$+functions[_zsh_autosuggest_start] )) || { print -u2 autosuggestions-not-loaded; rc=1 }; (( \$+functions[git_current_branch] )) || { print -u2 omz-git-not-loaded; rc=1 }; (( \$+functions[zshz] )) || (( \$+functions[_zshz] )) || { print -u2 omz-z-not-loaded; rc=1 }; (( \$+functions[check_alias_usage] )) || { print -u2 you-should-use-not-loaded; rc=1 }; [[ -n \$LS_COLORS ]] || { print -u2 LS_COLORS-empty; rc=1 }; exit \$rc"' /dev/null >/dev/null 2>&1 \
  || fail 'plugin assertions'
echo '[PASS] plugins loaded'

echo '[+] zsh-patina fetched and checksum-verified'
[ -x "$HOME/bin/zsh-patina" ] || fail 'zsh-patina not installed by make zsh'
sha256sum "$HOME/bin/zsh-patina" | grep -q '6669e4c46b52bd41ed30573986bcaf52c96af56e90a8826ae0c0d218c3c6b321' \
  || fail 'installed zsh-patina does not match DOWNLOADS.lock binary hash'
echo '[PASS] zsh-patina binary hash matches DOWNLOADS.lock'

echo '[+] fzf owns ^R in vi insert mode'
binding=$(script -qec 'zsh -i -c "bindkey -M viins ^R"' /dev/null 2>/dev/null | tr -d '\r')
case "$binding" in
  *fzf-history-widget*) echo '[PASS] ^R -> fzf-history-widget' ;;
  *) fail "viins ^R binding is: $binding" ;;
esac

echo '[+] no zinit checkout, no compiled files'
[ ! -d "$XDG_DATA_HOME/zinit" ] || fail 'zinit install dir still created'
if find "$XDG_DATA_HOME" -name '*.zwc' 2>/dev/null | grep -q .; then
  fail 'compiled *.zwc found in the install tree'
fi
echo '[PASS] clean install tree'

printf '\n[PASS] shell-start probe completed\n'
