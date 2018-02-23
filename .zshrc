#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export ANDROID_HOME=/usr/local/opt/android-sdk
ulimit -n 2048

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

source "$HOME/.dot-ix/.zsh-prompt"
#zstyle ':prezto:module:prompt' theme 'serby'[ -f ~/.fzf.zsh ]
export PATH="$HOME/.basher/bin:$PATH"
eval "$(basher init -)"
unsetopt correct
export PATH="$HOME/.yarn/bin:./node_modules/.bin:$PATH:/Users/paul/Library/Android/sdk/tools/bin:/Users/paul/Library/Android/sdk/platform-tools/"
alias stree='open -a SourceTree'