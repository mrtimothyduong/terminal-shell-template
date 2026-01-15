#!/bin/bash
# Save as: bootstrap_ubuntu.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Ubuntu Bootstrap...${NC}"

# 1. Update Ubuntu
echo -e "${GREEN}Updating Ubuntu...${NC}"
sudo apt-get update && sudo apt-get upgrade -y

# 2. Install essentials
echo -e "${GREEN}Installing essential packages...${NC}"
sudo apt install -y curl git zip zsh

# 3. Install Oh-My-Zsh (non-interactive)
echo -e "${GREEN}Installing Oh-My-Zsh...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 4. Install ZSH plugins
echo -e "${GREEN}Installing ZSH plugins...${NC}"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ] && \
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting

# 5. Install Atuin
echo -e "${GREEN}Installing Atuin...${NC}"
if ! command -v atuin &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    mkdir -p ~/.config/atuin
    echo "sync_address = \"https://atuin.timothyduong.me\"" > ~/.config/atuin/config.toml
fi

# 6. Install Oh-My-Posh
echo -e "${GREEN}Installing Oh-My-Posh...${NC}"
if ! command -v oh-my-posh &> /dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# 7. Download theme
echo -e "${GREEN}Downloading Oh-My-Posh theme...${NC}"
curl -L -o ~/.quick-term.omp.json https://raw.githubusercontent.com/mrtimothyduong/terminal-shell-template/refs/heads/main/.quick-term.omp.json

# 8. Setup .zshrc
echo -e "${GREEN}Configuring .zshrc...${NC}"
cat > ~/.zshrc << 'EOF'
# OH-MY-ZSH with minimal plugins
export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=30
DISABLE_UPDATE_PROMPT=true

# Reduced plugin set
plugins=(
    git
    zsh-autosuggestions
    fast-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# Compile completion dump for faster loading
if [[ -f "$HOME/.zcompdump" && ! -f "$HOME/.zcompdump.zwc" ]] ||
   [[ "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc" ]]; then
    zcompile "$HOME/.zcompdump"
fi

# Lazy load Atuin (only when needed)
atuin() {
    unfunction "$0"
    . "$HOME/.atuin/bin/env"
    eval "$(atuin init zsh)"
    $0 "$@"
}

# OH-MY-POSH with local config (much faster)
if [[ -f ~/.quick-term.omp.json ]]; then
    eval "$(oh-my-posh init zsh --config ~/.quick-term.omp.json)"
else
    # Fallback to simple PS1 if theme missing
    PS1='%n@%m:%~$ '
fi

# Add any custom aliases or functions below
EOF

# 9. Change default shell to zsh
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo -e "${GREEN}Changing default shell to zsh...${NC}"
    chsh -s $(which zsh)
fi

echo -e "${GREEN}Bootstrap complete!${NC}"
echo -e "${RED}Note: Login to Atuin manually with: atuin login -u \$(whoami)${NC}"
echo -e "${RED}Check 1password for the password${NC}"
echo -e "${GREEN}Please restart your terminal or run: exec zsh${NC}"
