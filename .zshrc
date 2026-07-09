alias c='clear'
alias ls='eza'
alias grep='rg'
alias cat='bat'
alias n='nvim'
alias lsa='ls -la'

bindkey -v
KEYTIMEOUT=1

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


function lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
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

source <(fzf --zsh)

