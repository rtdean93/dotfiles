#!/bin/bash

# Dotfiles installation script
# This script creates symlinks from the home directory to dotfiles in ~/dotfiles

DOTFILES_DIR="$HOME/dotfiles"
OLD_DOTFILES_BACKUP="$HOME/dotfiles_old"

# List of files to symlink (without the leading dot)
files="zshrc"

echo "Creating dotfiles symlinks..."

# Create backup directory for existing dotfiles
mkdir -p "$OLD_DOTFILES_BACKUP"
echo "Backup directory created at $OLD_DOTFILES_BACKUP"

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || exit

# Move existing dotfiles to backup and create symlinks
for file in $files; do
    if [ -f "$HOME/.$file" ]; then
        echo "Moving existing .$file to $OLD_DOTFILES_BACKUP"
        mv "$HOME/.$file" "$OLD_DOTFILES_BACKUP/"
    fi
    echo "Creating symlink to $file in home directory."
    ln -s "$DOTFILES_DIR/$file" "$HOME/.$file"
done

echo "Done! Dotfiles have been installed."
echo "Run 'source ~/.zshrc' to apply the changes."
