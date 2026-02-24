#!/usr/bin/env bash
set -eu

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

safe_copy() {
    local src="$1"
    local dst="$2"
    local is_dir="$3"

    if [ "$is_dir" = true ]; then
        [ -d "$dst" ] && rm -rf "$dst"
        mkdir -p "$(dirname "$dst")"
        cp -r "$src" "$dst"
    else
        [ -f "$dst" ] && rm -f "$dst"
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
    fi
}

echo "Restoring Neovim config..."
safe_copy "$SCRIPTS_DIR/.config/nvim" "$HOME/.config/nvim" true

echo "Restoring Zsh config..."
safe_copy "$SCRIPTS_DIR/.zshrc" "$HOME/.zshrc" false

echo "Restoring Tmux config..."
safe_copy "$SCRIPTS_DIR/.tmux.conf" "$HOME/.tmux.conf" false

echo "Restoring Alacritty config..."
safe_copy "$SCRIPTS_DIR/.config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml" false

echo "Restoring i3 config..."
safe_copy "$SCRIPTS_DIR/.config/i3/config" "$HOME/.config/i3/config" false
safe_copy "$SCRIPTS_DIR/.config/i3status/config" "$HOME/.config/i3status/config" false

echo "Restoring GEF config..."
safe_copy "$SCRIPTS_DIR/.gef.rc" "$HOME/.gef.rc" true

echo "All configs restored successfully!"

