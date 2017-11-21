source ~/.zplug/init.zsh

zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh, defer:3
zplug "plugins/z", from:oh-my-zsh
zplug "themes/gentoo", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zaw", as:command

zplug check || zplug install
zplug load

ZSH_THEME="robbyrussell"

source $ZPLUG_HOME/repos/zsh-users/zaw/zaw.zsh

if [ $KERNEL = "Darwin" ]; then
  export PATH="/opt/local/bin:/usr/local/bin:/usr/local/sbin:$HOME/go/bin:$PATH"
fi

if [ $KERNEL = "Linux" ]; then
  export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"
  alias ack="ack-grep"
fi

# ls
LS="ls"
if [ -f "/usr/local/bin/gls" ]; then
  LS="gls"
fi

LS_ARGUMENTS="-G"
$LS --help | grep "GNU coreutils" &>/dev/null 2>&1 && LS_VERSION="gnu" || LS_VERSION="bsd"
if [ "$LS_VERSION" = "gnu" ]; then
  LS_ARGUMENTS="--color=auto --classify"
fi

LS="$LS $LS_ARGUMENTS"
alias la="$LS -lAHh"
alias ls=$LS
alias l=$LS

# file colors
GDIRCOLORS=`which gdircolors >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  eval "`gdircolors ~/dircolors.ansi-dark`"
fi

DIRCOLORS=`which dircolors >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  eval "`dircolors --sh ~/dircolors.ansi-dark`"
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

bindkey -v
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
setopt prompt_subst

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
autoload -Uz compinit
compinit

# Zsh autosuggestions
bindkey '^ ' autosuggest-execute

# Own strategy to complete cd commands.
_zsh_autosuggest_strategy_match_prev_cmd_and_cd() {
	local prefix="$1"

  if [[ "$prefix" =~ ^cd\ .* ]]; then
  else
    _zsh_autosuggest_strategy_match_prev_cmd $prefix
  fi
}

ZSH_AUTOSUGGEST_STRATEGY="match_prev_cmd_and_cd"

# https://blog.packagecloud.io/eng/2017/02/21/set-environment-variable-save-thousands-of-system-calls/
export TZ=":/etc/localtime"

if [[ -f $HOME/.zshrc_private ]]; then
  source $HOME/.zshrc_private
fi

# FZF specific stuff.
which fzf > /dev/null
if [[ "$?" == "0" ]]; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  # fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
  fbr() {
    local branches branch
    branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
      branch=$(echo "$branches" |
    fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
      git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  }
fi
