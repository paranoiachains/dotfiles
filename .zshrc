alias c='clear'
alias ls='eza'
alias grep='rg'
alias cat='bat'
alias nfzf='nvim "$(fzf)"'
alias n='nvim'
alias lsa='ls -la'

export PATH="$PATH:~/.local/bin"
export VISUAL="nvim"
export EDITOR="nvim"

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

source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'


export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border
  --preview="bat --style=numbers --color=always {}"
  --color=fg:#c5c9c5
  --color=bg:#181616
  --color=hl:#8ea4a2

  --color=fg+:#c8c093
  --color=bg+:#2d2a2e
  --color=hl+:#7fb4ca

  --color=info:#a6a69c
  --color=prompt:#c4746e
  --color=pointer:#c4b28a
  --color=marker:#c4b28a
  --color=spinner:#8ba4b0
  --color=header:#8992a7

  --color=border:#393836
  --color=gutter:#181616
  --color=separator:#393836
  --color=label:#a6a69c
  --color=query:#c5c9c5
'
