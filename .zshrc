[ -z "$PS1" ] && return

DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="true"

# Antigen
ZSHA_BASE=$HOME/.zsh-antigen
source $ZSHA_BASE/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
  catimg
  colored-man
  colorize
  compleat
  composer
  docker
  git
  git-extras
  github
  gitignore
  gnu-utils
  history-substring-search
  jsontools
  node
  npm
  tmux
  torrent
  vagrant
  vi-mode
  web-search
  z

  # Non oh-my-zsh plugins:
  rummik/zsh-isup
  zsh-users/zaw
  zsh-users/zsh-syntax-highlighting
EOBUNDLES

# Hack around command not found when including .plugin.zsh files
source ~/.antigen/repos/*zsh-syntax-highlighting.git/zsh-syntax-highlighting.zsh
source ~/.antigen/repos/*zaw.git/zaw.zsh

antigen theme gentoo

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

  antigen bundle macports
  antigen bundle osx
  export PATH="/opt/local/libexec/gnubin/:$PATH"
fi
antigen apply

export TERM=xterm-256color

export SLASHEMOPTIONS="boulder:0, color, autodig, !cmdassist, norest_on_space, showexp"
export LSCOLORS=ExFxCxDxBxegedabagacad

bindkey '^R' zaw-history
bindkey '^B' zaw-git-branches
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

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
unsetopt bgnice autoparamslash
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

alias vimremote='mvim --remote'
alias vimremoteall="find . -type f \( -name '*.module' -o -name '*.inc' \) | xargs vim --servername GVIM --remote-silent"
alias webserv='python -m SimpleHTTPServer'
alias rsyncssh="rsync -avz --progress -e ssh "
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
case "$HOSTNAME" in
  "pris")      TERM_COLOR=$fg_no_bold[green] ;;
  "debian")    TERM_COLOR=$fg_no_bold[yellow] ;;
  "li66-97")   TERM_COLOR=$fg_no_bold[magenta] ;;
  "li624-36")  TERM_COLOR=$fg_bold[red] ;;
  "li501-135") TERM_COLOR=$fg_bold[red] ;;
  *)           TERM_COLOR=$fg_no_bold[blue] ;;
esac

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%(!.%{$fg_bold[red]%}.%{$TERM_COLOR%}%n@)%m:%{$fg_bold[blue]%}%(!.%1~.%~)$(git_prompt_info)%_$(prompt_char)%{$reset_color%} '

translate() {
  wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=${2:-en}|${3:-hu}" | sed -E -n 's/[[:alnum:]": {}]+"translatedText":"([^"]+)".*/\1/p';
  echo ''
  return 0;
}

unset http_proxy

# Set locale.
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Decrease autossh poll delay.
export AUTOSSH_POLL=60

# Use the "screen" TERM inside tmux.
if [ -n "$TMUX" ]; then
  export TERM="screen"
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
