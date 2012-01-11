HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
bindkey -v

KERNEL=`uname`

# macports
if [ $KERNEL = "Darwin" ]; then
  export PATH=/opt/local/bin:/opt/local/sbin:$PATH
  export PATH=$PATH:/Applications/MAMP/Library/bin/
  export MANPATH=/opt/local/share/man:$MANPATH
fi

# locale
export LC_ALL=C

bindkey "^[OD" backward-word
bindkey "^[OC" forward-word

# Autoload zsh modules
autoload -Uz compinit
compinit
autoload zmv

export TERM=xterm-color

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

# Autoload zsh modules when they are referenced
#zmodload -a zsh/stat stat
#zmodload -a zsh/zpty zpty
#zmodload -a zsh/zprof zprof
#zmodload -ap zsh/mapfile mapfile

HOSTNAME="`hostname`"
PAGER='less'
EDITOR='vim'

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
  "Darwin") alias ls='gls --color=always -A' ;;
  "Linux")  alias ls='ls --color=always -A' ;;
esac
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias vimremote='mvim --remote'
alias vimremoteall="find . -type f \( -name '*.module' -o -name '*.inc' \) | xargs vim --servername GVIM --remote-silent"
alias la='ls -lAHh'
alias l='ls'
alias z='7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on'
alias webserv='python -m SimpleHTTPServer'
alias ack='ack-grep'
alias rsyncssh="rsync -avz --progress -e ssh "

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

function git-branch-name () {
  git branch 2> /dev/null | grep '^\*' | sed 's/^\*\ //'
}

function git-dirty () {
  git status 2> /dev/null | grep "nothing to commit (working directory clean)"
  echo $?
}

# I don't use it most of the time
export no_git_prompt=true

function git-prompt() {
  if [ $no_git_prompt ]; then
    return
  fi
  gstatus=$(git status 2> /dev/null)
  branch=$(echo $gstatus | head -1 | sed 's/^# On branch //')
  dirty=$(echo $gstatus | sed 's/^#.*$//' | tail -2 | grep 'nothing to commit (working directory clean)'; echo $?)
  if [[ x$branch != x ]]; then
    dirty_color=$fg[green]
    if [[ $dirty = 1 ]] { dirty_color=$fg[red] }
    [ x$branch != x ] && echo "%{$PR_BLUE%}[%{$dirty_color%}$branch%{$reset_color%}%{$PR_BLUE%}]"
  fi
}

function git-scoreboard () {
  git log | grep Author | sort | uniq -ci | sort -r
}

# Set terminal color
HOSTNAME=`hostname -s`

case "$HOSTNAME" in
  "pris")    TERM_COLOR=$PR_GREEN ;;
  "li66-97") TERM_COLOR=$PR_MAGENTA ;;
  *)         TERM_COLOR=$PR_BLUE ;;
esac

PROMPT='%{$TERM_COLOR%}%n@%m%u%{$PR_NO_COLOR%}:%{$PR_BLUE%}%~`git-prompt`%{$reset_color%}%(!.#.$) '

translate() {
  wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=${2:-en}|${3:-hu}" | sed -E -n 's/[[:alnum:]": {}]+"translatedText":"([^"]+)".*/\1/p';
  echo ''
  return 0;
}

unset http_proxy

export SLASHEMOPTIONS="boulder:0, color, autodig, !cmdassist, norest_on_space, showexp"
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

#node.js
export NODE_PATH="/usr/local/lib/node"
export PATH=$PATH:~/.npm/less/1.1.2/package/bin/

export ECO="lp:~economist-magic/economist-magic"

# Private zshrc
if [ -f ~/.zshrc_private ]
  then
    source ~/.zshrc_private
fi

