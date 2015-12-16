[ -z "$PS1" ] && return

source ~/.zplug/zplug

if [[ -f $HOME/.zshrc_private ]]; then
  source $HOME/.zshrc_private
fi

zplug "plugins/catimg", from:oh-my-zsh
zplug "plugins/colored-man", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/compleat", from:oh-my-zsh
zplug "plugins/composer", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/emoji", from:oh-my-zsh
zplug "plugins/gitfast", from:oh-my-zsh
zplug "plugins/git-extras", from:oh-my-zsh
zplug "plugins/github", from:oh-my-zsh
zplug "plugins/gitignore", from:oh-my-zsh
zplug "plugins/gnu-utils", from:oh-my-zsh
zplug "plugins/golang", from:oh-my-zsh
zplug "plugins/grunt", from:oh-my-zsh
zplug "plugins/history-substring-search", from:oh-my-zsh
zplug "plugins/jsontools", from:oh-my-zsh
zplug "plugins/node", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/torrent", from:oh-my-zsh
zplug "plugins/vagrant", from:oh-my-zsh
#zplug "plugins/ vi-mode", from:oh-my-zsh
zplug "plugins/web-search", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "themes/gentoo", from:oh-my-zsh

# Non oh-my-zsh plugins:
zplug "rimraf/k"
zplug "rummik/zsh-isup"
zplug "zsh-users/zaw"
zplug "zsh-users/zsh-syntax-highlighting"

zplug "plugins/macports", from:oh-my-zsh, if:"[ $kernel == *darwin* ]"
zplug "plugins/osx", from:oh-my-zsh, if:"[ $kernel == *darwin* ]"

zplug load

source ~/.zplug/repos/zsh-users/zaw/zaw.zsh
source ~/.zplug/repos/rimraf/k/k.sh
source ~/.zplug/repos/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Vi mode is broken: https://github.com/robbyrussell/oh-my-zsh/issues/2815
# set -o vi

# Hack around command not found when including .plugin.zsh files
#source ~/.antigen/repos/*zsh-syntax-highlighting.git/zsh-syntax-highlighting.zsh
#source ~/.antigen/repos/*zaw.git/zaw.zsh
#source ~/.antigen/repos/*k.git/k.sh

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
KERNEL=`uname`
HOSTNAME=`hostname -s`

export PAGER=`which less`
export EDITOR=`which vim`

# Linux specific stuff
if [ $KERNEL = "Linux" ]; then
  export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"
  alias ack="ack-grep"
fi

# OsX specific stuff
if [ $KERNEL = "Darwin" ]; then
  alias hibernate=pmset sleepnow
  alias startftp='sudo -s launchctl load -w /System/Library/LaunchDaemons/ftp.plist'
  alias c='pbcopy'
  alias p='pbpaste'

  export PATH="/opt/local/bin/:/opt/local/libexec/gnubin/:$HOME/go/bin/:$PATH"
fi

export TERM=xterm-256color

export SLASHEMOPTIONS="boulder:0, color, autodig, !cmdassist, norest_on_space, showexp"
export LSCOLORS=ExFxCxDxBxegedabagacad

zstyle ':filter-select' max-lines 5
bindkey '^R' zaw-history
bindkey '^B' zaw-git-branches
zstyle ':filter-select:highlight' selected bg=red

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey '^X^H' run-help

autoload zmv

setopt no_hup hist_verify
setopt ALL_EXPORT
setopt nomatch
setopt notify globdots correct pushdtohome cdablevars autolist
setopt correctall recexact longlistjobs
setopt autoresume pushdsilent
setopt autopushd rcquotes
setopt listtypes
setopt noshwordsplit
setopt printexitvalue
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_ignore_all_dups

unsetopt beep notify
unsetopt autoparamslash
unsetopt ALL_EXPORT

setopt menu_complete   # autoselect the first completion entry

zstyle ':completion:*' file-sort 'time'

if [ $KERNEL = "Darwin" ]; then
  LS_ARGUMENTS="-G"
fi

ls --help | grep "GNU coreutils" &>/dev/null 2>&1 && LS_VERSION="gnu" || LS_VERSION="bsd"
if [ "$LS_VERSION" = "gnu" ]; then
  LS_ARGUMENTS="--color=auto --classify"
fi

LS="ls $LS_ARGUMENTS"
alias la="$LS -lAHh"
alias ls=$LS
alias l=$LS
alias k="k -h"

alias vimremote='mvim --remote'
alias vimremoteall="find . -type f \( -name '*.module' -o -name '*.inc' \) | xargs vim --servername GVIM --remote-silent"
alias webserv='python -m SimpleHTTPServer'
alias rsyncssh="rsync -avz --partial --progress -e ssh "
alias json_pretty_print='python -m json.tool'

# Generate longer passwords
alias pwgen='pwgen 16'

# I want the downloaded file to be the newest in the directory
# Zsh completes it easier
alias wget='wget --no-use-server-timestamps --no-check-certificate '

alias ....='cd ../../..'
alias .....='cd ../../../..'
alias more="less"
alias ghpush="git push gh $(current_branch)"

# correcting some keys
autoload zkbd

# for cd, only list dirs
compctl -/ cd

# file colors
GDIRCOLORS=`which gdircolors >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  eval "`gdircolors ~/dircolors.ansi-dark`"
fi

DIRCOLORS=`which dircolors >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  eval "`dircolors ~/dircolors.ansi-dark`"
fi

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Set terminal color
case "$COMPUTER_TYPE" in
  "desktop") TERM_COLOR=$fg_no_bold[green] ;;
  "dev")     TERM_COLOR=$fg_no_bold[yellow] ;;
  "vm")      TERM_COLOR=$fg_no_bold[gray] ;;
  "live")    TERM_COLOR=$fg_bold[red] ;;
  *)         TERM_COLOR=$fg_no_bold[blue] ;;
esac

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%(!.%{$fg_bold[red]%}.%{$TERM_COLOR%}%n@)%m:%{$fg[blue]%}%(!.%1~.%~)$(git_prompt_info)%_$(prompt_char)%{$reset_color%} '

unset http_proxy

# Set locale.
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Decrease autossh poll delay.
export AUTOSSH_POLL=60

# Use the "screen" TERM inside tmux.
if [ -n "$TMUX" ]; then
  export TERM="screen-256color"
fi

# Vi mode customization
# Based on: http://dougblack.io/words/zsh-vi-mode.html

# Backspace and ^h working even after returning from command mode.
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# Ctrl-w removed word backwards.
bindkey '^w' backward-kill-word

# By default, there is a 0.4 second delay after you hit the <ESC> key and when
# the mode change is registered. This results in a very jarring and
# frustrating transition between modes. Let's reduce this delay to 0.1 seconds.
export KEYTIMEOUT=1

# Lesspipe support.
eval `lesspipe 2>/dev/null || lesspipe.sh 2>/dev/null`

# Increase maximum open files
ulimit -S -n 4096

export _Z_DATA="$HOME/.z"

# Fix reverse ordering history.
function zaw-src-history() {
  if [[ -o hist_find_no_dups ]]; then
    candidates=(${(@vu)history})
  else
    cands_assoc=("${(@kv)history}")
  fi
  actions=("zaw-callback-execute" "zaw-callback-replace-buffer" "zaw-callback-append-to-buffer")
  act_descriptions=("execute" "replace edit buffer" "append to edit buffer")
  options=("-m" "-s" "${BUFFER}")

  if (( $+functions[zaw-bookmark-add] )); then
     zaw-src-bookmark is available
    actions+="zaw-bookmark-add"
    act_descriptions+="bookmark this command line"
  fi
}

zaw-register-src -n history zaw-src-history
