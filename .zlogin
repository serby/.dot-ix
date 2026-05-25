#
# Executes commands at login post-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

(( ${+functions[_zsh_profile_mark]} )) && _zsh_profile_mark zlogin:start

# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Print a random, hopefully interesting, adage.
if (( $+commands[fortune] )); then
  if [[ -t 0 || -t 1 ]]; then
    fortune -s
    print
  fi
fi

if (( ${+functions[_zsh_profile_mark]} )); then
  _zsh_profile_mark zlogin:end
  _zsh_profile_report
  [[ "$ZSH_PROFILE" == zprof ]] && zprof
fi
