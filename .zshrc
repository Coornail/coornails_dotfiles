eval "$(starship init zsh)"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git --depth=1 "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit load "zsh-users/zsh-autosuggestions"

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git

zinit ice wait lucid
zinit snippet OMZP::z

zinit ice wait lucid
zinit load "zdharma-continuum/fast-syntax-highlighting"

zinit ice wait lucid
zinit load "MichaelAquilina/zsh-you-should-use"

which fzf > /dev/null
if [[ "$?" == "0" ]]; then
  zinit ice wait lucid
  zinit light Aloxaf/fzf-tab

  zinit ice lucid wait'0'
  zinit light joshskidmore/zsh-fzf-history-search
else
  bindkey '^R' zaw-history # Fall back to history-search
fi

# dircolors
DIRCOLORS="dircolors"
`which gdircolors >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  DIRCOLORS="gdircolors"
fi
zinit ice atclone"$DIRCOLORS -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

# ZAW
ZAW_HOME="$(dirname $ZINIT_HOME)/zaw"
[ ! -d $ZAW_HOME ] && mkdir -p "$(dirname $ZAW_HOME)"
[ ! -d $ZAW_HOME/.git ] && git clone https://github.com/zsh-users/zaw.git --depth=1 "$ZAW_HOME"
source "$ZAW_HOME/zaw.zsh"

LS="ls"
LS_ARGUMENTS="-G"

if [ $KERNEL = "Darwin" ]; then
  eval "$(brew shellenv)"

  if [ -f "$HOMEBREW_PREFIX/bin/gls" ]; then
    LS="$HOMEBREW_PREFIX/bin/gls"
  fi

  FZF_ROOT="$HOMEBREW_PREFIX/opt/fzf"
  if [[ -d "$FZF_ROOT/shell" ]]; then
    for i in $(ls -1 $FZF_ROOT/shell/*.zsh); do
      source "$i"
    done
  fi
fi

if [ $KERNEL = "Linux" ]; then
  export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"
  alias ack="ack-grep"

  # https://github.com/junegunn/fzf/issues/2790
  zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
  zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
fi

`which direnv >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  eval "$(direnv hook zsh)"
fi

$LS --help | grep "GNU coreutils" &>/dev/null 2>&1 && LS_VERSION="gnu" || LS_VERSION="bsd"
if [ "$LS_VERSION" = "gnu" ]; then
  LS_ARGUMENTS="--color=auto --classify --group-directories-first"
fi

LS="$LS $LS_ARGUMENTS"
alias la="$LS -lAHh"
alias ls=$LS
alias l=$LS

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

bindkey -v
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
  # fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
  fbr() {
    local branches branch
    branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
      branch=$(echo "$branches" |
    fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
      git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  }

  # Sort using fzf
  # Based on https://github.com/Aloxaf/fzf-tab/issues/58#issuecomment-599178492
  zstyle ':fzf-tab:*'    fzf-flags  '--no-sort'
  zstyle ':completion:*' sort       'false'
fi

export TERM=xterm-256color

# FZF customization
export FZF_TMUX=1
export FZF_CTRL_T_OPTS="--preview 'cat {}'"

which highlight > /dev/null
if [[ "$?" == "0" ]]; then
  export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
fi

export YSU_MESSAGE_FORMAT="$(tput setaf 3)💡 %alias_type for %command: %alias$(tput sgr0)"

export DO_NOT_TRACK=1 # https://consoledonottrack.com/

autoload -Uz compinit
compinit
zinit cdreplay -q
