# Coornail's dotfiles

A few of my dotfiles.

Feel free to clone or just get ideas from it.
I'd be happy if you would create a merge request if I missed something or if I made a mistake.

# Dependencies:
* make
* git
* curl
* zsh
* starship - Optional; the shell falls back to a plain prompt without it.
  `apt install starship` on Ubuntu 25.04+ and Debian 13+, `brew install starship`
  on macOS. On older releases neither repo has it: use the release binary from
  https://github.com/starship/starship/releases
* tmux
* vim (with +python3 for UltiSnips)
* fzf - Optional
* direnv - Optional
* universal-ctags - for tagbar and `:Tags`
* exiftool - for image diffs
* urlview - for the tmux URL picker
* zsh-patina - optional; `make zsh` fetches it from a pinned release and
  checksum-verifies it (see DOWNLOADS.lock). Without it the shell starts
  unhighlighted.

# Usage
`make [zsh|git|tmux|vim|ssh|verify|downloads]`

`verify` re-hashes the vendored sources listed in SOURCES.lock; `downloads`
re-checks the installed release binaries listed in DOWNLOADS.lock (and fetches
them if missing). `make zsh` runs the same fetch best-effort, so a machine
without network still gets a working, unhighlighted shell.

zinit is vendored in `sources/zinit` as well (pinned in SOURCES.lock).
`make zsh` installs it to `${XDG_DATA_HOME:-~/.local/share}/zinit/zinit.git`,
so no shell clones the plugin manager at startup; a machine without that
install starts without zinit plugins and says so. The plugins zinit loads are
still cloned on first use -- only zinit itself is vendored.
