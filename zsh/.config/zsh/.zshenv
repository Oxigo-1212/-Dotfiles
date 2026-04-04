# XDG Base Directory Specification
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Cargo environment
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Go
export GOPATH="$XDG_DATA_HOME/go"

# Dotnet
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"

# GTK2
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# NuGet
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"

# TeX Live
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"

# Python
export PYTHONSTARTUP="$HOME/python/pythonrc"

# Zsh
export ZDOTDIR=$HOME/.config/zsh
export PATH="$HOME/develop/flutter/bin:$PATH"
. "/home/oxigo/.local/share/cargo/env"
