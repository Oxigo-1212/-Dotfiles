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
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
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

ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=#2CF9ED,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=#2CF9ED,underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=#2CF9ED
ZSH_HIGHLIGHT_STYLES[command]=fg=#2cf9ed

# eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
# ~/.zshrc


show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

# ------------FZF--------------
# Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
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
alias z='zathura'
alias sz="source $ZDOTDIR/.zshrc"

bindkey -s '^[l' 'ls -a\n'

alias rs='systemctl --user restart lid-monitor.service'
alias mln='cp -r ~/Documents/latex/LaTeX-Templates/"Lecture Notes"/Main.tex ~/Documents/latex/LaTeX-Templates/"Lecture Notes"/Lectures -t .'
alias mpn='cp -r ~/Documents/latex/LaTeX-Templates/Homework/HomeworkTemplate.tex -t .'
alias todo='nvim ~/Documents/todo.md'
# Define a function to wrap nvim
# Wrapper function for nvim
