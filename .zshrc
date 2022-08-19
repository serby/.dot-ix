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
#export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

unsetopt correct
alias weather='curl wttr.in'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
alias crossword='curl -s https://crosswords-static.guim.co.uk/gdn.quick.`date "+%Y%m%d"`.pdf | lpr'
unalias gm
alias notes='code ~/Notes/notes'

# Work
alias bb=brazil-build
alias js='cd ~/Development/JavaScript && ls'
alias ops='cd ~/workplace/PVLRCOperationsView/src/PVLRCOperationsView && ls'
alias lrc='cd ~/workplace/AVLivingRoom/src/AVLivingRoomClient && ls'

imageinfo () {
  gm identify -format "%wx%h %b unique_colors:%k bit_depth:%q - %i\n" $1
}

export PATH=$PATH:$HOME/.dot-ix/bin:$HOME/.yarn/bin:./node_modules/.bin
export PATH=$HOME/.toolbox/bin:$PATH
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"
