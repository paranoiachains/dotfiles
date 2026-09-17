#!/bin/bash

typeset -g ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if command -v sway >/dev/null 2>&1; then
    [ "$(tty)" = "/dev/tty1" ] && exec sway
fi

if [[ ! -r "$ZINIT_HOME/zinit.zsh" ]]; then
    if command -v git >/dev/null 2>&1; then
        mkdir -p -- "${ZINIT_HOME:h}"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    else
        print -u2 "zsh: git is required to install zinit"
    fi
fi

if [[ -r "$ZINIT_HOME/zinit.zsh" ]]; then
    source "$ZINIT_HOME/zinit.zsh"
fi

if command -v zinit >/dev/null 2>&1; then
    zinit ice depth=1
    zinit light jeffreytse/zsh-vi-mode
    export ZVM_SYSTEM_CLIPBOARD_ENABLED=true

    zinit light zdharma-continuum/fast-syntax-highlighting

    zinit ice wait lucid
    zinit light zsh-users/zsh-autosuggestions

    zinit ice wait lucid
    zinit light hlissner/zsh-autopair
fi

export KEYTIMEOUT=1

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

function lg() {
    local newdir_file="${LAZYGIT_NEW_DIR_FILE:-$HOME/.lazygit/newdir}"

    export LAZYGIT_NEW_DIR_FILE="$newdir_file"

    lazygit "$@"

    if [[ -f "$newdir_file" ]]; then
        cd -- "$(cat "$newdir_file")" || return
        rm -f -- "$newdir_file"
    fi
}

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

[[ -r "$HOME/.config/zsh/volatile" ]] && source "$HOME/.config/zsh/volatile"
[[ -r "$HOME/.config/zsh/aliases" ]] && source "$HOME/.config/zsh/aliases"

function proxy {
    cmd="$1"
    proxy="$2"

    case "$cmd" in
    enable)
        export HTTP_PROXY="http://$proxy"
        export HTTPS_PROXY="http://$proxy"
        export ALL_PROXY="http://$proxy"

        export http_proxy="$HTTP_PROXY"
        export https_proxy="$HTTPS_PROXY"
        export all_proxy="$ALL_PROXY"

        export SSH_PROXY="$proxy"

        echo "enabled $proxy proxy"
        ;;

    disable)
        unset HTTP_PROXY HTTPS_PROXY ALL_PROXY
        unset http_proxy https_proxy all_proxy
        unset SSH_PROXY

        echo "disabled proxy"
        ;;

    *)
        echo "usage: proxy enable|disable [host:port]"
        ;;
    esac
}

function ssh {
    if [[ "$SSH_PROXY" ]]; then
        command ssh -o "ProxyCommand=nc -X 5 -x $SSH_PROXY %h %p" "$@"
    else
        command ssh "$@"
    fi
}
