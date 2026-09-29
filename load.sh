#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

APPS=(
    fuzzel
    ghostty
    lazygit
    mako
    nvim
    starship
    sway
    tmux
    waybar
    zsh
)

COMMAND="${1:-}"
EXCLUSIONS=()
BACKUP_DIR=""
BACKUP_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups"

usage() {
    echo "usage: $0 <push|pull> [-e|--exclude <config>]..."
}

if [[ -z "$COMMAND" ]]; then
    usage
    exit 1
fi

shift

while (($# > 0)); do
    case "$1" in
    -e | --exclude)
        if (($# < 2)); then
            echo "error: $1 requires an argument"
            exit 1
        fi

        EXCLUSIONS+=("$2")
        shift 2
        ;;

    --)
        shift
        break
        ;;

    -*)
        echo "unknown flag: $1"
        usage
        exit 1
        ;;

    *)
        echo "unexpected argument: $1"
        usage
        exit 1
        ;;
    esac
done

is_exclusion() {
    local config="$1"
    local exclusion

    for exclusion in "${EXCLUSIONS[@]}"; do
        [[ "$config" == "$exclusion" ]] && return 0
    done

    return 1
}

is_valid_config() {
    for config in "${APPS[@]}"; do
        [[ "$1" == "$config" ]] && return 0
    done

    return 1
}

for exclusion in "${EXCLUSIONS[@]}"; do
    if ! is_valid_config "$exclusion"; then
        echo "error: config for exclusion not found: $exclusion"
        exit 1
    fi
done

make_backup_dir() {
    if [[ -z "$BACKUP_DIR" ]]; then
        BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)-$$"
        mkdir -p -- "$BACKUP_DIR"
    fi
}

backup_existing() {
    local path="$1"
    local name="$2"

    if [[ -e "$path" || -L "$path" ]]; then
        make_backup_dir
        mv -- "$path" "$BACKUP_DIR/$name"
        echo "  backed up $path to $BACKUP_DIR/$name"
    fi
}

replace_directory() {
    local source="$1"
    local dest="$2"
    local name="$3"
    local parent="${dest%/*}"
    local staging

    mkdir -p -- "$parent"
    staging="$(mktemp -d "$parent/.${name}.staging.XXXXXX")"

    if ! cp -pR -- "$source" "$staging/"; then
        rm -rf -- "$staging"
        return 1
    fi

    remove_local_state "$staging/$name"
    preserve_local_state "$dest" "$staging/$name"

    backup_existing "$dest" "$name"

    if ! mv -- "$staging/$name" "$dest"; then
        if [[ -n "$BACKUP_DIR" && (-e "$BACKUP_DIR/$name" || -L "$BACKUP_DIR/$name") ]]; then
            mv -- "$BACKUP_DIR/$name" "$dest"
        fi
        rm -rf -- "$staging"
        return 1
    fi

    rmdir -- "$staging"
}

remove_local_state() {
    local root="$1"

    rm -rf -- \
        "$root/.zsh_history" \
        "$root/.zcompdump" \
        "$root/volatile" \
        "$root/nvim-pack-lock.json"
    find "$root" -name .DS_Store -exec rm -rf {} +
}

preserve_local_state() {
    local source="$1"
    local dest="$2"
    local file

    for file in .zsh_history .zcompdump nvim-pack-lock.json; do
        if [[ -f "$source/$file" ]]; then
            cp -p -- "$source/$file" "$dest/$file"
        fi
    done

    if [[ -d "$source/volatile" ]]; then
        cp -pR -- "$source/volatile" "$dest/"
    fi
}

replace_file() {
    local source="$1"
    local dest="$2"
    local name="$3"
    local parent="${dest%/*}"
    local staging

    mkdir -p -- "$parent"
    staging="$(mktemp -d "$parent/.${name}.staging.XXXXXX")"

    if ! cp -p -- "$source" "$staging/$name"; then
        rm -rf -- "$staging"
        return 1
    fi

    backup_existing "$dest" "$name"

    if ! mv -- "$staging/$name" "$dest"; then
        if [[ -n "$BACKUP_DIR" && (-e "$BACKUP_DIR/$name" || -L "$BACKUP_DIR/$name") ]]; then
            mv -- "$BACKUP_DIR/$name" "$dest"
        fi
        rm -rf -- "$staging"
        return 1
    fi

    rmdir -- "$staging"
}

pull_zshenv() {
    replace_file "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv" ".zshenv"
}

push_zshenv() {
    replace_file "$HOME/.zshenv" "$DOTFILES_DIR/.zshenv" ".zshenv"
}

case "$COMMAND" in

pull)
    echo "pulling configuration..."

    if ! is_exclusion zsh; then
        pull_zshenv
    fi

    for config in "${APPS[@]}"; do
        if is_exclusion "$config"; then
            echo "  skipping $config"
            continue
        fi

        SOURCE="$DOTFILES_DIR/.config/$config"
        DEST="$CONFIG_DIR/$config"

        if [[ ! -d "$SOURCE" ]]; then
            echo "  warning: $SOURCE does not exist"
            continue
        fi

        replace_directory "$SOURCE" "$DEST" "$config"
        echo "  pulled $config"
    done

    echo "pull complete."
    ;;

push)
    echo "pushing configuration..."

    if ! is_exclusion zsh; then
        push_zshenv
    fi

    for config in "${APPS[@]}"; do
        if is_exclusion "$config"; then
            echo "  skipping $config"
            continue
        fi

        SOURCE="$CONFIG_DIR/$config"
        DEST="$DOTFILES_DIR/.config/$config"

        if [[ ! -d "$SOURCE" ]]; then
            echo "  warning: $SOURCE does not exist"
            continue
        fi

        replace_directory "$SOURCE" "$DEST" "$config"
        echo "  pushed $config"
    done

    echo "push complete."
    ;;

*)
    echo "unknown command: $COMMAND"
    usage
    exit 1
    ;;

esac
