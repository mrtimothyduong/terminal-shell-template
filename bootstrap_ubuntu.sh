#!/bin/bash
# Save as: bootstrap-ubuntu.sh

set -e  # Exit on error
set -o pipefail  # Pipe failures cause script to fail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_section() {
    echo -e "\n${BLUE}===================================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}===================================================${NC}\n"
}

# Trap errors
trap 'print_error "Script failed at line $LINENO"' ERR

print_section "Starting Ubuntu Bootstrap Process"

# 1. Update Ubuntu
print_section "Step 1: Updating Ubuntu Packages"
print_status "Running apt-get update..."
sudo apt-get update
print_status "Running apt-get upgrade..."
sudo apt-get upgrade -y
print_status "Ubuntu packages updated successfully!"

# 2. Install essentials
print_section "Step 2: Installing Essential Packages"
print_status "Installing curl, git, zip, and zsh..."
sudo apt install -y curl git zip zsh
print_status "Essential packages installed successfully!"

# 3. Install Oh-My-Zsh
print_section "Step 3: Installing Oh-My-Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Downloading and installing Oh-My-Zsh..."
    RUNZSH=no CHSH=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    if [ $? -eq 0 ]; then
        print_status "Oh-My-Zsh installed successfully!"
    else
        print_error "Oh-My-Zsh installation failed!"
        exit 1
    fi
else
    print_warning "Oh-My-Zsh already installed, skipping..."
fi

# 4. Install ZSH plugins
print_section "Step 4: Installing ZSH Plugins"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    print_status "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    if [ $? -eq 0 ]; then
        print_status "zsh-autosuggestions installed successfully!"
    else
        print_error "Failed to install zsh-autosuggestions!"
    fi
else
    print_warning "zsh-autosuggestions already installed, skipping..."
fi

# Install fast-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
    print_status "Installing fast-syntax-highlighting..."
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting
    if [ $? -eq 0 ]; then
        print_status "fast-syntax-highlighting installed successfully!"
    else
        print_error "Failed to install fast-syntax-highlighting!"
    fi
else
    print_warning "fast-syntax-highlighting already installed, skipping..."
fi

# 5. Install Atuin
print_section "Step 5: Installing Atuin"
if ! command -v atuin &> /dev/null; then
    print_status "Downloading and installing Atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    if [ $? -eq 0 ]; then
        print_status "Atuin installed successfully!"
        print_status "Creating Atuin configuration..."
        mkdir -p ~/.config/atuin
        echo "sync_address = \"https://atuin.timothyduong.me\"" > ~/.config/atuin/config.toml
        print_status "Atuin configuration created!"
    else
        print_error "Failed to install Atuin!"
        exit 1
    fi
else
    print_warning "Atuin already installed, skipping..."
fi

# 6. Install Oh-My-Posh
print_section "Step 6: Installing Oh-My-Posh"
if ! command -v oh-my-posh &> /dev/null; then
    print_status "Downloading and installing Oh-My-Posh..."
    # Install to ~/.local/bin explicitly
    mkdir -p ~/.local/bin
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
    if [ $? -eq 0 ]; then
        print_status "Oh-My-Posh installed successfully to ~/.local/bin!"
    else
        print_error "Failed to install Oh-My-Posh!"
        exit 1
    fi
else
    print_warning "Oh-My-Posh already installed, skipping..."
fi

# 7. Download theme
print_section "Step 7: Downloading Oh-My-Posh Theme"
print_status "Downloading quick-term.omp.json theme..."
curl -L -o ~/.quick-term.omp.json https://raw.githubusercontent.com/mrtimothyduong/ZSH-Terminal-Bootstrap/refs/heads/main/.quick-term.omp.json
if [ $? -eq 0 ]; then
    print_status "Theme downloaded successfully!"
else
    print_error "Failed to download theme!"
fi

# 8. Setup .zshrc
print_section "Step 8: Configuring .zshrc"
print_status "Creating backup of existing .zshrc..."
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
    print_status "Backup created: ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
fi

print_status "Writing new .zshrc configuration..."
cat > ~/.zshrc << 'EOF'
# OH-MY-ZSH with minimal plugins
export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=30
DISABLE_UPDATE_PROMPT=true

# Add oh-my-posh to PATH
export PATH=$PATH:$HOME/.local/bin

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

# ATUIN - Load immediately on startup (not lazy loaded)
if [[ -f "$HOME/.atuin/bin/env" ]]; then
    . "$HOME/.atuin/bin/env"
    eval "$(atuin init zsh)"
fi

# OH-MY-POSH with local config (not lazy loaded)
if command -v oh-my-posh &> /dev/null && [[ -f ~/.quick-term.omp.json ]]; then
    eval "$(oh-my-posh init zsh --config ~/.quick-term.omp.json)"
else
    # Fallback to simple PS1 if theme or oh-my-posh missing
    PS1='%n@%m:%~$ '
fi

# Add any custom aliases or functions below
EOF

if [ $? -eq 0 ]; then
    print_status ".zshrc configured successfully!"
else
    print_error "Failed to write .zshrc!"
    exit 1
fi

# 9. Change default shell to zsh
print_section "Step 9: Setting ZSH as Default Shell"
CURRENT_SHELL=$(echo $SHELL)
print_status "Current shell: $CURRENT_SHELL"

if [ "$CURRENT_SHELL" != "/usr/bin/zsh" ] && [ "$CURRENT_SHELL" != "/bin/zsh" ]; then
    print_status "Changing default shell to zsh..."
    chsh -s $(which zsh)
    if [ $? -eq 0 ]; then
        print_status "Default shell changed to zsh!"
    else
        print_warning "Failed to change shell automatically. Run manually: chsh -s $(which zsh)"
    fi
else
    print_warning "ZSH is already the default shell"
fi

# 10. Final Summary
print_section "Bootstrap Complete!"

echo -e "${GREEN}Successfully installed:${NC}"
echo "  ✓ ZSH and essential packages"
echo "  ✓ Oh-My-Zsh framework"
echo "  ✓ ZSH plugins (autosuggestions, syntax highlighting)"
echo "  ✓ Atuin (shell history sync)"
echo "  ✓ Oh-My-Posh (prompt theme engine)"
echo "  ✓ Quick-term theme"
echo ""
echo -e "${YELLOW}IMPORTANT - Manual Steps Required:${NC}"
echo "  1. Login to Atuin: ${BLUE}atuin login -u $(whoami)${NC}"
echo "     (Check 1password for the password)"
echo "  2. Restart your terminal or run: ${BLUE}exec zsh${NC}"
echo ""
echo -e "${GREEN}Installation Log:${NC}"
echo "  - Oh-My-Zsh location: ~/.oh-my-zsh"
echo "  - Oh-My-Posh location: ~/.local/bin/oh-my-posh"
echo "  - Theme location: ~/.quick-term.omp.json"
echo "  - Backup of old .zshrc: ~/.zshrc.backup.*"
echo ""

# Test if everything is accessible
print_status "Verifying installations..."
echo -n "  Oh-My-Zsh: "
[ -d "$HOME/.oh-my-zsh" ] && echo "✓" || echo "✗"
echo -n "  Atuin: "
command -v atuin &> /dev/null && echo "✓" || echo "✗"
echo -n "  Oh-My-Posh: "
[ -f "$HOME/.local/bin/oh-my-posh" ] && echo "✓" || echo "✗"
echo -n "  Theme: "
[ -f "$HOME/.quick-term.omp.json" ] && echo "✓" || echo "✗"

print_section "Script Completed Successfully!"
