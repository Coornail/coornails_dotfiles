source ~/.zplug/init.zsh

zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh, nice:10
zplug "plugins/z", from:oh-my-zsh
zplug "themes/gentoo", from:oh-my-zsh
zplug "zsh-users/zaw"
zplug "zsh-users/zsh-syntax-highlighting"

zplug load --verbose

source $ZPLUG_HOME/repos/zsh-users/zaw/zaw.zsh

if [ $KERNEL = "Darwin" ]; then
  export PATH="/opt/local/bin/:/opt/local/libexec/gnubin/:$HOME/go/bin/:$PATH"
fi

if [ $KERNEL = "Linux" ]; then
  export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"
  alias ack="ack-grep"
fi

LS_ARGUMENTS="-G"
ls --help | grep "GNU coreutils" &>/dev/null 2>&1 && LS_VERSION="gnu" || LS_VERSION="bsd"
if [ "$LS_VERSION" = "gnu" ]; then
  LS_ARGUMENTS="--color=auto --classify"
fi

# file colors
GDIRCOLORS=`which gdircolors >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  eval "`gdircolors ~/dircolors.ansi-dark`"
fi

DIRCOLORS=`which dircolors >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  eval "`dircolors ~/dircolors.ansi-dark`"
fi


# Directory aliases

LS="ls $LS_ARGUMENTS"
alias la="$LS -lAHh"
alias ls=$LS
alias l=$LS

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

bindkey '^R' zaw-history
bindkey '^B' zaw-git-branches
zstyle ':filter-select' max-lines 5
zstyle ':filter-select:highlight' selected bg=red

# Zsh settings
setopt complete_in_word
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt listtypes
setopt menu_complete   # autoselect the first completion entry
setopt printexitvalue
setopt share_history

# History settings
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

# Zsh completion settings
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' file-sort 'time'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select
zstyle :compinstall filename '/Users/coornail/.zshrc'
autoload -Uz compinit
compinit

if [[ -f $HOME/.zshrc_private ]]; then
  source $HOME/.zshrc_private
fi
