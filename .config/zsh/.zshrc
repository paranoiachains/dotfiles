typeset -g ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ ! -r "$ZINIT_HOME/zinit.zsh" ]]; then
    if (( $+commands[git] )); then
        mkdir -p -- "${ZINIT_HOME:h}"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    else
        print -u2 "zsh: git is required to install zinit"
    fi
fi

if [[ -r "$ZINIT_HOME/zinit.zsh" ]]; then
    source "$ZINIT_HOME/zinit.zsh"
fi


if (( $+functions[zinit] )); then
    zinit ice depth=1
    zinit light jeffreytse/zsh-vi-mode
    ZVM_SYSTEM_CLIPBOARD_ENABLED=true

    zinit light zdharma-continuum/fast-syntax-highlighting

    zinit ice wait lucid
    zinit light zsh-users/zsh-autosuggestions

    zinit ice wait lucid
    zinit light hlissner/zsh-autopair
fi

KEYTIMEOUT=1

if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

if ((  $+commands[mise]  )); then
    eval "$(~/.local/bin/mise activate zsh)"
fi

if (( $+commands[eza] )); then
    alias ls='eza'
    alias lsa='eza -la'
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

for config in \
    "$HOME/.config/zsh/volatile"
do
    [[ -r "$config" ]] && source "$config"
done
