# Oh my zsh
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gentoo"
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

plugins=(colored-man colorize composer docker git github gnu-utils history-substring-search tmux torrent vi-mode web-search z)
source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zaw/zaw.zsh

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

  plugins+=(macports osx)
fi
export PATH=$PATH:/usr/local/bin/

export LC_ALL=C
export TERM=xterm-256color

export SLASHEMOPTIONS="boulder:0, color, autodig, !cmdassist, norest_on_space, showexp"
export LSCOLORS=ExFxCxDxBxegedabagacad

bindkey '^R' zaw-history
bindkey '^B' zaw-git-branches

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

unsetopt beep notify
unsetopt bgnice autoparamslash
unsetopt ALL_EXPORT

setopt menu_complete   # autoselect the first completion entry

zstyle ':completion:*' file-sort 'time'

# Color support
autoload colors zsh/terminfo

colors
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
  eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
  (( count = $count + 1 ))
done

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

alias ....='cd ../../..'
alias .....='cd ../../../..'

alias drush='~/shellscript/drush/drush'

# correcting some keys
autoload zkbd

# for cd, only list dirs
compctl -/ cd

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
  "pris")      TERM_COLOR=$PR_GREEN ;;
  "debian")    TERM_COLOR=$PR_YELLOW ;;
  "li66-97")   TERM_COLOR=$PR_MAGENTA ;;
  "li501-135") TERM_COLOR=$PR_RED ;;
  *)           TERM_COLOR=$PR_BLUE ;;
esac

PROMPT="%(!.%{$fg_bold[red]%}.%{$TERM_COLOR%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) $(git_prompt_info)%_$(prompt_char)%{$reset_color%} "

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
