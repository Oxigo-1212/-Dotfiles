# ~~~~~~~~~~~~~~~~~~~~ Environment ~~~~~~~~~~~~~~~~~~~~

export TZ='Asia/Jakarta'
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"
export MANWIDTH=999

export QS_ICON_THEME=Adwaita
export QS_COLORS=true
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export ELECTRON_ENABLE_WAYLAND_DMD=1
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

export MKLROOT=/opt/intel/oneapi/mkl/latest
export LIBRARY_PATH=/usr/lib:/usr/local/lib
export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib

export BUN_INSTALL="$HOME/.bun"
export WASMTIME_HOME="$HOME/.wasmtime"
export PNPM_HOME="$HOME/.local/share/pnpm"
export NVM_DIR="$HOME/.nvm"

export ANTHROPIC_BASE_URL="http://localhost:8317"

# ~~~~~~~~~~~~~~~~~~~~ Node.js ~~~~~~~~~~~~~~~~~~~~

source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec

# ~~~~~~~~~~~~~~~~~~~~ PATH ~~~~~~~~~~~~~~~~~~~~

# Keep the existing priority of local tools and inherited PATH entries.
typeset -U path PATH
path=(
    "$PNPM_HOME"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    /opt/lampp/bin
    "$HOME/walker/target/release"
    "$HOME/.cache/.bun/bin"
    "$BUN_INSTALL/bin"
    "$WASMTIME_HOME/bin"
    $path
    "${GOPATH:-$HOME/go}/bin"
)

# Remove duplicate entries and non-existent directories.
path=($^path(N-/))
export PATH

# ~~~~~~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~

HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory hist_ignore_space hist_ignore_dups

# ~~~~~~~~~~~~~~~~~~~~ Oh My Zsh ~~~~~~~~~~~~~~~~~~~~

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git fzf-tab zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=1,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=5
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=3,underline
ZSH_HIGHLIGHT_STYLES[global-alias]=fg=2
ZSH_HIGHLIGHT_STYLES[precommand]=fg=2,underline
ZSH_HIGHLIGHT_STYLES[path]=fg=4,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=5
ZSH_HIGHLIGHT_STYLES[arg0]=fg=6,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=6,bold
ZSH_HIGHLIGHT_STYLES[comment]=fg=8

# ~~~~~~~~~~~~~~~~~~~~ Shell integrations ~~~~~~~~~~~~~~~~~~~~

source "$HOME/scripts/changecwd.sh"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Bun completions.
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# ~~~~~~~~~~~~~~~~~~~~ FZF ~~~~~~~~~~~~~~~~~~~~

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p90%,70%"

# ~~~~~~~~~~~~~~~~~~~~ Completion ~~~~~~~~~~~~~~~~~~~~

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# ~~~~~~~~~~~~~~~~~~~~ Key bindings ~~~~~~~~~~~~~~~~~~~~

bindkey -e
bindkey -M emacs '^I' fzf-tab-complete
bindkey -M viins '^I' fzf-tab-complete
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -s '^[l' 'ls -a\n'

# ~~~~~~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~

alias ls="eza --icons=always --long --git --no-filesize --color=always --no-time --no-user"
alias rm='trash-put'
alias oxigo='tmux has-session -t Oxigo 2>/dev/null && tmux attach-session -t Oxigo || tmux new-session -s Oxigo'
alias n='nvim'
alias vim='nvim'
alias sz="source $ZDOTDIR/.zshrc"
alias rs='systemctl --user restart lid-monitor.service'
alias mln='cp -r ~/Documents/latex/LaTeX-Templates/"Lecture Notes"/Main.tex ~/Documents/latex/LaTeX-Templates/"Lecture Notes"/Lectures -t .'
alias mpn='cp -r ~/Documents/latex/LaTeX-Templates/Homework/HomeworkTemplate.tex -t .'
alias todo='nvim ~/Documents/todo.md'
alias audio-reset='systemctl --user restart wireplumber pipewire pipewire-pulse'
