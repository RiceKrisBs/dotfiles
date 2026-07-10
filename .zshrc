# Enable Powerlevel10k instant prompt. Must stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$HOME/src/git.fullscript.io/kris.bucyk/dotfiles/bin:$PATH"

export EDITOR="nvim"
export VISUAL="$EDITOR"

alias ll="ls -laF"


# gt <name> — jump to a repo under ~/src by its dir name.
# Exact match wins; otherwise substring. Multiple matches open an fzf picker.
gt() {
  local out target
  out="$(gt-bin "$@")" || return 1
  if [[ "$(print -r -- "$out" | wc -l)" -gt 1 ]]; then
    target="$(print -r -- "$out" | fzf --select-1 --exit-0 --height=40% --reverse)" || return 1
  else
    target="$out"
  fi
  [[ -n "$target" ]] && cd "$target"
}

alias whereami='pwd | tr -d "\n" | pbcopy'

alias dev-rx='RX_ASSETS_DIR=/Users/kris.bucyk/src/git.fullscript.io/devops/rx/assets /Users/kris.bucyk/src/git.fullscript.io/devops/rx/public/darwin_arm64/rx'
alias temail='echo -n "kris.bucyk+$(date "+%Y%m%d%H%M")@fullscript.com" | tee /dev/tty | pbcopy'

ftoc() { echo "scale=1; ($1 - 32) * 5 / 9" | bc; }
ctof() { echo "scale=1; ($1 * 9 / 5) + 32" | bc; }
ktom() { echo "scale=1; $1 / 1.609344" | bc; }
mtok() { echo "scale=1; $1 / 0.621371" | bc; }

# Enable prompt caching for better performance and lower costs
export DISABLE_PROMPT_CACHING=0

# Powerlevel10k prompt theme.
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# Powerlevel10k configuration.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# bun completions
[ -s "/Users/kris.bucyk/.bunv/versions/1.3.9/_bun" ] && source "/Users/kris.bucyk/.bunv/versions/1.3.9/_bun"

# Created by `pipx` on 2026-06-29 19:21:22
export PATH="$PATH:/Users/kris.bucyk/.local/bin"
