#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR=".config"

CONFIGS=(
    nvim
    sway
    waybar
    ghostty
    mako
    fuzzel
    tmux
)

DOTFILES=(
    .zshrc
    .zshenv
    .tmux.conf
)

COMMAND="${1:-}"

if [[ -z "$COMMAND" ]]; then
    echo "usage: $0 <push|pull>"
    exit 1
fi

case "$COMMAND" in
pull)
    echo "pulling configuration..."

    for config in "${CONFIGS[@]}"; do
        echo "  .config/$config"

        rm -rf "$HOME/.config/$config"
        cp -r "$CONFIG_DIR/$config" "$HOME/.config"
    done

    for file in "${DOTFILES[@]}"; do
        echo "  $file"

        cp "$file" "$HOME"
    done

    echo "pull complete."
    ;;

push)
    echo "pushing configuration..."

    for config in "${CONFIGS[@]}"; do
        echo "  .config/$config"

        rm -rf "$CONFIG_DIR/${config:?}"
        cp -r "$HOME/.config/$config" "$CONFIG_DIR"
    done

    for file in "${DOTFILES[@]}"; do
        echo "  $file"

        cp "$HOME/$file" .
    done

    echo "push complete."
    ;;

*)
    echo "unknown command: $COMMAND"
    echo "usage: $0 <push|pull>"
    exit 1
    ;;
esac
