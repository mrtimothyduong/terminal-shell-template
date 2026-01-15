# Terminal Shell Bootstrap Template
Standardising terminal for any new Terminal host.

<img width="555" alt="image" src="https://github.com/user-attachments/assets/12dd4986-9925-4a76-9488-0e48c90223ed" />

* 🐚 Uses zsh as default shell
~~* ☕ brew as package manager (macOS + Linux) for standardization~~
* 🔌 Oh-my-zsh for plugins
* 🎨 Oh-my-posh for themes
* 📚 Atuin for Shell history

## Notes
### Compatibility 🤖
- Made for MacOS & AMD64 Linux Hosts. Atuin & Oh-My-Posh should now support ARM64
- Tested on Apple M1/M4 MacOS ARM devices & Ubuntu Server 24.04 on x86/AMD64 & ARM64

### Pre-requisites ✅
- Install Menslo Nerd Fonts to render icons / fonts
- Steps below rely on a Local `Atuin` Server. Skip step 5/6 and comment out or remove atuin section in .zshrc

### Long-term goals 🎯
- Streamline it. Reduce the steps & commands.
- Speed up the load times.

# Installation
1. Install **ZSH**: `sudo apt install zsh-autosuggestions zsh-syntax-highlighting zsh zip`
2. Install **Oh-My-ZSH**: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
3. Install **Atuin**: `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh`
	- **Add Atuin Config Files:** `echo 'eval "$(atuin init zsh)"' >> ~/.zshrc && echo "sync_address = \"https://atuin.{your-atuin-domain}.com\"" >> ~/.config/atuin/config.toml && exec zsh && atuin login -u $(whoami)`
 	- Note: You will need to auth for your atuin user + enter the atuin encryption passkey if you need history from other locations
5. **Configure defaults for ZSH, zsh-autoSuggestions, Syntax highlighting & zsh-autocomplete:**
	- `git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting && git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting && git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete`
6. Install **Oh-My-Posh**: `curl -s https://ohmyposh.dev/install.sh | bash -s`
7. **Download oh-my-posh theme** locally to ~/. `curl -L -o ~/.quick-term.omp.json https://raw.githubusercontent.com/mrtimothyduong/terminal-shell-template/refs/heads/main/.quick-term.omp.json`
8. Update **.zshrc** file: `sudo vi .zshrc` (`ggdG` to select all & delete all) and paste the code below:

```Shell
# OH-MY-ZSH with minimal plugins
export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=30

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
```

9. Finally, initialise via `exec zsh`
