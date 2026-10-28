# zinit is vendored in this repo at sources/zinit (pinned in SOURCES.lock) and
# installed to the path below by `make zsh` -- nothing is cloned at shell start,
# so a stale or tampered upstream cannot change what runs here. The installed
# copy has no history and no remote, so `zinit self-update` has nothing to pull;
# sourcing it straight out of a dotfiles checkout would instead let a stray
# self-update pull this repo and drop compiled *.zwc files into it.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ -r $ZINIT_HOME/zinit.zsh ]]; then
  source "$ZINIT_HOME/zinit.zsh"
else
  print -u2 "zinit is not installed at $ZINIT_HOME -- run 'make zsh' in the dotfiles repo; starting without zinit plugins"
fi

setopt AUTO_CD

if (( $+functions[zinit] )); then
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

  zinit ice wait lucid
  zinit load "MichaelAquilina/zsh-you-should-use"

  if (( $+commands[fzf] )); then
    #zinit ftb-tmux-popup light Aloxaf/fzf-tab

    zinit ice lucid wait'0'
    zinit light joshskidmore/zsh-fzf-history-search
    zinit load "andrewferrier/fzf-z"
  fi

  zinit light trapd00r/LS_COLORS
fi

LS="ls"
LS_ARGUMENTS="-G"

if [[ $OSTYPE == darwin* ]]; then
  eval "$(brew shellenv)"

  if [ -f "$HOMEBREW_PREFIX/bin/gls" ]; then
    LS="$HOMEBREW_PREFIX/bin/gls"
  fi

  ulimit -n 4096
fi

if [[ $OSTYPE == linux* ]]; then
  export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"
fi

# starship comes from the distro package manager. Without a working starship
# the shell still starts with a plain prompt. This has to sit *after* the
# Homebrew shellenv above: /opt/homebrew/bin is not on macOS's default PATH,
# so a check before that line misses a brew-installed starship. A starship
# that exists but fails to init falls back the same way.
if (( $+commands[starship] )) && _starship_init="$(starship init zsh 2>/dev/null)" && [[ -n $_starship_init ]]; then
  eval "$_starship_init"
else
  PROMPT='%F{blue}%~%f %(?..%F{red}[%?]%f )%# '
fi
unset _starship_init

# fzf's own zsh integration (completion + key bindings), available since fzf
# 0.48. It replaces the two raw-master snippets the Linux branch used to pull
# (junegunn/fzf#2790) and gives macOS and Linux the same path.
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

if (( $+commands[direnv] )); then
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
if (( $+commands[fzf] )); then

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

# Literal ANSI escapes instead of tput: tput aborts on an unknown TERM (e.g.
# xterm-ghostty over ssh to a host whose terminfo DB lacks the entry) and
# prints "tput: unknown terminal" at every shell start. YSU only needs yellow.
export YSU_MESSAGE_FORMAT=$'\e[33m💡 %alias_type for %command: %alias\e[0m'
export YSU_HARDCORE_ALIASES=()

export DO_NOT_TRACK=1 # https://consoledonottrack.com/

# Aider
export AIDER_VIM=true
export AIDER_AUTO_COMMITS=false

autoload -Uz compinit
compinit
(( $+functions[zinit] )) && zinit cdreplay -q

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# zsh-patina is installed by `make zsh` from the checksum-verified tarball in
# DOWNLOADS.lock -- nothing is downloaded at shell start. The explicit path is
# tried before a PATH lookup so a brew/distro copy cannot shadow the pinned
# binary; a missing or broken binary leaves the shell unhighlighted, like the
# starship fallback above. Activated last so its zle hook is installed after
# the other plugins bind theirs.
_patina=${HOME}/bin/zsh-patina
[[ -x $_patina ]] || _patina=${commands[zsh-patina]}
if [[ -n $_patina ]] && _patina_init=$("$_patina" activate 2>/dev/null) && [[ -n $_patina_init ]]; then
  eval "$_patina_init"
fi
unset _patina _patina_init
