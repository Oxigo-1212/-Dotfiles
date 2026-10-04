export BUN_INSTALL="$HOME/.bun"
export ANTHROPIC_BASE_URL="http://localhost:8317"
export ANTHROPIC_API_KEY="$(awk '/^api-keys:[[:space:]]*$/{getline; sub(/^[[:space:]]*-[[:space:]]*/, ""); gsub(/^"|"$/, ""); print; exit}' "$HOME/.cli-proxy-api/config.yaml")"
export WASMTIME_HOME="$HOME/.wasmtime"
export PATH="$BUN_INSTALL/bin:$WASMTIME_HOME/bin:$PATH"
export TZ='Asia/Jakarta'
export QS_ICON_THEME=Adwaita
export QS_COLORS=true 
export PATH="/home/oxigo/.cache/.bun/bin:$PATH"
export MKLROOT=/opt/intel/oneapi/mkl/latest
export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec
export ZSH="$HOME/.oh-my-zsh"
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export ELECTRON_ENABLE_WAYLAND_DMD=1
export EDITOR=nvim
export VISUAL=nvim
export PATH="$HOME/walker/target/release:$PATH"
export PATH="/opt/lampp/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=/usr/lib:/usr/local/lib
export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.was,time/bin:$PATH"
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export MANPAGER="nvim +Man!"
export MANWIDTH=999
plugins=(git fzf-tab zsh-autosuggestions zsh-syntax-highlighting)
ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh
source $HOME/scripts/changecwd.sh

# Initialize fzf
eval "$(fzf --zsh)"
# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

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

# eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
# ~/.zshrc


show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=$HISTSIZE	
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups	

# ------------FZF--------------
# Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p90%,70%"
# -----------------------------
set -o vi
alias ls="eza --icons=always --long --git --no-filesize --color=always --no-time --no-user" 
alias rm='trash-put'

alias oxigo='tmux has-session -t Oxigo 2>/dev/null && tmux attach-session -t Oxigo || tmux new-session -s Oxigo'
alias n='nvim'
alias vim='nvim'
alias sz="source $ZDOTDIR/.zshrc"

bindkey -s '^[l' 'ls -a\n'

alias rs='systemctl --user restart lid-monitor.service'
alias mln='cp -r ~/Documents/latex/LaTeX-Templates/"Lecture Notes"/Main.tex ~/Documents/latex/LaTeX-Templates/"Lecture Notes"/Lectures -t .'
alias mpn='cp -r ~/Documents/latex/LaTeX-Templates/Homework/HomeworkTemplate.tex -t .'
alias todo='nvim ~/Documents/todo.md'
alias audio-reset='systemctl --user restart wireplumber pipewire pipewire-pulse'
# Define a function to wrap nvim
# Wrapper function for nvim

bindkey -e
bindkey -M emacs '^I' fzf-tab-complete
bindkey -M viins '^I' fzf-tab-complete
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward	

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# bun completions
[ -s "/home/oxigo/.bun/_bun" ] && source "/home/oxigo/.bun/_bun"

# pnpm
export PNPM_HOME="/home/oxigo/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
