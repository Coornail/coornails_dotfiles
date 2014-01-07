# Oh my zsh
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gentoo"
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

plugins=(git colorize composer docker github gnu-utils tmux torrent z)
source $ZSH/oh-my-zsh.sh

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
KERNEL=`uname`
HOSTNAME=`hostname -s`

export PAGER=`which less`
export EDITOR=`which vim`

# OsX specific stuff
if [ $KERNEL = "Darwin" ]; then
  # macports
  export PATH=/opt/local/bin:/opt/local/sbin/:$PATH
  export MANPATH=/opt/local/share/man:$MANPATH

  alias hibernate=osascript -e 'tell application "System Events" to sleep'
  alias startftp='sudo -s launchctl load -w /System/Library/LaunchDaemons/ftp.plist'
  alias c='pbcopy'
  alias p='pbpaste'
fi
export PATH=$PATH:/usr/local/bin/

export LC_ALL=C
export TERM=xterm-256color
# I don't use it most of the time
export no_git_prompt=true

export SLASHEMOPTIONS="boulder:0, color, autodig, !cmdassist, norest_on_space, showexp"
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Keyboard bindings
bindkey -v
bindkey "^[OD" backward-word
bindkey "^[OC" forward-word

# page up and down
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey '^[[5~' history-beginning-search-backward
bindkey '^[[6~' history-beginning-search-forward

bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

bindkey "^R" history-incremental-search-backward


# Autoload zsh modules
autoload -Uz compinit
compinit -d $TMPDIR/zsh_compinit
autoload zmv

setopt no_hup hist_verify
setopt CORRECT      # command CORRECTION
setopt MENUCOMPLETE
setopt ALL_EXPORT
setopt appendhistory autocd extendedglob nomatch
setopt notify globdots correct pushdtohome cdablevars autolist
setopt correctall recexact longlistjobs
setopt autoresume histignoredups pushdsilent
setopt autopushd pushdminus rcquotes
setopt listtypes
setopt noshwordsplit
setopt printexitvalue
setopt hist_ignore_all_dups
setopt sharehistory
setopt prompt_subst  # show git branch if in a git repo

unsetopt menucomplete
unsetopt beep notify
unsetopt bgnice autoparamslash
unsetopt ALL_EXPORT

zstyle ':completion:*' file-sort 'time'

# Color support
autoload colors zsh/terminfo
colors

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
  eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
  (( count = $count + 1 ))
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"

# aliases
case "$KERNEL" in
  "Darwin")
    GLS=`which gls >> /dev/null &> /dev/null`
    if [ $? -eq 0 ]; then
      alias ls='gls --color=always -A'
    else
      alias ls='ls -G'
    fi
  ;;

  "Linux")  alias ls='ls --color=always -A' ;;
esac
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias vimremote='mvim --remote'
alias vimremoteall="find . -type f \( -name '*.module' -o -name '*.inc' \) | xargs vim --servername GVIM --remote-silent"
alias la='ls -lAHh'
alias l='ls'
alias webserv='python -m SimpleHTTPServer'
alias ack='ack-grep'
alias rsyncssh="rsync -avz --progress -e ssh "
alias json_pretty_print='python -m json.tool'

# Generate longer passwords
alias pwgen='pwgen 16'

# I want the downloaded file to be the newest in the directory
# Zsh completes it easier
alias wget='wget --no-use-server-timestamps --no-check-certificate '

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias gww='cd /Users/coornail/localhost/htdocs/'

alias drush='~/shellscript/drush/drush'

# correcting some keys
autoload zkbd
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

# completion stuff
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu yes select
xdvi() { command xdvi ${*:-*.dvi(om[1])} }
zstyle ':completion:*:*:xdvi:*' menu yes select
zstyle ':completion:*:*:xdvi:*' file-sort time
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*' ignored-patterns '*.sw*'
zstyle ':completion:*:urls' local /var/www/localhost/htdocs/
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete

# case-insensitive (all),partial-word and then substring completion
# http://www.rlazo.org/2010/11/18/zsh-case-insensitive-completion/
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
      'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# formatting and messages
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
# for cd, only list dirs
compctl -/ cd

_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1  # Because we didn't really complete anything
}

# file colors
GDIRCOLORS=`which gdircolors >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  eval "`gdircolors`"
fi

DIRCOLORS=`which dircolors >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  eval "`dircolors`"
fi

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Set terminal color
case "$HOSTNAME" in
  "centosvm")  TERM_COLOR=$PR_YELLOW ;;
  "li66-97")   TERM_COLOR=$PR_MAGENTA ;;
  "li501-135") TERM_COLOR=$PR_RED ;;
  "pris")      TERM_COLOR=$PR_GREEN ;;
  *)           TERM_COLOR=$PR_BLUE ;;
esac

translate() {
  wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=${2:-en}|${3:-hu}" | sed -E -n 's/[[:alnum:]": {}]+"translatedText":"([^"]+)".*/\1/p';
  echo ''
  return 0;
}

unset http_proxy

# Z command for frequently used directories
export _Z_DATA=~/.zsh/.z_cache

# todo.sh
alias t="~/shellscript/todo.sh"
export TODOTXT_DEFAULT_ACTION=ls

# Command line edit for ESC-v
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Set locale.
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Decrease autossh poll delay.
export AUTOSSH_POLL=60
