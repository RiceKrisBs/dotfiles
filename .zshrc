export PATH="$HOME/src/git.fullscript.io/kris.bucyk/dotfiles/bin:$PATH"

alias temail='echo -n "kris.bucyk+$(date "+%Y%m%d%H%M")@fullscript.com" | tee /dev/tty | pbcopy'
alias dev-rx='RX_ASSETS_DIR=/Users/kris.bucyk/src/git.fullscript.io/devops/rx/assets /Users/kris.bucyk/src/git.fullscript.io/devops/rx/public/darwin_arm64/rx'
alias ll="ls -laF"

alias cdhw='cd ~/src/git.fullscript.io/developers/hw-admin'
alias cdrx='cd ~/src/git.fullscript.io/devops/rx'
alias cdpharm='cd ~/src/git.fullscript.io/devops/pharmacist'
alias cdnitro='cd ~/src/git.fullscript.io/devops/nitro'
alias cddevops='cd ~/src/git.fullscript.io/devops'
alias whereami='pwd | tr -d "\n" | pbcopy'

ftoc() { echo "scale=1; ($1 - 32) * 5 / 9" | bc; }
ctof() { echo "scale=1; ($1 * 9 / 5) + 32" | bc; }
ktom() { echo "scale=1; $1 / 1.609344" | bc; }
mtok() { echo "scale=1; $1 / 0.621371" | bc; }

kwhere() {
  echo "context:   $(kubectx -c)"
  echo "namespace: $(kubens -c)"
}

# Enable prompt caching for better performance and lower costs
export DISABLE_PROMPT_CACHING=0

