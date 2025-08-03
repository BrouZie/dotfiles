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

stow_pck=(
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

copy_src=(
	"hypr/.config/hypr"
	"waybar/.config/waybar"
	"swaync/.config/swaync"
	"rofi/.config/rofi"
)

copy_dst=(
	".config/hypr"
	".config/waybar"
	".config/swaync"
	".config/rofi"
)


cd "$DOTFILES"
for pkg in "${stow_pck[@]}"; do
	echo "--> Backing up existing symlinks for $pkg"
	stow --restow --no-folding --target="$HOME" --adopt "$pkg"

	echo "--> Stowing $pkg"
	stow --target="$HOME" "$pkg"
done
#
# Backup & copy raw directories/files in parallel
for idx in "${!copy_src[@]}"; do
	SRC="$DOTFILES/${copy_src[$idx]}"
	DST="$HOME/${copy_dst[$idx]}"

	if [ -e "$DST" ]; then
		echo "--> Backing up $DST to ${DST}.bak"
		mv "$DST" "${DST}.bak"
	fi
	echo "--> Copying $SRC → $DST"
	# ensure the parent directory of $DST exists
	mkdir -p "$(dirname "$DST")"
	cp -r "$SRC" "$DST"
done

echo "✅ Setup complete."
