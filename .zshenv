export ZDOTDIR="$HOME/.config/zsh"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"

export PATH="$HOME/.local/bin:$PATH"

[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
