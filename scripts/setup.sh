#!/usr/bin/env bash
set -euo pipefail

# Determine architecture
ARCH=$(dpkg --print-architecture)

case "$ARCH" in
    amd64)
        RUST_ARCH="x86_64-unknown-linux-gnu"
        LUA_ARCH="x64"
        NVIM_ARCH="linux-x86_64" 
        ;;
    arm64)
        RUST_ARCH="aarch64-unknown-linux-gnu"
        LUA_ARCH="arm64"
        NVIM_ARCH="linux-arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH" >&2
        exit 1
        ;;
esac

#--------------------------------------------------
# Environment Safety
#--------------------------------------------------
export DEBIAN_FRONTEND=noninteractive

if ! command -v apt >/dev/null; then
    echo "This installer requires a Debian/Ubuntu system (apt)." >&2
    exit 1
fi

#--------------------------------------------------
# Resolve Paths 
#--------------------------------------------------
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "Script directory:   $SCRIPT_DIR"
echo "Dotfiles directory: $DOTFILES_DIR"

#--------------------------------------------------
# System Update
#--------------------------------------------------
sudo apt update -y
sudo apt upgrade -y

#--------------------------------------------------
# Package Installation 
#--------------------------------------------------
PACKAGES=(
    curl wget build-essential gnupg lsb-release ca-certificates
    make cmake pkg-config gcc libc6-dev clang lldb lld autoconf automake libtool
    net-tools iproute2 iputils-ping dnsutils traceroute tcpdump socat netcat-openbsd
    python3 python3-pip git xclip fzf ripgrep bat unzip
    tmux alacritty i3 i3status zsh dmenu i3lock xorg xinit suckless-tools
    fonts-dejavu lightdm lightdm-gtk-greeter open-vm-tools-desktop nodejs npm
    clangd
)

PACKAGES+=("linux-headers-$(uname -r)")

sudo apt install -y "${PACKAGES[@]}"

#--------------------------------------------------
# Create Required Directories
#--------------------------------------------------
mkdir -p \
    "$HOME/.config/alacritty" \
    "$HOME/.config/i3status" \
    "$HOME/.local/share/nvim/schemastore" \
    "$HOME/.tmux/plugins"

#--------------------------------------------------
# Apply Dotfiles 
#--------------------------------------------------
if [ -f "$SCRIPT_DIR/pull.sh" ]; then
    echo "Applying dotfiles..."
    bash "$SCRIPT_DIR/pull.sh"
else
    echo "WARNING: pull.sh not found in $DOTFILES_DIR"
fi

#--------------------------------------------------
# Oh My Zsh 
#--------------------------------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

chsh -s "$(command -v zsh)" || true

#--------------------------------------------------
# LightDM Configuration 
#--------------------------------------------------
sudo install -Dm644 /dev/stdin /etc/lightdm/lightdm.conf <<'EOF'
[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=i3
EOF

#--------------------------------------------------
# Neovim 
#--------------------------------------------------
if ! command -v nvim >/dev/null; then
    echo "Installing Neovim..."

    TMP="$(mktemp -d)"
    trap 'rm -rf "$TMP"' EXIT

    curl -fL https://github.com/neovim/neovim/releases/latest/download/nvim-"$NVIM_ARCH".tar.gz \
        -o "$TMP/nvim.tar.gz"

    sudo rm -rf /opt/nvim-"$NVIM_ARCH"
    sudo tar -C /opt -xzf "$TMP/nvim.tar.gz"
    sudo ln -sf /opt/nvim-"$NVIM_ARCH"/bin/nvim /usr/local/bin/nvim
fi

#--------------------------------------------------
# SchemaStore
#--------------------------------------------------
SCHEMA_FILE="$HOME/.local/share/nvim/schemastore/schemas.json"
if [ ! -f "$SCHEMA_FILE" ]; then
    curl -fsSL \
        https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json \
        -o "$SCHEMA_FILE"
fi

#--------------------------------------------------
# Tmux Plugin Manager
#--------------------------------------------------
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if command -v tmux >/dev/null; then
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
fi

#--------------------------------------------------
# Fonts (isolated subshell)
#--------------------------------------------------
FONT_DIR="$HOME/.local/share/fonts/FiraCode"
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
    (
        cd "$FONT_DIR"
        curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
        unzip -o FiraCode.zip
        rm FiraCode.zip
    )
    fc-cache -fv
fi

#--------------------------------------------------
# Zsh Plugins
#--------------------------------------------------
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
mkdir -p "$ZSH_CUSTOM/plugins"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"


#-------------------------------------------------
# Rust
#-------------------------------------------------

if ! command -v rustup > /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

#--------------------------------------------------
# Cleanup
#--------------------------------------------------
sudo apt autoremove -y
sudo apt clean

echo "Installation complete. Log out and back in to start i3."
