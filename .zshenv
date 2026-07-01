. "$HOME/.cargo/env"
export PATH="$PATH:$HOME/.local/bin"
export VISUAL="nvim"
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border
  --preview="bat --style=numbers --color=always {}"
  --color=fg:#cdcdcd
  --color=bg:#141415
  --color=hl:#f3be7c
  --color=fg+:#aeaed1
  --color=bg+:#252530
  --color=hl+:#f3be7c
  --color=border:#606079
  --color=header:#6e94b2
  --color=gutter:#141415
  --color=spinner:#7fa563
  --color=info:#f3be7c
  --color=pointer:#aeaed1
  --color=marker:#d8647e
  --color=prompt:#bb9dbd
'
