#!/usr/bin/env bash

# This script installs all neovim dependencies for ubuntu

set -e

ROOT="$HOME"
cd "$ROOT"

sudo apt update
sudo apt upgrade
sudo apt install -y curl ca-certificates build-essential \
	pkg-config libevent-dev libncurses-dev yacc

# Install ghostty for image support in the terminal
sudo apt install ibus-gtk4
sudo snap install ghostty --classic

# Silence Dbus error
mkdir -p ~/.local/share/applications
cp /var/lib/snapd/desktop/applications/ghostty_ghostty.desktop ~/.local/share/applications/
sed -i 's|Exec=ghostty|Exec=env GTK_IM_MODULE=gtk-im-context-simple ghostty|' ~/.local/share/applications/ghostty_ghostty.desktop
update-desktop-database ~/.local/share/applications


# ------- Neovim setup --------

# Python dependencies
sudo snap install astral-uv --classic

# Neovim environment
uv venv --seed ~/.venvs/nvim
uv pip install -p ~/.venvs/nvim/bin/python \
    pynvim jupyter_client nbformat cairosvg pillow plotly kaleido \
    pyperclip requests websocket-client pnglatex hererocks

sudo apt install -y python3-pip pipx
pipx ensurepath

# Uncomment these packages if they aren't installed already
# sudo apt install -y python3-pip python3-venv

# Necessary tooling fd, rg, bat, fzf from webi:
curl -sS https://webi.sh/rg  | sh && source ~/.config/envman/PATH.env
curl -sS https://webi.sh/fd  | sh && source ~/.config/envman/PATH.env
curl -sS https://webi.sh/bat | sh && source ~/.config/envman/PATH.env
curl -sS https://webi.sh/fzf | sh && source ~/.config/envman/PATH.env
# curl -sS https://webi.sh/go | sh && source ~/.config/envman/PATH.env

# Needed for dapui and image display
sudo apt install -y lua5.4 luarocks imagemagick

# Node.js deps for neovim: https://nodejs.org/en/download

# nvm install:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

cat >> ~/.bashrc <<'EOF'

# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF

# Install Node.js (LTS version) and make it the default
nvm install --lts
nvm alias default 'lts/*'
nvm use default

# ------ tmux -------
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install correct version of tmux:

curl -LO https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
tar xzf tmux-3.4.tar.gz
cd tmux-3.4
./configure --prefix="$HOME/.local"
make -j"$(nproc)"
make install

# ensure it's first on PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
exec $SHELL -l

# Add to ghostty config:
# term = xterm-256color
# shell-integration-features = no-cursor
# window-decoration = false
# font-family = "JetbrainsMono Nerd Font"
# font-style = Regular
# font-size = 16
# keybind = f11=toggle_fullscreen
