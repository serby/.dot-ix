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

export ANDROID_SDK=$HOME/Library/Android/sdk
export ANDROID_PATH=$ANDROID_SDK/platform-tools:$ANDROID_SDK/tools:$ANDROID_SDK/build-tools
ulimit -n 2048

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# Set the tab name based on current dir.
function tab_title {
  echo -n -e "\033]0;${PWD##*/}\007"
}

# Load required functions.
autoload -Uz add-zsh-hook
add-zsh-hook precmd tab_title

# Random Tab color
echo -e "\033]6;1;bg;red;brightness;$((128 + RANDOM % 255))\a"
echo -e "\033]6;1;bg;green;brightness;$((128 + RANDOM % 255))\a"
echo -e "\033]6;1;bg;blue;brightness;$((128 + RANDOM % 255))\a"

source "$HOME/.dot-ix/.zsh-prompt"
#zstyle ':prezto:module:prompt' theme 'serby'[ -f ~/.fzf.zsh ]
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export PATH="$PATH:$JAVA_HOME/bin:$ANDROID_PATH:/usr/local/heroku/bin:$HOME/.basher/bin:$HOME/.yarn/bin:./node_modules/.bin:/usr/local/opt/mongodb@3.6/bin"
eval "$(basher init -)"

unsetopt correct
alias stree='open -a SourceTree'
alias weather='curl wttr.in'
# tabtab source for yarn package
# uninstall by removing these lines or running `tabtab uninstall yarn`
[[ -f /Users/serby/.config/yarn/global/node_modules/tabtab/.completions/yarn.zsh ]] && . /Users/serby/.config/yarn/global/node_modules/tabtab/.completions/yarn.zsh
