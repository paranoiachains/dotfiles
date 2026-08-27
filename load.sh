set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

APPS=(
    nvim
    sway
    waybar
    ghostty
    mako
    fuzzel
    tmux
    zsh
    starship
)

COMMAND="${1:-}"
EXCLUSION=""

usage() {
    echo "usage: $0 <push|pull> [-e|--exclude <config>]"
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

        EXCLUSION="$2"
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
    [[ "$1" == "$EXCLUSION" ]]
}

is_valid_config() {
    for config in "${APPS[@]}"; do
        [[ "$1" == "$config" ]] && return 0
    done

    return 1
}

if [[ -n "$EXCLUSION" ]] && ! is_valid_config "$EXCLUSION"; then
    echo "error: config for exclusion not found: $EXCLUSION"
    exit 1
fi

pull_zshenv() {
    cp "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
}

push_zshenv() {
    rm "$DOTFILES_DIR/.zshenv"
    cp "$HOME/.zshenv" "$DOTFILES_DIR/.zshenv"
}

case "$COMMAND" in

pull)
    echo "pulling configuration..."

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

        echo "  $SOURCE -> $DEST"

        rm -rf -- "$DEST"
        cp -R -- "$SOURCE" "$DEST"

        if [[ "$EXCLUSION" != "zsh" ]]; then
            pull_zshenv
        fi
    done

    echo "pull complete."
    ;;

push)
    echo "pushing configuration..."

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

        echo "  $SOURCE -> $DEST"

        rm -rf -- "$DEST"
        cp -R -- "$SOURCE" "$DEST"

        if [[ "$EXCLUSION" != "zsh" ]]; then
            pull_zshenv
        fi
    done

    echo "push complete."
    ;;

*)
    echo "unknown command: $COMMAND"
    usage
    exit 1
    ;;

esac
