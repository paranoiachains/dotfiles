. "$HOME/.cargo/env"
export PATH="$PATH:$HOME/.local/bin"
export VISUAL="nvim"
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --preview="bat --style=numbers --color=always {}"
  --highlight-line
  --info=inline-right 
  --ansi 
  --border 
  --color=bg+:#283457 
  --color=bg:#16161e 
  --color=border:#27a1b9 
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
'
export EZA_CONFIG_DIR="$HOME/.config/eza"
