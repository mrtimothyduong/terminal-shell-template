# terminal-shell-template
Standardising terminal for any new shell host.
* 🐚 Uses zsh as default shell
* ☕ brew as package manager (macOS + Linux) for standardization
* 🔌 Oh-my-zsh for plugins
* 🎨 Oh-my-posh for themes
* 📚 Atuin for Shell History.

## Notes
### Compatibility
- **Made for MacOS or x86 Linux hosts.** Atuin / Oh-My-Posh and some plugins are not compatible with ARM.
- **Tested on:** ARM M1/M4 MacOS & x86 Ubuntu. Had issues with Atuin & Oh-my-zsh with ARM-based Ubuntu. _Not tested with WSL/PWSH._
- **MacOS Terminal app**: Oh-my-Posh Themes only work with non-Terminal.app apps. E.g. iTerm2

### Pre-Requisites
- Install Menslo Nerd Fonts to render icons / fonts
- Steps below rely on a Local Atuin Server. Skip step 5/6 and comment out or remove atuin section in .zshrc

### Long-term goals:
- Streamline it. Reduce the steps & commands.

# Install
1. Connect into Host Terminal / CLI Session (E.g. Localhost or SSH into Remote Host)
2. Install **Homebrew** `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. Install **zsh** `sudo apt install zsh` or `brew install zsh`
4. Install **oh-my-zsh** `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
5. Install **Atuin** `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh`
6. Add **Atuin** Sync Address to a new file:`echo "sync_address = \"https://change-to-your-atuin-fqdn\"" >> ~/.config/atuin/config.toml`
7. Install **oh-my-zsh plugins**:
  - `git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions`
  - `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting`
  - `git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting`
  - `git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete`
12. Install **oh-my-posh**: `brew install oh-my-posh`
13. Update your ~\.zshrc file (Replace all content):

```SHELL
# PLUGINS
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

# OH-MY-ZSH
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# ATUIN - Terminal History & Sync
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# HOMEBREW - Add for Linux / Comment out for MacOS
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# OH-MY-POSH & Custom QUICKTERM Theme
eval "$(oh-my-posh init zsh --config "https://raw.githubusercontent.com/mrtimothyduong/terminal-shell-template/refs/heads/main/quick-term.omp.json")"
```

14. `exec zsh`
15. Log into **Atuin** `atuin login -u username` and use password + keys saved when you originally set-up Atuin

## Usage
1. Re-launch terminal or run `exec zsh` or `source ~/.zshrc`
2. Press up for **Atuin** and shell history
3. Start typing for zsh-suggestions / zsh-autocomplete
4. Test out change-directory using `cd`

