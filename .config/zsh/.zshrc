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
    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-completions
    zinit light zdharma-continuum/fast-syntax-highlighting
fi

KEYTIMEOUT=1

autoload -Uz compinit
compinit

if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

if (( $+commands[fzf] )); then
    source <(fzf --zsh)
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


typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[default]='fg=#c0caf5'

ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e'
ZSH_HIGHLIGHT_STYLES[command]='fg=#7aa2f7'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[function]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#bb9af7'

ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#e0af68'

ZSH_HIGHLIGHT_STYLES[path]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#9ece6a'

ZSH_HIGHLIGHT_STYLES[globbing]='fg=#ff9e64'

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9ece6a'

ZSH_HIGHLIGHT_STYLES[numeric-glob]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#7dcfff'

ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f7768e'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#565f89'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#ff9e64'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f7768e'

for config in \
    "$HOME/.config/zsh/proxy" \
    "$HOME/.config/zsh/volatile"
do
    [[ -r "$config" ]] && source "$config"
done
