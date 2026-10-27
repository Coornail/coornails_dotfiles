eval "$(starship init zsh)"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git --depth=1 "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit load "kevinywlui/zlong_alert.zsh"
zlong_duration=60
zlong_ignore_cmds="vim ssh"

zinit load "zsh-users/zsh-autosuggestions"

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
#zinit snippet OMZP::colorize

zinit ice wait lucid
zinit snippet OMZP::z

#zinit ice wait lucid
#zinit load "zdharma-continuum/fast-syntax-highlighting"

zinit ice as"program" from"gh-r" pick"zsh-patina-*/zsh-patina" atload'eval "$(zsh-patina activate)"'
zinit light michel-kraemer/zsh-patina

zinit ice wait lucid
zinit load "MichaelAquilina/zsh-you-should-use"

setopt AUTO_CD

which fzf > /dev/null
if [[ "$?" == "0" ]]; then
  #zinit ftb-tmux-popup light Aloxaf/fzf-tab

  zinit ice lucid wait'0'
  zinit light joshskidmore/zsh-fzf-history-search
  zinit load "andrewferrier/fzf-z"
fi

zinit light trapd00r/LS_COLORS

LS="ls"
LS_ARGUMENTS="-G"

KERNEL=`uname`

if [ $KERNEL = "Darwin" ]; then
  eval "$(brew shellenv)"

  if [ -f "$HOMEBREW_PREFIX/bin/gls" ]; then
    LS="$HOMEBREW_PREFIX/bin/gls"
  fi

  source <(fzf --zsh)
  ulimit -n 4096
fi

if [ $KERNEL = "Linux" ]; then
  export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"

  # https://github.com/junegunn/fzf/issues/2790
  zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
  zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
fi

`which direnv >> /dev/null &> /dev/null`
if [ $? -eq 0 ]; then
  eval "$(direnv hook zsh)"
fi

# GNU and uutils ls accept the long flags; BSD/macOS ls only has -G. Probe
# the flags instead of parsing --help, which uutils ls (Ubuntu 26.04+) does
# not label "GNU coreutils".
if $LS --color=auto --classify --group-directories-first -d / &>/dev/null; then
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

function docker-compose () {
  docker compose $*
}

bindkey -v
# ^R is 'redisplay' in vi insert mode, so bind history search explicitly:
# fzf's widget when it is loaded, plain reverse search otherwise.
if (( ${+functions[fzf_history_search]} )); then
  bindkey -M viins '^R' fzf_history_search
  bindkey -M emacs '^R' fzf_history_search
else
  bindkey -M viins '^R' history-incremental-search-backward
fi

# Zsh settings
setopt complete_in_word
setopt hist_find_no_dups
setopt hist_ignore_all_dups
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

ZSH_AUTOSUGGEST_STRATEGY="match_prev_cmd"
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

  # Keep completion matches in insertion order.
  zstyle ':completion:*' sort 'false'
  zstyle ':completion:*:descriptions' format '[%d]'

  export FZF_TMUX=1
  export FZF_DEFAULT_OPTS="--tmux 80% -m --walker-skip .git,node_modules,.venv --margin=2 --reverse --preview 'fzf-preview.sh {}'"

  fzf-git-add() {
    git ls-files -m --exclude-standard | fzf --print0 -m --preview 'git diff --color=always --no-ext-diff {}' | xargs -0 -t -o git add -p
  }

  fzf-git-branch() {
    git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)' | fzf --print0 --preview 'git diff --shortstat --color=always --no-ext-diff {}; echo ""; git log --oneline HEAD..{}'| xargs -0 -t -o git switch
  }

  fzf-git-worktree-change() {
    local selected
    selected=$(git worktree list --porcelain | awk '/^worktree / {print $2}' | fzf \
      --preview 'BRANCH=$(git -C {} rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"); echo "Branch: $BRANCH"; echo "Dir: $(basename {})"; echo ""; git diff --shortstat --color=always --no-ext-diff HEAD..$BRANCH' \
      --preview-window=right:50% \
      --prompt="Select worktree: ")

    if [[ -n "$selected" ]]; then
      cd "$selected"
    fi
  }

  zle -N fzf-git-add fzf-git-add
  zle -N fzf-git-branch fzf-git-branch
  zle -N fzf-git-worktree-change fzf-git-worktree-change
  bindkey '^N' fzf-git-add
  bindkey '^B' fzf-git-branch
  bindkey '^Y' fzf-git-worktree-change
fi

export YSU_MESSAGE_FORMAT="$(tput setaf 3)💡 %alias_type for %command: %alias$(tput sgr0)"
export YSU_HARDCORE_ALIASES=()

export DO_NOT_TRACK=1 # https://consoledonottrack.com/

# Aider
export AIDER_VIM=true
export AIDER_AUTO_COMMITS=false

autoload -Uz compinit
compinit
zinit cdreplay -q

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi
