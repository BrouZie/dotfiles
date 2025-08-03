#!/bin/bash
set -euo pipefail

echo "Initializing config setup"
yay -S --needed stow

DOTFILES="$HOME/dotfiles"

cd "$HOME"
# Tmux dependency
if [ ! -d ".tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm.git .tmux/plugins/tpm
else
  echo "⟳ tpm already cloned"
fi

stow_pck(
	bashrc
	kitty
	nvim
	tmux
	ohmyposh
	fastfetch
	wallust
	matugen
	sokratos
)

copy_items(
	".config/hypr"
	".config/waybar"
	".config/swaync"
	".config/rofi"
)

for pkg in stow_pck; do
	echo "--> Backing up existing symlinks for $pkg"
	stow --restow --no-folding --target="$HOME" --adopt "$DOTFILES/$pkg"

	echo "--> Stowing $pkg"
	stow --target="$HOME" "$pkg"
done

# Backup & copy raw directories/files
for rel in "${copy_items[@]}"; do
  src="$DOTFILES/$rel"
  dst="$HOME/$rel"
  
  if [ -e "$dst" ]; then
    echo "--> Backing up $dst to ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  
  echo "--> Copying $src → $dst"
  # ensure parent dir exists
  mkdir -p "$(dirname "$dst")"
  cp -a "$src" "$dst"
done

echo "✅ Setup complete."
