#!/bin/bash
set -euo pipefail

# Resolve the repo's location
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Install Homebrew dependencies from the Brewfile
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES/Brewfile"
else
  echo "Homebrew not found. Install it from https://brew.sh, then re-run." >&2
  exit 1
fi

# Symlink .zshrc into the home dir
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"

# Symlink the Powerlevel10k prompt config
ln -sf "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"

# Symlink the Ghostty terminal config
mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

echo "Dotfiles installed. Run: source ~/.zshrc"

