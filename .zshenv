export ZDOTDIR="$HOME/.config/zsh"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"

export PATH="$HOME/.local/bin:$PATH"

[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_CTRL_T_OPTS="
--preview 'bat --color=always --style=numbers --line-range=:500 {}'
"

export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export FZF_ALT_C_OPTS="
--preview 'eza --tree --level=2 --color=always {}'
"

export FZF_DEFAULT_OPTS="
  --layout=reverse
  --preview='bat --style=numbers --color=always {}'
  --highlight-line
  --info=inline-right
  --ansi
  --border=none
  --color=bg+:#283457
  --color=bg:#16161e
  --color=fg:#c0caf5
  --color=gutter:#16161e
  --color=header:#ff9e64
  --color=hl+:#2ac3de
  --color=hl:#2ac3de
  --color=info:#545c7e
  --color=marker:#ff007c
  --color=pointer:#ff007c
  --color=prompt:#2ac3de
  --color=query:#c0caf5:regular
  --color=scrollbar:#27a1b9
  --color=separator:#ff9e64
  --color=spinner:#ff007c
"

export EZA_CONFIG_DIR="${XDG_CONFIG_HOME}/eza"
