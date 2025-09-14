# terminal-shell-template
Standardising terminal for any new shell host.

<img width="555" alt="image" src="https://github.com/user-attachments/assets/12dd4986-9925-4a76-9488-0e48c90223ed" />

* 🐚 Uses zsh as default shell
* ☕ brew as package manager (macOS + Linux) for standardization
* 🔌 Oh-my-zsh for plugins
* 🎨 Oh-my-posh for themes
* 📚 Atuin for Shell History.

## Notes
### Compatibility 🤖
- **Made for MacOS or x86 Linux hosts.** Atuin / Oh-My-Posh and some plugins are not compatible with ARM.
- **Tested on:** ARM M1/M4 MacOS & x86 Ubuntu. Had issues with Atuin & Oh-my-zsh with ARM-based Ubuntu. _Not tested with WSL/PWSH._
- **MacOS Terminal app**: Oh-my-Posh Themes only work with non-Terminal.app apps. E.g. iTerm2

### Pre-requisites ✅
- Install Menslo Nerd Fonts to render icons / fonts
- Steps below rely on a Local Atuin Server. Skip step 5/6 and comment out or remove atuin section in .zshrc

### Long-term goals 🎯
- Streamline it. Reduce the steps & commands.

# Install
1. SSH into Ubuntu e.g. `ssh user@linux`
2. update `sudo apt-get update && sudo apt-get upgrade`
3. Install **Homebrew**:
	- `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
	- Then install core-tools: `sudo apt-get install build-essential procps curl file git`
	- Run the following to enable brew via bash-shell

```bash
### Append .bashrc for brew commands
echo >> ~/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```
4. Then install **GCC**: `exec bash && brew install gcc`
5. Install **zsh**: `sudo apt install zsh-autosuggestions zsh-syntax-highlighting zsh`
6. Install **oh-my-zsh**: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
7. Install **Atuin**
	- `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh`
		- `echo 'eval "$(atuin init zsh)"' >> ~/.zshrc && echo "sync_address = \"https://atuin.domainname.com\"" >> ~/.config/atuin/config.toml`
		- `exec zsh`
		- `atuin login -u {ATUINUSERNAME}` & auth with Atuin password + encryption key
8. Configure *ZSH, zsh-autoSuggestions, Syntax highlighting & zsh-autocomplete*:
	- `git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting && git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting && git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete`
9. Install **Oh-My-Posh**: `brew install oh-my-posh`
10. Update **.zshrc** file: `sudo vi .zshrc` (`ggdG` to select all & delete all) and paste the code below

### .zshrc file
```zsh
# PLUGINS
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

# OH-MY-ZSH
export ZSH="$HOME/.oh-my-zsh"
UPDATE_ZSH_DAYS=30
source $ZSH/oh-my-zsh.sh

# ATUIN - Terminal History & Sync
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# HOMEBREW
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# OH-MY-POSH & QUICKTERM Theme
eval "$(oh-my-posh init zsh --config "https://raw.githubusercontent.com/mrtimothyduong/terminal-shell-template/refs/heads/main/quick-term.omp.json")"
```

11. Initialise via `exec zsh`

## Usage
1. Re-launch terminal or run `exec zsh` or `source ~/.zshrc`
2. Press up for **Atuin** and shell history
3. Start typing for zsh-suggestions / zsh-autocomplete
4. Test out change-directory using `cd`
