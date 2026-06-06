# dotfiles

Personal shell config and scripts.

## Install (new machine)

Clone to the expected location, then run the bootstrap:

```bash
git clone https://git.fullscript.io/kris.bucyk/dotfiles.git ~/src/git.fullscript.io/kris.bucyk/dotfiles
~/src/git.fullscript.io/kris.bucyk/dotfiles/install.sh
exec zsh
```

`install.sh` symlinks `.zshrc` into `$HOME`. The repo's `bin/` is added to PATH by `.zshrc`, so scripts within `bin/` are runnable by name.

## Notes

- Scripts in `bin/` assume the executable bit have been committed
- `.zshrc` assumes the repo lives at `~/src/git.fullscript.io/kris.bucyk/dotfiles`
