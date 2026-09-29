#!/usr/bin/env zsh

typeset -g ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

if command -v sway >/dev/null 2>&1 && [[ -o interactive && "$TTY" == "/dev/tty1" ]]; then
    exec sway
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
    export ZVM_SYSTEM_CLIPBOARD_ENABLED=true
    zinit light jeffreytse/zsh-vi-mode

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

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

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

[[ -r "$XDG_CONFIG_HOME/zsh/volatile" ]] && source "$XDG_CONFIG_HOME/zsh/volatile"
[[ -r "$XDG_CONFIG_HOME/zsh/aliases" ]] && source "$XDG_CONFIG_HOME/zsh/aliases"

function proxy {
    local action="${1:-}"
    local proxy_url="${2:-}"

    case "$action" in
    enable)
        if [[ -z "$proxy_url" ]]; then
            print -u2 "usage: proxy enable host:port"
            return 2
        fi

        [[ "$proxy_url" == *://* ]] || proxy_url="http://$proxy_url"

        export HTTP_PROXY="$proxy_url"
        export HTTPS_PROXY="$proxy_url"
        export ALL_PROXY="$proxy_url"

        export http_proxy="$HTTP_PROXY"
        export https_proxy="$HTTPS_PROXY"
        export all_proxy="$ALL_PROXY"

        echo "enabled $proxy_url proxy"
        ;;

    disable)
        unset HTTP_PROXY HTTPS_PROXY ALL_PROXY
        unset http_proxy https_proxy all_proxy

        echo "disabled proxy"
        ;;
    *)
        print -u2 "usage: proxy enable host:port|disable"
        return 2
        ;;
    esac
}

function ssh {
    if [[ -n "${SSH_PROXY:-}" ]]; then
        command ssh -o "ProxyCommand=nc -X 5 -x $SSH_PROXY %h %p" "$@"
    else
        command ssh "$@"
    fi
}

autoload -Uz compinit
compinit

export PATH="$HOME/go/bin:$PATH"

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"

export PATH="$HOME/.local/bin:$PATH"

[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

export PATH=$PATH:$HOME/.pdtm/go/bin
