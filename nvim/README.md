# Kris Neovim Setup

I've made this config powered by `lazy.nvim`, not LazyVim. The current goal is to keep the setup small enough to understand while still having the daily-driver pieces: fuzzy finding, file browsing, LSP, completion, formatting, Git, comfortable terminal.

## Language Stack

The config is tuned for Ruby, Go, TypeScript/JavaScript, Python, Terraform/HCL, Shell/Bash, Lua, YAML, JSON, Markdown, Dockerfile/Docker Compose, Helm, Ansible, SQL, and TOML.

For Ruby, Ruby LSP is the primary server. Sorbet is also enabled, but only in repos with `sorbet/config`, and its non-diagnostic capabilities are disabled so Ruby LSP owns formatting, navigation, completion, and general Ruby behavior.

## First Moves

- `Space` is the leader key.
- `-` opens the parent directory with Oil.
- `<C-p>` finds Git-tracked files.
- `<leader>ff` finds files.
- `<leader>fg` searches project text.
- `gd`, `gr`, `K`, `<leader>rn`, and `<leader>ca` are the core LSP motions/actions.
- `<C-w> h/j/k/l` moves between Neovim windows.
- `<leader>tc` opens Claude CLI in a vertical terminal.
- In terminal mode, press `<Esc><Esc>` to return to normal mode.

## Useful Commands

- `:Lazy` manages plugins.
- `:Mason` manages language servers.
- `:MasonToolsInstall` installs configured Mason-managed formatters and tools.
- `:checkhealth` diagnoses the environment.
- `:ConformInfo` shows formatter status.
- `:LspInfo` shows active language servers.
- `:FormatDisable` disables format-on-save globally.
- `:FormatDisable!` disables format-on-save for the current buffer.
- `:FormatEnable` turns format-on-save back on.

## New Machine Setup

This config has three install layers:

- Homebrew installs system tools like `nvim`, `ripgrep`, `tree-sitter-cli`, and `ruff`.
- Lazy installs Neovim plugins from `lazy-lock.json`.
- Mason installs editor-managed language servers, formatters, and linters.

On a new machine:

```sh
git clone https://git.fullscript.io/kris.bucyk/dotfiles.git ~/src/git.fullscript.io/kris.bucyk/dotfiles
~/src/git.fullscript.io/kris.bucyk/dotfiles/install.sh
exec zsh
```

Then open Neovim:

```sh
nvim .
```

Lazy should bootstrap itself. Once Neovim opens, run:

```vim
:Lazy restore
:MasonToolsInstall
```

Then restart Neovim and check:

```vim
:Lazy
:Mason
:LspInfo
:ConformInfo
:checkhealth
```

Some tools are intentionally not Mason-managed because they are system- or project-sensitive:

- `ruff` is installed by Homebrew.
- `gopls` should come from your Go/project tooling.
- `ruby-lsp` and `sorbet` should come from Ruby/Bundler/project tooling.

## Periodic Maintenance

Use this when you intentionally want to update the setup.

Update Homebrew tools:

```sh
cd ~/src/git.fullscript.io/kris.bucyk/dotfiles
brew bundle --file=Brewfile
brew upgrade
```

Update Neovim plugins:

```vim
:Lazy sync
```

This may update `lazy-lock.json`. Review and commit that file when the updated plugins work.

Update Mason-managed tools:

```vim
:MasonToolsUpdate
```

Useful checks after upgrades:

```vim
:checkhealth
:LspInfo
:ConformInfo
```

If something breaks after a plugin update, `lazy-lock.json` is the recovery point. Pull the last known-good dotfiles commit and run:

```vim
:Lazy restore
```
