#!/usr/bin/env bash
set -eu

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

safe_push() {
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

echo "Pushing Neovim config..."
safe_push "$HOME/.config/nvim" "$DOTFILES_DIR/.config/nvim" true

echo "Pushing Zsh config..."
safe_push "$HOME/.zshrc" "$DOTFILES_DIR/.zshrc" false

echo "Pushing Tmux config..."
safe_push "$HOME/.tmux.conf" "$DOTFILES_DIR/.tmux.conf" false

echo "Pushing Alacritty config..."
safe_push "$HOME/.config/alacritty/alacritty.toml" "$DOTFILES_DIR/.config/alacritty/alacritty.toml" false

echo "Pushing i3 config..."
safe_push "$HOME/.config/i3/config" "$DOTFILES_DIR/.config/i3/config" false
safe_push "$HOME/.config/i3status/config" "$DOTFILES_DIR/.config/i3status/config" false

echo "All configs pushed to dotfiles repo. You can now git add/commit/push."

