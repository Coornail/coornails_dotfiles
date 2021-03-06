# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zplug/init.zsh
source ~/.powerlevel10k/powerlevel10k.zsh-theme

zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh, defer:3
zplug "plugins/z", from:oh-my-zsh
#zplug "themes/gentoo", from:oh-my-zsh
zplug "zdharma/fast-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zaw", as:command
zplug "MichaelAquilina/zsh-you-should-use"

zplug check || zplug install
zplug load

#ZSH_THEME="robbyrussell"

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
setopt hist_ignore_space
setopt listtypes
setopt menu_complete   # autoselect the first completion entry
setopt printexitvalue
setopt prompt_subst
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
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=100'

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

export TERM=xterm-256color

# FZF customization
export FZF_TMUX=1
export FZF_CTRL_T_OPTS="--preview 'cat {}'"

if [[ -f "/usr/local/bin/highlight" ]]; then
  export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
fi

export YSU_MESSAGE_FORMAT="$(tput setaf 3)💡 %alias_type for %command: %alias$(tput sgr0)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export DO_NOT_TRACK=1 # https://consoledonottrack.com/
