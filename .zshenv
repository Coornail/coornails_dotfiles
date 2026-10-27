export PATH=$PATH:$HOME/bin/

# Debian/Ubuntu's /etc/zsh/zshrc runs compinit before this file's .zshrc is
# read. That first run caches a dump without zinit's completion dirs, so the
# compinit in .zshrc has to rebuild it -- on every shell. Skip the global one;
# .zshrc still runs compinit after zinit has loaded.
skip_global_compinit=1
