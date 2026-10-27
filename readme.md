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

# Usage
`make [zsh|git|tmux|vim|ssh]`
