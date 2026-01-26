eval "$(starship init zsh)"

# =============================================================================
# Private config
# =============================================================================
if [[ -f $HOME/.zshrc_private ]]; then
  source $HOME/.zshrc_private
fi

# =============================================================================
# Zcomet Plugin Manager (Fastest startup times)
# =============================================================================
ZCOMET_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zcomet"
[ ! -d $ZCOMET_HOME ] && mkdir -p "$(dirname $ZCOMET_HOME)"
[ ! -d $ZCOMET_HOME/.git ] && git clone https://github.com/agkozak/zcomet.git  --depth=1 "$ZCOMET_HOME"
source "${ZCOMET_HOME}/zcomet.zsh"

# =============================================================================
# Plugins
# =============================================================================

# Long command alert
zcomet load kevinywlui/zlong_alert.zsh
zlong_duration=60
zlong_ignore_cmds="vim ssh"

# Autosuggestions
zcomet load zsh-users/zsh-autosuggestions

# Git plugins (OMZ snippets)
zcomet snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/git.zsh
zcomet snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh

# Fast syntax highlighting (deferred for performance)
zcomet load zdharma-continuum/fast-syntax-highlighting

# "You should use" alias hints - manually load for zcomet compatibility
YSHU_HOME="${ZCOMET_HOME}/repos/you-should-use"
[ ! -d $YSHU_HOME ] && git clone https://github.com/MichaelAquilina/zsh-you-should-use.git --depth=1 "$YSHU_HOME"
[ -f "$YSHU_HOME/you-should-use.plugin.zsh" ] && source "$YSHU_HOME/you-should-use.plugin.zsh"

# FZF integration
if command -v fzf &>/dev/null; then
  # FZF history search
  zcomet load joshskidmore/zsh-fzf-history-search
  # FZF-z for directory jumping (will be superseded by zoxide)
  zcomet load andrewferrier/fzf-z
fi

# LS_COLORS for better file colors
zcomet load trapd00r/LS_COLORS

# =============================================================================
# Zoxide (Modern replacement for 'z' plugin)
# =============================================================================
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# =============================================================================
# Platform-specific setup
# =============================================================================
KERNEL=$(uname)

if [[ $KERNEL == "Darwin" ]]; then
  eval "$(brew shellenv)"
  if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
  fi
  ulimit -n 4096
fi

if [[ $KERNEL == "Linux" ]]; then
  export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"
  alias ack="ack-grep"
fi

# =============================================================================
# LS configuration
# =============================================================================
LS="ls"
LS_ARGUMENTS="-G"

if [[ $KERNEL == "Darwin" ]] && [[ -f "$HOMEBREW_PREFIX/bin/gls" ]]; then
  LS="$HOMEBREW_PREFIX/bin/gls"
fi

if { $LS --help 2>&1 | grep -q "GNU coreutils" } >&/dev/null; then
  LS_VERSION="gnu"
else
  LS_VERSION="bsd"
fi
if [[ "$LS_VERSION" == "gnu" ]]; then
  LS_ARGUMENTS="--color=auto --classify --group-directories-first"
fi

LS="$LS $LS_ARGUMENTS"
alias la="$LS -lAHh"
alias ls=$LS
alias l=$LS

# =============================================================================
# Direnv (dotenv for shell)
# =============================================================================
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# =============================================================================
# Navigation aliases
# =============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# =============================================================================
# Docker compose wrapper
# =============================================================================
function docker-compose () {
  docker compose $*
}

# =============================================================================
# Key bindings and options
# =============================================================================
bindkey -v
zstyle ':filter-select' max-lines 10
zstyle ':filter-select:highlight' selected bg=red

# Zsh settings
setopt AUTO_CD
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

# =============================================================================
# Environment variables
# =============================================================================
# https://blog.packagecloud.io/eng/2017/02/21/set-environment-variable-save-thousands-of-system-calls/
export TZ=":/etc/localtime"
export TERM=xterm-256color
export DO_NOT_TRACK=1 # https://consoledonottrack.com/

# Aider
export AIDER_VIM=true
export AIDER_AUTO_COMMITS=false

# You should use message format
export YSU_MESSAGE_FORMAT="$(tput setaf 3)💡 %alias_type for %command: %alias$(tput sgr0)"

# =============================================================================
# FZF Configuration
# =============================================================================
if command -v fzf &>/dev/null; then

  # Sort using fzf
  # Based on https://github.com/Aloxaf/fzf-tab/issues/58#issuecomment-599178492
  zstyle ':fzf-tab:*'    fzf-flags  '--no-sort'
  zstyle ':completion:*' sort       'false'
  zstyle ':fzf-tab:complete:cd:*' accept-line enter
  zstyle ':fzf-tab:*' switch-group ',' '.'
  zstyle ':completion:*:descriptions' format '[%d]'

  export FZF_TMUX=1
  export FZF_DEFAULT_OPTS="--tmux 80% -m --walker-skip .git,node_modules,.venv,target --margin=2 --reverse"

  fzf-git-add() {
    git ls-files -m --exclude-standard | fzf --print0 -m --preview 'git diff --color=always --no-ext-diff {}' | xargs -0 -t -o git add -p
  }

  fzf-git-branch() {
    git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)' | fzf --print0 --preview 'git diff --shortstat --color=always --no-ext-diff {}; echo ""; git log --oneline HEAD..{}'| xargs -0 -t -o git switch
  }

  fzf-git-worktree-change() {
    local selected
    selected=$(git worktree list --porcelain | awk '/^worktree / {print $2}' | fzf \
      --preview 'BRANCH=$(git -C {} rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"); echo "Branch: $BRANCH"; echo "Dir: $(basename {})"; echo ""; git -C {} diff --shortstat --color=always --no-ext-diff' \
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

# =============================================================================
# Initialization
# =============================================================================
zcomet compinit

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# =============================================================================
# Ghostty terminal integration
# =============================================================================
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# Add LLVM to PATH
export PATH="/usr/local/opt/llvm/bin:$PATH"
