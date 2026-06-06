#!/bin/bash
set -euo pipefail

# Resolve the repo's location
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Symlink .zshrc into the home dir
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"

echo "Dotfiles installed. Run: source ~/.zshrc"

