#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

DOTFILES="$HOME/dotfiles"
INSTALL_DIR=~/dotfiles/sokratos/.config/sokratos/install

# Give people a chance to retry running the installation
catch_errors() {
  echo -e "\n\e[31mKasper installation failed!\e[0m"
  echo "You can retry by running: bash ~/dotfiles/kasper.sh"
}

# Ensure system is up to date!
sudo pacman -Syu

# Install yay package manager
source $INSTALL_DIR/prerequisites/aur.sh
source $INSTALL_DIR/prerequisites/presentation.sh


cd "$HOME"

# Tmux dependency
if [ ! -d ".tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm.git .tmux/plugins/tpm
else
  echo "⟳ tpm already cloned"
fi

# Install nvim dependencies
source $INSTALL_DIR/terminal/nvim_tmux.sh

# Backing up any existing nvim config
if [ -e ~/.config/nvim ]; then
	echo "--> Backing up existing nvim config to ~/.config/nvim.bak"
	mv ~/.config/nvim ~/.config/nvim.bak
fi

# Move configs into place
mkdir -p ~/.config/nvim
cp -r $DOTFILES/nvim/.config/nvim/ ~/.config/nvim
cp $DOTFILES/tmux/.tmux.conf $HOME/.tmux.conf
echo "Tmux and neovim is set up properly!"
sleep 2

echo "Would you like to get some extra cli tools (quite handy ones)?"
gum confirm
echo "Nice! Installation will proceed"
sleep 1
source $INSTALL_DIR/terminal/kasper_extra.sh

echo "✅ Setup complete."
