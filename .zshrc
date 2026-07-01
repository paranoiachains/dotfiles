alias c='clear'
alias ls='eza'
alias grep='rg'
alias cat='bat'
alias nfzf='nvim "$(fzf)"'
alias n='nvim'
alias lsa='ls -la'

bindkey -v

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

case "$(uname -s)" in
    Darwin)
        source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ;;
    Linux)
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ;;
esac

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

typeset -A ZSH_HIGHLIGHT_STYLES

# Default text
ZSH_HIGHLIGHT_STYLES[default]="fg=#cdcdcd"

# Valid commands
ZSH_HIGHLIGHT_STYLES[command]="fg=#b4d4cf"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=#b4d4cf"
ZSH_HIGHLIGHT_STYLES[alias]="fg=#b4d4cf"
ZSH_HIGHLIGHT_STYLES[function]="fg=#7e98e8"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=#7e98e8"

# Keywords
ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=#d8647e"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=#d8647e"

# Variables & assignments
ZSH_HIGHLIGHT_STYLES[assign]="fg=#bb9dbd"
ZSH_HIGHLIGHT_STYLES[parameter]="fg=#e8b589"
ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=#e0a363"

# Strings
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#7fa563"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#7fa563"
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=#7fa563"

# Options / paths / globs
ZSH_HIGHLIGHT_STYLES[path]="fg=#90a0b5"
ZSH_HIGHLIGHT_STYLES[path_prefix]="fg=#90a0b5"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=#e8b589"
ZSH_HIGHLIGHT_STYLES[option]="fg=#aeaed1"

# Numbers
ZSH_HIGHLIGHT_STYLES[numeric-fd]="fg=#c48282"

# Comments
ZSH_HIGHLIGHT_STYLES[comment]="fg=#606079,italic"

# Command separators
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=#878787"

# Errors
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=#d8647e,bold"
ZSH_HIGHLIGHT_STYLES[unknown-command]="fg=#d8647e,bold"

source <(fzf --zsh)

