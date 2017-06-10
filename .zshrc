source ~/.zplug/init.zsh

zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh, nice:10
zplug "plugins/z", from:oh-my-zsh
zplug "themes/gentoo", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zaw", nice:1

zplug load --verbose

ZSH_THEME="robbyrussell"


source $ZPLUG_HOME/repos/zsh-users/zaw/zaw.zsh

if [ $KERNEL = "Darwin" ]; then
  export PATH="/opt/local/bin:/usr/local/bin:/usr/local/sbin:$HOME/go/bin:$PATH"
fi

if [ $KERNEL = "Linux" ]; then
  export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"
  alias ack="ack-grep"
fi

LS_ARGUMENTS="-G"
gls --help | grep "GNU coreutils" &>/dev/null 2>&1 && LS_VERSION="gnu" || LS_VERSION="bsd"
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
LS="gls $LS_ARGUMENTS"
alias la="$LS -lAHh"
alias ls=$LS
alias l=$LS

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

bindkey '^R' zaw-history
#bindkey '^B' zaw-git-branches
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
zstyle :compinstall filename '/Users/coornail/.zshrc'
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
# Based on https://github.com/junegunn/dotfiles/blob/master/bashrc
which fzf > /dev/null
if [[ "$?" == "0" ]]; then
  __fzfcmd() {
    [ ${FZF_TMUX:-1} -eq 1 ] && echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
  }

  # ^R reverse history
  fzf-history-widget() {
    local selected num
    setopt localoptions noglobsubst pipefail 2> /dev/null
    selected=( $(fc -l 1 | eval "$(__fzfcmd) +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r $FZF_CTRL_R_OPTS -q ${(q)LBUFFER}") )
    local ret=$?
    if [ -n "$selected" ]; then
      num=$selected[1]
      if [ -n "$num" ]; then
        zle vi-fetch-history -n $num
      fi
    fi
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
  }
  zle     -N   fzf-history-widget
  bindkey '^R' fzf-history-widget


	# c - browse chrome history
	c() {
		local cols sep
		export cols=$(( COLUMNS / 3 ))
		export sep='{::}'

		cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h
		sqlite3 -separator $sep /tmp/h \
			"select title, url from urls order by last_visit_time desc" |
		ruby -ne '
			cols = ENV["cols"].to_i
			title, url = $_.split(ENV["sep"])
			len = 0
			puts "\x1b[36m" + title.each_char.take_while { |e|
				if len < cols
					len += e =~ /\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/ ? 2 : 1
				end
			}.join + " " * (2 + cols - len) + "\x1b[m" + url' |
		fzf --ansi --multi --no-hscroll --tiebreak=index |
		sed 's#.*\(https*://\)#\1#' | xargs open
	}

#  # gb is aliases to git branch by oh-my-zsh
#  unalias gb
#
#  is_in_git_repo() {
#    git rev-parse HEAD > /dev/null 2>&1
#  }
#
#  # Change git branch
#  gb() {
#    is_in_git_repo || return
#    git branch -a --color=always | grep -v '/HEAD\s' | sort |
#    fzf-tmux --ansi --multi --tac --preview-window right:70% \
#        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
#    sed 's/^..//' | cut -d' ' -f1 |
#    sed 's#^remotes/##'
#  }
#
  fbr() {
    local branches branch
    branches=$(git branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
  }
fi

