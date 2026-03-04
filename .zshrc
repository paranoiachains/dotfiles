export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""
PROMPT='%n@%m:%~%# '

export PATH="$PATH:/opt/nvim/bin"
export GOPATH=/usr/local/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH="$PATH:/home/keira/.local/bin"

alias c='clear'
alias pc='proxychains'
alias e='exit'

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

xset r rate 200 40
