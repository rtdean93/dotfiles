# Dotfiles

My personal dotfiles for Zsh configuration, synced across macOS and Ubuntu machines.

## Features

- Oh My Zsh configuration with agnoster theme
- Username/hostname hidden in prompt for cleaner look
- Git plugin enabled

## Prerequisites

### macOS
```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Ubuntu
```bash
# Install Zsh
sudo apt update
sudo apt install zsh -y

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set Zsh as default shell
chsh -s $(which zsh)
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
```

2. Run the installation script:
```bash
cd ~/dotfiles
./install.sh
```

3. Reload your shell:
```bash
source ~/.zshrc
```

## What Gets Installed

The `install.sh` script will:
- Backup your existing dotfiles to `~/dotfiles_old`
- Create symlinks from your home directory to the dotfiles in `~/dotfiles`

## Updating

To update your dotfiles:

1. Make changes to the files in `~/dotfiles`
2. Commit and push:
```bash
cd ~/dotfiles
git add .
git commit -m "Update dotfiles"
git push
```

3. On other machines, pull the changes:
```bash
cd ~/dotfiles
git pull
source ~/.zshrc
```

## Files Included

- `zshrc` - Zsh configuration with Oh My Zsh and agnoster theme
- `install.sh` - Installation script for setting up symlinks

## Notes

- The agnoster theme requires a Powerline-patched font for best display
- Recommended fonts: Meslo, Source Code Pro, or Fira Code with Nerd Font patches
