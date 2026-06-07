#!/bin/bash
set -euo pipefail

# Resolve the repo's location
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link_file() {
  local source="$1"
  local target="$2"

  ln -sf "$source" "$target"
}

link_dir() {
  local source="$1"
  local target="$2"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Refusing to replace existing non-symlink: $target" >&2
    echo "Move it out of the way, then re-run install.sh." >&2
    exit 1
  fi

  ln -sfn "$source" "$target"
}

# Install Homebrew dependencies from the Brewfile
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES/Brewfile"
else
  echo "Homebrew not found. Install it from https://brew.sh, then re-run." >&2
  exit 1
fi

# Symlink .zshrc into the home dir
link_file "$DOTFILES/.zshrc" "$HOME/.zshrc"

# Symlink the Powerlevel10k prompt config
link_file "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"

# Symlink the Ghostty terminal config
mkdir -p "$HOME/.config/ghostty"
link_file "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

# Symlink the Neovim config
mkdir -p "$HOME/.config"
link_dir "$DOTFILES/nvim" "$HOME/.config/nvim"

echo "Dotfiles installed. Run: source ~/.zshrc"
