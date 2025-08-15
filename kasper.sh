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

# Install yay package manager
source $INSTALL_DIR/prerequirites/aur.sh


cd "$HOME"

# Tmux dependency
if [ ! -d ".tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm.git .tmux/plugins/tpm
else
  echo "⟳ tpm already cloned"
fi

# Install nvim dependencies
source $INSTALL_DIR/terminal/nvim_tmux.sh

# Move configs into place (this won't back up any existing config)
mkdir -p ~/.config/nvim
cp -r $DOTFILES/nvim/.config/nvim ~/.config/nvim/
cp $DOTFILES/tmux/.tmux.conf $HOME/.tmux.conf
